import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_pos_app/src/common/layout/window_size.dart';
import 'package:test_pos_app/src/common/utils/constants/constants.dart';
import 'package:test_pos_app/src/common/utils/reusable_functions.dart';
import 'package:test_pos_app/src/common/utils/router/app_router.dart';
import 'package:test_pos_app/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';

class AuthenticationLoginWidget extends StatefulWidget {
  const AuthenticationLoginWidget({super.key});

  @override
  State<AuthenticationLoginWidget> createState() => _AuthenticationLoginWidgetState();
}

class _AuthenticationLoginWidgetState extends State<AuthenticationLoginWidget> {
  late final AuthenticationBloc _authenticationBloc;
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _authenticationBloc = DependenciesScope.of(context).authenticationBloc;
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onMessage(final String message) {
    if (!mounted) return;
    ReusableFunctions.instance.showSnackBar(context: context, message: message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: const SizedBox.shrink(),
      ),
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: Constants.appGradientColor,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: WindowSizeScope.of(context).maybeMap(
          orElse: () => _else(context, dividedBy: 3),
          compact: () => Padding(padding: const EdgeInsets.all(16.0), child: _compact(context)),
          medium: () => Padding(padding: const EdgeInsets.all(16.0), child: _compact(context)),
          expanded: () => _else(context),
        ),
      ),
    );
  }

  Widget _compact(BuildContext context) {
    return Center(child: SingleChildScrollView(child: _authCard(context)));
  }

  Widget _else(BuildContext context, {final double dividedBy = 2}) {
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / dividedBy,
          child: _authCard(context),
        ),
      ),
    );
  }

  Widget _authCard(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(0, 10))],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text(
            "Welcome Back 👋",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF334155)),
          ),
          const SizedBox(height: 8),
          const Text("Login to continue", style: TextStyle(fontSize: 16, color: Colors.black54)),
          const SizedBox(height: 30),
          _buildTextField(_emailController, 'Email', Icons.email_outlined, false),
          const SizedBox(height: 16),
          _buildTextField(
            _passwordController,
            'Password',
            Icons.lock_outline,
            true,
            onDone: () {
              _authenticationBloc.add(
                AuthenticationEvent.login(
                  email: _emailController.text.trim(),
                  password: _passwordController.text.trim(),
                  onMessage: _onMessage,
                ),
              );
            },
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: 200,
            child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
              bloc: _authenticationBloc,
              builder: (context, state) {
                return ElevatedButton(
                  onPressed: () {
                    _authenticationBloc.add(
                      AuthenticationEvent.login(
                        email: _emailController.text.trim(),
                        password: _passwordController.text.trim(),
                        onMessage: _onMessage,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: const Color(0xFF5A67F2),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                  ),
                  child: state is Authentication$InProgressState
                      ? Center(child: CircularProgressIndicator(color: Colors.white))
                      : const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () {
              context.replace(AppRoutesName.authentication + AppRoutesName.register);
            },
            child: const Text(
              "Don't have an account? Register",
              style: TextStyle(fontSize: 15, color: Color(0xFF4C6EF5)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon,
    bool obscure, {
    void Function()? onDone,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      autocorrect: false,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: const Color(0xFF5A67F2)),
        labelText: label,
        labelStyle: const TextStyle(color: Color(0xFF5A67F2)),
        filled: true,
        fillColor: Colors.white,
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFF5A67F2), width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      autofocus: true,
      onEditingComplete: () {
        onDone?.call();
        FocusScope.of(context).nextFocus();
      },
    );
  }
}
