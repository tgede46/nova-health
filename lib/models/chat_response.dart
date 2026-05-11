class Pharmacy {
  final String name;
  final String address;
  final String phone;
  final double distance;
  final String mapLink;
  final String message;

  Pharmacy({
    required this.name,
    required this.address,
    required this.phone,
    required this.distance,
    required this.mapLink,
    required this.message,
  });

  factory Pharmacy.fromJson(Map<String, dynamic> json) {
    return Pharmacy(
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      distance: (json['distance'] as num?)?.toDouble() ?? 0.0,
      mapLink: json['map_link'] ?? '',
      message: json['message'] ?? '',
    );
  }
}

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
    dynamic parsedReponse = json['reponse_texte'];
    
    if (json['intention'] == 'PHARMACIE' && parsedReponse is List) {
      parsedReponse = parsedReponse.map((p) => Pharmacy.fromJson(p)).toList();
    }

    return ChatResponse(
      intention: json['intention'] ?? '',
      motCle: json['mot_cle'] ?? '',
      message: json['message'] ?? '',
      reponseTexte: parsedReponse,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'intention': intention,
      'mot_cle': motCle,
      'message': message,
      'reponse_texte': reponseTexte is List<Pharmacy> 
          ? (reponseTexte as List<Pharmacy>).map((p) => {
            'name': p.name,
            'address': p.address,
            'phone': p.phone,
            'distance': p.distance,
            'map_link': p.mapLink,
            'message': p.message,
          }).toList()
          : reponseTexte,
    };
  }
}

