class CheckoutModel {
  String? title;
  String? name;
  String? location;
  List<Photos>? photos;
  String? address;
  String? moveIn;
  String? moveOut;
  String? duration;
  int? rent;
  int? deposit;
  int? onboarding;
  int? maintenance;
  int? guest;
  int? lockIn;
  int? amount;
  int? total;
  int? cartId;

  CheckoutModel(
      {this.title,
        this.name,
        this.location,
        this.photos,
        this.address,
        this.moveIn,
        this.moveOut,
        this.duration,
        this.rent,
        this.deposit,
        this.onboarding,
        this.maintenance,
        this.guest,
        this.lockIn,
        this.amount,
        this.total,
        this.cartId});

  CheckoutModel.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    name = json['name'];
    location = json['location'];
    if (json['photos'] != null) {
      photos = <Photos>[];
      json['photos'].forEach((v) {
        photos!.add(new Photos.fromJson(v));
      });
    }
    address = json['address'];
    moveIn = json['moveIn'];
    moveOut = json['moveOut'];
    duration = json['duration'];
    rent = json['rent'];
    deposit = json['deposit'];
    onboarding = json['onboarding'];
    maintenance = json['maintenance'];
    guest = json['guest'];
    lockIn = json['lockIn'];
    amount = json['amount'];
    total = json['total'];
    cartId = json['cartId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['name'] = this.name;
    data['location'] = this.location;
    if (this.photos != null) {
      data['photos'] = this.photos!.map((v) => v.toJson()).toList();
    }
    data['address'] = this.address;
    data['moveIn'] = this.moveIn;
    data['moveOut'] = this.moveOut;
    data['duration'] = this.duration;
    data['rent'] = this.rent;
    data['deposit'] = this.deposit;
    data['onboarding'] = this.onboarding;
    data['maintenance'] = this.maintenance;
    data['guest'] = this.guest;
    data['lockIn'] = this.lockIn;
    data['amount'] = this.amount;
    data['total'] = this.total;
    data['cartId'] = this.cartId;
    return data;
  }
}

class Photos {
  String? url;

  Photos({this.url});

  Photos.fromJson(Map<String, dynamic> json) {
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['url'] = this.url;
    return data;
  }
}
