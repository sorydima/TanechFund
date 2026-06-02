enum ProjectStatus {
  inProgress,
  completed,
  onHold,
  cancelled,
}

enum ProjectCategory {
  defi,
  nft,
  dao,
  gaming,
  infrastructure,
  other,
}

/// Модель проекта портфолио.
class ProjectModel {
  final String id;
  final String title;
  final String description;
  final String userId;
  final ProjectCategory category;
  final ProjectStatus status;
  final List<String> technologies;
  final List<String> images;
  final String? githubUrl;
  final String? liveUrl;
  final String? documentationUrl;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final int likes;
  final int views;
  final double rating;
  final List<String> tags;
  final Map<String, dynamic> metadata;

  const ProjectModel({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.category,
    required this.status,
    required this.technologies,
    required this.images,
    this.githubUrl,
    this.liveUrl,
    this.documentationUrl,
    required this.createdAt,
    this.updatedAt,
    this.likes = 0,
    this.views = 0,
    this.rating = 0.0,
    required this.tags,
    this.metadata = const {},
  });

  ProjectModel copyWith({
    String? id,
    String? title,
    String? description,
    String? userId,
    ProjectCategory? category,
    ProjectStatus? status,
    List<String>? technologies,
    List<String>? images,
    String? githubUrl,
    String? liveUrl,
    String? documentationUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    int? likes,
    int? views,
    double? rating,
    List<String>? tags,
    Map<String, dynamic>? metadata,
  }) {
    return ProjectModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      userId: userId ?? this.userId,
      category: category ?? this.category,
      status: status ?? this.status,
      technologies: technologies ?? this.technologies,
      images: images ?? this.images,
      githubUrl: githubUrl ?? this.githubUrl,
      liveUrl: liveUrl ?? this.liveUrl,
      documentationUrl: documentationUrl ?? this.documentationUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      likes: likes ?? this.likes,
      views: views ?? this.views,
      rating: rating ?? this.rating,
      tags: tags ?? this.tags,
      metadata: metadata ?? this.metadata,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'userId': userId,
      'category': category.index,
      'status': status.index,
      'technologies': technologies,
      'images': images,
      'githubUrl': githubUrl,
      'liveUrl': liveUrl,
      'documentationUrl': documentationUrl,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'likes': likes,
      'views': views,
      'rating': rating,
      'tags': tags,
      'metadata': metadata,
    };
  }

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      userId: json['userId'] as String,
      category: ProjectCategory.values[(json['category'] as num).toInt()],
      status: ProjectStatus.values[(json['status'] as num).toInt()],
      technologies: (json['technologies'] as List<dynamic>).map((e) => e as String).toList(),
      images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
      githubUrl: json['githubUrl'] as String?,
      liveUrl: json['liveUrl'] as String?,
      documentationUrl: json['documentationUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt'] as String) : null,
      likes: (json['likes'] as num?)?.toInt() ?? 0,
      views: (json['views'] as num?)?.toInt() ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
      metadata: (json['metadata'] as Map<String, dynamic>?) ?? const {},
    );
  }
}
