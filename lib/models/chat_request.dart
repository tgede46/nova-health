class ChatRequest {
  final String userMessage;
  final double userLat;
  final double userLon;

  ChatRequest({
    required this.userMessage,
    required this.userLat,
    required this.userLon,
  });

  Map<String, dynamic> toJson() {
    return {
      'user_message': userMessage,
      'user_lat': userLat,
      'user_lon': userLon,
    };
  }
}
