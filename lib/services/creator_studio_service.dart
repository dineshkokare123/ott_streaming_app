import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UserCreation {
  final String id;
  final String title;
  final String videoUrl;
  final String description;
  final int likes;
  final DateTime createdAt;

  UserCreation({
    required this.id,
    required this.title,
    required this.videoUrl,
    required this.description,
    this.likes = 0,
    required this.createdAt,
  });
}

class CreatorStudioService extends ChangeNotifier {
  final List<UserCreation> _myCreations = [];

  List<UserCreation> get myCreations => List.unmodifiable(_myCreations);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // api.video endpoints
  final String _baseUrl = 'https://ws.api.video';

  Future<void> fetchLiveStreams() async {
    final apiKey = dotenv.env['API_VIDEO_KEY'];
    if (apiKey == null) {
      debugPrint('⚠️ API_VIDEO_KEY not found in .env');
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/live-streams'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> streams = data['data'];

        // Map api.video streams to UserCreation (or a new LiveStream model)
        // For now, we'll just log them to prove connection
        debugPrint('🎥 Live Streams fetched: ${streams.length}');
        for (var stream in streams) {
          debugPrint(' - ${stream['name']} (ID: ${stream['liveStreamId']})');
        }
      } else {
        debugPrint('❌ Failed to fetch live streams: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('❌ Error fetching live streams: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createLiveStream(String name) async {
    final apiKey = dotenv.env['API_VIDEO_KEY'];
    if (apiKey == null) return;

    _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/live-streams'),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({'name': name, 'record': true, 'public': true}),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        debugPrint('✅ Live Stream Created: ${data['liveStreamId']}');
        debugPrint('🔴 RTMP Key: ${data['streamKey']}');

        // Add to local list
        final newCreation = UserCreation(
          id: data['liveStreamId'],
          title: data['name'],
          description: "Live Stream",
          videoUrl: data['assets']['player'], // Player URL
          createdAt: DateTime.now(),
        );

        _myCreations.insert(0, newCreation);
      } else {
        debugPrint(
          '❌ Failed to create live stream: ${response.statusCode} - ${response.body}',
        );
      }
    } catch (e) {
      debugPrint('❌ Error creating live stream: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> uploadCreation(
    String title,
    String description, {
    String? filePath,
  }) async {
    final apiKey = dotenv.env['API_VIDEO_KEY'];
    if (apiKey == null) {
      debugPrint("❌ Missing API_VIDEO_KEY");
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      if (filePath != null) {
        final jFile = File(filePath); // Requires input dart:io
        debugPrint("🔵 Starting upload for: $title");

        // 1. Create Video Container
        final createResponse = await http.post(
          Uri.parse('$_baseUrl/videos'),
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          body: jsonEncode({
            'title': title,
            'description': description,
            'public': true,
            'mp4Support': true, // Ensure mp4 availability
          }),
        );

        if (createResponse.statusCode != 201) {
          throw Exception(
            "Failed to create video container: ${createResponse.body}",
          );
        }

        final videoData = jsonDecode(createResponse.body);
        final videoId = videoData['videoId'];
        debugPrint("✅ Video Container created: $videoId");

        // 2. Upload File Content
        final request = http.MultipartRequest(
          'POST',
          Uri.parse('$_baseUrl/videos/$videoId/source'),
        );
        request.headers['Authorization'] = 'Bearer $apiKey';
        request.files.add(await http.MultipartFile.fromPath('file', filePath));

        debugPrint("🔵 Uploading file bytes...");
        final streamResponse = await request.send();
        final uploadResponse = await http.Response.fromStream(streamResponse);

        if (uploadResponse.statusCode == 201) {
          final finalData = jsonDecode(uploadResponse.body);
          debugPrint("✅ Video Uploaded Successfully!");
          debugPrint("🔗 Player: ${finalData['assets']['player']}");
          debugPrint("🔗 HLS: ${finalData['assets']['hls']}");

          _myCreations.insert(
            0,
            UserCreation(
              id: videoId,
              title: title,
              description: description,
              videoUrl:
                  finalData['assets']['hls'] ?? finalData['assets']['player'],
              createdAt: DateTime.now(),
            ),
          );
        } else {
          throw Exception(
            "Failed to upload file bytes: ${uploadResponse.body}",
          );
        }
      } else {
        // Fallback or Test Mode (No file)
        await Future.delayed(const Duration(seconds: 2));
        _myCreations.insert(
          0,
          UserCreation(
            id: DateTime.now().toString(),
            title: title,
            description: description,
            videoUrl: 'https://placeholder.com/video.mp4',
            createdAt: DateTime.now(),
          ),
        );
      }
    } catch (e) {
      debugPrint("❌ Upload Error: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteCreation(String id) async {
    _myCreations.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}
