class CheckoutModel {
  String name;
  String address;
  String moveIn;
  String moveOut;
  String duration;
  String rent;
  String deposit;
  String onboarding;
  String guest;
  String lockIn;
  String amount;
  String total;
  String cardId;
  String maintenance;
  List<Photos> imageList;
  CheckoutModel(
      {required this.name,
      required this.address,
      required this.moveIn,
      required this.moveOut,
      required this.duration,
      required this.rent,
      required this.deposit,
      required this.onboarding,
      required this.guest,
      required this.lockIn,
      required this.amount,
      required this.total,
      required this.cardId,
      required this.maintenance,
      required this.imageList});

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
        imageList: (json['photos'] as List)
            .map((stock) => Photos.fromJson(stock))
            .toList());
  }
}

class Photos {
  String url;

  Photos({required this.url});

  factory Photos.fromJson(Map<String, dynamic> json) {
    return Photos(url: json['url']);
  }

  Map<String, dynamic> toJson() {
    return {
      'url': url,
    };
  }
}
