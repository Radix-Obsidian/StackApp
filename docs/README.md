# 🎤 StackApp API Documentation

## 💰 **The Black Community's Financial Powerhouse**

Welcome to the comprehensive API documentation for StackApp - the revolutionary financial platform designed specifically for the Black community, combining authentic cultural voice with cutting-edge AI technology.

---

## 🚀 **Quick Start**

### **Base URL**
```
Development: http://localhost:8000
Production: https://api.stackapp.com
```

### **Authentication**
- 🆓 **Free Tier**: No authentication required
- 💎 **Premium Tier**: API key required for FinRobot features

### **First Request**
```bash
curl -X POST "http://localhost:8000/stack-master/chat" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "user123",
    "message": "I want to start investing but I only have $50 a month. What should I do?",
    "context": {
      "income": 3000,
      "savings": 200,
      "risk_tolerance": "conservative"
    }
  }'
```

---

## 📚 **Documentation Overview**

### **🎯 Core Documentation**
- **[OpenAPI Specification](./stackapp_openapi.yaml)** - Complete API specification
- **[Interactive Documentation](./index.html)** - Beautiful, interactive API portal
- **[Code Examples](./code-examples.md)** - Multi-language code examples
- **[Authentication Guide](./authentication.md)** - Auth and subscription tiers
- **[Error Handling](./error-handling.md)** - Comprehensive error documentation

