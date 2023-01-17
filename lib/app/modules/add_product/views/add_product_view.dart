import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/add_product_controller.dart';

class AddProductView extends GetView<AddProductController> {
  AddProductView({Key? key}) : super(key: key);
  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Product'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            autocorrect: false,
            keyboardType: TextInputType.number,
            controller: codeC,
            maxLength: 10,
            decoration: InputDecoration(
              labelText: "Product Code",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              prefixIcon: const Icon(Icons.key),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
            autocorrect: false,
            keyboardType: TextInputType.name,
            controller: nameC,
            decoration: InputDecoration(
              labelText: "Product Name",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              prefixIcon: const Icon(Icons.list_alt_rounded),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            keyboardType: TextInputType.number,
            controller: qtyC,
            decoration: InputDecoration(
              labelText: "Product QTY",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              prefixIcon: const Icon(Icons.add),
            ),
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
                if (codeC.text.isNotEmpty &&
                    nameC.text.isNotEmpty &&
                    qtyC.text.isNotEmpty) {
                  controller.isLoading(true);
                  Map<String, dynamic> hasil = await controller.addProduct({
                    "code": codeC.text,
                    "name": nameC.text,
                    "qty": int.tryParse(qtyC.text) ?? 0,
                  });
                  controller.isLoading(false);

                  Get.back();

                  Get.snackbar(
                    hasil["error"] == true ? "Error" : "Success",
                    hasil["message"],
                  );
                } else {
                  Get.snackbar("Error", "Semua data wajib diisi");
                }
              }
            },
            child: Obx(
              () {
                return Text(controller.isLoading.isFalse
                    ? "Add Product"
                    : "Loading...");
              },
            ),
          ),
        ],
      ),
    );
  }
}
