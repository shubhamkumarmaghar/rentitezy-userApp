class UserModel {
  String id;
  String firstName;
  String lastName;
  String phone;
  String email;
  String password;
  String isTenant;
  String image;
  String createdOn;
  String authKey;
  String token;
  String isDelete;

  UserModel(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.phone,
      required this.email,
      required this.password,
      required this.isTenant,
      required this.image,
      required this.authKey,
      required this.token,
      required this.isDelete,
      required this.createdOn});

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
        id: json['id'].toString(),
        lastName: json['lastName'].toString() == 'null'
            ? ''
            : json['lastName'].toString(),
        firstName: json['firstName'],
        phone: json['phone'],
        email: json['email'],
        password: json['password'] ?? 'NA',
        image: json['image'],
        authKey: json['auth_key'] ?? 'NA',
        token: json['token'] ?? 'NA',
        isDelete: json['isDelete'] ?? 'NA',
        isTenant: json['isTenant'] ?? 'false',
        createdOn: json['createdOn'] ?? '');
  }
}
