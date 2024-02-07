import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rsa_id_number/rsa_id_number.dart';
import 'package:verified/app_config.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/application/verify_sa/verify_sa_bloc.dart';
import 'package:verified/domain/models/enquiry_reason.dart';
import 'package:verified/domain/models/form_type.dart';

import 'package:verified/globals.dart';
import 'package:verified/presentation/pages/add_payment_method_page.dart';
import 'package:verified/presentation/pages/search_options_page.dart';
import 'package:verified/presentation/pages/search_results_page.dart';
import 'package:verified/presentation/pages/top_up_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/error_warning_indicator.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/utils/verified_input_formatter.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/inputs/generic_input.dart';

final _globalKeyInputPage = GlobalKey<_InputFormPageState>(debugLabel: 'input-form-page-key');
final _globalKeyFormPage = GlobalKey<FormState>(debugLabel: 'input-form-key');

class InputFormPage extends StatefulWidget {
  final FormType formType;
  InputFormPage({
    required this.formType,
  }) : super(key: _globalKeyInputPage);

  @override
  State<InputFormPage> createState() => _InputFormPageState();
}

class _InputFormPageState extends State<InputFormPage> {
  List<String> reasonsForRequest = EnquiryReason.values.map((reason) => reason.value).toList();

  String? reason;

  String? idOrPhoneNumber;

  int stackIndex = 0;

  @override
  Widget build(BuildContext context) {
    final copy = widget.formType == FormType.idForm ? PageCopy.idNumberForm : PageCopy.phoneNumberForm;

    List<Widget> widgets = getWidgets(context, formType: widget.formType, stackIndex: stackIndex);

    return Scaffold(
      body: Center(
        child: Container(
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
                  title: Text(
                    copy.pageName ?? 'Search',
                  ),
                ),
                leadingWidth: 80.0,
                leading: VerifiedBackButton(
                  key: Key('${widget.formType.name}-input-form-page-back-btn'),
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
                actions: [
                  ActionButton(
                    key: const Key('go-to-search-btn'),
                    tooltip: 'Go to Search Page',
                    iconColor: Colors.black,
                    bgColor: Colors.white,
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) => const SearchOptionsPage(),
                        ),
                      );
                    },
                    icon: Icons.person_2_outlined,
                  ),
                ],
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
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}

List<Widget> getWidgets(BuildContext context, {required FormType formType, required int stackIndex}) {
  bool isIdNumber = formType == FormType.idForm;
  final copy = isIdNumber ? PageCopy.idNumberForm : PageCopy.phoneNumberForm;
  final inputLength = isIdNumber ? 13 : 10;
  final inputMask = isIdNumber ? '000000 0000 000' : '000 000 0000';
  final keyboardType = isIdNumber ? TextInputType.number : TextInputType.phone;
  final validator = isIdNumber ? validateIdNumber : validateMobile;

  return [
    BlocBuilder<VerifySaBloc, VerifySaState>(
      builder: (context, state) {
        return Padding(
          padding: EdgeInsets.symmetric(horizontal: primaryPadding.horizontal),
          child: Text(
            copy.pageDescription ?? 'Please type a phone/id number and click send to verify.',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              color: neutralDarkGrey,
              fontSize: 14.0,
            ),
            textAlign: TextAlign.center,
          ),
        );
      },
    ),
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
            padding: EdgeInsets.only(bottom: primaryPadding.bottom * 3, top: primaryPadding.top * 3),
            child: Form(
              key: _globalKeyFormPage,
              child: GenericInputField(
                key: ValueKey(copy.inputLabel),
                initialValue: _globalKeyInputPage.currentState?.idOrPhoneNumber,
                hintText: copy.formPlaceholderText ?? 'Please type...',
                label: copy.inputLabel ?? '',
                autofocus: true,
                keyboardType: keyboardType,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(inputLength),
                  VerifiedTextInputFormatter(mask: inputMask)
                ],
                validator: validator,
                onChange: (value) {
                  ///
                  _globalKeyFormPage.currentState?.validate();

                  ///
                  if (_globalKeyInputPage.currentState?.mounted == true) {
                    _globalKeyInputPage.currentState?.setState(() {
                      _globalKeyInputPage.currentState?.idOrPhoneNumber = value;
                    });
                  }
                },
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
                      value: _globalKeyInputPage.currentState?.reason,
                      hint: const Text('Select a reason.'),
                      isExpanded: true,
                      isDense: true,
                      items: _globalKeyInputPage.currentState?.reasonsForRequest
                          .map((opt) => DropdownMenuItem(
                                value: opt,
                                child: Text(opt),
                              ))
                          .toList(),
                      onChanged: (reason) => {
                        if (_globalKeyInputPage.currentState?.mounted == true)
                          {
                            _globalKeyInputPage.currentState?.setState(() {
                              _globalKeyInputPage.currentState?.reason = reason ?? 'Other';
                            })
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
        pageButtonName: stackIndex == 0 ? 'Next' : copy.pageButtonName,
        nextHandler: () {
          ///
          if (stackIndex == 0 && _globalKeyInputPage.currentState?.mounted == true) {
            ///
            if (_globalKeyFormPage.currentState?.validate() != true) return;

            ///
            _globalKeyInputPage.currentState?.setState(() {
              _globalKeyInputPage.currentState?.stackIndex = 1;
            });
          } else {
            ///
            if (_globalKeyInputPage.currentState?.reason == null) {
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
            VerifySaEvent Function(String idNumber, EnquiryReason reason) fetchDataEvent =
                formType == FormType.idForm ? VerifySaEvent.verifyIdNumber : VerifySaEvent.contactTracing;

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
            context.read<VerifySaBloc>()
              ..add(const VerifySaEvent.apiHealthCheck())
              ..add(
                fetchDataEvent(
                  _globalKeyInputPage.currentState!.idOrPhoneNumber!,
                  EnquiryReason.fromString(_globalKeyInputPage.currentState?.reason),
                ),
              );

            ///
            navigate(
              context,
              page: SearchResultsPage(
                type: formType,
              ),
              replaceCurrentPage: true,
            );
          }
        })
  ];
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

String? validateIdNumber(String? idNumber) {
  //
  if (idNumber == null || idNumber.isEmpty) {
    return 'Please enter a SA Id Number';
  }

  //
  if (!RsaIdValidator.isValid(idNumber.replaceAll(' ', ''))) {
    return 'Please enter a valid SA Id Number';
  }

  return null;
}

String? validateMobile(String? value) {
  // Pattern for validating a phone number
  String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
  RegExp regExp = RegExp(pattern);

  // Check if the field is empty
  if (value == null || value.isEmpty) {
    return 'Please enter a mobile number';
  }

  // Allow SA codes only
  if (value.startsWith('+') && !value.startsWith('+27')) {
    return 'Invalid country code(+27) - South African Numbers only';
  }

  // Example of disallowing sequential/repeated numbers
  if (RegExp(r'(.)\1{3}').hasMatch(value)) {
    return 'Invalid mobile number (sequential/repeated digits detected)';
  }

  // Check if the phone number matches the regular expression
  if (!regExp.hasMatch(value.replaceAll(' ', ''))) {
    return 'Please enter a valid mobile number';
  }

  // //Validate length
  // if (value.replaceAll(' ', '').length <= 9) {
  //   return 'A valid phone number has 10 digits';
  // }

  return null;
}
