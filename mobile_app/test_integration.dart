// Test script to verify Flutter app integration with StackApp backend
// Run this with: dart test_integration.dart

import 'dart:convert';
import 'dart:io';

void main() async {
  print('🧪 Testing StackApp Flutter Integration');
  print('=' * 50);
  
  // Test 1: Health Check
  print('\n1. Testing backend health check...');
  try {
    final response = await HttpClient().getUrl(
      Uri.parse('http://localhost:8000/health')
    ).then((request) => request.close());
    
    if (response.statusCode == 200) {
      print('✅ Backend is running and healthy');
    } else {
      print('❌ Backend returned status: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Cannot connect to backend: $e');
    print('   Make sure to start the backend with: python start_stackapp_huggingface.py');
  }
  
  // Test 2: Root endpoint
  print('\n2. Testing root endpoint...');
  try {
    final response = await HttpClient().getUrl(
      Uri.parse('http://localhost:8000/')
    ).then((request) => request.close());
    
    if (response.statusCode == 200) {
      final body = await response.transform(utf8.decoder).join();
      final data = jsonDecode(body);
      print('✅ Root endpoint working');
      print('   App: ${data['app']}');
      print('   Version: ${data['version']}');
      print('   AI Coach: ${data['ai_coach']}');
    } else {
      print('❌ Root endpoint failed: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Root endpoint error: $e');
  }
  
  // Test 3: Stack Master Chat
  print('\n3. Testing Stack Master chat...');
  try {
    final request = await HttpClient().postUrl(
      Uri.parse('http://localhost:8000/stack-master/chat')
    );
    
    request.headers.set('Content-Type', 'application/json');
    request.write(jsonEncode({
      'user_id': 'test_user_123',
      'message': 'Hello Stack Master!',
      'context': {}
    }));
    
    final response = await request.close();
    
    if (response.statusCode == 200) {
      final body = await response.transform(utf8.decoder).join();
      final data = jsonDecode(body);
      print('✅ Stack Master chat working');
      print('   Response: ${data['response'].substring(0, 50)}...');
      print('   Advice Type: ${data['advice_type']}');
    } else {
      print('❌ Stack Master chat failed: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Stack Master chat error: $e');
  }
  
  // Test 4: Community Challenges
  print('\n4. Testing community challenges...');
  try {
    final response = await HttpClient().getUrl(
      Uri.parse('http://localhost:8000/community/stack-challenges')
    ).then((request) => request.close());
    
    if (response.statusCode == 200) {
      final body = await response.transform(utf8.decoder).join();
      final data = jsonDecode(body);
      print('✅ Community challenges working');
      print('   Challenges available: ${data['challenges'].length}');
    } else {
      print('❌ Community challenges failed: ${response.statusCode}');
    }
  } catch (e) {
    print('❌ Community challenges error: $e');
  }
  
  print('\n' + '=' * 50);
  print('🎯 Integration test complete!');
  print('📱 Your Flutter app is ready to connect to the StackApp backend');
  print('💰 Start the backend and run: flutter run');
}
