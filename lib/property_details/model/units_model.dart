class Units {
  int? id;
  String? flatNo;
  String? availFrom;

  Units({id, flatNo, availFrom});

  Units.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    flatNo = json['flatNo'];
    availFrom = json['availFrom'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  <String, dynamic>{};
    data['id'] = id;
    data['flatNo'] = flatNo;
    data['availFrom'] = availFrom;
    return data;
  }
}