import 'package:flutter/material.dart';
import 'package:fuodz/create_deposit/data/currency_options.dart';
import 'package:fuodz/models/user.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';

class CashDepositPage extends StatefulWidget {
  const CashDepositPage({super.key});

  @override
  State<CashDepositPage> createState() => _CashDepositPageState();
}

class _CashDepositPageState extends State<CashDepositPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  CurrencyOption _selectedCurrency = depositCurrencies.first;
  User? _user;

  @override
  void initState() {
    super.initState();
    _loadUser();
  }

  Future<void> _loadUser() async {
    final currentUser = await AuthServices.getCurrentUser();
    if (!mounted) return;
    setState(() {
      _user = currentUser;
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Cash deposit submitted")));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text("Cash Deposit")),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Account Holder", style: theme.textTheme.labelMedium),
                const SizedBox(height: 4),
                if (_user == null)
                  const LinearProgressIndicator(minHeight: 2)
                else
                  Text(_user!.name, style: theme.textTheme.titleMedium),
                const SizedBox(height: 24),
                DropdownButtonFormField<CurrencyOption>(
                  value: _selectedCurrency,
                  decoration: const InputDecoration(
                    labelText: "Select currency",
                    border: OutlineInputBorder(),
                  ),
                  items:
                      depositCurrencies
                          .map(
                            (currency) => DropdownMenuItem(
                              value: currency,
                              child: Text(currency.displayName),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() {
                      _selectedCurrency = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _amountController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: "Amount",
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return "Please enter an amount";
                    }
                    final parsed = double.tryParse(value);
                    if (parsed == null || parsed <= 0) {
                      return "Enter a valid amount";
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                CustomButton(title: "Submit", onPressed: _submit),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
