import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_asset_picker/gallery_asset_picker.dart';
import 'package:intl/intl.dart';
import 'package:verified/app_config.dart';
import 'package:verified/application/appbase/appbase_bloc.dart';
import 'package:verified/application/auth/auth_bloc.dart';
import 'package:verified/application/store/store_bloc.dart';
import 'package:verified/domain/models/user_profile.dart';
import 'package:verified/globals.dart';
import 'package:verified/helpers/logger.dart';
import 'package:verified/infrastructure/native_scripts/main.dart';
import 'package:verified/presentation/pages/add_payment_method_page.dart';
import 'package:verified/presentation/utils/select_media.dart';
import 'package:verified/presentation/widgets/history/combined_history_list.dart';
import 'package:verified/presentation/pages/search_options_page.dart';
import 'package:verified/presentation/pages/search_results_page.dart';
import 'package:verified/presentation/pages/top_up_page.dart';
import 'package:verified/presentation/pages/webviews/terms_of_use.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/error_warning_indicator.dart';
import 'package:verified/presentation/widgets/popups/help_form_popup.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/widgets/bank_card/base_card.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/text/list_title.dart';

class AccountPage extends StatelessWidget {
  AccountPage({super.key});

  GlobalKey<RefreshIndicatorState> refreshIndicatorKey = GlobalKey<RefreshIndicatorState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 150.0,
        height: 74.0,
        margin: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          boxShadow: [
            const BoxShadow(color: Colors.transparent),
            BoxShadow(
              offset: const Offset(1, 30),
              blurRadius: 30,
              color: darkerPrimaryColor.withOpacity(0.2),
            ),
          ],
        ),
        child: BaseButton(
          key: UniqueKey(),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (BuildContext context) => const SearchOptionsPage(),
            ),
          ),
          label: 'Search',
          color: Colors.white,
          iconBgColor: neutralYellow,
          bgColor: neutralYellow,
          buttonIcon: const Image(image: AssetImage('assets/icons/find-icon.png')),
          buttonSize: ButtonSize.large,
          hasBorderLining: false,
        ),
      ),
      body: RefreshIndicator(
        key: refreshIndicatorKey,
        onRefresh: () async => await Future.delayed(
          const Duration(seconds: 2),
          // VerifiedAppNativeCalls.restartApp,
        ),
        child: const AccountPageContent(),
      ),
    );
  }
}

class AccountPageContent extends StatelessWidget {
  const AccountPageContent({super.key});

