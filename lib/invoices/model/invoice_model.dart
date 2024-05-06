class InvoiceModel {
  int? id;
  int? bookingId;
  String? fromDate;
  String? tillDate;
  String? type;
  int? payable;
  int? paid;
  String? status;
  String? createdOn;
  String? updatedOn;

  InvoiceModel(
      {this.id,
        this.bookingId,
        this.fromDate,
        this.tillDate,
        this.type,
        this.payable,
        this.paid,
        this.status,
        this.createdOn,
        this.updatedOn});

  InvoiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bookingId = json['bookingId'];
    fromDate = json['fromDate'];
    tillDate = json['tillDate'];
    type = json['type'];
    payable = json['payable'];
    paid = json['paid'];
    status = json['status'];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['bookingId'] = bookingId;
    data['fromDate'] = fromDate;
    data['tillDate'] = tillDate;
    data['type'] = type;
    data['payable'] = payable;
    data['paid'] = paid;
    data['status'] = status;
    data['createdOn'] = createdOn;
    data['updatedOn'] = updatedOn;
    return data;
  }
}