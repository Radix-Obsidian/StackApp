#!/usr/bin/env python3
"""
StackApp API Test Script
Test the core functionality of the StackApp MVP
"""

import requests
import json
import time
from datetime import datetime

# API Configuration
API_BASE_URL = "http://localhost:8000"
TEST_USER_ID = "test_user_123"

def test_health_check():
    """Test the health check endpoint"""
    print("🔍 Testing health check...")
    try:
        response = requests.get(f"{API_BASE_URL}/health")
        if response.status_code == 200:
            print("✅ Health check passed")
            return True
        else:
            print(f"❌ Health check failed: {response.status_code}")
            return False
    except requests.exceptions.ConnectionError:
        print("❌ Cannot connect to API - make sure it's running")
        return False

def test_root_endpoint():
    """Test the root endpoint"""
    print("🔍 Testing root endpoint...")
    try:
        response = requests.get(f"{API_BASE_URL}/")
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Root endpoint working - {data['app']} v{data['version']}")
            print(f"   Tagline: {data['tagline']}")
            return True
        else:
            print(f"❌ Root endpoint failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Root endpoint error: {e}")
        return False

def test_stack_master_chat():
    """Test Stack Master chat functionality"""
    print("🔍 Testing Stack Master chat...")
    try:
        payload = {
            "user_id": TEST_USER_ID,
            "message": "Yo, I got $500 and want to start stacking. What should I do?",
            "context": {
                "income": 3000,
                "savings": 500,
                "goals": ["build wealth", "invest"]
            }
        }
        
        response = requests.post(
            f"{API_BASE_URL}/stack-master/chat",
            json=payload,
            headers={"Content-Type": "application/json"}
        )
        
        if response.status_code == 200:
            data = response.json()
            print("✅ Stack Master chat working")
            print(f"   Response: {data['response'][:100]}...")
            print(f"   Advice type: {data['advice_type']}")
            return True
        else:
            print(f"❌ Stack Master chat failed: {response.status_code}")
            print(f"   Error: {response.text}")
            return False
    except Exception as e:
        print(f"❌ Stack Master chat error: {e}")
        return False

def test_stack_analysis():
    """Test stack analysis functionality"""
    print("🔍 Testing stack analysis...")
    try:
        payload = {
            "user_id": TEST_USER_ID,
            "current_income": 3000,
            "current_savings": 500,
            "monthly_expenses": 2000,
            "credit_score": 650,
            "investment_goals": ["build wealth", "buy house"],
            "risk_tolerance": "moderate"
        }
        
        response = requests.post(
            f"{API_BASE_URL}/stack-master/analyze-stack",
            json=payload,
            headers={"Content-Type": "application/json"}
        )
        
        if response.status_code == 200:
            data = response.json()
            print("✅ Stack analysis working")
            print(f"   Analysis: {data['analysis'][:100]}...")
            return True
        else:
            print(f"❌ Stack analysis failed: {response.status_code}")
            print(f"   Error: {response.text}")
            return False
    except Exception as e:
        print(f"❌ Stack analysis error: {e}")
        return False

def test_investment_advice():
    """Test investment advice functionality"""
    print("🔍 Testing investment advice...")
    try:
        payload = {
            "user_id": TEST_USER_ID,
            "amount_to_invest": 1000,
            "investment_horizon": "long-term",
            "risk_tolerance": "moderate",
            "investment_type": "stocks"
        }
        
        response = requests.post(
            f"{API_BASE_URL}/investment/advice",
            json=payload,
            headers={"Content-Type": "application/json"}
        )
        
        if response.status_code == 200:
            data = response.json()
            print("✅ Investment advice working")
            print(f"   Advice: {data['advice'][:100]}...")
            return True
        else:
            print(f"❌ Investment advice failed: {response.status_code}")
            print(f"   Error: {response.text}")
            return False
    except Exception as e:
        print(f"❌ Investment advice error: {e}")
        return False

def test_credit_building():
    """Test credit building functionality"""
    print("🔍 Testing credit building...")
    try:
        payload = {
            "user_id": TEST_USER_ID,
            "current_score": 580,
            "current_debt": 5000,
            "monthly_income": 3000,
            "goals": ["improve credit", "buy house"]
        }
        
        response = requests.post(
            f"{API_BASE_URL}/credit/building-plan",
            json=payload,
            headers={"Content-Type": "application/json"}
        )
        
        if response.status_code == 200:
            data = response.json()
            print("✅ Credit building working")
            print(f"   Plan: {data['plan'][:100]}...")
            return True
        else:
            print(f"❌ Credit building failed: {response.status_code}")
            print(f"   Error: {response.text}")
            return False
    except Exception as e:
        print(f"❌ Credit building error: {e}")
        return False

def test_community_features():
    """Test community features"""
    print("🔍 Testing community features...")
    try:
        # Test challenges
        response = requests.get(f"{API_BASE_URL}/community/stack-challenges")
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Stack challenges working - {len(data['challenges'])} challenges")
        else:
            print(f"❌ Stack challenges failed: {response.status_code}")
            return False
        
        # Test success stories
        response = requests.get(f"{API_BASE_URL}/community/success-stories")
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Success stories working - {len(data['stories'])} stories")
        else:
            print(f"❌ Success stories failed: {response.status_code}")
            return False
        
        return True
    except Exception as e:
        print(f"❌ Community features error: {e}")
        return False

def test_education_features():
    """Test education features"""
    print("🔍 Testing education features...")
    try:
        response = requests.get(f"{API_BASE_URL}/education/topics")
        if response.status_code == 200:
            data = response.json()
            print(f"✅ Education topics working - {len(data['topics'])} topics")
            return True
        else:
            print(f"❌ Education topics failed: {response.status_code}")
            return False
    except Exception as e:
        print(f"❌ Education features error: {e}")
        return False

def main():
    """Run all tests"""
    print("🎤 StackApp API Test Suite")
    print("=" * 50)
    
    tests = [
        ("Health Check", test_health_check),
        ("Root Endpoint", test_root_endpoint),
        ("Stack Master Chat", test_stack_master_chat),
        ("Stack Analysis", test_stack_analysis),
        ("Investment Advice", test_investment_advice),
        ("Credit Building", test_credit_building),
        ("Community Features", test_community_features),
        ("Education Features", test_education_features),
    ]
    
    passed = 0
    total = len(tests)
    
    for test_name, test_func in tests:
        print(f"\n📋 {test_name}")
        print("-" * 30)
        if test_func():
            passed += 1
        time.sleep(1)  # Small delay between tests
    
    print("\n" + "=" * 50)
    print(f"🎯 Test Results: {passed}/{total} tests passed")
    
    if passed == total:
        print("🎉 All tests passed! StackApp API is working perfectly!")
        print("💰 Ready to help the community stack their bread!")
    else:
        print("⚠️  Some tests failed. Check the API configuration and try again.")
    
    print("\n🎤 StackApp - Stack Your Bread, Stack Your Future! 💰")

if __name__ == "__main__":
    main()
