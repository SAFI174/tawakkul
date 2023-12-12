class Hadith40Model {
  String description;
  String idAr;
  String rawi;
  String text;
  String topic;

  Hadith40Model({
    required this.description,
    required this.idAr,
    required this.rawi,
    required this.text,
    required this.topic,
  });

  factory Hadith40Model.fromJson(Map<String, dynamic> json) {
    return Hadith40Model(
      description: json['description'],
      idAr: json['id_ar'],
      rawi: json['rawi'],
      text: json['text'],
      topic: json['topic'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'id_ar': idAr,
      'rawi': rawi,
      'text': text,
      'topic': topic,
    };
  }
}
