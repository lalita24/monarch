import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/monarch_provider.dart';
import '../models/monarch.dart';
import 'monarch_form_screen.dart';
import 'monarch_detail_screen.dart';
import 'monarch_form_screen.dart';


class MonarchListScreen extends StatelessWidget {
  static const routeName = '/';
  const MonarchListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Monarch History')),
      body: Consumer<MonarchProvider>(
        builder: (_, prov, __) {
          final data = prov.items;
          if (data.isEmpty) {
            return const Center(child: Text('ยังไม่มีข้อมูลในระบบ'));
          }
          return ListView.separated(
            itemCount: data.length,
            separatorBuilder: (_, __) => const Divider(height: 0),
            itemBuilder: (_, i) {
              final m = data[i];
              return ListTile(
                leading: CircleAvatar(
                  radius: 26,
                  backgroundImage: AssetImage(m.photoPath),
                ),
                title: Text('รัชกาลที่ ${m.reignNo}'),
                subtitle: Text(
                  m.years.isEmpty ? 'ยังไม่ระบุช่วงปีครองราชย์' : m.years,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => MonarchDetailScreen(monarch: m),
                    ),
                  );
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.blueGrey),
                      tooltip: 'แก้ไขข้อมูล',
                      onPressed: () {
                        Navigator.pushNamed(
                          context,
                          MonarchFormScreen.routeName,
                          arguments: m,
                        );
                      },
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.blueGrey),
                      tooltip: 'ลบข้อมูล',
                      onPressed: () async {
                        final ok = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: const Text('ยืนยันการลบ'),
                            content: Text('ลบข้อมูลของ ${m.name} หรือไม่?'),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, false),
                                child: const Text('ยกเลิก'),
                              ),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: const Text('ลบ',
                                    style: TextStyle(color: Colors.blueGrey)),
                              ),
                            ],
                          ),
                        );
                        if (ok == true) {
                          await context.read<MonarchProvider>().remove(m.id!);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('ลบ ${m.name} แล้ว')),
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () =>
            Navigator.pushNamed(context, MonarchFormScreen.routeName),
      ),
    );
  }
}
