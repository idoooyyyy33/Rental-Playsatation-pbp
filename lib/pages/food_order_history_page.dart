import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_order.dart';
import '../state/food_state.dart';

class FoodOrderHistoryPage extends StatefulWidget {
  const FoodOrderHistoryPage({super.key});

  @override
  State<FoodOrderHistoryPage> createState() => _FoodOrderHistoryPageState();
}

class _FoodOrderHistoryPageState extends State<FoodOrderHistoryPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<FoodState>(
      builder: (context, foodState, child) {
        final orders = foodState.foodOrders;

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
                      Icon(Icons.history, color: Colors.white, size: 32),
                      const SizedBox(width: 16),
                      const Text(
                        "Riwayat Pesanan",
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
          body: orders.isEmpty
              ? _buildEmptyHistory()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: orders.length,
                  itemBuilder: (context, index) {
                    final order = orders[index];
                    return _buildOrderCard(order);
                  },
                ),
        );
      },
    );
  }

  Widget _buildEmptyHistory() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.history,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Belum ada pesanan',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Pesanan makanan akan muncul di sini',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderCard(FoodOrder order) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                    color: Colors.deepPurple,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: order.statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    order.statusText,
                    style: TextStyle(
                      color: order.statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Order Time
            Text(
              'Dipesan: ${order.orderTime.toString().substring(0, 16)}',
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 12),

            // Customer Info
            if (order.customerName != null || order.tableNumber != null)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (order.customerName != null)
                      Text(
                        'Customer: ${order.customerName}',
                        style: TextStyle(fontSize: 12),
                      ),
                    if (order.tableNumber != null)
                      Text(
                        'Meja: ${order.tableNumber}',
                        style: TextStyle(fontSize: 12),
                      ),
                  ],
                ),
              ),
            const SizedBox(height: 12),

            // Order Items
            ...order.items.map((item) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '${item.quantity}x ${item.foodItem.name}',
                      style: TextStyle(fontSize: 14),
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
            const Divider(height: 16),

            // Order Total and Notes
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ${order.formattedTotal}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple,
                  ),
                ),
                if (order.notes != null && order.notes!.isNotEmpty)
                  Expanded(
                    child: Text(
                      'Catatan: ${order.notes}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.right,
                    ),
                  ),
              ],
            ),

            // Estimated wait time for pending orders
            if (order.status == OrderStatus.pending && order.estimatedWaitTime > 0)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  'Estimasi: ${order.estimatedWaitTime} menit',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
