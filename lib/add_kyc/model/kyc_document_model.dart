class KycDocumentModel {
  String? documentName;
  String? name;
  List<String?> documentUrlsList = [];
  String? phone;
  String? email;
  String? nationality;

  KycDocumentModel(
      {this.documentName,
      required this.documentUrlsList,
      this.phone,
      this.email,
      this.name,
      this.nationality});

  @override
  String toString() {
    return 'docName :: $documentName, docUrl :: ${documentUrlsList.length}, name :: $name, phone :: $phone, email :: $email, nationality :: $nationality';
  }
}
