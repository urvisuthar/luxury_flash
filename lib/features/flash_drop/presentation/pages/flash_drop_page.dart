import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:luxury_flash/features/flash_drop/presentation/bloc/flash_drop_bloc.dart';
import 'package:luxury_flash/features/flash_drop/presentation/widgets/hold_to_buy_button.dart';
import 'package:luxury_flash/features/flash_drop/presentation/widgets/live_chart_painter.dart';

class FlashDropPage extends StatefulWidget {
  final String productId;

  const FlashDropPage({super.key, required this.productId});

  @override
  State<FlashDropPage> createState() => _FlashDropPageState();
}

class _FlashDropPageState extends State<FlashDropPage> {
  @override
  void initState() {
    super.initState();
    context.read<FlashDropBloc>().add(LoadFlashProduct(widget.productId));
  }

  @override
  Widget build(BuildContext context) {
    return const FlashDropView();
  }
}

class FlashDropView extends StatelessWidget {
  const FlashDropView({super.key});

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.simpleCurrency(decimalDigits: 2);

    return Scaffold(
      body: BlocConsumer<FlashDropBloc, FlashDropState>(
        listenWhen: (previous, current) => previous.runtimeType != current.runtimeType,
        listener: (context, state) {
          if (state is FlashDropPurchaseSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Purchase Successful!"), backgroundColor: Colors.green),
            );
          }
          if (state is FlashDropFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.errorMessage), backgroundColor: Colors.red),
            );
          }
        },
        builder: (context, state) {
          if (state is FlashDropInitial || state is FlashDropLoading) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          if (state is FlashDropFailure && state is! FlashDropSuccess) {
             return Center(child: Text(state.errorMessage, style: const TextStyle(color: Colors.white)));
          }

          final dynamic currentState = state;
          final product = currentState.product;
          final slidingWindow = currentState.slidingWindow;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildHeader(),
                  const SizedBox(height: 40),
                  _buildProductInfo(product, currencyFormat),
                  const SizedBox(height: 40),
                  _buildChart(slidingWindow),
                  const SizedBox(height: 24),
                  _buildInventory(product.inventory),
                  const SizedBox(height: 40),
                  _buildBuyButton(context, product.id),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("LUXURY", style: TextStyle(color: Colors.white54, fontSize: 12, letterSpacing: 4)),
            Text("FLASH DROP", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.redAccent.withAlpha(51),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            "LIVE",
            style: TextStyle(color: Colors.redAccent.shade100, fontSize: 12, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget _buildProductInfo(dynamic product, NumberFormat currencyFormat) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          product.name.toUpperCase(),
          style: const TextStyle(color: Colors.white70, fontSize: 14, letterSpacing: 2),
        ),
        const SizedBox(height: 8),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Text(
            currencyFormat.format(product.currentPrice),
            key: ValueKey(product.currentPrice),
            style: const TextStyle(color: Colors.white, fontSize: 40, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  Widget _buildChart(dynamic slidingWindow) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withAlpha(12),
          borderRadius: BorderRadius.circular(24),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: CustomPaint(
            painter: LiveChartPainter(priceHistory: slidingWindow),
            size: Size.infinite,
          ),
        ),
      ),
    );
  }

  Widget _buildInventory(int inventory) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text("AVAILABLE UNITS", style: TextStyle(color: Colors.white38, fontSize: 12)),
        Text("$inventory PIECES", style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildBuyButton(BuildContext context, String productId) {
    return Center(
      child: HoldToBuyButton(
        onTrigger: () {
          context.read<FlashDropBloc>().add(BuyProductRequested(productId));
        },
      ),
    );
  }
}
