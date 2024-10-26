import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:verified/globals.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/error_warning_indicator.dart';
import 'package:verified/presentation/utils/verified_input_formatter.dart';
import 'package:verified/presentation/utils/widget_generator_options.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/inputs/generic_input.dart';
import 'package:verified/presentation/widgets/popups/default_popup.dart';

class CreateAccountPage extends StatefulWidget {
  CreateAccountPage({super.key});

  @override
  State<CreateAccountPage> createState() => _CreateAccountPageState();
}

class _CreateAccountPageState extends State<CreateAccountPage> {
  ///
  final _globalKeyCreateAccountPageForm = GlobalKey<FormState>(debugLabel: 'create-account-page-key');

  ///
  final keyboardType = TextInputType.number;

  ///
  late String? selectedPreferredCommunicationChannel = preferredCommunicationChannel.first;

  final List<String> preferredCommunicationChannel =
      List.unmodifiable(['In-App Notification', 'SMS', 'Email', 'Whatsapp']);

  ///
  @override
  Widget build(BuildContext context) {
    ///
    var borderColor = ThemeData(brightness: Brightness.light).textTheme.displayLarge?.color ?? primaryColor;

    ///
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
                  title: const Text('Create an Account'),
                ),
                leadingWidth: 80.0,
                leading: const SizedBox.shrink(),
                actions: const [],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => UnconstrainedBox(
                    child: Container(
                      width: MediaQuery.of(context).size.width - primaryPadding.horizontal,
                      constraints: appConstraints,
                      padding: EdgeInsets.only(bottom: primaryPadding.bottom * 3, top: primaryPadding.top * 3),
                      child: Form(
                        key: _globalKeyCreateAccountPageForm,
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
                            ...[
                              CaptureUserDetailsInputOption(
                                hintText: 'Whats your preferred name',
                                initialValue: null,
                                label: 'Username',
                                inputMask: null,
                                autofocus: true,
                                inputFormatters: [],
                                keyboardType: TextInputType.text,
                                validator: (_) => null,
                                onChangeHandler: print,
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
                                validator: (_) => null,
                                onChangeHandler: print,
                              ),
                              // CaptureUserDetailsInputOption(
                              //   hintText: 'City/Town/Suburb',
                              //   initialValue: null,
                              //   label: 'Name of your city',
                              //   inputMask: null,
                              //   autofocus: false,
                              //   inputFormatters: [],
                              //   keyboardType: TextInputType.text,
                              //   validator: (_) => null,
                              //   onChangeHandler: print,
                              // ),
                            ]
                                .map(
                                  (inputOption) => Padding(
                                    padding: EdgeInsets.symmetric(vertical: primaryPadding.vertical),
                                    child: GenericInputField(
                                      key: ValueKey(inputOption.hashCode),
                                      initialValue: inputOption.initialValue,
                                      hintText: inputOption.hintText,
                                      label: inputOption.label,
                                      autofocus: inputOption.autofocus,
                                      keyboardType: inputOption.keyboardType,
                                      inputFormatters: [
                                        ///
                                        if (inputOption.keyboardType == TextInputType.number)
                                          FilteringTextInputFormatter.digitsOnly,

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
                                )
                                .toList(),

                            ///
                            Padding(
                              padding: const EdgeInsets.only(top: 20.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Select preferred communication method',
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
                                              color: borderColor,
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
                                          )),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: selectedPreferredCommunicationChannel,
                                          // hint: const Text('Select preferred communication method'),
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
                                ],
                              ),
                            ),

                            ///
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 40),
                              child: BaseButton(
                                key: UniqueKey(),
                                onTap: () => {
                                  /// Bloc event

                                  /// then
                                  Navigator.of(context).pop()
                                },
                                label: 'Create an Account',
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
