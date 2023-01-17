import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode_barang/app/data/Models/product_model.dart';
import 'package:qrcode_barang/app/routes/app_pages.dart';

import '../controllers/products_controller.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: controller.streamProducts(),
        builder: (context, snapProduct) {
          if (snapProduct.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (snapProduct.data!.docs.isEmpty) {
            return const Center(
              child: Text("Data Produk tidak ada"),
            );
          }

          List<ProductModel> allProduct = [];

          for (var element in snapProduct.data!.docs) {
            allProduct.add(ProductModel.fromJson(element.data()));
          }
          return ListView.builder(
            itemCount: allProduct.length,
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              ProductModel product = allProduct[index];
              return Card(
                color: Colors.grey.shade300,
                elevation: 3,
                margin: const EdgeInsets.only(bottom: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.detailProduct, arguments: product);
                  },
                  borderRadius: BorderRadius.circular(10),
                  child: Container(
                    height: 100,
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                product.code,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(
                                height: 5,
                              ),
                              Text(product.name),
                              const SizedBox(
                                height: 5,
                              ),
                              Text("Jumlah : ${product.qty}"),
                            ],
                          ),
                        ),
                        Container(
                          height: 65,
                          width: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: QrImage(
                            data: product.code,
                            size: 200,
                            version: QrVersions.auto,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
