import 'package:flutter/material.dart';

enum PaymentMethod {
  cash,
  bankTransfer,
  gopay,
  ovo,
  dana,
  creditCard,
}

extension PaymentMethodExtension on PaymentMethod {
  String get name {
    switch (this) {
      case PaymentMethod.cash:
        return 'Tunai';
      case PaymentMethod.bankTransfer:
        return 'Transfer Bank';
      case PaymentMethod.gopay:
        return 'GoPay';
      case PaymentMethod.ovo:
        return 'OVO';
      case PaymentMethod.dana:
        return 'DANA';
      case PaymentMethod.creditCard:
        return 'Kartu Kredit';
    }
  }

  String get description {
    switch (this) {
      case PaymentMethod.cash:
        return 'Bayar langsung di tempat';
      case PaymentMethod.bankTransfer:
        return 'Transfer ke rekening bank';
      case PaymentMethod.gopay:
        return 'Pembayaran via GoPay';
      case PaymentMethod.ovo:
        return 'Pembayaran via OVO';
      case PaymentMethod.dana:
        return 'Pembayaran via DANA';
      case PaymentMethod.creditCard:
        return 'Pembayaran dengan kartu kredit';
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentMethod.cash:
        return Icons.money;
      case PaymentMethod.bankTransfer:
        return Icons.account_balance;
      case PaymentMethod.gopay:
        return Icons.account_balance_wallet;
      case PaymentMethod.ovo:
        return Icons.account_balance_wallet;
      case PaymentMethod.dana:
        return Icons.account_balance_wallet;
      case PaymentMethod.creditCard:
        return Icons.credit_card;
    }
  }
}
