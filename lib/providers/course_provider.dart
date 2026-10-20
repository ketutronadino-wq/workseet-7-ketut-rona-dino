import 'package:flutter/foundation.dart';
import '../models/course.dart';
import '../repositories/course_repository.dart';

class CourseProvider extends ChangeNotifier {
  final CourseRepository repository;
  CourseProvider(this.repository);

  List<Course> _courses = [];
  Map<String, dynamic> _student = {};
  bool _isLoading = false;
  bool _isSaving = false; // Untuk loading tombol form
  String? _error;
  final Set<String> _favorites = {};

  List<Course> get courses => _courses;
  Map<String, dynamic> get student => _student;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get error => _error;
  Set<String> get favorites => _favorites;

  List<Course> get favoriteCourses => _courses.where((c) => _favorites.contains(c.code)).toList();
  bool isFavorite(String code) => _favorites.contains(code);

  void toggleFavorite(String code) {
    if (_favorites.contains(code)) { _favorites.remove(code); } else { _favorites.add(code); }
    notifyListeners();
  }

  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      _courses = await repository.getCourses();
      // Data student kita hardcode atau ambil dari asset lokal jika mau
      _student = {"name": "Ketut Rona Dino", "nim": "2415051108", "skills": ["Flutter", "API", "Supabase"]};
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createCourse(Course course) async {
    _isSaving = true; notifyListeners();
    try {
      await repository.createCourse(course);
      await loadAll(); // Refresh
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isSaving = false; notifyListeners();
    }
  }

  Future<bool> updateCourse(int id, Course course) async {
    _isSaving = true; notifyListeners();
    try {
      await repository.updateCourse(id, course);
      await loadAll();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isSaving = false; notifyListeners();
    }
  }

  Future<bool> deleteCourse(int id, String code) async {
    _isSaving = true; notifyListeners();
    try {
      await repository.deleteCourse(id);
      _favorites.remove(code); // Hapus dari favorit jika ada
      await loadAll();
      return true;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isSaving = false; notifyListeners();
    }
  }
}