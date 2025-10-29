import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_pos_app/src/common/utils/router/app_router.dart';
import 'package:test_pos_app/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:test_pos_app/src/features/products/bloc/products_bloc.dart';

class ProductsWidget extends StatefulWidget {
  const ProductsWidget({super.key});

  @override
  State<ProductsWidget> createState() => _ProductsWidgetState();
}

class _ProductsWidgetState extends State<ProductsWidget> {
  late final AuthenticationBloc _authenticationBloc;
  late final ProductsBloc _productsBloc;

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context, listen: false);
    _authenticationBloc = dependencies.authenticationBloc;
    _productsBloc = dependencies.productsBloc;
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
      child: Scaffold(),
    );
  }
}
