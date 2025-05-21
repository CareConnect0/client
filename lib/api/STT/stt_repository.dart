import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class STTRepository {
  final String _baseUrl = 'http://54.180.31.196/api/ai/stt';

  Future<String> uploadAudioForSTT(String audioPath, bool isSchedule) async {
    final uri = Uri.parse(
      isSchedule ? '$_baseUrl/schedule' : '$_baseUrl/raw',
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
      return recognizedText;
    } else {
      print('❌ 업로드 실패: ${response.statusCode}');
      final decodedResponse = utf8.decode(response.bodyBytes);
      print(decodedResponse);
      throw Exception('STT 서버 업로드 실패');
    }
  }
}
