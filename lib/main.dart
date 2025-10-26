import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/monarch_provider.dart';
import 'screens/monarch_list_screen.dart';
import 'screens/monarch_form_screen.dart';
import 'screens/monarch_detail_screen.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => MonarchProvider()..load(),  // โหลดข้อมูลตอนเริ่ม
      child: const MonarchApp(),
    ),
  );
}

class MonarchApp extends StatelessWidget {
  const MonarchApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Monarch DB (SQLite + Provider)',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: MonarchListScreen.routeName,
      debugShowCheckedModeBanner: false,
      routes: {
        MonarchListScreen.routeName: (_) => const MonarchListScreen(),
        MonarchFormScreen.routeName: (_) => const MonarchFormScreen(),
        MonarchDetailScreen.routeName: (_) => const Placeholder(),
      },
    );
  }
}
