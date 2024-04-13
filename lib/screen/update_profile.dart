// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rentitezy/dashboard/controller/dashboard_controller.dart';
import 'package:rentitezy/dashboard/view/dashboard_view.dart';
import 'package:rentitezy/utils/const/api.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import 'package:rentitezy/model/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/const/app_urls.dart';
import '../utils/const/widgets.dart';
import '../home/home_view/home_screen.dart';

class UpdateProfilePage extends StatefulWidget {
  const UpdateProfilePage({super.key});

  @override
  State<UpdateProfilePage> createState() => _UpdateState();
}

class _UpdateState extends State<UpdateProfilePage> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  TextEditingController unameController = TextEditingController();
  TextEditingController uLNameController = TextEditingController();
  TextEditingController uPhoneController = TextEditingController();
  TextEditingController uEmailController = TextEditingController();
  String imagePath = '';
  String userId = '';
  List<UserModel> userList = [];
  Widget widgetCompanyLogo = ClipRRect(
    borderRadius: const BorderRadius.all(Radius.circular(10)),
    child: Image.network(''),
  );

  @override
  void initState() {
    setValueSB();
    super.initState();
  }

  setValueSB() async {
    var sharedPreferences = await _prefs;
    if (GetStorage().read(Constants.userId) != '' &&
        GetStorage().read(Constants.userId) != null) {
      userId = GetStorage().read(Constants.userId).toString();
      userList = await fetchUserApi(
          '${AppUrls.user}?id=${GetStorage().read(Constants.userId).toString()}');
    } else {
      userId = 'guest';
    }

    if (userList.isNotEmpty) {
      unameController.value = TextEditingValue(text: userList.first.firstName);
      uLNameController.value = TextEditingValue(text: userList.first.lastName);
      uPhoneController.value = TextEditingValue(text: userList.first.phone);
      uEmailController.value = TextEditingValue(text: userList.first.email);
      imagePath = userList.first.image;
      widgetCompanyLogo = CircleAvatar(
          radius: 38.0,
          backgroundImage: NetworkImage(imagePath),
          child: Align(
            alignment: Alignment.bottomRight,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 12.0,
              child: GestureDetector(
                onTap: () async {
                  XFile? pickedImage = await ImagePicker()
                      .pickImage(source: ImageSource.gallery);
                  if (pickedImage != null) {
                    String img =
                        await uploadImage(pickedImage.path, pickedImage.name);
                    setState(() {
                      imagePath = img;
                    });
                  }
                },
                child: const Icon(
                  Icons.camera_alt,
                  size: 15.0,
                  color: Color(0xFF404040),
                ),
              ),
            ),
          ));
    }
    setState(() {});
  }

  void userUpdateRequest() async {
    var sharedPreferences = await _prefs;
    try {
      dynamic result = await updateUser(
          unameController.text,
          uLNameController.text,
          uPhoneController.text,
          uEmailController.text,
          imagePath,
          GetStorage().read(Constants.userId).toString());
      if (result['success']) {
        Get.find<DashboardController>().setIndex(0);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => DashboardView()));
      } else {
        showSnackBar(context, result['message']);
      }
    } on Exception catch (error) {
      showSnackBar(context, error.toString());
      Navigator.pop(context);
    }
  }

  Widget inputFeild(
      String hind, TextEditingController tController, double bottom) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        padding: const EdgeInsets.all(3),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Constants.lightBg,
          border: Border.all(color: const Color.fromARGB(255, 227, 225, 225)),
        ),
        child: TextField(
          controller: tController,
          decoration: InputDecoration(
              hoverColor: Constants.hint,
              hintText: hind,
              border: InputBorder.none),
        ),
      ),
    );
  }

  Widget inputFeildPh(
      String hind, TextEditingController tController, double bottom) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        padding: const EdgeInsets.all(3),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Constants.lightBg,
          border: Border.all(color: const Color.fromARGB(255, 227, 225, 225)),
        ),
        child: TextField(
          controller: tController,
          keyboardType: TextInputType.phone,
          inputFormatters: <TextInputFormatter>[
            FilteringTextInputFormatter.allow(RegExp("[0-9]")),
          ],
          maxLength: 10,
          decoration: InputDecoration(
              counter: const SizedBox(),
              hoverColor: Constants.hint,
              hintText: hind,
              border: InputBorder.none),
        ),
      ),
    );
  }

  Widget inputFeildEmail(
      String hind, TextEditingController tController, double bottom) {
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Container(
        padding: const EdgeInsets.all(3),
        margin: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(7),
          color: Constants.lightBg,
          border: Border.all(color: const Color.fromARGB(255, 227, 225, 225)),
        ),
        child: TextField(
          controller: tController,
          keyboardType: TextInputType.emailAddress,
          decoration: InputDecoration(
              hoverColor: Constants.hint,
              hintText: hind,
              border: InputBorder.none),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
          child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(10),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              height(0.05),
              Center(
                child: SizedBox(
                    height: 170,
                    width: 250,
                    child: Image.asset(
                      'assets/images/login_image.png',
                      fit: BoxFit.fill,
                    )),
              ),
              Center(child: title("Update Account", 27)),
              height(0.05),
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                    child: CircleAvatar(
                        radius: 40.0,
                        backgroundColor: Colors.white,
                        child: imagePath.isNotEmpty
                            ? widgetCompanyLogo
                            : CircleAvatar(
                                radius: 38.0,
                                backgroundImage: const AssetImage(
                                    'assets/images/user_vec.png'),
                                child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: CircleAvatar(
                                    backgroundColor: Colors.white,
                                    radius: 12.0,
                                    child: GestureDetector(
                                      onTap: () async {
                                        XFile? pickedImage = await ImagePicker()
                                            .pickImage(
                                                source: ImageSource.gallery);
                                        if (pickedImage != null) {
                                          String img = await uploadImage(
                                              pickedImage.path,
                                              pickedImage.name);
                                          setState(() {
                                            imagePath = img;
                                          });
                                        }
                                      },
                                      child: const Icon(
                                        Icons.camera_alt,
                                        size: 15.0,
                                        color: Color(0xFF404040),
                                      ),
                                    ),
                                  ),
                                )))),
              ),
              height(0.05),
              inputFeild('First name', unameController, 5),
              inputFeild('Last name', uLNameController, 5),
              inputFeildPh('Mobile number', uPhoneController, 5),
              inputFeildEmail('Email Address', uEmailController, 25),
              Center(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.primaryColor,
                    ),
                    onPressed: () {
                      if (unameController.text.isEmpty) {
                        showSnackBar(context, 'Enter valid first name');
                      } else if (uLNameController.text.isEmpty) {
                        showSnackBar(context, 'Enter valid last name');
                      } else if (uPhoneController.text.isEmpty) {
                        showSnackBar(context, 'Enter valid phone number');
                      } else if (uEmailController.text.isEmpty) {
                        showSnackBar(context, 'Enter valid email address');
                      } else if (!validateEmail(uEmailController.text)) {
                        showSnackBar(context, 'Invalid email address');
                      } else {
                        userUpdateRequest();
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 15, bottom: 15, left: 27, right: 27),
                      child: Text(
                        'UPDATE',
                        style: TextStyle(
                            fontFamily: Constants.fontsFamily,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    )),
              ),
              height(0.05),
            ]),
      )),
    );
  }
}
