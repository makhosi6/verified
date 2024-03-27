// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:carousel_indicator/carousel_indicator.dart';
import 'package:flutter/material.dart';

import 'package:verified/globals.dart';
import 'package:verified/presentation/theme.dart';
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

    ///
    WidgetsBinding.instance.addPostFrameCallback((_) {
      try {
        showModalBottomSheet(
          context: context,
          barrierColor: Colors.transparent,
          transitionAnimationController: BottomSheet.createAnimationController(this),
          isDismissible: false,
          enableDrag: false,
          isScrollControlled: true,
          builder: (context) => GestureDetector(
            onVerticalDragStart: (_) {},
            onHorizontalDragStart: (_) {},
            child: BottomSheet(
                onClosing: () {},
                showDragHandle: true,
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
                            currentTutorial.title ?? '',
                            style: const TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 18.0,
                              fontStyle: FontStyle.normal,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          ////
                          Text(
                            currentTutorial.body ?? '',
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
                            label: 'Next',
                            onTap: () {
                              var nextIndex = index + 1;
                              if (mounted && index <= indexMax && (nextIndex != index) && nextIndex <= indexMax) {
                                setState(() {
                                  index++;
                                });
                              }
                            },
                          )
                        ],
                      ),
                    ),
                  );
                }),
          ),
        );
      } catch (err) {
        print('NO BOTTOMSHEET EVENTS, $err');
      }
    });

    //
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final bottomSheetTop = screenHeight - 320;
    final windowSpace = screenHeight - bottomSheetTop;

    ///
    return Scaffold(
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
                        margin: const EdgeInsets.only(top: 100, right: 50),
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
                      child: index > 1
                          ? FlutterLogo(
                              size: 200 + index.toDouble(),
                              key: Key('illust_$index'),
                            )
                          : Container(
                              margin: const EdgeInsets.only(bottom: 20.0),
                              child: const Image(
                                image: AssetImage('assets/images/12704419_4968099.jpg'),
                                height: 230.0,
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
            ),
          ],
        ),
      ),
    );
  }
}

final tutorials = <HowToTutorial>[
  HowToTutorial(
    title: 'Fastest payment',
    body: 'I have a problem with this BottomSheet, it works fine but as soon as I tap on it, I will get an error',
    index: 0,
  ),
  HowToTutorial(
    title: 'Safest Payment',
    body: 'I have a problem with this BottomSheet, it works fine but as soon as I tap on it, I will get an error',
    index: 1,
  ),
  HowToTutorial(
    title: 'Pay Anything',
    body: 'I have a problem with this BottomSheet, it works fine but as soon as I tap on it, I will get an error',
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
