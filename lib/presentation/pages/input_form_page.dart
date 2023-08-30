import 'package:flutter/material.dart';
import 'package:verify_sa/presentation/theme.dart';
import 'package:verify_sa/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verify_sa/presentation/widgets/buttons/base_buttons.dart';
import 'package:verify_sa/presentation/widgets/inputs/generic_input.dart';

import 'landing_page.dart';

class InputFormPage extends StatelessWidget {
  const InputFormPage({super.key});

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
                  centerTitle: false,
                  title: const Text('Search by Name'),
                ),
                leading: Container(
                  margin: const EdgeInsets.only(left: 12.0),
                  child: ActionButton(
                    iconColor: Colors.black,
                    borderColor: neutralGrey,
                    bgColor: Colors.white,
                    onTap: () => Navigator.pop(context),
                    icon: Icons.arrow_back_ios_new_rounded,
                    padding: const EdgeInsets.all(0.0),
                  ),
                ),
                actions: [
                  ActionButton(
                    iconColor: Colors.black,
                    bgColor: Colors.white,
                    onTap: () {
                      Navigator.of(context)
                        ..pop()
                        ..pushReplacement(
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) =>
                                const LandingPage(),
                          ),
                        );
                    },
                    icon: Icons.settings,
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
}

var _widgets = [
  Padding(
    padding: const EdgeInsets.symmetric(horizontal: 30.0),
    child: Text(
      "Please put your phone in front of your face Please put your phone in front put your phone in front of your face",
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
          label: 'Name',
          hintText: 'Type the Name',
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
    label: "Search",
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

enum FormType { idForm, phoneNumberForm, sarsReform }
