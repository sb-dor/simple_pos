import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_pos_app/src/common/utils/router/app_router.dart';
import 'package:test_pos_app/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';

class AuthenticationListener extends StatefulWidget {
  const AuthenticationListener({required this.child, super.key});

  final WidgetBuilder child;

  @override
  State<AuthenticationListener> createState() => _AuthenticationListenerState();
}

class _AuthenticationListenerState extends State<AuthenticationListener> {
  late final AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context);
    _authenticationBloc = dependencies.authenticationBloc;
  }

  @override
  Widget build(BuildContext context) => BlocListener<AuthenticationBloc, AuthenticationState>(
    bloc: _authenticationBloc,
    listener: (context, state) {
      if (state is Authentication$UnauthenticatedState) {
        context.pushReplacement(AppRoutesName.authentication + AppRoutesName.login);
      }
    },
    child: widget.child(context),
  );
}
