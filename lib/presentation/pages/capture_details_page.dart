import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/domain/models/search_request.dart';
import 'package:verified/globals.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/infrastructure/analytics/repository.dart';
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

class CaptureDetailsPage extends StatelessWidget {
  CaptureDetailsPage({super.key});

  ///
  final keyboardType = TextInputType.number;

  ///
  var person = SearchPerson();

  ///
  @override
  Widget build(BuildContext context) {
    ///
    final globalKeyCaptureDetailsPageForm = GlobalKey<FormState>(debugLabel: '[$hashCode]captured-details-page-key');

    ///
    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).clearMaterialBanners();

        return true;
      },
      child: Scaffold(
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
                  title: const Text('Verified'),
                ),
                leadingWidth: 80.0,
                leading: VerifiedBackButton(
                  key: const Key('captured-details-page-back-btn'),
                  onTap: () {
                    VerifiedAppAnalytics.logActionTaken(
                      VerifiedAppAnalytics.ACTION_BACK_CREATE_CANDIDATE_DETAILS,
                    );

                    ScaffoldMessenger.of(context).clearMaterialBanners();

                    Navigator.pop(context);
                  },
                  isLight: true,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: BaseButton(
                      key: UniqueKey(),
                      // onTap: () => navigate(context, page: CreateAccountPage()),
                      onTap: () {
                        VerifiedAppAnalytics.logFeatureUsed(
                          VerifiedAppAnalytics.FEATURE_BULK_VERIFICATION,
                        );

                        ///
                        ScaffoldMessenger.of(context)
                          ..clearMaterialBanners()
                          ..showMaterialBanner(
                            MaterialBanner(
                              padding: primaryPadding,
                              content: const Text(
                                'Bulk Verification feature coming soon!',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                              ),
                              leading: const Icon(
                                Icons.donut_large_sharp,
                                size: 24,
                                color: Colors.white,
                              ),
                              backgroundColor: darkerPrimaryColor,
                              actions: [
                                IconButton(
                                  onPressed: ScaffoldMessenger.of(context).clearMaterialBanners,
                                  icon: const Icon(
                                    Icons.close_sharp,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          );
                      },
                      height: 49.0,
                      label: 'Bulk Verify',
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
                        key: globalKeyCaptureDetailsPageForm,
                        child: Column(
                          key: const Key('captured-details-field-inputs'),
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: primaryPadding.horizontal),
                              child: Text(
                                'Get full confidence with a detailed identity verification. This thorough check covers everything, giving you extra assurance.',
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
                                hintText: 'Name of the Candidate',
                                label: 'Name or Nickname',
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
                                hintText: '000 000 0000',
                                initialValue: null,
                                label: 'Phone Number',
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
                                  globalKeyCaptureDetailsPageForm.currentState?.validate();
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
                                      padding: EdgeInsets.symmetric(vertical: primaryPadding.vertical),
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
                                text: 'Need help? Visit our Help page for support!',
                                onTap: () => navigate(
                                  context,
                                  page: LearnMorePage(),
                                ),
                              ),
                            ),

                            ///
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: BaseButton(
                                key: UniqueKey(),
                                onTap: () {
                                  if (globalKeyCaptureDetailsPageForm.currentState?.validate() == true) {
                                    context.read<StoreBloc>().add(
                                          StoreEvent.createPersonalDetails(
                                            person,
                                          ),
                                        );

                                    navigate(context, page: const SelectServicesPage());
                                  } else {
                                    verifiedLogger('FALSE, ${person.toJson()}');
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
  }
}
