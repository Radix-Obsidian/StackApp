# 🎤 StackApp API Code Examples

## 🚀 Quick Start

### Base URL
```
Development: http://localhost:8000
Production: https://api.stackapp.com
```

### Authentication
- **Free Tier**: No authentication required
- **Premium Tier**: API key required for FinRobot features

---

## 📱 JavaScript/TypeScript Examples

### Chat with The Stack Master (Free)

```javascript
// Using fetch API
async function chatWithStackMaster(message, userId, context = {}) {
  try {
    const response = await fetch('http://localhost:8000/stack-master/chat', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        user_id: userId,
        message: message,
        context: context
      })
    });
    
    if (!response.ok) {
      throw new Error(`HTTP error! status: ${response.status}`);
    }
    
    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Error chatting with Stack Master:', error);
    throw error;
  }
}

// Example usage
const response = await chatWithStackMaster(
  "I want to start investing but I only have $50 a month. What should I do?",
  "user123",
  {
    income: 3000,
    savings: 200,
    risk_tolerance: "conservative"
  }
);

console.log(response);
// Output:
// {
//   response: "Real talk - let's break this down. First step is tracking every dollar...",
//   advice_type: "investment",
//   actionable_steps: ["Start with $25/month in an index fund", ...],
//   motivational_message: "Your future self will thank you for starting today!"
// }
```

### Using Axios

```javascript
import axios from 'axios';

const stackappApi = axios.create({
  baseURL: 'http://localhost:8000',
  timeout: 30000,
  headers: {
    'Content-Type': 'application/json',
  },
});

// Chat with Stack Master
export const chatWithStackMaster = async (message, userId, context = {}) => {
  try {
    const response = await stackappApi.post('/stack-master/chat', {
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

// Get investment advice
export const getInvestmentAdvice = async (message, userId, context = {}) => {
  try {
    const response = await stackappApi.post('/investment/advice', {
      user_id: userId,
      message: message,
      context: context
    });
    return response.data;
  } catch (error) {
    console.error('Investment advice error:', error);
    throw error;
  }
};

// Access FinRobot agents (Premium)
export const accessFinRobotAgents = async (userId, apiKey) => {
  try {
    const response = await stackappApi.post('/premium/finrobot-agents', {
      user_id: userId,
      subscription_tier: 'beta',
      payment_verified: true
    }, {
      headers: {
        'X-API-Key': apiKey
      }
    });
    return response.data;
  } catch (error) {
    if (error.response?.status === 402) {
      throw new Error('Payment required. Upgrade to premium for FinRobot access.');
    }
    console.error('FinRobot access error:', error);
    throw error;
  }
};
```

### React Hook Example

```jsx
import { useState, useCallback } from 'react';

export const useStackMaster = () => {
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const chatWithStackMaster = useCallback(async (message, userId, context = {}) => {
    setLoading(true);
    setError(null);
    
    try {
      const response = await fetch('http://localhost:8000/stack-master/chat', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({
          user_id: userId,
          message: message,
          context: context
        })
      });
      
      if (!response.ok) {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
      
      const data = await response.json();
      return data;
    } catch (err) {
      setError(err.message);
      throw err;
    } finally {
      setLoading(false);
    }
  }, []);

  return {
    chatWithStackMaster,
    loading,
    error
  };
};

// Usage in component
const ChatComponent = () => {
  const { chatWithStackMaster, loading, error } = useStackMaster();
  const [message, setMessage] = useState('');
  const [response, setResponse] = useState(null);

  const handleSubmit = async (e) => {
    e.preventDefault();
    try {
      const result = await chatWithStackMaster(message, 'user123');
      setResponse(result);
    } catch (err) {
      console.error('Chat error:', err);
    }
  };

  return (
    <div>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          value={message}
          onChange={(e) => setMessage(e.target.value)}
          placeholder="Ask The Stack Master anything..."
        />
        <button type="submit" disabled={loading}>
          {loading ? 'Chatting...' : 'Send'}
        </button>
      </form>
      
      {error && <div className="error">Error: {error}</div>}
      
      {response && (
        <div className="response">
          <h3>🎤 The Stack Master says:</h3>
          <p>{response.response}</p>
          <div className="actionable-steps">
            <h4>Actionable Steps:</h4>
            <ul>
              {response.actionable_steps.map((step, index) => (
                <li key={index}>{step}</li>
              ))}
            </ul>
          </div>
          <p className="motivational">{response.motivational_message}</p>
        </div>
      )}
    </div>
  );
};
```

