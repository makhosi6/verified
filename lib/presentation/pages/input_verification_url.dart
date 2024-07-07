import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/validation.dart';
import 'package:verified/globals.dart';
import 'package:verified/presentation/pages/verification_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/inputs/generic_input.dart';

final _globalKeyFormPage = GlobalKey<FormState>(debugLabel: 'input-verification-url-page-form-key');

class InputVerificationURL extends StatefulWidget {
  const InputVerificationURL({super.key});

  @override
  State<InputVerificationURL> createState() => _InputVerificationURLState();
}

class _InputVerificationURLState extends State<InputVerificationURL> {
  final _sliverAppBarMaxHeight = 90.0;
  bool hasInvalidInput = false;
  String? inputValue;
  String? uriUuidFragment;

  @override
  Widget build(BuildContext context) {
    var _widgets = _getWidgets(context);
    return Scaffold(
      body: Form(
        key: _globalKeyFormPage,
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              stretch: true,
              onStretchTrigger: () async {},
              surfaceTintColor: Colors.transparent,
              stretchTriggerOffset: 300.0,
              expandedHeight: _sliverAppBarMaxHeight,
              flexibleSpace: AppBar(
                automaticallyImplyLeading: true,
                title: const Text(
                  'Verified',
                ),
              ),
              leadingWidth: 80.0,
              leading: VerifiedBackButton(
                key: const Key('input-verification-url-page-back-btn'),
                isLight: true,
                onTap: Navigator.of(context).pop,
              ),
            ),
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (BuildContext context, int index) => UnconstrainedBox(
                  key: ValueKey(index),
                  child: Container(
                    width: MediaQuery.of(context).size.width - primaryPadding.horizontal,
                    constraints: appConstraints,
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
      ),
    );
  }

  List<Widget> _getWidgets(context) => [
        Padding(
          // padding: EdgeInsets.symmetric(horizontal: primaryPadding.horizontal / 3),
          padding: EdgeInsets.only(bottom: primaryPadding.bottom * 2, top: primaryPadding.top * 2),
          child: const Text(
            'Instantly confirm the legitimacy of personal information with our user-friendly app.',
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14.0,
            ),
            maxLines: 4,
            textAlign: TextAlign.center,
          ),
        ),
        GenericInputField(
          key: ValueKey(inputValue),
          hintText: 'Hint Text',
          initialValue: inputValue,
          autofocus: true,
          keyboardType: TextInputType.none,
          readOnly: true,
          onChange: (_) {},
          onTap: () => {},
          validator: (String? url) {
            ///
            var urlSegments =
                url.toString().split('/').where((segment) => UuidValidation.isValidUUID(fromString: segment));

            ///
            hasInvalidInput = false;
            uriUuidFragment = urlSegments.isNotEmpty ? urlSegments.first : null;

            ///

            if (urlSegments.isEmpty) {
              if (mounted) {
                setState(() {
                  hasInvalidInput = true;
                });
              }

              return 'The URL you entered is not valid.';
            }

            if (mounted) setState(() {});
            return null;
          },
          maxLines: 3,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              BaseButton(
                buttonIcon: const Icon(Icons.content_copy_rounded),
                hasIcon: true,
                buttonSize: ButtonSize.small,
                label: 'Paste URL',
                hasBorderLining: true,
                onTap: () async {
                  var data = await Clipboard.getData('text/plain');
                  if (mounted && data != null) {
                    setState(() {
                      inputValue = data.text.toString();
                    });
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) => _globalKeyFormPage.currentState?.validate());
                },
              ),
              if ((inputValue != null && hasInvalidInput) || hasInvalidInput)
                ActionButton(
                  tooltip: '',
                  innerPadding: const EdgeInsets.all(12.0),
                  icon: Icons.backspace_rounded,
                  hasBorderLining: true,
                  borderColor: Colors.red[100],
                  iconColor: errorColor,
                  onTap: () async {
                    if (mounted) {
                      setState(() {
                        hasInvalidInput = false;
                        inputValue = null;
                      });
                    }
                  },
                  bgColor: Colors.white,
                ),
              if (uriUuidFragment != null && hasInvalidInput == false)
                ActionButton(
                  tooltip: '',
                    innerPadding: const EdgeInsets.all(12.0),
                  icon: Icons.arrow_forward_ios_rounded,
                  hasBorderLining: true,
                  borderColor: Colors.green[100],
                  iconColor: primaryColor,
                  onTap: () => navigateToNamedRoute(
                    context,
                    arguments: VerificationPageArgs(
                      inputValue ?? '0000000-0000-0000-0000-00000000000',
                    ),
                    replaceCurrentPage: true,
                  ),
                  bgColor: Colors.white,
                ),
            ],
          ),
        )
      ];
}
