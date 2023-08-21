import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verify_sa/pages/account_page.dart';
import 'package:verify_sa/theme.dart';
import 'package:verify_sa/widgets/bank_card/suggested_topup.dart';
import 'package:verify_sa/widgets/buttons/app_bar_action_btn.dart';
import 'package:verify_sa/widgets/buttons/base_buttons.dart';
import 'package:verify_sa/widgets/profile/balance.dart';

class LandingPage extends StatelessWidget {
  const LandingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: _LandingPageContent(),
    );
  }
}

class _LandingPageContent extends StatelessWidget {
  const _LandingPageContent();

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
                centerTitle: false,
                title: const Text('Face ID Verification'),
              ),
              actions: [
                ActionButton(
                  iconColor: Colors.black,
                  bgColor: Colors.white,
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      builder: (context) => SingleChildScrollView(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 20.0),
                          child: Column(
                            children: [
                              /// sign in text

                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10.0),
                                child: Column(
                                  children: [
                                    ///
                                    const Text(
                                      "Payment with QR Code",
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18.0,
                                        fontStyle: FontStyle.normal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 30.0),
                                      child: RichText(
                                        text: TextSpan(
                                            style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              color: neutralDarkGrey,
                                              fontSize: 14.0,
                                            ),
                                            children: [
                                              const TextSpan(
                                                text:
                                                    "Enter your email and we will send you a link to reset your password. New to Wpay? ",
                                              ),
                                              TextSpan(
                                                  text: "Sign Up",
                                                  recognizer:
                                                      TapGestureRecognizer()
                                                        ..onTap = () => {},
                                                  style:
                                                      GoogleFonts.ibmPlexSans(
                                                    fontWeight: FontWeight.w600,
                                                    decoration: TextDecoration
                                                        .underline,
                                                    color: darkerPrimaryColor,
                                                  )),
                                              const TextSpan(text: ".")
                                            ]),
                                        textAlign: TextAlign.center,
                                      ),
                                    )
                                  ],
                                ),
                              ),

                              ///buttons
                              BaseButton(
                                key: UniqueKey(),
                                onTap: () {},
                                label: "Login with Google",
                                buttonIcon: const Image(
                                  image: AssetImage("assets/icons/google.png"),
                                ),
                                buttonSize: ButtonSize.large,
                                hasBorderLining: true,
                              ),
                              BaseButton(
                                key: UniqueKey(),
                                onTap: () {},
                                label: "Login with Facebook",
                                buttonIcon: const Image(
                                  image:
                                      AssetImage("assets/icons/facebook.png"),
                                ),
                                buttonSize: ButtonSize.large,
                                hasBorderLining: true,
                              ),

                              BaseButton(
                                key: UniqueKey(),
                                onTap: () {},
                                label: "Login with Apple",
                                buttonIcon: const Image(
                                  image: AssetImage("assets/icons/apple.png"),
                                ),
                                buttonSize: ButtonSize.large,
                                hasBorderLining: true,
                              ),

                              BaseButton(
                                key: UniqueKey(),
                                onTap: () {},
                                label: "Login with Microsoft",
                                buttonIcon: const Image(
                                  image:
                                      AssetImage("assets/icons/microsoft.png"),
                                ),
                                buttonSize: ButtonSize.large,
                                hasBorderLining: true,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  icon: Icons.person_2_outlined,
                ),
                ActionButton(
                  iconColor: Colors.black,
                  bgColor: Colors.white,
                  onTap: () {
                    showModalBottomSheet<void>(
                      context: context,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: Container(
                            margin:
                                const EdgeInsets.symmetric(horizontal: 16.0),
                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                            child: Column(
                              children: [
                                const Balance(title: "Top up you account"),
                                Divider(
                                  color: Colors.grey[400],
                                  indent: 0,
                                  endIndent: 0,
                                ),
                                SuggestedTopUp(
                                  key: UniqueKey(),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  icon: Icons.settings,
                ),
              ],
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) => const AccountPage(),
                    ),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: _list,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

var _list = [
  Column(mainAxisAlignment: MainAxisAlignment.start, children: [
    //image
    Container(
      margin: const EdgeInsets.only(bottom: 20.0),
      child: const Image(
        image: AssetImage("assets/images/12704419_4968099.jpg"),
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
      padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
            Icons.grain_rounded,
            color: neutralYellow,
          ),
          buttonSize: ButtonSize.large,
          hasBorderLining: false,
        ),
        BaseButton(
          key: UniqueKey(),
          onTap: () {},
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
];