---

## 🐍 Python Examples

### Basic Python Client

```python
import requests
import json
from typing import Dict, Any, Optional

class StackAppClient:
    def __init__(self, base_url: str = "http://localhost:8000", api_key: Optional[str] = None):
        self.base_url = base_url
        self.api_key = api_key
        self.session = requests.Session()
        
        if api_key:
            self.session.headers.update({'X-API-Key': api_key})
    
    def chat_with_stack_master(self, message: str, user_id: str, context: Dict[str, Any] = None) -> Dict[str, Any]:
        """Chat with The Stack Master AI Coach (Free)"""
        url = f"{self.base_url}/stack-master/chat"
        payload = {
            "user_id": user_id,
            "message": message,
            "context": context or {}
        }
        
        try:
            response = self.session.post(url, json=payload)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            print(f"Error chatting with Stack Master: {e}")
            raise
    
    def analyze_financial_stack(self, user_id: str, **kwargs) -> Dict[str, Any]:
        """Analyze user's financial stack (Free)"""
        url = f"{self.base_url}/stack-master/analyze-stack"
        payload = {
            "user_id": user_id,
            **kwargs
        }
        
        try:
            response = self.session.post(url, json=payload)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            print(f"Error analyzing financial stack: {e}")
            raise
    
    def get_investment_advice(self, message: str, user_id: str, context: Dict[str, Any] = None) -> Dict[str, Any]:
        """Get investment advice (Free)"""
        url = f"{self.base_url}/investment/advice"
        payload = {
            "user_id": user_id,
            "message": message,
            "context": context or {}
        }
        
        try:
            response = self.session.post(url, json=payload)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            print(f"Error getting investment advice: {e}")
            raise
    
    def access_finrobot_agents(self, user_id: str) -> Dict[str, Any]:
        """Access FinRobot agents (Premium - $9.99)"""
        url = f"{self.base_url}/premium/finrobot-agents"
        payload = {
            "user_id": user_id,
            "subscription_tier": "beta",
            "payment_verified": True
        }
        
        try:
            response = self.session.post(url, json=payload)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            if response.status_code == 402:
                raise Exception("Payment required. Upgrade to premium for FinRobot access.")
            print(f"Error accessing FinRobot agents: {e}")
            raise
    
    def get_subscription_plans(self) -> Dict[str, Any]:
        """Get available subscription plans"""
        url = f"{self.base_url}/subscription/plans"
        
        try:
            response = self.session.get(url)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.RequestException as e:
            print(f"Error getting subscription plans: {e}")
            raise

# Example usage
if __name__ == "__main__":
    # Initialize client (no API key needed for free tier)
    client = StackAppClient()
    
    # Chat with Stack Master
    response = client.chat_with_stack_master(
        message="I want to start investing but I only have $50 a month. What should I do?",
        user_id="user123",
        context={
            "income": 3000,
            "savings": 200,
            "risk_tolerance": "conservative"
        }
    )
    
    print("🎤 The Stack Master says:")
    print(response["response"])
    print("\n📋 Actionable Steps:")
    for step in response["actionable_steps"]:
        print(f"• {step}")
    print(f"\n💪 {response['motivational_message']}")
    
    # Analyze financial stack
    analysis = client.analyze_financial_stack(
        user_id="user123",
        current_income=3000,
        current_savings=500,
        monthly_expenses=2200,
        credit_score=650,
        investment_goals=["emergency fund", "retirement"],
        risk_tolerance="moderate"
    )
    
    print("\n📊 Financial Analysis:")
    print(analysis["analysis"])
    print(f"Stack Score: {analysis['stack_score']}/10")
    
    # Get subscription plans
    plans = client.get_subscription_plans()
    print("\n💰 Subscription Plans:")
    for tier, plan in plans["plans"].items():
        print(f"{tier.upper()}: {plan['price']}")
```

### Async Python Client

