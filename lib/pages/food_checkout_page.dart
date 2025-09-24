import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_order.dart';
import '../state/food_state.dart';

class FoodCheckoutPage extends StatefulWidget {
  const FoodCheckoutPage({super.key});

  @override
  State<FoodCheckoutPage> createState() => _FoodCheckoutPageState();
}

class _FoodCheckoutPageState extends State<FoodCheckoutPage> {
  String _selectedPaymentMethod = 'Cash';

  @override
  Widget build(BuildContext context) {
    return Consumer<FoodState>(
      builder: (context, foodState, child) {
        final cart = foodState.foodCart;

        return Scaffold(
          backgroundColor: Colors.deepPurple.shade50,
          appBar: PreferredSize(
            preferredSize: const Size.fromHeight(100),
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.deepPurple,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      Icon(Icons.payment, color: Colors.white, size: 32),
                      const SizedBox(width: 16),
                      const Text(
                        "Checkout Makanan",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Summary
                _buildOrderSummary(cart),
                const SizedBox(height: 16),

                // Customer Info
                _buildCustomerInfo(cart),
                const SizedBox(height: 16),

                // Payment Method
                _buildPaymentMethod(),
                const SizedBox(height: 24),

                // Order Button
                _buildOrderButton(foodState),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildOrderSummary(dynamic cart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ringkasan Pesanan',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 16),
          ...cart.items.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(
                    '${item.quantity}x ${item.foodItem.name}',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                Text(
                  item.formattedTotal,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
              ],
            ),
          )),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Pembayaran:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
              Text(
                cart.formattedTotal,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Estimasi Waktu:',
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                cart.estimatedTimeText,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfo(dynamic cart) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Informasi Customer',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 12),
          if (cart.customerName != null)
            Row(
              children: [
                Icon(Icons.person, color: Colors.grey.shade600, size: 20),
                const SizedBox(width: 8),
                Text(
                  cart.customerName!,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          if (cart.tableNumber != null) ...[
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.table_restaurant, color: Colors.grey.shade600, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Meja ${cart.tableNumber}',
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ],
          if (cart.notes != null && cart.notes!.isNotEmpty) ...[
            const SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.note, color: Colors.grey.shade600, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    cart.notes!,
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentMethod() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Metode Pembayaran',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.deepPurple,
            ),
          ),
          const SizedBox(height: 12),
          ...['Cash', 'Transfer', 'E-Wallet'].map((method) => ListTile(
            title: Text(method),
            leading: Radio<String>(
              value: method,
              groupValue: _selectedPaymentMethod,
              onChanged: (value) {
                setState(() {
                  _selectedPaymentMethod = value!;
                });
              },
            ),
            onTap: () {
              setState(() {
                _selectedPaymentMethod = method;
              });
            },
          )),
        ],
      ),
    );
  }

  Widget _buildOrderButton(FoodState foodState) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () => _processOrder(foodState),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.deepPurple,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        child: const Text(
          'Buat Pesanan',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  void _processOrder(FoodState foodState) {
    final cart = foodState.foodCart;

    // Create order items
    final orderItems = cart.items.map((cartItem) => FoodOrderItem(
      foodItem: cartItem.foodItem,
      quantity: cartItem.quantity,
      notes: cartItem.notes,
    )).toList();

    // Create order
    final order = FoodOrder(
      id: foodState.generateOrderId(),
      items: orderItems,
      total: cart.totalAmount,
      customerName: cart.customerName,
      tableNumber: cart.tableNumber,
      notes: cart.notes,
    );

    // Add order to state
    foodState.addFoodOrder(order);

    // Clear cart
    foodState.foodCart.clearCart();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Pesanan berhasil dibuat! ID: ${order.id}'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 3),
      ),
    );

    // Navigate back to menu
    Navigator.of(context).popUntil((route) => route.isFirst);
  }
}
