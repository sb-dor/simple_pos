import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pos_app/src/common/layout/window_size.dart';
import 'package:test_pos_app/src/common/uikit/circular_progress_indicator_widget.dart';
import 'package:test_pos_app/src/common/uikit/error_button_widget.dart';
import 'package:test_pos_app/src/common/uikit/main_app_bar.dart';
import 'package:test_pos_app/src/common/uikit/main_app_drawer.dart';
import 'package:test_pos_app/src/common/uikit/text_widget.dart';
import 'package:test_pos_app/src/common/utils/constants/constants.dart';
import 'package:test_pos_app/src/common/utils/router/app_router.dart';
import 'package:go_router/go_router.dart';
import 'package:test_pos_app/src/features/authentication/widgets/authentication_listener.dart';
import 'package:test_pos_app/src/features/categories/bloc/categories_bloc.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:test_pos_app/src/features/synchronization/widgets/synchronization_listener.dart';

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  late final CategoriesBloc _categoriesBloc;

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context);
    _categoriesBloc = dependencies.categoriesBloc;
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticationListener(
      child: (context) => SynchronizationListener(
        child: (context) => Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              context.go(AppRoutesName.categories + AppRoutesName.creation);
            },
            child: Icon(Icons.add),
          ),
          floatingActionButtonLocation: WindowSizeScope.of(context).maybeMap(
            orElse: () => FloatingActionButtonLocation.centerFloat,
            compact: () => FloatingActionButtonLocation.endFloat,
          ),
          drawer: MainAppDrawer(),
          appBar: PreferredSize(
            preferredSize: Size(double.infinity, kToolbarHeight),
            child: MainAppBar(label: Constants.categories),
          ),
          body: DecoratedBox(
            decoration: BoxDecoration(gradient: LinearGradient(colors: Constants.appGradientColor)),
            child: SafeArea(
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(child: SizedBox(height: 10)),
                  BlocBuilder<CategoriesBloc, CategoriesState>(
                    bloc: _categoriesBloc,
                    builder: (context, categoriesState) {
                      switch (categoriesState) {
                        case Categories$InitialState():
                          return SliverToBoxAdapter(child: SizedBox.shrink());
                        case Categories$InProgressState():
                          return SliverFillRemaining(
                            child: Center(child: CircularProgressIndicatorWidget()),
                          );
                        case Categories$ErrorState():
                          return SliverFillRemaining(
                            child: Center(
                              child: ErrorButtonWidget(
                                label: Constants.reloadLabel,
                                onTap: () {
                                  _categoriesBloc.add(CategoriesEvent.refresh());
                                },
                              ),
                            ),
                          );

                        case Categories$CompletedState():
                          return SliverToBoxAdapter(
                            child: Center(
                              child: SizedBox(
                                width: WindowSizeScope.of(context).expandedSize,
                                child: GridView.builder(
                                  padding: const EdgeInsets.all(12),
                                  itemCount: categoriesState.categories.length,
                                  shrinkWrap: true,
                                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4, // number of circles per row
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                    childAspectRatio: 0.9,
                                  ),
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemBuilder: (context, index) {
                                    final category = categoriesState.categories[index];

                                    return GestureDetector(
                                      onTap: () async {
                                        context.go(
                                          "${AppRoutesName.categories}${AppRoutesName.creation}?categoryId=${category.id}",
                                        );
                                      },
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          CircleAvatar(
                                            radius: 30,
                                            backgroundColor: category.color ?? Colors.grey,
                                            child: TextWidget(
                                              text:
                                                  category.name != null && category.name!.isNotEmpty
                                                  ? category.name![0].toUpperCase()
                                                  : '-',
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              size: 18,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          TextWidget(
                                            text: category.name ?? '',
                                            textAlign: TextAlign.center,
                                            overFlow: TextOverflow.ellipsis,
                                            color: Colors.white,
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                          );
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
