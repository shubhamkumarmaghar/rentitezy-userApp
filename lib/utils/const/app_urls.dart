import 'package:flutter/cupertino.dart';
import 'package:lottie/lottie.dart';

class AppUrls {
  static const String appName = "Rentiseazy";
  static const String phone = "+918867319944";
  static const productionUrl = "https://api.rentiseazy.com/user/";
  static const developmentUrl = "https://test-api.rentiseazy.com/user/";
  static const rootUrl = "http://networkgroups.in/prisma/rentitezy/";
  static const baseUrl = developmentUrl;
  static const imagesRootUrl =
      "https://api.rentiseazy.com/user/images/";
  static const imagesRentIsEasyUrl = "${baseUrl}images/";
  static const user = baseUrl;
  static const userRegister = "${baseUrl}signUp";
  static const getUser = baseUrl;
  static const userDelete = "${baseUrl}userDelete";
  static const userLogin = "${baseUrl}login";
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
  static const getTicket = "${baseUrl}tickets";

  // static const rentReq = "${rentIsEasyUrl}rent_req";
  static const invoice = "${baseUrl}invoices";
  static const review = "${baseUrl}review";
  static const otp = "${baseUrl}user_otp";
  static const resetPass = "${baseUrl}user_reset_password";
  static const bookNow = "${baseUrl}leadsBooking";
  static const orderIdRzy = "https://api.razorpay.com/v1/orders";
  static const checkout = '${baseUrl}checkout';
  static const checkoutV2 = '${baseUrl}checkOutV2';
  static const siteVisit = '${baseUrl}siteVisit';
  static const loginWeb = '${baseUrl}login';
  static const invoicePay = '${baseUrl}payment';
  static const addFav = '${baseUrl}wishlist';

  static const urlImgUpload = "${rootUrl}fileUpload";

  static const updateProfileImageUrl = "${baseUrl}profileImage";
  static const updateProfileUrl = "${baseUrl}profile";

  static const myBooking = '${baseUrl}bookings';
  static const getSingleBooking = '${baseUrl}booking';
  static const listingDetail = '${baseUrl}listingDetail';
  static const listing = '${baseUrl}listing';
  static const locations = '${baseUrl}locations';
  static const wishlist = '${baseUrl}wishlist';
  static const paymentCallback = '${baseUrl}paymentCallback';

  static Widget emptyWidget(String path) {
    return SizedBox(height: 150, width: 150, child: Lottie.network(path));
  }
}