# Mobile Playground - Architecture Documentation

## 📋 Overview

This app follows a **Clean Architecture pattern** with **Riverpod** for state management, organized into four distinct layers:

```
┌─────────────────────────────────────────┐
│      PRESENTATION LAYER                 │
│   (Screens, Widgets, Controllers)       │
└──────────────────┬──────────────────────┘
                   │
┌──────────────────▼──────────────────────┐
│      APPLICATION LAYER                  │
│   (Services, Orchestration Logic)       │
└──────────────────┬──────────────────────┘
                   │
┌──────────────────▼──────────────────────┐
│      DOMAIN LAYER                       │
│   (Models, Entities, Business Rules)    │
└──────────────────┬──────────────────────┘
                   │
┌──────────────────▼──────────────────────┐
│      DATA LAYER                         │
│   (Repositories, APIs, Local Storage)   │
└─────────────────────────────────────────┘
```

### Data Flow Direction

```
User Interaction
       ↓
   Presentation Layer (UI, Widgets)
       ↓
   Application Layer (Services, Controllers)
       ↓
   Domain Layer (Models, Business Rules)
       ↓
   Data Layer (Repositories, APIs)
       ↓
   Data Sources (APIs, Local Storage, Devices)
```

---

## 🏗️ Layer Responsibilities

### 1. **Presentation Layer**
**Location:** `lib/[feature]/presentation/`

Responsible for:
- Rendering UI components (Widgets)
- Managing UI state with Controllers (AsyncNotifier)
- Responding to user interactions
- Displaying data to the user
- No direct business logic

**Key Components:**
- **Screens:** Full-page widgets (e.g., `home_screen.dart`, `nfc_scanner_screen.dart`)
- **Widgets:** Reusable UI components (e.g., `feature_card.dart`)
- **Controllers:** Riverpod AsyncNotifier that manage state (e.g., NFC Scanner uses `nfc_scanner_controller.dart`)

**Example Structure:**
```
lib/nfc_scanner/presentation/
├── nfc_scanner_screen.dart          # Main screen widget
├── nfc_screen_types.dart/           # Sub-screens directory
│   ├── nfc_screen.dart
│   ├── nfc_scanning_screen.dart
│   ├── nfc_success_screen.dart
│   └── nfc_error_screen.dart
└── controllers/                     # Controllers for state management
    └── nfc_controller.dart
```

**Riverpod Controller Example:**
```dart
final nfcScannerProvider = AsyncNotifierProvider<
  NfcScannerController,
  NfcScannerState
>(() => NfcScannerController());

class NfcScannerController extends AsyncNotifier<NfcScannerState> {
  // Manages state and calls application layer services
}
```

**Interaction:**
- Controllers call services from the **Application Layer**
- Widgets listen to provider state and rebuild when state changes
- No direct database or API calls

---

### 2. **Application Layer**
**Location:** `lib/[feature]/services/` or `lib/[feature]/application/`

Responsible for:
- Orchestrating business logic across multiple data sources
- Coordinating between controllers and repositories
- Handling complex workflows
- Sharing logic across multiple features

**Key Components:**
- **Services:** Classes that coordinate logic (e.g., `nfc_scanner_controller.dart`, `location_service.dart`)
- **Providers:** Riverpod providers that expose services to controllers

**Example Structure:**
```
lib/location/services/
├── location_service.dart            # Handles location retrieval
└── directions_service.dart          # Handles direction calculation
```

**Service Example:**
```dart
class LocationService {
  final LocationRepository _locationRepository;

  LocationService(this._locationRepository);

  Future<LocationModel> getCurrentLocation() async {
    // Orchestrate logic, may call multiple repositories
    return await _locationRepository.fetchCurrentLocation();
  }
}
```

**Interaction:**
- Called by Presentation Layer (Controllers)
- Calls Domain and Data Layer entities/repositories
- Contains reusable, feature-independent logic

---

### 3. **Domain Layer**
**Location:** `lib/[feature]/domain/` (or `lib/[feature]/domains/`)

Responsible for:
- Defining core business models (Entities)
- Representing the "heart" of the app's business logic
- Being framework-agnostic (no Riverpod, no HTTP client imports)
- Defining immutable data structures

**Key Components:**
- **Models/Entities:** Immutable data classes representing domain concepts
- **Value Objects:** Small, immutable objects representing domain values
- **Repository Interfaces:** Abstract definitions of data access contracts

**Example Structure:**
```
lib/nfc_scanner/domain/
├── nfc_scanner_state.dart           # Domain model (Freezed immutable class)
├── nfc_scanner_state.freezed.dart   # Generated freezed code
└── models/
    └── scan_result.dart
```

**Domain Model Example (Using Freezed):**
```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'nfc_scanner_state.freezed.dart';

@freezed
class NfcScannerState with _$NfcScannerState {
  const factory NfcScannerState({
    required String tagId,
    required DateTime scannedAt,
  }) = _NfcScannerState;
}
```

**Characteristics:**
- ✅ Immutable (using Freezed)
- ✅ No external dependencies
- ✅ Contains equality and hash implementations
- ✅ Serialization logic if needed

