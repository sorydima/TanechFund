# Web4/Web5 Гид Разработчика

## Быстрый Старт

### 1. Инициализация

Сервисы автоматически инициализируются через DI контейнер. Никаких дополнительных настроек не требуется.

```dart
import 'package:rechain_vc_lab/di/injection.dart';
import 'package:rechain_vc_lab/providers/web4_movement_provider_v2.dart';
import 'package:rechain_vc_lab/providers/web5_creation_provider_v2.dart';

// В main.dart или любом экране
final web4Provider = getIt.get<Web4MovementProviderV2>();
final web5Provider = getIt.get<Web5CreationProviderV2>();
```

### 2. Работа с DID (Децентрализованная Идентичность)

#### Создание DID (автоматически при первом запуске)

```dart
// DID создается автоматически при инициализации Web4MovementProviderV2
if (!web4Provider.hasIdentity) {
  print('Идентичность создается автоматически...');
} else {
  print('Ваш DID: ${web4Provider.currentDid!.id}');
}
```

#### Экспорт и импорт идентичности

```dart
// Экспорт для резервного копирования
final backup = await web4Provider.exportIdentity();
// Сохраните backup в безопасное место

// Импорт при восстановлении
await web4Provider.importIdentity(backup);
```

### 3. Работа с IPFS

#### Сохранение данных

```dart
// Сохранение траектории Web4
await web4Provider.saveTrajectoriesToIpfs(trajectories);

// Сохранение проекта Web5
final projectCid = await web5Provider.saveProjectToIpfs(projectData);
```

#### Получение данных

```dart
// Получение проекта из IPFS
final project = await web5Provider.loadProjectFromIpfs(cid);
```

### 4. Создание Проекта Web5

```dart
final project = await web5Provider.createDecentralizedProject(
  title: 'Мой AI Проект',
  description: 'Проект с использованием AI',
  type: 'code',
  collaborators: ['user1', 'user2'],
  aiConfig: {
    'specialty': 'technical',
    'models': ['code-assistant'],
  },
);

print('Проект создан: ${project.value!['id']}');
print('IPFS CID: ${project.value!['ipfs']['cid']}');
```

### 5. AI Коллаборация

#### Получение AI предложений

```dart
final enhanced = await web5Provider.enhanceProjectWithAi(
  projectId: projectId,
  projectData: projectData,
  enhancementType: 'technical', // или 'creative', 'business', 'social'
);

// AI предложения
final suggestions = enhanced.value!['aiEnhancements']['suggestions'];
```

#### Совместная работа с AI

```dart
final result = await web5Provider.collaborateWithAi(
  projectId: projectId,
  projectData: projectData,
  aiSpecialty: 'creative', // или 'technical', 'analytical', 'social'
  task: 'Предложи идеи для улучшения UX',
);

print('AI ответ: ${result.value!['response']}');
```

### 6. Творческие Моменты

```dart
final moment = await web5Provider.createCreativeMoment(
  title: 'Новая идея',
  description: 'Озарение о архитектуре системы',
  inspirations: ['research', 'conversation'],
  context: {
    'location': 'home',
    'mood': 'inspired',
    'time': 'evening',
  },
);
```

### 7. Управление Версиями

```dart
// Создание версии
final versionCid = await web5Provider.createProjectVersion(
  projectId: projectId,
  projectData: projectData,
  versionMessage: 'Добавлена новая функция',
);

// Сравнение версий
final diff = await web5Provider.compareVersions(
  cid1: 'QmXyz123...',
  cid2: 'QmAbc456...',
);

print('Различия: ${diff.value!['differences']}');
```

### 8. Верифицируемые Креденшиалы

#### Издание креденшиала за завершение траектории

```dart
final credential = await web4Provider.issueTrajectoryCredential(
  'trajectory-123',
  {
    'progress': 100,
    'completedAt': DateTime.now().toIso8601String(),
    'score': 95,
  },
);

print('Креденшиал выпущен: ${credential.value!['id']}');
```

#### Получение всех креденшиалов

```dart
final credentials = await web4Provider.getCredentials();

for (final vc in credentials.value!) {
  print('Креденшиал: ${vc.id}');
  print('Утверждения: ${vc.claims}');
}
```

