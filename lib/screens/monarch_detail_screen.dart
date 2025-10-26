import 'package:flutter/material.dart';
import '../models/monarch.dart';

class MonarchDetailScreen extends StatelessWidget {
  static const routeName = '/detail';
  final Monarch monarch;

  const MonarchDetailScreen({super.key, required this.monarch});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'รัชกาลที่ ${monarch.reignNo}',
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                monarch.photoPath,
                width: 220,
                height: 220,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              monarch.name,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 8),
            Text(
              monarch.years.isEmpty
                  ? 'ยังไม่ระบุช่วงปีครองราชย์'
                  : monarch.years,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'พระราชประวัติย่อ:',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[800],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 4),
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  monarch.bio.isEmpty ? 'ยังไม่มีข้อมูลประวัติ' : monarch.bio,
                  style: const TextStyle(fontSize: 15, height: 1.4),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