**Interaction:**
- Used by Application Layer (Services)
- Used by Presentation Layer (displayed in UI)
- Independent of frameworks and external libraries

---

### 4. **Data Layer**
**Location:** `lib/[feature]/data/` or `lib/[feature]/repositories/`

Responsible for:
- Fetching data from external sources (APIs, sensors, local storage)
- Implementing repository interfaces
- Transforming DTOs to Domain Models
- Caching and persistence

**Key Components:**
- **Repositories:** Implementation of data access contracts
- **Data Sources:** Direct API/database/device access (Remote, Local, Device)
- **DTOs:** Data Transfer Objects for serialization/deserialization

**Example Structure:**
```
lib/[feature]/data/
├── repositories/
│   └── nfc_scanner_repository.dart  # Implementation of repository
├── datasources/
│   ├── remote_datasource.dart       # API calls
│   ├── local_datasource.dart        # Local storage
│   └── device_datasource.dart       # Hardware access
└── models/
    └── scan_dto.dart                # Data Transfer Objects
```

**Repository Example:**
```dart
class NfcScannerRepository {
  final NfcScannerRemoteDataSource _remoteDataSource;

  Future<NfcScannerState> scanTag() async {
    // Fetch from data source and transform
    final dto = await _remoteDataSource.scanNfcTag();
    return dto.toDomain(); // Convert DTO to Domain Model
  }
}
```

**Interaction:**
- Called by Application Layer (Services)
- Calls external services (APIs, device sensors, databases)
- Returns Domain Models to upper layers

---

## 📁 Current Architecture State

### ✅ Well-Structured Features
**NFC Scanner** - Follows the full architecture pattern:
```
lib/nfc_scanner/
├── domain/
│   ├── nfc_scanner_state.dart       # Domain model
│   └── nfc_scanner_state.freezed.dart
├── presentation/
│   ├── nfc_scanner_screen.dart      # Main UI
│   ├── nfc_screen_types.dart/       # Sub-screens
│   └── controllers/                 # State management (optional)
└── services/
    └── nfc_scanner_controller.dart  # Application logic
```

**Home Feature** - Partial structure with Domain and Presentation:
```
lib/home/
├── domain/
│   └── feature.dart                 # Domain model
└── presentation/
    ├── home_screen.dart             # UI
    └── feature_card.dart            # Reusable component
```

### 🔄 Partially Structured Features
**Location** - Has services but minimal domain structure:
```
lib/location/
├── location_screen.dart             # Presentation
└── services/
    ├── location_service.dart        # Application logic
    └── directions_service.dart
```

### 🏗️ Needs Refactoring
**Document Scanner** - Currently monolithic, needs layer separation:
```
lib/document_scanner/
├── document_scanner.dart            # ❌ All code in one file
└── docs/
    └── feature_specification.md
```

---

## 🛠️ Implementation Guidelines

### When to Create Each Layer

#### Domain Layer (Always Create)
- ✅ Define your core models/entities
- ✅ Use Freezed for immutability
- ✅ Keep it framework-agnostic

**Example:**
```dart
// lib/document_scanner/domain/document_model.dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'document_model.freezed.dart';

@freezed
class Document with _$Document {
  const factory Document({
    required String id,
    required String filePath,
    required DateTime createdAt,
    String? description,
  }) = _Document;
}
```

#### Presentation Layer (Always Create)
- ✅ Create screens for each major UI state
- ✅ Use Controllers (AsyncNotifier) for state management
- ✅ Keep widgets focused on display

**Example:**
```dart
// lib/document_scanner/presentation/document_scanner_screen.dart
class DocumentScannerScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(documentScannerProvider);

    return state.when(
      loading: () => Center(child: CircularProgressIndicator()),
      error: (err, stack) => ErrorWidget(error: err),
      data: (document) => DocumentViewWidget(document: document),
    );
  }
}
```

#### Application Layer (When Needed)
- ✅ Create when you have orchestration logic
- ✅ Create when logic is shared across controllers
- ✅ Create for complex workflows

**Example:**
```dart
// lib/document_scanner/services/document_scanner_service.dart
class DocumentScannerService {
  final DocumentRepository _repository;

  DocumentScannerService(this._repository);

  Future<Document> scanAndSave(String imagePath) async {
    final document = await _repository.createDocument(imagePath);
    // Additional orchestration if needed
    return document;
  }
}
```

#### Data Layer (When Needed)
- ✅ Create when you have external data sources (APIs, local storage)
- ✅ Create repositories to abstract data access
- ✅ Use DTOs for API responses, convert to Domain Models

**Example:**
```dart
// lib/document_scanner/data/repositories/document_repository.dart
class DocumentRepository {
  final DocumentLocalDataSource _localDataSource;

  Future<Document> createDocument(String imagePath) async {
    final dto = await _localDataSource.saveDocument(imagePath);
    return dto.toDomain();
  }
}

// lib/document_scanner/data/datasources/document_local_datasource.dart
class DocumentLocalDataSource {
  Future<DocumentDTO> saveDocument(String imagePath) async {
    // Handle file operations
    return DocumentDTO(id: id, filePath: path, createdAt: DateTime.now());
  }
}
```