### **🔧 API Reference**
- **[Endpoints](#endpoints)** - All available API endpoints
- **[Models](#models)** - Request/response schemas
- **[Authentication](#authentication)** - Auth methods and tiers
- **[Rate Limits](#rate-limits)** - Usage limits by tier
- **[Error Codes](#error-codes)** - Complete error reference

---

## 🎯 **API Endpoints**

### **🆓 Free Tier Endpoints**

#### **Stack Master AI Coach**
```http
POST /stack-master/chat
POST /stack-master/analyze-stack
```

#### **Financial Advice**
```http
POST /investment/advice
POST /credit/building-plan
```

#### **Community & Education**
```http
GET /community/stack-challenges
GET /education/topics
```

#### **System**
```http
GET /
GET /health
GET /subscription/plans
```

### **💎 Premium Tier Endpoints**

#### **FinRobot Agents**
```http
POST /premium/finrobot-agents
POST /premium/advanced-analysis
```

---

## 🎤 **The Stack Master**

### **What is The Stack Master?**
The Stack Master is your AI financial coach with authentic Black community voice, providing culturally-aware financial guidance that resonates with the community while delivering professional-grade advice.

### **Key Features:**
- ✅ **Authentic Voice** - Culturally aware and relatable
- ✅ **Real AI** - Powered by Qwen/Qwen2.5-7B-Instruct model
- ✅ **Actionable Advice** - Specific steps you can take
- ✅ **Motivational** - Encouraging and supportive
- ✅ **Free Access** - No API keys required

### **Example Response:**
```json
{
  "response": "Real talk - let's break this down. First step is tracking every dollar. You can't stack what you can't see. Start with the 50/30/20 rule: 50% needs, 30% wants, 20% wealth building.",
  "advice_type": "investment",
  "actionable_steps": [
    "Start with $25/month in an index fund",
    "Research low-cost ETFs like VTI or SPY",
    "Set up automatic transfers to your investment account"
  ],
  "motivational_message": "Your future self will thank you for starting today!"
}
```

---

## 💰 **Subscription Tiers**

### **🆓 Free Tier - $0/month**
- ✅ Qwen AI Stack Master
- ✅ Basic financial advice
- ✅ Community features
- ✅ Educational content
- ✅ 100 requests/hour

### **💎 Beta Tier - $9.99/month**
- ✅ Everything in Free
- 🔒 FinRobot agents access
- 🔒 Advanced market analysis
- 🔒 Personalized strategies
- 🔒 Priority support
- 🔒 1,000 requests/hour

### **🚀 Premium Tier - $29.99/month**
- ✅ Everything in Beta
- 🔒 Real-time market data
- 🔒 Advanced portfolio tools
- 🔒 1-on-1 coaching sessions
- 🔒 5,000 requests/hour

---

## 🔐 **Authentication**

### **Free Tier**
No authentication required - start using immediately!

### **Premium Tier**
Include API key in request headers:
```http
X-API-Key: your_api_key_here
```

### **Getting API Key**
1. Subscribe to premium tier
2. Receive API key via email
3. Include in request headers
4. Access FinRobot features

---

## 📊 **Rate Limits**

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

---

## 🚨 **Error Handling**

### **Common Error Codes**
- **400** - Bad Request (invalid parameters)
- **401** - Unauthorized (invalid API key)
- **402** - Payment Required (premium feature)
- **403** - Forbidden (insufficient permissions)
- **429** - Too Many Requests (rate limit exceeded)
- **500** - Internal Server Error

### **Error Response Format**
```json
{
  "error": "Error type",
  "message": "Human-readable message",
  "code": "ERROR_CODE",
  "details": {
    "field": "Additional details",
    "timestamp": "2024-01-15T10:30:00Z",
    "request_id": "req_123456789"
  }
}
```

---

## 🛠️ **Code Examples**

### **JavaScript/TypeScript**
```javascript
// Chat with Stack Master
const response = await fetch('http://localhost:8000/stack-master/chat', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    user_id: 'user123',
    message: 'I want to start investing',
    context: { income: 3000, savings: 200 }
  })
});

const data = await response.json();
console.log(data.response);
```

### **Python**
```python
import requests

response = requests.post('http://localhost:8000/stack-master/chat', json={
    'user_id': 'user123',
    'message': 'I want to start investing',
    'context': {'income': 3000, 'savings': 200}
})

data = response.json()
print(data['response'])
```

### **cURL**
```bash
curl -X POST "http://localhost:8000/stack-master/chat" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "user123",
    "message": "I want to start investing",
    "context": {"income": 3000, "savings": 200}
  }'
```

---

## 🎯 **Use Cases**

### **Personal Finance Apps**
- Integrate Stack Master for financial coaching
- Provide culturally-aware advice
- Build community features

### **Investment Platforms**
- Add Stack Master as financial advisor
- Provide personalized guidance
- Offer premium FinRobot analysis

### **Educational Platforms**
- Include financial literacy content
- Provide interactive learning
- Build community challenges

### **Fintech Applications**
- Add AI-powered financial coaching
- Provide credit building guidance
- Offer investment advice

---

## 🚀 **Getting Started**

### **1. Choose Your Integration**
- **Free Tier**: Start immediately with Qwen AI
- **Premium Tier**: Subscribe for FinRobot features

### **2. Select Your Language**
- JavaScript/TypeScript
- Python
- Java
- Go
- Rust
- cURL

### **3. Make Your First Request**
```bash
curl -X POST "http://localhost:8000/stack-master/chat" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "user123",
    "message": "Hello Stack Master!"
  }'
```

### **4. Explore the Features**
- Chat with Stack Master
- Get investment advice
- Create credit building plans
- Join community challenges
- Access educational content

---

## 📞 **Support**

### **Documentation**
- **[Interactive Docs](http://localhost:8000/docs)** - Try the API
- **[ReDoc](http://localhost:8000/redoc)** - Beautiful documentation
- **[OpenAPI Spec](./stackapp_openapi.yaml)** - Complete specification

### **Community**
- **GitHub**: [StackApp Repository](https://github.com/stackapp)
- **Discord**: [Community Server](https://discord.gg/stackapp)
- **Twitter**: [@StackApp](https://twitter.com/stackapp)

### **Support**
- **Email**: support@stackapp.com
- **Status**: [status.stackapp.com](https://status.stackapp.com)
- **FAQ**: [help.stackapp.com](https://help.stackapp.com)

---

## 🎤 **About StackApp**

StackApp is a revolutionary financial platform designed specifically for the Black community, combining authentic cultural voice with cutting-edge AI technology to provide personalized financial guidance and wealth-building strategies.

### **Mission**
To empower the Black community with culturally-aware financial education and AI-powered guidance that resonates with our culture while delivering professional-grade financial advice.

### **Vision**
From the block to the boardroom, we're stacking together.

### **Values**
- **Authenticity** - Real talk, real advice
- **Community** - Building wealth together
- **Excellence** - Professional-grade guidance
- **Accessibility** - Free tier for everyone
- **Innovation** - Cutting-edge AI technology

---

## 🚀 **Ready to Stack?**

Your StackApp API is ready to help the Black community stack their bread and build their future!

**"From the block to the boardroom, we're stacking together."** 🎤💰

---

*StackApp - Where the culture meets financial freedom.*
