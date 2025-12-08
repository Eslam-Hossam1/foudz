import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuodz/create_deposit/data/datasources/deposit.datasource.dart';
import 'package:fuodz/create_deposit/data/repositories/deposit.repository.dart';
import 'package:fuodz/create_deposit/logic/cubits/usdt_deposit.cubit.dart';
import 'package:fuodz/create_deposit/presentation/pages/deposit_list_page.dart';
import 'package:fuodz/models/user.dart';
import 'package:fuodz/services/auth.service.dart';
import 'package:fuodz/widgets/buttons/custom_button.dart';
import 'package:fuodz/create_deposit/theme/deposit_app_themes.dart';
import 'package:fuodz/create_deposit/theme/deposit_theme_extension.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

class UsdtDepositPage extends StatefulWidget {
  const UsdtDepositPage({super.key});

  @override
  State<UsdtDepositPage> createState() => _UsdtDepositPageState();
}

class _UsdtDepositPageState extends State<UsdtDepositPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _hashController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
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
    _hashController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    final amount = double.parse(_amountController.text);
    final txHash = _hashController.text;
    context.read<UsdtDepositCubit>().submitDeposit(
      netAmount: amount,
      txHash: txHash,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.depositTheme;

    return BlocProvider(
      create:
          (context) => UsdtDepositCubit(
            DepositRepositoryImpl(DepositRemoteDataSourceImpl()),
          ),
      child: Scaffold(
        backgroundColor: context.depositScaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            "USDT Deposit".tr(),
            style: theme.textTheme.titleLarge?.copyWith(
              color: context.depositAppBarForeground,
            ),
          ),
          backgroundColor: context.depositAppBarBackground,
          iconTheme: IconThemeData(color: context.depositAppBarForeground),
        ),
        body: BlocListener<UsdtDepositCubit, UsdtDepositState>(
          listener: (context, state) {
            if (state is UsdtDepositLoading) {
              // Loading
            } else if (state is UsdtDepositSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    state.response.message ?? "Deposit successful".tr(),
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
            } else if (state is UsdtDepositFailure) {
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
                          "Account Holder".tr(),
                          style: theme.textTheme.labelMedium,
                        ),
                        const SizedBox(height: 4),
                        if (_user == null)
                          const LinearProgressIndicator(minHeight: 2)
                        else
                          Text(_user!.name, style: theme.textTheme.titleMedium),
                        const SizedBox(height: 24),
                        TextFormField(
                          controller: _hashController,
                          decoration: InputDecoration(
                            labelText: "Transaction hash".tr(),
                            border: const OutlineInputBorder(),
                          ),
                          validator: (value) {
                            if (value == null || value.trim().isEmpty) {
                              return "Please enter the transaction hash".tr();
                            }
                            if (value.trim().length < 10) {
                              return "Hash looks too short".tr();
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _amountController,
                          keyboardType: const TextInputType.numberWithOptions(
                            decimal: true,
                          ),
                          decoration: InputDecoration(
                            labelText: "Amount".tr(),
                            border: const OutlineInputBorder(),
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
                        BlocBuilder<UsdtDepositCubit, UsdtDepositState>(
                          builder: (context, state) {
                            return CustomButton(
                              title: "Submit".tr(),
                              loading: state is UsdtDepositLoading,
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
