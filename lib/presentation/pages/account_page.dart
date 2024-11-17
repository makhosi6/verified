// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:io';

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
import 'package:verified/infrastructure/analytics/repository.dart';
import 'package:verified/infrastructure/auth/local_user.dart';
import 'package:verified/infrastructure/native_scripts/main.dart';
import 'package:verified/presentation/pages/app_signature_page.dart';
import 'package:verified/presentation/pages/search_options_page.dart';
import 'package:verified/presentation/pages/top_up_page.dart';
import 'package:verified/presentation/pages/webviews/privacy_clause.dart';
import 'package:verified/presentation/pages/webviews/terms_of_use.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/data_view_item.dart';
import 'package:verified/presentation/utils/error_warning_indicator.dart';
import 'package:verified/presentation/utils/lottie_loader.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/utils/select_media.dart';
import 'package:verified/presentation/utils/url_loader.dart';
import 'package:verified/presentation/widgets/bank_card/base_card.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/history/combined_history_list.dart';
import 'package:verified/presentation/widgets/popups/default_popup.dart';
import 'package:verified/presentation/widgets/popups/help_form_popup.dart';
import 'package:verified/presentation/widgets/text/list_title.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    GlobalKey<RefreshIndicatorState> refreshIndicatorKey =
        GlobalKey<RefreshIndicatorState>(debugLabel: 'acc-page-refresh-token-key');
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
          onTap: () {
            VerifiedAppAnalytics.logFeatureUsed(VerifiedAppAnalytics.FEATURE_VERIFY_FROM_ACCOUNT);
            navigate(context, page: const SearchOptionsPage());
          },
          label: 'Verify',
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

    var user = context.watch<StoreBloc>().state.userProfileData;
    var wallet = context.watch<StoreBloc>().state.walletData;

    return FutureBuilder<UserProfile?>(
        future: LocalUser.getUser(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: LottieProgressLoader(
                key: Key('app-splash-screen-loader-$key'),
              ),
            );
          }

          user = snapshot.data;

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
                                    tooltip: wallet == null ? 'Add payment method' : 'Top up',
                                    iconColor: Colors.white,
                                    bgColor: neutralYellow,
                                    padding: const EdgeInsets.all(0),
                                    onTap: () {
                                      VerifiedAppAnalytics.logActionTaken(
                                          VerifiedAppAnalytics.ACTION_TOPUP_FROM_ACCOUNT);

                                      ///
                                      showTopUpBottomSheet(context);
                                    },
                                    icon: Icons.add,
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
                    onTap: Navigator.of(context).pop,
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    childCount: accountSettings.length,
                    (BuildContext context, int index) => UnconstrainedBox(
                      child: Container(
                        // color: Colors.blueAccent,
                        width: MediaQuery.of(context).size.width - primaryPadding.top,
                        padding: EdgeInsets.symmetric(
                          horizontal: primaryPadding.top / 2,
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
                                                  context.read<StoreBloc>().add(const StoreEvent.clearUser());

                                                  ///
                                                  VerifiedAppAnalytics.logActionTaken(
                                                      VerifiedAppAnalytics.ACTION_LOGOUT);

                                                  ///
                                                  // Navigator.of(context)
                                                  // ..pop();
                                                  // ..initState();

                                                  Future.delayed(const Duration(milliseconds: 700),
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

                                                  ///
                                                  VerifiedAppAnalytics.logActionTaken(
                                                      VerifiedAppAnalytics.ACTION_LOGOUT);
                                                  VerifiedAppAnalytics.logActionTaken(
                                                      VerifiedAppAnalytics.ACTION_DELETED_ACCOUNT);

                                                  ///
                                                  Navigator.of(context)
                                                    ..pop()
                                                    ..initState();

                                                  Future.delayed(
                                                    const Duration(milliseconds: 700),
                                                    () => VerifiedAppNativeCalls.restartApp(),
                                                  );
                                                }

                                                /// Show Terms of Use
                                                if (accountSettings[index]['text'] == 'Terms of Use') {
                                                  navigate(context, page: const TermOfUseWebView());
                                                }

                                                /// Show privacy
                                                if (accountSettings[index]['text'] == 'Privacy & Security') {
                                                  navigate(context, page: const PrivacyClauseWebView());
                                                }

                                                /// show get help pop-up
                                                if (accountSettings[index]['text'] == 'Help') {
                                                  await showHelpPopUpForm(context);
                                                }
                                              } catch (error, stackTrace) {
                                                verifiedErrorLogger(error, stackTrace);
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
                                                      context,
                                                      key: "${userPersonalDetailsKey[index]['displayName']}",
                                                      value:
                                                          "${user?.toJson()[userPersonalDetailsKey[index]['keyName']]}",
                                                      isLast: index == userPersonalDetailsKey.length - 1,
                                                    ),
                                                  )
                                                : (accountSettings[index]['text'] == 'Transactions')
                                                    ? [const CombinedHistoryList(limit: 4, showBanner: false)]
                                                    : (accountSettings[index]['text'] == 'App Information')
                                                        ? List.generate(
                                                            appInfo.length,
                                                            (index) => accountPageListItems(
                                                              context,
                                                              key: appInfo.keys.toList()[index],
                                                              value: appInfo[appInfo.keys.toList()[index]] ?? '',
                                                              isLast: index == appInfo.length - 1,
                                                            ),
                                                          )
                                                        : accountSettings[index]['text'] == 'Alerts And Notifications'
                                                            ? [
                                                                const _NotificationsSettings(
                                                                  key: Key('notifications-settings'),
                                                                )
                                                              ]
                                                            : [
                                                                const Text(' '),
                                                              ],
                                          ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        });
  }
}

