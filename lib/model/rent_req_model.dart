class RentReqModel {
  String id;
  String bookingId;
  String fromDate;
  String tillDate;
  String type;
  String payable;
  String paid;
  String status;
  String userName = '';
  String userPhone = '';
  String createdOn;
  String updatedOn;

  RentReqModel(
      {required this.id,
      required this.bookingId,
      required this.fromDate,
      required this.status,
      required this.tillDate,
      required this.type,
      required this.payable,
      required this.paid,
      required this.updatedOn,
      required this.createdOn});

  factory RentReqModel.fromJson(Map<String, dynamic> json) {
    return RentReqModel(
        id: json['id'].toString(),
        status: json['status'] ?? 'pending',
        bookingId: json['bookingId'].toString(),
        fromDate: json['fromDate'],
        tillDate: json['tillDate'],
        type: json['type'],
        payable: json['payable'].toString(),
        paid: json['paid'].toString(),
        updatedOn: json['updatedOn'],
        createdOn: json['createdOn']);
  }
}
