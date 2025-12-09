import 'package:dio/dio.dart';

abstract class DepositRequest {
  String get method;
  Map<String, dynamic> toJson();
}

class CashDepositRequest extends DepositRequest {
  @override
  final String method = "cash";
  final String currency;
  final double amount;

  CashDepositRequest({required this.currency, required this.amount});

  @override
  Map<String, dynamic> toJson() {
    return {"method": method, "currency": currency, "amount": amount};
  }
}

class UsdtDepositRequest extends DepositRequest {
  @override
  final String method = "usdt";
  final double netAmount;
  final String txHash;

  UsdtDepositRequest({required this.netAmount, required this.txHash});

  @override
  Map<String, dynamic> toJson() {
    return {"method": method,
     "net_amount": netAmount,
      "tx_hash": txHash,
      };
  }
}

class HewallaDepositRequest extends DepositRequest {
  @override
  final String method = "transfer"; // "transfer" seems to correspond to hewalla/transfer in the prompt description "method (string, required): one of (cash, transfer, shamcash, usdt)"
  final double amount;
  final String? photoPath; // Path to the screenshot file
  final String currency;

  HewallaDepositRequest({
    required this.amount,
    this.photoPath,
    required this.currency,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "method": method,
      "amount": amount,
      "currency": currency,
      if (photoPath != null)
        "screenshot": MultipartFile.fromFileSync(photoPath!),
    };
  }
}

class ShamCashDepositRequest extends DepositRequest {
  @override
  final String method = "shamcash";
  final double amount;
  final String? photoPath;
  final String currency;

  ShamCashDepositRequest({
    required this.amount,
    this.photoPath,
    required this.currency,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      "method": method,
      "amount": amount,
      "currency": currency,
      if (photoPath != null)
        "screenshot": MultipartFile.fromFileSync(photoPath!),
    };
  }
}
