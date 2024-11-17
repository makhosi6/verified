import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hand_signature/signature.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/domain/models/permit_type.dart';
import 'package:verified/domain/models/permit_upload_data.dart';
import 'package:verified/globals.dart';
import 'package:verified/helpers/image.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/infrastructure/analytics/repository.dart';
import 'package:verified/presentation/pages/home_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/error_warning_indicator.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/utils/select_media.dart';
import 'package:verified/presentation/utils/trigger_auth_bottom_sheet.dart';
import 'package:verified/presentation/utils/verification_done_bottom_sheet.dart';
import 'package:verified/presentation/utils/verified_input_formatter.dart';
import 'package:verified/presentation/utils/widget_generator_options.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/inputs/generic_input.dart';
import 'package:verified/presentation/widgets/popups/default_popup.dart';
import 'package:syncfusion_flutter_signaturepad/signaturepad.dart';

class PermitFormPage extends StatelessWidget {
  PermitFormPage({super.key});

  ///
  final globalKeyPermitFormPageForm = GlobalKey<FormState>(debugLabel: 'permit-form-page-key');

  ///
  final GlobalKey<SfSignaturePadState> signatureGlobalKey =
      GlobalKey<SfSignaturePadState>(debugLabel: 'permit-form-page-key');

  ///
  String? signatureError;

  ///
  PermitType? selectedPermitType;
  var signaturePath = '';
  var permitNumber = '';
  var descriptionNotes = '';
  var permitTypeStr = '';

  ///
  List<MultipartFile> selectedMedia = [];
  PermitVisaUploadBean permitVisaUpload = PermitVisaUploadBean(date: DateFormat('dd/MM/yyyy').format(DateTime.now()));