  @override
  Widget build(BuildContext context) {
    /// config before image/media picker
    selectMediaConfig();

    ///
    final appInfo = getAppInfo(context);

    ///

    final user = context.watch<StoreBloc>().state.userProfileData;
    final wallet = context.watch<StoreBloc>().state.walletData;
    return Center(
      child: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: <Widget>[
          const AppErrorWarningIndicator(),
          SliverAppBar(
            stretch: true,
            onStretchTrigger: () async {},
            surfaceTintColor: Colors.transparent,
            stretchTriggerOffset: 360.0,
            expandedHeight: 360.0,
            title: const Text(
              'Account',
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
                decoration: BoxDecoration(
                  color: darkerPrimaryColor,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                ),
                child: SingleChildScrollView(
                  reverse: true,
                  clipBehavior: Clip.none,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        padding: primaryPadding.copyWith(left: primaryPadding.left, right: primaryPadding.right),
                        constraints: appConstraints,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  wallet != null ? 'Top up your account' : 'Add a payment method',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.0,
                                    fontStyle: FontStyle.normal,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  wallet != null
                                      ? 'Default payment method used to top-up'
                                      : 'Default payment method used to top-up',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 14.0,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            ActionButton(
                              key: const Key('add-payment-method-or-topup-btn'),
                              tooltip: wallet == null ? 'Add payment method' : 'Top-up',
                              iconColor: Colors.white,
                              bgColor: neutralYellow,
                              padding: const EdgeInsets.all(0),
                              onTap: () {
                                if (wallet == null) {
                                  navigate(context, page: const AddPaymentMethodPage());
                                } else {
                                  showTopUpBottomSheet(context);
                                }
                              },
                              icon: wallet == null ? Icons.add_card_rounded : Icons.add,
                              borderColor: neutralYellow,
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: primaryPadding.copyWith(bottom: 0, top: 0),
                        child: const BaseBankCard(size: BankCardSize.short),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            leadingWidth: 80.0,
            leading: VerifiedBackButton(
              key: const Key('acc-page-back-btn'),
              onTap: () => Navigator.of(context)
                ..pop()
                ..initState(),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              childCount: accountSettings.length,
              (BuildContext context, int index) => UnconstrainedBox(
                child: Container(
                  // color: Colors.blueAccent,
                  width: MediaQuery.of(context).size.width - 16,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                  ),
                  constraints: appConstraints,
                  child: (accountSettings[index]['type'] == 'space')
                      ? Container(
                          height: 90,
                          width: 100,
                          color: Colors.transparent,
                        )
                      : accountSettings[index]['text'] == 'balance'
                          ? Column(
                              children: [
                                _ProfileName(
                                  user: user,
                                ),
                                Divider(
                                  color: Colors.grey[400],
                                  indent: 0,
                                  endIndent: 0,
                                ),
                              ],
                            )
                          : (accountSettings[index]['text'] == 'title')
                              ? Container(
                                  alignment: Alignment.centerLeft,
                                  padding: primaryPadding.copyWith(bottom: 22.0),
                                  child: const ListTitle(
                                    text: 'Account Settings',
                                  ),
                                )
                              : accountSettings[index]['type'] == 'button'
                                  ? ListTile(
                                      hoverColor: ((accountSettings[index]['color']) as Color?) != null
                                          ? const Color.fromARGB(255, 255, 210, 210)
                                          : null,
                                      focusColor: ((accountSettings[index]['color']) as Color?) != null
                                          ? const Color.fromARGB(255, 255, 210, 210)
                                          : null,
                                      splashColor: ((accountSettings[index]['color']) as Color?) != null
                                          ? const Color.fromARGB(255, 255, 210, 210)
                                          : null,
                                      style: ListTileStyle.list,
                                      onTap: () async {
                                        try {
                                          /// Logout
                                          if (accountSettings[index]['text'] == 'Logout') {
                                            ///
                                            ScaffoldMessenger.of(context)
                                              ..clearSnackBars()
                                              ..showSnackBar(
                                                SnackBar(
                                                  content: const Text(
                                                    'Logged out',
                                                  ),
                                                  backgroundColor: warningColor,
                                                ),
                                              );

                                            context.read<AuthBloc>().add(const AuthEvent.signOut());
                                            context.read<StoreBloc>()
                                              ..add(StoreEvent.deleteUserProfile(user?.id ?? ''))
                                              ..add(const StoreEvent.clearUser());

                                            Navigator.of(context)
                                              ..pop()
                                              ..initState();

                                            Future.delayed(const Duration(milliseconds: 600),
                                                () => VerifiedAppNativeCalls.restartApp());
                                          }

                                          // Delete account
                                          if (accountSettings[index]['text'] == 'Delete Account') {
                                            ///
                                            ScaffoldMessenger.of(context)
                                              ..clearSnackBars()
                                              ..showSnackBar(
                                                SnackBar(
                                                  content: const Text(
                                                    'Account Deleted!',
                                                  ),
                                                  backgroundColor: errorColor,
                                                ),
                                              );

                                            ///
                                            context.read<AuthBloc>().add(const AuthEvent.deleteAccount());
                                            context.read<StoreBloc>()
                                              ..add(StoreEvent.deleteUserProfile(user?.id ?? ''))
                                              ..add(const StoreEvent.clearUser());

                                            Navigator.of(context)
                                              ..pop()
                                              ..initState();

                                            Future.delayed(const Duration(milliseconds: 600),
                                                () => VerifiedAppNativeCalls.restartApp());
                                          }

                                          /// Show Terms of Use
                                          if (accountSettings[index]['text'] == 'Terms of Use') {
                                            navigate(context, page: const TermOfUseWebView());
                                          }

                                          /// show get help pop-up
                                          if (accountSettings[index]['text'] == 'Help') {
                                            await showHelpPopUpForm(context);
                                          }
                                        } catch (e) {
                                          verifiedErrorLogger(e);
                                          if (accountSettings[index]['text'] != 'Delete Account' &&
                                              accountSettings[index]['text'] != 'Logout') {
                                            ScaffoldMessenger.of(context)
                                              ..clearSnackBars()
                                              ..showSnackBar(
                                                SnackBar(
                                                  content: const Text(
                                                    'Pull To Refresh',
                                                  ),
                                                  action: SnackBarAction(label: 'Refresh', onPressed: () {}),
                                                ),
                                              );
                                          }
                                        }
                                      },
                                      leading: Icon(
                                        accountSettings[index]['icon'] as IconData?,
                                        color: (accountSettings[index]['color']) as Color? ?? primaryColor,
                                        size: 32.0,
                                      ),
                                      title: Text(
                                        accountSettings[index]['text'] as String,
                                        style: TextStyle(
                                          color: (accountSettings[index]['color']) as Color? ?? Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.0,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                      contentPadding: EdgeInsets.zero,
                                      enableFeedback: true,
                                      trailing: Icon(
                                        Icons.arrow_forward_ios_sharp,
                                        color: (accountSettings[index]['color']) as Color? ?? Colors.black,
                                        size: 16.0,
                                      ),
                                    )
                                  : ExpansionTile(
                                      tilePadding: const EdgeInsets.all(0.0),
                                      leading: Icon(
                                        accountSettings[index]['icon'] as IconData?,
                                        color: (accountSettings[index]['color']) as Color? ?? primaryColor,
                                        size: 32.0,
                                      ),
                                      backgroundColor: Colors.grey[100],
                                      collapsedBackgroundColor: Colors.white,
                                      childrenPadding: const EdgeInsets.symmetric(
                                          // horizontal: 20.0,
                                          ),
                                      title: Text(
                                        accountSettings[index]['text'] as String,
                                        style: TextStyle(
                                          color: (accountSettings[index]['color']) as Color? ?? Colors.black,
                                          fontWeight: FontWeight.w600,
                                          fontSize: 16.0,
                                          fontStyle: FontStyle.normal,
                                        ),
                                      ),
                                      children: (accountSettings[index]['text'] == 'Personal')
                                          ? List.generate(
                                              userPersonalDetailsKey.length,
                                              (index) => accountPageListItems(
                                                key: "${userPersonalDetailsKey[index]['displayName']}",
                                                value: "${user?.toJson()[userPersonalDetailsKey[index]['keyName']]}",
                                                isLast: index == userPersonalDetailsKey.length - 1,
                                              ),
                                            )
                                          : (accountSettings[index]['text'] == 'Transactions')
                                              ? [const CombinedHistoryList(limit: 4, showBanner: false)]
                                              : (accountSettings[index]['text'] == 'App Information')
                                                  ? List.generate(
                                                      appInfo.length,
                                                      (index) => accountPageListItems(
                                                        key: appInfo.keys.toList()[index],
                                                        value: appInfo[appInfo.keys.toList()[index]] ?? '',
                                                        isLast: index == appInfo.length - 1,
                                                      ),
                                                    )
                                                  : [
                                                      const Text('No Data'),
                                                    ],
                                    ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

var userPersonalDetailsKey = [
  {
    'keyName': 'name',
    'displayName': 'Name',
  },
  {
    'keyName': 'active',
    'displayName': 'Active',
  },
  {
    'keyName': 'email',
    'displayName': 'Email',
  },
  {
    'keyName': 'phone',
    'displayName': 'Phone',
  },
  {
    'keyName': 'last_login_at',
    'displayName': 'Last Login',
  },
  {
    'keyName': 'account_created_at',
    'displayName': 'Account Created',
  },
];

var accountSettings = [
  {
    'type': 'expandable',
    'text': 'balance',
  },
  {
    'type': 'expandable',
    'text': 'title',
  },
  {
    'type': 'expandable',
    'text': 'Personal',
    'icon': Icons.person_2_outlined,
  },
  {
    'type': 'expandable',
    'text': 'Transactions',
    'icon': Icons.payments_outlined,
  },
  {
    'type': 'button',
    'text': 'Help',
    'icon': Icons.info_outline,
  },
  {'type': 'expandable', 'text': 'App Information', 'icon': Icons.app_settings_alt_outlined},
  {'type': 'expandable', 'text': 'Privacy &  Security', 'icon': Icons.security_outlined},
  {
    'type': 'button',
    'text': 'Terms of Use',
    'icon': Icons.article_outlined,
  },
  {
    'type': 'button',
    'text': 'Logout',
    'icon': Icons.logout_outlined,
  },
  {
    'type': 'button',
    'text': 'Delete Account',
    'icon': Icons.delete_outline_outlined,
    'color': const Color.fromARGB(255, 248, 112, 110)
  },
  {
    'type': 'space',
    'text': '',
  },
];

class _ProfileName extends StatelessWidget {
  final UserProfile? user;
  const _ProfileName({required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.only(right: 16.0),
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(200),
                    child: Container(
                      padding: const EdgeInsets.all(1),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.green.shade50,
                        ),
                        shape: BoxShape.circle,
                        color: Colors.green[50],
                      ),
                      child: Image.network(
                        user?.avatar?.replaceAll(' ', '') ??
                            "https://ui-avatars.com/api/?background=105D38&color=fff&name=${(user?.displayName ?? user?.actualName ?? user?.name)?.split(" ").join('+')}",
                        height: 100.0,
                        width: 100.0,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () async {
                        try {
                          // Pick a single image from the gallery.
                          var images = await GalleryAssetPicker.pick(
                            context,
                            maxCount: 1,
                            requestType: RequestType.image,
                          );

                          // Early exit if no images are picked or if the user object is null.
                          if (images.isEmpty || user == null) {
                            print('No images selected or user is null');
                            return;
                          }

                          print('IMAGES: ${images.length}');

                          // Convert the picked images to a list of FormData objects.
                          final files =
                              await Future.wait(images.map((f) async => await convertToFormData(await f.file)));

                          // Filter out any null items from the list and cast to a non-nullable type.
                          final nonNullFiles = files.whereType<MultipartFile>().toList();

                          // Trigger an event to upload the files.
                          context.read<StoreBloc>().add(StoreEvent.uploadFiles(nonNullFiles));

                          // Artificial delay
                          await Future.delayed(const Duration(milliseconds: 1300));

                          //
                          if (context.read<StoreBloc>().state.uploadsData?.files?.isNotEmpty ?? false) {
                            context.read<StoreBloc>().add(
                                  StoreEvent.updateUserProfile(
                                    user!.copyWith(
                                        avatar:
                                            '$CDN/media/${context.read<StoreBloc>().state.uploadsData!.files![0].filename}'),
                                  ),
                                );
                          } else {
                            print('No files uploaded');
                          }
                        } catch (e) {
                          // Log any errors encountered during the process.
                          print('Image picker or upload error: $e');
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: const Icon(
                          Icons.edit_outlined,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// name
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  clipBehavior: Clip.none,
                  child: Text(
                    user?.displayName ?? user?.actualName ?? '',
                    style: const TextStyle(
                      fontSize: 24.0,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                      overflow: TextOverflow.ellipsis,
                    ),
                    textAlign: TextAlign.left,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),

                /// phone
                Text(
                  user?.phone ?? '000 000 0000',
                  textAlign: TextAlign.left,
                ),

                /// email
                Container(
                  width: MediaQuery.of(context).size.width * 0.5,
                  clipBehavior: Clip.none,
                  child: Text(
                    user?.email ?? 'nomail@mailbox.com',
                    textAlign: TextAlign.left,
                    style: const TextStyle(overflow: TextOverflow.ellipsis),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                )
              ],
            )
          ]),
    );
  }
}

Widget accountPageListItems({required String key, required String value, bool isLast = false}) {
  dynamic transformedValue() => switch (key) {
        'Official Website' => IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.open_in_new,
              color: primaryColor,
            ),
          ),
        'Active' => value == 'true' ? 'Yes' : 'No',
        'Last Login' => (value == 'null') ? 'Unknown' : humanReadable(value),
        'Account Created' => (value == 'Unknown') ? '' : humanReadable(value),
        _ => value
      };
  return Container(
    alignment: Alignment.centerLeft,
    padding: const EdgeInsets.only(
      left: 16.0,
      right: 16.0,
      bottom: 0,
      top: 20.0,
    ),
    child: Column(
      children: [
        DataItem(keyName: key, value: transformedValue()),
        (!isLast)
            ? Divider(
                color: Colors.grey[400],
                indent: 0,
                endIndent: 0,
              )
            : const SizedBox.shrink(),
      ],
    ),
  );
}

Map<String, String> getAppInfo(BuildContext context) {
  final appBase = context.read<AppbaseBloc>().state;

  return {
    'App Id': 'com.byteestudio.verified',
    'Name': 'Verified',
    'App Official Name': appBase.appName ?? '',
    'Vendor': 'Verified (byteestudio.com)',
    'Version': appBase.version ?? '0.0.0',
    'Build Number': appBase.buildNumber ?? '',
    'Build Signature': appBase.buildSignature ?? '#',
    'Official Website': TargetPlatform.iOS == defaultTargetPlatform
        ? 'https://www.apple.com/app-store/12454534636'
        : (TargetPlatform.android == defaultTargetPlatform)
            ? 'https://play.google.com/store/apps/details?id=com.byteestudio.verified'
            : 'https://verified.byteestudio.com'
  };
}

String humanReadable(String time) {
  try {
    return DateFormat.yMMMMd('en_US').format(DateTime.fromMillisecondsSinceEpoch(int.parse(time) * 1000));
  } catch (err) {
    return 'T_$time';
  }
}
