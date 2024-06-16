class KycDocumentModel {
  String? documentName;
  String? documentUrl;
  String? name;
  String? phone;
  String? email;
  String? nationality;

  KycDocumentModel({this.documentName, this.documentUrl, this.phone, this.email, this.name, this.nationality});

  @override
  String toString() {
    return 'docName :: $documentName, docUrl :: $documentUrl, name :: $name, phone :: $phone, email :: $email, nationality :: $nationality';
  }
}
