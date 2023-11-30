import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class AppUrls {
  static const String appName = "Rentiseazy";
  static const String phone = "+918867319944";
  static const rootUrl = "http://networkgroups.in/prisma/rentitezy/";
  static const baseUrl = "https://api.rentiseazy.com/user/";
  static const imagesRootUrl =
      "http://networkgroups.in/prisma/rentitezy/images/";

  static const imagesRentIsEasyUrl = "${baseUrl}images/";

  // static const rootUrl = "http://192.168.1.233:8136/prisma/rentitezy/";
  // static const imagesRootUrl =
  //     "http://192.168.1.233:8136/prisma/rentitezy/images/";

  // static const rootUrl = "http://192.168.1.204:8136/prisma/rentitezy/";
  // static const imagesRootUrl =
  //     "http://192.168.1.204:8136/prisma/rentitezy/images/";

  static const user = "${baseUrl}user";
  static const userRegister = "${baseUrl}user/signUp";
  static const getUser = "${baseUrl}user";
  static const userDelete = "${baseUrl}userDelete";
  static const userLogin = "${baseUrl}user/login";
  static const leads = "${baseUrl}leads";
  static const nearProperty = "${rootUrl}nearByProperty";
  static const property = "${baseUrl}property";
  static const issues = "${baseUrl}faq";
  static const assetReq = "${baseUrl}assets_req";
  static const assets = "${rootUrl}assets";
  static const settings = "${baseUrl}settings";
  static const fetchAllFavByIds = "${rootUrl}fetchProductByIds";
  static const tenantAgree = "${baseUrl}rentitezyAgreement";
  static const userTenant =
      "${baseUrl}userTenant"; //query userTenant?userId=19
  static const tenant = "${baseUrl}tenant";
  static const ticket = "${baseUrl}ticket";

  // static const rentReq = "${rentIsEasyUrl}rent_req";
  static const rentReq = "${baseUrl}user/invoices";
  static const review = "${baseUrl}review";
  static const otp = "${baseUrl}user_otp";
  static const resetPass = "${baseUrl}user_reset_password";
  static const bookNow = "${baseUrl}leadsBooking";
  static const orderIdRzy = "https://api.razorpay.com/v1/orders";
  static const checkout = '${baseUrl}user/checkout';
  static const loginWeb = '${baseUrl}login';
  static const rentPay = '${baseUrl}user/payment';
  static const addFav = '${baseUrl}user/wishlist';

  static const urlImgUpload = "${rootUrl}fileUpload";

  static const myBooking = '${baseUrl}user/bookings';
  static const listingDetail = '${baseUrl}listingDetail';
  static const listing = '${baseUrl}listing';
  static const locations = '${baseUrl}locations';
  static const wishlist = '${baseUrl}user/wishlist';

  static Widget emptyWidget(String path) {
    return SizedBox(height: 150, width: 150, child: Lottie.network(path));
  }
}