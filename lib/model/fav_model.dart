class FavModel {
  String id;
  String userId;
  String listingId;
  String addedOn;

  FavModel({
    required this.id,
    required this.userId,
    required this.listingId,
    required this.addedOn,
  });

  factory FavModel.fromJson(Map<String, dynamic> json) {
    return FavModel(
      id: json['id'].toString(),
      userId: json['userId'].toString(),
      listingId: json['listingId'].toString(),
      addedOn: json['addedOn'],
    );
  }
}
