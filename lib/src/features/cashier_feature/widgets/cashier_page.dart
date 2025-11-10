import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pos_app/src/common/layout/window_size.dart';
import 'package:test_pos_app/src/common/uikit/circular_progress_indicator_widget.dart';
import 'package:test_pos_app/src/common/uikit/error_button_widget.dart';
import 'package:test_pos_app/src/common/uikit/main_app_bar.dart';
import 'package:test_pos_app/src/common/utils/constants/constants.dart';
import 'package:test_pos_app/src/common/uikit/main_app_drawer.dart';
import 'package:test_pos_app/src/features/authentication/bloc/authentication_bloc.dart';
import 'package:test_pos_app/src/features/authentication/widgets/authentication_listener.dart';
import 'package:test_pos_app/src/features/cashier_feature/bloc/cashier_feature_bloc.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:test_pos_app/src/features/synchronization/widgets/synchronization_listener.dart';
import 'widgets/cashier_invoice_widget.dart';

class CashierPage extends StatefulWidget {
  const CashierPage({super.key, required this.cashierId});

  final String cashierId;

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  late CashierFeatureBloc _cashierFeatureBloc;
  late final AuthenticationBloc _authenticationBloc;

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context, listen: false);
    _cashierFeatureBloc = dependencies.cashierFeatureBloc;
    _authenticationBloc = dependencies.authenticationBloc;
    _cashierFeatureBloc.add(CashierFeatureEvents.initial());
  }

  @override
  Widget build(BuildContext context) {
    return AuthenticationListener(
      child: (context) => SynchronizationListener(
        child: (context) => Scaffold(
          appBar: PreferredSize(
            preferredSize: Size(MediaQuery.of(context).size.width, kToolbarHeight),
            child: MainAppBar(label: Constants.cashier),
          ),
          drawer: const MainAppDrawer(),
          body: DecoratedBox(
            decoration: BoxDecoration(gradient: LinearGradient(colors: Constants.appGradientColor)),
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: () async => _cashierFeatureBloc.add(CashierFeatureEvents.initial()),
                child: Center(
                  child: SizedBox(
                    width: WindowSizeScope.of(context).expandedSize,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8),
                      children: [
                        BlocBuilder<CashierFeatureBloc, CashierFeatureStates>(
                          bloc: _cashierFeatureBloc,
                          builder: (context, state) {
                            switch (state) {
                              case Cashier$InititalState():
                                return SizedBox.shrink();
                              case Cashier$InProgressState():
                                return CircularProgressIndicatorWidget();
                              case Cashier$ErrorState():
                                return ErrorButtonWidget(
                                  label: Constants.reloadLabel,
                                  onTap: () {
                                    //
                                  },
                                );
                              case Cashier$CompletedState():
                                final currentStateModel = state.cashierFeatureStateModel;
                                return ListView.separated(
                                  separatorBuilder: (context, index) => const SizedBox(height: 20),
                                  shrinkWrap: true,
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount: currentStateModel.invoices.length,
                                  itemBuilder: (context, index) {
                                    final invoice = currentStateModel.invoices[index];
                                    return CashierInvoiceWidget(customerInvoice: invoice);
                                  },
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
          ),
        ),
      ),
    );
  }
}
