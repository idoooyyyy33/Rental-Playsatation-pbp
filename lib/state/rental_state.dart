import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/transaction.dart';
import '../models/booking.dart';
import '../models/shift_keeper.dart';

class RentalState extends ChangeNotifier {
  final List<Booking> bookings = [];
  final Map<String, Transaction> activeTransactions = {};
  final List<Transaction> history = [];
  final List<ShiftKeeper> shiftKeepers = [];

  RentalState() {
    _initializeShiftKeepers();
    _loadData();
  }

  void _initializeShiftKeepers() {
    if (shiftKeepers.isEmpty) {
      shiftKeepers.addAll([
        ShiftKeeper(
          name: 'Ahmad',
          startShift: DateTime.now().subtract(Duration(hours: 2)),
          endShift: DateTime.now().add(Duration(hours: 4)),
          psAssigned: 'PS 5 No. 1',
        ),
        ShiftKeeper(
          name: 'Budi',
          startShift: DateTime.now().add(Duration(hours: 2)),
          endShift: DateTime.now().add(Duration(hours: 10)),
          psAssigned: 'PS 4 Pro No. 1',
        ),
        ShiftKeeper(
          name: 'Cici',
          startShift: DateTime.now().subtract(Duration(hours: 4)),
          endShift: DateTime.now().add(Duration(hours: 2)),
          psAssigned: 'PS 3 No. 1',
        ),
      ]);
    }
  }

  Future<void> _loadData() async {
    final prefs = await SharedPreferences.getInstance();
    final bookingsString = prefs.getString('bookings');
    if (bookingsString != null) {
      final List<dynamic> decoded = jsonDecode(bookingsString);
      bookings.clear();
      bookings.addAll(decoded.map((e) => Booking.fromJson(e)));
    }
    final historyString = prefs.getString('history');
    if (historyString != null) {
      final List<dynamic> decoded = jsonDecode(historyString);
      history.clear();
      history.addAll(decoded.map((e) => Transaction.fromJson(e)));
    }
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final bookingsString = jsonEncode(bookings.map((b) => b.toJson()).toList());
    await prefs.setString('bookings', bookingsString);
    final historyString = jsonEncode(history.map((t) => t.toJson()).toList());
    await prefs.setString('history', historyString);
  }

  bool isBooked(String psName, DateTime dateTime) {
    return bookings.any((b) => b.psName == psName && b.dateTime == dateTime);
  }

  void addBooking(String psName, DateTime dateTime) {
    if (!isBooked(psName, dateTime)) {
      bookings.add(Booking(psName: psName, dateTime: dateTime));
      _saveData();
      notifyListeners();
    }
  }

  void removeBooking(Booking booking) {
    bookings.remove(booking);
    _saveData();
    notifyListeners();
  }

  void start(String psName, int pricePerHour, {int? paketJam}) {
    if (activeTransactions.containsKey(psName)) return;
    final trx = Transaction(
      psName: psName,
      pricePerHour: pricePerHour,
      startTime: DateTime.now(),
      paketJam: paketJam,
      foodOrders: [],
      foodTotal: 0,
      combinedTotal: 0,
    );
    activeTransactions[psName] = trx;
    if (paketJam != null) {
      Future.delayed(Duration(hours: paketJam), () {
        if (activeTransactions[psName] != null && activeTransactions[psName]!.paketJam == paketJam && activeTransactions[psName]!.endTime == null) {
          stop(psName);
        }
      });
    }
    notifyListeners();
  }

  void stop(String psName) {
    final trx = activeTransactions[psName];
    if (trx != null && trx.endTime == null) {
      final updatedTrx = trx.copyWith(
        endTime: DateTime.now(),
      );
      final duration = updatedTrx.endTime!.difference(updatedTrx.startTime);
      final menit = duration.inMinutes;
      final rentalTotal = (menit * updatedTrx.pricePerHour / 60).round().toDouble();
      final combinedTotal = rentalTotal + updatedTrx.foodTotal;

      final finalTrx = updatedTrx.copyWith(
        total: rentalTotal,
        combinedTotal: combinedTotal,
      );
      history.insert(0, finalTrx);
      activeTransactions.remove(psName);
      _saveData();
      notifyListeners();
    }
  }




}

final rentalState = RentalState();
