import 'package:rentitezy/model/asset_model.dart';
import 'package:rentitezy/model/user_model.dart';

class AssetReqModel {
  String id;
  UserModel userModel;
  AssetsModel assetsModel;
  String status;
  String createdOn;

  AssetReqModel(
      {required this.id,
      required this.userModel,
      required this.assetsModel,
      required this.status,
      required this.createdOn});

  factory AssetReqModel.fromJson(Map<String, dynamic> json) {
    return AssetReqModel(
        id: json['id'].toString(),
        status: json['status'] ?? 'opened',
        userModel: UserModel.fromJson(json['userDet']),
        assetsModel: AssetsModel.fromJson(json['assetDet']),
        createdOn: json['createdOn']);
  }
}
