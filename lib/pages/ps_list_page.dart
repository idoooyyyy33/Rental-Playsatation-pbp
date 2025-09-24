import 'package:flutter/material.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../state/ui_state.dart';
import '../models/ps.dart';
import 'ps_detail_page.dart';

class PSListPage extends StatefulWidget {
  const PSListPage({super.key});

  @override
  State<PSListPage> createState() => _PSListPageState();
}

class _PSListPageState extends State<PSListPage> with WidgetsBindingObserver {
  // Default PS list - will be loaded from storage if available
  final List<PS> _defaultPSList = [
    PS(name: "PS 4 Pro No. 1", pricePerHour: 15000),
    PS(name: "PS 4 Pro No. 2", pricePerHour: 15000),
    PS(name: "PS 5 No. 1", pricePerHour: 20000),
    PS(name: "PS 5 No. 2", pricePerHour: 20000),
    PS(name: "PS 5 No. 3", pricePerHour: 20000),
    PS(name: "PS 4 Slim No. 1", pricePerHour: 12000),
    PS(name: "PS 4 Slim No. 2", pricePerHour: 12000),
    PS(name: "PS 3 No. 1", pricePerHour: 9000),
    PS(name: "PS 3 No. 2", pricePerHour: 9000),
  ];

  late List<PS> _psList;
  Timer? _timer;
  bool _isLoading = true;
  String? _errorMessage;

