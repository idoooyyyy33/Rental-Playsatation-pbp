import 'package:flutter/material.dart';
import '../models/shift_keeper.dart';

class ShiftKeeperDetailPage extends StatelessWidget {
  final ShiftKeeper shiftKeeper;
  final int index;

  const ShiftKeeperDetailPage({super.key, required this.shiftKeeper, required this.index});

  @override
  Widget build(BuildContext context) {
    final isOnShift = shiftKeeper.isOnShift(DateTime.now());
    final now = DateTime.now();
    final remainingTime = shiftKeeper.endShift.difference(now);
    final hoursRemaining = remainingTime.inHours;
    final minutesRemaining = (remainingTime.inMinutes % 60);

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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          shiftKeeper.name,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            letterSpacing: 1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Detail Penjaga Shift",
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.8),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: isOnShift ? Colors.green : Colors.grey,
                    child: Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    shiftKeeper.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: isOnShift ? Colors.green.shade100 : Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isOnShift ? Colors.green.shade300 : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      isOnShift ? "Sedang Bertugas" : "Tidak Bertugas",
                      style: TextStyle(
                        color: isOnShift ? Colors.green.shade800 : Colors.grey.shade800,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Shift Information Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.schedule,
                          color: Colors.deepPurple.shade400,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Informasi Shift",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _buildInfoRow("PS yang Dijaga", shiftKeeper.psAssigned),
                    const SizedBox(height: 16),
                    _buildInfoRow("Waktu Mulai", "${shiftKeeper.startShift.hour.toString().padLeft(2, '0')}:${shiftKeeper.startShift.minute.toString().padLeft(2, '0')}"),
                    const SizedBox(height: 16),
                    _buildInfoRow("Waktu Selesai", "${shiftKeeper.endShift.hour.toString().padLeft(2, '0')}:${shiftKeeper.endShift.minute.toString().padLeft(2, '0')}"),
                    const SizedBox(height: 16),
                    _buildInfoRow("Durasi Shift", "${shiftKeeper.endShift.difference(shiftKeeper.startShift).inHours} jam"),
                    if (isOnShift) ...[
                      const SizedBox(height: 16),
                      _buildInfoRow("Sisa Waktu", "$hoursRemaining jam $minutesRemaining menit"),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),

            // Status Card
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isOnShift ? Icons.check_circle : Icons.cancel,
                          color: isOnShift ? Colors.green.shade600 : Colors.red.shade600,
                          size: 24,
                        ),
                        const SizedBox(width: 12),
                        Text(
                          "Status Saat Ini",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple.shade700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: isOnShift ? Colors.green.shade50 : Colors.red.shade50,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: isOnShift ? Colors.green.shade200 : Colors.red.shade200,
                        ),
                      ),
                      child: Column(
                        children: [
                          Text(
                            isOnShift ? "Penjaga sedang bertugas" : "Penjaga tidak sedang bertugas",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: isOnShift ? Colors.green.shade800 : Colors.red.shade800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            isOnShift
                                ? "Penjaga akan selesai shift dalam $hoursRemaining jam $minutesRemaining menit"
                                : "Penjaga akan mulai shift pada ${shiftKeeper.startShift.day}/${shiftKeeper.startShift.month}/${shiftKeeper.startShift.year} pukul ${shiftKeeper.startShift.hour.toString().padLeft(2, '0')}:${shiftKeeper.startShift.minute.toString().padLeft(2, '0')}",
                            style: TextStyle(
                              color: isOnShift ? Colors.green.shade700 : Colors.red.shade700,
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Add contact functionality
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Fitur kontak penjaga akan segera hadir"),
                          backgroundColor: Colors.deepPurple,
                        ),
                      );
                    },
                    icon: const Icon(Icons.phone),
                    label: const Text("Hubungi"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                    label: const Text("Kembali"),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.deepPurple,
                      side: const BorderSide(color: Colors.deepPurple),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 120,
          child: Text(
            "$label:",
            style: TextStyle(
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
