import 'package:flutter/material.dart';

class UIState extends ChangeNotifier {
  // Fields for UI state persistence
  int timerSeconds = 0;
  int? selectedPSIndex;
  String? selectedPSName;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  // Setters for UI state with notifyListeners
  void setTimerSeconds(int seconds) {
    timerSeconds = seconds;
    notifyListeners();
  }

  void setSelectedPSIndex(int? index) {
    selectedPSIndex = index;
    notifyListeners();
  }

  void setSelectedPSName(String? name) {
    selectedPSName = name;
    notifyListeners();
  }

  void setSelectedDate(DateTime? date) {
    selectedDate = date;
    notifyListeners();
  }

  void setSelectedTime(TimeOfDay? time) {
    selectedTime = time;
    notifyListeners();
  }
}

final uiState = UIState();
