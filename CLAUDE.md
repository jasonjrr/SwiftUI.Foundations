# SwiftUI.Foundations Framework Guide

## Overview
SwiftUI.Foundations is a comprehensive framework providing core utilities, design patterns, and infrastructure for SwiftUI applications. It's organized into modular libraries that can be used independently.

## Core Libraries

### 1. SwiftUIFoundation
**Purpose**: Base utilities and extensions for SwiftUI and Combine
**Key Components**:
- SwiftUI view modifiers and extensions
- Combine reactive patterns
- Custom bindings and state management helpers
- Common view utilities

**Dependencies**: CombineExt

### 2. SwiftUIDesignSystem
**Purpose**: Reusable UI components and design tokens
**Key Components**:
- Custom SwiftUI components
- Design tokens (colors, typography, spacing)
- Common layouts and patterns
- Themed components

**Dependencies**: SwiftUIFoundation, SUIFNetworking, SUIFTelemetry, CombineExt

### 3. SUIFBluetoothConnectivity
**Purpose**: Bluetooth communication and device connectivity
**Key Components**:
- BLE peripheral discovery
- Connection management
- Data transmission utilities

**Dependencies**: SwiftUIFoundation, CombineExt

### 4. SUIFKeychain
**Purpose**: Secure credential and sensitive data storage
**Key Components**:
- Keychain wrapper for secure storage
- Credential management
- Password management utilities

**Dependencies**: SwiftUIFoundation, CombineExt

### 5. SUIFNetworking
**Purpose**: Network operations and API communication
**Key Components**:
- URLSession wrapper
- API client patterns
- Request/response handling
- Network error handling

**Dependencies**: SwiftUIFoundation, CombineExt

### 6. SUIFServerDrivenUI
**Purpose**: Server-driven UI configuration and rendering
**Key Components**:
- Remote configuration handling
- Dynamic UI generation
- Layout directives from server

**Dependencies**: SwiftUIFoundation, CombineExt

### 7. SUIFTelemetry
**Purpose**: Analytics, logging, and crash reporting integration
**Key Components**:
- Analytics event tracking
- Crash reporting setup
- Performance monitoring
- User tracking

**Dependencies**: SwiftUIFoundation, CombineExt

### 8. SUIFUserDefaults
**Purpose**: Type-safe UserDefaults wrapper with reactive bindings
**Key Components**:
- Property wrapper for UserDefaults
- Reactive value updates
- Type safety helpers

**Dependencies**: SwiftUIFoundation

## Development Guidelines

### When to Use Each Library
- **SwiftUIFoundation**: Always; base utilities everyone needs
- **SUIFTelemetry**: For apps requiring analytics/crash reporting
- **SUIFUserDefaults**: For app preference storage
- **SUIFNetworking**: For apps making API calls
- **SUIFKeychain**: For secure credential storage
- **SUIFBluetoothConnectivity**: For BLE-enabled apps
- **SwiftUIDesignSystem**: For consistent UI/theme management
- **SUIFServerDrivenUI**: For dynamic UI from backend

### Adding New Utilities
1. Determine which library is most appropriate
2. Add code to `Sources/[LibraryName]/`
3. Add tests to `Tests/` if applicable
4. Export from library's public API

### Testing
- Unit tests in `Tests/SwiftUIFoundationTests/`
- Add tests for new utilities

## Platform Support
- **iOS**: 17+
- **macOS**: 13+
- **Swift**: 5.10+

## Dependencies
- **CombineExt**: Extended Combine operators and utilities

## Usage in KT-Cards
KT-Cards imports:
- `SwiftUIFoundation`: Core view utilities
- `SUIFTelemetry`: Analytics integration
- `SUIFUserDefaults`: User preferences
- See `KT-Cards/Packages/KTCardsFoundation/Package.swift` for exact versions

## Android Equivalent
For Android, consider:
- **Jetpack Compose** for UI framework
- **Hilt** for dependency injection
- **DataStore** for preferences (SUIFUserDefaults equivalent)
- **Retrofit/OkHttp** for networking (SUIFNetworking equivalent)
- **Firebase Analytics/Crashlytics** for telemetry (SUIFTelemetry equivalent)
