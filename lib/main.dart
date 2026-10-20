import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'providers/course_provider.dart';
import 'repositories/course_repository.dart';
import 'services/course_supabase_service.dart'; // Ganti ke CourseApiService jika pakai REST
import 'screens/courses_page.dart';
import 'screens/favorites_page.dart';
import 'screens/home_page.dart';
import 'screens/profile_page.dart';
import 'widgets/status_style.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Tahap 10: Inisialisasi Supabase
  await Supabase.initialize(
    url: 'URL_SUPABASE_ANDA_DISINI',
    anonKey: 'ANON_KEY_ANDA_DISINI',
  );

  // Tahap 16: Pilih DataSource (Supabase atau API)
  final dataSource = CourseSupabaseService(); // Ubah ke CourseApiService('url') jika ingin pakai REST API

  runApp(
    ChangeNotifierProvider(
      create: (_) => CourseProvider(CourseRepository(dataSource))..loadAll(),
      child: const CourseExplorerApp(),
    ),
  );
}

// ... (Sisanya biarkan sama seperti ResponsiveMainShell di Pertemuan 6 Anda) ...
// (Salin ulang CourseExplorerApp dan ResponsiveMainShell dari kode main.dart lama Anda, 
// lalu di dalam pages tambahkan CoursesPage, FavoritesPage, HomePage, ProfilePage).