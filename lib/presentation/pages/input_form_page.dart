// ignore_for_file: non_constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verified/app_config.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/application/verify_sa/verify_sa_bloc.dart';
import 'package:verified/domain/models/enquiry_reason.dart';
import 'package:verified/domain/models/form_type.dart';

import 'package:verified/globals.dart';
import 'package:verified/presentation/pages/add_payment_method_page.dart';
import 'package:verified/presentation/pages/learn_more_page.dart';
import 'package:verified/presentation/pages/search_results_page.dart';
import 'package:verified/presentation/pages/top_up_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/error_warning_indicator.dart';
import 'package:verified/presentation/utils/learn_more_highlighted_btn.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/utils/validate_inputs.dart';
import 'package:verified/presentation/utils/verified_input_formatter.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/inputs/generic_input.dart';

class InputFormPage extends StatefulWidget {
  const InputFormPage({super.key});

  @override
  State<InputFormPage> createState() => _InputFormPageState();
}

class _InputFormPageState extends State<InputFormPage> {
  List<String> reasonsForRequest = EnquiryReason.values.map((reason) => reason.value).toList();
  final _globalKeyFormPage = GlobalKey<FormState>(debugLabel: 'input-form-key');
  String? reason;

  String? idOrPhoneNumber;

  FormType? selectedFormType;

  int stackIndex = 0;