class _NotificationsSettings extends StatefulWidget {
  const _NotificationsSettings({super.key});

  @override
  State<_NotificationsSettings> createState() => __NotificationsSettingsState();
}

class __NotificationsSettingsState extends State<_NotificationsSettings> {
  ///
  bool email = true, inApp = true;

  ///
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SwitchListTile(
          title: const Text('In-App push Notification'),
          subtitle: Text('Also have to enable OS notification', style: TextStyle(color: neutralDarkGrey, fontSize: 13),),
          value: inApp,
          onChanged: (bool? value) {
            if (mounted) {
              setState(() {
                inApp = value ?? false;
              });
            }
            VerifiedAppAnalytics.logActionTaken(
                VerifiedAppAnalytics.ACTION_UPDATE_NOTIFICATION_SETTINGS, {'in_app_notifications': value});
          },
        ),
        SwitchListTile(
          title: const Text(
            'Email Notifications',
          ),
          subtitle: Text('Important notification like payment receipts, and refund notification are mandatory' , style: TextStyle(color: neutralDarkGrey, fontSize: 13),),
          value: email,
          onChanged: (bool? value) {
            if (mounted) {
              setState(() {
                email = value ?? false;
              });
            }

            ///
            VerifiedAppAnalytics.logActionTaken(
                VerifiedAppAnalytics.ACTION_UPDATE_NOTIFICATION_SETTINGS, {'email_notifications': value});
          },
        )
      ],
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
  {'type': 'expandable', 'text': 'balance'},
  {'type': 'expandable', 'text': 'title'},
  {'type': 'expandable', 'text': 'Personal', 'icon': Icons.person_2_outlined},
  {'type': 'expandable', 'text': 'History', 'icon': Icons.history_rounded},
  {'type': 'button', 'text': 'Help', 'icon': Icons.support_outlined},
  {
    'type': 'expandable',
    'text': 'App Information',
    'icon': Icons.app_settings_alt_outlined,
  },
  {
    'type': 'expandable',
    'text': 'Alerts And Notifications',
    'icon': Icons.notifications_none_rounded,
  },
  {'type': 'button', 'text': 'Privacy & Security', 'icon': Icons.security_outlined},
  {'type': 'button', 'text': 'Terms of Use', 'icon': Icons.article_outlined},
  {'type': 'button', 'text': 'Logout', 'icon': Icons.logout_outlined},
  {
    'type': 'button',
    'text': 'Delete Account',
    'icon': Icons.delete_outline_outlined,
    'color': const Color.fromARGB(255, 248, 112, 110)
  },
  {'type': 'space', 'text': ''},
];

class _ProfileName extends StatelessWidget {
  UserProfile? user;
  _ProfileName({
    Key? key,
    this.user,
  }) : super(key: key);

