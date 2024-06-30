import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:verified/globals.dart';
import 'package:verified/infrastructure/native_scripts/main.dart';
import 'package:verified/presentation/pages/capture_verifiee_details_page.dart';
import 'package:verified/presentation/pages/home_page.dart';
import 'package:verified/presentation/pages/id_document_scanner_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/error_warning_indicator.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';

class ChooseDocumentPage extends StatefulWidget {
  const ChooseDocumentPage({super.key});

  @override
  State<ChooseDocumentPage> createState() => _ChooseDocumentPageState();
}

class _ChooseDocumentPageState extends State<ChooseDocumentPage> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        navigate(context, page: const HomePage(), replaceCurrentPage: true);
        return false;
      },
      child: Scaffold(
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
                  key: const Key('choose_document_type_page-back-btn'),
                  onTap: () => navigate(context, page: const HomePage(), replaceCurrentPage: true),
                  isLight: true,
                ),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, indx) {
                    var index = indx - 1;
    
                    if (index == -1) {
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: primaryPadding.horizontal,vertical: primaryPadding.vertical * 2),
                        child: Text(
                          'StakeWise brings solo stakers access to DeFi and liquidity! Mint osETH for your solo stake, and use Arbitrum, Aave, EigenLayer, and others',
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            color: neutralDarkGrey,
                            fontSize: 14.0,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
    
                    return UnconstrainedBox(
                      child: Container(
                        width: MediaQuery.of(context).size.width - primaryPadding.horizontal,
                        constraints: appConstraints,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: BaseButton(
                            key: ValueKey(DocumentType.values[index]),
                            onTap: () => navigate(
                              context,
                              page: IDDocumentScanner(
                                documentType: DocumentType.values[index],
                                onCapture: (File file, DetectSide side) {},
                                onMessage: (List<String> msgs) {},
                                onStateChanged: (CameraEventsState state) {},
                                onNext: (ctx) => navigate(ctx, page: CaptureVerifieeDetailsPage(), replaceCurrentPage: true),
                              ),
                              replaceCurrentPage: true,
                            ),
                            label: DocumentType.values[index].name,
                            buttonIcon: const Icon(Icons.verified_outlined),
                            buttonSize: ButtonSize.large,
                            hasBorderLining: true,
                          ),
                        ),
                      ),
                    );
                  },
                  childCount: DocumentType.values.length + 1, // header at index 0
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
