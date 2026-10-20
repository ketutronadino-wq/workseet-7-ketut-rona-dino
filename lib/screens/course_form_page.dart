import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/course_provider.dart';

class CourseFormPage extends StatefulWidget {
  final Course? course; // Jika null = Create, jika ada isinya = Update
  const CourseFormPage({super.key, this.course});

  @override
  State<CourseFormPage> createState() => _CourseFormPageState();
}

class _CourseFormPageState extends State<CourseFormPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _codeCtrl;
  late TextEditingController _titleCtrl;
  late TextEditingController _creditsCtrl;
  String _status = 'planned';

  @override
  void initState() {
    super.initState();
    _codeCtrl = TextEditingController(text: widget.course?.code ?? '');
    _titleCtrl = TextEditingController(text: widget.course?.title ?? '');
    _creditsCtrl = TextEditingController(text: widget.course?.credits.toString() ?? '');
    _status = widget.course?.status ?? 'planned';
  }

  @override
  void dispose() {
    _codeCtrl.dispose();
    _titleCtrl.dispose();
    _creditsCtrl.dispose();
    super.dispose();
  }

  Future<void> _simpan() async {
    if (!_formKey.currentState!.validate()) return;

    final course = Course(
      id: widget.course?.id,
      code: _codeCtrl.text,
      title: _titleCtrl.text,
      credits: int.parse(_creditsCtrl.text),
      status: _status,
    );

    final provider = context.read<CourseProvider>();
    bool success;
    
    if (widget.course == null) {
      success = await provider.createCourse(course);
    } else {
      success = await provider.updateCourse(widget.course!.id!, course);
    }

    if (!mounted) return;
    
    if (success) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Data berhasil disimpan!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Gagal: ${provider.error}')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<CourseProvider>().isSaving;

    return Scaffold(
      appBar: AppBar(title: Text(widget.course == null ? 'Tambah Course' : 'Edit Course')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _codeCtrl,
              decoration: const InputDecoration(labelText: 'Code (Contoh: MOB01)'),
              readOnly: widget.course != null, // Code read-only saat edit
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
            ),
            TextFormField(
              controller: _titleCtrl,
              decoration: const InputDecoration(labelText: 'Judul Course'),
              validator: (v) => v!.isEmpty ? 'Wajib diisi' : null,
            ),
            TextFormField(
              controller: _creditsCtrl,
              decoration: const InputDecoration(labelText: 'SKS'),
              keyboardType: TextInputType.number,
              validator: (v) => int.tryParse(v ?? '') == null ? 'Harus angka' : null,
            ),
            DropdownButtonFormField<String>(
              value: _status,
              decoration: const InputDecoration(labelText: 'Status'),
              items: ['planned', 'active', 'done'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) => setState(() => _status = val!),
            ),
            const SizedBox(height: 24),
            FilledButton(
              onPressed: isSaving ? null : _simpan,
              child: isSaving ? const CircularProgressIndicator() : const Text('Simpan'),
            )
          ],
        ),
      ),
    );
  }
}