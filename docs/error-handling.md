# 🚨 StackApp Error Handling Guide

## 🎯 Overview

This guide provides comprehensive error handling documentation for the StackApp API, including error codes, messages, resolution steps, and best practices for implementing robust error handling in your applications.

---

## 📊 Error Response Format

### **Standard Error Response**
```json
{
  "error": "Error type",
  "message": "Human-readable error message",
  "code": "ERROR_CODE",
  "details": {
    "field": "Additional error details",
    "timestamp": "2024-01-15T10:30:00Z",
    "request_id": "req_123456789"
  }
}
```

### **Error Response Headers**
```http
HTTP/1.1 400 Bad Request
Content-Type: application/json
X-Error-Code: VALIDATION_ERROR
X-Request-ID: req_123456789
Retry-After: 60
```

---

## 🔢 HTTP Status Codes

### **2xx Success**
| Code | Status | Description |
|------|--------|-------------|
| 200 | OK | Request successful |
| 201 | Created | Resource created successfully |
| 202 | Accepted | Request accepted for processing |

### **4xx Client Errors**
| Code | Status | Description |
|------|--------|-------------|
| 400 | Bad Request | Invalid request format or parameters |
| 401 | Unauthorized | Invalid or missing authentication |
| 402 | Payment Required | Premium feature requires subscription |
| 403 | Forbidden | Insufficient permissions |
| 404 | Not Found | Resource not found |
| 409 | Conflict | Resource conflict |
| 422 | Unprocessable Entity | Validation error |
| 429 | Too Many Requests | Rate limit exceeded |

### **5xx Server Errors**
| Code | Status | Description |
|------|--------|-------------|
| 500 | Internal Server Error | Unexpected server error |
| 502 | Bad Gateway | Upstream service error |
| 503 | Service Unavailable | Service temporarily unavailable |
| 504 | Gateway Timeout | Request timeout |

---

## 🚨 Error Categories

### **Authentication Errors (4xx)**

#### **401 Unauthorized**
```json
{
  "error": "Unauthorized",
  "message": "Invalid or missing API key",
  "code": "INVALID_API_KEY",
  "details": {
    "timestamp": "2024-01-15T10:30:00Z",
    "request_id": "req_123456789"
  }
}
```

**Common Causes:**
- Missing API key header
- Invalid API key format
- Expired API key
- Revoked API key

**Resolution Steps:**
1. Check API key format: `X-API-Key: your_key_here`
2. Verify key is active in dashboard
3. Regenerate key if expired
4. Contact support if key is valid

**Code Example:**
```javascript
try {
  const response = await fetch('/premium/finrobot-agents', {
    headers: { 'X-API-Key': apiKey }
  });
} catch (error) {
  if (error.status === 401) {
    console.error('Invalid API key. Please check your credentials.');
    // Redirect to login or show API key input
  }
}
```

#### **402 Payment Required**
```json
{
  "error": "Payment required",
  "message": "FinRobot agents require $9.99 beta subscription",
  "code": "SUBSCRIPTION_REQUIRED",
  "details": {
    "required_tier": "beta",
    "current_tier": "free",
    "upgrade_url": "/upgrade-to-premium",
    "features": [
      "Advanced FinRobot agents",
      "Real-time market analysis",
      "Personalized investment strategies",
      "Priority support"
    ]
  }
}
```

**Common Causes:**
- Attempting to access premium features with free tier
- Expired subscription
- Payment method declined
- Subscription cancelled

**Resolution Steps:**
1. Upgrade to premium tier
2. Update payment method
3. Reactivate subscription
4. Contact billing support

**Code Example:**
```javascript
try {
  const response = await fetch('/premium/finrobot-agents', {
    headers: { 'X-API-Key': apiKey }
  });
} catch (error) {
  if (error.status === 402) {
    const errorData = await error.json();
    showUpgradePrompt(errorData.details.features);
  }
}
```

#### **403 Forbidden**
```json
{
  "error": "Forbidden",
  "message": "API key does not have permission for this endpoint",
  "code": "INSUFFICIENT_PERMISSIONS",
  "details": {
    "required_permission": "finrobot_access",
    "current_permissions": ["basic_chat", "investment_advice"]
  }
}
```

**Common Causes:**
- API key lacks required permissions
- Endpoint requires higher tier
- Resource access denied
- Account suspended

**Resolution Steps:**
1. Check subscription tier
2. Verify endpoint access
3. Upgrade subscription if needed
4. Contact support for permission issues

### **Validation Errors (4xx)**

