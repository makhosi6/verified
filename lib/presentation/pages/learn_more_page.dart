import 'package:flutter/foundation.dart';
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
  ///
  Map<String, String> content = helpQuestionContent.values.first;
  int topicIndex = 0;

  ///
  final ScrollController _scrollController = ScrollController();

  ///
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;

  ///

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    )..forward();
    _offsetAnimation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticInOut,
    ));
  }

  ///
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                            child: const Column(
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
                                  'Here, you\'ll find everything you need to navigate the Verified app seamlessly.',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.white,
                                    fontStyle: FontStyle.italic,
                                    fontSize: 14.0,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: primaryPadding.copyWith(bottom: 0, top: 0),
                            child: ListOfHelpTipsTopics(
                              topics: topics,
                              onTap: (index) {
                                if (mounted) {
                                  /// trigger animation
                                  _controller
                                    ..reset()
                                    ..forward();

                                  /// reset the scrollbar
                                  _scrollController.jumpTo(0.0);

                                  /// and set content
                                  setState(() {
                                    topicIndex = index;
                                    content = helpQuestionContent[index] ?? helpQuestionContent.values.first;
                                  });
                                }
                              },
                            ),
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
                        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height - 300.0),
                        animationController: BottomSheet.createAnimationController(this),
                        enableDrag: false,
                        builder: (BuildContext context) {
                          return Container(
                            decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20.0),
                                topRight: Radius.circular(20.0),
                              ),
                            ),
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height - 300.0,
                            child: Scrollbar(
                              controller: _scrollController,
                              child: SingleChildScrollView(
                                controller: _scrollController,
                                physics: const BouncingScrollPhysics(),
                                padding: EdgeInsets.symmetric(horizontal: primaryPadding.horizontal / 2),
                                child: SlideTransition(
                                  position: _offsetAnimation,
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
                                            child: Text(
                                              topics[topicIndex].replaceAll('\n', ' ').replaceAll('  ', ' '),
                                              style: const TextStyle(
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
                                              explainers[topicIndex],
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
                                      Padding(
                                        padding: const EdgeInsets.only(bottom: 20),
                                        child: ListView.builder(
                                          key: ValueKey(content.hashCode),
                                          physics: const NeverScrollableScrollPhysics(),
                                          shrinkWrap: true,
                                          itemCount: content.length,
                                          itemBuilder: (context, index) {
                                            var question = content.keys.toList()[index];
                                            var answer = content.values.toList()[index];

                                            return ExpansionTile(
                                              key: Key('expansion_tile_${question.hashCode}'),
                                              tilePadding: const EdgeInsets.all(0.0),
                                              backgroundColor: Colors.grey[100],
                                              collapsedBackgroundColor: Colors.transparent,
                                              initiallyExpanded: index == 0,
                                              title: Text(
                                                question,
                                                style: const TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 15.0,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                                textAlign: TextAlign.start,
                                              ),
                                              children: [
                                                Text(
                                                  answer,
                                                ),
                                                const Text('')
                                              ],
                                            );
                                          },
                                        ),
                                      )
                                    ],
                                  ),
                                ),
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
  final List<String> topics;
  final void Function(int) onTap;

  const ListOfHelpTipsTopics({super.key, required this.topics, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: primaryPadding.vertical / 2),
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemCount: topics.length,
        itemBuilder: (context, index) => InkWell(
          onTap: () => onTap(index),
          child: Container(
            width: 160,
            height: 100,
            margin: EdgeInsets.only(right: primaryPadding.right / 2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white70),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(
                topics[index],
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                  fontStyle: FontStyle.normal,
                  fontSize: 18.0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

const helpQuestionContent = {
  /// Getting Started
  0: gettingStarted,

  /// Search and Verification
  1: searchAndVerification,

  /// Account Management
  2: accountManagement,

  /// FAQs
  3: faqs,
};

const searchAndVerification = {
  'How can I search for specific information within the app?':
      "You can use the search bar located at the top of the app interface to enter keywords related to the information you're looking for.",
  'What types of documents can I verify using VerifyID Plus?':
      "VerifyID Plus supports verification of various government-issued documents such as driver's licenses, passports, ID cards, and more.",
  'Is there a way to track the status of my verification process?':
      "Yes, you can track the status of your verification process in the app's dashboard, which provides real-time updates on the progress.",
  'Can I verify my identity using multiple documents?':
      'Yes, you can verify your identity using multiple documents if required for certain verification purposes.',
  'Are there any tips for ensuring a successful verification process?':
      'Make sure to provide clear and legible images of your documents, ensure all information matches the provided details, and follow any additional instructions provided during the process.',
  'How long does it typically take for verification results to be processed?':
      'Verification results are usually processed within a few minutes to a few hours, depending on the complexity of the verification process and any additional checks required.',
  'Is there a limit to the number of verification attempts I can make?':
      'There may be a limit to the number of verification attempts within a specific time frame to prevent misuse or abuse of the system.',
  'What should I do if my verification attempt fails?':
      'If your verification attempt fails, you may be provided with instructions on how to rectify the issue or given the option to retry the verification process.',
  'Are there any additional verification steps for accessing certain features or services within the app?':
      'Yes, some features or services within the app may require additional verification steps to ensure security and compliance with regulations.',
  'How does VerifyID Plus ensure the accuracy and reliability of verification results?':
      'VerifyID Plus uses advanced algorithms and verification techniques, combined with access to government databases, to ensure the accuracy and reliability of verification results.'
};
const accountManagement = {
  'How do I create an account on VerifyID Plus?':
      'You can create an account by downloading the VerifyID Plus app from the App Store or Google Play Store and following the prompts to sign up.',
  "Can I change my account information after it's been set up?":
      'Yes, you can typically change your account information such as email address, password, and personal details within the app settings.',
  'Is there a way to reset my password if I forget it?':
      "Yes, you can reset your password by selecting the 'Forgot Password' option on the login screen and following the instructions to reset your password.",
  'How can I update my personal details within the app?':
      'You can update your personal details by accessing the account settings within the app and selecting the option to edit your profile.',
  'Are there any security measures in place to protect my account?':
      'Yes, VerifyID Plus employs various security measures such as encryption, multi-factor authentication, and regular security audits to protect user accounts.',
  'Can I link multiple devices to my VerifyID Plus account?':
      'Yes, you can typically use your VerifyID Plus account on multiple devices by logging in with the same credentials.',
  'What should I do if I suspect unauthorized access to my account?':
      'If you suspect unauthorized access to your account, you should immediately change your password and contact VerifyID Plus customer support for assistance.',
  'Is there an option to deactivate or delete my account?':
      'Yes, you can usually deactivate or delete your account by accessing the account settings within the app and following the instructions provided.',
  'How can I switch between different accounts if I have more than one?':
      'You can switch between different accounts by logging out of the current account and logging in with the credentials of the other account.',
  'Are there any account-related notifications or alerts I should be aware of?':
      'Yes, VerifyID Plus may send notifications or alerts regarding account activity, verification status updates, and important announcements related to the app.'
};
const gettingStarted = {
  'What are the initial steps I need to take after downloading the VerifyID Plus app?':
      "After downloading the VerifyID Plus app, you'll need to create an account, complete the setup process, and initiate the identity verification process.",
  'How do I initiate the identity verification process?':
      'You can initiate the identity verification process by logging into your account and following the prompts to upload the required documents for verification.',
  'Can I preview the verification requirements before starting the process?':
      'Yes, you can usually preview the verification requirements within the app before starting the process to ensure you have all the necessary documents and information.',
  'Is there a tutorial or guide available to help me get started with the app?':
      'Yes, VerifyID Plus may provide a tutorial or guide within the app to help you get started and navigate the verification process.',
  'Are there any prerequisites for using VerifyID Plus, such as having specific documents ready?':
      "Yes, you'll typically need to have government-issued identification documents such as a driver's license, passport, or ID card ready for the verification process.",
  'What platforms or devices are compatible with VerifyID Plus?':
      'VerifyID Plus is usually compatible with both iOS and Android devices, and you can download the app from the App Store or Google Play Store.',
  'Can I use VerifyID Plus offline, or do I need an internet connection?':
      "You'll typically need an internet connection to use VerifyID Plus as it requires access to online databases for identity verification.",
  'How do I access customer support if I need assistance during the setup process?':
      'You can usually access customer support within the app by navigating to the help or support section and contacting customer support through email, chat, or phone.',
  'Are there any special features or tips for new users to maximize their experience with VerifyID Plus?':
      'Yes, VerifyID Plus may provide tips or recommendations for new users to help them navigate the app and complete the verification process successfully.',
  'What are some common mistakes to avoid when getting started with VerifyID Plus?':
      'Some common mistakes to avoid when getting started with VerifyID Plus include providing incomplete or inaccurate information, uploading unclear or illegible documents, and not following the instructions provided during the verification process.'
};

const faqs = {
  'What is VerifyID Plus, and how does it work?':
      'VerifyID Plus is a secure identity verification app that uses advanced algorithms and access to government databases to verify the authenticity of user identities.',
  'Is VerifyID Plus free to use, or are there any subscription fees?':
      'VerifyID Plus may offer both free and paid versions of the app, with additional features or services available through subscription plans.',
  'How does VerifyID Plus ensure the security and privacy of user data?':
      'VerifyID Plus employs various security measures such as encryption, multi-factor authentication, and regular security audits to protect user data and privacy.',
  'What types of documents can be verified using VerifyID Plus?':
      "VerifyID Plus supports verification of various government-issued documents such as driver's licenses, passports, ID cards, and more.",
  'How accurate is the verification process in identifying fraudulent documents?':
      'The verification process used by VerifyID Plus is typically highly accurate in identifying fraudulent documents, thanks to advanced algorithms and access to government databases.',
  'Can VerifyID Plus be used for both personal and business purposes?':
      'Yes, VerifyID Plus can usually be used for both personal and business purposes, with tailored solutions available for businesses.',
  'Are there any restrictions on who can use VerifyID Plus?':
      'VerifyID Plus may have certain age or residency requirements for users, depending on local regulations and policies.',
  'What are the benefits of using VerifyID Plus compared to traditional identity verification methods?':
      'The benefits of using VerifyID Plus include faster verification times, increased accuracy, enhanced security measures, and greater convenience compared to traditional identity verification methods.',
  'How can I provide feedback or suggestions for improving VerifyID Plus?':
      'You can typically provide feedback or suggestions for improving VerifyID Plus within the app by accessing the feedback or support section and submitting your comments.',
  'Where can I find more information about VerifyID Plus, such as user reviews or testimonials?':
      'You can usually find more information about VerifyID Plus, including user reviews, testimonials, and press releases, on the official website, app stores, and social media channels.'
};

var topics = ['Getting\nStarted', 'Search and\nVerification', 'Account\nManagement', 'FAQs'];
var explainers = [
  'Guides through setup and support access.',
  'Helps you find info and verify documents.',
  'Manages your account, passwords, and security.',
  'Answers common questions.'
];

var xyz = {
  'Search and Verification': [
    'Search Functionality and Document Verification',
    'Tracking Verification Process',
    'Multiple Document Verification and Tips',
    'Verification Process Duration and Limits',
    'Ensuring Successful Verification',
    'Accuracy and Reliability of Verification Results'
  ],
  'Account Management': [
    'Account Creation and Information Modification',
    'Password Management and Security Measures',
    'Deactivating or Deleting Accounts',
    'Managing Multiple Devices and Accounts',
    'Account-related Notifications and Alerts'
  ],
  'Getting Started': [
    'Initial Steps and Identity Verification',
    'Previewing Verification Requirements',
    'Tutorials and Guides for New Users',
    'Prerequisites and Compatibility',
    'Accessing Customer Support and Special Features',
    'Common Mistakes to Avoid'
  ],
  'FAQs': [
    'Understanding VerifyID Plus and its Functionality',
    'Pricing Model and Subscription Fees',
    'Security Measures and Privacy Protection',
    'Supported Document Types',
    'Accuracy in Identifying Fraudulent Documents',
    'Usage for Personal and Business Purposes',
    'User Restrictions and Requirements',
    'Advantages over Traditional Verification Methods',
    'Providing Feedback and Suggestions',
    'Finding Additional Information and Resources'
  ]
};
