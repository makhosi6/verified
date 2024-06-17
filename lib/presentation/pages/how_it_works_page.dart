// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:verified/globals.dart';
import 'package:verified/presentation/pages/search_options_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';

class HowItWorksPage extends StatefulWidget {
  const HowItWorksPage({super.key});

  @override
  State<HowItWorksPage> createState() => _HowItWorksPageState();
}

class _HowItWorksPageState extends State<HowItWorksPage> with TickerProviderStateMixin {
  //
  num index = 0;

  //
  @override
  Widget build(BuildContext context) {
    final indexMax = tutorials.length - 1;
    const indexMin = 0;
    final tutorialIndex = (index > indexMax) ? indexMax : index;
    final currentTutorial = tutorials.firstWhere((t) => t.index == tutorialIndex);
    //
    final screenHeight = MediaQuery.of(context).size.height;
    final topSafeArea = MediaQuery.of(context).padding.top;
    final bottomSafeArea = MediaQuery.of(context).padding.bottom;
    final screenWidth = MediaQuery.of(context).size.width;
    final magicNumber = screenHeight * 0.3 > 279 + 90 ? 279 : screenHeight * 0.3;
    final bottomSheetTop = screenHeight - (magicNumber > 210 ? 300 : 320);
    final windowSpace = screenHeight - bottomSheetTop;

    ///
    final illustrationPath = (index == 0)
        ? 'assets/images/load_credits.png'
        : (index == 1)
            ? 'assets/images/face_id.png'
            : 'assets/images/scan_to_verify.png';

    ///
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: darkerPrimaryColor,
        body: Container(
          color: darkerPrimaryColor,
          height: screenHeight,
          child: Column(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                height: bottomSheetTop,
                child: Stack(
                  children: [
                    /// skip text button
                    Align(
                      alignment: Alignment.topRight,
                      child: Container(
                          margin: EdgeInsets.only(top: 20 + topSafeArea, right: 50),
                          child: InkWell(
                            onTap: Navigator.of(context).pop,
                            child: const Text(
                              'Skip',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          )),
                    ),

                    /// illustrator
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 100),
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 20.0),
                          child: Image(
                            image: AssetImage(illustrationPath),
                          ),
                        ),
                      ),
                    ),

                    /// Progress Indicator
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CarouselIndicator(
                        count: tutorials.length,
                        index: tutorialIndex.toInt(),
                      ),
                    ),
                  ],
                ),
              ),

              /// space below the bottom_sheet
              Container(
                height: windowSpace,
                width: MediaQuery.of(context).size.width,
                color: Colors.transparent,
                child: BottomSheet(
                    onClosing: () {},
                    showDragHandle: TargetPlatform.android != defaultTargetPlatform,
                    constraints: appConstraints.copyWith(maxHeight: 300),
                    animationController: BottomSheet.createAnimationController(this),
                    enableDrag: false,
                    builder: (BuildContext context) {
                      return Container(
                        constraints: appConstraints,
                        decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20.0),
                            topRight: Radius.circular(20.0),
                          ),
                        ),
                        width: MediaQuery.of(context).size.width,
                        height: 279,
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: primaryPadding.horizontal),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ///
                              Text(
                                currentTutorial.title ?? 'Instant Background Check, Done right',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 18.0,
                                  fontStyle: FontStyle.normal,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              ////
                              Text(
                                currentTutorial.body ??
                                    'Get your verification results immediately for seamless access to services.',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: neutralDarkGrey,
                                  fontSize: 14.0,
                                ),
                                textAlign: TextAlign.center,
                              ),

                              ///
                              BaseButton(
                                hasBorderLining: false,
                                buttonIcon: null,
                                buttonSize: ButtonSize.large,
                                color: Colors.white,
                                hasIcon: false,
                                bgColor: primaryColor,
                                label: index == indexMax ? 'Get Started' : 'Next',
                                onTap: () {
                                  var nextIndex = index + 1;
                                  if (mounted && index <= indexMax && (nextIndex != index) && nextIndex <= indexMax) {
                                    setState(() {
                                      index++;
                                    });
                                  } else {
                                    navigate(context, page: const SearchOptionsPage(), replaceCurrentPage: true);
                                  }
                                },
                              )
                            ],
                          ),
                        ),
                      );
                    }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final tutorials = <HowToTutorial>[
  HowToTutorial(
    title: 'Load Money',
    body: 'Easily fund your account with credits. Add as little as R30 to get started',
    index: 0,
  ),
  HowToTutorial(
    title: 'Instant Background Check',
    body:
        'Enter a phone number or ID for verification, and get immediate confirmation of legitimacy. Accuracy and trust at your fingertips.',
    index: 1,
  ),
  HowToTutorial(
    title: 'Get Instant Results',
    body: 'Obtain your verification outcome instantly. Ensure accuracy and trust in seconds',
    index: 2,
  )
];

class HowToTutorial {
  int? index;
  String? title;
  String? body;

  HowToTutorial({
    required this.title,
    required this.body,
    required this.index,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{'body': body, 'title': title, 'index': index};
  }

  factory HowToTutorial.fromMap(Map<String, dynamic> map) {
    return HowToTutorial(
      body: map['body'],
      index: map['index'],
      title: map['title'],
    );
  }

  String toJson() => json.encode(toMap());

  factory HowToTutorial.fromJson(String source) => HowToTutorial.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'HowToTutorial(title: $title,body: $body, index: $index)';

  HowToTutorial copyWith({
    int? index,
    String? title,
  }) {
    return HowToTutorial(
      index: index ?? this.index,
      title: title ?? this.title,
      body: title ?? this.body,
    );
  }
}