#### Проверка креденшиала

```dart
final isValid = await web4Provider.verifyCredential(credential);

if (isValid.value!) {
  print('Креденшиал валиден!');
} else {
  print('Креденшиал не валиден');
}
```

---

## Примеры Использования

### Полный Workflow: Создание Путь → Завершение → Получение Креденшиала

```dart
// 1. Создание траектории
final trajectory = MovementTrajectory(
  id: 'web3-mastery',
  title: 'Путь к Web3 Мастерству',
  description: 'Изучение блокчейн технологий',
  type: MovementType.professional,
  tags: ['blockchain', 'web3'],
  createdAt: DateTime.now(),
  status: MovementStatus.active,
  metadata: {},
  steps: [],
  progress: 0,
);

// 2. Сохранение в IPFS
await web4Provider.saveTrajectoriesToIpfs([trajectory.toJson()]);

// 3. Завершение пути (эмуляция)
// ... пользователь выполняет шаги ...

// 4. Издание креденшиала
final credential = await web4Provider.issueTrajectoryCredential(
  trajectory.id,
  {
    'progress': 100,
    'completedAt': DateTime.now().toIso8601String(),
    'skills': ['Solidity', 'Smart Contracts', 'DApps'],
  },
);

// 5. Проверка креденшиала
final isValid = await web4Provider.verifyCredential(credential.value!);

print('Trajectory completed with credential: ${credential.value!.id}');
```

### Полный Workflow: Создание Проекта → AI Улучшение → Версионирование

```dart
// 1. Создание проекта
final project = await web5Provider.createDecentralizedProject(
  title: 'AI-Powered DApp',
  description: 'Децентрализованное приложение с AI',
  type: 'code',
  aiConfig: {'specialty': 'technical'},
);

// 2. AI улучшение
final enhanced = await web5Provider.enhanceProjectWithAi(
  projectId: project.value!['id'],
  projectData: project.value!,
  enhancementType: 'technical',
);

// 3. Создание версии
final version1 = await web5Provider.createProjectVersion(
  projectId: project.value!['id'],
  projectData: enhanced.value!,
  versionMessage: 'Initial AI-enhanced version',
);

// 4. Дополнительные улучшения...
// 5. Создание новой версии
final version2 = await web5Provider.createProjectVersion(
  projectId: project.value!['id'],
  projectData: finalProjectData,
  versionMessage: 'Final version with all features',
);

// 6. Сравнение версий
final diff = await web5Provider.compareVersions(
  cid1: version1.value!,
  cid2: version2.value!,
);

print('Project evolved from ${version1.value!} to ${version2.value!}');
```

---

## Best Practices

### 1. Обработка Ошибок

```dart
final result = await web5Provider.createDecentralizedProject(...);

if (result.isSuccess) {
  // Успешно
  final project = result.value!;
} else {
  // Ошибка
  AppLogger.error('Failed to create project', result.error);
  // Показать пользователю
}
```

### 2. Проверка Идентичности

```dart
if (!web4Provider.hasIdentity) {
  // Ожидание создания идентичности или показать ошибку
  await Future.delayed(Duration(seconds: 2));
}
```

### 3. Кэширование

```dart
// Данные локально + в IPFS для резерва
final localData = await loadLocally();
final ipfsData = await web5Provider.loadProjectFromIpfs(cid);
```

### 4. Синхронизация

```dart
// Синхронизация с IPFS при наличии сети
if (await _checkNetwork()) {
  await web4Provider.syncWithIpfs();
  await web5Provider.syncAllProjects();
}
```

---

## Troubleshooting

### DID не создается

- Проверьте наличие `FlutterSecureStorage`
- Убедитесь, что приложение имеет права на хранение

### IPFS недоступен

- Проверьте интернет-соединение
- IPFS может быть медленным — используйте fallback на локальное хранилище

### Ошибка подписи креденшиала

- Убедитесь, что DID создан корректно
- Проверьте наличие приватного ключа в secure storage

---

*Гид создан: 2025-01-XX*  
*Версия: 1.0.0*
