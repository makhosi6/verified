// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/material.dart';
import 'package:verify_sa/helpers/logger.dart';

import 'package:verify_sa/presentation/pages/search_options_page.dart';
import 'package:verify_sa/presentation/theme.dart';
import 'package:verify_sa/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verify_sa/presentation/widgets/buttons/base_buttons.dart';
import 'package:verify_sa/presentation/widgets/inputs/generic_input.dart';

// ignore: must_be_immutable
class InputFormPage extends StatelessWidget {
  final FormType formType;
  InputFormPage({
    Key? key,
    required this.formType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 500.0),
          padding: primaryPadding,
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              SliverAppBar(
                stretch: true,
                onStretchTrigger: () async {},
                surfaceTintColor: Colors.transparent,
                stretchTriggerOffset: 300.0,
                expandedHeight: 90.0,
                flexibleSpace: AppBar(
                  automaticallyImplyLeading: true,
                  title: Text(
                    pageCopy[formType.name.toString()]?["pageName"] ?? "Search",
                  ),
                ),
                leadingWidth: 80.0,
                leading: VerifiedBackButton(
                    key: Key("${formType.name}-input-form-page-back-btn"),
                    onTap: Navigator.of(context).pop,
                    isLight: true),
                actions: [
                  ActionButton(
                    iconColor: Colors.black,
                    bgColor: Colors.white,
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute<void>(
                          builder: (BuildContext context) =>
                              const SearchOptionsPage(),
                        ),
                      );
                    },
                    icon: Icons.person_2_outlined,
                  ),
                ],
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) => _widgets[index],
                  childCount: _widgets.length,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ignore: prefer_final_fields
  late List<Widget> _widgets = getWidgets(formType);
}

List<Widget> getWidgets(FormType formType) {
  try {
    final copy = pageCopy[formType.name.toString()];
    if (copy == null || copy.isEmpty) return [];
    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30.0),
        child: Text(
          "${copy['pageDescription']}",
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: neutralDarkGrey,
            fontSize: 14.0,
          ),
          textAlign: TextAlign.left,
        ),
      ),
      Container(
        padding: const EdgeInsets.symmetric(vertical: 48.0),
        height: 300.0,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GenericInputField(
              label: "${copy['pageLabel']}",
              hintText: "${copy['formPlaceholderText']}",
              onChange: (String value) {},
            ),
            GenericInputField(
              label: 'Date of Birth',
              hintText: 'DD/MM/YYYY (31/12/2010)',
              onChange: (String value) {},
            ),
          ],
        ),
      ),
      BaseButton(
        key: UniqueKey(),
        onTap: () {},
        label: "${copy['pageButtonName']}",
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
    ];
  } catch (err) {
    verifiedErrorLogger<void>(err);
    return [];
  }
}

enum FormType { idForm, phoneNumberForm, sarsForm }

final pageCopy = {
  "idForm": {
    "formLabel": "ID Form",
    "formPlaceholderText": "ID Form Placeholder Text",
    "pageName": "Search by ID No",
    "pageDescription":
        "Please put your phone in front of your face Please put your phone in front put your phone in front of your face",
    "pageButtonName": "Search"
  },
  "phoneNumberForm": {
    "formLabel": "Phone Number Form",
    "formPlaceholderText": "Phone Number Form Placeholder Text",
    "pageName": "Search by Phone No",
    "pageDescription": "Phone Number Page Description",
    "pageButtonName": "Search"
  },
  "sarsForm": {
    "formLabel": "SARS Form",
    "formPlaceholderText": "SARS Form Placeholder Text",
    "pageName": "Search by SARS No",
    "pageDescription": "SARS Page Description",
    "pageButtonName": "Search"
  },
};
