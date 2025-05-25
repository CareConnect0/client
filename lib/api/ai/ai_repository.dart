import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:audioplayers/audioplayers.dart';
import 'package:client/api/Auth/auth_storage.dart';
import 'package:client/api/emergency/emergency_repository.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class AIRepository {
  final String _baseUrl = 'http://54.180.31.196/api/ai';

  /// STT 업로드
  Future<String> uploadAudioForSTT(String audioPath, bool isSchedule) async {
    final uri = Uri.parse(
      isSchedule ? '$_baseUrl/stt/schedule' : '$_baseUrl/stt/raw',
    );

    final request = http.MultipartRequest('POST', uri)
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          audioPath,
          contentType: MediaType('audio', 'wav'),
        ),
      );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    isSchedule ? print("Schedule 업로드") : print("채팅 업로드");

    if (response.statusCode == 200) {
      final decoded = response.body;
      print('✅ 업로드 성공: $decoded');
      final decodedJson = jsonDecode(response.body);
      final recognizedText = decodedJson['data'];
      print('📝 인식된 텍스트: $recognizedText');

      // 긴급상황 감지 호출
      if (!isSchedule) {
        try {
          final emergencyData = await uploadAudioForEmergency(audioPath);
          final isEmergency = emergencyData['is_emergency'];
          final keywords = emergencyData['keywords'];

          if (isEmergency == true) {
            final audioUrl = await EmergencyRepository()
                .uploadAudioForEmergencyCall(audioPath);
            await EmergencyRepository().createEmergencyFromAudioTrigger(
              audioUrl: audioUrl,
              keywords: keywords,
            );
            print("⚠️ 긴급상황 발생!");
          }
        } catch (e) {
          print("❌ 긴급상황 감지 중 오류 발생: $e");
        }
      }
      return recognizedText;
    } else {
      print('❌ 업로드 실패: ${response.statusCode}');
      final decodedResponse = utf8.decode(response.bodyBytes);
      print(decodedResponse);
      throw Exception('STT 서버 업로드 실패');
    }
  }

  /// TTS 재생
  final player = AudioPlayer();

  Future<void> playTTS(String text) async {
    final uri = Uri.parse('$_baseUrl/tts');
    final response = await http.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'text': text}),
    );

    if (response.statusCode == 200) {
      final Uint8List audioBytes = response.bodyBytes;

      // 메모리에서 직접 재생
      await player.play(BytesSource(audioBytes));
    } else {
      print('❌ TTS 실패: ${response.statusCode}');
      print(utf8.decode(response.bodyBytes));
      throw Exception('TTS 실패');
    }
  }

  /// 음성 긴급상황 감지
  Future<Map<String, dynamic>> uploadAudioForEmergency(String audioPath) async {
    final uri = Uri.parse('$_baseUrl/emergency');

    final request = http.MultipartRequest('POST', uri)
      ..files.add(
        await http.MultipartFile.fromPath(
          'file',
          audioPath,
          contentType: MediaType('audio', 'wav'),
        ),
      );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final decoded = response.body;
      print('✅ 긴급상황 감지 성공: $decoded');
      final decodedJson = jsonDecode(response.body);
      final isEmergency = decodedJson['data']['is_emergency'];
      final keywords = (decodedJson['data']['keywords'] as List).cast<String>();
      return {'is_emergency': isEmergency, 'keywords': keywords};
    } else {
      print('❌ 긴급상황 감지 실패: ${response.statusCode}');
      final decodedResponse = utf8.decode(response.bodyBytes);
      print(decodedResponse);
      throw Exception('긴급상황 감지 실패');
    }
  }

  /// AI 비서 답변
  Future<String> getAssistantAnswer(int roomId, String userInput) async {
    final uri = Uri.parse('$_baseUrl/assistant');
    final accessToken = await AuthStorage.getAccessToken();
    final refreshToken = await AuthStorage.getRefreshToken();

    final response = await http.post(
      uri,
      headers: {
        'Authorization': accessToken ?? '',
        'Refreshtoken': refreshToken ?? '',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'user_input': userInput, 'roomId': roomId}),
    );

    if (response.statusCode == 200) {
      final decodedJson = jsonDecode(response.body);
      return decodedJson['message'];
    } else {
      print('❌ AI 비서 답변 실패: ${response.statusCode}');
      print(utf8.decode(response.bodyBytes));
      throw Exception('AI 비서 답변 실패');
    }
  }
}
