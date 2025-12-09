import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuodz/create_deposit/data/currency_options.dart';
import 'package:fuodz/create_deposit/data/datasources/deposit.datasource.dart';
import 'package:fuodz/create_deposit/data/repositories/deposit.repository.dart';
import 'package:fuodz/create_deposit/logic/cubits/hewalla_deposit.cubit.dart';
import 'package:fuodz/create_deposit/presentation/pages/deposit_list_page.dart';
import 'package:fuodz/create_deposit/presentation/widgets/deposit_dropdown_field.dart';
import 'package:fuodz/create_deposit/presentation/widgets/deposit_text_field.dart';
import 'package:fuodz/models/user.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/widgets/buttons/image_picker.view.dart';
import 'package:image_picker/image_picker.dart';
import 'package:fuodz/create_deposit/theme/deposit_theme_extension.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

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
        SnackBar(content: Text("Please upload the payment receipt".tr())),
      );
      return;
    }
    final amount = double.parse(_amountController.text);
    context.read<HewallaDepositCubit>().submitDeposit(
      amount: amount,
      photoPath: _receiptImage!.path,
      currency: _selectedCurrency!.code,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.depositTheme;

    return BlocProvider(
      create:
          (context) => HewallaDepositCubit(
            DepositRepositoryImpl(DepositRemoteDataSourceImpl()),
          ),
      child: Scaffold(
        backgroundColor: context.depositScaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            "Deposit via Transfer".tr(),
            style: theme.textTheme.titleLarge?.copyWith(
              color: context.depositAppBarForeground,
            ),
          ),
          backgroundColor: context.depositAppBarBackground,
          iconTheme: IconThemeData(color: context.depositAppBarForeground),
        ),
        body: BlocListener<HewallaDepositCubit, HewallaDepositState>(
          listener: (context, state) {
            if (state is HewallaDepositLoading) {
              // Loading
            } else if (state is HewallaDepositSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    "Deposit request submitted and pending admin approval".tr(),
                  ),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const DepositListPage(),
                ),
              );
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
                  padding: const EdgeInsets.all(24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DepositTextField(
                          label: "Account Holder".tr(),
                          controller: TextEditingController(
                            text: _user?.name ?? "Loading...",
                          ),
                          readOnly: true,
                          hintText: "Account Holder Name",
                        ),
                        const SizedBox(height: 24),
                        DepositDropdownField<CurrencyOption>(
                          label: "Currency".tr(),
                          value: _selectedCurrency,
                          isRequired: true,
                          hintText: "Select currency".tr(),
                          validator: (value) {
                            if (value == null) {
                              return "Please select a currency".tr();
                            }
                            return null;
                          },
                          items:
                              depositCurrencies.map((currency) {
                                return DropdownMenuItem(
                                  value: currency,
                                  child: Text(currency.displayName),
                                );
                              }).toList(),
                          onChanged: (value) {
                            setState(() {
                              _selectedCurrency = value;
                            });
                          },
                        ),
                        const SizedBox(height: 24),
                        DepositTextField(
                          label: "Amount".tr(),
                          controller: _amountController,
                          isRequired: true,
                          hintText: "Enter amount".tr(),
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter an amount".tr();
                            }
                            final parsed = double.tryParse(value);
                            if (parsed == null || parsed <= 0) {
                              return "Enter a valid amount".tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Text(
                          "Receipt Image".tr(),
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: context.depositPrimaryTextColor,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ImagePickerView(
                          _receiptImage,
                          _pickImage,
                          _removeImage,
                        ),
                        const SizedBox(height: 32),
                        BlocBuilder<HewallaDepositCubit, HewallaDepositState>(
                          builder: (context, state) {
                            return Align(
                              alignment: Alignment.center,
                              child: CustomButton(
                                title: "Submit".tr(),
                                loading: state is HewallaDepositLoading,
                                onPressed: () => _submit(context),
                              ),
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
