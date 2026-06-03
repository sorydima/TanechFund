# Web4/Web5 Расширенная Архитектура REChain®️ VC Lab

## 📋 Обзор

Данный документ описывает расширенную архитектуру Web4 (Движение) и Web5 (Творение) с интеграцией децентрализованных технологий: DID (Decentralized Identifiers), IPFS (InterPlanetary File System) и Verifiable Credentials.

---

## 🏗️ Архитектура

### Компоненты

```
lib/
├── core/
│   └── services/
│       ├── did_service.dart          # DID Service
│       └── ipfs_service.dart         # IPFS Service
├── providers/
│   ├── web4_movement_provider.dart   # Legacy Web4 Provider
│   ├── web4_movement_provider_v2.dart # Enhanced Web4 Provider
│   ├── web5_creation_provider.dart   # Legacy Web5 Provider
│   └── web5_creation_provider_v2.dart # Enhanced Web5 Provider
```

---

## 🔐 DID Service (Decentralized Identifiers)

### Функциональность

- **Создание DID**: Генерация децентрализованных идентичностей в форматах:
  - `did:web:domain:user:userId` - Web-based DID
  - `did:key:z...` - Self-sovereign DID (самодостаточный)

- **Verifiable Credentials**: Издание и проверка верифицируемых креденшиалов
  - Подпись с использованием криптографии
  - Проверка подлинности
  - Отзыв креденшиалов

- **Хранение**: Безопасное хранение в FlutterSecureStorage

### Основные классы

#### DID
```dart
class DID {
  final String id;                    // DID identifier
  final String didDocument;           // DID документ
  final Map<String, dynamic> metadata; // Метаданные
  final DateTime createdAt;
}
```

#### VerifiableCredential
```dart
class VerifiableCredential {
  final String id;
  final String issuer;                // DID издателя
  final String subject;               // DID субъекта
  final Map<String, dynamic> claims;  // Утверждения
  final DateTime issuedAt;
  final DateTime? expiresAt;
  final String? signature;
  final bool isRevoked;
}
```

### Использование

```dart
final didService = DIDService();

// Создание DID
final didResult = await didService.createDid(
  domain: 'rechain.vc',
  userId: 'user123',
  metadata: {'name': 'John Doe'},
);

// Издание креденшиала
final credentialResult = await didService.issueCredential(
  issuerDid: 'did:web:rechain.vc:platform',
  subjectDid: didResult.value!.id,
  claims: {
    'type': 'trajectory_completion',
    'trajectoryId': 'web3-mastery',
    'score': 95,
  },
  validity: Duration(days: 365),
);

// Проверка креденшиала
final isValid = await didService.verifyCredential(credential);
```

---

## 🌐 IPFS Service

### Функциональность

- **Загрузка контента**: Децентрализованное хранение данных
- **Получение контента**: Доступ к данным по CID (Content Identifier)
- **Специализированные методы**:
  - `uploadWeb5Project()` - Загрузка проектов Web5
  - `uploadWeb4Trajectory()` - Загрузка траекторий Web4
  - `getWeb5Project()` - Получение проектов Web5
  - `getWeb4Trajectory()` - Получение траекторий Web4

### Основные методы

```dart
class IPFSService {
  // Базовые методы
  Future<Result<String>> uploadData(dynamic data);
  Future<Result<String>> uploadJson(Map<String, dynamic> json);
  Future<Result<String>> uploadText(String text);
  
  Future<Result<dynamic>> getData(String cid);
  Future<Result<Map<String, dynamic>>> getJson(String cid);
  Future<Result<String>> getText(String cid);
  
  // Специализированные методы
  Future<Result<String>> uploadWeb5Project(Map<String, dynamic> projectData);
  Future<Result<String>> uploadWeb4Trajectory(Map<String, dynamic> trajectoryData);
  Future<Result<Map<String, dynamic>>> getWeb5Project(String cid);
  Future<Result<Map<String, dynamic>>> getWeb4Trajectory(String cid);
  
  // Управление
  Future<Result<bool>> pinContent(String cid);
  Future<Result<bool>> unpinContent(String cid);
  String generateUrl(String cid);
}
```

### Использование

