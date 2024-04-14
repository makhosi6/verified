import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verified/globals.dart';
import 'package:verified/presentation/pages/search_options_page.dart';
import 'package:verified/presentation/pages/select_services_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/error_warning_indicator.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/utils/verified_input_formatter.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/inputs/generic_input.dart';

final _globalKeyCaptureDetailsPageForm = GlobalKey<FormState>(debugLabel: 'capture-details-page-key');

class CaptureDetailsPage extends StatelessWidget {
  const CaptureDetailsPage({super.key});

  //
  final keyboardType = TextInputType.number;

  ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
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
                  centerTitle: false,
                  automaticallyImplyLeading: true,
                  title: const Text('Search'),
                ),
                leadingWidth: 80.0,
                leading: VerifiedBackButton(
                  key: const Key('capture-details-page-back-btn'),
                  onTap: () => Navigator.pop(context),
                  isLight: true,
                ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: BaseButton(
                      key: UniqueKey(),
                      onTap: () => {},
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
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                              child: GenericInputField(
                                key: const ValueKey('copy.inputLabel32'),
                                initialValue: '9039',
                                hintText: 'Please type...',
                                label: 'copy.inputLabel',
                                autofocus: true,
                                keyboardType: keyboardType,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(9090),
                                  VerifiedTextInputFormatter(mask: '76322')
                                ],
                                validator: (value) {
                                  if (value == null) {
                                    return 'Error';
                                  }
                                  return null;
                                },
                                onChange: (value) {
                                  ///
                                  // _globalKeyCaptureDetailsPageForm.currentState?.validate();

                                  ///
                                  // if (_globalKeyCaptureDetailsPageForm.currentState?.mounted == true) {
                                  //   _globalKeyCaptureDetailsPageForm.currentState?.setState(() {
                                  //     _globalKeyCaptureDetailsPageForm.currentState?.value = value;
                                  //   });
                                  // }
                                },
                              ),
                            ),

                            ///
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: GenericInputField(
                                key: const ValueKey('copy.inputLabel323'),
                                initialValue: '90219',
                                hintText: 'Please type...',
                                label: 'copy.inputLabel',
                                autofocus: true,
                                keyboardType: keyboardType,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(9090),
                                  VerifiedTextInputFormatter(mask: '76022')
                                ],
                                validator: (value) {
                                  if (value == null) {
                                    return 'Error';
                                  }
                                  return null;
                                },
                                onChange: (String value) {
                                  // _globalKeyCaptureDetailsPageForm.currentState?.validate();
                                },
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                              child: GenericInputField(
                                key: const ValueKey('copy.inputLabel323'),
                                initialValue: '90219',
                                hintText: 'Please type...',
                                label: 'copy.inputLabel',
                                autofocus: true,
                                keyboardType: keyboardType,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(9090),
                                  VerifiedTextInputFormatter(mask: '76022')
                                ],
                                validator: (value) {
                                  if (value == null) {
                                    return 'Error';
                                  }
                                  return null;
                                },
                                onChange: (String value) {
                                  // _globalKeyCaptureDetailsPageForm.currentState?.validate();
                                },
                              ),
                            ),

                            Padding(
                              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                              child: GenericInputField(
                                key: const ValueKey('copy.inputLabel323'),
                                initialValue: '90219',
                                hintText: 'Please type...',
                                label: 'copy.inputLabel',
                                autofocus: true,
                                keyboardType: keyboardType,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(9090),
                                  VerifiedTextInputFormatter(mask: '76022')
                                ],
                                validator: (value) {
                                  if (value == null) {
                                    return 'Error';
                                  }
                                  return null;
                                },
                                onChange: (String value) {
                                  // _globalKeyCaptureDetailsPageForm.currentState?.validate();
                                },
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0, bottom: 10.0),
                              child: GenericInputField(
                                key: const ValueKey('copy.inputLabel323'),
                                initialValue: '90219',
                                hintText: 'Please type...',
                                label: 'copy.inputLabel',
                                autofocus: true,
                                keyboardType: keyboardType,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(9090),
                                  VerifiedTextInputFormatter(mask: '76022')
                                ],
                                validator: (value) {
                                  if (value == null) {
                                    return 'Error';
                                  }
                                  return null;
                                },
                                onChange: (String value) {
                                  // _globalKeyCaptureDetailsPageForm.currentState?.validate();
                                },
                              ),
                            ),

                            ///
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 40, 20, 30),
                              child: Text(
                                'Please type a phone/id number and click send to verify.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: neutralDarkGrey,
                                  fontSize: 14.0,
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),

                            ///
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: BaseButton(
                                key: UniqueKey(),
                                onTap: () => navigate(context, page: const SelectServicesPage()),
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
