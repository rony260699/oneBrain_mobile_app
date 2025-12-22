import 'package:OneBrain/repo_api/dio_helper.dart';
import 'package:OneBrain/repo_api/rest_constants.dart';
import 'package:flutter/foundation.dart';

/// Notification type for Slack alerts
enum SlackNotificationType { capExceeded, modelError }

/// Service to trigger Slack notifications when free models fail
class SlackNotificationService {
  static final SlackNotificationService _instance =
      SlackNotificationService._internal();
  factory SlackNotificationService() => _instance;
  SlackNotificationService._internal();

  /// Slack channel ID from environment
  static const String slackChannelId = 'C08BCUU5MFW';

  /// Triggers a Slack notification through backend when a free model fails
  ///
  /// Parameters:
  /// - [type]: Type of notification (cap_exceeded or model_error)
  /// - [modelName]: Name of the model that failed
  /// - [errorMessage]: Optional error message for context
  Future<void> triggerSlackNotification({
    required SlackNotificationType type,
    required String modelName,
    String? errorMessage,
  }) async {
    try {
      final String title =
          type == SlackNotificationType.capExceeded
              ? '⚠️ Free model *$modelName* reached its usage cap'
              : '🚨 Free model *$modelName* failed due to an internal error';

      final List<Map<String, String>> fields = [
        {'label': 'Model', 'value': modelName},
        {
          'label': 'Issue Type',
          'value':
              type == SlackNotificationType.capExceeded
                  ? 'Usage Cap Reached'
                  : 'Model Error',
        },
        {
          'label': 'Next Steps',
          'value': 'Try switching to a premium model or retry later.',
        },
        {
          'label': 'Environment',
          'value': kDebugMode ? 'development' : 'production',
        },
      ];

      // Add error message if provided
      if (errorMessage != null && errorMessage.isNotEmpty) {
        fields.add({'label': 'Error Details', 'value': errorMessage});
      }

      final Map<String, dynamic> requestBody = {
        'channel': slackChannelId,
        'title': title,
        'fields': fields,
      };

      if (kDebugMode) {
        print('📤 Sending Slack notification:');
        print('   Type: ${type.name}');
        print('   Model: $modelName');
        print('   Channel: $slackChannelId');
      }

      final response = await DioHelper.postData(
        url: RestConstants.slackNotify,
        data: requestBody,
        isHeader: true,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (kDebugMode) {
          print('✅ Slack fallback notification sent via backend');
        }
      } else {
        if (kDebugMode) {
          print(
            '⚠️ Slack notification returned status: ${response.statusCode}',
          );
        }
      }
    } catch (err) {
      // Ensure notification failure doesn't block main flow
      if (kDebugMode) {
        print('❌ Failed to send Slack notification: $err');
      }
    }
  }

  /// Analyzes error and determines the notification type
  ///
  /// Returns [SlackNotificationType.capExceeded] if error is related to rate limits,
  /// otherwise returns [SlackNotificationType.modelError]
  SlackNotificationType analyzeErrorType(
    String errorMessage, {
    int? statusCode,
  }) {
    final String msg = errorMessage.toLowerCase();

    // Check for cap/limit keywords
    final bool isKeywordCapError =
        msg.contains('cap') ||
        msg.contains('quota') ||
        msg.contains('limit') ||
        msg.contains('rate limit exceeded') ||
        msg.contains('429');

    // Check for status code 429 (Too Many Requests)
    final bool isStatusCapError = statusCode == 429;

    final bool isCapError = isKeywordCapError || isStatusCapError;

    return isCapError
        ? SlackNotificationType.capExceeded
        : SlackNotificationType.modelError;
  }
}
