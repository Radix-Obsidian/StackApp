# 🎤 StackApp Frontend Integration Guide

## 💰 Connecting Your Frontend to StackApp Backend

This guide will help you integrate your React Native frontend with the StackApp API backend.

## 🚀 Quick Setup

### 1. Start the Backend
```bash
# In the StackApp backend directory
python start_stackapp.py
```

The API will be available at: `http://localhost:8000`

### 2. Frontend Configuration

#### API Base URL
```javascript
const API_BASE_URL = 'http://localhost:8000'; // Development
// const API_BASE_URL = 'https://your-production-api.com'; // Production
```

#### API Client Setup
```javascript
// api/stackapp.js
import axios from 'axios';

const api = axios.create({
  baseURL: API_BASE_URL,
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json',
  },
});

export default api;
```

## 🎯 Core API Endpoints

### 1. Stack Master AI Coach

#### Chat with The Stack Master
```javascript
// Chat with the AI coach
const chatWithStackMaster = async (message, userId, context = {}) => {
  try {
    const response = await api.post('/stack-master/chat', {
      user_id: userId,
      message: message,
      context: context
    });
    return response.data;
  } catch (error) {
    console.error('Stack Master chat error:', error);
    throw error;
  }
};

// Usage in your component
const handleChat = async () => {
  const response = await chatWithStackMaster(
    "Yo, I got $500 and want to start stacking. What should I do?",
    "user123",
    { income: 3000, savings: 500 }
  );
  
  console.log('Stack Master response:', response.response);
  console.log('Advice type:', response.advice_type);
};
```

#### Analyze User's Financial Stack
```javascript
const analyzeStack = async (userId, financialData) => {
  try {
    const response = await api.post('/stack-master/analyze-stack', {
      user_id: userId,
      current_income: financialData.income,
      current_savings: financialData.savings,
      monthly_expenses: financialData.expenses,
      credit_score: financialData.creditScore,
      investment_goals: financialData.goals,
      risk_tolerance: financialData.riskTolerance
    });
    return response.data;
  } catch (error) {
    console.error('Stack analysis error:', error);
    throw error;
  }
};
```

### 2. Investment Features

#### Get Investment Advice
```javascript
const getInvestmentAdvice = async (userId, investmentData) => {
  try {
    const response = await api.post('/investment/advice', {
      user_id: userId,
      amount_to_invest: investmentData.amount,
      investment_horizon: investmentData.horizon,
      risk_tolerance: investmentData.riskTolerance,
      investment_type: investmentData.type
    });
    return response.data;
  } catch (error) {
    console.error('Investment advice error:', error);
    throw error;
  }
};
```

#### Analyze Specific Stock
```javascript
const analyzeStock = async (ticker) => {
  try {
    const response = await api.get(`/investment/stock-analysis/${ticker}`);
    return response.data;
  } catch (error) {
    console.error('Stock analysis error:', error);
    throw error;
  }
};
```

### 3. Credit Building

#### Create Credit Building Plan
```javascript
const createCreditPlan = async (userId, creditData) => {
  try {
    const response = await api.post('/credit/building-plan', {
      user_id: userId,
      current_score: creditData.score,
      current_debt: creditData.debt,
      monthly_income: creditData.income,
      goals: creditData.goals
    });
    return response.data;
  } catch (error) {
    console.error('Credit plan error:', error);
    throw error;
  }
};
```

### 4. Community Features

#### Get Stack Challenges
```javascript
const getStackChallenges = async () => {
  try {
    const response = await api.get('/community/stack-challenges');
    return response.data.challenges;
  } catch (error) {
    console.error('Challenges error:', error);
    throw error;
  }
};
```

#### Get Success Stories
```javascript
const getSuccessStories = async () => {
  try {
    const response = await api.get('/community/success-stories');
    return response.data.stories;
  } catch (error) {
    console.error('Success stories error:', error);
    throw error;
  }
};
```

### 5. Education

#### Get Education Topics
```javascript
const getEducationTopics = async () => {
  try {
    const response = await api.get('/education/topics');
    return response.data.topics;
  } catch (error) {
    console.error('Education topics error:', error);
    throw error;
  }
};
```

## 🎤 React Native Component Examples

