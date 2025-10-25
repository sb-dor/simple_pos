import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pos_app/src/common/layout/window_size.dart';
import 'package:test_pos_app/src/common/uikit/circular_progress_indicator_widget.dart';
import 'package:test_pos_app/src/common/uikit/error_button_widget.dart';
import 'package:test_pos_app/src/common/uikit/main_app_bar.dart';
import 'package:test_pos_app/src/common/uikit/main_app_drawer.dart';
import 'package:test_pos_app/src/common/utils/constants/constants.dart';
import 'package:test_pos_app/src/common/utils/router/app_router.dart';
import 'package:test_pos_app/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_pos_app/src/features/categories/bloc/categories_bloc.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:test_pos_app/src/features/synchronization/widgets/synchronization_listener.dart';

class CategoriesWidget extends StatefulWidget {
  const CategoriesWidget({super.key});

  @override
  State<CategoriesWidget> createState() => _CategoriesWidgetState();
}

class _CategoriesWidgetState extends State<CategoriesWidget> {
  late final AuthenticationBloc _authenticationBloc;
  late final CategoriesBloc _categoriesBloc;

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context, listen: false);
    _authenticationBloc = dependencies.authenticationBloc;
    _categoriesBloc = dependencies.categoriesBloc;
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthenticationBloc, AuthenticationState>(
      bloc: _authenticationBloc,
      listener: (context, state) {
        if (state is Authentication$UnauthenticatedState) {
          context.pushReplacement(AppRoutesName.authentication + AppRoutesName.login);
        }
      },
      child: SynchronizationListener(
        child: (context) => Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () async {
              await context.push(AppRoutesName.categories + AppRoutesName.creation);
              _categoriesBloc.add(CategoriesEvent.refresh());
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
          body: SafeArea(
            child: CustomScrollView(
              slivers: [
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
                            child: ErrorButtonWidget(label: Constants.reloadLabel, onTap: () {}),
                          ),
                        );

                      case Categories$CompletedState():
                        return SliverToBoxAdapter(
                          child: SizedBox(
                            width: WindowSizeScope.of(context).expandedSize,
                            child: GridView.builder(
                              padding: const EdgeInsets.all(12),
                              itemCount: categoriesState.categories.length,
                              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 4, // number of circles per row
                                crossAxisSpacing: 12,
                                mainAxisSpacing: 12,
                                childAspectRatio: 1,
                              ),
                              physics: const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                final category = categoriesState.categories[index];

                                return GestureDetector(
                                  onTap: () {},
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CircleAvatar(
                                        radius: 30,
                                        backgroundColor: category.color ?? Colors.grey,
                                        child: Text(
                                          category.name != null && category.name!.isNotEmpty
                                              ? category.name![0].toUpperCase()
                                              : '?',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        category.name ?? '',
                                        textAlign: TextAlign.center,
                                        style: const TextStyle(fontSize: 12),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ],
                                  ),
                                );
                              },
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
    );
  }
}
