# Luxury Flash Drop Architecture (Aligned with test_app)

This project implements a high-performance "Flash Drop" feature, standardized to match the architectural patterns of `test_app`.

## Tech Stack
- **Flutter**: UI Framework.
- **Bloc**: State management using standard `BlocProvider` and `MultiBlocProvider`.
- **GetIt**: Service locator (`serviceLocator`) for dependency injection.
- **fpdart**: Functional programming primitives like `Either` for error handling.
- **Equatable**: Value equality for objects.
- **Dart Isolates**: Background processing for heavy data via `compute()`.
- **Flutter Launcher Icons**: Standardized asset management for app icons.

## Architecture Layers

### 1. Core Layer (`lib/core`)
Cross-cutting concerns and base abstractions.
- **Error**: `Failure` and `Exception` definitions.
- **UseCase**: `Usecase` and `StreamUsecase` interfaces.

### 2. Domain Layer (`lib/features/flash_drop/domain`)
Enterprise-level business logic.
- **Entities**: Business models (`FlashProduct`, `PricePoint`).
- **Repositories**: Abstract contracts for data access.
- **UseCases**: Granular business actions (`GetFlashProduct`, `GetFlashProductUpdates`, `BuyFlashProduct`).

### 3. Data Layer (`lib/features/flash_drop/data`)
Implementation of data retrieval and mapping.
- **Models**: Data transfer objects with JSON logic (`FlashProductModel`).
- **Data Sources**: Low-level data access (Isolate-powered simulator in `FlashRemoteDataSource`).
- **Repositories**: Implementations that catch exceptions and return `Either<Failure, T>`.

### 4. Presentation Layer (`lib/features/flash_drop/presentation`)
UI and interaction logic.
- **Bloc**: Manages state using UseCases and functional `.fold()` transitions.
- **Widgets**: Reusable components like `HoldToBuyButton` and `LiveChartPainter`.
- **Pages**: Feature entry points (`FlashDropPage`).

## Initialization
Dependency injection is centralized in `lib/init_dependency.dart` using a modular approach (`_initFlashDrop()`), matching the structure of `test_app`.

## Performance Strategies
- **Background Isolates**: Large data generation (50,000 records) is handled via `compute()` in the data source to maintain 60 FPS.
- **Sliding Window Rendering**: A 300-point sliding window in the BLoC state (`_maxWindowSize = 300`) optimizes the `CustomPainter` workload.
- **Real-time Streams**: Price updates are pushed via `StreamSubscription` to ensure reactive UI without full page rebuilds.
