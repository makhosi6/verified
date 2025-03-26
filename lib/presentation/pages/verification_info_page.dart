import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/globals.dart';
import 'package:verified/presentation/pages/verification_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';

class VerificationInfoPage extends StatelessWidget {
  const VerificationInfoPage({super.key});

  final _sliverAppBarMaxHeight = 90.0;

  @override
  Widget build(BuildContext context) {
    var _widgets = _getWidgets(context);
    return Scaffold(
      backgroundColor: darkerPrimaryColor,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            stretch: true,
            onStretchTrigger: () async {},
            surfaceTintColor: Colors.transparent,
            backgroundColor: darkerPrimaryColor,
            stretchTriggerOffset: 300.0,
            expandedHeight: _sliverAppBarMaxHeight,
            flexibleSpace: AppBar(
              backgroundColor: darkerPrimaryColor,
              automaticallyImplyLeading: true,
              title: Text(
                'Verified',
                style: TextStyle(color: neutralGrey),
              ),
            ),
            leadingWidth: 80.0,
            leading: VerifiedBackButton(
              key: const Key('veri-info-page-back-btn'),
              onTap: () {
                ScaffoldMessenger.of(context).clearMaterialBanners();
                Navigator.of(context).pop();
              },
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) => UnconstrainedBox(
                key: ValueKey(index),
                child: Container(
                  width: MediaQuery.of(context).size.width - primaryPadding.horizontal,
                  constraints: appConstraints,
                  padding: EdgeInsets.only(bottom: primaryPadding.bottom * 2, top: primaryPadding.top * 2),
                  child: Center(
                    child: _widgets[index],
                  ),
                ),
              ),
              childCount: _widgets.length,
            ),
          ),
        ],
      ),
    );
  }
}

List<Widget> _getWidgets(BuildContext context) => [
      Padding(
        padding: EdgeInsets.symmetric(horizontal: primaryPadding.horizontal / 3),
        child: Text(
          'We’re about to start your identity verification! In the next steps, you’ll need to use your camera to scan your face and ID documents. This helps us securely confirm your identity and keep your information safe. It’s quick, easy, and ensures a smooth process for you. Let’s get started when you’re ready!',
          style: TextStyle(
            fontWeight: FontWeight.w400,
            color: neutralGrey,
            fontSize: 14.0,
          ),
          maxLines: 4,
          textAlign: TextAlign.center,
        ),
      ),
      Container(
        padding: const EdgeInsets.only(top: 4),
        child: Image.asset(
          'assets/images/face-detection.png',
          key: const Key('face-id-animation'),
          height: 280,
          fit: BoxFit.fitHeight,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(
          bottom: 12.0,
        ),
        child: BaseButton(
          key: UniqueKey(),
          onTap: () {
            bool? invalidateVerificationLink = context.read<StoreBloc>().state.invalidateVerificationLink;

            if (invalidateVerificationLink == true) {
              ///
              ScaffoldMessenger.of(context)
                ..clearMaterialBanners()
                ..showMaterialBanner(
                  MaterialBanner(
                    padding: primaryPadding,
                    content: const Text(
                      'Invalid Link: The verification link you used is invalid.',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                      maxLines: 2,
                    ),
                    leading: const Icon(
                      Icons.info_outline_rounded,
                      size: 24,
                      color: Colors.white,
                    ),
                    backgroundColor: errorColor,
                    actions: [
                      IconButton(
                        onPressed: ScaffoldMessenger.of(context).clearMaterialBanners,
                        icon: const Icon(
                          Icons.close_sharp,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                );
              return;
            }

            final args = ModalRoute.of(context)?.settings.arguments as VerificationPageArgs?;
            navigateToNamedRoute(context, arguments: args, routeName: '/secure', replaceCurrentPage: true);
          },
          label: 'Get started',
          color: neutralGrey,
          hasIcon: false,
          buttonIcon: null,
          bgColor: primaryColor,
          buttonSize: ButtonSize.large,
          hasBorderLining: false,
        ),
      ),
    ];
