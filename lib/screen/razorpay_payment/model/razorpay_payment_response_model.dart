class RazorpayPaymentResponseModel {
  int? paymentId;
  String? key;
  int? amount;
  String? currency;
  String? name;
  String? description;
  String? orderId;
  Prefill? prefill;

  RazorpayPaymentResponseModel(
      {paymentId,
        key,
        amount,
        currency,
        name,
        description,
        orderId,
        prefill});

  RazorpayPaymentResponseModel.fromJson(Map<String, dynamic> json) {
    paymentId = json['paymentId'];
    key = json['key'];
    amount = json['amount'];
    currency = json['currency'];
    name = json['name'];
    description = json['description'];
    orderId = json['orderId'];
    prefill =
    json['prefill'] != null ?  Prefill.fromJson(json['prefill']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['paymentId'] = paymentId;
    data['key'] = key;
    data['amount'] = amount;
    data['currency'] = currency;
    data['name'] = name;
    data['description'] = description;
    data['orderId'] = orderId;
    if (prefill != null) {
      data['prefill'] = prefill!.toJson();
    }
    return data;
  }
}

class Prefill {
  String? name;
  String? email;
  String? contact;

  Prefill({name, email, contact});

  Prefill.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    contact = json['contact'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['name'] = name;
    data['email'] = email;
    data['contact'] = contact;
    return data;
  }
}