class KycModel {
  String? name;
  String? phone;
  String? email;
  String? nationality;
  List<Proofs>? proofs;

  KycModel({this.name, this.phone, this.email, this.nationality, this.proofs});

  KycModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phone = json['phone'];
    email = json['email'];
    nationality = json['nationality'];
    if (json['proofs'] != null) {
      proofs = <Proofs>[];
      json['proofs'].forEach((v) {
        proofs!.add(new Proofs.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['nationality'] = this.nationality;
    if (this.proofs != null) {
      data['proofs'] = this.proofs!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Proofs {
  String? type;
  String? url;

  Proofs({this.type, this.url});

  Proofs.fromJson(Map<String, dynamic> json) {
    type = json['type'];
    url = json['url'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['type'] = this.type;
    data['url'] = this.url;
    return data;
  }
}