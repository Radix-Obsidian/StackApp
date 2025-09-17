# 🔐 StackApp Authentication & Subscription Guide

## 🎯 Overview

StackApp uses a **tiered authentication system** that allows free access to core features while requiring authentication for premium FinRobot capabilities.

### **Authentication Tiers:**
- 🆓 **Free Tier**: No authentication required
- 💎 **Premium Tier**: API key required for FinRobot features

---

## 🆓 Free Tier Authentication

### **No Authentication Required**
The free tier provides access to:
- ✅ Qwen AI Stack Master chat
- ✅ Basic financial advice
- ✅ Investment guidance
- ✅ Credit building plans
- ✅ Community challenges
- ✅ Educational content
- ✅ Financial stack analysis

### **Usage Example:**
```javascript
// No authentication needed for free tier
const response = await fetch('http://localhost:8000/stack-master/chat', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
  },
  body: JSON.stringify({
    user_id: 'user123',
    message: 'I want to start investing',
    context: { income: 3000, savings: 200 }
  })
});
```

---

## 💎 Premium Tier Authentication

### **API Key Required**
Premium tier requires an API key for:
- 🔒 FinRobot agents access
- 🔒 Advanced financial analysis
- 🔒 Real-time market data
- 🔒 Personalized investment strategies
- 🔒 Priority support

### **Getting Your API Key**
1. **Sign up** for StackApp premium
2. **Subscribe** to beta plan ($9.99/month)
3. **Receive** your API key via email
4. **Include** API key in request headers

### **API Key Usage:**
```javascript
// Include API key in headers for premium features
const response = await fetch('http://localhost:8000/premium/finrobot-agents', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'X-API-Key': 'your_api_key_here'
  },
  body: JSON.stringify({
    user_id: 'premium_user123',
    subscription_tier: 'beta',
    payment_verified: true
  })
});
```

---

## 🔑 API Key Management

### **Header Format**
```
X-API-Key: your_api_key_here
```

### **Security Best Practices**
1. **Never expose** API keys in client-side code
2. **Store securely** in environment variables
3. **Rotate regularly** for security
4. **Monitor usage** for unusual activity
5. **Revoke immediately** if compromised

### **Environment Variables**
```bash
# .env file
STACKAPP_API_KEY=your_api_key_here
STACKAPP_BASE_URL=http://localhost:8000
```

### **Client Implementation**
```javascript
// Secure API key handling
class StackAppClient {
  constructor(apiKey = null) {
    this.baseURL = process.env.STACKAPP_BASE_URL || 'http://localhost:8000';
    this.apiKey = apiKey || process.env.STACKAPP_API_KEY;
  }
  
  async makeRequest(endpoint, data, requiresAuth = false) {
    const headers = {
      'Content-Type': 'application/json'
    };
    
    if (requiresAuth && this.apiKey) {
      headers['X-API-Key'] = this.apiKey;
    }
    
    const response = await fetch(`${this.baseURL}${endpoint}`, {
      method: 'POST',
      headers,
      body: JSON.stringify(data)
    });
    
    if (response.status === 401) {
      throw new Error('Invalid API key');
    }
    
    if (response.status === 402) {
      throw new Error('Payment required. Upgrade to premium.');
    }
    
    return response.json();
  }
}
```

---

## 💰 Subscription Tiers

### **Free Tier - $0/month**
```json
{
  "tier": "free",
  "price": "$0",
  "features": [
    "Qwen AI Stack Master",
    "Basic financial advice",
    "Community features",
    "Educational content"
  ],
  "ai_model": "Qwen/Qwen2.5-7B-Instruct",
  "rate_limit": "100 requests/hour"
}
```

**Features:**
- ✅ Qwen AI model responses
- ✅ Authentic Stack Master personality
- ✅ Basic financial guidance
- ✅ Community challenges
- ✅ Educational resources
- ✅ Financial stack analysis

