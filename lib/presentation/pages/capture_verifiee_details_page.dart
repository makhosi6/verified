import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verified/application/search_request/search_request_bloc.dart';
import 'package:verified/domain/models/verifee_request.dart';
import 'package:verified/globals.dart';
import 'package:verified/presentation/pages/learn_more_page.dart';
import 'package:verified/presentation/pages/select_services_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/learn_more_highlighted_btn.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/utils/validate_inputs.dart';
import 'package:verified/presentation/utils/verified_input_formatter.dart';
import 'package:verified/presentation/utils/widget_generator_options.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/inputs/generic_input.dart';

final _globalKeyCaptureVerifieeDetailsPageForm = GlobalKey<FormState>(debugLabel: 'capture-verifiee-details-page-key');

class CaptureVerifieeDetailsPage extends StatelessWidget {
  CaptureVerifieeDetailsPage({super.key});

  ///
  var keyboardType = TextInputType.number;

  ///
  var verifiee = VerifeeRequest();

  ///
  @override
  Widget build(BuildContext context) {
        final image = ModalRoute.of(context)?.settings.arguments as File?;
    //
    return Scaffold(
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
                onTap: () => Navigator.pop(context),
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
                            CaptureUserDetailsInputOption(
                              hintText: 'Person to be verify',
                              label: 'Name or Nickname (Optional)',
                              initialValue: null,
                              autofocus: true,
                              inputFormatters: [],
                              keyboardType: TextInputType.text,
                              validator: (name) {
                                if (name == null || name.isEmpty == true) {
                                  return 'Please provide a name/surname';
                                }
                                if (name.length < 2) {
                                  return 'Name must be at least 2 characters long';
                                }
                                return null;
                              },
                              onChangeHandler: (name) {
                                verifiee = verifiee.copyWith(preferredName: name);
                              },
                            ),
                            CaptureUserDetailsInputOption(
                              hintText: 'Type their Id Number',
                              initialValue: null,
                              label: 'Government-issued ID Number (optional)',
                              inputMask: '000000 0000 000',
                              autofocus: false,
                              maxLength: 13,
                              inputFormatters: [],
                              keyboardType: TextInputType.number,
                              validator: (idNumber) {
                          

                                if (idNumber == null || idNumber.isEmpty) {
                                  return 'You have to provide a phone number or a ID number';
                                }
                                return validateIdNumber(idNumber);
                              },
                              onChangeHandler: (idNumber) {
                                verifiee = verifiee.copyWith(idNumber: idNumber);

                                /// and validate the form
                                _globalKeyCaptureVerifieeDetailsPageForm.currentState?.validate();
                              },
                            ), CaptureUserDetailsInputOption(
                              hintText: '000 000 0000',
                              initialValue: null,
                              label: 'Phone Number (Optional)',
                              inputMask: '000 000 0000',
                              maxLength: 10,
                              autofocus: false,
                              inputFormatters: [],
                              keyboardType: TextInputType.number,
                              validator: (phone) {
                        

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
                              label: 'Email address (Optional)',
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
                              text: 'Please type and click send to verify the details.',
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
                                  context.read<SearchRequestBloc>().add(
                                        SearchRequestEvent.createVerifieeDetails(
                                          verifiee,
                                        ),
                                      );

                                  navigate(context, page: const SelectServicesPage());
                                } else {
                                  print('FALSE, ${verifiee.toJson()}');
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
    );
  }
}
