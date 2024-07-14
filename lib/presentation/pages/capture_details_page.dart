import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/domain/models/search_request.dart';
import 'package:verified/globals.dart';
import 'package:verified/presentation/pages/create_account_page.dart';
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

final _globalKeyCaptureDetailsPageForm = GlobalKey<FormState>(debugLabel: 'captured-details-page-key');

class CaptureDetailsPage extends StatelessWidget {
  CaptureDetailsPage({super.key});

  ///
  final keyboardType = TextInputType.number;

  ///
  var person = SearchPerson();

  ///
  @override
  Widget build(BuildContext context) {
    //
    return Scaffold(
      key: const Key('captured-details-page'),
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
                centerTitle: false,
                automaticallyImplyLeading: true,
                title: const Text('Search'),
              ),
              leadingWidth: 80.0,
              leading: VerifiedBackButton(
                key: const Key('captured-details-page-back-btn'),
                onTap: () => Navigator.pop(context),
                isLight: true,
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 12.0),
                  child: BaseButton(
                    key: UniqueKey(),
                    onTap: () => navigate(context, page: CreateAccountPage()),
                    height: 49.0,
                    label: 'Bulk Upload',
                    borderColor: primaryColor,
                    iconBgColor: litePrimaryColor,
                    buttonIcon: const Image(
                      image: AssetImage('assets/icons/bulk_upload2.png'),
                    ),
                    buttonSize: ButtonSize.small,
                    hasBorderLining: true,
                  ),
                )
              ],
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) => UnconstrainedBox(
                  child: Container(
                    width: MediaQuery.of(context).size.width - primaryPadding.horizontal,
                    constraints: appConstraints,
                    padding: EdgeInsets.only(bottom: primaryPadding.bottom * 3, top: primaryPadding.top * 3),
                    child: Form(
                      key: _globalKeyCaptureDetailsPageForm,
                      child: Column(
                        key: const Key('captured-details-field-inputs'),
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
                                  return 'Please provide a name/surname/nickname';
                                }
                                if (name.length < 2) {
                                  return 'Name must be at least 2 characters long';
                                }
                                return null;
                              },
                              onChangeHandler: (name) {
                                person = person.copyWith(name: name);
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
                                /// if phone is define the Id is optional
                                if ((person.phoneNumber != null && person.phoneNumber?.isNotEmpty == true) &&
                                    (idNumber == null || idNumber.isEmpty)) {
                                  return null;
                                }

                                if (idNumber == null || idNumber.isEmpty) {
                                  return 'You have to provide a phone number or a ID number';
                                }
                                return validateIdNumber(idNumber);
                              },
                              onChangeHandler: (idNumber) {
                                person = person.copyWith(idNumber: idNumber);

                                /// and validate the form
                                _globalKeyCaptureDetailsPageForm.currentState?.validate();
                              },
                            ),
                            CaptureUserDetailsInputOption(
                              hintText: '00000000000',
                              initialValue: null,
                              label: 'Bank Account Number (optional)',
                              inputMask: '00000000000',
                              autofocus: false,
                              maxLength: null,
                              inputFormatters: [],
                              keyboardType: TextInputType.number,
                              validator: (accNumber) {
                                if ((accNumber != null && accNumber.isNotEmpty) && accNumber.length < 10) {
                                  return 'Acc Number must be at least 10 characters long';
                                }
                                return null;
                              },
                              onChangeHandler: (bankAccountNumber) {
                                person = person.copyWith(bankAccountNumber: bankAccountNumber);
                              },
                            ),
                            CaptureUserDetailsInputOption(
                              hintText: '000 000 0000',
                              initialValue: null,
                              label: 'Phone Number (Optional)',
                              inputMask: '000 000 0000',
                              maxLength: 10,
                              autofocus: false,
                              inputFormatters: [],
                              keyboardType: TextInputType.number,
                              validator: (phone) {
                                /// if idNumber is define the then Phone is optional
                                if ((person.idNumber != null && person.idNumber?.isNotEmpty == true) &&
                                    (phone == null || phone.isEmpty)) {
                                  return null;
                                }

                                if (phone == null || phone.isEmpty) {
                                  return 'You have to provide a phone number or a ID number';
                                }
                                return validateMobile(phone);
                              },
                              onChangeHandler: (phoneNumber) {
                                person = person.copyWith(phoneNumber: phoneNumber);

                                /// and validate the form
                                _globalKeyCaptureDetailsPageForm.currentState?.validate();
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
                                person = person.copyWith(email: email);
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
                                person = person.copyWith(description: notes);
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
                                if (_globalKeyCaptureDetailsPageForm.currentState?.validate() == true) {
                                  context.read<StoreBloc>().add(
                                        StoreEvent.createPersonalDetails(
                                          person,
                                        ),
                                      );

                                  navigate(context, page: const SelectServicesPage());
                                } else {
                                  print('FALSE, ${person.toJson()}');
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
