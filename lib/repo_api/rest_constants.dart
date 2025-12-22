class RestConstants {
  static const String baseUrl =
      'https://dev.onebrain.app/onebrain-server/api/v1/';

  // Auth
  static const String loginUrl = 'auth/login';
  static const String googleLoginUrl = 'auth/google-login';
  static const String registerUrl = 'auth/register';
  static const String sendSMSOTP = 'auth/send-sms-otp';
  static const String reSendSMSOTP = 'auth/resend-sms-otp';
  static const String verifySMSOTP = 'auth/verify-sms-otp';
  static const String sendEmailOTP = 'auth/send-email-otp';
  static const String reSendEmailOTP = 'auth/resend-email-otp';
  static const String verifyEmailOTP = 'auth/verify-email-otp';
  static const String deleteAccount = 'auth/delete-account';
  static const String addPhoneNumberAfterGoogleSignup =
      'auth/add-phone-number-after-google-signup';
  static const String verifyAddPhoneNumberOTP =
      'auth/verify-add-phone-number-otp';
  static const String searchAccount = 'auth/search-or-register';
  static const String sendForgotPasswordOTP = 'auth/send-forgot-password-otp';
  static const String reSendForgotPasswordOTP =
      'auth/resend-forgot-password-otp';
  static const String verifyForgotPasswordOTP =
      'auth/verify-forgot-password-otp';
  static const String resetPassword = 'auth/reset-password';
  static const String getTempUser = 'auth/get-temp-user';
  static const String refreshToken = 'auth/refresh-token';
  static const String getCurrentUser = 'auth/get-current-user';
  static const String updateProfile = 'auth/update-profile';
  static const String updateProfileImage = 'auth/update-profile-image';

  // Conversation
  static const String createNewChat = 'chat/create';
  static const String getSingleConversation =
      'conversation/get-single-conversation';
  static const String getAllConversation = 'conversation/get-all-conversations';
  static const String switchConversation = 'conversation/switch-conversation';
  static const String addMessage = 'conversation/add-message-to-conversation';
  static const String sendMessage = 'conversation/send-message';

  static const String chat = 'chat';
  static const String chatUserHistory = 'chat/user/history';
  static const String chatStatistics = 'chat/chat-statistics';

  // Attachment endpoints
  // static const String parseAttachmentsPreview ='conversation/parse-attachments-preview';

  static const String parseAttachmentsPreview =
      'files/parse-attachments-preview';
  static const String uploadFile = 'files/upload';

  static const String processAttachments = 'conversation/process-attachments';
  static const String processImageIntelligent =
      'conversation/process-image-intelligent';
  static const String processAudioTranscription =
      'conversation/process-audio-transcription';

  /// Payment ///
  static const String getPlanListUrl = 'plan/get-plans';
  static const String getTopUpPlanListUrl = 'plan/get-top-up-plans';
  static const String makePayment = 'payment/make-payment';
  static const String paymentStatus = 'payment/status/';
  static const String userSuccessfulPaymentList =
      'payment/user-successful-payment-list';

  // POST /payment/make-payment            # Initialize payment (SSLCommerz)
  // POST /payment/success/:tran_id        # Payment success callback
  // POST /payment/fail/:tran_id           # Payment failure callback
  // POST /payment/ipn                     # Instant Payment Notification
  // GET  /payment/user-successful-payment-list  # Get payment history
  // GET  /plan/get-plans                  # Get all subscription plans
  // GET  /plan/get-single-plan/:id        # Get specific plan details
  // GET  /plan/get-top-up-plans           # Get all top-up packages
  // GET  /plan/get-single-top-up-plan/:id # Get specific top-up details

  /// Folders ///
  static const String getFolders = 'chat/folders';
  static const String createFolder = 'chat/folders';
  static const String updateFolder = 'chat/folders/';
  static const String deleteFolder = 'chat/folders/';
  static const String moveChatToFolder = 'chat/';

  /// Slack ///
  static const String slackNotify = 'slack/notify';

  /// Usage History ///
  static const String usageHistory = 'usage-history';

  /// ImageX / Image Conversation ///
  static const String createImageConversation =
      'image-conversation/create-new-image-conversation';

  // Generate image with conversation ID
  static String generateImage(String conversationId) =>
      '${baseUrl}image-conversation/generate-image/$conversationId';
}
