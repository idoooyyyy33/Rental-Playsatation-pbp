import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/shift_keeper.dart';
import '../state/rental_state.dart';
import 'shift_keeper_detail_page.dart';

class TestShiftKeeperPage extends StatefulWidget {
  @override
  State<TestShiftKeeperPage> createState() => _TestShiftKeeperPageState();
}

class _TestShiftKeeperPageState extends State<TestShiftKeeperPage> {
  late RentalState _rentalState;

  @override
  void initState() {
    super.initState();
    _rentalState = Provider.of<RentalState>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Shift Keeper'),
        backgroundColor: Colors.deepPurple,
      ),
      body: Consumer<RentalState>(
        builder: (context, rentalState, child) {
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: rentalState.shiftKeepers.length,
            itemBuilder: (context, index) {
              final keeper = rentalState.shiftKeepers[index];
              final isOnShift = keeper.isOnShift(DateTime.now());
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: ListTile(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ShiftKeeperDetailPage(
                          shiftKeeper: keeper,
                          index: index,
                        ),
                      ),
                    );
                  },
                  leading: CircleAvatar(
                    backgroundColor: isOnShift ? Colors.green : Colors.grey,
                    child: Icon(
                      Icons.person,
                      color: Colors.white,
                    ),
                  ),
                  title: Text(
                    keeper.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${keeper.getSummary()}\nStatus: ${isOnShift ? 'Sedang Bertugas' : 'Tidak Bertugas'}',
                  ),
                  isThreeLine: true,
                  trailing: Icon(
                    Icons.arrow_forward_ios,
                    color: Colors.grey.shade400,
                    size: 16,
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddShiftKeeperDialog(context),
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  void _showAddShiftKeeperDialog(BuildContext context) {
    final nameController = TextEditingController();
    final psController = TextEditingController();
    TimeOfDay startTime = TimeOfDay.now();
    TimeOfDay endTime = TimeOfDay.now().replacing(hour: TimeOfDay.now().hour + 8);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambah Penjaga Shift'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Nama Penjaga',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: psController,
                  decoration: const InputDecoration(
                    labelText: 'PS yang Dijaga',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  title: const Text('Waktu Mulai'),
                  subtitle: Text(startTime.format(context)),
                  trailing: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: startTime,
                      );
                      if (picked != null) {
                        setState(() {
                          startTime = picked;
                        });
                      }
                    },
                  ),
                ),
                ListTile(
                  title: const Text('Waktu Selesai'),
                  subtitle: Text(endTime.format(context)),
                  trailing: IconButton(
                    icon: const Icon(Icons.access_time),
                    onPressed: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: endTime,
                      );
                      if (picked != null) {
                        setState(() {
                          endTime = picked;
                        });
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty && psController.text.isNotEmpty) {
                  final now = DateTime.now();
                  final startDateTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    startTime.hour,
                    startTime.minute,
                  );
                  final endDateTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    endTime.hour,
                    endTime.minute,
                  );

                  final newShiftKeeper = ShiftKeeper(
                    name: nameController.text,
                    startShift: startDateTime,
                    endShift: endDateTime,
                    psAssigned: psController.text,
                  );

                  _rentalState.shiftKeepers.add(newShiftKeeper);
                  _rentalState.notifyListeners();

                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Penjaga shift berhasil ditambahkan'),
                      backgroundColor: Colors.green,
                    ),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                foregroundColor: Colors.white,
              ),
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
