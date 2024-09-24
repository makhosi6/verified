import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/domain/models/captured_candidate_details.dart';
import 'package:verified/globals.dart';
import 'package:verified/helpers/extensions/user.dart';
import 'package:verified/helpers/image.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/presentation/pages/home_page.dart';
import 'package:verified/presentation/pages/id_document_scanner_page.dart';
import 'package:verified/presentation/pages/verification_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/document_type.dart';
import 'package:verified/presentation/utils/error_warning_indicator.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/utils/select_media.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';

class ChooseDocumentPage extends StatefulWidget {
  final VerificationPageArgs? verificationArgs;
  const ChooseDocumentPage({super.key, this.verificationArgs});

  @override
  State<ChooseDocumentPage> createState() => _ChooseDocumentPageState();
}

class _ChooseDocumentPageState extends State<ChooseDocumentPage> {
  CameraEventsState? documentScannerState;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigate(context, page: const HomePage(), replaceCurrentPage: true);
        return false;
      },
      child: Scaffold(
        body: Center(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              const AppErrorWarningIndicator(),
              SliverAppBar(
                stretch: true,
                onStretchTrigger: () async {},
                surfaceTintColor: Colors.transparent,
                stretchTriggerOffset: 300.0,
                expandedHeight: 90.0,
                flexibleSpace: AppBar(
                  automaticallyImplyLeading: true,
                  title: const Text(
                    'Quick Verification',
                  ),
                ),
                leadingWidth: 80.0,
                leading: VerifiedBackButton(
                  key: const Key('choose-document-type-page-back-btn'),
                  onTap: () => navigate(context, page: const HomePage(), replaceCurrentPage: true),
                  isLight: true,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, indx) {
                    var index = indx - 1;

                    if (index == -1) {
                      return Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: primaryPadding.horizontal, vertical: primaryPadding.vertical * 2),
                        child: Text(
                          'To complete your verification, please upload/scan a clear image of your ID, passport. Ensure the document is fully visible and well-lit to avoid any delays in the process.',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: neutralDarkGrey,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }

                    return UnconstrainedBox(
                      child: Container(
                        width: MediaQuery.of(context).size.width - primaryPadding.horizontal,
                        constraints: appConstraints,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: BaseButton(
                            key: ValueKey(DocumentType.values[index]),
                            onTap: () => navigate(
                              context,
                              page: IDDocumentScanner(
                                documentType: DocumentType.values[index],
                                onCapture: (File file, DetectSide side) {
                                  if (mounted &&
                                      documentScannerState?.imageFiles.where((i) => i.side == side.name).isEmpty ==
                                          true) {
                                    setState(() {
                                      documentScannerState?.copyWith(
                                          imageFiles: documentScannerState?.imageFiles
                                            ?..add(ImageFile(side: side.name, file: file)));
                                    });
                                  }
                                },
                                onMessage: (_) {},
                                onStateChanged: (CameraEventsState? state) {
                                  if (mounted) {
                                    setState(() {
                                      documentScannerState = state;
                                    });
                                  }
                                },
                                onNext: (ctx, state) {
                                  try {
                                    // ignore: no_leading_underscores_for_local_identifiers
                                    final _documentScannerState = documentScannerState ?? state;
                                    void _nextPage() => navigateToNamedRoute(
                                          ctx,
                                          routeName: '/captured-details',
                                          arguments: {
                                            "docType": DocumentType.values[index],
                                            'jobUuid': widget.verificationArgs?.uuid
                                          },
                                          replaceCurrentPage: true,
                                        );

                                    ///
                                    if (_documentScannerState == null ||
                                        _documentScannerState.imageFiles.isEmpty == true ||
                                        (DocumentType.values[index] == DocumentType.id_card &&
                                            (documentScannerState?.idPdf417Text ?? documentScannerState?.idCode39Text)
                                                    ?.isEmpty ==
                                                true)) {
                                      return;
                                    }
                                    if (DocumentType.values[index] == DocumentType.passport) {
                                      ///
                                      var image = _documentScannerState.imageFiles.first;
                                      var bytes = image.file.readAsBytesSync();

                                      ///
                                      Future.microtask(() async {
                                        try {
                                          var fileData = await convertToFormData(image.file);
                                          if (fileData != null) {
                                            // ignore: use_build_context_synchronously
                                            ctx.read<StoreBloc>()
                                              ..add(StoreEvent.decodePassportData(FormData.fromMap({
                                                // 'files': [fileData],
                                                'data_url': bytesToDataUrl(bytes, getExtension(image.file.path))
                                              })))
                                              ..add(
                                                StoreEvent.addCandidate(
                                                  CapturedCandidateDetails(
                                                    jobUuid: widget.verificationArgs?.uuid,
                                                    cameraState: (documentScannerState ?? state)?.toJson(),
                                                  ),
                                                ),
                                              )
                                              ..add(
                                                StoreEvent.uploadPassportImage(fileData),
                                              );
                                          }
                                        } catch (error, stackTrace) {
                                          verifiedErrorLogger(error, stackTrace);
                                        }
                                      }).whenComplete(_nextPage);
                                    } else if (DocumentType.values[index] == DocumentType.id_card ||
                                        DocumentType.values[index] == DocumentType.id_book) {
                                      var details = CapturedCandidateDetails.fromIdString(
                                        _documentScannerState.idPdf417Text ?? '',
                                      );
                                      details.cameraState = (documentScannerState ?? state)?.toJson();
                                      if (DocumentType.values[index] == DocumentType.id_card) {
                                        details.identityNumber2 = _documentScannerState.idCode39Text;
                                        details.rawInput = _documentScannerState.idPdf417Text;
                                        details.jobUuid = widget.verificationArgs?.uuid;
                                      } else if (DocumentType.values[index] == DocumentType.id_book) {
                                        details.identityNumber = _documentScannerState.idCode39Text2;
                                        details.rawInput = _documentScannerState.idCode39Text2;
                                        details.jobUuid = widget.verificationArgs?.uuid;
                                      }

                                      Future.microtask(() async {
                                        var filesData = await Future.wait(_documentScannerState.imageFiles
                                            .map((img) async =>
                                                ((await convertToFormData(img.file, side: img.side)) as MultipartFile))
                                            .toList());

                                        verifiedLogger(_documentScannerState.imageFiles.length);
                                        verifiedLogger(_documentScannerState.imageFiles);
                                        verifiedLogger(filesData);
                                        verifiedLogger(filesData.map((e) => e.filename));
                                        verifiedLogger(filesData.length);
                                        // if (filesData.isEmpty && kDebugMode) exit(0);
                                        // ignore: use_build_context_synchronously
                                        ctx.read<StoreBloc>()
                                          ..add(StoreEvent.addCandidate(details))
                                          ..add(StoreEvent.uploadIdImages(filesData));
                                      }).whenComplete(_nextPage);
                                    } else {
                                      ScaffoldMessenger.of(ctx)
                                        ..clearSnackBars()
                                        ..showSnackBar(
                                          SnackBar(
                                            showCloseIcon: true,
                                            duration: const Duration(seconds: 10),
                                            closeIconColor: const Color.fromARGB(255, 254, 226, 226),
                                            content: const Text(
                                              'Invalid document type, please use passport or id book or id card',
                                              style: TextStyle(
                                                color: Color.fromARGB(255, 254, 226, 226),
                                              ),
                                            ),
                                            backgroundColor: errorColor,
                                          ),
                                        );
                                    }
                                  } catch (error, stackTrace) {
                                    // 31878): Error @ onNext of _choose docs Looking up a deactivated widget's ancestor is unsafe.
                                    debugPrintStack(stackTrace: stackTrace, label: 'Error @ onNext of _choose docs');
                                    verifiedErrorLogger(error, stackTrace);
                                    if (kDebugMode) exit(0);
                                  }
                                },
                              ),
                              replaceCurrentPage: true,
                            ),
                            label: DocumentType.values[index].name.split('_').join(' ').capitalize().replaceAll('Id ', 'ID '),
                            buttonIcon: Icon(docTypeIcon(DocumentType.values[index])),
                            buttonSize: ButtonSize.large,
                            hasBorderLining: true,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: DocumentType.values.length + 1, // header at index 0
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

IconData? docTypeIcon(DocumentType? value) => switch (value) {
      DocumentType.id_card => Icons.fact_check_outlined,
      DocumentType.id_book => Icons.document_scanner_outlined,
      DocumentType.passport => Icons.branding_watermark_outlined,
      _ => Icons.verified_outlined
    };
