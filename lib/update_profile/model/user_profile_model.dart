class UserProfileModel {
  String? firstName;
  String? lastName;
  String? email;
  String? phone;
  String? image;

  UserProfileModel(
      {this.firstName, this.lastName, this.email, this.phone, this.image});

  UserProfileModel.fromJson(Map<String, dynamic> json) {
    firstName = json['firstName'];
    lastName = json['lastName'];
    email = json['email'];
    phone = json['phone'];
    image = json['image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['firstName'] = this.firstName;
    data['lastName'] = this.lastName;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['image'] = this.image;
    return data;
  }
}