### Stack Master Chat Component
```javascript
import React, { useState, useEffect } from 'react';
import { View, Text, TextInput, TouchableOpacity, ScrollView } from 'react-native';
import { chatWithStackMaster } from '../api/stackapp';

const StackMasterChat = ({ userId }) => {
  const [messages, setMessages] = useState([]);
  const [inputMessage, setInputMessage] = useState('');
  const [isLoading, setIsLoading] = useState(false);

  const sendMessage = async () => {
    if (!inputMessage.trim()) return;

    const userMessage = {
      id: Date.now(),
      text: inputMessage,
      sender: 'user',
      timestamp: new Date()
    };

    setMessages(prev => [...prev, userMessage]);
    setInputMessage('');
    setIsLoading(true);

    try {
      const response = await chatWithStackMaster(inputMessage, userId);
      
      const aiMessage = {
        id: Date.now() + 1,
        text: response.response,
        sender: 'stack_master',
        adviceType: response.advice_type,
        timestamp: new Date()
      };

      setMessages(prev => [...prev, aiMessage]);
    } catch (error) {
      console.error('Chat error:', error);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <View style={styles.container}>
      <ScrollView style={styles.messagesContainer}>
        {messages.map((message) => (
          <View key={message.id} style={[
            styles.message,
            message.sender === 'user' ? styles.userMessage : styles.aiMessage
          ]}>
            <Text style={styles.messageText}>{message.text}</Text>
            {message.adviceType && (
              <Text style={styles.adviceType}>Type: {message.adviceType}</Text>
            )}
          </View>
        ))}
        {isLoading && (
          <View style={styles.loadingMessage}>
            <Text>The Stack Master is thinking...</Text>
          </View>
        )}
      </ScrollView>
      
      <View style={styles.inputContainer}>
        <TextInput
          style={styles.textInput}
          value={inputMessage}
          onChangeText={setInputMessage}
          placeholder="Ask The Stack Master anything..."
          multiline
        />
        <TouchableOpacity style={styles.sendButton} onPress={sendMessage}>
          <Text style={styles.sendButtonText}>Send</Text>
        </TouchableOpacity>
      </View>
    </View>
  );
};

const styles = {
  container: {
    flex: 1,
    backgroundColor: '#1a1a1a',
  },
  messagesContainer: {
    flex: 1,
    padding: 16,
  },
  message: {
    padding: 12,
    marginVertical: 4,
    borderRadius: 8,
    maxWidth: '80%',
  },
  userMessage: {
    backgroundColor: '#ffd700',
    alignSelf: 'flex-end',
  },
  aiMessage: {
    backgroundColor: '#333',
    alignSelf: 'flex-start',
  },
  messageText: {
    color: '#fff',
    fontSize: 16,
  },
  adviceType: {
    color: '#ffd700',
    fontSize: 12,
    marginTop: 4,
  },
  inputContainer: {
    flexDirection: 'row',
    padding: 16,
    backgroundColor: '#2a2a2a',
  },
  textInput: {
    flex: 1,
    backgroundColor: '#333',
    color: '#fff',
    padding: 12,
    borderRadius: 8,
    marginRight: 8,
  },
  sendButton: {
    backgroundColor: '#ffd700',
    paddingHorizontal: 16,
    paddingVertical: 12,
    borderRadius: 8,
    justifyContent: 'center',
  },
  sendButtonText: {
    color: '#1a1a1a',
    fontWeight: 'bold',
  },
};

export default StackMasterChat;
```

