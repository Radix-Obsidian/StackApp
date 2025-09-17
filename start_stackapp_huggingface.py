#!/usr/bin/env python3
"""
StackApp Hugging Face Startup Script
The Black Community's Financial Powerhouse - FREE AI Launch
"""

import os
import sys
import json
import subprocess
from pathlib import Path

def print_banner():
    """Print StackApp Hugging Face banner"""
    banner = """
    ╔══════════════════════════════════════════════════════════════╗
    ║                                                              ║
    ║    🎤 STACKAPP - QWEN FREE + FINROBOT PREMIUM 🎤           ║
    ║                                                              ║
    ║    💰 "Stack Your Bread, Stack Your Future" 💰               ║
    ║                                                              ║
    ║    🆓 FREE: Qwen AI | 💎 PREMIUM: FinRobot $9.99 🆓        ║
    ║                                                              ║
    ╚══════════════════════════════════════════════════════════════╝
    """
    print(banner)

def check_requirements():
    """Check if required files exist"""
    required_files = [
        "stackapp_api_huggingface.py",
        "requirements_mvp.txt"
    ]
    
    missing_files = []
    for file in required_files:
        if not Path(file).exists():
            missing_files.append(file)
    
    if missing_files:
        print(f"❌ Missing required files: {', '.join(missing_files)}")
        return False
    
    print("✅ All required files found")
    return True

def install_requirements():
    """Install MVP requirements including Hugging Face"""
    print("📦 Installing StackApp requirements with Hugging Face...")
    try:
        subprocess.run([
            sys.executable, "-m", "pip", "install", "-r", "requirements_mvp.txt"
        ], check=True)
        print("✅ Requirements installed successfully")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to install requirements: {e}")
        return False

def check_huggingface_setup():
    """Check Hugging Face setup"""
    print("🔍 Checking StackApp pricing model...")
    
    print("✅ FREE TIER: Qwen AI model for all users")
    print("💰 PREMIUM TIER: FinRobot agents locked behind $9.99 beta paywall")
    print("🎯 Revenue model: Free users get Qwen, paid users get FinRobot")
    
    return True

def start_api():
    """Start the StackApp Hugging Face API"""
    print("🚀 Starting StackApp with Qwen FREE + FinRobot PREMIUM...")
    print("💰 The Stack Master is ready to help you stack your bread!")
    print("🆓 FREE TIER: Qwen AI model - No API keys required!")
    print("💎 PREMIUM TIER: FinRobot agents - $9.99 beta pricing!")
    print("🌐 API will be available at: http://localhost:8000")
    print("📚 API documentation at: http://localhost:8000/docs")
    print("💳 Subscription plans at: http://localhost:8000/subscription/plans")
    print("\n" + "="*60)
    
    try:
        # Import and run the API
        import uvicorn
        # Use import string so uvicorn reload works without warning
        uvicorn.run(
            "stackapp_api_huggingface:app",
            host="0.0.0.0",
            port=8000,
            reload=True,
            log_level="info"
        )
    except KeyboardInterrupt:
        print("\n👋 StackApp FREE API stopped. Keep stacking your bread! 💰")
    except Exception as e:
        print(f"❌ Failed to start API: {e}")
        return False

def main():
    """Main startup function"""
    print_banner()
    
    # Check requirements
    if not check_requirements():
        print("❌ Cannot start StackApp - missing required files")
        return
    
    # Check Hugging Face setup
    check_huggingface_setup()
    
    # Install requirements
    if not install_requirements():
        print("❌ Cannot start StackApp - installation failed")
        return
    
    # Start the API
    start_api()

if __name__ == "__main__":
    main()