```python
import aiohttp
import asyncio
from typing import Dict, Any, Optional

class AsyncStackAppClient:
    def __init__(self, base_url: str = "http://localhost:8000", api_key: Optional[str] = None):
        self.base_url = base_url
        self.api_key = api_key
        self.headers = {'Content-Type': 'application/json'}
        
        if api_key:
            self.headers['X-API-Key'] = api_key
    
    async def chat_with_stack_master(self, message: str, user_id: str, context: Dict[str, Any] = None) -> Dict[str, Any]:
        """Chat with The Stack Master AI Coach (Free)"""
        url = f"{self.base_url}/stack-master/chat"
        payload = {
            "user_id": user_id,
            "message": message,
            "context": context or {}
        }
        
        async with aiohttp.ClientSession() as session:
            try:
                async with session.post(url, json=payload, headers=self.headers) as response:
                    response.raise_for_status()
                    return await response.json()
            except aiohttp.ClientError as e:
                print(f"Error chatting with Stack Master: {e}")
                raise
    
    async def get_investment_advice(self, message: str, user_id: str, context: Dict[str, Any] = None) -> Dict[str, Any]:
        """Get investment advice (Free)"""
        url = f"{self.base_url}/investment/advice"
        payload = {
            "user_id": user_id,
            "message": message,
            "context": context or {}
        }
        
        async with aiohttp.ClientSession() as session:
            try:
                async with session.post(url, json=payload, headers=self.headers) as response:
                    response.raise_for_status()
                    return await response.json()
            except aiohttp.ClientError as e:
                print(f"Error getting investment advice: {e}")
                raise

# Example usage
async def main():
    client = AsyncStackAppClient()
    
    # Chat with Stack Master
    response = await client.chat_with_stack_master(
        message="How can I improve my credit score from 580 to 700+?",
        user_id="user456",
        context={
            "current_credit_score": 580,
            "monthly_income": 2500,
            "current_debt": 5000
        }
    )
    
    print("🎤 The Stack Master says:")
    print(response["response"])
    print("\n📋 Actionable Steps:")
    for step in response["actionable_steps"]:
        print(f"• {step}")

# Run the async example
if __name__ == "__main__":
    asyncio.run(main())
```

---

## ☕ Java Examples

### Java Client with OkHttp

