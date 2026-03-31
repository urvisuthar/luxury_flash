# Luxury Flash

A high-performance, premium Flutter application for exclusive product drops. Featuring real-time price tracking, sophisticated animations, and a robust Clean Architecture aligned with industrial standards.

![Luxury Flash Logo](assets/images/logo.png)

## 🚀 Features

- **Live Performance Chart**: High-frequency real-time price tracking using `CustomPainter` with optimized sliding window rendering (300 points).
- **Interactive "Hold to Buy"**: A sophisticated button interaction with state-based morphing (Idle, Holding, Processing, Success) and haptic feedback.
- **Isolate-Powered Data**: Heavy JSON parsing and historical data generation (50,000+ points) handled via Dart Isolates to maintain a smooth 60 FPS.
- **Enterprise Architecture**: 100% Clean Architecture compliance with BLoC state management and functional error handling (`fpdart`).

## 🏗️ Architecture

The project follows the [Clean Architecture](ARCHITECTURE.md) pattern, divided into four distinct layers:

1.  **Core**: Base abstractions, error handling, and `UseCase` interfaces.
2.  **Domain**: Enterprise business logic, entities, and repository contracts.
3.  **Data**: Repository implementations, data sources (SIM-powered), and DTO mapping.
4.  **Presentation**: BLoC-driven UI, custom painters, and page layouts.

For more details, see the [Architecture Documentation](ARCHITECTURE.md).

## 🛠️ Tech Stack

- **State Management**: [flutter_bloc](https://pub.dev/packages/flutter_bloc)
- **Dependency Injection**: [get_it](https://pub.dev/packages/get_it)
- **Functional Programming**: [fpdart](https://pub.dev/packages/fpdart)
- **Value Equality**: [equatable](https://pub.dev/packages/equatable)
- **Localization**: [intl](https://pub.dev/packages/intl)
- **Assets**: [flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons)

## 📦 Getting Started

### Prerequisites
- Flutter SDK (^3.9.2)
- Dart SDK (^3.0.0)

### Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/urvisuthar/luxury_flash.git
   ```
2. Fetch dependencies:
   ```bash
   flutter pub get
   ```
3. Run the application:
   ```bash
   flutter run
   ```

## 📈 Performance Optimization

To ensure a premium "FinTech" feel, the application employs several optimization strategies:
- **Compute( )**: Heavy calculations are moved off the main thread.
- **RepaintBoundary**: Used strategically to isolate expensive UI sections like the live chart.
- **Sliding Window**: The BLoC maintains a fixed-size buffer for real-time data to prevent memory bloat and over-painting.

---
Developed with ❤️ by [Urvi Suthar](https://github.com/urvisuthar)
