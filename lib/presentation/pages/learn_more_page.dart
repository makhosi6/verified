import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:verified/infrastructure/analytics/repository.dart';
import 'package:verified/presentation/theme.dart';
import 'package:verified/presentation/utils/error_warning_indicator.dart';
import 'package:verified/presentation/utils/navigate.dart';
import 'package:verified/presentation/widgets/buttons/app_bar_action_btn.dart';
import 'package:verified/presentation/widgets/buttons/base_buttons.dart';
import 'package:verified/presentation/widgets/popups/help_form_popup.dart';

class LearnMorePage extends StatefulWidget {
   LearnMorePage({super.key}){
      VerifiedAppAnalytics.logActionTaken(VerifiedAppAnalytics.ACTION_READ_DOCUMENTATION);
      VerifiedAppAnalytics.logActionTaken(VerifiedAppAnalytics.ACTION_OPEN_LEARN_MORE);
   }

  @override
  State<LearnMorePage> createState() => _LearnMorePageState();
}

class _LearnMorePageState extends State<LearnMorePage> with TickerProviderStateMixin {
  ///
  List<TutorialData> content = helpQuestionContent[0] ?? helpQuestionContent.values.first;
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
                centerTitle: false,
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
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(right: 12.0),
                    child: BaseButton(
                      key: UniqueKey(),
                      onTap: () async => await showHelpPopUpForm(context, title: 'Submit Help Ticket'),
                      height: 49.0,
                      label: 'Get Help',
                      color: Colors.white,
                      bgColor: darkerPrimaryColor,
                      borderColor: const Color.fromARGB(70, 237, 237, 237),
                      iconBgColor: const Color.fromARGB(70, 237, 237, 237),
                      buttonIcon: const Icon(
                        Icons.support_outlined,
                        color: Colors.white,
                      ),
                      buttonSize: ButtonSize.small,
                      hasBorderLining: true,
                    ),
                  )
                ],
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
                                              maxLines: 3,
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
                                            final tutorial = content[index];
                                            var question = tutorial.question;
                                            var answer = tutorial.answer;
                                            var detailedAnswer = tutorial.detailedAnswer;

                                            return ExpansionTile(
                                              key: Key('expansion_tile_${tutorial.hashCode}'),
                                              tilePadding: const EdgeInsets.all(0.0),
                                              backgroundColor: Colors.grey[100],
                                              collapsedBackgroundColor: Colors.transparent,
                                              childrenPadding: EdgeInsets.only(bottom: primaryPadding.vertical / 2),
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
                                                RichText(
                                                  textAlign: TextAlign.start,
                                                  text: TextSpan(
                                                    children: [
                                                      TextSpan(
                                                        text: answer,
                                                        style: DefaultTextStyle.of(context).style,
                                                      ),
                                                      const TextSpan(
                                                        text: '  ',
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () => navigate(
                                                    context,
                                                    page: DetailedTutorialPage(
                                                      key: ValueKey('detailed_tutorial_page_${tutorial.hashCode}'),
                                                      question: question,
                                                      answer: detailedAnswer,
                                                    ),
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(top: 8),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          'Learn More',
                                                          style: GoogleFonts.dmSans(color: primaryColor),
                                                        ),
                                                        Padding(
                                                          padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                                          child: Icon(
                                                            Icons.arrow_forward_ios_rounded,
                                                            color: primaryColor,
                                                            size: 14.0,
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                )
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
            margin: EdgeInsets.only(right: primaryPadding.right),
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

final Map<int, List<TutorialData>> helpQuestionContent = {
  /// Getting Started
  0: gettingStarted,

  /// Search and Verification
  1: searchAndVerification,

  /// Account Management
  2: accountManagement,

  /// FAQs
  3: faqs,
};

final gettingStarted = [
  TutorialData(
    question: 'How do I get started with the Verified App?',
    answer: 'Download the app from your app store, create an account, and follow the onboarding instructions.',
    detailedAnswer: RichText(
      text: TextSpan(
          style: GoogleFonts.ibmPlexSans(
            color: Colors.black87,
            fontSize: 16.0,
            height: 1.6,
          ),
          children: const [
            TextSpan(text: 'Getting started with the Verified App:\n', style: TextStyle(fontWeight: FontWeight.bold)),
            TextSpan(text: '1. '),
            TextSpan(text: 'Download the App: Find the Verified App in the App Store or Google Play and install it.\n'),
            TextSpan(text: '2. '),
            TextSpan(text: 'Create an Account: Open the app and sign up using your email and a password.\n'),
            TextSpan(text: '3. '),
            TextSpan(
                text:
                    'Follow Onboarding Instructions: Complete the onboarding process to set up your profile and preferences.\n'),
          ]),
    ),
  ),
  TutorialData(
    question: 'What should I do after creating my account?',
    answer: 'After creating your account, verify your email and complete your profile setup.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(text: 'After creating your account:\n', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '1. '),
          TextSpan(
              text: 'Verify Your Email: Check your inbox for a confirmation email and click the link to verify.\n'),
          TextSpan(text: '2. '),
          TextSpan(
              text:
                  'Complete Profile Setup: Enter additional details in your profile settings to enhance your verification experience.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'How do I navigate the app?',
    answer: 'Use the bottom navigation bar to access key sections of the app easily.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(text: 'Navigating the app is simple:\n', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '1. '),
          TextSpan(text: 'Home: View your dashboard for recent activities and updates.\n'),
          TextSpan(text: '2. '),
          TextSpan(text: 'Verification: Access the verification section to upload documents and check statuses.\n'),
          TextSpan(text: '3. '),
          TextSpan(text: 'Profile: Manage your account settings and personal information in the profile section.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'What features should I explore first?',
    answer: 'Start with the document upload feature and familiarize yourself with the verification process.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(text: 'Features to explore first:\n', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '1. '),
          TextSpan(text: 'Document Upload: Try uploading a document to see how the verification process works.\n'),
          TextSpan(text: '2. '),
          TextSpan(
              text:
                  'Notifications: Check notifications to stay updated on your verification statuses and other alerts.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'Are there any tutorials available?',
    answer: 'Yes, the app provides built-in tutorials to guide you through various features.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(
              text: 'Yes, you can find tutorials within the app:\n', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '1. '),
          TextSpan(text: 'Access Help Section: Go to the help section for step-by-step guides on using the app.\n'),
          TextSpan(text: '2. '),
          TextSpan(
              text:
                  'Watch Video Tutorials: Some features may have accompanying video tutorials for better understanding.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'What should I do if I encounter any issues?',
    answer: 'If you face any issues, contact customer support through the app for assistance.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(text: 'If you encounter any issues:\n', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '1. '),
          TextSpan(text: 'Use the Support Feature: Navigate to the support section within the app.\n'),
          TextSpan(text: '2. '),
          TextSpan(text: 'Contact Customer Support: Fill out the form with details of your issue and submit.\n'),
        ],
      ),
    ),
  ),
];

final searchAndVerification = [
  TutorialData(
    question: 'How can I search for specific information within the app?',
    answer:
        'Use the search bar at the top of the app to find specific documents or verifications quickly and efficiently.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(text: 'To search for specific information:\n', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '1. '),
          TextSpan(
              text:
                  'Use the Search Bar: Located at the top of the screen, enter keywords related to the info you are looking for.\n'),
          TextSpan(text: '2. '),
          TextSpan(text: 'Filters: Apply filters to narrow down your results by document type or date.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'What types of documents can I verify using the Verified App?',
    answer:
        'You can verify various government-issued documents, such as passports, driver\'s licenses, and national IDs.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(
              text: 'The Verified App supports various government-issued documents:\n',
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '- Driver\'s licenses\n'),
          TextSpan(text: '- Passports\n'),
          TextSpan(text: '- ID cards\n'),
          TextSpan(text: '- Birth certificates\n'),
          TextSpan(text: 'Check the documentation for any region-specific verifications supported.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'Is there a way to track the status of my verification process?',
    answer: 'Yes, the dashboard provides real-time updates on your verification\'s status and progress.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(text: 'Yes, tracking is available:\n', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '1. '),
          TextSpan(text: 'Dashboard: The status of your verifications is visible in the dashboard.\n'),
          TextSpan(text: '2. '),
          TextSpan(text: 'Notifications: You\'ll receive updates through notifications as the process progresses.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'Can I verify my identity using multiple documents?',
    answer: 'Yes, you may upload multiple documents if required for the verification process.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(
              text: 'Yes, multiple documents are supported for some verifications:\n',
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '1. '),
          TextSpan(
              text:
                  'Add More Documents: When uploading, select "Add another document" to include multiple IDs, passports, or other forms of identification.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'Are there any tips for ensuring a successful verification process?',
    answer: 'Ensure documents are clear, complete, and match the personal information you provided.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(text: 'Ensure documents are clear, complete, and match the personal information you provided.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'How long does it typically take for verification results to be processed?',
    answer: 'Most verifications are processed within minutes to a few hours, depending on complexity.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(
              text: 'The processing time depends on the complexity:\n', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '- Quick Verifications: These usually take a few minutes.\n'),
          TextSpan(
              text:
                  '- Comprehensive Verifications: These can take from a few hours to a full day, depending on the number of documents and checks required.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'Is there a limit to the number of verification attempts I can make?',
    answer: 'There may be limits on the number of verification attempts within a specific time to prevent misuse.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(
              text:
                  'There may be limits on the number of verification attempts within a specific time to prevent misuse.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'What should I do if my verification attempt fails?',
    answer: 'If a verification attempt fails, you\'ll be given instructions to retry or resolve the issue.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(
              text: 'If a verification attempt fails, you\'ll be given instructions to retry or resolve the issue.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'Are there additional verification steps for certain features?',
    answer: 'Yes, some features require additional verification for security and compliance purposes.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(text: 'Yes, some features require additional verification for security and compliance purposes.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'How does the Verified App ensure accuracy and reliability?',
    answer: 'The Verified App uses advanced technology and access to government databases to deliver accurate results.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(
              text:
                  'The Verified App uses advanced technology and access to government databases to deliver accurate results.\n'),
        ],
      ),
    ),
  ),
];

final accountManagement = [
  TutorialData(
    question: 'How do I create an account on the Verified App?',
    answer: 'Download the app, follow the prompts to sign up, and you\'re all set to begin verification.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(text: 'To create an account:\n', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '1. '),
          TextSpan(text: 'Download the App: Install the Verified App from the App Store or Google Play.\n'),
          TextSpan(text: '2. '),
          TextSpan(text: 'Sign Up: Open the app and enter your email, phone number, and a password to register.\n'),
          TextSpan(text: '3. '),
          TextSpan(
              text:
                  'Verify Your Email: Check your inbox for a confirmation email and click on the verification link.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'Can I change my account information after it\'s set up?',
    answer: 'Yes, you can update your account details such as email and password in the app\'s settings.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(text: 'Yes, you can update your account info:\n', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '1. '),
          TextSpan(text: 'Go to Settings: Navigate to the "Account Settings" section.\n'),
          TextSpan(text: '2. '),
          TextSpan(text: 'Edit Details: Update your email, phone number, or personal details as needed.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'Is there a way to reset my password if I forget it?',
    answer: 'Yes, click \'Forgot Password\' on the login screen and follow the instructions.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(text: 'If you forgot your password:\n', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '1. '),
          TextSpan(text: 'Click Forgot Password: On the login screen, click "Forgot Password".\n'),
          TextSpan(text: '2. '),
          TextSpan(text: 'Follow the Instructions: Enter your email to receive a password reset link.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'How can I update my personal details within the app?',
    answer: 'Go to account settings and select \'Edit Profile\' to update your personal information.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(text: 'To update your personal information:\n', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '1. '),
          TextSpan(text: 'Go to Profile Settings: Open the settings menu and select "Profile".\n'),
          TextSpan(text: '2. '),
          TextSpan(text: 'Make Changes: Edit your personal details and save.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'Are there any privacy settings I can adjust?',
    answer: 'Yes, you can manage your privacy settings under the account settings section.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(text: 'Yes, manage your privacy settings:\n', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '1. '),
          TextSpan(text: 'Navigate to Privacy Settings: Access the "Privacy" section in the settings.\n'),
          TextSpan(text: '2. '),
          TextSpan(text: 'Adjust Preferences: Change who can view your information or notifications.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'How do I delete my account?',
    answer:
        'To delete your account, go to settings, select "Account", and follow the instructions to delete your account permanently.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.8,
        ),
        children: const [
          TextSpan(text: 'To delete your account:\n', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '1. '),
          TextSpan(text: 'Open Account Settings: Navigate to the settings and select "Account".\n'),
          TextSpan(text: '2. '),
          TextSpan(text: 'Follow Instructions: Click on "Delete Account" and follow the prompts to confirm.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'Will deleting my account remove all my data?',
    answer: 'Yes, all your personal data will be permanently removed from our servers.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(text: 'Yes, deleting your account will remove all your data permanently.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'What should I do if I can\'t access my account?',
    answer: 'If you cannot access your account, follow the password reset procedure or contact support for assistance.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(text: 'If you can’t access your account:\n', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '1. '),
          TextSpan(text: 'Try Password Reset: Click on "Forgot Password" and follow the steps.\n'),
          TextSpan(text: '2. '),
          TextSpan(text: 'Contact Support: If issues persist, reach out to customer support for help.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'Are there any security measures in place to protect my account?',
    answer: 'Yes, we implement advanced encryption and two-factor authentication for enhanced security.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(
              text: 'Yes, several security measures are in place:\n', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '- Encryption: Your data is encrypted to protect against unauthorized access.\n'),
          TextSpan(
              text:
                  '- Two-Factor Authentication: We recommend enabling two-factor authentication for an added layer of security.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'Can I deactivate my account instead of deleting it?',
    answer: 'Yes, you have the option to deactivate your account temporarily without losing your data.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(
              text: 'Yes, you can deactivate your account temporarily:\n',
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '1. '),
          TextSpan(text: 'Go to Account Settings: Find the "Account" section in settings.\n'),
          TextSpan(text: '2. '),
          TextSpan(text: 'Select Deactivate: Follow the instructions to deactivate your account temporarily.\n'),
        ],
      ),
    ),
  ),
];

final faqs = [
  TutorialData(
    question: 'What is the Verified App?',
    answer: 'The Verified App is a mobile application designed to help users verify various documents securely.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(
              text: 'The Verified App is designed to help users verify various documents securely:\n',
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '1. '),
          TextSpan(text: 'User-Friendly Interface: Simple and intuitive navigation.\n'),
          TextSpan(text: '2. '),
          TextSpan(text: 'Document Security: Utilizes advanced encryption methods for data protection.\n'),
          TextSpan(text: '3. '),
          TextSpan(text: 'Real-Time Verification: Quick results for verification requests.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'How does the app protect my personal information?',
    answer: 'The app uses encryption and strict data privacy policies to safeguard user information.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(
              text: 'The app employs several measures to protect your personal information:\n',
              style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '- Data Encryption: All sensitive data is encrypted.\n'),
          TextSpan(text: '- Privacy Policies: Adheres to strict privacy policies to ensure data protection.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'Is the Verified App free to use?',
    answer: 'The app is free to download, but some verification features may require a fee.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(text: 'The Verified App is free to download:\n', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '- Free Features: Basic verification features are available for free.\n'),
          TextSpan(text: '- Paid Features: Some advanced features may require a payment or subscription.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'Can I use the app on multiple devices?',
    answer: 'Yes, you can log in on multiple devices using the same account.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(text: 'Yes, the app supports multiple devices:\n', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '- Log In: Use your credentials to log in on any compatible device.\n'),
          TextSpan(text: '- Sync: Your data will sync across devices for continuity.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'What should I do if I encounter technical issues?',
    answer: 'Contact customer support through the app for assistance with technical issues.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(text: 'If you encounter technical issues:\n', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '1. '),
          TextSpan(text: 'Reach Out: Contact customer support through the app.\n'),
          TextSpan(text: '2. '),
          TextSpan(text: 'Provide Details: Share specifics about the issue for prompt assistance.\n'),
        ],
      ),
    ),
  ),
  TutorialData(
    question: 'Where can I find help resources?',
    answer: 'Help resources are available within the app under the Help section.',
    detailedAnswer: RichText(
      text: TextSpan(
        style: GoogleFonts.ibmPlexSans(
          color: Colors.black87,
          fontSize: 16.0,
          height: 1.6,
        ),
        children: const [
          TextSpan(text: 'Help resources can be found:\n', style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: '- In-App Help: Navigate to the "Help" section for FAQs and tutorials.\n'),
          TextSpan(text: '- Online Resources: Visit our website for additional support materials.\n'),
        ],
      ),
    ),
  ),
];

var topics = ['Getting\nStarted', 'Search and\nVerification', 'Account\nManagement', 'FAQs'];
var explainers = [
  'Guides through setup and support access.',
  'Helps you find info and verify documents.',
  'Manages your account, passwords, and security.',
  'Answers common questions.'
];

class TutorialData {
  final String question;
  final String answer;
  final Widget detailedAnswer;

  TutorialData({required this.question, required this.answer, required this.detailedAnswer});
}

class DetailedTutorialPage extends StatefulWidget {
  final Widget answer;
  final String question;
  DetailedTutorialPage({super.key, required this.answer, required this.question}) {
    VerifiedAppAnalytics.logActionTaken(VerifiedAppAnalytics.ACTION_OPEN_DETAILED_TUTORIAL);
  }

  @override
  State<DetailedTutorialPage> createState() => _DetailedTutorialPageState();
}

class _DetailedTutorialPageState extends State<DetailedTutorialPage> {
  bool folded = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // SliverAppBar for a header image and title
          SliverAppBar(
            onStretchTrigger: () async {
              setState(() {
                folded = !folded;
              });
            },
            stretchTriggerOffset: 50,
            expandedHeight: 250.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.all(0),
              title: Container(
                width: MediaQuery.of(context).size.width,
                padding: primaryPadding.copyWith(top: 8, bottom: 8),
                decoration: BoxDecoration(
                  color: scaffoldBackgroundColor.withOpacity(0.5),
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      flex: 5,
                      child: SizedBox(
                        child: Text(
                          widget.question,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 1,
                      child: TextButton(
                        style: ButtonStyle(
                          padding: WidgetStateProperty.all(
                            const EdgeInsets.all(8).copyWith(right: 0),
                          ),
                          maximumSize: WidgetStateProperty.all(
                            const Size(80, 40),
                          ),
                        ),
                        onPressed: () {
                            VerifiedAppAnalytics.logActionTaken(VerifiedAppAnalytics.ACTION_OPEN_YOUTUBE_VIDEO);
                        },
                        child: Image.asset('assets/icons/youtube.png'),
                      ),
                    )
                  ],
                ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  color: neutralGrey,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                ),
                clipBehavior: Clip.hardEdge,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.network(
                      'https://images.unsplash.com/photo-1719937206255-cc337bccfc7d',
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      top: 50,
                      left: 20,
                      child: VerifiedBackButton(
                        key: const Key('learn-more-page-back-btn'),
                        isLight: true,
                        onTap: Navigator.of(context).pop,
                      ),
                    )
                  ],
                ),
              ),
              expandedTitleScale: 1,
            ),
            leadingWidth: 80.0,
            leading: const SizedBox.shrink(),
          ),
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
                horizontal: 12,
              ),
              child: const Text(
                'Click on the YouTube icon to watch the full tutorial on YouTube.',
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
              ),
            ),
          ),
          // SliverList for the blog content
          SliverList(
            delegate: SliverChildListDelegate(
              List.generate(
                20,
                (index) => Container(
                  key: ValueKey(index),
                  padding: const EdgeInsets.all(18.0),
                  child: widget.answer,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
