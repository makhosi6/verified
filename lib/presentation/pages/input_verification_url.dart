import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uuid/validation.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/globals.dart';
import 'package:verified/infrastructure/analytics/repository.dart';
import 'package:verified/presentation/pages/verification_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/inputs/generic_input.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
    var widgets = _getWidgets(context);
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
                      child: widgets[index],
                    ),
                  ),
                ),
                childCount: widgets.length,
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
            'Paste the verification link provided to you to proceed to the verification process.',
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
            VerifiedAppAnalytics.logActionTaken(VerifiedAppAnalytics.ACTION_VERIFICATION_VIA_URL, {'url': url});

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
                    VerifiedAppAnalytics.logActionTaken(
                        VerifiedAppAnalytics.ACTION_DID_PASTE_A_VERIFICATION_URL, {'url': inputValue, 'mode': 'paste'});
                  }
                  WidgetsBinding.instance.addPostFrameCallback((_) => _globalKeyFormPage.currentState?.validate());
                },
              ),
              if ((inputValue != null && hasInvalidInput) || hasInvalidInput)
                BaseButton(
                  buttonSize: ButtonSize.small,
                  label: '',
                  buttonIcon: Icon(
                    Icons.backspace_rounded,
                    color: errorColor,
                  ),
                  hasIcon: true,
                  hasBorderLining: true,
                  borderColor: Colors.red[100],
                  iconBgColor: Colors.white,
                  onTap: () async {
                    if (mounted) {
                      setState(() {
                        hasInvalidInput = false;
                        inputValue = null;
                      });
                    }
                  },
                  bgColor: Colors.white,
                ).iconOnly(context),
              if (uriUuidFragment != null && hasInvalidInput == false)
                BlocBuilder<StoreBloc, StoreState>(builder: (context, state) {
                  return BaseButton(
                    buttonIcon: Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: primaryColor,
                    ),
                    hasBorderLining: true,
                    label: '',
                    borderColor: Colors.green[100],
                    onTap: () {
                      var urlSegments = inputValue
                          .toString()
                          .split('/')
                          .where((segment) => UuidValidation.isValidUUID(fromString: segment));
                      if (urlSegments.isNotEmpty) {
                        context.read<StoreBloc>().add(StoreEvent.validateVerificationLink(urlSegments.first));
                        navigateToNamedRoute(
                          context,
                          arguments: VerificationPageArgs(
                            urlSegments.first,
                          ),
                          replaceCurrentPage: true,
                        );
                      } else {
                        ScaffoldMessenger.of(context)
                          ..clearSnackBars()
                          ..showSnackBar(
                            SnackBar(
                              showCloseIcon: true,
                              closeIconColor: const Color.fromARGB(255, 254, 226, 226),
                              duration: const Duration(seconds: 10),
                              content: const Text(
                                'Invalid verification link!',
                                style: TextStyle(
                                  color: Color.fromARGB(255, 254, 226, 226),
                                ),
                              ),
                              backgroundColor: errorColor,
                            ),
                          );
                      }
                    },
                    buttonSize: ButtonSize.small,
                    hasIcon: true,
                    bgColor: Colors.white,
                  ).iconOnly(context);
                }),
            ],
          ),
        )
      ];
}
