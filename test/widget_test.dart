import 'package:flutter_test/flutter_test.dart';
import 'package:rechain_vc_lab/core/result.dart';
import 'package:rechain_vc_lab/core/app_error.dart';
import 'package:rechain_vc_lab/models/user_model.dart';
import 'package:rechain_vc_lab/models/project_model.dart';

void main() {
  group('Result<T,E>', () {
    test('Success holds value', () {
      const result = Success<int, AppError>(42);
      expect(result.isSuccess, true);
      expect(result.value, 42);
      expect(result.error, null);
    });

    test('Failure holds error', () {
      const result = Failure<int, AppError>(AuthError('unauthorized'));
      expect(result.isFailure, true);
      expect(result.value, null);
      expect(result.error, isA<AuthError>());
    });

    test('when maps both branches', () {
      const ok = Success<int, AppError>(10);
      final mapped = ok.when(success: (v) => v * 2, failure: (_) => 0);
      expect(mapped, 20);
    });
  });

  group('UserModel', () {
    test('empty user has isEmpty == true', () {
      expect(UserModel.empty.isEmpty, true);
      expect(UserModel.empty.isNotEmpty, false);
    });

    test('fromJson / toJson roundtrip', () {
      const user = UserModel(
        id: 'u1',
        name: 'Alice',
        email: 'alice@example.com',
        role: 'admin',
        permissions: ['read', 'write'],
      );
      final json = user.toJson();
      final restored = UserModel.fromJson(json);
      expect(restored.id, 'u1');
      expect(restored.name, 'Alice');
      expect(restored.permissions, ['read', 'write']);
    });
  });

  group('ProjectModel', () {
    test('copyWith changes only provided fields', () {
      final project = ProjectModel(
        id: 'p1',
        title: 'Old',
        description: 'Desc',
        userId: 'u1',
        category: ProjectCategory.defi,
        status: ProjectStatus.inProgress,
        technologies: const ['Flutter'],
        images: const [],
        createdAt: DateTime(2024, 1, 1),
        tags: const [],
      );
      final updated = project.copyWith(title: 'New');
      expect(updated.title, 'New');
      expect(updated.id, 'p1');
    });
  });
}
