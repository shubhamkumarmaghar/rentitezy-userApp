class CheckoutModel {
  String? name;
  String? address;
  String? moveIn;
  String? moveOut;
  String? duration;
  String? rent;
  String? deposit;
  String? onboarding;
  String? guest;
  String? lockIn;
  String? amount;
  String? total;
  String? cardId;
  String? maintenance;
  List<Photos>? imageList;
  CheckoutModel(
      { this.name,
       this.address,
       this.moveIn,
       this.moveOut,
       this.duration,
       this.rent,
       this.deposit,
       this.onboarding,
       this.guest,
       this.lockIn,
       this.amount,
       this.total,
        this.cardId,
       this.maintenance,
       this.imageList});

  factory CheckoutModel.fromJson(Map<String, dynamic> json) {
    return CheckoutModel(
        name: json['name'],
        address: json['address'],
        moveIn: json['moveIn'],
        moveOut: json['moveOut'],
        duration: json['duration'].toString(),
        rent: json['rent'].toString(),
        deposit: json['deposit'].toString(),
        onboarding: json['onboarding'].toString(),
        guest: json['guest'].toString(),
        lockIn: json['lockIn'].toString(),
        amount: json['amount'].toString(),
        total: json['total'].toString(),
        cardId: json['cartId'].toString(),
        maintenance: json['maintenance'].toString(),
        imageList: (json['photos']! as List)
            .map((stock) => Photos.fromJson(stock))
            .toList());
  }
}

class Photos {
  String? url;

  Photos({ this.url});

  factory Photos.fromJson(Map<String, dynamic> json) {
    return Photos(url: json['url']);
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}
