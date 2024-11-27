import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:rentitezy/theme/custom_theme.dart';
import 'package:rentitezy/utils/const/app_urls.dart';
import 'package:rentitezy/utils/view/rie_widgets.dart';
import '../../utils/const/appConfig.dart';
import '../../utils/functions/util_functions.dart';
import '../../utils/model/property_model.dart';
import '../../utils/services/rie_user_api_service.dart';

class HomeController extends GetxController {
  List<PropertyInfoModel>? propertyInfoList;
  List<PropertyInfoModel>? nearbyPropertyInfoList;
  final GeolocatorPlatform _geoLocatorPlatform = GeolocatorPlatform.instance;
  final RIEUserApiService apiService = RIEUserApiService();
  String currentLocation = '';
  String userName = '';
  String imageUrl = '';

  @override
  void onInit() {
    localSetup();
    fetchProperties();
    _getCurrentPositionLatLong();
    super.onInit();
  }

  void localSetup() {
    userName = GetStorage().read(Constants.firstName) ?? 'Guest';
    imageUrl = GetStorage().read(Constants.profileUrl) ?? '';
  }

  Future<void> fetchNearbyProperties(String locality) async {
    String url = '${AppUrls.listing}?available=true&offset=1&limit=6&location=$locality';

    final response = await apiService.getApiCallWithURL(endPoint: url);

    if (response["message"].toString().toLowerCase().contains('success') && response['data'] != null) {
      Iterable iterable = response['data'];
      nearbyPropertyInfoList = iterable.map((e) => PropertyInfoModel.fromJson(e)).toList();
    } else {
      nearbyPropertyInfoList = [];
      RIEWidgets.getToast(message: response["message"] ?? 'Something went wrong!', color: CustomTheme.errorColor);
    }
    update();
  }

  void fetchProperties() async {
    String url = '${AppUrls.listing}?available=true&offset=0&limit=5';
    final response = await apiService.getApiCallWithURL(endPoint: url);

    if (response["message"].toString().toLowerCase().contains('success') && response['data'] != null) {
      Iterable iterable = response['data'];
      propertyInfoList = iterable.map((e) => PropertyInfoModel.fromJson(e)).toList();
    } else {
      propertyInfoList = [];
      RIEWidgets.getToast(message: response["message"] ?? 'Something went wrong!', color: CustomTheme.errorColor);
    }
    update();
  }

  Future<void> _getCurrentPositionLatLong() async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      return;
    }

    final position = await _geoLocatorPlatform.getCurrentPosition();
    await getUserLocation(position);
  }

  Future<void> getUserLocation(Position position) async {
    List<Placemark> placeMarks = await placemarkFromCoordinates(position.latitude, position.longitude);
    if (placeMarks.isNotEmpty) {
      if (placeMarks.first.subLocality != null || placeMarks.first.subLocality!.isNotEmpty) {
        currentLocation = placeMarks.first.subLocality ?? '';
        fetchNearbyProperties(currentLocation);
      }
    }
  }

  Future<void> navigateToMap(String? latLang) async {
    if (latLang == null || latLang.isEmpty) {
      return;
    }
    List<String> locationList = latLang.split(',');
    navigateToNativeMap(lat: locationList[0], long: locationList[1]);
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await _geoLocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await _geoLocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geoLocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _openAppSettings();
      return false;
    }
    return true;
  }

  void _openAppSettings() async {
    final opened = await _geoLocatorPlatform.openAppSettings();
  }
}