### Investment Analysis Component
```javascript
import React, { useState } from 'react';
import { View, Text, TextInput, TouchableOpacity, Alert } from 'react-native';
import { getInvestmentAdvice } from '../api/stackapp';

const InvestmentAdvice = ({ userId }) => {
  const [amount, setAmount] = useState('');
  const [horizon, setHorizon] = useState('long-term');
  const [riskTolerance, setRiskTolerance] = useState('moderate');
  const [advice, setAdvice] = useState(null);
  const [isLoading, setIsLoading] = useState(false);

  const getAdvice = async () => {
    if (!amount) {
      Alert.alert('Error', 'Please enter an amount to invest');
      return;
    }

    setIsLoading(true);
    try {
      const response = await getInvestmentAdvice(userId, {
        amount: parseFloat(amount),
        horizon,
        riskTolerance,
        type: 'stocks'
      });
      
      setAdvice(response);
    } catch (error) {
      Alert.alert('Error', 'Failed to get investment advice');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <View style={styles.container}>
      <Text style={styles.title}>Investment Advice</Text>
      
      <TextInput
        style={styles.input}
        value={amount}
        onChangeText={setAmount}
        placeholder="Amount to invest ($)"
        keyboardType="numeric"
      />
      
      <TouchableOpacity style={styles.button} onPress={getAdvice} disabled={isLoading}>
        <Text style={styles.buttonText}>
          {isLoading ? 'Getting Advice...' : 'Get Investment Advice'}
        </Text>
      </TouchableOpacity>
      
      {advice && (
        <View style={styles.adviceContainer}>
          <Text style={styles.adviceTitle}>The Stack Master Says:</Text>
          <Text style={styles.adviceText}>{advice.advice}</Text>
        </View>
      )}
    </View>
  );
};

const styles = {
  container: {
    flex: 1,
    padding: 16,
    backgroundColor: '#1a1a1a',
  },
  title: {
    fontSize: 24,
    fontWeight: 'bold',
    color: '#ffd700',
    marginBottom: 20,
  },
  input: {
    backgroundColor: '#333',
    color: '#fff',
    padding: 12,
    borderRadius: 8,
    marginBottom: 16,
  },
  button: {
    backgroundColor: '#ffd700',
    padding: 16,
    borderRadius: 8,
    alignItems: 'center',
    marginBottom: 20,
  },
  buttonText: {
    color: '#1a1a1a',
    fontWeight: 'bold',
    fontSize: 16,
  },
  adviceContainer: {
    backgroundColor: '#333',
    padding: 16,
    borderRadius: 8,
  },
  adviceTitle: {
    color: '#ffd700',
    fontSize: 18,
    fontWeight: 'bold',
    marginBottom: 8,
  },
  adviceText: {
    color: '#fff',
    fontSize: 16,
    lineHeight: 24,
  },
};

export default InvestmentAdvice;
```

## 🎯 Error Handling

### API Error Handling
```javascript
const handleApiError = (error) => {
  if (error.response) {
    // Server responded with error status
    console.error('API Error:', error.response.data);
    return `Server error: ${error.response.status}`;
  } else if (error.request) {
    // Request was made but no response
    console.error('Network Error:', error.request);
    return 'Network error - check your connection';
  } else {
    // Something else happened
    console.error('Error:', error.message);
    return 'An unexpected error occurred';
  }
};
```

### Retry Logic
```javascript
const apiCallWithRetry = async (apiCall, maxRetries = 3) => {
  for (let i = 0; i < maxRetries; i++) {
    try {
      return await apiCall();
    } catch (error) {
      if (i === maxRetries - 1) throw error;
      await new Promise(resolve => setTimeout(resolve, 1000 * (i + 1)));
    }
  }
};
```

## 🚀 Production Considerations

### Environment Configuration
```javascript
// config/api.js
const config = {
  development: {
    API_BASE_URL: 'http://localhost:8000',
  },
  staging: {
    API_BASE_URL: 'https://staging-api.stackapp.com',
  },
  production: {
    API_BASE_URL: 'https://api.stackapp.com',
  },
};

export default config[process.env.NODE_ENV || 'development'];
```

### Authentication (Future)
```javascript
// Add authentication headers
const api = axios.create({
  baseURL: API_BASE_URL,
  headers: {
    'Authorization': `Bearer ${userToken}`,
    'Content-Type': 'application/json',
  },
});
```

## 🎤 Testing Your Integration

### Test Script
```bash
# Run the test script to verify API is working
python test_stackapp.py
```

### Manual Testing
1. Start the backend: `python start_stackapp.py`
2. Open your React Native app
3. Test the Stack Master chat
4. Try investment advice
5. Check community features

## 💰 Ready to Stack!

Your frontend is now ready to connect with StackApp! The API provides all the core functionality you need to build a powerful financial empowerment app for the Black community.

**Remember**: StackApp isn't just an app - it's a movement. Let's help the community stack their bread! 🎤💰
