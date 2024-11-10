class InvoiceModel {
  int? id;
  String? fromDate;
  String? tillDate;
  int? amount;
  int? pending;
  List<Details>? details;

  InvoiceModel(
      {this.id,
        this.fromDate,
        this.tillDate,
        this.amount,
        this.pending,
        this.details});

  InvoiceModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    fromDate = json['fromDate'];
    tillDate = json['tillDate'];
    amount = json['amount'];
    pending = json['pending'];
    if (json['details'] != null) {
      details = <Details>[];
      json['details'].forEach((v) {
        details!.add(new Details.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['fromDate'] = fromDate;
    data['tillDate'] = tillDate;
    data['amount'] = amount;
    data['pending'] = pending;
    if (details != null) {
      data['details'] = details!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Details {
  String? type;
  int? amount;
  int? pending;
  String? status;

  Details({this.type, this.amount, this.pending, this.status});

  Details.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    amount = json['amount'];
    pending = json['pending'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['type'] = type;
    data['amount'] = amount;
    data['pending'] = pending;
    data['status'] = status;
    return data;
  }
}