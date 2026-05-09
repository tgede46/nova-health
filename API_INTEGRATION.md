# Documentation d'Intégration API Nova Health

Cette documentation décrit comment intégrer l'API Nova Health dans l'application Flutter.

## Base URL
L'API est hébergée à l'adresse suivante :
`https://bilalbill-nova-healt-bot-api.hf.space`

Tous les endpoints de l'API commencent par `/api`.

## Endpoints

### 1. Chat (Texte)
**URL** : `/api/chat`
**Méthode** : `POST`
**Description** : Envoie un message texte et les coordonnées GPS pour obtenir une orientation médicale.

**Requête (JSON)** :
```json
{
  "user_message": "J'ai mal à la tête",
  "user_lat": 5.3484,
  "user_lon": -4.0305
}
```

**Réponse (JSON)** :
```json
{
  "intention": "consultation",
  "mot_cle": "céphalée",
  "message": "Vous semblez souffrir d'un mal de tête...",
  "reponse_texte": "Je vous recommande de consulter un médecin si la douleur persiste."
}
```

### 2. Audio
**URL** : `/api/audio`
**Méthode** : `POST`
**Description** : Envoie un fichier audio et les coordonnées GPS.

**Requête (Multipart/Form-Data)** :
- `file` : Le fichier audio (ex: .m4a, .wav, .mp3)
- `user_lat` : Nombre (latitude)
- `user_lon` : Nombre (longitude)

**Réponse (JSON)** :
Même format que l'endpoint Chat.

## Modèles de Données (Flutter)

### ChatRequest
```dart
class ChatRequest {
  final String userMessage;
  final double userLat;
  final double userLon;

  ChatRequest({required this.userMessage, required this.userLat, required this.userLon});

  Map<String, dynamic> toJson() => {
    'user_message': userMessage,
    'user_lat': userLat,
    'user_lon': userLon,
  };
}
```

### ChatResponse
```dart
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
      intention: json['intention'],
      motCle: json['mot_cle'],
      message: json['message'],
      reponseTexte: json['reponse_texte'],
    );
  }
}
```
