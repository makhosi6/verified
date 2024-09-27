import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:verified/helpers/logger.dart';

class VerifiedAppAnalytics {
  // Pages
  static const String PAGE_HOME = 'home';
  static const String PAGE_SEARCH = 'search';
  static const String PAGE_VERIFICATION = 'verification';
  static const String PAGE_ACCOUNT = 'account';
  static const String PAGE_FAQ = 'FAQs';
  static const String PAGE_SETTINGS = 'settings';
  static const String PAGE_SUPPORT = 'support';
  static const String PAGE__HISTORY = 'history';

// Features
  static const String FEATURE_QUICK_VERIFICATION = 'quick_verification';
  static const String FEATURE_COMPREHENSIVE_VERIFICATION = 'comprehensive_verification';
  static const String FEATURE_BULK_VERIFICATION = 'bulk_verification';
  static const String FEATURE_SEARCH_DOCUMENTS = 'search_documents';
  static const String FEATURE_TRACK_VERIFICATION = 'track_verification_status';
  static const String FEATURE_MULTIPLE_DOCUMENTS = 'use_multiple_documents';
  static const String FEATURE_UPDATE_ACCOUNT = 'update_account_information';
  static const String FEATURE_CHANGE_PASSWORD = 'change_password';
  static const String FEATURE_RESET_PASSWORD = 'reset_password';
  static const String FEATURE_LINK_MULTIPLE_DEVICES = 'link_multiple_devices';
  static const String FEATURE_DEACTIVATE_ACCOUNT = 'deactivate_account';
  static const String FEATURE_VERIFY_FROM_HOME = 'verify_from_home';
  static const String FEATURE_VERIFY_FROM_ACCOUNT = 'verify_from_account';
  static const String FEATURE_VERIFY_FROM_HISTORY = 'verify_from_history';
  static const String FEATURE_UPDATE_PROFILE_PICTURE = 'update_profile_picture';
  static const String FEATURE_TEST_USER_LOGIN = 'test_user_login';
  static const String FEATURE_QUICK_VERIFICATION_ID = 'quick_verification_id';
  static const String FEATURE_QUICK_VERIFICATION_PHONE = 'quick_verification_phone';
  static const String FEATURE_SEND_COMMS_TO_CANDIDATE = 'send_comms_to_candidate';
  static const String FEATURE_SKIP_HOW_IT_WORKS = 'skip_how_it_works';
  static const String FEATURE_VERIFY_FROM_HOW_IT_WORKS = 'verify_from_how_it_works';
  static const String FEATURE_DID_TRIGGER_A_WEBVIEW = 'did_trigger_a_webview';

// Actions
  static const String ACTION_SPLASH_SCREEN = 'splash_screen_widget';
  static const String ACTION_PROGRESS_INDICATOR = 'progress_indicator_widget';
  static const String ACTION_OPEN_LEARN_MORE = 'open_learn_more';
  static const String ACTION_START_VERIFICATION = 'start_verification';
  static const String ACTION_UPLOAD_DOCUMENT = 'upload_document';
  static const String ACTION_SUBMIT_VERIFICATION = 'submit_verification';
  static const String ACTION_CHECK_VERIFICATION_STATUS = 'check_verification_status';
  static const String ACTION_RETRY_VERIFICATION = 'retry_verification';
  static const String ACTION_TRACK_VERIFICATION_STATUS = 'track_verification_status';
  static const String ACTION_LOGIN = 'login';
  static const String ACTION_LOGOUT = 'logout';
  static const String ACTION_DELETED_ACCOUNT = 'delete_account';
  static const String ACTION_SWITCH_ACCOUNTS = 'switch_accounts';
  static const String ACTION_SEARCH = 'search';
  static const String ACTION_NAVIGATE_TO_SETTINGS = 'navigate_to_settings';
  static const String ACTION_UPDATE_PERSONAL_DETAILS = 'update_personal_details';
  static const String ACTION_CONTACT_SUPPORT = 'contact_support';
  static const String ACTION_CANDIDATE_COMPLETED_VERIFICATION = 'candidate_completed_verification';
  static const String ACTION_STARTED_VERIFICATION_PROCESS = 'started_verification_process';
  static const String ACTION_RETAKE_SELFIE_IMAGE = 'retake_selfie_image';
  static const String ACTION_RETAKE_SCANNED_DOC = 'retake_scanned_doc';
  static const String ACTION_PROCESSED_AFTER_DOC_SCANNER = 'processed_after_doc_scanner';
  static const String ACTION_PROCESSED_AFTER_SELFIE = 'processed_after_selfie';
  static const String ACTION_READ_GUIDELINES_NOTES = 'read_guidelines_notes';
  static const String ACTION_BACK_FROM_SELFIE_CAMERA = 'back_from_selfie_camera';
  static const String ACTION_BACK_FROM_DOC_SCANNER = 'back_from_doc_scanner';
  static const String ACTION_SELECT_DOC_TYPE = 'select_doc_type';
  static const String ACTION_DID_MANUALLY_CAPTURE_SELFIE = 'did_manually_capture_selfie';
  static const String ACTION_TOPUP_FROM_HOME = 'topup_from_home';
  static const String ACTION_TOPUP_FROM_ACCOUNT = 'topup_from_account';
  static const String ACTION_TOPUP_DURING_VERIFICATION = 'topup_during_verification';
  static const String ACTION_TOPUP_BANNER = 'topup_from_banner';
  static const String ACTION_READ_DOCUMENTATION = 'read_documentation';
  static const String ACTION_START_VERIFICATION_FROM_HOME = 'start_verification_from_home';
  static const String ACTION_TRIGGER_VERIFICATION_WITH_DEEP_LINK = 'trigger_verification_with_deep_link';
  static const String ACTION_HOME_IT_WORKS = 'home_it_works';
  static const String ACTION_LOGIN_FROM_ACCOUNT_PAGE = 'login_from_account_page';
  static const String ACTION_OPEN_YOUTUBE_VIDEO = 'open_youtube_video';
  static const String ACTION_OPEN_DETAILED_TUTORIAL = 'open_detailed_tutorial';
  static const String ACTION_UPDATE_NOTIFICATION_SETTINGS = 'update_notification_settings';
  static const String ACTION_BACK_FROM_CONFIRM_CANDIDATE_DETAILS = 'back_from_confirm_candidate_details';
  static const String ACTION_BACK_CREATE_CANDIDATE_DETAILS = 'back_from_create_candidate_details';
  static const String ACTION_CANDIDATE_DID_UPDATE_DETAILS = 'candidate_did_update_capture_details';
  static const String ACTION_REFRESH_APP_FROM_ERROR_PAGE = 'refresh_app_from_error_page';
  static const String ACTION_CLOSE_APP_FROM_ERROR_PAGE = 'close_app_from_error_page';
  static const String ACTION_ON_SUCCESSFUL_PAYMENT = 'successful_payment';
  static const String ACTION_ON_FAILED_PAYMENT = 'failed_payment';
  static const String ACTION_ON_PAYMENT_CANCELLED = 'cancelled_payment';
  static const String ACTION_VERIFICATION_VIA_URL = 'start_verification_with_a_link';
  static const String ACTION_DID_PASTE_A_VERIFICATION_URL = 'user_did_paste_a_verification_url';
  static const String ACTION_LOG_SUPPORT_TICKET = 'log_a_support_help_ticket';

  /// Send feature usage event to analytics
  static void logFeatureUsed(String feature, [Map<String, dynamic>? args]) {
    FirebaseAnalytics.instance.logEvent(
      name: 'verified_app_feature_event',
      parameters: {'feature': feature}..addAll(args ?? {}),
    );
    verifiedLogger('Feature used logged: $feature');
  }

  /// Send action event to analytics
  static void logActionTaken(String action, [Map<String, dynamic>? args]) {
    FirebaseAnalytics.instance.logEvent(
      name: 'verified_app_action_event',
      parameters: {'action': action}..addAll(args ?? {}),
    );
    verifiedLogger('Action taken logged: $action');
  }
}
