class ChatResponse {
  final String intention;
  final String motCle;
  final String message;
  final dynamic reponseTexte;

  ChatResponse({
    required this.intention,
    required this.motCle,
    required this.message,
    required this.reponseTexte,
  });

  factory ChatResponse.fromJson(Map<String, dynamic> json) {
    return ChatResponse(
      intention: json['intention'] ?? '',
      motCle: json['mot_cle'] ?? '',
      message: json['message'] ?? '',
      reponseTexte: json['reponse_texte'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'intention': intention,
      'mot_cle': motCle,
      'message': message,
      'reponse_texte': reponseTexte,
    };
  }
}
