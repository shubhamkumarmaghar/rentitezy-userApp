
class TicketDetailsModel {
  Ticket? ticket;
  List<String>? categories;
  List<String>? status;

  TicketDetailsModel({ticket, categories, status});

  TicketDetailsModel.fromJson(Map<String, dynamic> json) {
    ticket = json['ticket'] != null ? Ticket.fromJson(json['ticket']) : null;
    categories = json['categories'] == null ? [] : List<String>.from(json['categories'].map((x) => x));
    status = json['status'] == null ? [] : List<String>.from(json['status'].map((x) => x));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (ticket != null) {
      data['ticket'] = ticket!.toJson();
    }
    data['categories'] = categories;
    data['status'] = status;
    return data;
  }
}

class Ticket {
  int? id;
  int? tenantId;
  String? unitId;
  int? propId;
  String? category;
  String? description;
  String? status;
  String? priority;
  String? remindOn;
  String? createdOn;
  String? updatedOn;
  String? closedOn;
  String? createdById;
  String? updatedById;

  Ticket(
      {id,
      tenantId,
      unitId,
      propId,
      category,
      description,
      status,
      priority,
      remindOn,
      createdOn,
      updatedOn,
      closedOn,
      createdById,
      updatedById});

  Ticket.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    tenantId = json['tenantId'];
    unitId = json['unitId'];
    propId = json['propId'];
    category = json['category'];
    description = json['description'];
    status = json['status'];
    priority = json['priority'];
    remindOn = json['remindOn'];
    createdOn = json['createdOn'];
    updatedOn = json['updatedOn'];
    closedOn = json['closedOn'];
    createdById = json['createdById'];
    updatedById = json['updatedById'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['tenantId'] = tenantId;
    data['unitId'] = unitId;
    data['propId'] = propId;
    data['category'] = category;
    data['description'] = description;
    data['status'] = status;
    data['priority'] = priority;
    data['remindOn'] = remindOn;
    data['createdOn'] = createdOn;
    data['updatedOn'] = updatedOn;
    data['closedOn'] = closedOn;
    data['createdById'] = createdById;
    data['updatedById'] = updatedById;
    return data;
  }
}
