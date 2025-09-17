# StackApp Flutter Frontend

The mobile frontend for StackApp - The Black Community's Financial Powerhouse.

## 🚀 Quick Start

### Prerequisites
- Flutter 3.10.0 or higher
- Dart 3.0.0 or higher
- Android Studio / Xcode for mobile development

### Setup
1. Navigate to the mobile_app directory:
   ```bash
   cd mobile_app
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Start the StackApp backend:
   ```bash
   # From the main StackApp directory
   python start_stackapp_huggingface.py
   ```

4. Run the Flutter app:
   ```bash
   flutter run
   ```

## 📱 Features

### Core Features
- **Stack Master Chat**: AI-powered financial coaching with cultural awareness
- **Investment Dashboard**: Portfolio tracking and investment advice
- **Community Challenges**: Stack building challenges and success stories
- **Financial Education**: Educational content and tips

### Design System
- **Dark Theme**: Optimized for StackApp's brand colors
- **Cultural UI**: Designed specifically for the Black community
- **Responsive**: Works on all screen sizes
- **Accessible**: Follows accessibility guidelines

## 🎨 Brand Colors
- **Primary Black**: #1A1A1A
- **Gold**: #FFD700
- **Green**: #00FF00
- **Dark Background**: #0F0F0F
- **Surface**: #2A2A2A

## 🔧 Architecture

### State Management
- **Provider**: For state management across the app
- **StackMasterProvider**: Manages chat state and API calls

### API Integration
- **StackAppApiClient**: Connects to the StackApp backend
- **Models**: Type-safe data models for API responses
- **Error Handling**: Comprehensive error handling and user feedback

### Navigation
- **Bottom Navigation**: Easy access to all main features
- **Tab Navigation**: Organized content within screens

## 📁 Project Structure
```
lib/
├── core/
│   ├── api/           # API client and network layer
│   ├── models/        # Data models
│   ├── providers/     # State management
│   └── theme/         # App theme and design system
├── features/
│   ├── navigation/    # App navigation
│   ├── stack_master/  # AI chat interface
│   ├── investment/    # Investment features
│   ├── community/     # Community features
│   ├── education/     # Financial education
│   └── shared/        # Shared widgets and components
└── main.dart          # App entry point
```

## 🔌 Backend Integration

The Flutter app connects to your existing StackApp backend:

- **Base URL**: `http://localhost:8000` (development)
- **API Endpoints**: All StackApp API endpoints
- **Real-time**: WebSocket support for live updates
- **Authentication**: User management and sessions

## 🚀 Development

### Running in Development
```bash
flutter run --debug
```

### Building for Production
```bash
# Android
flutter build apk --release

# iOS
flutter build ios --release
```

### Testing
```bash
flutter test
```

## 📱 Platform Support
- **iOS**: 12.0+
- **Android**: API level 21+ (Android 5.0)

## 🎯 Next Steps
1. Add authentication system
2. Implement real-time notifications
3. Add offline capabilities
4. Integrate with Supabase
5. Add biometric authentication
6. Implement push notifications

## 💰 StackApp Mission
"Stack Your Bread, Stack Your Future" - Empowering the Black community to build generational wealth through AI-powered financial coaching and community support.