#### **400 Bad Request**
```json
{
  "error": "Bad Request",
  "message": "Invalid request format",
  "code": "INVALID_REQUEST_FORMAT",
  "details": {
    "validation_errors": [
      {
        "field": "user_id",
        "message": "user_id is required",
        "code": "REQUIRED_FIELD"
      },
      {
        "field": "message",
        "message": "message must be between 1 and 1000 characters",
        "code": "INVALID_LENGTH"
      }
    ]
  }
}
```

**Common Causes:**
- Missing required fields
- Invalid field formats
- Malformed JSON
- Unsupported content type

**Resolution Steps:**
1. Check request format
2. Validate required fields
3. Fix field formats
4. Ensure proper JSON structure

**Code Example:**
```javascript
function validateRequest(data) {
  const errors = [];
  
  if (!data.user_id) {
    errors.push({ field: 'user_id', message: 'user_id is required' });
  }
  
  if (!data.message || data.message.length > 1000) {
    errors.push({ field: 'message', message: 'message must be 1-1000 characters' });
  }
  
  return errors;
}

try {
  const errors = validateRequest(requestData);
  if (errors.length > 0) {
    throw new Error(`Validation failed: ${JSON.stringify(errors)}`);
  }
} catch (error) {
  console.error('Request validation failed:', error.message);
}
```

#### **422 Unprocessable Entity**
```json
{
  "error": "Validation Error",
  "message": "Request validation failed",
  "code": "VALIDATION_ERROR",
  "details": {
    "validation_errors": [
      {
        "field": "credit_score",
        "message": "credit_score must be between 300 and 850",
        "code": "INVALID_RANGE",
        "value": 950
      },
      {
        "field": "risk_tolerance",
        "message": "risk_tolerance must be one of: conservative, moderate, aggressive",
        "code": "INVALID_ENUM",
        "value": "high"
      }
    ]
  }
}
```

**Common Causes:**
- Field value out of range
- Invalid enum values
- Type mismatches
- Business rule violations

**Resolution Steps:**
1. Check field constraints
2. Validate enum values
3. Ensure correct data types
4. Review business rules

### **Rate Limiting Errors (4xx)**

#### **429 Too Many Requests**
```json
{
  "error": "Rate limit exceeded",
  "message": "You have exceeded the rate limit for your tier",
  "code": "RATE_LIMIT_EXCEEDED",
  "details": {
    "rate_limit": {
      "limit": 1000,
      "remaining": 0,
      "reset": 1640995200,
      "retry_after": 3600
    },
    "tier": "beta"
  }
}
```

**Common Causes:**
- Exceeded hourly rate limit
- Burst limit exceeded
- Tier limit reached
- Abuse detection triggered

**Resolution Steps:**
1. Wait for rate limit reset
2. Implement exponential backoff
3. Upgrade to higher tier
4. Optimize request frequency

**Code Example:**
```javascript
async function makeRequestWithRetry(url, options, maxRetries = 3) {
  for (let attempt = 1; attempt <= maxRetries; attempt++) {
    try {
      const response = await fetch(url, options);
      
      if (response.status === 429) {
        const errorData = await response.json();
        const retryAfter = errorData.details.rate_limit.retry_after;
        
        if (attempt < maxRetries) {
          console.log(`Rate limited. Retrying in ${retryAfter} seconds...`);
          await new Promise(resolve => setTimeout(resolve, retryAfter * 1000));
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

### **Server Errors (5xx)**

#### **500 Internal Server Error**
```json
{
  "error": "Internal Server Error",
  "message": "An unexpected error occurred",
  "code": "INTERNAL_ERROR",
  "details": {
    "request_id": "req_123456789",
    "timestamp": "2024-01-15T10:30:00Z",
    "support_contact": "support@stackapp.com"
  }
}
```

**Common Causes:**
- Database connection issues
- External service failures
- Code bugs
- Resource exhaustion

**Resolution Steps:**
1. Retry request after delay
2. Check service status
3. Contact support with request ID
4. Implement circuit breaker pattern

**Code Example:**
```javascript
async function handleServerError(error, requestId) {
  if (error.status >= 500) {
    console.error(`Server error for request ${requestId}:`, error);
    
    // Log error for monitoring
    logError({
      requestId,
      status: error.status,
      message: error.message,
      timestamp: new Date().toISOString()
    });
    
    // Show user-friendly message
    showErrorMessage('Service temporarily unavailable. Please try again later.');
    
    // Retry after delay
    setTimeout(() => {
      retryRequest(requestId);
    }, 5000);
  }
}
```

#### **503 Service Unavailable**
```json
{
  "error": "Service Unavailable",
  "message": "Service is temporarily unavailable for maintenance",
  "code": "SERVICE_UNAVAILABLE",
  "details": {
    "maintenance_window": {
      "start": "2024-01-15T02:00:00Z",
      "end": "2024-01-15T04:00:00Z"
    },
    "estimated_recovery": "2024-01-15T04:00:00Z"
  }
}
```

**Common Causes:**
- Planned maintenance
- High load conditions
- Service degradation
- Infrastructure issues

**Resolution Steps:**
1. Check maintenance schedule
2. Wait for service recovery
3. Monitor status page
4. Use fallback mechanisms

---

## 🛠️ Error Handling Patterns

### **1. Retry with Exponential Backoff**
```javascript
class RetryHandler {
  constructor(maxRetries = 3, baseDelay = 1000) {
    this.maxRetries = maxRetries;
    this.baseDelay = baseDelay;
  }
  
