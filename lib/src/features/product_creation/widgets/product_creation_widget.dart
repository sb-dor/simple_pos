part of 'product_creation_config_widget.dart';

class _ProductCreationWidgets extends StatefulWidget {
  const _ProductCreationWidgets({this.productId});

  final String? productId;

  @override
  State<_ProductCreationWidgets> createState() => _ProductCreationWidgetsState();
}

class _ProductCreationWidgetsState extends State<_ProductCreationWidgets> {
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

  ProductType? _productType;

  @override
  void initState() {
    super.initState();
    _nameControllerListener = TextControllerListener(_nameController);
    _priceControllerListener = TextControllerListener(_priceController);
    _packQtyControllerListener = TextControllerListener(_packQtyController);
    _barcodeControllerListener = TextControllerListener(_barcodeController);
  }

  @override
  void dispose() {
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
    if (product.price != null) {
      _priceController.text = "${ReusableFunctions.instance.separateNumbersRegex(product.price)}";
    }
    if (product.wholesalePrice != null) {
      _wholesalePriceController.text =
          "${ReusableFunctions.instance.separateNumbersRegex(product.wholesalePrice)}";
    }
    if (product.packQty != null) {
      _packQtyController.text =
          "${ReusableFunctions.instance.separateNumbersRegex(product.packQty)}";
    }
    _packQtyController.text = product.packQty?.toString() ?? '';
    _barcodeController.text = product.barcode ?? '';
    _productType = product.productType;
    _productTypeController.text = "${product.productType.type}, ${product.productType.unit}";
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
          DependenciesScope.of(context, listen: false).productsBloc.add(ProductsEvent.load());
          context.go(AppRoutesName.products);
        }
      },
      child: AuthenticationListener(
        child: (context) => SynchronizationListener(
          child: (context) => Scaffold(
            drawer: const MainAppDrawer(),
            appBar: PreferredSize(
              preferredSize: const Size(double.infinity, kToolbarHeight),
              child: const AppBarBack(label: "Create Product", backPath: AppRoutesName.products),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                final nameValidated = _nameControllerListener.validated;
                final priceValidated = _priceControllerListener.validated;
                final packQtyValidated = _packQtyControllerListener.validated;
                final barcodeValidated = _barcodeControllerListener.validated;

                if (!nameValidated || !priceValidated || !packQtyValidated || !barcodeValidated) {
                  return;
                }

                final trimmedPrice = ReusableFunctions.instance.clearSeparatedNumbers(
                  _priceController.text.trim(),
                );
                final trimmedWholeSalePrice = ReusableFunctions.instance.clearSeparatedNumbers(
                  _wholesalePriceController.text.trim(),
                );
                final trimmedPackQty = ReusableFunctions.instance.clearSeparatedNumbers(
                  _packQtyController.text.trim(),
                );

                final productCreationData = ProductCreationData(
                  name: _nameControllerListener.trimmedText,
                  price: double.tryParse(trimmedPrice),
                  wholesalePrice: double.tryParse(trimmedWholeSalePrice),
                  packQty: double.tryParse(trimmedPackQty),
                  barcode: _barcodeControllerListener.trimmedText,
                  productType: _productType,
                );

                context.read<ProductCreationBloc>().add(
                  ProductCreationEvent.save(
                    productCreationData: productCreationData,
                    onSave: () {},
                  ),
                );
              },
              child: const Icon(Icons.save),
            ),
            floatingActionButtonLocation: WindowSizeScope.of(context).maybeMap(
              orElse: () => FloatingActionButtonLocation.centerFloat,
              compact: () => FloatingActionButtonLocation.endFloat,
            ),
            body: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: Constants.appGradientColor),
              ),
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
                            _nameControllerListener,
                            _priceControllerListener,
                            _packQtyControllerListener,
                            _barcodeControllerListener,
                          ]),
                          builder: (context, _) {
                            return ListView(
                              padding: const EdgeInsets.all(16),
                              children: [
                                TextField(
                                  controller: _nameController,
                                  decoration: InputDecoration(
                                    labelText: "Product Name",
                                    border: const OutlineInputBorder(),
                                    errorText: _nameControllerListener.error,
                                  ),
                                ),
                                const SizedBox(height: 12),

                                TextField(
                                  controller: _priceController,
                                  keyboardType: ReusableFunctions.instance.numberInputType,
                                  decoration: InputDecoration(
                                    labelText: "Retail Price",
                                    border: const OutlineInputBorder(),
                                    errorText: _priceControllerListener.error,
                                  ),
                                  inputFormatters: [DecimalTextInputFormatter()],
                                ),
                                const SizedBox(height: 12),

                                TextField(
                                  controller: _wholesalePriceController,
                                  keyboardType: ReusableFunctions.instance.numberInputType,
                                  decoration: const InputDecoration(
                                    labelText: "Wholesale Price",
                                    border: OutlineInputBorder(),
                                  ),
                                  inputFormatters: [DecimalTextInputFormatter()],
                                ),
                                const SizedBox(height: 12),

                                TextField(
                                  controller: _packQtyController,
                                  keyboardType: ReusableFunctions.instance.numberInputType,
                                  decoration: InputDecoration(
                                    labelText: "Pack Quantity",
                                    border: OutlineInputBorder(),
                                    errorText: _packQtyControllerListener.error,
                                  ),
                                  inputFormatters: [DecimalTextInputFormatter()],
                                ),
                                const SizedBox(height: 12),

                                TextField(
                                  controller: _barcodeController,
                                  decoration: const InputDecoration(
                                    labelText: "Barcode",
                                    border: OutlineInputBorder(),
                                  ),
                                ),
                                const SizedBox(height: 12),

                                DropDownSelectionWidget(
                                  textController: _productTypeController,
                                  listOfDropdownEntries: ProductType.values
                                      .map(
                                        (e) => DropdownMenuEntry<ProductType>(
                                          value: e,
                                          label: "${e.type}, ${e.unit}",
                                        ),
                                      )
                                      .toList(),
                                  title: "Product Type",
                                  enableSearch: false,
                                  requestFocusOnTap: false,
                                  onSelect: (productType) {
                                    setState(() {
                                      if (_productType == productType) {
                                        _productType = null;
                                      } else {
                                        _productType = productType;
                                      }
                                    });
                                  },
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
      ),
    );
  }
}
