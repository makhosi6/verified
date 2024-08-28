import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/domain/models/verifee_request.dart';
import 'package:verified/globals.dart';
import 'package:verified/helpers/data/countries.dart';
import 'package:verified/presentation/pages/home_page.dart';
import 'package:verified/presentation/pages/learn_more_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/document_type.dart';
import 'package:verified/presentation/utils/learn_more_highlighted_btn.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/utils/validate_inputs.dart';
import 'package:verified/presentation/utils/verified_input_formatter.dart';
import 'package:verified/presentation/utils/widget_generator_options.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/inputs/generic_input.dart';
import 'package:verified/presentation/widgets/popups/successful_action_popup.dart';

class CaptureVerifieeDetailsPage extends StatefulWidget {
  CaptureVerifieeDetailsPage({super.key});

  @override
  State<CaptureVerifieeDetailsPage> createState() => _CaptureVerifieeDetailsPageState();
}

class _CaptureVerifieeDetailsPageState extends State<CaptureVerifieeDetailsPage> {
  ///
  final _globalKeyCaptureVerifieeDetailsPageForm =
      GlobalKey<FormState>(debugLabel: 'capture-verifiee-details-page-key');

  ///
  var keyboardType = TextInputType.number;

  ///
  var verifiee = VerifeeRequest(jobUuid: '');

  ///
  @override
  void dispose() {
    FocusManager.instance.primaryFocus?.unfocus();
    _globalKeyCaptureVerifieeDetailsPageForm.currentState?.dispose();
    super.dispose();
  }

