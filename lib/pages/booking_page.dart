import 'package:flutter/material.dart';
import '../state/rental_state.dart';

class BookingPage extends StatefulWidget {
  @override
  State<BookingPage> createState() => _BookingPageState();
}

class _BookingPageState extends State<BookingPage> {
  String? selectedPS;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  int duration = 1;
  String? errorMessage;

  final List<String> psList = [
    "PS 4 Pro No. 1",
    "PS 4 Pro No. 2",
    "PS 5 No. 1",
    "PS 5 No. 2",
    "PS 5 No. 3",
    "PS 4 Slim No. 1",
    "PS 4 Slim No. 2",
    "PS 3 No. 1",
    "PS 3 No. 2",
  ];

  bool isBooked(String psName, DateTime dateTime) {
    return rentalState.isBooked(psName, dateTime);
  }

  void _submitBooking() {
    if (selectedPS == null || selectedDate == null || selectedTime == null) {
      setState(() {
        errorMessage = "Semua field harus diisi.";
      });
      return;
    }

    final bookingDateTime = DateTime(
      selectedDate!.year,
      selectedDate!.month,
      selectedDate!.day,
      selectedTime!.hour,
      selectedTime!.minute,
    );

    if (isBooked(selectedPS!, bookingDateTime)) {
      setState(() {
        errorMessage = "PS sudah dibooking pada waktu tersebut.";
      });
      return;
    }

    rentalState.addBooking(selectedPS!, bookingDateTime);
    setState(() {
      errorMessage = null;
      selectedPS = null;
      selectedDate = null;
      selectedTime = null;
      duration = 1;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Booking berhasil!")),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  Icon(Icons.event_note, color: Colors.white, size: 32),
                  const SizedBox(width: 16),
                  const Text(
                    "Booking",
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
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          children: [
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(labelText: "Pilih PS"),
              initialValue: selectedPS,
              items: psList.map((ps) {
                final disabled = selectedDate != null && isBooked(ps, DateTime(
                  selectedDate!.year,
                  selectedDate!.month,
                  selectedDate!.day,
                  selectedTime?.hour ?? 0,
                  selectedTime?.minute ?? 0,
                ));
                return DropdownMenuItem(
                  value: disabled ? null : ps,
                  enabled: !disabled,
                  child: Text(
                    ps + (disabled ? " (Sudah dibooking)" : ""),
                    style: TextStyle(color: disabled ? Colors.grey : Colors.black),
                  ),
                );
              }).toList(),
              onChanged: (val) => setState(() => selectedPS = val),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: Text(selectedDate == null
                  ? "Pilih Tanggal"
                  : "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"),
              trailing: const Icon(Icons.calendar_today),
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 30)),
                );
                if (picked != null) setState(() => selectedDate = picked);
              },
            ),
            ListTile(
              title: Text(selectedTime == null
                  ? "Pilih Jam Mulai"
                  : "${selectedTime!.hour}:${selectedTime!.minute.toString().padLeft(2, '0')}"),
              trailing: const Icon(Icons.access_time),
              onTap: () async {
                final picked = await showTimePicker(
                  context: context,
                  initialTime: selectedTime ?? TimeOfDay.now(),
                );
                if (picked != null) setState(() => selectedTime = picked);
              },
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text("Durasi (jam):"),
                const SizedBox(width: 16),
                DropdownButton<int>(
                  value: duration,
                  items: [1, 2, 3, 4].map((d) => DropdownMenuItem(value: d, child: Text("$d"))).toList(),
                  onChanged: (val) => setState(() => duration = val!),
                ),
              ],
            ),
            if (errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(errorMessage!, style: const TextStyle(color: Colors.red)),
            ],
            const Spacer(),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                minimumSize: const Size.fromHeight(48),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
              ),
              onPressed: _submitBooking,
              child: const Text("Booking Sekarang", style: TextStyle(fontSize: 18, color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
