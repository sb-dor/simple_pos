import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:test_pos_app/src/features/image_product_saver/controller/image_product_constant.dart';
import 'package:test_pos_app/src/features/image_product_saver/controller/image_product_update_controller.dart';
import 'package:test_pos_app/src/features/image_product_saver/models/image_size.dart';
import 'package:test_pos_app/src/features/image_product_saver/models/temp_product.dart';
import 'package:test_pos_app/src/features/image_product_saver/models/temp_variant.dart';

class ImageProductUpdateWidget extends StatefulWidget {
  const ImageProductUpdateWidget({super.key});

  @override
  State<ImageProductUpdateWidget> createState() => _ImageProductUpdateWidgetState();
}

class _ImageProductUpdateWidgetState extends State<ImageProductUpdateWidget> {
  late final ImageProductUpdateController _imageProductUpdateController;

  @override
  void initState() {
    super.initState();
    _imageProductUpdateController = ImageProductUpdateController();
    _imageProductUpdateController.product(ImageProductConstant.tempProductId);
  }

  @override
  void dispose() {
    _imageProductUpdateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      actions: [
        TextButton(
          onPressed: () {
            _imageProductUpdateController.addVariant();
          },
          child: const Text('Add variant'),
        ),
        TextButton(
          onPressed: () {
            _imageProductUpdateController.update();
          },
          child: const Text('Save'),
        ),
      ],
    ),
    body: ListenableBuilder(
      listenable: _imageProductUpdateController,
      builder: (context, child) {
        if (_imageProductUpdateController.tempProduct == null) {
          return const SizedBox();
        } else {
          return ListView(
            children: [
              Wrap(
                children: [
                  _ProductPrice(product: _imageProductUpdateController.tempProduct!),
                  Text('Product: ${_imageProductUpdateController.tempProduct!.name}'),
                  TextButton(
                    onPressed: () {
                      _imageProductUpdateController.pickImageForProduct();
                      // _imageProductSaverController.pickImageForProduct(tempProduct);
                    },
                    child: const Text('Pick image'),
                  ),
                ],
              ),
              ReorderableListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _imageProductUpdateController.tempProduct!.productImages.length,
                onReorder: (oldIndex, newIndex) {
                  _imageProductUpdateController.reorderProductImages(oldIndex, newIndex);
                },
                itemBuilder: (context, index) {
                  final image = _imageProductUpdateController.tempProduct!.productImages[index];
                  return Stack(
                    key: ValueKey(image.path ?? image.file?.path ?? index),
                    children: [
                      SizedBox(
                        width: 100,
                        height: 100,
                        child: image.file != null
                            ? Image.file(File(image.file!.path))
                            : image.path != null
                            ? Image.network(image.imageURL(ImageSize.original))
                            : const ColoredBox(color: Colors.grey),
                      ),
                      Positioned(
                        child: IconButton(
                          onPressed: () {
                            _imageProductUpdateController.removeImageFromProduct(index);
                          },
                          icon: const Icon(Icons.delete, color: Colors.red),
                        ),
                      ),
                    ],
                  );
                },
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _imageProductUpdateController.tempProduct!.variants.indexed
                    .map(
                      (variant) => Column(
                        children: [
                          Row(
                            children: [
                              _ProductVariantPrice(variant: variant.$2),
                              Text(variant.$2.name ?? '-'),
                              TextButton(
                                onPressed: () {
                                  _imageProductUpdateController.removeVariant(variant.$1);
                                },
                                child: const Icon(Icons.delete),
                              ),
                              TextButton(
                                onPressed: () {
                                  _imageProductUpdateController.pickImageForProductVariant(
                                    variant.$2,
                                  );
                                  // _imageProductUpdateController.pickImageForProductVariant(
                                  //   element,
                                  // );
                                },
                                child: const Text('Pick image'),
                              ),
                            ],
                          ),
                          ReorderableListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: variant.$2.images?.length ?? 0,
                            onReorder: (oldIndex, newIndex) {
                              // Fix newIndex offset due to ReorderableListView behavior
                              if (newIndex > oldIndex) newIndex -= 1;
                              _imageProductUpdateController.reorderVariantImages(
                                variant.$2,
                                oldIndex,
                                newIndex,
                              );
                            },
                            itemBuilder: (context, index) {
                              final image = variant.$2.images![index];
                              return Stack(
                                key: ValueKey(image.id ?? image.path ?? image.file?.path ?? index),
                                children: [
                                  SizedBox(
                                    width: 100,
                                    height: 100,
                                    child: (image.file != null && kIsWeb)
                                        ? Image.network(image.file!.path, fit: BoxFit.cover)
                                        : image.file != null
                                        ? Image.file(File(image.file!.path), fit: BoxFit.cover)
                                        : image.path != null
                                        ? Image.network(
                                            image.imageURL(ImageSize.original),
                                            fit: BoxFit.cover,
                                          )
                                        : const ColoredBox(color: Colors.grey),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: IconButton(
                                      onPressed: () {
                                        _imageProductUpdateController.removeImageFromProductVariant(
                                          variant.$2,
                                          index,
                                        );
                                      },
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                        ],
                      ),
                    )
                    .toList(),
              ),
            ],
          );
        }
      },
    ),
  );
}

class _ProductPrice extends StatefulWidget {
  const _ProductPrice({required this.product});

  final TempProduct product;

  @override
  State<_ProductPrice> createState() => __ProductPriceState();
}

class __ProductPriceState extends State<_ProductPrice> {
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _priceController.text = widget.product.price.toStringAsFixed(2);
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 100,
    child: TextField(
      controller: _priceController,
      decoration: const InputDecoration(labelText: 'Price'),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        final parsedValue = double.tryParse(value);
        if (parsedValue != null) {
          widget.product.price = parsedValue;
        } else {
          // Handle invalid input if necessary
          // For example, you could show a snackbar or reset the field
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid price input'),
              duration: Duration(milliseconds: 300),
            ),
          );
        }
      },
    ),
  );
}

class _ProductVariantPrice extends StatefulWidget {
  const _ProductVariantPrice({required this.variant});

  final TempVariant variant;

  @override
  State<_ProductVariantPrice> createState() => __ProductVariantPriceState();
}

class __ProductVariantPriceState extends State<_ProductVariantPrice> {
  final TextEditingController _priceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _priceController.text = (widget.variant.price ?? 0).toStringAsFixed(2);
  }

  @override
  void dispose() {
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 100,
    child: TextField(
      controller: _priceController,
      decoration: const InputDecoration(labelText: 'Price'),
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      onChanged: (value) {
        final parsedValue = double.tryParse(value);
        if (parsedValue != null) {
          widget.variant.price = parsedValue;
        } else {
          // Handle invalid input if necessary
          // For example, you could show a snackbar or reset the field
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Invalid price input'),
              duration: Duration(milliseconds: 300),
            ),
          );
        }
      },
    ),
  );
}
