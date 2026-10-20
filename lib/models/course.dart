class Course {
  final int? id;
  final String code;
  final String title;
  final int credits;
  final String status;
  final String description;

  Course({
    this.id,
    required this.code,
    required this.title,
    required this.credits,
    required this.status,
    this.description = '',
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    return Course(
      id: json['id'] as int?,
      code: json['code'] as String? ?? '', // Supabase kadang return null
      title: json['title'] as String? ?? '',
      credits: (json['credits'] as num?)?.toInt() ?? 0,
      status: (json['status'] as String?) ?? 'planned',
      description: (json['description'] ?? '').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    // Hapus 'id' saat insert/update agar database yang mengurus auto-increment
    return {
      'code': code,
      'title': title,
      'credits': credits,
      'status': status,
      'description': description,
    };
  }
}