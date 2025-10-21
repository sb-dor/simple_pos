import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pos_app/src/common/layout/window_size.dart';
import 'package:test_pos_app/src/common/uikit/text_widget.dart';
import 'package:test_pos_app/src/common/utils/constants/constants.dart';
import 'package:test_pos_app/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';

class MainAppBar extends StatefulWidget {
  const MainAppBar({super.key, required this.label});

  final String label;

  @override
  State<MainAppBar> createState() => _MainAppBarState();
}

class _MainAppBarState extends State<MainAppBar> {
  late final AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context, listen: false);
    _authenticationBloc = dependencies.authenticationBloc;
    if (_authenticationBloc.state is! Authentication$AuthenticatedState) {
      _authenticationBloc.add(
        AuthenticationEvent.checkAuthentication(
          onMessage: (message) {
            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
            }
          },
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      bloc: _authenticationBloc,
      builder: (context, authState) {
        switch (authState) {
          case Authentication$InitialState():
          case Authentication$InProgressState():
          case Authentication$UnauthenticatedState():
            return SizedBox.shrink();
          case Authentication$AuthenticatedState():
            return DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: Constants.appGradientColor),
                color: Colors.white.withValues(alpha: 0.8),
              ),
              child: SafeArea(
                child: Center(
                  child: SizedBox(
                    width: WindowSizeScope.of(context).expandedSize + 200,
                    height: 100,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        children: [
                          ElevatedButton(
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            onPressed: () {
                              Scaffold.of(context).openDrawer();
                            },
                            child: Icon(Icons.menu, color: Colors.black),
                          ),
                          SizedBox(width: 10),
                          Expanded(
                            child: TextWidget(
                              text: widget.label,
                              size: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              letterSpacing: 1.1,
                              maxLines: 1,
                              overFlow: TextOverflow.ellipsis,
                            ),
                          ),
                          CircleAvatar(radius: 20),
                          SizedBox(width: 10),
                          TextWidget(
                            text: authState.stateModel.userModel?.name ?? '',
                            size: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          SizedBox(width: 10),
                          ElevatedButton(
                            style: ButtonStyle(
                              shape: WidgetStatePropertyAll(
                                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                            onPressed: () {},
                            child: Icon(Icons.settings, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
        }
      },
    );
  }
}
