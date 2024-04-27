import 'dart:math';

import 'package:flutter/material.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/error_warning_indicator.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';

class LearnMorePage extends StatefulWidget {
  const LearnMorePage({super.key});

  @override
  State<LearnMorePage> createState() => _LearnMorePageState();
}

class _LearnMorePageState extends State<LearnMorePage> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    ///
    return Scaffold(
        backgroundColor: const Color(0xFFF5FCF8),
        body: Center(
          child: CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: <Widget>[
              const AppErrorWarningIndicator(),
              SliverAppBar(
                stretch: true,
                onStretchTrigger: () async {},
                surfaceTintColor: Colors.transparent,
                stretchTriggerOffset: 280.0,
                expandedHeight: 280.0,
                title: const Text(
                  'Learn More',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    width: MediaQuery.of(context).size.width - 16,
                    color: darkerPrimaryColor,
                    child: SingleChildScrollView(
                      reverse: true,
                      clipBehavior: Clip.none,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            padding: primaryPadding.copyWith(left: primaryPadding.left, right: primaryPadding.right),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Help tips',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 18.0,
                                        fontStyle: FontStyle.normal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      'Explainer for help tips...',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w400,
                                        color: Colors.white,
                                        fontStyle: FontStyle.italic,
                                        fontSize: 14.0,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: primaryPadding.copyWith(bottom: 0, top: 0),
                            child: const ListOfHelpTipsTopics(),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                leadingWidth: 80.0,
                leading: VerifiedBackButton(
                  key: const Key('learn-more-page-back-btn'),
                  onTap: Navigator.of(context).pop,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  childCount: 1,
                  (BuildContext context, _) => Container(
                    color: darkerPrimaryColor,
                    child: BottomSheet(
                        onClosing: () {},
                        showDragHandle: true,
                        constraints: BoxConstraints().copyWith(maxHeight: MediaQuery.of(context).size.height - 300.0),
                        animationController: BottomSheet.createAnimationController(this),
                        enableDrag: false,
                        builder: (BuildContext context) {
                          return Container(
                            
                            // constraints: appConstraints,
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height - 300.0,
                            child: SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              padding: EdgeInsets.symmetric(horizontal: primaryPadding.horizontal / 2),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ///
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.only(bottom: primaryPadding.bottom / 2),
                                        child: const Text(
                                          'Read Instructions Please',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 18.0,
                                            fontStyle: FontStyle.normal,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.only(bottom: primaryPadding.bottom / 2),
                                        child: Text(
                                          'Explainer for help tips...',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            color: neutralDarkGrey,
                                            fontSize: 16.0,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  ///
                                  Scrollbar(
                                    child: ListView.builder(
                                      physics: const NeverScrollableScrollPhysics(),
                                      shrinkWrap: true,
                                      itemCount: 190,
                                      itemBuilder: (context, index) {
                                        return ExpansionTile(
                                          key: Key('expansion_tile_$index'),
                                          tilePadding: const EdgeInsets.all(0.0),
                                          backgroundColor: Colors.grey[100],
                                          collapsedBackgroundColor: Colors.transparent,
                                          initiallyExpanded: index == 0,
                                          title: Text(
                                            " accountSettings[index]['text'] as String $index",
                                            style: const TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16.0,
                                              fontStyle: FontStyle.normal,
                                            ),
                                            textAlign: TextAlign.start,
                                          ),
                                          children: List.generate(
                                            3,
                                            (_index) => Text('RUNNING $_index'),
                                          ),
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                            ),
                          );
                        }),
                  ),
                ),
              )
            ],
          ),
        ));
  }
}

class ListOfHelpTipsTopics extends StatelessWidget {
  const ListOfHelpTipsTopics({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: primaryPadding.vertical / 2),
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: 90,
        itemBuilder: (context, index) => Container(
          width: 160,
          height: 100,
          margin: EdgeInsets.only(right: primaryPadding.right / 2),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white70),
            borderRadius: BorderRadius.circular(20),
            color: Color.fromARGB(Random().nextInt(255), 0, 0, 0),
          ),
        ),
      ),
    );
  }
}
