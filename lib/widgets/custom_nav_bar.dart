import 'package:flutter/material.dart';

class CustomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;
  const CustomNavBar({super.key, required this.currentIndex, required this.onTap});

  static const _icons = [
    Icons.sports_esports, // Daftar PS
    Icons.event_note,     // Booking
    Icons.restaurant,     // Food Menu
    Icons.attach_money,   // Pembayaran
    Icons.history_edu,    // Riwayat
    Icons.account_circle, // Profil
    Icons.security,       // Penjaga
  ];
  static const _labels = [
    'Daftar PS', 'Booking', 'Food', 'Pembayaran', 'Riwayat', 'Profil', 'Penjaga'
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        boxShadow: [
          BoxShadow(
            color: Colors.deepPurple.withOpacity(0.08),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_icons.length, (i) {
          final selected = i == currentIndex;
          return GestureDetector(
            onTap: () => onTap(i),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutBack,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: selected ? Colors.deepPurple.withOpacity(0.12) : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                boxShadow: selected
                    ? [
                        BoxShadow(
                          color: Colors.deepPurple.withOpacity(0.18),
                          blurRadius: 16,
                          offset: const Offset(0, 4),
                        ),
                      ]
                    : [],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    curve: Curves.easeOutBack,
                    width: selected ? 34 : 26,
                    height: selected ? 34 : 26,
                    child: Icon(
                      _icons[i],
                      color: selected ? Colors.deepPurple : Colors.grey[700]!,
                      size: selected ? 30 : 24,
                    ),
                  ),
                  const SizedBox(height: 2),
                  AnimatedDefaultTextStyle(
                    duration: const Duration(milliseconds: 250),
                    style: TextStyle(
                      color: selected ? Colors.deepPurple : Colors.grey[700] ?? Colors.grey,
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                      fontSize: selected ? 13 : 12,
                    ),
                    child: Text(_labels[i]),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}