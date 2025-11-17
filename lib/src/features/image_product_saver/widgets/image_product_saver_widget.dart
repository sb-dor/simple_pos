import 'dart:io';

import 'package:flutter/material.dart';
import 'package:test_pos_app/src/features/image_product_saver/controller/image_product_saver_controller.dart';
import 'package:test_pos_app/src/features/image_product_saver/models/image_size.dart';
import 'package:test_pos_app/src/features/image_product_saver/models/temo_product_data.dart';
import 'package:test_pos_app/src/features/image_product_saver/models/temp_image_model.dart';
import 'package:test_pos_app/src/features/image_product_saver/models/temp_product.dart';
import 'package:test_pos_app/src/features/image_product_saver/widgets/image_product_update_widget.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';

class ImageProductSaverWidget extends StatefulWidget {
  const ImageProductSaverWidget({super.key});

  @override
  State<ImageProductSaverWidget> createState() => _ImageProductSaverWidgetState();
}

class _ImageProductSaverWidgetState extends State<ImageProductSaverWidget> {
  late TempProduct tempProduct;
  late final ImageProductSaverController _imageProductSaverController;

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context);
    tempProduct = product;
    _imageProductSaverController = ImageProductSaverController(dependencies.logger);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Image saver"),
        actions: [
          TextButton(
            onPressed: () {
              _imageProductSaverController.setImagesWithProduct(tempProduct);
            },
            child: Text("Send images"),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ImageProductUpdateWidget()),
              );
            },
            child: Text("Get product"),
          ),
        ],
      ),
      body: ListView(
        children: [
          Row(
            children: [
              Text("Product: ${tempProduct.name}"),
              TextButton(
                onPressed: () {
                  _imageProductSaverController.pickImageForProduct(tempProduct);
                },
                child: Text("Pick image"),
              ),
            ],
          ),
          ListenableBuilder(
            listenable: _imageProductSaverController,
            builder: (context, child) {
              return Column(
                children: tempProduct.productImages
                    .map(
                      (element) => SizedBox(
                        width: 100,
                        height: 100,
                        child: element.file != null
                            ? Image.file(File(element.file!.path))
                            : element.path != null
                            ? Image.network(element.imageURL(ImageSize.original))
                            : ColoredBox(color: Colors.grey),
                      ),
                    )
                    .toList(),
              );
            },
          ),
          ListenableBuilder(
            listenable: _imageProductSaverController,
            builder: (context, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: product.variants
                    .map(
                      (element) => Column(
                        children: [
                          Row(
                            children: [
                              Text(element.name ?? '-'),
                              TextButton(
                                onPressed: () {
                                  _imageProductSaverController.pickImageForProductVariant(element);
                                },
                                child: Text("Pick image"),
                              ),
                            ],
                          ),
                          Column(
                            children: (element.images ?? <TempImageModel>[])
                                .map(
                                  (element) => SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: element.file != null
                                        ? Image.file(File(element.file!.path))
                                        : element.path != null
                                        ? Image.network(element.imageURL(ImageSize.original))
                                        : ColoredBox(color: Colors.grey),
                                  ),
                                )
                                .toList(),
                          ),
                          SizedBox(height: 20),
                        ],
                      ),
                    )
                    .toList(),
              );
            },
          ),
        ],
      ),
    );
  }
}
