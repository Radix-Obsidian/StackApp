#!/usr/bin/env python3
"""
StackApp Startup Script
The Black Community's Financial Powerhouse - MVP Launch
"""

import os
import sys
import json
import subprocess
from pathlib import Path

def print_banner():
    """Print StackApp banner"""
    banner = """
    ╔══════════════════════════════════════════════════════════════╗
    ║                                                              ║
    ║    🎤 STACKAPP - THE BLACK COMMUNITY'S FINANCIAL POWERHOUSE  ║
    ║                                                              ║
    ║    💰 "Stack Your Bread, Stack Your Future" 💰               ║
    ║                                                              ║
    ║    🚀 MVP Version 1.0.0 - Ready to Stack! 🚀                ║
    ║                                                              ║
    ╚══════════════════════════════════════════════════════════════╝
    """
    print(banner)

def check_requirements():
    """Check if required files exist"""
    required_files = [
        "stackapp_api.py",
        "stackapp_config.json", 
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

def check_api_keys():
    """Check if API keys are configured"""
    api_key_files = [
        "OAI_CONFIG_LIST",
        "config_api_keys"
    ]
    
    missing_keys = []
    for file in api_key_files:
        if not Path(file).exists():
            missing_keys.append(file)
    
    if missing_keys:
        print(f"⚠️  Warning: API key files missing: {', '.join(missing_keys)}")
        print("   Some features may not work without proper API keys")
        print("   Please configure your API keys before using StackApp")
        return False
    
    print("✅ API keys configured")
    return True

def install_requirements():
    """Install MVP requirements"""
    print("📦 Installing StackApp MVP requirements...")
    try:
        subprocess.run([
            sys.executable, "-m", "pip", "install", "-r", "requirements_mvp.txt"
        ], check=True)
        print("✅ Requirements installed successfully")
        return True
    except subprocess.CalledProcessError as e:
        print(f"❌ Failed to install requirements: {e}")
        return False

def load_config():
    """Load StackApp configuration"""
    try:
        with open("stackapp_config.json", "r") as f:
            config = json.load(f)
        print(f"✅ Loaded configuration for {config['app']['name']}")
        return config
    except Exception as e:
        print(f"❌ Failed to load configuration: {e}")
        return None

def start_api():
    """Start the StackApp API"""
    print("🚀 Starting StackApp API...")
    print("💰 The Stack Master is ready to help you stack your bread!")
    print("🌐 API will be available at: http://localhost:8000")
    print("📚 API documentation at: http://localhost:8000/docs")
    print("\n" + "="*60)
    
    try:
        # Import and run the API
        import uvicorn
        from stackapp_api import app
        
        uvicorn.run(
            app,
            host="0.0.0.0",
            port=8000,
            reload=True,
            log_level="info"
        )
    except KeyboardInterrupt:
        print("\n👋 StackApp API stopped. Keep stacking your bread! 💰")
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
    
    # Check API keys
    check_api_keys()
    
    # Load configuration
    config = load_config()
    if not config:
        print("❌ Cannot start StackApp - configuration error")
        return
    
    # Install requirements
    if not install_requirements():
        print("❌ Cannot start StackApp - installation failed")
        return
    
    # Start the API
    start_api()

if __name__ == "__main__":
    main()
