#!/usr/bin/env python3
"""
StackApp API - Simplified version for Render deployment
The Black Community's Financial Powerhouse Backend
Uses Hugging Face free models - No API keys required!
"""

import os
import json
from datetime import datetime
from typing import Dict, List, Optional, Any
from fastapi import FastAPI, HTTPException, Request
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field
import uvicorn
from dotenv import load_dotenv
import requests

# Load environment variables
load_dotenv()

# StackApp Configuration
STACKAPP_CONFIG = {
    "app_name": "StackApp",
    "tagline": "Stack Your Bread, Stack Your Future",
    "version": "1.0.0-MVP-CLOUD",
    "ai_coach_name": "The Stack Master",
    "target_community": "Black Community Financial Empowerment"
}

# API Models
class StackMasterMessage(BaseModel):
    """Message to the Stack Master AI Coach"""
    user_id: str
    message: str
    context: Optional[Dict[str, Any]] = {}

class StackMasterResponse(BaseModel):
    """Response from the Stack Master AI Coach"""
    response: str
    advice_type: str
    actionable_steps: List[str] = []
    motivational_message: str = ""

# Agent Types
class AgentType:
    """Enum for agent types"""
    STACK_MASTER = "stack_master"
    FINANCIAL_ANALYST = "financial_analyst"
    MARKET_ANALYST = "market_analyst"
    EXPERT_INVESTOR = "expert_investor"
    ACCOUNTANT = "accountant"

# Hugging Face API Client
class HuggingFaceClient:
    """Client for Hugging Face API"""
    
    def __init__(self):
        self.api_url = "https://api-inference.huggingface.co/models/"
        self.token = os.getenv("HF_TOKEN")
        self.headers = {"Authorization": f"Bearer {self.token}"} if self.token else {}
        
        # Model assignments
        self.models = {
            AgentType.STACK_MASTER: os.getenv("HF_MODEL", "Qwen/Qwen2.5-7B-Instruct"),
            AgentType.FINANCIAL_ANALYST: os.getenv("HF_MODEL_FINANCIAL_ANALYST", "Qwen/Qwen2.5-7B-Instruct"),
            AgentType.MARKET_ANALYST: os.getenv("HF_MODEL_MARKET_ANALYST", "FinGPT/fingpt-forecaster_dow_30"),
            AgentType.EXPERT_INVESTOR: os.getenv("HF_MODEL_EXPERT_INVESTOR", "microsoft/DialoGPT-medium"),
            AgentType.ACCOUNTANT: os.getenv("HF_MODEL_ACCOUNTANT", "EleutherAI/gpt-neo-2.7B")
        }
        
        print("🚀 Hugging Face Client initialized")
        print(f"📊 Stack Master: {self.models[AgentType.STACK_MASTER]}")
        print(f"📊 Financial Analyst: {self.models[AgentType.FINANCIAL_ANALYST]}")
        print(f"📊 Market Analyst: {self.models[AgentType.MARKET_ANALYST]}")
        print(f"📊 Expert Investor: {self.models[AgentType.EXPERT_INVESTOR]}")
        print(f"📊 Accountant: {self.models[AgentType.ACCOUNTANT]}")
    
    async def generate_text(self, prompt: str, agent_type: str = AgentType.STACK_MASTER) -> str:
        """Generate text using Hugging Face API"""
        try:
            model = self.models.get(agent_type, self.models[AgentType.STACK_MASTER])
            payload = {
                "inputs": prompt,
                "parameters": {
                    "max_new_tokens": 150,
                    "temperature": 0.7,
                    "top_p": 0.9,
                    "do_sample": True
                }
            }
            
            response = requests.post(
                f"{self.api_url}{model}",
                headers=self.headers,
                json=payload
            )
            
            if response.status_code == 200:
                result = response.json()
                if isinstance(result, list) and len(result) > 0:
                    return result[0].get("generated_text", "").replace(prompt, "")
                return "Sorry, I couldn't generate a response at this time."
            else:
                print(f"Error: {response.status_code}, {response.text}")
                return "Sorry, the AI service is currently unavailable. Please try again later."
                
        except Exception as e:
            print(f"Error generating text: {e}")
            return "Sorry, an error occurred while generating a response."

# Initialize Hugging Face client
hf_client = HuggingFaceClient()

# Initialize FastAPI app
app = FastAPI(
    title="StackApp Cloud API",
    description="The Black Community's Financial Powerhouse - Cloud API",
    version="1.0.0-MVP-CLOUD"
)

# CORS middleware for frontend integration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# API Key middleware
@app.middleware("http")
async def api_key_middleware(request: Request, call_next):
    """Middleware to check API key"""
    # Skip API key check for health and root endpoints
    if request.url.path in ["/", "/health"]:
        return await call_next(request)
    
    # Get API key from header
    api_key = request.headers.get("X-API-Key")
    expected_api_key = os.getenv("STACKAPP_API_KEY")
    
    # Check API key
    if not api_key or api_key != expected_api_key:
        return JSONResponse(
            status_code=401,
            content={"detail": "Invalid or missing API key"}
        )
    
    return await call_next(request)

