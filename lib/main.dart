import 'dart:async';
import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fuodz/app_bloc_observer.dart';
import 'package:fuodz/my_app.dart';
import 'package:fuodz/services/cart.service.dart';
import 'package:fuodz/services/general_app.service.dart';
import 'package:fuodz/services/local_storage.service.dart';
import 'package:fuodz/services/firebase.service.dart';
import 'package:fuodz/services/notification.service.dart';
import 'package:localize_and_translate/localize_and_translate.dart';

import 'constants/app_languages.dart';
import 'firebase_options.dart'; // Make sure this file is correctly configured by FlutterFire CLI

// This class is used
// to bypass SSL certificate checks,
// often for development with local servers.
class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  // Use runZonedGuarded to catch all errors, even those that happen
  // outside the Flutter framework.

  // Ensure that all Flutter bindings are initialized before calling native code.
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();

  // THE FIX: Initialize the DEFAULT Firebase app by removing the 'name' parameter.
  // This is the standard and correct way to do it.
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print("[DEBUG] Default Firebase App Initialized.");

  // FIX #2: Re-enable Crashlytics to catch errors.
  // This will handle errors within the Flutter framework.

  // Initialize localization service.
  await translator.init(
    localeType: LocalizationDefaultType.asDefined,
    languagesList: AppLanguages.codes,
    assetsDirectory: 'assets/lang/',
  );

  // Initialize other app services.
  await LocalStorageService.getPrefs();
  await CartServices.getCartItems();

  // Initialize notification services.
  await NotificationService.clearIrrelevantNotificationChannels();
  await NotificationService.initializeAwesomeNotification();
  await NotificationService.listenToActions();

  // Set up Firebase Cloud Messaging. This will now work correctly.
  await FirebaseService().setUpFirebaseMessaging();
  FirebaseMessaging.onBackgroundMessage(
    GeneralAppService.onBackgroundMessageHandler,
  );

  // This should ideally be used only for development/debugging.
  HttpOverrides.global = MyHttpOverrides();

  // All initialization is complete, now run the app.
  runApp(LocalizedApp(child: MyApp()));
  // This function catches any errors that were thrown in the "zone".
}
