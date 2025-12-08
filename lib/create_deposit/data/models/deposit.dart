import 'dart:convert';

class Deposit {
  final int id;
  final String method;
  final String? currency;
  final double? amount;
  final double? netAmount;
  final String status;
  final DateTime? createdAt;

  const Deposit({
    required this.id,
    required this.method,
    this.currency,
    this.amount,
    this.netAmount,
    required this.status,
    this.createdAt,
  });

  factory Deposit.fromJson(dynamic source) {
    final Map<String, dynamic> map =
        source is String
            ? jsonDecode(source) as Map<String, dynamic>
            : source as Map<String, dynamic>;

    double? parseDouble(dynamic value) {
      if (value == null) return null;
      if (value is num) return value.toDouble();
      return double.tryParse(value.toString());
    }

    DateTime? parseDate(dynamic value) {
      if (value == null) return null;
      try {
        return DateTime.parse(value.toString()).toLocal();
      } catch (_) {
        return null;
      }
    }

    return Deposit(
      id:
          map["id"] is int
              ? map["id"] as int
              : int.tryParse("${map["id"]}") ?? 0,
      method: map["method"]?.toString() ?? "",
      currency: map["currency"]?.toString(),
      amount: parseDouble(map["amount"]),
      netAmount: parseDouble(map["net_amount"]),
      status: map["status"]?.toString() ?? "",
      createdAt: parseDate(map["created_at"]),
    );
  }

  String get displayAmount {
    final value = netAmount ?? amount;
    if (value == null) return "---";
    final currencySuffix = currency?.isNotEmpty == true ? " ${currency!}" : "";
    return "${value.toStringAsFixed(2)}$currencySuffix";
  }
}
