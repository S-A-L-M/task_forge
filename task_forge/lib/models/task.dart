class Task {
  final String? id;
  final String title;
  final String? description;
  final DateTime dueDate;
  final String priority; // 'high', 'medium', 'low'
  final List<String> tags;
  final String? notes;
  final String? parentId;
  final bool isProject;
  final bool isCompleted;

  Task({
    this.id,
    required this.title,
    this.description,
    required this.dueDate,
    this.priority = 'medium',
    this.tags = const [],
    this.notes,
    this.parentId,
    this.isProject = false,
    this.isCompleted = false,
  });

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id']?.toString(),
      title: json['title'] ?? '',
      description: json['description'],
      dueDate: DateTime.parse(json['due_date']),
      priority: json['priority'] ?? 'medium',
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      notes: json['notes'],
      parentId: json['parent_id']?.toString(),
      isProject: json['is_project'] ?? false,
      isCompleted: json['is_completed'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id': id,
      'title': title,
      'description': description,
      'due_date': dueDate.toIso8601String(),
      'priority': priority,
      'tags': tags,
      'notes': notes,
      'parent_id': parentId,
      'is_project': isProject,
      'is_completed': isCompleted,
    };
  }

  Task copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? dueDate,
    String? priority,
    List<String>? tags,
    String? notes,
    String? parentId,
    bool? isProject,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      dueDate: dueDate ?? this.dueDate,
      priority: priority ?? this.priority,
      tags: tags ?? this.tags,
      notes: notes ?? this.notes,
      parentId: parentId ?? this.parentId,
      isProject: isProject ?? this.isProject,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}