import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/course_provider.dart';
import '../widgets/error_view.dart';
import 'course_form_page.dart';
import 'course_detail_page.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<CourseProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Data Manager')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const CourseFormPage())),
        child: const Icon(Icons.add),
      ),
      body: _buildBody(context, provider),
    );
  }

  Widget _buildBody(BuildContext context, CourseProvider provider) {
    if (provider.isLoading) return const Center(child: CircularProgressIndicator());
    if (provider.error != null) return ErrorView(message: provider.error!, onRetry: provider.loadAll);
    if (provider.courses.isEmpty) return const Center(child: Text('Data kosong, silakan tambah.'));

    return ListView.builder(
      itemCount: provider.courses.length,
      itemBuilder: (context, i) {
        final c = provider.courses[i];
        return ListTile(
          title: Text(c.title),
          subtitle: Text('${c.code} • ${c.credits} SKS • ${c.status}'),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseDetailPage(course: c))),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.blue),
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => CourseFormPage(course: c))),
              ),
              IconButton(
                icon: const Icon(Icons.delete, color: Colors.red),
                onPressed: () => _konfirmasiHapus(context, c.id!, c.code),
              ),
            ],
          ),
        );
      },
    );
  }

  void _konfirmasiHapus(BuildContext context, int id, String code) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Course?'),
        content: const Text('Data yang dihapus tidak bisa dikembalikan.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Batal')),
          FilledButton(
            onPressed: () async {
              Navigator.pop(ctx); // Tutup dialog
              final success = await context.read<CourseProvider>().deleteCourse(id, code);
              if (success && context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Berhasil dihapus')));
              }
            },
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}