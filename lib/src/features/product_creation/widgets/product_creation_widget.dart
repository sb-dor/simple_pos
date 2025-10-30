part of 'product_creation_config_widget.dart';

class _ProductCreationWidgets extends StatefulWidget {
  const _ProductCreationWidgets({this.productId});

  final String? productId;

  @override
  State<_ProductCreationWidgets> createState() => _ProductCreationWidgetsState();
}

class _ProductCreationWidgetsState extends State<_ProductCreationWidgets> {
  late final ProductCreationWidgetController _productCreationWidgetController;

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _wholesalePriceController = TextEditingController();
  final _packQtyController = TextEditingController();
  final _barcodeController = TextEditingController();

  late final TextControllerListener _nameControllerListener;
  late final TextControllerListener _priceControllerListener;
  late final TextControllerListener _wholesalePriceControllerListener;
  late final TextControllerListener _packQtyControllerListener;

  @override
  void initState() {
    super.initState();
    _productCreationWidgetController = ProductCreationWidgetController();
    _nameControllerListener = TextControllerListener(_nameController);
    _priceControllerListener = TextControllerListener(_priceController);
    _wholesalePriceControllerListener = TextControllerListener(_wholesalePriceController);
    _packQtyControllerListener = TextControllerListener(_packQtyController);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    _wholesalePriceController.dispose();
    _packQtyController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SynchronizationListener(
      child: (context) => Scaffold(
        drawer: const MainAppDrawer(),
        appBar: PreferredSize(
          preferredSize: const Size(double.infinity, kToolbarHeight),
          child: const AppBarBack(label: "Create Product"),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            if (!_controller.validated) return;
            // TODO: Integrate with your Bloc save logic here
            context.pop();
          },
          child: const Icon(Icons.save),
        ),
        floatingActionButtonLocation: WindowSizeScope.of(context).maybeMap(
          orElse: () => FloatingActionButtonLocation.centerFloat,
          compact: () => FloatingActionButtonLocation.endFloat,
        ),
        body: DecoratedBox(
          decoration: BoxDecoration(gradient: LinearGradient(colors: Constants.appGradientColor)),
          child: SafeArea(
            child: Center(
              child: SizedBox(
                width: WindowSizeScope.of(context).expandedSize,
                child: Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: ListenableBuilder(
                      listenable: _controller,
                      builder: (context, _) {
                        return SingleChildScrollView(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Create Product",
                                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 12),

                              // 🏷️ Product name
                              TextField(
                                controller: _nameController,
                                decoration: InputDecoration(
                                  labelText: "Product Name",
                                  border: const OutlineInputBorder(),
                                  errorText: _controller.nameError,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // 💰 Price
                              TextField(
                                controller: _priceController,
                                keyboardType: TextInputType.number,
                                decoration: InputDecoration(
                                  labelText: "Retail Price",
                                  border: const OutlineInputBorder(),
                                  errorText: _controller.priceError,
                                ),
                              ),
                              const SizedBox(height: 12),

                              // 🏷️ Wholesale price
                              TextField(
                                controller: _wholesalePriceController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Wholesale Price",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // 📦 Pack quantity
                              TextField(
                                controller: _packQtyController,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  labelText: "Pack Quantity",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // 🏷️ Barcode
                              TextField(
                                controller: _barcodeController,
                                decoration: const InputDecoration(
                                  labelText: "Barcode",
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              const SizedBox(height: 12),

                              // 🧩 Product type dropdown
                              DropdownButtonFormField<ProductType>(
                                value: _controller.productType,
                                decoration: const InputDecoration(
                                  labelText: "Product Type",
                                  border: OutlineInputBorder(),
                                ),
                                items: ProductType.values
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text("${e.type} (${e.unit})"),
                                      ),
                                    )
                                    .toList(),
                                onChanged: _controller.setProductType,
                              ),
                              const SizedBox(height: 12),

                              // 🗂 Category selector (placeholder)
                              DropdownButtonFormField<CategoryModel>(
                                value: _controller.selectedCategory,
                                decoration: const InputDecoration(
                                  labelText: "Category",
                                  border: OutlineInputBorder(),
                                ),
                                items: _controller.availableCategories
                                    .map(
                                      (cat) => DropdownMenuItem(
                                        value: cat,
                                        child: Text(cat.name ?? "Unnamed"),
                                      ),
                                    )
                                    .toList(),
                                onChanged: _controller.setCategory,
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