# Health check endpoint
@app.get("/")
async def root():
    """Root endpoint with StackApp info"""
    return {
        "app": STACKAPP_CONFIG["app_name"],
        "tagline": STACKAPP_CONFIG["tagline"],
        "version": STACKAPP_CONFIG["version"],
        "ai_coach": STACKAPP_CONFIG["ai_coach_name"],
        "status": "ready",
        "message": "StackApp API is ready to help you stack your bread! 💰",
        "provider": "Render Cloud"
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "timestamp": datetime.now().isoformat()}

# Stack Master AI Coach Endpoints
@app.post("/stack-master/chat", response_model=StackMasterResponse)
async def chat_with_stack_master(request: StackMasterMessage):
    """Chat with The Stack Master AI Coach"""
    try:
        # Create prompt
        prompt = f"""You are The Stack Master, an AI financial coach for the Black community.
        
Your personality:
- Real talk, street smart, culturally aware
- Use language that resonates with Black culture
- Focus on building wealth, not just spending money
- Be motivational but practical
- Use terms like "stacking", "building your stack", "stacking chips"

User message: {request.message}

Respond as The Stack Master with authentic, culturally-aware financial advice:"""
        
        # Generate response
        response_text = await hf_client.generate_text(prompt, AgentType.STACK_MASTER)
        
        # Determine advice type
        advice_type = "general"
        if any(word in response_text.lower() for word in ["invest", "stock", "portfolio"]):
            advice_type = "investment"
        elif any(word in response_text.lower() for word in ["credit", "score", "debt"]):
            advice_type = "credit"
        elif any(word in response_text.lower() for word in ["save", "saving", "budget"]):
            advice_type = "savings"
        
        # Generate motivational message
        motivational_messages = {
            "investment": "Your future self will thank you for starting today!",
            "credit": "Every payment on time is money in your pocket!",
            "savings": "Small steps lead to big stacks!",
            "general": "You got this! Every expert was once a beginner."
        }
        motivational_message = motivational_messages.get(advice_type, motivational_messages["general"])
        
        # Generate actionable steps
        actionable_steps = {
            "investment": [
                "Start with $25/month in an index fund",
                "Research low-cost ETFs like VTI or SPY",
                "Set up automatic transfers to your investment account"
            ],
            "credit": [
                "Pay all bills on time, every time",
                "Keep credit card balances below 30% of limit",
                "Check your credit report monthly"
            ],
            "savings": [
                "Set up automatic transfer of $50/month to savings",
                "Create a budget using the 50/30/20 rule",
                "Build emergency fund to $500 first"
            ],
            "general": [
                "Track every dollar you spend for one month",
                "Set one specific financial goal",
                "Start with small, consistent actions"
            ]
        }
        steps = actionable_steps.get(advice_type, actionable_steps["general"])
        
        return StackMasterResponse(
            response=response_text,
            advice_type=advice_type,
            actionable_steps=steps,
            motivational_message=motivational_message
        )
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error chatting with Stack Master: {str(e)}")

# Specialized Agent Endpoints
@app.post("/agents/{agent_type}/chat", response_model=StackMasterResponse)
async def chat_with_specialized_agent(agent_type: str, request: StackMasterMessage):
    """Chat with specialized financial agents"""
    try:
        # Map URL parameter to agent type
        agent_map = {
            "financial-analyst": AgentType.FINANCIAL_ANALYST,
            "market-analyst": AgentType.MARKET_ANALYST,
            "expert-investor": AgentType.EXPERT_INVESTOR,
            "accountant": AgentType.ACCOUNTANT
        }
        
        if agent_type not in agent_map:
            raise HTTPException(status_code=404, detail=f"Agent type {agent_type} not found")
        
        agent = agent_map[agent_type]
        
        # Create agent-specific prompt
        agent_prompts = {
            AgentType.FINANCIAL_ANALYST: f"You are a Financial Analyst expert. Provide detailed financial analysis in response to: {request.message}",
            AgentType.MARKET_ANALYST: f"You are a Market Analyst expert. Analyze market trends and provide insights about: {request.message}",
            AgentType.EXPERT_INVESTOR: f"You are an Expert Investor. Provide investment advice and strategies for: {request.message}",
            AgentType.ACCOUNTANT: f"You are an Accountant expert. Provide budgeting and financial planning advice for: {request.message}"
        }
        
        prompt = agent_prompts.get(agent, f"You are a financial expert. Respond to: {request.message}")
        
        # Generate response
        response_text = await hf_client.generate_text(prompt, agent)
        
        # Add agent label to response
        agent_labels = {
            AgentType.FINANCIAL_ANALYST: "Financial Analyst",
            AgentType.MARKET_ANALYST: "Market Analyst",
            AgentType.EXPERT_INVESTOR: "Expert Investor",
            AgentType.ACCOUNTANT: "Accountant"
        }
        agent_label = agent_labels.get(agent, "Specialized Agent")
        labeled_response = f"[{agent_label}] {response_text}"
        
        return StackMasterResponse(
            response=labeled_response,
            advice_type="specialized",
            actionable_steps=[],
            motivational_message="Stack your bread, stack your future!"
        )
    except HTTPException:
        raise
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error chatting with agent: {str(e)}")