  ///
  @override
  Widget build(BuildContext context) {
    final documentType = (ModalRoute.of(context)?.settings.arguments as Map)['docType'] as DocumentType?;
    final jobUuid = (ModalRoute.of(context)?.settings.arguments as Map)['jobUuid'] as String?;
    return BlocListener<StoreBloc, StoreState>(
      bloc: context.read<StoreBloc>(),
      listener: (context, state) {},
      child: Builder(
        builder: (context) {
          //
          // if (context.watch<StoreBloc>().state.decodePassportDataLoading ||
          //     (context.watch<StoreBloc>().state.capturedVerifeeDetails == null &&
          //         context.watch<StoreBloc>().state.decodePassportData == null)) {
          //   return const CustomSplashScreen();
          // }
          //
          final capturedVerifeeDetails = context.watch<StoreBloc>().state.capturedVerifeeDetails;
          return WillPopScope(
            onWillPop: () async {
              navigate(context, page: const HomePage(), replaceCurrentPage: true);
              return false;
            },
            child: Scaffold(
              key: const Key('capture-verifiee-details-page'),
              body: Center(
                child: CustomScrollView(
                  physics: const BouncingScrollPhysics(),
                  slivers: [
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
                        title: const Text('Get Verified'),
                      ),
                      leadingWidth: 80.0,
                      leading: VerifiedBackButton(
                        key: const Key('capture-verifiee-details-page-back-btn'),
                        onTap: () => navigate(context, page: const HomePage(), replaceCurrentPage: true),
                        isLight: true,
                      ),
                    ),
                    SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) => UnconstrainedBox(
                          child: Container(
                            width: MediaQuery.of(context).size.width - primaryPadding.horizontal,
                            constraints: appConstraints,
                            padding: EdgeInsets.only(bottom: primaryPadding.bottom * 3, top: primaryPadding.top * 3),
                            child: Form(
                              key: _globalKeyCaptureVerifieeDetailsPageForm,
                              child: Column(
                                key: const Key('capture-verifiee-details-field-inputs'),
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(horizontal: primaryPadding.horizontal),
                                    child: Text(
                                      capturedVerifeeDetails?.toString() ??
                                          'Instantly confirm the legitimacy of personal information with our user-friendly app.',
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
                                    // CaptureUserDetailsInputOption(
                                    //   label: 'Name or Nickname',
                                    //   hintText: 'Type your name...',
                                    //   initialValue: capturedVerifeeDetails?.names == null
                                    //       ? null
                                    //       : '${capturedVerifeeDetails?.names ?? ''}  ${capturedVerifeeDetails?.surname ?? ''}',
                                    //   autofocus: false,
                                    //   inputFormatters: [],
                                    //   keyboardType: TextInputType.text,
                                    //   validator: (name) {
                                    //     if (name == null || name.isEmpty == true) {
                                    //       return 'Please provide a name/surname/nickname';
                                    //     }
                                    //     if (name.length < 2) {
                                    //       return 'Name must be at least 2 characters long';
                                    //     }
                                    //     return null;
                                    //   },
                                    //   onChangeHandler: (name) {
                                    //     verifiee = verifiee.copyWith(preferredName: name);
                                    //   },
                                    // ),
                                    CaptureUserDetailsInputOption(
                                      hintText: 'Type their ID Number(Document Number)',
                                      initialValue: capturedVerifeeDetails?.identityNumber ??
                                          capturedVerifeeDetails?.passportNumber,
                                      label:
                                          'Govt-issued ${documentType?.name == 'passport' ? 'Passport' : 'ID'} Number (optional)',
                                      inputMask: '000000 0000 000',
                                      autofocus: false,
                                      maxLength: 13,
                                      inputFormatters: [],
                                      keyboardType: TextInputType.number,
                                      validator: (idNumber) {
                                        if (verifiee.phoneNumber != null && idNumber?.isEmpty == true) {
                                          return null;
                                        }
                                        if (idNumber == null || idNumber.isEmpty) {
                                          return 'You have to provide a phone number or a ID number';
                                        }

                                        if (capturedVerifeeDetails?.documentType == DocumentType.passport.name) {
                                          return null;
                                        }
                                        return validateIdNumber(idNumber);
                                      },
                                      onChangeHandler: (idNumber) {
                                        verifiee = verifiee.copyWith(idNumber: idNumber);

                                        /// and validate the form
                                        _globalKeyCaptureVerifieeDetailsPageForm.currentState?.validate();
                                      },
                                    ),
                                    CaptureUserDetailsInputOption(
                                      hintText: '000 000 0000',
                                      initialValue: null,
                                      label: 'Phone Number',
                                      inputMask: '000 000 0000',
                                      maxLength: 10,
                                      autofocus: false,
                                      inputFormatters: [],
                                      keyboardType: TextInputType.number,
                                      validator: (phone) {
                                        var id = verifiee.idNumber ??
                                            capturedVerifeeDetails?.identityNumber ??
                                            capturedVerifeeDetails?.identityNumber2 ??
                                            capturedVerifeeDetails?.cardNumber;
                                        if (id != null && phone?.isEmpty == true) {
                                          return null;
                                        }
                                        if (phone == null || phone.isEmpty) {
                                          return 'You have to provide a phone number or a ID number';
                                        }
                                        return validateMobile(phone);
                                      },
                                      onChangeHandler: (phoneNumber) {
                                        verifiee = verifiee.copyWith(phoneNumber: phoneNumber);

                                        /// and validate the form
                                        _globalKeyCaptureVerifieeDetailsPageForm.currentState?.validate();
                                      },
                                    ),
                                    CaptureUserDetailsInputOption(
                                      hintText: 'Type their email address',
                                      initialValue: null,
                                      label: 'Email address',
                                      autofocus: false,
                                      inputFormatters: [],
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (_) => null,
                                      onChangeHandler: (email) {
                                        verifiee = verifiee.copyWith(email: email);
                                      },
                                    ),
                                    CaptureUserDetailsInputOption(
                                      hintText: 'Nationality',
                                      initialValue: capturedVerifeeDetails?.nationality is String
                                          ? COUNTRIES_ISO_3366_ALPHA_3[capturedVerifeeDetails?.nationality] ??
                                              COUNTRIES_ISO_3166_ALPHA_2[capturedVerifeeDetails?.nationality]
                                          : null,
                                      label: 'Nationality',
                                      autofocus: false,
                                      inputFormatters: [],
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (_) => null,
                                      onChangeHandler: (val) {
                                        verifiee = verifiee.copyWith(nationality: val);
                                      },
                                    ),
                                    CaptureUserDetailsInputOption(
                                      hintText: 'Date of Birth',
                                      initialValue: capturedVerifeeDetails?.dayOfBirth != null
                                          ? _formatDate(capturedVerifeeDetails?.dayOfBirth)
                                          : null,
                                      label: 'Date of Birth',
                                      autofocus: false,
                                      inputFormatters: [],
                                      keyboardType: TextInputType.emailAddress,
                                      validator: (_) => null,
                                      onChangeHandler: (email) {
                                        verifiee = verifiee.copyWith(email: email);
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
                                        verifiee = verifiee.copyWith(description: notes);
                                      },
                                    ),
                                  ]
                                      .map((inputOption) => Padding(
                                            padding: const EdgeInsets.only(top: 20.0),
                                            child: GenericInputField(
                                              key: ValueKey(inputOption.hashCode),
                                              initialValue: inputOption.initialValue,
                                              hintText: inputOption.hintText,
                                              label: inputOption.label,
                                              readOnly: inputOption.label == 'Nationality' ||
                                                  inputOption.label == 'Date of Birth',
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
                                          ))
                                      .toList(),

                                  ///
                                  Padding(
                                    padding: const EdgeInsets.fromLTRB(0, 40, 0, 30),
                                    child: LearnMoreHighlightedButton(
                                      text: 'Need help? Visit our Help page for support!',
                                      onTap: () => navigate(
                                        context,
                                        page: const LearnMorePage(),
                                      ),
                                    ),
                                  ),

                                  ///
                                  Padding(
                                    padding: const EdgeInsets.symmetric(vertical: 40),
                                    child: BaseButton(
                                      key: UniqueKey(),
                                      onTap: () {
                                        if (_globalKeyCaptureVerifieeDetailsPageForm.currentState?.validate() == true) {
                                          context.read<StoreBloc>().add(
                                                StoreEvent.createVerifieeDetails(
                                                  verifiee.copyWith(jobUuid: jobUuid),
                                                ),
                                              );

                                          if (documentType == DocumentType.id_card ||
                                              documentType == DocumentType.id_book) {
                                            context.read<StoreBloc>().add(const StoreEvent.makeIdVerificationRequest());
                                          } else if (documentType == DocumentType.passport) {
                                            context
                                                .read<StoreBloc>()
                                                .add(const StoreEvent.makePassportVerificationRequest());
                                          } else {
                                            ScaffoldMessenger.of(context)
                                              ..clearSnackBars()
                                              ..showSnackBar(
                                                SnackBar(
                                                  showCloseIcon: true,
                                                  closeIconColor: const Color.fromARGB(255, 254, 226, 226),
                                                  duration: const Duration(seconds: 10),
                                                  content: const Text(
                                                    'Verification Request was not sent',
                                                    style: TextStyle(
                                                      color: Color.fromARGB(255, 254, 226, 226),
                                                    ),
                                                  ),
                                                  backgroundColor: errorColor,
                                                ),
                                              );
                                          }

                                          ///  pop-up with a barrier to home-screen or put the call back inside a listener
                                          showDialog(
                                            context: context,
                                            builder: (context) => SuccessfulActionModal(
                                              title: 'Generating build script completed',
                                              subtitle:
                                                  "To ignore certain requests from your Nginx logs, you can use the if directive within the http or server block of your Nginx configuration. Here's a basic example to exclude requests to a specific URL (like /healthcheck) from being logged",
                                              nextAction: () => navigate(
                                                context,
                                                page: const HomePage(),
                                              ),
                                              showDottedDivider: true,
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(context)
                                            ..clearSnackBars()
                                            ..showSnackBar(
                                              SnackBar(
                                                content: const Text(
                                                  'Some fields are not valid.',
                                                ),
                                                action: SnackBarAction(label: 'Refresh', onPressed: () {}),
                                              ),
                                            );
                                        }
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
        },
      ),
    );
  }
}

String? _formatDate(String? dayOfBirth) {
  try {
    var date = DateTime.tryParse(dayOfBirth ?? '');
    if (date is DateTime) {
      return DateFormat('dd/MM/yyyy').format(date);
    } else if (dayOfBirth != null) {
      return (dayOfBirth).split(' ').join('/');
    } else {
      return null;
    }
  } catch (err) {
    return null;
  }
}
