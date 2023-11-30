class ReviewModel {
  String id;
  String userId;
  String tenantId;
  String propertyId;
  String review;
  String createdOn;

  ReviewModel(
      {required this.id,
      required this.userId,
      required this.tenantId,
      required this.propertyId,
      required this.review,
      required this.createdOn});

  factory ReviewModel.fromJson(Map<String, dynamic> json) {
    return ReviewModel(
        id: json['id'].toString(),
        userId: json['userId'],
        tenantId: json['tenantId'],
        propertyId: json['propertyId'],
        review: json['review'],
        createdOn: json['createdOn']);
  }
}
