import 'package:flutter/material.dart';
import 'package:device_preview/device_preview.dart';
import 'package:perpus_app/page/welcome.dart';
import 'package:perpus_app/provider/auth_provider.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(
    DevicePreview(
      enabled: true, // Aktifkan Device Preview
      builder: (context) => MultiProvider(
        providers: [
          ChangeNotifierProvider(
              create: (_) => LoginProvider()), // Tambahkan LoginProvider
        ],
        child: const MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Toko Online',
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      home: const WelcomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
