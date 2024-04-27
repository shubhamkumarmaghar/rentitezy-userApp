import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:rentitezy/utils/const/appConfig.dart';
import '../../../utils/const/widgets.dart';
import '../controller/update_profile_controller.dart';

class UpdateProfilePage extends StatelessWidget {
  const UpdateProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<UpdateProfileController>(
      init: UpdateProfileController(),
      builder: (controller) {
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            elevation: 5,
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20))),
            backgroundColor: Constants.primaryColor,
            title: const Text('Update Account'),
          ),
          body: GestureDetector(
            onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
            child: Container(
                height: screenHeight,
                width: screenWidth,
                padding: const EdgeInsets.only(left: 15, right: 15, top: 30),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Stack(
                          children: [
                            SizedBox(
                              height: screenHeight * 0.18,
                              width: screenWidth * 0.4,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(screenWidth * 0.2),
                                  child: controller.imagePath == null || controller.imagePath == ''
                                      ? Container(
                                          color: Constants.primaryColor.withOpacity(0.2),
                                          child: Icon(
                                            Icons.person,
                                            size: screenWidth * 0.2,
                                            color: Constants.primaryColor,
                                          ),
                                        )
                                      : Image.network(
                                          controller.imagePath!,
                                          fit: BoxFit.fill,
                                        )),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: InkWell(
                                  onTap: controller.updateProfileImage,
                                  child: CircleAvatar(
                                    backgroundColor: Constants.primaryColor,
                                    child: Icon(
                                      Icons.edit,
                                      size: screenWidth * 0.04,
                                      color: Colors.white,
                                    ),
                                  ),
                                ))
                          ],
                        ),
                        height(0.05),
                        inputField(
                            controller: controller.firstNameController,
                            hintText: 'First name',
                            prefixIcon: Icons.account_circle_rounded,
                            textInputType: TextInputType.text),
                        inputField(
                            controller: controller.lastNameController,
                            hintText: 'Last name',
                            prefixIcon:Icons.person ,
                            textInputType: TextInputType.text),
                        inputField(
                            controller: controller.phoneController,
                            hintText: 'Mobile number',
                            prefixIcon: Icons.phone,
                            textInputType: TextInputType.number,
                            maxLength: 10,
                            inputFormatters: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(RegExp("[0-9]")),
                            ]),
                        inputField(
                            controller: controller.emailController,
                            hintText: 'Email Address',
                            prefixIcon: Icons.email,
                            textInputType: TextInputType.emailAddress),
                        SizedBox(
                          height: screenHeight * 0.18,
                        ),
                        SizedBox(
                          height: screenHeight * 0.06,
                          width: screenWidth * 0.8,
                          child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Constants.primaryColor,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30))),
                              onPressed: () {
                                if (controller.firstNameController.text.isEmpty) {
                                  showSnackBar(context, 'Enter valid first name');
                                } else if (controller.lastNameController.text.isEmpty) {
                                  showSnackBar(context, 'Enter valid last name');
                                } else if (controller.phoneController.text.isEmpty) {
                                  showSnackBar(context, 'Enter valid phone number');
                                } else if (controller.emailController.text.isEmpty) {
                                  showSnackBar(context, 'Enter valid email address');
                                } else if (!validateEmail(controller.emailController.text)) {
                                  showSnackBar(context, 'Invalid email address');
                                } else {
                                  controller.updateUserData();
                                }
                              },
                              child: Text(
                                'UPDATE',
                                style: TextStyle(
                                    fontFamily: Constants.fontsFamily,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              )),
                        ),
                        height(0.05),
                      ]),
                )),
          ),
        );
      },
    );
  }

  Widget inputField(
      {required TextEditingController controller,
      required String hintText,
      required TextInputType textInputType,
        required IconData prefixIcon,
      int? maxLength,
      List<TextInputFormatter>? inputFormatters}) {
    return Container(
      height: screenHeight * 0.065,
      margin: EdgeInsets.only(bottom: screenHeight * 0.025),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(40),
        color: Constants.primaryColor.withOpacity(0.1),
      ),
      child: Row(
        children: [
          SizedBox(width: screenWidth*0.04,),
          Icon(prefixIcon,color: Constants.primaryColor,size: 20,),
          SizedBox(
            width: screenWidth*0.78,
            child: TextFormField(
              controller: controller,
              keyboardType: textInputType,

              inputFormatters: inputFormatters,
              maxLength: maxLength,
              decoration: InputDecoration(
                  hoverColor: Constants.hint,
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 16, fontWeight: FontWeight.w500),
                  border: InputBorder.none,
                  labelStyle: const TextStyle(color: Colors.black, fontSize: 16, fontWeight: FontWeight.w600),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20)),
            ),
          ),
        ],
      ),
    );
  }
}
