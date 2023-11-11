import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/domain/models/help_request.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';

Future showHelpPopUpForm(BuildContext context) async => await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        contentPadding: primaryPadding,
        title: const Text(
          'Report an issue',
          style: TextStyle(fontSize: 24.0),
        ),
        content: _HelpForm(),
      ),
    );

class _HelpForm extends StatefulWidget {
  @override
  State<_HelpForm> createState() => _HelpFormState();
}

class _HelpFormState extends State<_HelpForm> {
  ///
  final _formKey = GlobalKey<FormState>();

  ///
  final issueTypes = [
    'Bug Report',
    'Billing/Payments/Refund',
    'Service Complaint',
    'Deletion of Personal Information',
    'Other'
  ];
  late String? selectedIssueType = issueTypes.last;

  ///
  final preferredCommunicationChannel = ['In-App Notification', 'SMS', 'Email', 'Whatsapp'];
  late String? selectedPreferredCommunicationChannel = preferredCommunicationChannel.first;

  final _bodyTextController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Column(
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
                      if (value == null || value.isEmpty) {
                        return 'The description field is required.';
                      }
                      return null;
                    },
                  ),
                )
              ],
            ),
            BaseButton(
              key: UniqueKey(),
              onTap: () {
                ///
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  ///
                  FocusScope.of(context).unfocus();

                  ///
                  final user = context.read<StoreBloc>().state.userProfileData;
                  final helpRequest = HelpRequest(
                    profileId: user?.id,
                    timestamp: DateTime.now().millisecondsSinceEpoch,
                    type: selectedIssueType,
                    comment: Comment(title: 'Issue report', body: _bodyTextController.text),
                    preferredCommunicationChannel: selectedPreferredCommunicationChannel,
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
                'Please be as specific and detailed as possible. Include relevant details, steps to reproduce the issue, and any error messages you\'ve encountered.',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
