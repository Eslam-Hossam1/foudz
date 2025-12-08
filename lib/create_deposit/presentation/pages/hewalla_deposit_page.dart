import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuodz/create_deposit/data/currency_options.dart';
import 'package:fuodz/create_deposit/data/datasources/deposit.datasource.dart';
import 'package:fuodz/create_deposit/data/repositories/deposit.repository.dart';
import 'package:fuodz/create_deposit/logic/cubits/hewalla_deposit.cubit.dart';
import 'package:fuodz/models/user.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/buttons/image_picker.view.dart';
import 'package:image_picker/image_picker.dart';

class HewallaDepositPage extends StatefulWidget {
  const HewallaDepositPage({super.key});

  @override
  State<HewallaDepositPage> createState() => _HewallaDepositPageState();
}

class _HewallaDepositPageState extends State<HewallaDepositPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  CurrencyOption? _selectedCurrency;
  final ImagePicker _picker = ImagePicker();
  File? _receiptImage;
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

  Future<void> _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile == null) return;
    setState(() {
      _receiptImage = File(pickedFile.path);
    });
  }

  void _removeImage() {
    setState(() {
      _receiptImage = null;
    });
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    if (_receiptImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please upload the payment receipt")),
      );
      return;
    }
    final amount = double.parse(_amountController.text);
    context.read<HewallaDepositCubit>().submitDeposit(
      amount: amount,
      photoPath: _receiptImage!.path,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create:
          (context) => HewallaDepositCubit(
            DepositRepositoryImpl(DepositRemoteDataSourceImpl()),
          ),
      child: Scaffold(
        appBar: AppBar(title: const Text("Hewalla Deposit")),
        body: BlocListener<HewallaDepositCubit, HewallaDepositState>(
          listener: (context, state) {
            if (state is HewallaDepositLoading) {
              // Loading
            } else if (state is HewallaDepositSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.response.message ?? "Deposit successful"),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            } else if (state is HewallaDepositFailure) {
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
                                      child: Text(currency.displayName),
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
                        const SizedBox(height: 16),
                        ImagePickerView(
                          _receiptImage,
                          _pickImage,
                          _removeImage,
                        ),
                        const SizedBox(height: 24),
                        BlocBuilder<HewallaDepositCubit, HewallaDepositState>(
                          builder: (context, state) {
                            return CustomButton(
                              title: "Submit",
                              loading: state is HewallaDepositLoading,
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