### **Beta Tier - $9.99/month**
```json
{
  "tier": "beta",
  "price": "$9.99/month",
  "features": [
    "Everything in Free",
    "FinRobot agents access",
    "Advanced market analysis",
    "Personalized strategies",
    "Priority support"
  ],
  "ai_models": [
    "Qwen/Qwen2.5-7B-Instruct (Free)",
    "FinRobot Agents (Premium)"
  ],
  "rate_limit": "1000 requests/hour",
  "popular": true
}
```

**Features:**
- ✅ Everything in Free tier
- 🔒 FinRobot agents access
- 🔒 Advanced financial analysis
- 🔒 Real-time market data
- 🔒 Personalized investment strategies
- 🔒 Priority support

### **Premium Tier - $29.99/month**
```json
{
  "tier": "premium",
  "price": "$29.99/month",
  "features": [
    "Everything in Beta",
    "Real-time market data",
    "Advanced portfolio tools",
    "1-on-1 coaching sessions"
  ],
  "rate_limit": "5000 requests/hour"
}
```

**Features:**
- ✅ Everything in Beta tier
- 🔒 Real-time market data
- 🔒 Advanced portfolio tools
- 🔒 1-on-1 coaching sessions
- 🔒 Custom integrations

---

## 🚦 Rate Limiting

### **Rate Limits by Tier**
| Tier | Requests/Hour | Requests/Day | Burst Limit |
|------|---------------|--------------|-------------|
| Free | 100 | 1,000 | 10/minute |
| Beta | 1,000 | 10,000 | 100/minute |
| Premium | 5,000 | 50,000 | 500/minute |

### **Rate Limit Headers**
```http
X-RateLimit-Limit: 1000
X-RateLimit-Remaining: 999
X-RateLimit-Reset: 1640995200
```

### **Rate Limit Handling**
```javascript
async function makeRequestWithRetry(url, options, maxRetries = 3) {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      const response = await fetch(url, options);
      
      if (response.status === 429) {
        const retryAfter = response.headers.get('Retry-After');
        const delay = retryAfter ? parseInt(retryAfter) * 1000 : Math.pow(2, attempt) * 1000;
        
        if (attempt < maxRetries) {
          console.log(`Rate limited. Retrying in ${delay}ms...`);
          await new Promise(resolve => setTimeout(resolve, delay));
          continue;
        }
      }
      
      return response;
    } catch (error) {
      if (attempt === maxRetries) throw error;
      
      const delay = Math.pow(2, attempt) * 1000;
      await new Promise(resolve => setTimeout(resolve, delay));
    }
  }
}
```

---

## 🔒 Security Considerations

### **API Key Security**
1. **HTTPS Only**: Always use HTTPS in production
2. **Environment Variables**: Store keys in environment variables
3. **Key Rotation**: Rotate keys regularly
4. **Access Logging**: Monitor API key usage
5. **Scope Limitation**: Limit key permissions

### **Request Security**
```javascript
// Secure request implementation
class SecureStackAppClient {
  constructor(apiKey) {
    this.apiKey = apiKey;
    this.baseURL = 'https://api.stackapp.com'; // Always HTTPS in production
  }
  
  async makeSecureRequest(endpoint, data) {
    // Validate input
    if (!data.user_id || !data.message) {
      throw new Error('Required fields missing');
    }
    
    // Sanitize input
    const sanitizedData = {
      user_id: this.sanitizeInput(data.user_id),
      message: this.sanitizeInput(data.message),
      context: data.context || {}
    };
    
    const response = await fetch(`${this.baseURL}${endpoint}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-API-Key': this.apiKey,
        'User-Agent': 'StackApp-Client/1.0'
      },
      body: JSON.stringify(sanitizedData)
    });
    
    return response;
  }
  
  sanitizeInput(input) {
    return input.toString().trim().substring(0, 1000);
  }
}
```

---

## 🚨 Error Handling

### **Authentication Errors**

#### **401 Unauthorized**
```json
{
  "error": "Unauthorized",
  "message": "Invalid or missing API key",
  "code": "INVALID_API_KEY"
}
```

**Resolution:**
- Check API key format
- Verify key is active
- Contact support if key is valid

#### **402 Payment Required**
```json
{
  "error": "Payment required",
  "message": "FinRobot agents require $9.99 beta subscription",
  "upgrade_url": "/upgrade-to-premium",
  "features": [
    "Advanced FinRobot agents",
    "Real-time market analysis",
    "Personalized investment strategies",
    "Priority support"
  ]
}
```

**Resolution:**
- Upgrade to premium tier
- Verify payment status
- Check subscription status

#### **403 Forbidden**
```json
{
  "error": "Forbidden",
  "message": "API key does not have permission for this endpoint",
  "code": "INSUFFICIENT_PERMISSIONS"
}
```

**Resolution:**
- Check subscription tier
- Verify endpoint access
- Upgrade if needed

### **Rate Limit Errors**

#### **429 Too Many Requests**
```json
{
  "error": "Rate limit exceeded",
  "message": "You have exceeded the rate limit for your tier",
  "retry_after": 3600,
  "rate_limit": {
    "limit": 1000,
    "remaining": 0,
    "reset": 1640995200
  }
}
```

**Resolution:**
- Wait for rate limit reset
- Upgrade to higher tier
- Implement request queuing

---

## 📊 Usage Monitoring

### **Track API Usage**
```javascript
class UsageTracker {
  constructor() {
    this.usage = {
      requests: 0,
      errors: 0,
      rate_limits: 0
    };
  }
  