```dart
final ipfsService = IPFSService();

// Загрузка проекта Web5
final cidResult = await ipfsService.uploadWeb5Project({
  'title': 'Мой Проект',
  'description': 'Описание проекта',
  'type': 'digitalArt',
  'collaborators': ['user1', 'user2'],
});

// Получение проекта из IPFS
final projectResult = await ipfsService.getWeb5Project(cidResult.value!);

// Генерация URL для доступа
final url = ipfsService.generateUrl(cidResult.value!);
// https://ipfs.io/ipfs/QmXyz...
```

---

## 🔄 Web4MovementProvider V2

### Расширенная функциональность

- **DID Интеграция**: Поддержка децентрализованных идентичностей
- **IPFS Синхронизация**: Сохранение траекторий в децентрализованное хранилище
- **Верифицируемые Креденшиалы**: Издание креденшиалов за выполнение траекторий
- **Импорт/Экспорт**: Резервное копирование идентичностей

### Основные методы

```dart
class Web4MovementProviderV2 extends BaseProvider {
  // DID управление
  Future<Result<void>> _createDecentralizedIdentity();
  DID? get currentDid;
  bool get hasIdentity;
  
  // IPFS синхронизация
  Future<Result<void>> loadTrajectoriesFromIpfs();
  Future<Result<String>> saveTrajectoriesToIpfs(List<dynamic> trajectories);
  Future<Result<void>> syncWithIpfs();
  
  // Креденшиалы
  Future<Result<List<dynamic>>> getCredentials();
  Future<Result<dynamic>> issueTrajectoryCredential(
    String trajectoryId,
    Map<String, dynamic> claims,
  );
  Future<Result<bool>> verifyCredential(dynamic credential);
  
  // Идентичность
  Future<String> exportIdentity();
  Future<Result<void>> importIdentity(String exportedData);
}
```

### Использование

```dart
final web4Provider = getIt.get<Web4MovementProviderV2>();

// Проверка идентичности
if (web4Provider.hasIdentity) {
  print('DID: ${web4Provider.currentDid!.id}');
}

// Сохранение траекторий в IPFS
await web4Provider.saveTrajectoriesToIpfs(trajectories);

// Издание креденшиала за завершение траектории
final credential = await web4Provider.issueTrajectoryCredential(
  'trajectory-123',
  {'progress': 100, 'completedAt': DateTime.now().toIso8601String()},
);

// Экспорт идентичности для резервного копирования
final exportedData = await web4Provider.exportIdentity();
```

---

## 🎨 Web5CreationProvider V2

### Расширенная функциональность

- **AI Collaboration**: Интеграция с AI для совместной работы
- **IPFS Хранение**: Децентрализованное хранение проектов
- **Version Control**: Управление версиями проектов
- **Creative Moments**: Запись и хранение творческих моментов

### Основные методы

```dart
class Web5CreationProviderV2 extends BaseProvider {
  // Проекты
  Future<Result<String>> saveProjectToIpfs(Map<String, dynamic> projectData);
  Future<Result<Map<String, dynamic>>> loadProjectFromIpfs(String cid);
  
  // Создание проектов
  Future<Result<Map<String, dynamic>>> createDecentralizedProject({
    required String title,
    required String description,
    required String type,
    List<String>? collaborators,
    Map<String, dynamic>? aiConfig,
  });
  
  // AI collaboration
  Future<Result<Map<String, dynamic>>> enhanceProjectWithAi({
    required String projectId,
    required Map<String, dynamic> projectData,
    required String enhancementType,
  });
  
  Future<Result<Map<String, dynamic>>> collaborateWithAi({
    required String projectId,
    required Map<String, dynamic> projectData,
    required String aiSpecialty,
    required String task,
  });
  
  // Creative moments
  Future<Result<Map<String, dynamic>>> createCreativeMoment({
    required String title,
    required String description,
    List<String>? inspirations,
    Map<String, dynamic>? context,
  });
  
  // Version control
  Future<Result<String>> createProjectVersion({
    required String projectId,
    required Map<String, dynamic> projectData,
    required String versionMessage,
  });
  
  Future<Result<Map<String, dynamic>>> compareVersions({
    required String cid1,
    required String cid2,
  });
}
```

### Использование

