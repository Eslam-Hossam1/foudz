import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuodz/create_deposit/data/currency_options.dart';
import 'package:fuodz/create_deposit/data/datasources/deposit.datasource.dart';
import 'package:fuodz/create_deposit/data/repositories/deposit.repository.dart';
import 'package:fuodz/create_deposit/logic/cubits/cash_deposit.cubit.dart';
import 'package:fuodz/create_deposit/presentation/pages/deposit_list_page.dart';
import 'package:fuodz/models/user.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:velocity_x/velocity_x.dart';

class CashDepositPage extends StatefulWidget {
  const CashDepositPage({super.key});

  @override
  State<CashDepositPage> createState() => _CashDepositPageState();
}

class _CashDepositPageState extends State<CashDepositPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  CurrencyOption? _selectedCurrency;
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

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final amount = double.parse(_amountController.text);
    context.read<CashDepositCubit>().submitDeposit(
      currency: _selectedCurrency!.code,
      amount: amount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create:
          (context) => CashDepositCubit(
            DepositRepositoryImpl(DepositRemoteDataSourceImpl()),
          ),
      child: Scaffold(
        appBar: AppBar(title: const Text("Cash Deposit")),
        body: BlocListener<CashDepositCubit, CashDepositState>(
          listener: (context, state) {
            if (state is CashDepositLoading) {
              // You might want to show a loading indicator overlay here
            } else if (state is CashDepositSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.response.message ?? "Deposit successful"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const DepositListPage(),
                ),
              );
            } else if (state is CashDepositFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: Builder(
            builder: (context) {
              return SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Account Holder",
                          style: theme.textTheme.labelMedium,
                        ),
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
                          hint: const Text("Select currency"),
                          validator: (value) {
                            if (value == null) {
                              return "Please select a currency";
                            }
                            return null;
                          },
                          items:
                              depositCurrencies
                                  .map(
                                    (currency) => DropdownMenuItem(
                                      value: currency,
                                      child: Text(
                                        "${currency.label} → ${currency.code}",
                                      ),
                                    ),
                                  )
                                  .toList(),
                          onChanged: (value) {
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
                        BlocBuilder<CashDepositCubit, CashDepositState>(
                          builder: (context, state) {
                            return CustomButton(
                              title: "Submit",
                              loading: state is CashDepositLoading,
                              onPressed: () => _submit(context),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
