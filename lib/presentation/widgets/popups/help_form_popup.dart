import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_asset_picker/gallery_asset_picker.dart';
import 'package:uuid/uuid.dart';
import 'package:verified/app_config.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/domain/models/help_ticket.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/infrastructure/analytics/repository.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/select_media.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/popups/default_popup.dart';

final _helpFormGlobalKey = GlobalKey<_HelpFormState>(debugLabel: 'help-form-key');

Future showHelpPopUpForm(BuildContext context, {String? title}) async => await showDialog(
    context: context,
    barrierColor: darkBlurColor,
    builder: (context) {
      var delta = 10;
      return StatefulBuilder(builder: (context, setState) {
        return AlertDialog(
          key: ValueKey(delta),
          contentPadding: primaryPadding,
          insetPadding: _helpFormGlobalKey.currentState?.formHeight == null
              ? const EdgeInsets.symmetric(horizontal: 40.0, vertical: 24.0)
              : EdgeInsets.zero,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                child: Text(
                  title ?? 'Report an issue',
                  style: const TextStyle(fontSize: 24.0),
                ),
              ),
              ActionButton(
                key: const Key('minimize-maximize-btn'),
                tooltip: _helpFormGlobalKey.currentState?.formHeight == null ? 'Maximize' : 'Minimize',
                padding: EdgeInsets.zero,
                iconColor: primaryColor,
                bgColor: Colors.white,
                onTap: () {
                  /// a useless delta used to force-refresh the AlertDialog
                  setState(
                    () {
                      delta = Random().nextInt(900);
                    },
                  );

                  _helpFormGlobalKey.currentState?.miniMaximizeHelpFrom(context);
                },
                icon: _helpFormGlobalKey.currentState?.formHeight == null
                    ? Icons.open_in_new
                    : Icons.call_received_outlined,
              ),
            ],
          ),
          content: _HelpForm(),
        );
      });
    });

class _HelpForm extends StatefulWidget {
  _HelpForm() : super(key: _helpFormGlobalKey){

  VerifiedAppAnalytics.logActionTaken(
      VerifiedAppAnalytics.ACTION_LOG_SUPPORT_TICKET);
  }

  @override
  State<_HelpForm> createState() => _HelpFormState();
}

final _formKey = GlobalKey<FormState>();

class _HelpFormState extends State<_HelpForm> {
  ///

  ///
  final List<String> issueTypes = List.unmodifiable(
      ['Bug Report', 'Billing/Payments/Refund', 'Service Complaint', 'Deletion of Personal Information', 'Other']);
  late String? selectedIssueType = issueTypes.last;

  ///
  final List<String> preferredCommunicationChannel =
      List.unmodifiable(['In-App Notification', 'SMS', 'Email', 'Whatsapp']);
  late String? selectedPreferredCommunicationChannel = preferredCommunicationChannel.first;

  ///
  final _bodyTextController = TextEditingController();

  num? formHeight;
  num? formWidth;

  ///
  List<MultipartFile> selectedMedia = [];

