import 'package:flutter/material.dart';
import '../models/shift_keeper.dart';
import '../state/rental_state.dart';

class ShiftKeeperListPage extends StatefulWidget {
  @override
  State<ShiftKeeperListPage> createState() => _ShiftKeeperListPageState();
}

class _ShiftKeeperListPageState extends State<ShiftKeeperListPage> {
  List<ShiftKeeper> _shiftKeepers = [];

  @override
  void initState() {
    super.initState();
    _shiftKeepers = List.from(rentalState.shiftKeepers);
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
              ),
            ],
          ),
          child: const Center(
            child: Text(
              'Daftar Penjaga Shift',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _shiftKeepers.length,
        itemBuilder: (context, index) {
          final keeper = _shiftKeepers[index];
          final isOnShift = keeper.isOnShift(DateTime.now());
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListTile(
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
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Add dialog to add new shift keeper
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }
}
