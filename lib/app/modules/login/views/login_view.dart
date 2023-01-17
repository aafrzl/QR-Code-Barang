import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qrcode_barang/app/controllers/auth_controller.dart';
import 'package:qrcode_barang/app/routes/app_pages.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  LoginView({Key? key}) : super(key: key);

  final TextEditingController emailC = TextEditingController(
    text: "afrizal.mufriz25@gmail.com",
  );
  final TextEditingController passC = TextEditingController(
    text: "admin123",
  );

  final AuthController authC = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            keyboardType: TextInputType.emailAddress,
            controller: emailC,
            decoration: InputDecoration(
              labelText: "Email",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              prefixIcon: const Icon(Icons.email_rounded),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Obx(
            () {
              return TextField(
                autocorrect: false,
                keyboardType: TextInputType.emailAddress,
                controller: passC,
                obscureText: controller.isHidden.value,
                decoration: InputDecoration(
                  labelText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  prefixIcon: const Icon(Icons.password_rounded),
                  suffixIcon: IconButton(
                    onPressed: () {
                      controller.isHidden.toggle();
                    },
                    icon: Icon(controller.isHidden.isFalse
                        ? Icons.visibility_off
                        : Icons.visibility),
                  ),
                ),
              );
            },
          ),
          const SizedBox(
            height: 20,
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            onPressed: () async {
              if (controller.isLoading.isFalse) {
                if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
                  controller.isLoading(true);
                  //proses login
                  Map<String, dynamic> hasil =
                      await authC.login(emailC.text, passC.text);
                  controller.isLoading(false);
                  if (hasil["error"] == true) {
                    Get.snackbar("Error", hasil["message"]);
                  } else {
                    Get.offAllNamed(Routes.home);
                  }
                } else {
                  Get.snackbar("Error", "Email dan password wajib diisi.");
                }
              }
            },
            child: Obx(
              () {
                return Text(
                    controller.isLoading.isFalse ? "Login" : "Loading...");
              },
            ),
          ),
        ],
      ),
    );
  }
}