```java
import okhttp3.*;
import com.google.gson.Gson;
import com.google.gson.JsonObject;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

public class StackAppClient {
    private final String baseUrl;
    private final OkHttpClient client;
    private final Gson gson;
    private final String apiKey;
    
    public StackAppClient(String baseUrl, String apiKey) {
        this.baseUrl = baseUrl;
        this.apiKey = apiKey;
        this.client = new OkHttpClient();
        this.gson = new Gson();
    }
    
    public StackAppClient(String baseUrl) {
        this(baseUrl, null);
    }
    
    public StackMasterResponse chatWithStackMaster(String message, String userId, Map<String, Object> context) throws IOException {
        String url = baseUrl + "/stack-master/chat";
        
        JsonObject payload = new JsonObject();
        payload.addProperty("user_id", userId);
        payload.addProperty("message", message);
        payload.add("context", gson.toJsonTree(context));
        
        RequestBody body = RequestBody.create(
            payload.toString(),
            MediaType.get("application/json; charset=utf-8")
        );
        
        Request.Builder requestBuilder = new Request.Builder()
            .url(url)
            .post(body);
            
        if (apiKey != null) {
            requestBuilder.addHeader("X-API-Key", apiKey);
        }
        
        Request request = requestBuilder.build();
        
        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                throw new IOException("Unexpected code " + response);
            }
            
            String responseBody = response.body().string();
            return gson.fromJson(responseBody, StackMasterResponse.class);
        }
    }
    
    public InvestmentAdviceResponse getInvestmentAdvice(String message, String userId, Map<String, Object> context) throws IOException {
        String url = baseUrl + "/investment/advice";
        
        JsonObject payload = new JsonObject();
        payload.addProperty("user_id", userId);
        payload.addProperty("message", message);
        payload.add("context", gson.toJsonTree(context));
        
        RequestBody body = RequestBody.create(
            payload.toString(),
            MediaType.get("application/json; charset=utf-8")
        );
        
        Request request = new Request.Builder()
            .url(url)
            .post(body)
            .build();
        
        try (Response response = client.newCall(request).execute()) {
            if (!response.isSuccessful()) {
                throw new IOException("Unexpected code " + response);
            }
            
            String responseBody = response.body().string();
            return gson.fromJson(responseBody, InvestmentAdviceResponse.class);
        }
    }
    
    public FinRobotResponse accessFinRobotAgents(String userId) throws IOException {
        String url = baseUrl + "/premium/finrobot-agents";
        
        JsonObject payload = new JsonObject();
        payload.addProperty("user_id", userId);
        payload.addProperty("subscription_tier", "beta");
        payload.addProperty("payment_verified", true);
        
        RequestBody body = RequestBody.create(
            payload.toString(),
            MediaType.get("application/json; charset=utf-8")
        );
        
        Request request = new Request.Builder()
            .url(url)
            .post(body)
            .addHeader("X-API-Key", apiKey)
            .build();
        
        try (Response response = client.newCall(request).execute()) {
            if (response.code() == 402) {
                throw new IOException("Payment required. Upgrade to premium for FinRobot access.");
            }
            
            if (!response.isSuccessful()) {
                throw new IOException("Unexpected code " + response);
            }
            
            String responseBody = response.body().string();
            return gson.fromJson(responseBody, FinRobotResponse.class);
        }
    }
    
    // Response classes
    public static class StackMasterResponse {
        public String response;
        public String advice_type;
        public String[] actionable_steps;
        public String motivational_message;
    }
    
    public static class InvestmentAdviceResponse {
        public String advice;
        public String tier;
        public String ai_model;
        public String upgrade_message;
    }
    
    public static class FinRobotResponse {
        public String message;
        public String[] available_agents;
        public String subscription_tier;
        public String beta_price;
        public boolean features_unlocked;
    }
}

// Example usage
public class StackAppExample {
    public static void main(String[] args) {
        try {
            StackAppClient client = new StackAppClient("http://localhost:8000");
            
            // Chat with Stack Master
            Map<String, Object> context = new HashMap<>();
            context.put("income", 3000);
            context.put("savings", 200);
            context.put("risk_tolerance", "conservative");
            
            StackAppClient.StackMasterResponse response = client.chatWithStackMaster(
                "I want to start investing but I only have $50 a month. What should I do?",
                "user123",
                context
            );
            
            System.out.println("🎤 The Stack Master says:");
            System.out.println(response.response);
            System.out.println("\n📋 Actionable Steps:");
            for (String step : response.actionable_steps) {
                System.out.println("• " + step);
            }
            System.out.println("\n💪 " + response.motivational_message);
            
        } catch (IOException e) {
            System.err.println("Error: " + e.getMessage());
        }
    }
}
```

---

## 🦀 Rust Examples

### Rust Client with reqwest

