import 'package:flutter/material.dart';
import 'package:fuodz/create_deposit/presentation/widgets/choose_method_page_body.dart';
import 'package:fuodz/create_deposit/theme/deposit_app_themes.dart';
import 'package:fuodz/create_deposit/theme/deposit_theme_extension.dart';

class ChooseMethodPage extends StatelessWidget {
  const ChooseMethodPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Theme(
      data: DepositAppThemes.lightTheme,
      child: Builder(
        builder: (context) {
          return Scaffold(
            backgroundColor: context.depositScaffoldBackgroundColor,
            appBar: AppBar(
              title: const Text("Select Method"), // Localize this if needed
              backgroundColor: context.depositAppBarBackground,
              iconTheme: IconThemeData(color: context.depositAppBarForeground),
            ),
            body: const ChooseMethodPageBody(),
          );
        },
      ),
    );
  }
}
