import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../data/Models/product_model.dart';
import '../controllers/detail_product_controller.dart';

class DetailProductView extends GetView<DetailProductController> {
  DetailProductView({Key? key}) : super(key: key);

  final TextEditingController codeC = TextEditingController();
  final TextEditingController nameC = TextEditingController();
  final TextEditingController qtyC = TextEditingController();

  final ProductModel product = Get.arguments;
  @override
  Widget build(BuildContext context) {
    codeC.text = product.code;
    nameC.text = product.name;
    qtyC.text = product.qty.toString();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Product'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 200,
                width: 200,
                child: QrImage(
                  data: product.code,
                  size: 200,
                  version: QrVersions.auto,
                ),
              ),
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          TextField(
            autocorrect: false,
            keyboardType: TextInputType.number,
            controller: codeC,
            readOnly: true,
            decoration: InputDecoration(
              labelText: "Product Code",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(18),
              ),
              prefixIcon: const Icon(Icons.key),
            ),
          ),
          const SizedBox(
            height: 20,
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
              if (controller.isLoadingUpdate.isFalse) {
                if (nameC.text.isNotEmpty && qtyC.text.isNotEmpty) {
                  controller.isLoadingUpdate(true);
                  Map<String, dynamic> hasil = await controller.editProduct({
                    "id": product.productId,
                    "name": nameC.text,
                    "qty": int.tryParse(qtyC.text) ?? 0,
                  });
                  controller.isLoadingUpdate(false);
                  Get.snackbar(
                    hasil["error"] == true ? "Error" : "Berhasil",
                    hasil['message'],
                    duration: const Duration(seconds: 2),
                  );
                } else {
                  Get.snackbar(
                    "Error",
                    "Semua data wajib diisi",
                    duration: const Duration(seconds: 2),
                  );
                }
              }
            },
            child: Obx(
              () {
                return Text(
                  controller.isLoadingUpdate.isFalse
                      ? "Update Product"
                      : "Loading...",
                );
              },
            ),
          ),
          TextButton(
            onPressed: () {
              Get.defaultDialog(
                title: "Hapus Product",
                middleText: "Apakah anda mau menghapus product ini?",
                actions: [
                  OutlinedButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: const Text("Batal"),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      controller.isLoadingDelete(true);
                      Map<String, dynamic> hasil =
                          await controller.deleteProduct(product.productId);
                      controller.isLoadingDelete(false);

                      Get.back(); // tutup dialog
                      Get.back(); // Balik ke page all products

                      Get.snackbar(
                        hasil["error"] == true ? "Error" : "Berhasil",
                        hasil['message'],
                        duration: const Duration(seconds: 2),
                      );
                    },
                    child: Obx(
                      () => controller.isLoadingDelete.isFalse
                          ? const Text("Hapus")
                          : const SizedBox(
                              height: 15,
                              width: 15,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                    ),
                  ),
                ],
              );
            },
            child: const Text(
              "Delete Product",
              style: TextStyle(
                color: Colors.redAccent,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
