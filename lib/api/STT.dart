import 'dart:convert';
import 'dart:io';
import 'package:googleapis/speech/v1.dart';
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;

/// STT 처리 함수
Future<void> sendAudioToGoogleSTT(File audioFile) async {
  // 서비스 계정 키 파일 경로
  final serviceAccountJson = File('assets/your_service_account.json');
  final credentials = ServiceAccountCredentials.fromJson(
    json.decode(await serviceAccountJson.readAsString()),
  );

  // 인증
  final scopes = [SpeechApi.cloudPlatformScope];
  final authClient = await clientViaServiceAccount(credentials, scopes);
  final speechApi = SpeechApi(authClient);

  // 오디오 파일 base64 인코딩
  final audioBytes = await audioFile.readAsBytes();
  final audioBase64 = base64Encode(audioBytes);

  // 요청 생성
  final request = RecognizeRequest.fromJson({
    "config": {
      "encoding": "LINEAR16",
      "sampleRateHertz": 16000,
      "languageCode": "ko-KR"
    },
    "audio": {"content": audioBase64}
  });

  // 요청 전송
  final response = await speechApi.speech.recognize(request);
  final transcript = response.results?.first.alternatives?.first.transcript;

  print("STT 결과: $transcript");
}