  @override
  Widget build(BuildContext context) {
    List<Widget> widgets = getWidgets(context);

    return Scaffold(
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
                key: Key('${selectedFormType?.name}-input-form-page-back-btn'),
                onTap: () {
                  if (mounted && stackIndex == 1) {
                    setState(() {
                      stackIndex = 0;
                    });
                  } else {
                    Navigator.of(context).pop();
                  }
                },
                isLight: true,
              ),
           
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) => UnconstrainedBox(
                  child: Container(
                    width: MediaQuery.of(context).size.width - primaryPadding.horizontal,
                    constraints: appConstraints,
                    child: widgets[index],
                  ),
                ),
                childCount: widgets.length,
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> getWidgets(BuildContext context) {
    final user = context.watch<StoreBloc>().state.userProfileData;
    final MIDDLE_INDEX = ((FormType.values.length - 1) / 2).ceil();
    final HELP_TEXT_INDEX = ((FormType.values.length + 1)).ceil();
    return [
      BlocBuilder<VerifySaBloc, VerifySaState>(
          builder: (context, state) => Padding(
                padding: EdgeInsets.symmetric(horizontal: primaryPadding.horizontal),
                child: Text(
                 '${selectedFormType?.index.toString()}' + 'Please type a phone/id number and click send to verify.',
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: neutralDarkGrey,
                    fontSize: 14.0,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),),
      AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        transitionBuilder: (Widget child, Animation<double> animation) {
          return ScaleTransition(scale: animation, child: child);
        },
        child: IndexedStack(
          key: ValueKey<int>(stackIndex),
          index: stackIndex,
          children: [
            Container(
              padding: EdgeInsets.only(bottom: primaryPadding.bottom , top: primaryPadding.top * 3),
              child: Form(
                key: _globalKeyFormPage,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: FormType.values.map<Widget>((formType) {
                    ///
                    bool isIdNumber = formType == FormType.idForm;
                    final copy = isIdNumber ? PageCopy.idNumberForm : PageCopy.phoneNumberForm;
                    final inputLength = isIdNumber ? 13 : 10;
                    final inputMask = isIdNumber ? '000000 0000 000' : '000 000 0000';
                    final keyboardType = isIdNumber ? TextInputType.number : TextInputType.phone;
                    final validator = isIdNumber ? validateIdNumber : validateMobile;

                    return GenericInputField(
                      key: ValueKey(copy.inputLabel),
                      hintText: copy.formPlaceholderText ?? 'Please type...',
                      label: copy.inputLabel ?? '',
                      autofocus: true,
                      keyboardType: keyboardType,
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(inputLength),
                        VerifiedTextInputFormatter(mask: inputMask)
                      ],
                      validator: (value) {
                        if (kDebugMode) {
                          print('====>>====');
                          print(value);
                          print(value.runtimeType);
                          print(idOrPhoneNumber != null);
                          print(idOrPhoneNumber?.isNotEmpty == true);
                        }
                        if ((idOrPhoneNumber != null && idOrPhoneNumber?.isNotEmpty == true) &&
                            (value == null || value.isEmpty)) {
                          return null;
                        }

                        return validator(value);
                      },
                      onChange: (value) {
                        ///
                        _globalKeyFormPage.currentState?.validate();

                        ///
                        if (mounted) {
                          setState(() {
                            idOrPhoneNumber = value;
                            selectedFormType = formType;
                          });
                        }
                      },
                    );
                  }).toList()

                    /// and OR in between the two input fields
                    ..insert(
                      MIDDLE_INDEX,
                      Container(
                        height: 100,
                        padding: const EdgeInsets.only(top: 34),
                        child: Text(
                          'OR',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w700,
                            fontSize: 20,
                            fontStyle: FontStyle.normal,
                          ),
                        ),
                      ),
                    )
                    ..insert(
                      HELP_TEXT_INDEX,
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
                    )
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.only(bottom: primaryPadding.bottom * 3, top: primaryPadding.top * 3),
              constraints: appConstraints,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.all(4),
                    child: Text(
                      'Reason',
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 16.0,
                      ),
                    ),
                  ),
                  InputDecorator(
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(primaryPadding.top),
                      ),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: reason,
                        hint: const Text('Select a reason.'),
                        isExpanded: true,
                        isDense: true,
                        items: reasonsForRequest
                            .map((opt) => DropdownMenuItem(
                                  value: opt,
                                  child: Text(opt),
                                ))
                            .toList(),
                        onChanged: (otp) {
                          if (mounted) {
                            setState(() {
                              reason = otp ?? 'Other';
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      InputFormSubmitButton(
          pageButtonName: 'Next',
          nextHandler: () {
            ///
            if (stackIndex == 0 && mounted) {
              ///
              if (_globalKeyFormPage.currentState?.validate() != true) return;

              ///
              setState(() {
                stackIndex = 1;
              });
            } else {
              ///
              if (reason == null) {
                ///
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Select a reason',
                      ),
                    ),
                  );

                return;
              }

              ///
              final wallet = context.read<StoreBloc>().state.walletData;

              if (wallet == null) {
                navigate(context, page: const AddPaymentMethodPage());

                return;
              }
              print(wallet);
              print('============');
              if ((wallet.balance ?? 0) < POINTS_PER_TRANSACTION) {
                showTopUpBottomSheet(context);

                return;
              }

              ///
              if (selectedFormType == FormType.idForm) {
                ///
                context.read<VerifySaBloc>()
                  ..add(const VerifySaEvent.apiHealthCheck())
                  ..add(
                    VerifySaEvent.verifyIdNumber(
                      idNumber: (idOrPhoneNumber ?? '').replaceAll(' ', ''),
                      reason: EnquiryReason.fromString(reason),
                      clientId: user?.id ?? user?.profileId ?? 'system',
                    ),
                  );
              } else if (selectedFormType == FormType.phoneNumberForm) {
                ///
                context.read<VerifySaBloc>()
                  ..add(const VerifySaEvent.apiHealthCheck())
                  ..add(
                    VerifySaEvent.contactTracing(
                      phoneNumber: (idOrPhoneNumber ?? '').replaceAll(' ', ''),
                      reason: EnquiryReason.fromString(reason),
                      clientId: user?.id ?? user?.profileId ?? 'system',
                    ),
                  );
              } else {
                ScaffoldMessenger.of(context)
                  ..clearSnackBars()
                  ..showSnackBar(
                    SnackBar(
                      backgroundColor: warningColor,
                      content: const Text(
                        'Unknown error occurred, Please try again later.',
                      ),
                    ),
                  );

                return;
              }

              ///
              navigate(
                context,
                page: SearchResultsPage(
                  type: selectedFormType ?? FormType.idForm,
                ),
                replaceCurrentPage: true,
              );
            }
          })
    ];
  }

  @override
  void dispose() {
    super.dispose();
  }
}

class InputFormSubmitButton extends StatelessWidget {
  final String? pageButtonName;

  final Function() nextHandler;

  const InputFormSubmitButton({
    super.key,
    this.pageButtonName,
    required this.nextHandler,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: appConstraints,
      child: BaseButton(
        key: UniqueKey(),
        onTap: nextHandler,
        label: pageButtonName ?? 'Next',
        color: neutralGrey,
        hasIcon: false,
        bgColor: primaryColor,
        buttonIcon: Icon(
          Icons.lock_outline,
          color: primaryColor,
        ),
        buttonSize: ButtonSize.small,
        hasBorderLining: false,
      ),
    );
  }
}

class PageCopy {
  static InputFormPageData idNumberForm = InputFormPageData.fromJson({
    'formLabel': 'ID Form',
    'formPlaceholderText': '000000 0000 000',
    'pageName': 'Verify ID Number',
    'inputLabel': 'SA ID Number',
    'pageDescription': formDescription,
    'pageButtonName': 'Send'
  });

  static InputFormPageData phoneNumberForm = InputFormPageData.fromJson({
    'formLabel': 'Phone Number Form',
    'formPlaceholderText': '000 000 0000',
    'inputLabel': 'Phone Number',
    'pageName': 'Verify Phone Number',
    'pageDescription': formDescription,
    'pageButtonName': 'Send'
  });
}

class InputFormPageData {
  InputFormPageData({
    this.formLabel,
    this.formPlaceholderText,
    this.pageName,
    this.inputLabel,
    this.pageDescription,
    this.pageButtonName,
  });

  InputFormPageData.fromJson(dynamic json) {
    formLabel = json['formLabel'];
    formPlaceholderText = json['formPlaceholderText'];
    inputLabel = json['inputLabel'];
    pageName = json['pageName'];
    pageDescription = json['pageDescription'];
    pageButtonName = json['pageButtonName'];
  }
  String? formLabel;
  String? formPlaceholderText;
  String? pageName;
  String? inputLabel;
  String? pageDescription;
  String? pageButtonName;

  InputFormPageData copyWith({
    String? formLabel,
    String? formPlaceholderText,
    String? pageName,
    String? inputLabel,
    String? pageDescription,
    String? pageButtonName,
  }) =>
      InputFormPageData(
        formLabel: formLabel ?? this.formLabel,
        formPlaceholderText: formPlaceholderText ?? this.formPlaceholderText,
        pageName: pageName ?? this.pageName,
        inputLabel: inputLabel ?? this.inputLabel,
        pageDescription: pageDescription ?? this.pageDescription,
        pageButtonName: pageButtonName ?? this.pageButtonName,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['formLabel'] = formLabel;
    map['formPlaceholderText'] = formPlaceholderText;
    map['pageName'] = pageName;
    map['inputLabel'] = inputLabel;
    map['pageDescription'] = pageDescription;
    map['pageButtonName'] = pageButtonName;
    return map;
  }
}

const formDescription =
    'We make sure that the ID number and/or phone number are checked against reliable databases, using the latest security methods for the best safety and trustworthiness.';