```rust
use reqwest;
use serde::{Deserialize, Serialize};
use serde_json::json;
use std::collections::HashMap;

#[derive(Debug, Serialize, Deserialize)]
pub struct StackMasterMessage {
    pub user_id: String,
    pub message: String,
    pub context: Option<HashMap<String, serde_json::Value>>,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct StackMasterResponse {
    pub response: String,
    pub advice_type: String,
    pub actionable_steps: Vec<String>,
    pub motivational_message: String,
}

#[derive(Debug, Serialize, Deserialize)]
pub struct InvestmentAdviceResponse {
    pub advice: String,
    pub tier: String,
    pub ai_model: String,
    pub upgrade_message: String,
}

pub struct StackAppClient {
    base_url: String,
    client: reqwest::Client,
    api_key: Option<String>,
}

impl StackAppClient {
    pub fn new(base_url: &str) -> Self {
        Self {
            base_url: base_url.to_string(),
            client: reqwest::Client::new(),
            api_key: None,
        }
    }
    
    pub fn with_api_key(base_url: &str, api_key: &str) -> Self {
        Self {
            base_url: base_url.to_string(),
            client: reqwest::Client::new(),
            api_key: Some(api_key.to_string()),
        }
    }
    
    pub async fn chat_with_stack_master(
        &self,
        message: &str,
        user_id: &str,
        context: Option<HashMap<String, serde_json::Value>>,
    ) -> Result<StackMasterResponse, Box<dyn std::error::Error>> {
        let url = format!("{}/stack-master/chat", self.base_url);
        
        let payload = StackMasterMessage {
            user_id: user_id.to_string(),
            message: message.to_string(),
            context,
        };
        
        let mut request = self.client.post(&url).json(&payload);
        
        if let Some(api_key) = &self.api_key {
            request = request.header("X-API-Key", api_key);
        }
        
        let response = request.send().await?;
        
        if !response.status().is_success() {
            return Err(format!("HTTP error: {}", response.status()).into());
        }
        
        let stack_master_response: StackMasterResponse = response.json().await?;
        Ok(stack_master_response)
    }
    
    pub async fn get_investment_advice(
        &self,
        message: &str,
        user_id: &str,
        context: Option<HashMap<String, serde_json::Value>>,
    ) -> Result<InvestmentAdviceResponse, Box<dyn std::error::Error>> {
        let url = format!("{}/investment/advice", self.base_url);
        
        let payload = StackMasterMessage {
            user_id: user_id.to_string(),
            message: message.to_string(),
            context,
        };
        
        let response = self.client.post(&url).json(&payload).send().await?;
        
        if !response.status().is_success() {
            return Err(format!("HTTP error: {}", response.status()).into());
        }
        
        let advice_response: InvestmentAdviceResponse = response.json().await?;
        Ok(advice_response)
    }
}

#[tokio::main]
async fn main() -> Result<(), Box<dyn std::error::Error>> {
    let client = StackAppClient::new("http://localhost:8000");
    
    // Chat with Stack Master
    let mut context = HashMap::new();
    context.insert("income".to_string(), json!(3000));
    context.insert("savings".to_string(), json!(200));
    context.insert("risk_tolerance".to_string(), json!("conservative"));
    
    let response = client.chat_with_stack_master(
        "I want to start investing but I only have $50 a month. What should I do?",
        "user123",
        Some(context),
    ).await?;
    
    println!("🎤 The Stack Master says:");
    println!("{}", response.response);
    println!("\n📋 Actionable Steps:");
    for step in response.actionable_steps {
        println!("• {}", step);
    }
    println!("\n💪 {}", response.motivational_message);
    
    Ok(())
}
```

---

## 🐹 Go Examples

### Go Client