  late String placeholderAvatar = 'https://robohash.org/${user?.displayName?.substring(1, 2)}.png';
  @override
  Widget build(BuildContext context) {
    var windowWidth = MediaQuery.of(context).size.width;
    var calculatedWidth = appConstraints.maxWidth - (100 + primaryPadding.horizontal);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
          // crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(right: primaryPadding.right),
              child: Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(1),
                    height: 100.0,
                    width: 100.0,
                    clipBehavior: Clip.hardEdge,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: Colors.green.shade50, width: 0),
                      // shape: BoxShape.circle,
                      color: Colors.green.shade50,
                    ),
                    child: Image.network(
                      // if avatar is not null and it's from byteestudio or robohash
                      ((user?.avatar != null &&
                              ((user?.avatar ?? '').contains('byteestudio') ||
                                  (user?.avatar ?? '').contains('robohash')))
                          ? user?.avatar?.replaceAll(' ', '') ?? placeholderAvatar
                          : placeholderAvatar),
                      height: 100.0,
                      width: 100.0,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {
                        // Pick a single image from the gallery.
                        GalleryAssetPicker.pick(
                          context,
                          maxCount: 1,
                          requestType: RequestType.image,
                        ).then((images) async {
                          // Early exit if no images are picked or if the user object is null.
                          if (images.isEmpty || user == null) {
                            verifiedLogger('No images selected or user is null');
                            return null;
                          }

                          verifiedLogger('IMAGES: ${images.length}');

                          // Convert the picked images to a list of FormData objects.
                          final files = await Future.wait(images.map((f) async {
                            final filePath = await f.getMediaUrl();
                            final rawFile = (await f.file) ?? File(filePath ?? '');
                            final compressedImage = await compressForProfilePicture(rawFile);
                            return await convertToFormData(compressedImage);
                          }));

                          // Filter out any null items from the list and cast to a non-nullable type.
                          return files.whereType<MultipartFile>().toList();
                        }).then((uploads) {
                          // Trigger an event to upload the files.
                          context.read<StoreBloc>().add(StoreEvent.uploadFiles(uploads ?? []));
                        }).then((_) async {
                          return await showDefaultPopUp(
                            context,
                            title: 'Update Profile Picture?',
                            subtitle: 'Are you sure you want to update your profile picture?',
                            confirmBtnText: 'Yes',
                            declineBtnText: 'No',
                            onConfirm: () => Navigator.pop(context, true),
                            onDecline: () => Navigator.pop(context, false),
                          );
                        }).then((shouldUpdate) {
                          if ((context.read<StoreBloc>().state.uploadsData?.files?.isNotEmpty ?? false) &&
                              shouldUpdate == true) {
                            context.read<StoreBloc>().add(
                                  StoreEvent.updateUserProfile(
                                    user!.copyWith(
                                        avatar:
                                            '$CDN/media/${context.read<StoreBloc>().state.uploadsData!.files![0].filename}'),
                                  ),
                                );
                          } else {
                            verifiedLogger('No files uploaded');
                          }
                        }).catchError((error) {
                          verifiedErrorLogger(error, StackTrace.current);
                        }, test: (_) {
                          return true;
                        });

                        ///
                        VerifiedAppAnalytics.logFeatureUsed(VerifiedAppAnalytics.FEATURE_UPDATE_PROFILE_PICTURE);
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
                  width: windowWidth > 600 ? calculatedWidth : windowWidth * 0.5,
                  clipBehavior: Clip.none,
                  child: Text(
                    user?.name ?? user?.displayName ?? user?.actualName ?? 'Hello',
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
                  user?.phone ?? '(+27) 000 000 0000',
                  textAlign: TextAlign.left,
                ),

                /// email
                Container(
                  width:
                      windowWidth > 600 ? calculatedWidth : (windowWidth > 400 ? windowWidth * 0.6 : windowWidth * 0.5),
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

Widget accountPageListItems(BuildContext context, {required String key, required String value, bool isLast = false}) {
  dynamic transformedValue() => switch (key) {
        'Build Signature' => IconButton(
            onPressed: () => navigate(context, page: const AppSignaturePage()),
            icon: Icon(
              Icons.tag,
              color: primaryColor,
            ),
          ),
        'Official Website' => IconButton(
            onPressed: () {
              try {
                launchInAppWebPage(value);
              } catch (error, stackTrace) {
                verifiedErrorLogger(error, stackTrace);
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
            },
            icon: Icon(
              Icons.open_in_new,
              color: primaryColor,
            ),
          ),
        'Active' => value == 'true' ? 'Yes' : 'No',
        'Last Login' => (value == 'null') ? 'Unknown' : humanReadable(value),
        'Account Created' => (value == 'Unknown') ? '' : humanReadable(value),
        _ => (value == 'null') ? 'Unknown' : value
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
        DataViewItem(keyName: key, value: transformedValue()),
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
  final appBase = context.watch<AppbaseBloc>().state.appInfo;

  return {
    'App Id': appBase?['packageName'] ?? 'Unknown',
    'Name': 'Verified',
    'App Official Name': appBase?['appName'] ?? '',
    'Vendor': 'Verified (byteestudio.com)',
    'Version': appBase?['version'] ?? '0.0.0',
    'Build Number': appBase?['buildNumber'] ?? '',
    'Build Signature': appBase?['buildSignature'] ?? '#',
    'Official Website': TargetPlatform.iOS == defaultTargetPlatform
        ? 'https://www.apple.com/app-store/12454534636'
        : (TargetPlatform.android == defaultTargetPlatform)
            ? 'https://play.google.com/store/apps/details?id=com.byteestudio.verified'
            : 'http://192.168.0.134'
  };
}

String humanReadable(String time) {
  try {
    return DateFormat.yMMMMd('en_US').format(DateTime.fromMillisecondsSinceEpoch(int.parse(time) * 1000));
  } catch (err) {
    return 'T_$time';
  }
}
