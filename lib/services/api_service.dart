import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../models/chat_request.dart';
import '../models/chat_response.dart';

class ApiService {
  // On s'assure que le baseUrl inclut bien le suffixe /api si nécessaire
  static const String baseUrl = 'https://bilalbill-nova-healt-bot-api.hf.space';

  /// Sends a text message to the chat endpoint.
  Future<ChatResponse> sendChatMessage(ChatRequest request) async {
    final url = Uri.parse('$baseUrl/api/chat');
    
    print('DEBUG API: Envoi à $url');
    print('DEBUG API: Body: ${jsonEncode(request.toJson())}');
    
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode(request.toJson()),
      ).timeout(const Duration(seconds: 30));

      print('DEBUG API: Status Code: ${response.statusCode}');
      print('DEBUG API: Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return ChatResponse.fromJson(data);
      } else {
        throw Exception('Erreur Serveur (${response.statusCode}): ${response.body}');
      }
    } catch (e) {
      print('DEBUG API: ERREUR CATCH: $e');
      throw Exception('Erreur de connexion: $e');
    }
  }

  /// Sends an audio file to the audio endpoint.
  Future<ChatResponse> sendAudioMessage({
    required File audioFile,
    required double lat,
    required double lon,
  }) async {
    final url = Uri.parse('$baseUrl/api/audio');
    
    try {
      var request = http.MultipartRequest('POST', url);
      
      request.fields['user_lat'] = lat.toString();
      request.fields['user_lon'] = lon.toString();
      
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          audioFile.path,
        ),
      );

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(utf8.decode(response.bodyBytes));
        return ChatResponse.fromJson(data);
      } else {
        throw Exception('Failed to load response: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error sending audio message: $e');
    }
  }
}