  async executeWithRetry(operation) {
    for (let attempt = 1; attempt <= this.maxRetries; attempt++) {
      try {
        return await operation();
      } catch (error) {
        if (this.shouldRetry(error, attempt)) {
          const delay = this.calculateDelay(attempt);
          console.log(`Attempt ${attempt} failed. Retrying in ${delay}ms...`);
          await this.sleep(delay);
          continue;
        }
        throw error;
      }
    }
  }
  
  shouldRetry(error, attempt) {
    if (attempt >= this.maxRetries) return false;
    
    // Retry on server errors and rate limits
    return error.status >= 500 || error.status === 429;
  }
  
  calculateDelay(attempt) {
    return this.baseDelay * Math.pow(2, attempt - 1);
  }
  
  sleep(ms) {
    return new Promise(resolve => setTimeout(resolve, ms));
  }
}

// Usage
const retryHandler = new RetryHandler();
const result = await retryHandler.executeWithRetry(async () => {
  return await fetch('/stack-master/chat', options);
});
```

### **2. Circuit Breaker Pattern**
```javascript
class CircuitBreaker {
  constructor(threshold = 5, timeout = 60000) {
    this.threshold = threshold;
    this.timeout = timeout;
    this.failureCount = 0;
    this.lastFailureTime = null;
    this.state = 'CLOSED'; // CLOSED, OPEN, HALF_OPEN
  }
  
  async execute(operation) {
    if (this.state === 'OPEN') {
      if (Date.now() - this.lastFailureTime > this.timeout) {
        this.state = 'HALF_OPEN';
      } else {
        throw new Error('Circuit breaker is OPEN');
      }
    }
    
    try {
      const result = await operation();
      this.onSuccess();
      return result;
    } catch (error) {
      this.onFailure();
      throw error;
    }
  }
  
  onSuccess() {
    this.failureCount = 0;
    this.state = 'CLOSED';
  }
  
  onFailure() {
    this.failureCount++;
    this.lastFailureTime = Date.now();
    
    if (this.failureCount >= this.threshold) {
      this.state = 'OPEN';
    }
  }
}

// Usage
const circuitBreaker = new CircuitBreaker();
const result = await circuitBreaker.execute(async () => {
  return await fetch('/stack-master/chat', options);
});
```

### **3. Graceful Degradation**
```javascript
class StackAppClient {
  constructor() {
    this.fallbackEnabled = true;
  }
  
  async chatWithStackMaster(message, userId, context = {}) {
    try {
      // Try primary API
      return await this.callPrimaryAPI(message, userId, context);
    } catch (error) {
      console.warn('Primary API failed:', error);
      
      if (this.fallbackEnabled) {
        // Fall back to cached responses or simplified logic
        return await this.getFallbackResponse(message, context);
      }
      
      throw error;
    }
  }
  
  async callPrimaryAPI(message, userId, context) {
    const response = await fetch('/stack-master/chat', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ user_id: userId, message, context })
    });
    
    if (!response.ok) {
      throw new Error(`API error: ${response.status}`);
    }
    
    return response.json();
  }
  
  async getFallbackResponse(message, context) {
    // Return cached responses or rule-based responses
    const fallbackResponses = {
      'investment': 'Start with index funds and build your emergency fund first.',
      'credit': 'Pay bills on time and keep credit utilization low.',
      'savings': 'Build an emergency fund of 3-6 months expenses.'
    };
    
    const adviceType = this.determineAdviceType(message);
    return {
      response: fallbackResponses[adviceType] || 'Focus on building your financial foundation.',
      advice_type: adviceType,
      actionable_steps: ['Track your spending', 'Build emergency fund', 'Start investing'],
      motivational_message: 'You got this! Every expert was once a beginner.'
    };
  }
  
  determineAdviceType(message) {
    const lowerMessage = message.toLowerCase();
    if (lowerMessage.includes('invest')) return 'investment';
    if (lowerMessage.includes('credit')) return 'credit';
    if (lowerMessage.includes('save')) return 'savings';
    return 'general';
  }
}
```

---

## 📊 Error Monitoring

### **Error Logging**
```javascript
class ErrorLogger {
  constructor() {
    this.errors = [];
  }
  
