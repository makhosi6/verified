import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:uuid/uuid.dart';
import 'package:verified/app_config.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/domain/models/communication_channels.dart';
import 'package:verified/domain/models/services_options_enum.dart';
import 'package:verified/domain/models/wallet.dart';

import 'package:verified/globals.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/presentation/pages/home_page.dart';
import 'package:verified/presentation/pages/top_up_page.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/data_view_item.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/popups/successful_action_popup.dart';

class ConfirmDetailsPage extends StatefulWidget {
  ConfirmDetailsPage({super.key});

  @override
  State<ConfirmDetailsPage> createState() => _ConfirmDetailsPageState();
}

class _ConfirmDetailsPageState extends State<ConfirmDetailsPage> {
  ///
  var serviceOptions = ServiceOptionsEnum.values.where((opt) => opt != ServiceOptionsEnum.all);

  @override
  Widget build(BuildContext context) {
    final capturedData = context.watch<StoreBloc>().state.searchPerson;
    final Map<String, dynamic> person = (capturedData?.toJson() ?? {})
      ..removeWhere((key, value) => (key == 'instanceId' || key == 'selectedServices' || value is List));
    final List<String> product = capturedData?.selectedServices ?? [];

    return BlocListener<StoreBloc, StoreState>(
        bloc: context.read<StoreBloc>(),
        listener: (context, state) {
          if (state.searchPersonHasError == true || state.searchPersonError != null) {
            ///
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  showCloseIcon: true,
                  closeIconColor: const Color.fromARGB(255, 254, 226, 226),
                  content: Text(
                    errorToString(state.searchPersonError),
                    style: const TextStyle(
                      color: Color.fromARGB(255, 254, 226, 226),
                    ),
                  ),
                  backgroundColor: errorColor,
                ),
              );

            ///
            Navigator.of(context)
              ..pop()
              ..pop()
              ..pop();
          }
        },
        child: Scaffold(
          body: Center(
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                SliverAppBar(
                  stretch: true,
                  onStretchTrigger: () async {},
                  surfaceTintColor: Colors.transparent,
                  stretchTriggerOffset: 300.0,
                  expandedHeight: 90.0,
                  flexibleSpace: AppBar(
                    automaticallyImplyLeading: true,
                    title: const Text('Confirm'),
                  ),
                  leadingWidth: 80.0,
                  leading: VerifiedBackButton(
                    key: const Key('captured-details-page-back-btn'),
                    onTap: () => Navigator.pop(context),
                    isLight: true,
                  ),
                  actions: const [],
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (BuildContext context, int index) => UnconstrainedBox(
                      child: Container(
                        width: MediaQuery.of(context).size.width - primaryPadding.horizontal,
                        constraints: appConstraints,
                        padding: EdgeInsets.only(bottom: primaryPadding.bottom * 3, top: primaryPadding.top * 3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: primaryPadding.horizontal),
                              child: Text(
                                'Before we proceed, take a moment to review all the details. If everything looks good, you\'re all set to continue!',
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                  color: neutralDarkGrey,
                                  fontSize: 14.0,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              width: 20,
                              height: 40,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(bottom: 0, left: 0),
                              child: RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: neutralDarkGrey,
                                    fontSize: 14.0,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: 'Details ',
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () => Navigator.of(context)
                                          ..pop()
                                          ..pop(),
                                      style: GoogleFonts.ibmPlexSans(
                                        color: darkerPrimaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' > ',
                                      style: GoogleFonts.ibmPlexSans(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' Options ',
                                      recognizer: TapGestureRecognizer()..onTap = () => Navigator.of(context).pop(),
                                      style: GoogleFonts.ibmPlexSans(
                                        color: darkerPrimaryColor,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' > ',
                                      style: GoogleFonts.ibmPlexSans(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    TextSpan(
                                      text: ' Confirm ',
                                      style: GoogleFonts.ibmPlexSans(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),

                            /// confirm details
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: primaryPadding.top),
                                    child: const Text(
                                      'Personal Details',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18.0,
                                        fontStyle: FontStyle.normal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: person.keys
                                            .map(
                                              (key) => _DataView(
                                                keyName: displayValuesForPerson[key] ?? key,
                                                value: person[key] ?? ' - ',
                                                withDivider: key != person.keys.last,
                                              ),
                                            )
                                            .whereType<_DataView>()
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            ///
                            const SizedBox(
                              height: 20,
                              width: 20,
                            ),

                            /// confirm page/category/product type
                            SizedBox(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(vertical: primaryPadding.top),
                                    child: const Text(
                                      'Selected Options',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 18.0,
                                        fontStyle: FontStyle.normal,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  Card(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: serviceOptions
                                            .map(
                                              (item) => _DataView(
                                                keyName: item.toString(),
                                                value: product.contains(item.toJson()) ||
                                                        item == ServiceOptionsEnum.identity_verification
                                                    ? 'Yes '
                                                    : ' - ',
                                                withDivider: serviceOptions.last != item,
                                              ),
                                            )
                                            .toList(),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            /// next button
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 40),
                                child: BaseButton(
                                    key: UniqueKey(),
                                    label: 'Confirm',
                                    color: neutralGrey,
                                    hasIcon: false,
                                    bgColor: primaryColor,
                                    buttonIcon: Icon(
                                      Icons.lock_outline,
                                      color: primaryColor,
                                    ),
                                    buttonSize: ButtonSize.large,
                                    hasBorderLining: false,
                                    onTap: () async {
                                      ///
                                      var wallet = context.read<StoreBloc>().state.walletData;
                                      final user = context.read<StoreBloc>().state.userProfileData;

                                      if (wallet == null) {
                                        wallet = Wallet(
                                            id: const Uuid().v4(), profileId: user?.id ?? user?.walletId ?? 'unknown');
                                        if (user != null) {
                                          context.read<StoreBloc>()
                                            ..add(StoreEvent.updateUserProfile(user.copyWith(walletId: wallet.id)))
                                            ..add(StoreEvent.createWallet(wallet));
                                        }
                                      }
                                      if (kDebugMode) {
                                        verifiedLogger(wallet);
                                        verifiedLogger('============');
                                      }
                                      if ((wallet.balance ?? 0) < POINTS_PER_TRANSACTION) {
                                        return await showTopUpBottomSheet(context);
                                      }

                                      /// send
                                      context.read<StoreBloc>().add(const StoreEvent.validateAndSubmit());

                                      await showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        barrierColor: const Color.fromARGB(171, 0, 0, 0),
                                        builder: (context) => _DonePopUp(),
                                      );
                                    }),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                    childCount: 1,
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  @override
  void dispose() {
    super.dispose();
  }
}

String errorToString(error) =>
    error.toString().replaceAll(':', '').replaceAll('Exception', '').replaceAll('Assertion', '');

class _DataView extends StatelessWidget {
  final String keyName;
  final String value;
  final bool withDivider;

  const _DataView({Key? key, required this.keyName, required this.value, required this.withDivider}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DataViewItem(keyName: keyName, value: value),
        if (withDivider)
          Divider(
            color: Colors.grey[400],
            indent: 0,
            endIndent: 0,
          ),
      ],
    );
  }
}

var displayValuesForPerson = {
  'name': 'Name',
  'idNumber': 'Id Number',
  'phoneNumber': 'Phone Number',
  'bankAccountNumber': 'Bank Account Number',
  'email': 'Email Address',
  'description': 'Description',
  'selectedServices': 'Selected Services',
};

class _DonePopUp extends StatefulWidget {
  const _DonePopUp({super.key});

  @override
  State<_DonePopUp> createState() => __DonePopUpState();
}

class __DonePopUpState extends State<_DonePopUp> {
  ///
  bool email = false;
  bool sms = false;

  ///
  @override
  Widget build(BuildContext context) {
    final person = context.watch<StoreBloc>().state.searchPerson;
    return SuccessfulActionModal(
      title: 'Created Successfully!',
      subtitle: 'Your verification has been successfully submitted! The person will be notified and will complete the required steps soon. You will receive updates once it\'s completed 🎉',
      nextAction: () {
        /// send communication to [person]
        context.read<StoreBloc>().add(StoreEvent.willSendNotificationAfterVerification(
            CommsChannels(sms: sms, email: email, instanceId: person?.instanceId ?? '')));

        ///
        Navigator.of(context)
          ..pop()
          ..pop()
          ..pop()
          ..pushAndRemoveUntil(
            MaterialPageRoute(builder: (_) => const HomePage()),
            (_) => false,
          ).catchError((error) {
            verifiedErrorLogger(error, StackTrace.current);
          }, test: (_) {
            return true;
          });
      },
      showDottedDivider: false,
      children: [
        ///
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'How would you like to notify the candidate?',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 18.0,
              fontStyle: FontStyle.normal,
            ),
            maxLines: 2,
            textAlign: TextAlign.center,
          ),
        ),

        ///
        CheckboxListTile(
          value: email,
          onChanged: (bool? value) {
            if (mounted) {
              setState(() {
                email = value ?? false;
              });
            }
          },
          title: const Text('Email'),
          subtitle: Text(
            "A verification link with instructions will be sent directly to ${person?.name ?? 'the verified individual'}'s email address ${((s) => s == null ? '' : '($s)')(person?.email)}",
          ),
          // isThreeLine: true,
        ),

        ///
        CheckboxListTile(
          value: sms,
          onChanged: (bool? value) {
            if (mounted) {
              setState(() {
                sms = value ?? false;
              });
            }
          },
          title: const Text('SMS'),
          subtitle: Text(
            "A verification link with instructions will be sent via text message to ${person?.name ?? 'the verified individual'}'s phone number ${((s) => s == null ? '' : '($s)')(person?.phoneNumber)}",
          ),
          // isThreeLine: true,
        ),
      ],
    );
  }
}