  // Timer state
  int _currentSeconds = 0;
  bool _isOpenTimer = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _psList = List.from(_defaultPSList);
    _initializeData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _stopTimer();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Pause timer when app is backgrounded
    if (state == AppLifecycleState.paused) {
      _timer?.cancel();
    } else if (state == AppLifecycleState.resumed && _isTimerActive()) {
      _resumeTimer();
    }
  }

  Future<void> _initializeData() async {
    try {
      setState(() => _isLoading = true);
      await _loadPSData();
      _syncWithUIState();
    } catch (e) {
      setState(() => _errorMessage = 'Gagal memuat data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _syncWithUIState() {
    // Sync timer state from UI state
    if (mounted) {
      setState(() {
        _currentSeconds = uiState.timerSeconds;
      });
    }
  }

  bool _isTimerActive() {
    return uiState.selectedPSIndex != null && _currentSeconds > 0;
  }

  void _resumeTimer() {
    if (_isTimerActive()) {
      _startTimerInternal(isOpenTimer: _isOpenTimer);
    }
  }

  void _startTimerInternal({bool isOpenTimer = false, int? minutes}) {
    _currentSeconds = 0;
    _isOpenTimer = isOpenTimer;
    _timer?.cancel();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      setState(() {
        _currentSeconds++;
        uiState.setTimerSeconds(_currentSeconds);

        // Auto-stop for timed sessions
        if (!isOpenTimer && minutes != null && _currentSeconds >= (minutes * 60)) {
          _stopTimer();
        }
      });
    });
  }

  void _startTimer({int? minutes}) {
    final selectedIndex = uiState.selectedPSIndex;
    if (selectedIndex == null) return;

    _startTimerInternal(
      isOpenTimer: minutes == null,
      minutes: minutes,
    );
  }

  void _stopTimer() {
    final selectedIndex = uiState.selectedPSIndex;
    if (selectedIndex == null) return;

    _timer?.cancel();

    if (mounted) {
      setState(() {
        final price = _psList[selectedIndex].pricePerHour;
        final total = ((_currentSeconds / 3600) * price).ceil();

        uiState.setSelectedPSIndex(null);
        uiState.setTimerSeconds(0);
        _currentSeconds = 0;
        _isOpenTimer = false;

        // Show payment dialog
        _showPaymentDialog(total);
      });
    }
  }

  void _showPaymentDialog(int total) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text("Total Pembayaran"),
        content: Text("Total: Rp ${total.toString()}"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("OK"),
          )
        ],
      ),
    );
  }

  Future<void> _loadPSData() async {
    final prefs = await SharedPreferences.getInstance();
    final psListString = prefs.getString('psList');
    if (psListString != null) {
      final List<dynamic> decoded = jsonDecode(psListString);
      setState(() {
        _psList = decoded.map((e) => PS.fromJson(e as Map<String, dynamic>)).toList();
      });
    }
  }

  Future<void> _savePSData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('psList', jsonEncode(_psList.map((ps) => ps.toJson()).toList()));
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
          backgroundColor: Colors.red,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_errorMessage!),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _initializeData,
                child: const Text('Coba Lagi'),
              ),
            ],
          ),
        ),
      );
    }

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
                  Icon(Icons.sports_esports, color: Colors.white, size: 32),
                  const SizedBox(width: 16),
                  Text(
                    "Daftar PS",
                    style: const TextStyle(
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
        padding: const EdgeInsets.all(16),
        itemCount: _psList.length,
        itemBuilder: (context, index) {
          final isSelected = uiState.selectedPSIndex == index;

          return Card(
            elevation: 6,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PSDetailPage(
                      ps: _psList[index],
                      index: index,
                    ),
                  ),
                );
              },
              leading: Icon(
                Icons.videogame_asset,
                color: isSelected ? Colors.green : Colors.deepPurple.shade400,
                size: 36,
              ),
              title: Text(
                _psList[index].name,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                "Rp ${_psList[index].pricePerHour}/jam",
                style: TextStyle(color: Colors.deepPurple.shade700),
              ),
              trailing: isSelected
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "${(_currentSeconds ~/ 3600).toString().padLeft(2, '0')}:${((_currentSeconds % 3600) ~/ 60).toString().padLeft(2, '0')}:${(_currentSeconds % 60).toString().padLeft(2, '0')}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        ElevatedButton(
                          onPressed: _stopTimer,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                          child: const Text("Selesai", style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    )
                  : PopupMenuButton<String>(
                      onSelected: (value) {
                        uiState.setSelectedPSIndex(index);
                        if (value == "Open Timer") {
                          _startTimer();
                        } else {
                          int jam = int.parse(value);
                          _startTimer(minutes: jam * 60);
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: "Open Timer", child: Text("Open Timer")),
                        const PopupMenuItem(value: "1", child: Text("1 Jam")),
                        const PopupMenuItem(value: "2", child: Text("2 Jam")),
                        const PopupMenuItem(value: "3", child: Text("3 Jam")),
                      ],
                      child: ElevatedButton(
                        onPressed: null,
                        child: const Text("Mulai"),
                      ),
                    ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddPSDialog(context),
        child: const Icon(Icons.add),
        backgroundColor: Colors.deepPurple,
      ),
    );
  }

  void _showAddPSDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String? selectedPS;
        String hargaPS = "";
        String nomorPS = "";
        List<String> psOptions = ["PS 3", "PS 4", "PS 5"];
        Map<String, int> defaultPrices = {
          "PS 3": 7000,
          "PS 4": 9000,
          "PS 5": 12000,
        };

        return AlertDialog(
          title: const Text("Tambah PS Baru"),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                    labelText: "Pilih PS",
                  ),
                  items: psOptions.map((ps) {
                    return DropdownMenuItem<String>(
                      value: ps,
                      child: Text(ps),
                    );
                  }).toList(),
                  onChanged: (value) {
                    selectedPS = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Harga PS (per jam)",
                    hintText: "Masukkan harga PS",
                  ),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    hargaPS = value;
                  },
                ),
                TextField(
                  decoration: const InputDecoration(
                    labelText: "Nomor PS",
                    hintText: "Masukkan nomor PS",
                  ),
                  keyboardType: TextInputType.text,
                  onChanged: (value) {
                    nomorPS = value;
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal"),
            ),
            ElevatedButton(
              onPressed: () async {
                if (selectedPS != null && nomorPS.trim().isNotEmpty) {
                  try {
                    int price = hargaPS.trim().isEmpty
                        ? defaultPrices[selectedPS!]!
                        : int.tryParse(hargaPS.trim()) ?? defaultPrices[selectedPS!]!;

                    String newPSName = "$selectedPS No. ${nomorPS.trim()}";
                    PS newPS = PS(name: newPSName, pricePerHour: price);

                    if (!_psList.any((ps) => ps.name == newPSName)) {
                      setState(() {
                        _psList.add(newPS);
                      });
                      await _savePSData();

                      if (mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('PS berhasil ditambahkan')),
                        );
                      }
                    } else {
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('PS dengan nama tersebut sudah ada')),
                        );
                      }
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                }
              },
              child: const Text("Tambah"),
            ),
          ],
        );
      },
    );
  }


}
