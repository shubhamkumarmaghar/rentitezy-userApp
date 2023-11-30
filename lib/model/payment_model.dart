class PaymentModel {
  String id;
  String phone;
  String email;
  String buyer_name;
  String amount;
  String purpose;
  String expires_at;
  String status;
  String send_sms;
  String send_email;
  String sms_status;
  String email_status;
  String shorturl;
  String longurl;
  String redirect_url;
  String webhook;
  String allow_repeated_payments;
  String created_at;
  String modified_at;

  PaymentModel(
      {required this.id,
      required this.phone,
      required this.email,
      required this.buyer_name,
      required this.amount,
      required this.purpose,
      required this.expires_at,
      required this.status,
      required this.send_sms,
      required this.send_email,
      required this.sms_status,
      required this.email_status,
      required this.shorturl,
      required this.longurl,
      required this.redirect_url,
      required this.webhook,
      required this.allow_repeated_payments,
      required this.created_at,
      required this.modified_at});

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
        id: json['id'],
        phone: json['phone'],
        email: json['email'],
        buyer_name: json['buyer_name'],
        amount: json['amount'].toString(),
        purpose: json['purpose'],
        expires_at: json['expires_at'] ?? 'NA',
        status: json['status'],
        send_sms: json['send_sms'].toString(),
        send_email: json['send_email'].toString(),
        sms_status: json['sms_status'] ?? 'NA',
        email_status: json['email_status'] ?? 'NA',
        shorturl: json['shorturl'] ?? 'NA',
        longurl: json['longurl'],
        redirect_url: json['redirect_url'],
        webhook: json['webhook'],
        allow_repeated_payments: json['allow_repeated_payments'].toString(),
        created_at: json['created_at'],
        modified_at: json['modified_at']);
  }
}