  logError(error, context = {}) {
    const errorLog = {
      timestamp: new Date().toISOString(),
      error: {
        message: error.message,
        status: error.status,
        code: error.code
      },
      context,
      userAgent: navigator.userAgent,
      url: window.location.href
    };
    
    this.errors.push(errorLog);
    
    // Send to monitoring service
    this.sendToMonitoring(errorLog);
    
    // Store locally for debugging
    this.storeLocally(errorLog);
  }
  
  sendToMonitoring(errorLog) {
    // Send to your monitoring service (e.g., Sentry, LogRocket)
    if (window.Sentry) {
      window.Sentry.captureException(new Error(errorLog.error.message), {
        extra: errorLog
      });
    }
  }
  
  storeLocally(errorLog) {
    const stored = JSON.parse(localStorage.getItem('stackapp_errors') || '[]');
    stored.push(errorLog);
    
    // Keep only last 50 errors
    if (stored.length > 50) {
      stored.splice(0, stored.length - 50);
    }
    
    localStorage.setItem('stackapp_errors', JSON.stringify(stored));
  }
  
  getErrorStats() {
    const errors = this.errors;
    const stats = {
      total: errors.length,
      byStatus: {},
      byCode: {},
      recent: errors.slice(-10)
    };
    
    errors.forEach(error => {
      const status = error.error.status;
      const code = error.error.code;
      
      stats.byStatus[status] = (stats.byStatus[status] || 0) + 1;
      stats.byCode[code] = (stats.byCode[code] || 0) + 1;
    });
    
    return stats;
  }
}

// Usage
const errorLogger = new ErrorLogger();

try {
  const response = await fetch('/stack-master/chat', options);
} catch (error) {
  errorLogger.logError(error, { userId, message });
  throw error;
}
```

### **Error Analytics**
```javascript
class ErrorAnalytics {
  constructor() {
    this.metrics = {
      totalRequests: 0,
      successfulRequests: 0,
      failedRequests: 0,
      errorTypes: {},
      responseTimes: []
    };
  }
  
  trackRequest(startTime, success, error = null) {
    const responseTime = Date.now() - startTime;
    
    this.metrics.totalRequests++;
    this.metrics.responseTimes.push(responseTime);
    
    if (success) {
      this.metrics.successfulRequests++;
    } else {
      this.metrics.failedRequests++;
      
      if (error && error.code) {
        this.metrics.errorTypes[error.code] = 
          (this.metrics.errorTypes[error.code] || 0) + 1;
      }
    }
  }
  
  getMetrics() {
    const successRate = this.metrics.totalRequests > 0 
      ? (this.metrics.successfulRequests / this.metrics.totalRequests) * 100 
      : 0;
    
    const avgResponseTime = this.metrics.responseTimes.length > 0
      ? this.metrics.responseTimes.reduce((a, b) => a + b, 0) / this.metrics.responseTimes.length
      : 0;
    
    return {
      ...this.metrics,
      successRate: Math.round(successRate * 100) / 100,
      avgResponseTime: Math.round(avgResponseTime)
    };
  }
}
```

---

## 🎯 Best Practices

### **1. Error Handling Strategy**
- ✅ **Always handle errors** - Never ignore API errors
- ✅ **Provide user feedback** - Show meaningful error messages
- ✅ **Implement retry logic** - Handle transient failures
- ✅ **Log errors** - Monitor and debug issues
- ✅ **Graceful degradation** - Fallback when possible

### **2. User Experience**
- ✅ **Clear error messages** - Avoid technical jargon
- ✅ **Actionable guidance** - Tell users what to do next
- ✅ **Progress indicators** - Show loading states
- ✅ **Retry options** - Allow users to retry failed requests
- ✅ **Offline handling** - Handle network issues gracefully

### **3. Development**
- ✅ **Consistent error format** - Use standard error structure
- ✅ **Error boundaries** - Prevent app crashes
- ✅ **Input validation** - Validate before sending requests
- ✅ **Type safety** - Use TypeScript for error handling
- ✅ **Testing** - Test error scenarios

### **4. Monitoring**
- ✅ **Error tracking** - Monitor error rates and types
- ✅ **Performance metrics** - Track response times
- ✅ **Alerting** - Set up alerts for critical errors
- ✅ **Analytics** - Understand error patterns
- ✅ **Debugging** - Include request IDs in logs

---

## 🚀 Ready to Handle Errors?

Your StackApp API is ready to help the Black community stack their bread and build their future with robust error handling!

**"From the block to the boardroom, we're stacking together."** 🎤💰