  ///
  @override
  Widget build(BuildContext context) {
    ///
    final candidate = context.read<StoreBloc>().state.candidate;

    ///
    void onSignatureEnd() async {
      final path = signatureGlobalKey.currentState?.toPathList();
      var signatureError = validateSignature(path);

      if (signatureError is String) {
        signatureError = signatureError;
        return;
      }

      final data = await signatureGlobalKey.currentState?.toImage(pixelRatio: 3.0);
      final bytes = await data?.toByteData(format: ImageByteFormat.png);
      if (bytes != null) {
        // permitVisaUpload.copyWith(signature: bytesToDataUrl(bytes.buffer.asUint8List(), ImageByteFormat.png.name));
        signaturePath = bytesToDataUrl(bytes.buffer.asUint8List(), ImageByteFormat.png.name);
      }
    }

    return WillPopScope(
      onWillPop: () async {
        bool canCancel = await showDefaultPopUp(
          context,
          title: 'Are You Sure You Want to Cancel?',
          subtitle:
              "It looks like you're about to leave the account creation process. If you wish to cancel, press yes",
          confirmBtnText: 'Yes',
          declineBtnText: 'No',
          onConfirm: () => Navigator.pop(context, true),
          onDecline: () => Navigator.pop(context, false),
        );
        return canCancel;
      },
      child: Scaffold(
        body: Center(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const AppErrorWarningIndicator(),
              SliverAppBar(
                stretch: true,
                centerTitle: false,
                onStretchTrigger: () async {},
                surfaceTintColor: Colors.transparent,
                stretchTriggerOffset: 300.0,
                expandedHeight: 90.0,
                flexibleSpace: AppBar(
                  centerTitle: true,
                  automaticallyImplyLeading: true,
                  title: const Text('Permit/Visa Upload'),
                ),
                leadingWidth: 80.0,
                leading: VerifiedBackButton(
                  isLight: true,
                  onTap: Navigator.of(context).pop,
                ),
                actions: const [],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => UnconstrainedBox(
                    key: ValueKey(index),
                    child: Container(
                      width: MediaQuery.of(context).size.width - primaryPadding.horizontal,
                      constraints: appConstraints,
                      padding: EdgeInsets.only(bottom: primaryPadding.bottom * 3, top: primaryPadding.top * 3),
                      child: Form(
                        key: globalKeyPermitFormPageForm,
                        child: Column(
                          key: const Key('captured-details-field-inputs'),
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width - primaryPadding.horizontal * 2,
                              padding: EdgeInsets.symmetric(horizontal: primaryPadding.horizontal),
                              child: Text(
                                'Please upload your permit and fill in the necessary details to complete your submission.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: neutralDarkGrey,
                                  fontSize: 14.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 40,
                              width: 40,
                            ),

                            ///
                            ...[
                              CaptureUserDetailsInputOption(
                                hintText: 'Enter the number printed on your permit.',
                                initialValue: null,
                                label:  '${selectedPermitType?.value ?? 'Permit'} Number',
                                autofocus: false,
                                maxLines: 1,
                                inputFormatters: [],
                                keyboardType: TextInputType.text,
                                validator: (_) => null,
                                onChangeHandler: (value) {
                                  // VerifiedAppAnalytics.logActionTaken(
                                  //     VerifiedAppAnalytics.ACTION_CANDIDATE_DID_UPDATE_DETAILS, {'value_name': 'notes'});
                                  permitNumber = value;
                                  // permitVisaUpload.copyWith(permitNumber: value);
                                },
                              ),
                              CaptureUserDetailsInputOption(
                                hintText: 'Additional information',
                                initialValue: null,
                                label: 'Notes/Description (Optional)',
                                autofocus: false,
                                maxLines: 10,
                                inputFormatters: [],
                                keyboardType: TextInputType.text,
                                validator: (_) => null,
                                onChangeHandler: (notes) {
                                  descriptionNotes = notes;
                                  // permitVisaUpload.copyWith(additionalInformation: notes);
                                },
                              ),
                            ].map(
                              (inputOption) => Padding(
                                padding: EdgeInsets.symmetric(vertical: primaryPadding.vertical),
                                child: GenericInputField(
                                  key: ValueKey(inputOption.hashCode),
                                  initialValue: inputOption.initialValue,
                                  hintText: inputOption.hintText,
                                  label: inputOption.label,
                                  readOnly: false,
                                  maxLines: inputOption.maxLines,
                                  autofocus: inputOption.autofocus,
                                  keyboardType: inputOption.keyboardType,
                                  inputFormatters: [
                                    ///
                                    if (inputOption.keyboardType == TextInputType.number)
                                      FilteringTextInputFormatter.digitsOnly,

                                    ///
                                    if (inputOption.maxLength != null)
                                      LengthLimitingTextInputFormatter(inputOption.maxLength),

                                    ///
                                    if (inputOption.inputMask != null)
                                      VerifiedTextInputFormatter(mask: inputOption.inputMask),

                                    ///
                                    ...(inputOption.inputFormatters ?? [])
                                  ],
                                  validator: inputOption.validator,
                                  onChange: inputOption.onChangeHandler,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: primaryPadding.vertical),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Type of Permit/Visa',
                                    style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14.0,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 10.0),
                                    child: InputDecorator(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(16.0),
                                        ),
                                        enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 2,
                                            color: primaryColor,
                                          ),
                                        ),
                                        focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(width: 2, color: primaryColor),
                                        ),
                                        errorBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                            width: 2,
                                            color: errorColor,
                                          ),
                                        ),
                                      ),
                                      child: StatefulBuilder(builder: (context, setState) {
                                        return DropdownButtonHideUnderline(
                                          child: DropdownButton<PermitType>(
                                            value: selectedPermitType,
                                            hint: Text(
                                              'Select your permit/visa type',
                                              style: TextStyle(color: Colors.grey[400]),
                                            ),
                                            isExpanded: true,
                                            isDense: true,
                                            items: PermitType.values
                                                .map((permitType) => DropdownMenuItem<PermitType>(
                                                      value: permitType,
                                                      child: Text(permitType.value),
                                                    ))
                                                .toList(),
                                            onChanged: (permitType) {
                                              permitVisaUpload.copyWith(permitType: permitType?.name);
                                              setState(() {
                                                selectedPermitType = permitType;
                                              });
                                              permitTypeStr = '${permitType?.name}';
                                            },
                                          ),
                                        );
                                      }),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            StatefulBuilder(builder: (context, setState) {
                              return Center(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: primaryPadding.vertical),
                                  child: BaseButton(
                                    key: UniqueKey(),
                                    onTap: () {
                                      try {
                                        ///
                                        FilePicker.platform
                                            .pickFiles(
                                                // dialogTitle: 'Select your permit/visa doc',
                                                // allowMultiple: true,
                                                // type: FileType.custom,
                                                // allowedExtensions: ['pdf', 'doc', 'jpg', 'png'],
                                                )
                                            .then((data) async {
                                          verifiedLogger('DOC/FILE/PDF: ${data?.files.length}');

                                          ///
                                          return await Future.wait(
                                            (data?.files ?? [])
                                                .map((doc) async => await convertToFormData(File(doc.xFile.path))),
                                          );
                                        }).then((media) {
                                          ///
                                          if (media.isEmpty) return;

                                          ///
                                          setState(() {
                                            selectedMedia =
                                                media.where((i) => i != null).cast<MultipartFile>().toList();
                                          });

                                          if (selectedMedia.isNotEmpty) {
                                            context.read<StoreBloc>().add(StoreEvent.permitDocsUpload(selectedMedia));
                                          } else {
                                            verifiedErrorLogger(
                                                Exception('Media upload is empty...'), StackTrace.current);
                                          }
                                        }).catchError((error) {
                                          verifiedErrorLogger(error, StackTrace.current);
                                        }, test: (_) {
                                          return true;
                                        });

                                        ///
                                      } catch (error, stackTrace) {
                                        verifiedErrorLogger(error, stackTrace);
                                      }
                                    },
                                    label:
                                        'Upload permit/visa ${selectedMedia.isNotEmpty ? '(${selectedMedia.length})' : ''}',
                                    color: Colors.black87,
                                    buttonIcon: const Image(
                                      image: AssetImage('assets/icons/add-file.png'),
                                    ),
                                    buttonSize: ButtonSize.large,
                                    hasBorderLining: true,
                                    borderColor: litePrimaryColor,
                                  ),
                                ),
                              );
                            }),
                            SizedBox(
                              // width: MediaQuery.of(context).size.width - 100,
                              // padding: EdgeInsets.symmetric(vertical: primaryPadding.vertical),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.only(bottom: 8),
                                    child: Text(
                                      'Signature',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15.0,
                                      ),
                                    ),
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: neutralGrey.withOpacity(0.5),
                                      border: Border(
                                        bottom: BorderSide(
                                          width: 2,
                                          color: primaryColor,
                                        ),
                                      ),
                                    ),
                                    child: SfSignaturePad(
                                      key: signatureGlobalKey,
                                      strokeColor: Colors.black,
                                      minimumStrokeWidth: 1.0,
                                      maximumStrokeWidth: 4.0,
                                      onDrawEnd: onSignatureEnd,
                                      onDraw: (offset, time) {
                                        // if (mounted) {
                                        //   setState(() {
                                        signatureError = null;
                                        //   });
                                        // }
                                      },
                                    ),
                                  ),
                                  if (signatureError is String)
                                    Padding(
                                      padding: const EdgeInsets.symmetric(vertical: 8),
                                      child: Text(
                                        '$signatureError',
                                        style: TextStyle(color: errorColor),
                                      ),
                                    ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const SizedBox.shrink(),
                                        // BaseButton(
                                        //   buttonIcon: const Icon(Icons.check),
                                        //   hasIcon: true,
                                        //   buttonSize: ButtonSize.small,
                                        //   label: 'Okay',
                                        //   hasBorderLining: true,
                                        //   onTap: () => _handleSaveButtonPressed(),
                                        // ),
                                        BaseButton(
                                          buttonIcon: Icon(Icons.backspace_rounded, color: errorColor),
                                          borderColor: Colors.red[100],
                                          hasIcon: true,
                                          buttonSize: ButtonSize.small,
                                          label: '',
                                          hasBorderLining: true,
                                          onTap: () {
                                            signatureGlobalKey.currentState?.clear();
                                          },
                                          bgColor: Colors.white,
                                        ).iconOnly(context),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Text('${permitVisaUpload.toJson()}'),

                            ///
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: BaseButton(
                                key: UniqueKey(),
                                onTap: () {
                                  verifiedLogger("SELECT_MEDIA_TYPE $selectedPermitType");
                                  verifiedLogger("SELECTED MEDIA  $selectedMedia");
                                  final jobUuid =
                                      (ModalRoute.of(context)?.settings.arguments as Map)['jobUuid'] as String?;

                                  ///
                                  context.read<StoreBloc>().add(
                                        StoreEvent.permitUploadDataEvnt(
                                          permitVisaUpload.copyWith(
                                            jobUuid:
                                                context.read<StoreBloc>().state.capturedCandidateDetails?.jobUuid ??
                                                    jobUuid,
                                            permitNumber: permitNumber,
                                            permitType: permitTypeStr,
                                            signature: signaturePath,
                                            additionalInformation: descriptionNotes,
                                            relatedDocuments: context.read<StoreBloc>().state.permitsUploadsData,
                                          ),
                                        ),
                                      );

                                  ///
                                  VerifiedAppAnalytics.logActionTaken(
                                      VerifiedAppAnalytics.ACTION_CANDIDATE_DID_UPDATE_DETAILS,
                                      {'type': selectedPermitType?.name});

                                  ///
                                  Future.delayed(
                                      const Duration(milliseconds: 500),
                                      () => context
                                          .read<StoreBloc>()
                                          .add(const StoreEvent.makePassportVerificationRequest()));

                                  verificationDoneBottomSheet(
                                    context,
                                    title: 'Congratulations! Verification Complete',
                                    msg:
                                        'Would you like to set up your account (as ${candidate?.phoneNumber ?? candidate?.phoneNumber ?? candidate?.email ?? 'Candidate'}) to track your verification process?',
                                    color: Colors.white,
                                    lottieBuilder: Lottie.asset(
                                      'assets/lottie/confetti.json',
                                      fit: BoxFit.contain,
                                    ),
                                    actions: [
                                      Padding(
                                        padding: EdgeInsets.only(top: primaryPadding.top),
                                        child: BaseButton(
                                          key: UniqueKey(),
                                          onTap: () {
                                            VerifiedAppAnalytics.logActionTaken(
                                                VerifiedAppAnalytics.ACTION_CANDIDATE_COMPLETED_VERIFICATION);
                                            VerifiedAppAnalytics.logActionTaken(
                                                VerifiedAppAnalytics.ACTION_NO_ACCOUNT_CREATED);

                                            ///
                                            navigate(
                                              context,
                                              page: const HomePage(),
                                              replaceCurrentPage: true,
                                            );
                                          },
                                          buttonIcon: const Icon(
                                            Icons.close_rounded,
                                          ),
                                          hasIcon: true,
                                          buttonSize: ButtonSize.large,
                                          label: 'No, Thanks',
                                          hasBorderLining: true,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(top: primaryPadding.top),
                                        child: BaseButton(
                                          key: UniqueKey(),
                                          onTap: () {
                                            VerifiedAppAnalytics.logActionTaken(
                                                VerifiedAppAnalytics.ACTION_CANDIDATE_COMPLETED_VERIFICATION);
                                            VerifiedAppAnalytics.logActionTaken(
                                                VerifiedAppAnalytics.ACTION_ACCOUNT_CREATED);

                                            ///
                                            triggerAuthBottomSheet(context: context, redirect: const HomePage());
                                          },
                                          buttonIcon: const Icon(
                                            Icons.check_rounded,
                                            color: Colors.white,
                                          ),
                                          iconBgColor: primaryColor.withOpacity(0.5),
                                          borderColor: litePrimaryColor,
                                          bgColor: primaryColor,
                                          hasIcon: true,
                                          buttonSize: ButtonSize.large,
                                          color: Colors.white,
                                          label: 'Okay',
                                          hasBorderLining: false,
                                        ),
                                      ),
                                    ],
                                  );
                                },
                                label: 'Next',
                                color: neutralGrey,
                                hasIcon: false,
                                bgColor: primaryColor,
                                buttonIcon: Icon(
                                  Icons.lock_outline,
                                  color: primaryColor,
                                ),
                                buttonSize: ButtonSize.large,
                                hasBorderLining: false,
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  childCount: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final control = HandSignatureControl(
  threshold: 0.01,
  smoothRatio: 0.65,
  velocityRange: 2.0,
);

ValueNotifier<String?> svg = ValueNotifier<String?>(null);

ValueNotifier<ByteData?> rawImage = ValueNotifier<ByteData?>(null);

ValueNotifier<ByteData?> rawImageFit = ValueNotifier<ByteData?>(null);

String? validateStrokeCount(List<Path> pathData, {int minStrokes = 1}) {
  if (pathData.length < minStrokes) {
    return 'Not enough strokes: Minimum required is $minStrokes.';
  }
  return null;
}

String? validateSignatureArea(List<Path> pathData, {double minWidth = 50, double minHeight = 20}) {
  double xMin = double.infinity, xMax = -double.infinity;
  double yMin = double.infinity, yMax = -double.infinity;

  for (var path in pathData) {
    final Rect bounds = path.getBounds();

    xMin = bounds.left < xMin ? bounds.left : xMin;
    xMax = bounds.right > xMax ? bounds.right : xMax;
    yMin = bounds.top < yMin ? bounds.top : yMin;
    yMax = bounds.bottom > yMax ? bounds.bottom : yMax;
  }

  double width = xMax - xMin;
  double height = yMax - yMin;

  if (width < minWidth || height < minHeight) {
    return 'Signature area is too small: Minimum width is $minWidth and height is $minHeight.';
  }
  return null;
}

String? validateSignatureCompleteness(List<Path> pathData) {
  if (pathData.isEmpty) {
    return 'Signature is incomplete: No path data found.';
  }
  return null;
}

String? validateSignature(List<Path>? pathData) {
  String? error;
  if (pathData == null || pathData.isEmpty) {
    return 'Signature is incomplete: No path data found.';
  }

  error = validateStrokeCount(pathData);
  if (error != null) return error;

  error = validateSignatureArea(pathData);
  if (error != null) return error;

  error = validateSignatureCompleteness(pathData);
  return error;
}
