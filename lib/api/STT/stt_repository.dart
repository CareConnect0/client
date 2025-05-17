import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';

class STTRepository {
  final String _baseUrl = 'http://localhost:8000/api/ai/stt'; // TODO: 배포 후 수정

  Future<String> uploadAudioForSTT(String audioPath) async {
    final uri = Uri.parse(_baseUrl);

    final request = http.MultipartRequest('POST', uri)
      ..files.add(
        await http.MultipartFile.fromPath(
          'file', // ✅ 서버에서 요구하는 키
          audioPath,
          contentType: MediaType('audio', 'wav'), // ✅ MIME type 고정
        ),
      );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 200) {
      final decoded = response.body;
      print('✅ 업로드 성공: $decoded');
      final decodedJson = jsonDecode(response.body);
      final recognizedText = decodedJson['data']['text'];
      print('📝 인식된 텍스트: $recognizedText');
      return recognizedText;
    } else {
      print('❌ 업로드 실패: ${response.statusCode}');
      print(response.body);
      throw Exception('STT 서버 업로드 실패');
    }
  }
}