  /// - function handler to minimize and maximize the help form
  void miniMaximizeHelpFrom(BuildContext context) {
    if (mounted) {
      setState(() {
        if (formHeight == null && formWidth == null) {
          formHeight = MediaQuery.of(context).size.height * 0.9;
          formWidth = MediaQuery.of(context).size.width * 0.9;
        } else {
          formHeight = null;
          formWidth = null;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: formHeight?.toDouble(),
      width: formWidth?.toDouble(),
      duration: const Duration(milliseconds: 250),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0, top: 4),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        hintText: 'Select issue type',
                        labelText: 'Select issue type',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          hint: const Text('Select issue type'),
                          value: selectedIssueType,
                          isExpanded: true,
                          isDense: true,
                          items: issueTypes.map((String value) {
                            return DropdownMenuItem<String>(
                              value: value,
                              child: Text(value),
                            );
                          }).toList(),
                          onChanged: (issueType) {
                            if (mounted) {
                              setState(() {
                                selectedIssueType = issueType;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        hintText: 'Select preferred communication method',
                        labelText: 'Select preferred communication method',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedPreferredCommunicationChannel,
                          hint: const Text('Select preferred communication method'),
                          isExpanded: true,
                          isDense: true,
                          items: preferredCommunicationChannel
                              .map((String value) => DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  ))
                              .toList(),
                          onChanged: (String? channel) => {
                            if (mounted)
                              {
                                setState(() {
                                  selectedPreferredCommunicationChannel = channel;
                                })
                              }
                          },
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10.0),
                    child: TextFormField(
                      controller: _bodyTextController,
                      maxLines: 4,
                      minLines: 1,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                        hintStyle: TextStyle(color: Colors.grey[700]),
                        labelStyle: TextStyle(color: Colors.grey[700]),
                        hintText: 'Description of the issue',
                        labelText: 'Description of the issue',
                      ),
                      validator: (value) {
                        FocusScope.of(context).unfocus();

                        ///
                        if (value == null || value.isEmpty) {
                          return 'The description field is required.';
                        }
                        return null;
                      },
                    ),
                  )
                ],
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: BaseButton(
                    key: UniqueKey(),
                    onTap: () {
                      try {
                        ///
                        GalleryAssetPicker.pick(
                          context,
                          maxCount: MAX_FILES_UPLOAD,
                          requestType: RequestType.all,
                        ).then((files) async {
                          verifiedLogger('MEDIA: ${files.length}');

                          ///
                          return await Future.wait(files.map((f) async => await convertToFormData(await f.file)));
                        }).then((media) {
                          ///
                          if (media.isEmpty) return;

                          ///
                          if (mounted) {
                            setState(() {
                              selectedMedia = media.where((i) => i != null).cast<MultipartFile>().toList();
                            });
                          }

                          context.read<StoreBloc>().add(StoreEvent.uploadFiles(selectedMedia));
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
                    label: 'Uploads (Optional) ${selectedMedia.isEmpty ? '' : "(${selectedMedia.length})"}',
                    color: Colors.black87,
                    buttonIcon: const Image(
                      image: AssetImage('assets/icons/add-file.png'),
                    ),
                    buttonSize: ButtonSize.large,
                    hasBorderLining: true,
                  ),
                ),
              ),
              Center(
                child: SizedBox(
                  child: BaseButton(
                    key: UniqueKey(),
                    onTap: () async {
                      ///
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();

                        ///
                        FocusScope.of(context).unfocus();

                        ///
                        final user = context.read<StoreBloc>().state.userProfileData;

                        ///
                        final isWithinFileSizeLimit = checkTotalFileSizeIsWithLimits(
                          context.read<StoreBloc>().state.uploadsData?.files ?? [],
                        );

                        if (isWithinFileSizeLimit == false || context.read<StoreBloc>().state.uploadsTooBig) {
                          // ignore: use_build_context_synchronously
                          showDefaultPopUp(
                            context,
                            title: 'File(s) size exceeds limit!',
                            subtitle:
                                'The total size of the selected files exceeds the 25 MB limit. Please select fewer files or choose smaller files to proceed.',
                            confirmBtnText: 'Okay',
                            onConfirm: () => Navigator.pop(context),
                          );
                          return;
                        }

                        Future.delayed(const Duration(seconds: 1)).then((_) {
                          final helpRequest = HelpTicket(
                            id: const Uuid().v4(),
                            profileId: user?.id,
                            timestamp: DateTime.now().millisecondsSinceEpoch ~/ 1000,
                            type: selectedIssueType,
                            isResolved: false,
                            comment: Comment(title: 'Issue report', body: _bodyTextController.text),
                            preferredCommunicationChannel: selectedPreferredCommunicationChannel,
                            uploads: context.read<StoreBloc>().state.uploadsData?.files,
                            responses: [],
                          );

                          ///
                          context.read<StoreBloc>().add(StoreEvent.requestHelp(helpRequest));

                          ///
                          Navigator.of(context).pop(helpRequest);

                          ///
                          ScaffoldMessenger.of(context)
                            ..clearSnackBars()
                            ..showSnackBar(
                              const SnackBar(content: Text('Processing the Request!')),
                            );
                        });
                      }
                    },
                    label: 'Submit',
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
                ),
              ),
              Container(
                padding: const EdgeInsets.only(bottom: 5.0, left: 8.0, top: 16),
                child: const Text(
                  'Note',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8.0),
                child: Text(
                  'Please be as specific and detailed as possible. Include relevant details, screenshots, steps to reproduce the issue, and any error messages you\'ve encountered.',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
