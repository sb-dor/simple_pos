import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_pos_app/src/common/constants/constants.dart';
import 'package:test_pos_app/src/common/layout/window_size.dart';
import 'package:test_pos_app/src/common/uikit/app_bar_back.dart';
import 'package:test_pos_app/src/common/uikit/main_app_drawer.dart';
import 'package:test_pos_app/src/common/uikit/text_widget.dart';
import 'package:test_pos_app/src/common/utils/router/app_router.dart';
import 'package:test_pos_app/src/features/authentication/widgets/authentication_listener.dart';
import 'package:test_pos_app/src/features/categories/bloc/categories_bloc.dart';
import 'package:test_pos_app/src/features/category_creation/bloc/category_creation_bloc.dart';
import 'package:test_pos_app/src/features/category_creation/widgets/controllers/category_creation_widget_controller.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:test_pos_app/src/features/products_of_category/bloc/products_of_category_bloc.dart';
import 'package:test_pos_app/src/features/products_of_category/widgets/products_of_category_config_widget.dart';
import 'package:test_pos_app/src/features/synchronization/widgets/synchronization_listener.dart';

class CategoryCreationWidgets extends StatefulWidget {
  const CategoryCreationWidgets({required this.categoryId, super.key});

  final String categoryId;

  @override
  State<CategoryCreationWidgets> createState() => _CategoryCreationWidgetsState();
}

class _CategoryCreationWidgetsState extends State<CategoryCreationWidgets> {
  late final CategoryCreationWidgetController _categoryCreationWidgetController;
  final TextEditingController _nameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _categoryCreationWidgetController = CategoryCreationWidgetController(
      nameController: _nameController,
      categoryId: widget.categoryId,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocConsumer<CategoryCreationBloc, CategoryCreationState>(
    listener: (context, categoryCreationState) {
      if (categoryCreationState is CategoryCreation$InitialState &&
          categoryCreationState.category != null) {
        _categoryCreationWidgetController.init(categoryCreationState.category!);
      }
      if (categoryCreationState is CategoryCreation$CompletedState) {
        DependenciesScope.of(context).categoriesBloc.add(const CategoriesEvent.refresh());
        context.go(AppRoutesName.categories);
      }
    },
    builder: (context, categoryCreationState) => AuthenticationListener(
      child: (context) => SynchronizationListener(
        child: (context) => Scaffold(
          drawer: const MainAppDrawer(),
          appBar: const PreferredSize(
            preferredSize: Size(double.infinity, kToolbarHeight),
            child: AppBarBack(label: categoryCreation, backPath: AppRoutesName.categories),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              if (!_categoryCreationWidgetController.validated) return;
              context.read<CategoryCreationBloc>().add(
                CategoryCreationEvent.save(
                  categoryCreationData: _categoryCreationWidgetController.categoryCreationData,
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
            decoration: const BoxDecoration(gradient: LinearGradient(colors: appGradientColor)),
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
                        listenable: _categoryCreationWidgetController,
                        builder: (context, child) => CustomScrollView(
                          physics: const AlwaysScrollableScrollPhysics(),
                          slivers: [
                            SliverToBoxAdapter(
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Create Category',
                                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                    ),
                                    const SizedBox(height: 12),
                                    TextField(
                                      controller: _nameController,
                                      decoration: InputDecoration(
                                        labelText: 'Category Name',
                                        border: const OutlineInputBorder(),
                                        errorText: _categoryCreationWidgetController.error,
                                      ),
                                    ),
                                    const SizedBox(height: 12),
                                    Row(
                                      children: [
                                        const Text('Color: '),
                                        GestureDetector(
                                          onTap: () =>
                                              _categoryCreationWidgetController.pickColor(context),
                                          child: Container(
                                            width: 30,
                                            height: 30,
                                            decoration: BoxDecoration(
                                              color:
                                                  _categoryCreationWidgetController.selectedColor,
                                              shape: BoxShape.circle,
                                              border: Border.all(color: Colors.black12),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        final productsOfCategoryBloc = context
                                            .read<ProductsOfCategoryBloc>();
                                        showDialog(
                                          context: context,
                                          builder: (context) => AlertDialog(
                                            contentPadding: EdgeInsets.zero,
                                            insetPadding: EdgeInsets.zero,
                                            content: SizedBox(
                                              width: MediaQuery.of(context).size.height * 0.4,
                                              child: ProductsOfCategoryConfigWidget(
                                                categoryId: widget.categoryId,
                                              ),
                                            ),
                                          ),
                                        ).whenComplete(
                                          () => productsOfCategoryBloc.add(
                                            ProductsOfCategoryEvent.load(
                                              categoryId: widget.categoryId,
                                            ),
                                          ),
                                        );
                                      },
                                      child: const TextWidget(text: productsOfCategory),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
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
    ),
  );
}
