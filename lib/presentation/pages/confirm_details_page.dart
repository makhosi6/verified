import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verified/application/search_request/search_request_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/domain/models/help_ticket.dart';
import 'package:verified/domain/models/services_options_enum.dart';

import 'package:verified/globals.dart';
import 'package:verified/presentation/pages/home_page.dart';
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
    final capturedData = context.watch<SearchRequestBloc>().state.person;
    final Map<String, dynamic> person = (capturedData?.toJson() ?? {})
      ..removeWhere((key, value) => (key == 'selectedServices' || value is List));
    final List<String> product = capturedData?.selectedServices ?? [];

    return BlocListener<SearchRequestBloc, SearchRequestState>(
        listener: (context, state) {
          if (state.hasError == true || state.error != null) {
            ///
            ScaffoldMessenger.of(context)
              ..clearSnackBars()
              ..showSnackBar(
                SnackBar(
                  showCloseIcon: true,
                  closeIconColor: const Color.fromARGB(255, 254, 226, 226),
                  content: Text(
                    errorToString(state.error),
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
                    key: const Key('capture-details-page-back-btn'),
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
                                'Instantly confirm the legitimacy of personal information with our user-friendly app.',
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
                                      /// send
                                      context
                                          .read<SearchRequestBloc>()
                                          .add(const SearchRequestEvent.validateAndSubmit());

                                      await showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        barrierColor: const Color.fromARGB(171, 0, 0, 0),
                                        builder: (context) => const _DonePopUp(),
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
    final person = context.watch<SearchRequestBloc>().state.person;
    return SuccessfulActionModal(
      title: 'Action & Done',
      subtitle: 'Your Action of has been successfully processed. Thank you for your top-up! 🎉',
      nextAction: () {
        /// send communication to [person]
        context.read<StoreBloc>().add(StoreEvent.updateTicket(HelpTicket.fromJson({})));

        ///
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomePage()),
          (_) => false,
        );
      },
      showDottedDivider: false,
      children: [
        ///
        Padding(
          padding: EdgeInsets.only(left: primaryPadding.left),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Choose how you want to share:',
                style: GoogleFonts.dmSans(
                  color: Theme.of(context).textTheme.bodyMedium?.color ??
                      Theme.of(context).listTileTheme.subtitleTextStyle?.color,
                  fontSize: 18,
                  decoration: TextDecoration.underline,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox.shrink()
            ],
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
