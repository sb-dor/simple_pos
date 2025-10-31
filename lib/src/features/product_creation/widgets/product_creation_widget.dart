part of 'product_creation_config_widget.dart';

class _ProductCreationWidgets extends StatefulWidget {
  const _ProductCreationWidgets({this.productId});

  final String? productId;

  @override
  State<_ProductCreationWidgets> createState() => _ProductCreationWidgetsState();
}

class _ProductCreationWidgetsState extends State<_ProductCreationWidgets> {
  late final ProductCreationWidgetController _productCreationWidgetController;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _wholesalePriceController = TextEditingController();
  final TextEditingController _packQtyController = TextEditingController();
  final TextEditingController _productTypeController = TextEditingController();
  final TextEditingController _barcodeController = TextEditingController();

  late final TextControllerListener _nameControllerListener;
  late final TextControllerListener _priceControllerListener;
  late final TextControllerListener _packQtyControllerListener;
  late final TextControllerListener _barcodeControllerListener;

  @override
  void initState() {
    super.initState();
    _productCreationWidgetController = ProductCreationWidgetController();
    _nameControllerListener = TextControllerListener(_nameController);
    _priceControllerListener = TextControllerListener(_priceController);
    _packQtyControllerListener = TextControllerListener(_packQtyController);
    _barcodeControllerListener = TextControllerListener(_barcodeController);
  }

  @override
  void dispose() {
    _productCreationWidgetController.dispose();
    _nameControllerListener.dispose();
    _priceControllerListener.dispose();
    _packQtyControllerListener.dispose();
    _barcodeControllerListener.dispose();
    _nameController.dispose();
    _priceController.dispose();
    _wholesalePriceController.dispose();
    _packQtyController.dispose();
    _productTypeController.dispose();
    _barcodeController.dispose();
    super.dispose();
  }

  void _initControllers(ProductModel product) {
    _nameController.text = product.name ?? '';
    _priceController.text = "price";
    _packQtyController.text = "pack";
    _barcodeController.text = "barcode";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductCreationBloc, ProductCreationState>(
      listener: (context, state) {
        if (state is ProductCreation$InitialState && state.product != null) {
          _initControllers(state.product!);
        }

        if (state is ProductCreation$CompletedState) {
          context.pop();
        }
      },
      child: SynchronizationListener(
        child: (context) => Scaffold(
          drawer: const MainAppDrawer(),
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, kToolbarHeight),
            child: const AppBarBack(label: "Create Product"),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              final nameValidated = _nameControllerListener.validated;
              final priceValidated = _priceControllerListener.validated;
              final packQtyValidated = _packQtyControllerListener.validated;
              final barcodeValidated = _barcodeControllerListener.validated;

              if (!nameValidated || !priceValidated || !packQtyValidated || !barcodeValidated)
                return;
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
                        listenable: Listenable.merge([
                          _productCreationWidgetController,
                          _nameControllerListener,
                          _priceControllerListener,
                          _packQtyControllerListener,
                          _barcodeControllerListener,
                        ]),
                        builder: (context, _) {
                          return ListView(
                            padding: const EdgeInsets.all(16),
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
                                  errorText: _nameControllerListener.error,
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
                                  errorText: _priceControllerListener.error,
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
                                decoration: InputDecoration(
                                  labelText: "Pack Quantity",
                                  border: OutlineInputBorder(),
                                  errorText: _packQtyControllerListener.error,
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
                              DropDownSelectionWidget(
                                textController: _productTypeController,
                                listOfDropdownEntries: ProductType.values
                                    .map(
                                      (e) =>
                                          DropdownMenuEntry<ProductType>(value: e, label: e.type),
                                    )
                                    .toList(),
                                title: "Product Type",
                                onSelect: (productType) {},
                              ),

                              const SizedBox(height: 12),
                            ],
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
      ),
    );
  }
}