  trackRequest(endpoint, success, rateLimited = false) {
    this.usage.requests++;
    
    if (!success) {
      this.usage.errors++;
    }
    
    if (rateLimited) {
      this.usage.rate_limits++;
    }
    
    // Log usage for monitoring
    console.log('API Usage:', this.usage);
  }
  
  getUsageStats() {
    return {
      ...this.usage,
      success_rate: (this.usage.requests - this.usage.errors) / this.usage.requests,
      rate_limit_rate: this.usage.rate_limits / this.usage.requests
    };
  }
}
```

### **Usage Analytics**
```javascript
// Track usage for optimization
const usageTracker = new UsageTracker();

async function trackApiCall(endpoint, apiCall) {
  try {
    const result = await apiCall();
    usageTracker.trackRequest(endpoint, true);
    return result;
  } catch (error) {
    const rateLimited = error.status === 429;
    usageTracker.trackRequest(endpoint, false, rateLimited);
    throw error;
  }
}
```

---

## 🚀 Migration Guide

### **From Free to Premium**

#### **Step 1: Subscribe**
```javascript
// Subscribe to premium tier
const subscription = await fetch('/api/subscribe', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    tier: 'beta',
    payment_method: 'stripe_token'
  })
});
```

#### **Step 2: Get API Key**
```javascript
// Receive API key after successful subscription
const { api_key } = await subscription.json();
```

#### **Step 3: Update Client**
```javascript
// Update client with API key
const client = new StackAppClient(api_key);

// Now you can access premium features
const finrobotResponse = await client.accessFinRobotAgents('user123');
```

### **Upgrading Tiers**
```javascript
// Upgrade from Beta to Premium
const upgrade = await fetch('/api/upgrade', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'X-API-Key': current_api_key
  },
  body: JSON.stringify({
    new_tier: 'premium'
  })
});
```

---

## 🎯 Best Practices

### **1. Authentication**
- ✅ Use HTTPS in production
- ✅ Store API keys securely
- ✅ Implement key rotation
- ✅ Monitor key usage
- ✅ Handle auth errors gracefully

### **2. Rate Limiting**
- ✅ Implement exponential backoff
- ✅ Cache responses when possible
- ✅ Monitor rate limit headers
- ✅ Queue requests during limits
- ✅ Upgrade tier if needed

### **3. Error Handling**
- ✅ Handle all HTTP status codes
- ✅ Provide user-friendly messages
- ✅ Log errors for debugging
- ✅ Implement retry logic
- ✅ Graceful degradation

### **4. Security**
- ✅ Validate all inputs
- ✅ Sanitize user data
- ✅ Use secure headers
- ✅ Monitor for abuse
- ✅ Regular security audits

---

## 🎤 Ready to Authenticate?

Your StackApp API is ready to help the Black community stack their bread and build their future with secure, tiered access!

**"From the block to the boardroom, we're stacking together."** 🚀💰