```go
package main

import (
    "bytes"
    "encoding/json"
    "fmt"
    "io"
    "net/http"
    "time"
)

type StackMasterMessage struct {
    UserID  string                 `json:"user_id"`
    Message string                 `json:"message"`
    Context map[string]interface{} `json:"context,omitempty"`
}

type StackMasterResponse struct {
    Response           string   `json:"response"`
    AdviceType         string   `json:"advice_type"`
    ActionableSteps    []string `json:"actionable_steps"`
    MotivationalMessage string  `json:"motivational_message"`
}

type InvestmentAdviceResponse struct {
    Advice         string `json:"advice"`
    Tier           string `json:"tier"`
    AIModel        string `json:"ai_model"`
    UpgradeMessage string `json:"upgrade_message"`
}

type StackAppClient struct {
    BaseURL string
    Client  *http.Client
    APIKey  string
}

func NewStackAppClient(baseURL string) *StackAppClient {
    return &StackAppClient{
        BaseURL: baseURL,
        Client: &http.Client{
            Timeout: 30 * time.Second,
        },
    }
}

func NewStackAppClientWithAPIKey(baseURL, apiKey string) *StackAppClient {
    return &StackAppClient{
        BaseURL: baseURL,
        Client: &http.Client{
            Timeout: 30 * time.Second,
        },
        APIKey: apiKey,
    }
}

func (c *StackAppClient) ChatWithStackMaster(message, userID string, context map[string]interface{}) (*StackMasterResponse, error) {
    url := c.BaseURL + "/stack-master/chat"
    
    payload := StackMasterMessage{
        UserID:  userID,
        Message: message,
        Context: context,
    }
    
    jsonData, err := json.Marshal(payload)
    if err != nil {
        return nil, fmt.Errorf("error marshaling payload: %v", err)
    }
    
    req, err := http.NewRequest("POST", url, bytes.NewBuffer(jsonData))
    if err != nil {
        return nil, fmt.Errorf("error creating request: %v", err)
    }
    
    req.Header.Set("Content-Type", "application/json")
    if c.APIKey != "" {
        req.Header.Set("X-API-Key", c.APIKey)
    }
    
    resp, err := c.Client.Do(req)
    if err != nil {
        return nil, fmt.Errorf("error making request: %v", err)
    }
    defer resp.Body.Close()
    
    if resp.StatusCode != http.StatusOK {
        return nil, fmt.Errorf("HTTP error: %d", resp.StatusCode)
    }
    
    body, err := io.ReadAll(resp.Body)
    if err != nil {
        return nil, fmt.Errorf("error reading response: %v", err)
    }
    
    var response StackMasterResponse
    if err := json.Unmarshal(body, &response); err != nil {
        return nil, fmt.Errorf("error unmarshaling response: %v", err)
    }
    
    return &response, nil
}

func (c *StackAppClient) GetInvestmentAdvice(message, userID string, context map[string]interface{}) (*InvestmentAdviceResponse, error) {
    url := c.BaseURL + "/investment/advice"
    
    payload := StackMasterMessage{
        UserID:  userID,
        Message: message,
        Context: context,
    }
    
    jsonData, err := json.Marshal(payload)
    if err != nil {
        return nil, fmt.Errorf("error marshaling payload: %v", err)
    }
    
    req, err := http.NewRequest("POST", url, bytes.NewBuffer(jsonData))
    if err != nil {
        return nil, fmt.Errorf("error creating request: %v", err)
    }
    
    req.Header.Set("Content-Type", "application/json")
    
    resp, err := c.Client.Do(req)
    if err != nil {
        return nil, fmt.Errorf("error making request: %v", err)
    }
    defer resp.Body.Close()
    
    if resp.StatusCode != http.StatusOK {
        return nil, fmt.Errorf("HTTP error: %d", resp.StatusCode)
    }
    
    body, err := io.ReadAll(resp.Body)
    if err != nil {
        return nil, fmt.Errorf("error reading response: %v", err)
    }
    
    var response InvestmentAdviceResponse
    if err := json.Unmarshal(body, &response); err != nil {
        return nil, fmt.Errorf("error unmarshaling response: %v", err)
    }
    
    return &response, nil
}

func main() {
    client := NewStackAppClient("http://localhost:8000")
    
    // Chat with Stack Master
    context := map[string]interface{}{
        "income":         3000,
        "savings":        200,
        "risk_tolerance": "conservative",
    }
    
    response, err := client.ChatWithStackMaster(
        "I want to start investing but I only have $50 a month. What should I do?",
        "user123",
        context,
    )
    
    if err != nil {
        fmt.Printf("Error: %v\n", err)
        return
    }
    
    fmt.Println("🎤 The Stack Master says:")
    fmt.Println(response.Response)
    fmt.Println("\n📋 Actionable Steps:")
    for _, step := range response.ActionableSteps {
        fmt.Printf("• %s\n", step)
    }
    fmt.Printf("\n💪 %s\n", response.MotivationalMessage)
}
```

---

## 🔧 cURL Examples

### Basic Chat with Stack Master

```bash
# Chat with The Stack Master (Free)
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

### Get Investment Advice

```bash
# Get investment advice (Free)
curl -X POST "http://localhost:8000/investment/advice" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "user123",
    "message": "How should I invest $1000 for retirement?",
    "context": {
      "age": 25,
      "risk_tolerance": "moderate",
      "time_horizon": "40_years"
    }
  }'
```

### Access FinRobot Agents (Premium)

```bash
# Access FinRobot agents (Premium - requires API key)
curl -X POST "http://localhost:8000/premium/finrobot-agents" \
  -H "Content-Type: application/json" \
  -H "X-API-Key: your_api_key_here" \
  -d '{
    "user_id": "premium_user123",
    "subscription_tier": "beta",
    "payment_verified": true
  }'
