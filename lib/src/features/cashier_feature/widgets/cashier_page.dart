import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test_pos_app/src/common/constants/constants.dart';
import 'package:test_pos_app/src/common/layout/window_size.dart';
import 'package:test_pos_app/src/common/uikit/circular_progress_indicator_widget.dart';
import 'package:test_pos_app/src/common/uikit/error_button_widget.dart';
import 'package:test_pos_app/src/common/uikit/main_app_bar.dart';
import 'package:test_pos_app/src/common/uikit/main_app_drawer.dart';
import 'package:test_pos_app/src/features/authentication/widgets/authentication_listener.dart';
import 'package:test_pos_app/src/features/cashier_feature/bloc/cashier_feature_bloc.dart';
import 'package:test_pos_app/src/features/cashier_feature/widgets/widgets/cashier_invoice_widget.dart';
import 'package:test_pos_app/src/features/initialization/widgets/dependencies_scope.dart';
import 'package:test_pos_app/src/features/synchronization/widgets/synchronization_listener.dart';

class CashierPage extends StatefulWidget {
  const CashierPage({required this.cashierId, super.key});

  final String cashierId;

  @override
  State<CashierPage> createState() => _CashierPageState();
}

class _CashierPageState extends State<CashierPage> {
  late CashierFeatureBloc _cashierFeatureBloc;

  @override
  void initState() {
    super.initState();
    final dependencies = DependenciesScope.of(context);
    _cashierFeatureBloc = dependencies.cashierFeatureBloc;
    _cashierFeatureBloc.add(const CashierFeatureEvents.initial());
  }

  @override
  Widget build(BuildContext context) => AuthenticationListener(
    child: (context) => SynchronizationListener(
      child: (context) => Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(MediaQuery.of(context).size.width, kToolbarHeight),
          child: const MainAppBar(label: cashier),
        ),
        drawer: const MainAppDrawer(),
        body: DecoratedBox(
          decoration: const BoxDecoration(gradient: LinearGradient(colors: appGradientColor)),
          child: SafeArea(
            child: RefreshIndicator(
              onRefresh: () async => _cashierFeatureBloc.add(const CashierFeatureEvents.initial()),
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
                              return const SizedBox.shrink();
                            case Cashier$InProgressState():
                              return const CircularProgressIndicatorWidget();
                            case Cashier$ErrorState():
                              return ErrorButtonWidget(
                                label: reloadLabel,
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
