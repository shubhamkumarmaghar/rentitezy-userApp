
class AppUrls {
  static const String appName = "SoWeRent";
  static const String phone = "+918867319944";
  static const productionUrl = "https://api.sowerent.com/user/";
  static const developmentUrl = "https://test-api.sowerent.com/user/";
  static const rootUrl = "http://networkgroups.in/prisma/rentitezy/";
  static const baseUrl = developmentUrl;
  static const imagesRootUrl =
      "https://api.rentiseazy.com/user/images/";
  static const imagesRentIsEasyUrl = "${baseUrl}images/";
  static const user = baseUrl;
  static const userRegister = "${baseUrl}signUp";
  static const userLogin = "${baseUrl}login";
  static const property = "${baseUrl}property";
  static const issues = "${baseUrl}faq";
  static const settings = "${baseUrl}settings";
  static const fetchAllFavByIds = "${rootUrl}fetchProductByIds";
  static const tenantAgree = "${baseUrl}rentitezyAgreement";
  static const userTenant =
      "${baseUrl}userTenant"; //query userTenant?userId=19
  static const tenant = "${baseUrl}tenant";
  static const ticket = "${baseUrl}ticket";
  static const getTicket = "${baseUrl}tickets";

  static const invoice = "${baseUrl}invoices";
  static const otp = "${baseUrl}user_otp";
  static const resetPass = "${baseUrl}user_reset_password";
  static const checkout = '${baseUrl}checkout';
  static const checkoutV2 = '${baseUrl}checkOutV2';
  static const siteVisit = '${baseUrl}siteVisit';
  static const addFav = '${baseUrl}wishlist';


  static const updateProfileImageUrl = "${baseUrl}profileImage";
  static const updateProfileUrl = "${baseUrl}profile";

  static const myBooking = '${baseUrl}bookings';
  static const getSingleBooking = '${baseUrl}booking';
  static const listingDetail = '${baseUrl}listingDetail';
  static const listing = '${baseUrl}listing';
  static const locations = '${baseUrl}locations';
  static const wishlist = '${baseUrl}wishlist';
  static const paymentCallback = '${baseUrl}paymentCallback';
  static const uploadFile = '${baseUrl}fileUpload';
  static const uploadTenantsDocs = '${baseUrl}tenants';
  static const googleSignIn = '${baseUrl}googleSignIn';
  static const sendOTP = '${baseUrl}otpSend';
  static const resendOTP = '${baseUrl}otpResend';
  static const otpSignIn = '${baseUrl}otpSignIn';
  static const payInvoice = '${baseUrl}invoicePay';



}
// android:networkSecurityConfig="@xml/network_security_config"

/*<?xml version="1.0" encoding="utf-8"?>
 android:usesCleartextTraffic="true"
<network-security-config>
    <domain-config
        cleartextTrafficPermitted="true">
        <domain includeSubdomains="true">networkgroups.in</domain>
        <domain includeSubdomains="true">api.rentiseazy.com</domain>
        <domain includeSubdomains="true">192.168.1.204</domain>
        <domain includeSubdomains="true">157.245.60.156</domain>
        <domain includeSubdomains="true">192.168.1.233</domain>
        <domain includeSubdomains="true">rie-images.s3.ap-south-1.amazonaws.com</domain>

    </domain-config>
</network-security-config>*/