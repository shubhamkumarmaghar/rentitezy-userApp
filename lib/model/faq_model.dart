class FaqModel {
  int id;
  String question;
  String ans;

  FaqModel({
    required this.id,
    required this.question,
    required this.ans,
  });

  factory FaqModel.fromJson(Map<String, dynamic> json) {
    return FaqModel(
      id: json['id'],
      question: json['question'],
      ans: json['ans'],
    );
  }
}