---

## 🔌 Riverpod Provider Architecture

### Provider Patterns Used

**1. AsyncNotifierProvider (State Management)**
```dart
final documentScannerProvider = AsyncNotifierProvider<
  DocumentScannerController,
  Document?
>(() => DocumentScannerController());

class DocumentScannerController extends AsyncNotifier<Document?> {
  @override
  FutureOr<Document?> build() async {
    return null;
  }

  Future<void> scanDocument() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() =>
      ref.read(documentRepositoryProvider).scanDocument()
    );
  }
}
```

**2. FutureProvider (One-time Data Fetching)**
```dart
final documentListProvider = FutureProvider<List<Document>>((ref) async {
  return ref.read(documentRepositoryProvider).getAllDocuments();
});
```

**3. StateProvider (Simple State)**
```dart
final selectedDocumentProvider = StateProvider<Document?>((ref) => null);
```

**4. Repository Provider**
```dart
final documentRepositoryProvider = Provider<DocumentRepository>((ref) {
  final localDataSource = ref.watch(documentLocalDataSourceProvider);
  return DocumentRepository(localDataSource);
});
```

---

## 📊 Communication Between Layers

### Presentation → Application → Domain → Data

```dart
// 1. User taps button in Presentation Layer
onPressed: () {
  ref.read(documentScannerProvider.notifier).scanDocument();
}

// 2. Controller calls service in Application Layer
class DocumentScannerController extends AsyncNotifier<Document?> {
  Future<void> scanDocument() async {
    final service = ref.read(documentScannerServiceProvider);
    state = await AsyncValue.guard(() => service.scanDocument());
  }
}

// 3. Service orchestrates logic and calls repository in Data Layer
class DocumentScannerService {
  Future<Document> scanDocument() async {
    final repository = ref.read(documentRepositoryProvider);
    return repository.scanDocument();
  }
}

// 4. Repository calls data source and returns Domain Model
class DocumentRepository {
  Future<Document> scanDocument() async {
    final dto = await _dataSource.scanDocument();
    return dto.toDomain(); // Convert to Domain Model
  }
}

// 5. Data source handles actual external operations
class DocumentLocalDataSource {
  Future<DocumentDTO> scanDocument() async {
    // Hardware access, API calls, file operations
    return DocumentDTO(...);
  }
}
```

---

## ✨ Best Practices

### Domain Layer
- ✅ Use Freezed for immutability
- ✅ Keep it framework-agnostic (no Flutter/Riverpod imports)
- ✅ Include equality and hash implementations
- ❌ Don't add business logic here (keep models simple)

### Presentation Layer
- ✅ Use ConsumerWidget for Riverpod integration
- ✅ Use AsyncValue.when() for loading/error/data states
- ✅ Keep widgets small and focused
- ❌ Don't fetch data directly (use controllers/providers)

### Application Layer
- ✅ Use Riverpod providers for dependency injection
- ✅ Keep services stateless when possible
- ✅ Orchestrate complex workflows
- ❌ Don't include UI logic

### Data Layer
- ✅ Keep repositories simple (single responsibility)
- ✅ Use DTOs for external API responses
- ✅ Convert DTOs to Domain Models
- ❌ Don't expose implementation details to upper layers

---

## 🚀 Feature Template

When creating a new feature, use this structure:

```
lib/[feature_name]/
├── domain/
│   ├── [feature]_model.dart          # Freezed immutable model
│   └── [feature]_model.freezed.dart  # Generated file
├── presentation/
│   ├── [feature]_screen.dart         # Main screen
│   ├── [feature]_controller.dart     # (Optional) AsyncNotifier
│   └── widgets/                      # (Optional) Reusable components
│       └── [feature]_card.dart
├── services/                         # (Optional) Application layer
│   └── [feature]_service.dart
├── data/                             # (Optional) Data layer
│   ├── repositories/
│   │   └── [feature]_repository.dart
│   ├── datasources/
│   │   └── [feature]_datasource.dart
│   └── models/
│       └── [feature]_dto.dart
└── docs/
    └── feature_specification.md      # Feature documentation
```

---

## 📚 Reference

- **Flutter Riverpod Guide:** https://codewithandrea.com/articles/flutter-app-architecture-riverpod-introduction/
- **Clean Architecture Principles:** Separation of concerns, testability, maintainability
- **Freezed Package:** Immutable data classes with code generation

---

## 🔄 Next Steps for Current Features

### Priority 1: Refactor Document Scanner
- [ ] Extract domain model (Document) with Freezed
- [ ] Create presentation screens with controllers
- [ ] Extract business logic to services
- [ ] Create data layer with repositories

### Priority 2: Complete Location Feature
- [ ] Create domain models (Location, Route)
- [ ] Add presentation layer structure
- [ ] Formalize data repositories

### Priority 3: Standardize All Features
- [ ] Apply same architecture pattern to Sensors, Bluetooth, Storage
- [ ] Add proper state management with Riverpod
- [ ] Document each feature following this pattern

