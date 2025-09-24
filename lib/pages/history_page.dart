import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> history = [
    {
      "ps": "PS 4 Pro No. 1",
      "date": "09/09/2025",
      "time": "13:00",
      "duration": 2,
      "total": 30000,
      "status": "Lunas"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
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
                  Icon(Icons.history_edu, color: Colors.white, size: 32),
                  const SizedBox(width: 16),
                  const Text(
                    "Riwayat",
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
        itemCount: history.length,
        itemBuilder: (context, i) {
          final item = history[i];
          return Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            margin: const EdgeInsets.only(bottom: 18),
            child: ListTile(
              leading: Icon(Icons.sports_esports, color: Colors.deepPurple.shade400, size: 36),
              title: Text("${item['ps']} (${item['date']} ${item['time']})"),
              subtitle: Text("Durasi: ${item['duration']} jam\nTotal: Rp ${item['total']}"),
              trailing: Chip(
                label: Text(item['status'], style: const TextStyle(color: Colors.white)),
                backgroundColor: Colors.green,
              ),
            ),
          );
        },
      ),
    );
  }
}
