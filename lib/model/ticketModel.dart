class TicketModel {
  String id;
  String tenantId;
  String ticket;
  String openDate;
  String closeDate;
  String resolved;
  String comments;
  String houseId;
  String propertyId;
  String createdOn;

  TicketModel(
      {required this.id,
      required this.tenantId,
      required this.ticket,
      required this.openDate,
      required this.closeDate,
      required this.resolved,
      required this.comments,
      required this.houseId,
      required this.propertyId,
      required this.createdOn});

  factory TicketModel.fromJson(Map<String, dynamic> json) {
    return TicketModel(
        id: json['id'].toString(),
        tenantId: json['tenantId'],
        ticket: json['ticket'],
        openDate: json['openDate'],
        closeDate: json['closeDate'] ?? 'NA',
        resolved: json['resolved'],
        comments: json['comments'],
        houseId: json['houseId'],
        propertyId: json['propertyId'],
        createdOn: json['createdOn']);
  }
}
