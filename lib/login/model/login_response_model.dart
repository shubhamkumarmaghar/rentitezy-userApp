
class LoginResponseModel {
  int? id;
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? image;
  String? token;
  String? status;

  LoginResponseModel(
      {this.id,
        this.firstName,
        this.lastName,
        this.email,
        this.phone,
        this.status,
        this.image,
        this.token});

  LoginResponseModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
    status = json['status'];
    image = json['image'];
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['firstName'] = firstName;
    data['lastName'] = lastName;
    data['email'] = email;
    data['phone'] = phone;
    data['status'] = status;
    data['image'] = image;
    data['token'] = token;
    return data;
  }
}

