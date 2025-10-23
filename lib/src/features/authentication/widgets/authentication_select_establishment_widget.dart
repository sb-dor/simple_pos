import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:test_pos_app/src/common/layout/window_size.dart';
import 'package:test_pos_app/src/common/uikit/text_widget.dart';
import 'package:test_pos_app/src/common/utils/constants/constants.dart';
import 'package:test_pos_app/src/common/utils/router/app_router.dart';
import 'package:test_pos_app/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';

class AuthenticationSelectEstablishmentWidget extends StatefulWidget {
  const AuthenticationSelectEstablishmentWidget({super.key});

  @override
  State<AuthenticationSelectEstablishmentWidget> createState() =>
      _AuthenticationSelectEstablishmentWidgetState();
}

class _AuthenticationSelectEstablishmentWidgetState
    extends State<AuthenticationSelectEstablishmentWidget> {
  late final AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    _authenticationBloc = DependenciesScope.of(context, listen: false).authenticationBloc;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: SizedBox.shrink(),
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
          expanded: () => _else(context),
          compact: () => Padding(padding: const EdgeInsets.all(16.0), child: _compact(context)),
          medium: () => Padding(padding: const EdgeInsets.all(16.0), child: _compact(context)),
        ),
      ),
    );
  }

  Widget _compact(BuildContext context) {
    return Center(child: SingleChildScrollView(child: _establishmentListCard(context)));
  }

  Widget _else(BuildContext context, {int dividedBy = 2}) {
    return Align(
      alignment: Alignment.center,
      child: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width / dividedBy,
          child: _establishmentListCard(context),
        ),
      ),
    );
  }

  Widget _establishmentListCard(BuildContext context) {
    return BlocConsumer<AuthenticationBloc, AuthenticationState>(
      bloc: _authenticationBloc,
      listener: (context, state) {
        if (state is Authentication$AuthenticatedState && state.stateModel.establishment != null) {
          context.go(AppRoutesName.orderTables);
        }
      },
      builder: (context, state) {
        final currentStateModel = state.stateModel;
        final establishments = currentStateModel.allUserEstablishments ?? [];

        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.95),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(color: Colors.black12, blurRadius: 20, offset: const Offset(0, 10)),
            ],
          ),
          child: Column(
            children: [
              const TextWidget(
                text: "Choose Your Establishment 🏪",
                textAlign: TextAlign.center,
                fontWeight: FontWeight.bold,
                size: 22,
              ),
              const SizedBox(height: 10),
              const Text(
                "Select one of your stores to continue",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 24),

              if (establishments.isEmpty)
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    "No establishments found.",
                    style: TextStyle(color: Colors.black54, fontSize: 16),
                  ),
                )
              else
                ListView.separated(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: establishments.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  padding: EdgeInsets.zero,
                  itemBuilder: (context, index) {
                    final establishment = establishments[index];
                    return InkWell(
                      onTap: () {
                        _authenticationBloc.add(
                          AuthenticationEvent.selectEstablishment(establishment: establishment),
                        );
                      },
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFFCBD5E1)),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.storefront, color: Color(0xFF5A67F2), size: 28),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    establishment.name ?? "Unnamed",
                                    style: const TextStyle(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w600,
                                      color: Color(0xFF1E293B),
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    "ID: ${establishment.id ?? 'N/A'}",
                                    style: const TextStyle(color: Colors.black54, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.arrow_forward_ios, size: 16, color: Color(0xFF94A3B8)),
                          ],
                        ),
                      ),
                    );
                  },
                ),

              const SizedBox(height: 24),
              TextButton(
                onPressed: () {
                  context.replace(AppRoutesName.authentication + AppRoutesName.login);
                },
                child: const Text(
                  "Back to Login",
                  style: TextStyle(fontSize: 15, color: Color(0xFF4C6EF5)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
