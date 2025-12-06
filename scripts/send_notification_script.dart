// ignore_for_file: avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:googleapis_auth/auth_io.dart';

Future<void> main(List<String> args) async {
  if (args.isEmpty) {
    print('Usage: dart scripts/send_notification_script.dart <DEVICE_TOKEN>');
    exit(1);
  }

  final deviceToken = args[0];
  final serviceAccountPath = 'scripts/service_account.json';

  if (!File(serviceAccountPath).existsSync()) {
    print('❌ Error: scripts/service_account.json not found!');
    print('👉 Please save your Firebase Service Account JSON to this file.');
    exit(1);
  }

  print('🔵 Reading Service Account...');
  final serviceAccountContent = await File(serviceAccountPath).readAsString();
  final serviceAccount = ServiceAccountCredentials.fromJson(
    serviceAccountContent,
  );

  print('🔵 Authenticating...');
  final scopes = ['https://www.googleapis.com/auth/firebase.messaging'];
  final client = await clientViaServiceAccount(serviceAccount, scopes);

  // Extract project ID from JSON
  final projectId = jsonDecode(serviceAccountContent)['project_id'];

  print('🔵 Sending Notification to $projectId...');

  final notification = {
    'message': {
      'token': deviceToken,
      'notification': {
        'title': 'StreamVibe Test 🎬',
        'body': 'This is a real-time notification from your test script! 🚀',
      },
      'data': {
        'type': 'new_release',
        'content_id': '12345',
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      },
    },
  };

  final response = await client.post(
    Uri.parse(
      'https://fcm.googleapis.com/v1/projects/$projectId/messages:send',
    ),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(notification),
  );

  if (response.statusCode == 200) {
    print('✅ Notification sent successfully!');
    print('Response: ${response.body}');
  } else {
    print('❌ Failed to send notification.');
    print('Status Code: ${response.statusCode}');
    print('Response: ${response.body}');
    print('-------------------');
    print('Troubleshooting:');
    print('1. Check if the Device Token is correct.');
    print(
      '2. Ensure "Firebase Cloud Messaging API (V1)" is enabled in Google Cloud Console.',
    );
  }

  client.close();
}
