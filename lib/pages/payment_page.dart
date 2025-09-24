import 'package:flutter/material.dart';

class PaymentPage extends StatelessWidget {
  final List<Map<String, dynamic>> unpaidBookings = [
    {
      "ps": "PS 4 Pro No. 1",
      "date": "10/09/2025",
      "time": "14:00",
      "duration": 2,
      "total": 30000,
      "status": "Belum Dibayar"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[50],
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: Container(
          decoration: const BoxDecoration(
            color: Colors.deepPurple,
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Row(
                children: [
                  Icon(Icons.attach_money, color: Colors.white, size: 32),
                  const SizedBox(width: 16),
                  const Text(
                    "Pembayaran",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24),
        itemCount: unpaidBookings.length,
        itemBuilder: (context, i) {
          final booking = unpaidBookings[i];
          return Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            margin: const EdgeInsets.only(bottom: 18),
            child: ListTile(
              leading: Icon(Icons.sports_esports, color: Colors.deepPurple[400], size: 36),
              title: Text("${booking['ps']} (${booking['date']} ${booking['time']})"),
              subtitle: Text("Durasi: ${booking['duration']} jam\nTotal: Rp ${booking['total']}"),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () {
                  // Proses pembayaran di sini
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Pembayaran berhasil!")),
                  );
                },
                child: const Text("Bayar", style: TextStyle(color: Colors.white)),
              ),
            ),
          );
        },
      ),
    );
  }
}