@app.get("/agents")
async def list_available_agents():
    """List all available specialized agents"""
    return {
        "agents": [
            {
                "id": "financial-analyst",
                "name": "Financial Analyst",
                "description": "Expert in financial analysis and credit planning",
                "model": hf_client.models[AgentType.FINANCIAL_ANALYST],
                "endpoint": "/agents/financial-analyst/chat"
            },
            {
                "id": "market-analyst",
                "name": "Market Analyst",
                "description": "Expert in market trends and stock analysis",
                "model": hf_client.models[AgentType.MARKET_ANALYST],
                "endpoint": "/agents/market-analyst/chat"
            },
            {
                "id": "expert-investor",
                "name": "Expert Investor",
                "description": "Expert in investment advice and strategies",
                "model": hf_client.models[AgentType.EXPERT_INVESTOR],
                "endpoint": "/agents/expert-investor/chat"
            },
            {
                "id": "accountant",
                "name": "Accountant",
                "description": "Expert in budgeting and financial planning",
                "model": hf_client.models[AgentType.ACCOUNTANT],
                "endpoint": "/agents/accountant/chat"
            }
        ],
        "shortcuts": [
            {
                "task": "Investment Advice",
                "endpoint": "/investment/advice",
                "agent": "Expert Investor"
            },
            {
                "task": "Credit Building Plan",
                "endpoint": "/credit/building-plan",
                "agent": "Financial Analyst"
            },
            {
                "task": "Budget Analysis",
                "endpoint": "/budget/analysis",
                "agent": "Accountant"
            },
            {
                "task": "Market Analysis",
                "endpoint": "/market/analysis",
                "agent": "Market Analyst"
            }
        ]
    }

# Specialized agent shortcuts
@app.post("/investment/advice")
async def get_investment_advice(request: StackMasterMessage):
    """Get investment advice using Expert Investor agent"""
    try:
        # Use Expert Investor agent
        prompt = f"You are an Expert Investor. Provide investment advice for: {request.message}"
        response_text = await hf_client.generate_text(prompt, AgentType.EXPERT_INVESTOR)
        
        return {
            "advice": f"[Expert Investor] {response_text}",
            "tier": "free",
            "ai_model": hf_client.models[AgentType.EXPERT_INVESTOR],
            "agent_type": "Expert Investor"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error getting investment advice: {str(e)}")

@app.post("/credit/building-plan")
async def create_credit_plan(request: StackMasterMessage):
    """Create credit building plan using Financial Analyst agent"""
    try:
        # Use Financial Analyst agent
        prompt = f"You are a Financial Analyst. Create a credit building plan for: {request.message}"
        response_text = await hf_client.generate_text(prompt, AgentType.FINANCIAL_ANALYST)
        
        return {
            "plan": f"[Financial Analyst] {response_text}",
            "tier": "free", 
            "ai_model": hf_client.models[AgentType.FINANCIAL_ANALYST],
            "agent_type": "Financial Analyst"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error creating credit plan: {str(e)}")

@app.post("/budget/analysis")
async def analyze_budget(request: StackMasterMessage):
    """Analyze budget using Accountant agent"""
    try:
        # Use Accountant agent
        prompt = f"You are an Accountant. Analyze this budget and provide recommendations: {request.message}"
        response_text = await hf_client.generate_text(prompt, AgentType.ACCOUNTANT)
        
        return {
            "analysis": f"[Accountant] {response_text}",
            "tier": "free", 
            "ai_model": hf_client.models[AgentType.ACCOUNTANT],
            "agent_type": "Accountant"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error analyzing budget: {str(e)}")

@app.post("/market/analysis")
async def analyze_market(request: StackMasterMessage):
    """Analyze market using Market Analyst agent"""
    try:
        # Use Market Analyst agent
        prompt = f"You are a Market Analyst. Analyze the market and provide insights about: {request.message}"
        response_text = await hf_client.generate_text(prompt, AgentType.MARKET_ANALYST)
        
        return {
            "analysis": f"[Market Analyst] {response_text}",
            "tier": "free", 
            "ai_model": hf_client.models[AgentType.MARKET_ANALYST],
            "agent_type": "Market Analyst"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error analyzing market: {str(e)}")

if __name__ == "__main__":
    port = int(os.getenv("PORT", 8000))
    print("🚀 Starting StackApp Cloud API...")
    print(f"📱 {STACKAPP_CONFIG['app_name']} - {STACKAPP_CONFIG['tagline']}")
    print("💰 The Stack Master is ready to help you stack your bread!")
    print(f"🌐 Listening on port {port}")
    
    uvicorn.run(
        "stackapp_api_render:app",
        host="0.0.0.0",
        port=port,
        log_level="info"
    )