```dart
final web5Provider = getIt.get<Web5CreationProviderV2>();

// Создание децентрализованного проекта
final project = await web5Provider.createDecentralizedProject(
  title: 'Мой AI Проект',
  description: 'Проект с AI коллаборацией',
  type: 'code',
  aiConfig: {'specialty': 'technical'},
);

// AI улучшения
final enhanced = await web5Provider.enhanceProjectWithAi(
  projectId: project.value!['id'],
  projectData: project.value!,
  enhancementType: 'technical',
);

// Создание творческого момента
final moment = await web5Provider.createCreativeMoment(
  title: 'Озарение',
  description: 'Новая идея для проекта',
  inspirations: ['AI conversation', 'research'],
  context: {'location': 'home', 'mood': 'inspired'},
);

// Создание версии проекта
final versionCid = await web5Provider.createProjectVersion(
  projectId: project.value!['id'],
  projectData: project.value!,
  versionMessage: 'Initial version',
);
```

---

## 🔗 Интеграция с DI

### Регистрация сервисов

Все новые сервисы автоматически регистрируются через Injectable:

```dart
// lib/di/injection.dart - автоматически сгенерирован

// Сервисы
@singleton
DIDService get didService => DIDService();

@singleton
IPFSService get ipfsService => IPFSService();

// Legacy провайдеры
@injectable
Web4MovementProvider();

@injectable
Web5CreationProvider();

// V2 провайдеры
@singleton
Web4MovementProviderV2(
  DIDService,
  IPFSService,
  Web4MovementProvider,
);

@singleton
Web5CreationProviderV2(
  DIDService,
  IPFSService,
  Web5CreationProvider,
);
```

---

## 📊 Архитектурные Паттерны

### 1. Multi-Version Support
- **Legacy провайдеры**: Сохраняют обратную совместимость
- **V2 провайдеры**: Расширенная функциональность с DID и IPFS
- **Плавная миграция**: Постепенный переход на новые версии

### 2. Repository Pattern
```
UI Layer (Screens)
    ↓
Provider Layer (Web4MovementProviderV2, Web5CreationProviderV2)
    ↓
Service Layer (DIDService, IPFSService)
    ↓
Storage Layer (FlutterSecureStorage, IPFS)
```

### 3. Result Pattern
Все асинхронные операции возвращают `Result<T>`:
- `Result.success(value)` - Успешная операция
- `Result.failure(error)` - Ошибка операции

### 4. Offline-First
- Данные сохраняются локально
- Синхронизация с IPFS при наличии сети
- Graceful degradation при отсутствии связи

---

## 🔒 Безопасность

### DID Security
- **Secure Storage**: Приватные ключи хранятся в FlutterSecureStorage
- **Crypto Signatures**: Подпись креденшиалов с использованием криптографии
- **Verification**: Проверка подписи и истечения срока

### IPFS Security
- **Content Addressing**: CID обеспечивает целостность данных
- **Pinning**: Постоянное хранение критического контента
- **Encryption**: (TODO) Шифрование чувствительных данных

---

## 🚀 Roadmap

### Фаза 1 (Текущая) ✅
- [x] DID Service реализация
- [x] IPFS Service реализация
- [x] Web4MovementProvider V2
- [x] Web5CreationProvider V2
- [x] Интеграция с DI

### Фаза 2 (Ближайшая)
- [ ] Реальная криптографическая подпись (библиотека pointycastle)
- [ ] Интеграция с Pinata API для IPFS pinning
- [ ] UI для управления DID
- [ ] UI для просмотра IPFS контента

### Фаза 3 (Перспективная)
- [ ] Интеграция с блокчейном для DID
- [ ] Decentralized Web Platform (DWP) поддержка
- [ ] Cross-chain credensial verification
- [ ] NFT minting для завершенных траекторий

---

## 📚 Ресурсы

### Документация
- [W3C DID Specification](https://www.w3.org/TR/did-core/)
- [IPFS Documentation](https://docs.ipfs.io/)
- [Verifiable Credentials Data Model](https://www.w3.org/TR/vc-data-model/)

### Пакеты
- `flutter_secure_storage` - Безопасное хранилище
- `crypto` - Криптографические функции
- `http` - HTTP клиент для IPFS API

---

*Документ создан: 2025-01-XX*  
*Версия: 2.0.0*  
*Статус: В разработке 🔄*
