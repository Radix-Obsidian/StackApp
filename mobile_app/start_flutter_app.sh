#!/bin/bash

# StackApp Flutter App Startup Script
# This script helps you start the Flutter app with the backend

echo "🎤 StackApp Flutter App Startup"
echo "================================"

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "   Please install Flutter: https://flutter.dev/docs/get-started/install"
    exit 1
fi

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ pubspec.yaml not found. Please run this script from the mobile_app directory"
    exit 1
fi

echo "✅ Flutter found: $(flutter --version | head -n 1)"

# Install dependencies
echo "📦 Installing Flutter dependencies..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed successfully"

# Check if backend is running
echo "🔍 Checking if StackApp backend is running..."
if curl -s http://localhost:8000/health > /dev/null; then
    echo "✅ Backend is running"
else
    echo "⚠️  Backend is not running"
    echo "   Please start the backend first:"
    echo "   cd .. && python start_stackapp_huggingface.py"
    echo ""
    echo "   Or start it in another terminal and press Enter to continue..."
    read -p "Press Enter when backend is ready..."
fi

# Run the Flutter app
echo "🚀 Starting Flutter app..."
echo "   The app will connect to: http://localhost:8000"
echo ""

flutter run

echo ""
echo "👋 Flutter app stopped. Keep stacking your bread! 💰"
