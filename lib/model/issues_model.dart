class IssuesModel {
  String id;
  String userId;
  String propertyId;
  String question;
  String status;
  String createdOn;

  IssuesModel(
      {required this.id,
      required this.userId,
      required this.propertyId,
      required this.question,
      required this.status,
      required this.createdOn});

  factory IssuesModel.fromJson(Map<String, dynamic> json) {
    return IssuesModel(
        id: json['id'].toString(),
        userId: json['userId'],
        propertyId: json['propertyId'],
        question: json['question'],
        status: json['status'],
        createdOn: json['createdOn']);
  }
}
