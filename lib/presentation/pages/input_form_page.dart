import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:verified/globals.dart';
import 'package:verified/presentation/pages/search_options_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/error_warning_indicator.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/inputs/generic_input.dart';

final _globalKeyInputPage = GlobalKey<_InputFormPageState>(debugLabel: 'input-form-page-key');

class InputFormPage extends StatefulWidget {
  final FormType formType;
  InputFormPage({
    required this.formType,
  }) : super(key: _globalKeyInputPage);

  @override
  State<InputFormPage> createState() => _InputFormPageState();
}

class _InputFormPageState extends State<InputFormPage> {
  List<String> reasonsForRequest = ['E-commerce and Financial Transactions', 'b', 'c'];

  late String reason = reasonsForRequest.first;

  @override
  Widget build(BuildContext context) {
    final copy = widget.formType == FormType.idForm ? PageCopy.idNumberForm : PageCopy.phoneNumberForm;

    List<Widget> widgets = getWidgets(widget.formType);

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
                    onTap: Navigator.of(context).pop,
                    isLight: true),
                actions: [
                  ActionButton(
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

List<Widget> getWidgets(FormType formType) {
  final copy = formType == FormType.idForm ? PageCopy.idNumberForm : PageCopy.phoneNumberForm;

  return [
    Padding(
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
    ),
    Container(
        padding: EdgeInsets.only(bottom: primaryPadding.bottom, top: primaryPadding.top * 3),
        child: GenericInputField(
          hintText: copy.formPlaceholderText ?? 'Please type...',
          label: null,
          keyboardType: TextInputType.number,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
          onChange: (value) {},
        )),
    Container(
      padding: EdgeInsets.symmetric(vertical: primaryPadding.vertical),
      constraints: appConstraints,
      child: InputDecorator(
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(primaryPadding.top),
          ),
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _globalKeyInputPage.currentState?.reason ?? 'Other',
            hint: const Text('Select preferred communication method'),
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
    ),
    Container(
      constraints: appConstraints,
      child: BaseButton(
        key: UniqueKey(),
        onTap: () {},
        label: copy.pageButtonName ?? 'Submit',
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
    ),
  ];
}

enum FormType { idForm, phoneNumberForm }

class PageCopy {
  static InputFormPageData idNumberForm = InputFormPageData.fromJson({
    'formLabel': 'ID Form',
    'formPlaceholderText': 'ID Form Placeholder Text',
    'pageName': 'Verify ID Number',
    'pageDescription':
        'Please put your phone in front of your face Please put your phone in front put your phone in front of your face',
    'pageButtonName': 'Send'
  });

  static InputFormPageData phoneNumberForm = InputFormPageData.fromJson({
    'formLabel': 'Phone Number Form',
    'formPlaceholderText': 'Phone Number Form Placeholder Text',
    'pageName': 'Verify Phone Number',
    'pageDescription': 'Phone Number Page Description',
    'pageButtonName': 'Send'
  });
}

class InputFormPageData {
  InputFormPageData({
    this.formLabel,
    this.formPlaceholderText,
    this.pageName,
    this.pageDescription,
    this.pageButtonName,
  });

  InputFormPageData.fromJson(dynamic json) {
    formLabel = json['formLabel'];
    formPlaceholderText = json['formPlaceholderText'];
    pageName = json['pageName'];
    pageDescription = json['pageDescription'];
    pageButtonName = json['pageButtonName'];
  }
  String? formLabel;
  String? formPlaceholderText;
  String? pageName;
  String? pageDescription;
  String? pageButtonName;
  InputFormPageData copyWith({
    String? formLabel,
    String? formPlaceholderText,
    String? pageName,
    String? pageDescription,
    String? pageButtonName,
  }) =>
      InputFormPageData(
        formLabel: formLabel ?? this.formLabel,
        formPlaceholderText: formPlaceholderText ?? this.formPlaceholderText,
        pageName: pageName ?? this.pageName,
        pageDescription: pageDescription ?? this.pageDescription,
        pageButtonName: pageButtonName ?? this.pageButtonName,
      );

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['formLabel'] = formLabel;
    map['formPlaceholderText'] = formPlaceholderText;
    map['pageName'] = pageName;
    map['pageDescription'] = pageDescription;
    map['pageButtonName'] = pageButtonName;
    return map;
  }
}
