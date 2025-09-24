import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/food_state.dart';
import 'food_checkout_page.dart';

class FoodCartPage extends StatefulWidget {
  const FoodCartPage({super.key});

  @override
  State<FoodCartPage> createState() => _FoodCartPageState();
}

class _FoodCartPageState extends State<FoodCartPage> {
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _tableNumberController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  @override
  void dispose() {
    _customerNameController.dispose();
    _tableNumberController.dispose();
    _notesController.dispose();
    super.dispose();
  }

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
                      Icon(Icons.shopping_cart, color: Colors.white, size: 32),
                      const SizedBox(width: 16),
                      const Text(
                        "Keranjang Makanan",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                          letterSpacing: 1,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        '${cart.totalQuantity} item(s)',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: cart.isEmpty
              ? _buildEmptyCart()
              : Column(
                  children: [
                    // Customer Info Section
                    Container(
                      margin: const EdgeInsets.all(16),
                      padding: const EdgeInsets.all(16),
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
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.deepPurple,
                            ),
                          ),
                          const SizedBox(height: 12),
                          TextField(
                            controller: _customerNameController,
                            decoration: InputDecoration(
                              labelText: 'Nama Customer (Opsional)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: Icon(Icons.person),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _tableNumberController,
                            decoration: InputDecoration(
                              labelText: 'Nomor Meja (Opsional)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: Icon(Icons.table_restaurant),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _notesController,
                            decoration: InputDecoration(
                              labelText: 'Catatan Khusus (Opsional)',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                              prefixIcon: Icon(Icons.note),
                            ),
                            maxLines: 2,
                          ),
                        ],
                      ),
                    ),

                    // Cart Items
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: cart.items.length,
                        itemBuilder: (context, index) {
                          final cartItem = cart.items[index];
                          return _buildCartItem(cartItem);
                        },
                      ),
                    ),

                    // Bottom Summary
                    _buildCartSummary(cart),
                  ],
                ),
          floatingActionButton: cart.isEmpty
              ? null
              : FloatingActionButton.extended(
                  onPressed: () {
                    // Validate cart before checkout
                    if (cart.items.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Keranjang kosong'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Update cart with customer info
                    cart.setCustomerInfo(
                      customerName: _customerNameController.text.isEmpty
                          ? null
                          : _customerNameController.text,
                      tableNumber: _tableNumberController.text.isEmpty
                          ? null
                          : _tableNumberController.text,
                      notes: _notesController.text.isEmpty
                          ? null
                          : _notesController.text,
                    );

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => FoodCheckoutPage(),
                      ),
                    );
                  },
                  backgroundColor: Colors.deepPurple,
                  icon: Icon(Icons.payment),
                  label: Text('Checkout - ${cart.formattedTotal}'),
                ),
        );
      },
    );
  }

  Widget _buildEmptyCart() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Keranjang Kosong',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tambahkan makanan dari menu',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.deepPurple,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Lihat Menu'),
          ),
        ],
      ),
    );
  }

  Widget _buildCartItem(dynamic cartItem) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Food Icon
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: Colors.deepPurple.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                Icons.fastfood,
                color: Colors.deepPurple,
                size: 30,
              ),
            ),
            const SizedBox(width: 16),

            // Food Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.foodItem.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cartItem.foodItem.formattedPrice,
                    style: TextStyle(
                      color: Colors.deepPurple.shade600,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (cartItem.notes != null && cartItem.notes.isNotEmpty)
                    Text(
                      'Catatan: ${cartItem.notes}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),

            // Quantity Controls
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      context.read<FoodState>().foodCart.decrementQuantity(cartItem.foodItem);
                    });
                  },
                  icon: Icon(Icons.remove_circle_outline),
                  color: Colors.deepPurple,
                ),
                Text(
                  '${cartItem.quantity}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      context.read<FoodState>().foodCart.incrementQuantity(cartItem.foodItem);
                    });
                  },
                  icon: Icon(Icons.add_circle_outline),
                  color: Colors.deepPurple,
                ),
              ],
            ),

            // Remove Button
            IconButton(
              onPressed: () {
                setState(() {
                  context.read<FoodState>().foodCart.removeItem(cartItem.foodItem);
                });
              },
              icon: Icon(Icons.delete_outline),
              color: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCartSummary(dynamic cart) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(24),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Item:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '${cart.totalQuantity} item(s)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
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
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                cart.estimatedTimeText,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple,
                ),
              ),
            ],
          ),
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
        ],
      ),
    );
  }
}
