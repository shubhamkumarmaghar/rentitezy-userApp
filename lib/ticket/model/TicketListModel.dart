class TicketListModel {
  List<Data>? data;
  String? message;

  TicketListModel({this.data, this.message});

  TicketListModel.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  int? id;
  String? unit;
  String? property;
  String? category;
  String? description;
  String? status;
  String? remindOn;
  String? createdOn;
  dynamic closedOn;
  String? updatedOn;
  String? addedBy;

  Data(
      {this.id,
      this.unit,
      this.property,
      this.category,
      this.description,
      this.status,
      this.remindOn,
      this.createdOn,
      this.closedOn,
      this.updatedOn,
      this.addedBy});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    unit = json['unit'];
    property = json['property'];
    category = json['category'];
    description = json['description'];
    status = json['status'];
    remindOn = json['remindOn'];
    createdOn = json['createdOn'];
    closedOn = json['closedOn'];
    updatedOn = json['updatedOn'];
    addedBy = json['addedBy'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['unit'] = unit;
    data['property'] = property;
    data['category'] = category;
    data['description'] = description;
    data['status'] = status;
    data['remindOn'] = remindOn;
    data['createdOn'] = createdOn;
    data['closedOn'] = closedOn;
    data['updatedOn'] = updatedOn;
    data['addedBy'] = addedBy;
    return data;
  }
}