```

### Get Subscription Plans

```bash
# Get available subscription plans
curl -X GET "http://localhost:8000/subscription/plans"
```

### Analyze Financial Stack

```bash
# Analyze financial stack (Free)
curl -X POST "http://localhost:8000/stack-master/analyze-stack" \
  -H "Content-Type: application/json" \
  -d '{
    "user_id": "user123",
    "current_income": 3000,
    "current_savings": 500,
    "monthly_expenses": 2200,
    "credit_score": 650,
    "investment_goals": ["emergency fund", "retirement"],
    "risk_tolerance": "moderate"
  }'
```

---

## 🚨 Error Handling Examples

### JavaScript Error Handling

```javascript
async function chatWithStackMaster(message, userId, context = {}) {
  try {
    const response = await fetch('http://localhost:8000/stack-master/chat', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        user_id: userId,
        message: message,
        context: context
      })
    });
    
    if (!response.ok) {
      if (response.status === 402) {
        throw new Error('Payment required. Upgrade to premium for this feature.');
      } else if (response.status === 429) {
        throw new Error('Rate limit exceeded. Please try again later.');
      } else if (response.status >= 500) {
        throw new Error('Server error. Please try again later.');
      } else {
        throw new Error(`HTTP error! status: ${response.status}`);
      }
    }
    
    const data = await response.json();
    return data;
  } catch (error) {
    if (error.name === 'TypeError' && error.message.includes('fetch')) {
      throw new Error('Network error. Please check your connection.');
    }
    throw error;
  }
}

// Usage with error handling
try {
  const response = await chatWithStackMaster(
    "I want to start investing",
    "user123"
  );
  console.log("Success:", response);
} catch (error) {
  console.error("Error:", error.message);
  // Handle different error types
  if (error.message.includes('Payment required')) {
    // Show upgrade prompt
    showUpgradePrompt();
  } else if (error.message.includes('Rate limit')) {
    // Show retry option
    showRetryOption();
  } else {
    // Show generic error message
    showErrorMessage(error.message);
  }
}
```

### Python Error Handling

```python
import requests
from requests.exceptions import RequestException, Timeout, ConnectionError

def chat_with_stack_master(message, user_id, context=None):
    url = "http://localhost:8000/stack-master/chat"
    payload = {
        "user_id": user_id,
        "message": message,
        "context": context or {}
    }
    
    try:
        response = requests.post(url, json=payload, timeout=30)
        response.raise_for_status()
        return response.json()
    
    except ConnectionError:
        raise Exception("Network error. Please check your connection.")
    except Timeout:
        raise Exception("Request timeout. Please try again.")
    except requests.exceptions.HTTPError as e:
        if e.response.status_code == 402:
            raise Exception("Payment required. Upgrade to premium for this feature.")
        elif e.response.status_code == 429:
            raise Exception("Rate limit exceeded. Please try again later.")
        elif e.response.status_code >= 500:
            raise Exception("Server error. Please try again later.")
        else:
            raise Exception(f"HTTP error: {e.response.status_code}")
    except RequestException as e:
        raise Exception(f"Request error: {str(e)}")

# Usage with error handling
try:
    response = chat_with_stack_master(
        "I want to start investing",
        "user123",
        {"income": 3000, "savings": 200}
    )
    print("Success:", response)
except Exception as e:
    print("Error:", str(e))
    # Handle different error types
    if "Payment required" in str(e):
        # Show upgrade prompt
        show_upgrade_prompt()
    elif "Rate limit" in str(e):
        # Show retry option
        show_retry_option()
    else:
        # Show generic error message
        show_error_message(str(e))
```

---

## 🎯 Best Practices

### 1. **Rate Limiting**
- Free tier: 100 requests per hour
- Premium tier: 1000 requests per hour
- Implement exponential backoff for retries

### 2. **Error Handling**
- Always handle network errors
- Implement retry logic with backoff
- Provide user-friendly error messages
- Log errors for debugging

### 3. **Authentication**
- Free tier: No authentication required
- Premium tier: Include API key in headers
- Store API keys securely

### 4. **Context Usage**
- Provide relevant context for better responses
- Include financial information when available
- Update context as user situation changes

### 5. **Response Processing**
- Parse actionable steps for user display
- Show motivational messages to encourage users
- Categorize advice types for UI organization

---

## 🚀 Ready to Integrate?

Your StackApp API is ready to help the Black community stack their bread and build their future! 

**"From the block to the boardroom, we're stacking together."** 🎤💰
