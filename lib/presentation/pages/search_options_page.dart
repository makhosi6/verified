import 'package:flutter/material.dart';
import 'package:verify_sa/presentation/pages/input_form_page.dart';
import 'package:verify_sa/presentation/theme.dart';
import 'package:verify_sa/presentation/utils/trigger_auth_bottom_sheet.dart';
import 'package:verify_sa/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verify_sa/presentation/widgets/buttons/base_buttons.dart';

class SearchOptionsPage extends StatelessWidget {
  const SearchOptionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _SearchOptionsPageContent(),
    );
  }
}

class _SearchOptionsPageContent extends StatelessWidget {
  const _SearchOptionsPageContent();

  @override
  Widget build(BuildContext context) {
    return Center(
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
                automaticallyImplyLeading: false,
                title: const Text('Verification'),
              ),
              actions: [
                ActionButton(
                  iconColor: Colors.black,
                  bgColor: Colors.white,
                  onTap: () => triggerAuthBottomSheet(context: context),
                  icon: Icons.person_2_outlined,
                ),
              ],
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: GestureDetector(
                onTap: () {},
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          //image
                          Container(
                            margin: const EdgeInsets.only(bottom: 20.0),
                            child: const Image(
                              image: AssetImage(
                                  "assets/images/12704419_4968099.jpg"),
                              height: 230.0,
                            ),
                          ),

                          ///header for the explainer
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            child: Text(
                              "Payment with QR Code",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 18.0,
                                fontStyle: FontStyle.normal,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),

                          ///and description for the explainer
                          Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 30.0),
                            child: Text(
                              "Please put your phone in front of your face Please put your phone in front put your phone in front of your face",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: neutralDarkGrey,
                                fontSize: 14.0,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ]),
                    SizedBox(
                      child: Column(
                        children: [
                          BaseButton(
                            key: UniqueKey(),
                            onTap: () {},
                            label: "Seek & Guide",
                            color: neutralGrey,
                            hasIcon: false,
                            bgColor: neutralYellow,
                            buttonIcon: Icon(
                              Icons.grain_outlined,
                              color: neutralYellow,
                            ),
                            buttonSize: ButtonSize.large,
                            hasBorderLining: false,
                          ),
                          BaseButton(
                            key: UniqueKey(),
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (BuildContext context) =>
                                      InputFormPage(
                                    formType: FormType.phoneNumberForm,
                                  ),
                                ),
                              );
                            },
                            label: "Learn Quick",
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
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
