import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_pos_app/src/common/layout/window_size.dart';
import 'package:test_pos_app/src/common/uikit/circular_progress_indicator_widget.dart';
import 'package:test_pos_app/src/common/uikit/text_widget.dart';
import 'package:test_pos_app/src/common/utils/constants/constants.dart';
import 'package:test_pos_app/src/common/utils/reusable_functions.dart';
import 'package:test_pos_app/src/common/utils/router/app_router.dart';
import 'package:test_pos_app/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:test_pos_app/src/features/authentication/models/establishment.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';

class AuthenticationAuthCheckWidget extends StatefulWidget {
  const AuthenticationAuthCheckWidget({super.key});

  @override
  State<AuthenticationAuthCheckWidget> createState() => _AuthenticationAuthCheckWidgetState();
}

class _AuthenticationAuthCheckWidgetState extends State<AuthenticationAuthCheckWidget>
    with SingleTickerProviderStateMixin {
  late final AuthenticationBloc _authenticationBloc;
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _authenticationBloc = DependenciesScope.of(context).authenticationBloc;

    _authenticationBloc.add(AuthenticationEvent.checkAuthentication(onMessage: _onMessage));

    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);

    _fadeAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void _onMessage(String message) {
    if (!mounted) return;
    ReusableFunctions.instance.showSnackBar(context: context, message: message);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => BlocListener<AuthenticationBloc, AuthenticationState>(
    bloc: _authenticationBloc,
    listener: _handleStateChange,
    child: Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: appGradientColor,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: WindowSizeScope.of(context).maybeMap(
          compact: () =>
              Padding(padding: const EdgeInsets.all(16), child: _buildCompactContent(context)),
          medium: () =>
              Padding(padding: const EdgeInsets.all(16), child: _buildCompactContent(context)),
          expanded: () => _buildCenteredContent(context),
          orElse: () => _buildCenteredContent(context, dividedBy: 3),
        ),
      ),
    ),
  );

  void _handleStateChange(BuildContext context, AuthenticationState state) {
    if (state is Authentication$AuthenticatedState) {
      final establishments = state.stateModel.allUserEstablishments ?? <Establishment>[];
      if (state.stateModel.establishment == null && establishments.length > 1) {
        Router.neglect(
          context,
          () => context.go(AppRoutesName.authentication + AppRoutesName.establishmentsSelection),
        );
      } else {
        Router.neglect(context, () => context.go(AppRoutesName.orderTables));
      }
    } else if (state is Authentication$UnauthenticatedState) {
      Router.neglect(context, () => context.go(AppRoutesName.authentication + AppRoutesName.login));
    }
  }

  Widget _buildCompactContent(BuildContext context) => _buildContent();

  Widget _buildCenteredContent(BuildContext context, {int dividedBy = 1}) => Center(
    child: FractionallySizedBox(widthFactor: 1 / dividedBy, child: _buildContent()),
  );

  Widget _buildContent() => FadeTransition(
    opacity: _fadeAnimation,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Icon(Icons.lock_outline_rounded, color: Colors.white, size: 72),
        const SizedBox(height: 24),
        const TextWidget(
          text: 'Checking authentication...',
          color: Colors.white,
          size: 18,
          fontWeight: FontWeight.w500,
        ),
        const SizedBox(height: 20),
        const CircularProgressIndicatorWidget(color: Colors.white),
        const SizedBox(height: 16),
        Text(
          'Please wait a moment',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 14),
        ),
      ],
    ),
  );
}
