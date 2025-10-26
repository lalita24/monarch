import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/monarch_provider.dart';
import '../models/monarch.dart';

class MonarchFormScreen extends StatefulWidget {
  static const routeName = '/form';
  const MonarchFormScreen({super.key});

  @override
  State<MonarchFormScreen> createState() => _MonarchFormScreenState();
}

class _MonarchFormScreenState extends State<MonarchFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _yearsCtrl = TextEditingController();
  final _bioCtrl = TextEditingController();

  int _reignNo = 1;
  String _photoPath = 'assets/images/r1.jpg';
  Monarch? editing;

  final _photoChoices =
      List.generate(10, (i) => 'assets/images/r${i + 1}.jpg');

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final arg = ModalRoute.of(context)!.settings.arguments;
    if (arg != null && editing == null) {
      editing = arg as Monarch;
      _reignNo = editing!.reignNo;
      _nameCtrl.text = editing!.name;
      _yearsCtrl.text = editing!.years;
      _bioCtrl.text = editing!.bio;
      _photoPath = editing!.photoPath;
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _yearsCtrl.dispose();
    _bioCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final m = Monarch(
      id: editing?.id,
      reignNo: _reignNo,
      name: _nameCtrl.text.trim(),
      years: _yearsCtrl.text.trim(),
      bio: _bioCtrl.text.trim(),
      photoPath: _photoPath,
    );
    final prov = context.read<MonarchProvider>();
    if (editing == null) {
      await prov.add(m);
    } else {
      await prov.update(m);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = editing != null;
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'แก้ไขข้อมูล' : 'เพิ่มข้อมูล')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(_photoPath,
                      width: 160, height: 160, fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                value: _reignNo,
                items: List.generate(10, (i) => i + 1)
                    .map((n) => DropdownMenuItem(
                        value: n, child: Text('รัชกาลที่ $n')))
                    .toList(),
                onChanged: (v) => setState(() => _reignNo = v ?? 1),
                decoration: const InputDecoration(labelText: 'รัชกาล'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'พระนาม'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'กรอกพระนาม' : null,
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _yearsCtrl,
                decoration:
                    const InputDecoration(labelText: 'ช่วงปีครองราชย์ (พ.ศ. …–…)'),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _bioCtrl,
                decoration: const InputDecoration(labelText: 'ประวัติย่อ'),
                maxLines: 4,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _photoPath,
                items: _photoChoices
                    .map((p) => DropdownMenuItem(
                          value: p,
                          child: Text(p.split('/').last),
                        ))
                    .toList(),
                onChanged: (v) => setState(() => _photoPath = v ?? _photoPath),
                decoration: const InputDecoration(labelText: 'เลือกรูป (assets)'),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.save),
                label: Text(isEdit ? 'บันทึกการแก้ไข' : 'บันทึก'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
