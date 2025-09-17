#!/usr/bin/env python3
"""
StackApp API - Free Hugging Face Version
The Black Community's Financial Powerhouse Backend
Uses Hugging Face free models - No API keys required!
"""

import os
import json
import asyncio
from datetime import datetime, timedelta
from typing import Dict, List, Optional, Any
from fastapi import FastAPI, HTTPException, Depends, BackgroundTasks
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from pydantic import BaseModel, Field
import uvicorn
from contextlib import asynccontextmanager

# Hugging Face imports
from huggingface_hub import InferenceClient

# StackApp Configuration
STACKAPP_CONFIG = {
    "app_name": "StackApp",
    "tagline": "Stack Your Bread, Stack Your Future",
    "version": "1.0.0-MVP-FREE-HF",
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

class StackAnalysisRequest(BaseModel):
    """Request model for stack analysis"""
    user_id: str
    current_income: Optional[float] = None
    current_savings: Optional[float] = None
    monthly_expenses: Optional[float] = None
    credit_score: Optional[int] = None
    investment_goals: Optional[List[str]] = []
    risk_tolerance: Optional[str] = "moderate"

# Free Hugging Face AI Coach
class HuggingFaceStackMaster:
    """Free Stack Master using Qwen model - No API key required!"""
    
    def __init__(self):
        # Initialize Hugging Face client with Qwen model (FREE)
        try:
            # Use Qwen model directly - no API key required for free tier
            self.client = InferenceClient()
            self.model = "Qwen/Qwen2.5-7B-Instruct"  # Free model for all users
            self.use_paid_model = False
            print("✅ Using Qwen model - FREE for all users!")
            print("💰 FinRobot agents locked behind $9.99 beta paywall")
        except Exception as e:
            print(f"⚠️ Hugging Face client error: {e}")
            self.client = None
            self.use_paid_model = False
        
        # Fallback responses for when API is slow or unavailable
        self.fallback_responses = {
            "greeting": [
                "Yo! I'm your Stack Master. Ready to turn your financial dreams into reality? What's your biggest money goal right now?",
                "What's good! I'm here to help you stack your bread. Let's talk about your financial goals.",
                "Hey there! The Stack Master is in the building. What's your money situation looking like?"
            ],
            "investment": [
                "Real talk - let's break this down. First step is tracking every dollar. You can't stack what you can't see. Start with the 50/30/20 rule: 50% needs, 30% wants, 20% wealth building.",
                "Investing $50 a month can turn into $50k over time. Compound interest is how the rich stay rich. Time to join the club.",
                "Your money needs to work for you, not the other way around. Start with index funds, then level up to individual stocks."
            ],
            "credit": [
                "Your credit score is your power score. Every payment on time is money in the bank. Let's get you to 750+ and unlock real wealth opportunities.",
                "Credit is power - let's build yours! Pay your bills on time, keep balances low, and watch your score climb.",
                "A good credit score opens doors to better rates on everything. Let's get you stacking with better credit."
            ],
            "savings": [
                "I see you trying to level up! Let's get you a $500 emergency fund first. That's your foundation. Then we build the real stack from there.",
                "Emergency fund first, then we stack. You need that safety net before you start investing.",
                "Save first, spend second. That's the Stack Master way. Build that emergency fund, then we talk investments."
            ],
            "general": [
                "Every dollar you save is a dollar working for you. Let's make your money work harder than you do.",
                "Wealth building is a marathon, not a sprint. Stay consistent and watch your stack grow.",
                "The best time to start stacking was yesterday. The second best time is right now."
            ]
        }
        
        self.keywords = {
            "investment": ["invest", "stock", "portfolio", "market", "trading", "buy", "sell"],
            "credit": ["credit", "score", "debt", "loan", "payment", "interest"],
            "savings": ["save", "saving", "budget", "money", "cash", "emergency"]
        }
    
    async def get_response(self, message: str, context: Dict[str, Any] = {}) -> StackMasterResponse:
        """Generate response using Hugging Face models"""
        try:
            # Try to use Hugging Face API first
            if self.client:
                response = await self._call_huggingface_api(message, context)
                if response:
                    return self._format_response(response, message, context)
        except Exception as e:
            print(f"Hugging Face API error: {e}")
        
        # Fallback to rule-based responses
        return self._get_fallback_response(message, context)
    
    async def _call_huggingface_api(self, message: str, context: Dict[str, Any]) -> Optional[str]:
        """Call Hugging Face API"""
        try:
            # Create Stack Master prompt
            prompt = self._create_stack_master_prompt(message, context)
            
            if self.use_paid_model:
                # Use the Qwen model you found
                completion = self.client.chat.completions.create(
                    model=self.model,
                    messages=[
                        {
                            "role": "system",
                            "content": "You are The Stack Master, an AI financial coach for the Black community. Use authentic, culturally-aware language. Give real talk financial advice that resonates with the community."
                        },
                        {
                            "role": "user",
                            "content": prompt
                        }
                    ],
                )
                return completion.choices[0].message.content
            else:
                # Use free model
                response = self.client.text_generation(
                    prompt,
                    max_new_tokens=150,
                    temperature=0.7,
                    do_sample=True
                )
                return response
                
        except Exception as e:
            print(f"Hugging Face API call failed: {e}")
            return None
    
    def _create_stack_master_prompt(self, message: str, context: Dict[str, Any]) -> str:
        """Create a prompt that maintains Stack Master personality"""
        context_info = ""
        if context:
            context_info = f"\nUser context: {json.dumps(context, indent=2)}\n"
        
        prompt = f"""You are The Stack Master, an AI financial coach for the Black community. 

Your personality:
- Real talk, street smart, culturally aware
- Use language that resonates with Black culture
- Focus on building wealth, not just spending money
- Be motivational but practical
- Use terms like "stacking", "building your stack", "stacking chips"

User message: {message}
{context_info}

Respond as The Stack Master with authentic, culturally-aware financial advice:"""
        
        return prompt
    
    def _format_response(self, ai_response: str, original_message: str, context: Dict[str, Any]) -> StackMasterResponse:
        """Format AI response with Stack Master personality"""
        # Determine advice type
        advice_type = self._determine_advice_type(original_message)
        
        return StackMasterResponse(
            response=ai_response,
            advice_type=advice_type,
            actionable_steps=self._get_actionable_steps(advice_type, context),
            motivational_message=self._get_motivational_message(advice_type)
        )
    
    def _get_fallback_response(self, message: str, context: Dict[str, Any] = {}) -> StackMasterResponse:
        """Get fallback response using rule-based system"""
        message_lower = message.lower()
        
        # Determine advice type
        advice_type = self._determine_advice_type(message)
        
        # Get appropriate response
        if advice_type in self.fallback_responses:
            response_text = self.fallback_responses[advice_type][0]
        else:
            response_text = self.fallback_responses["general"][0]
        
        # Add personalized advice based on context
        if context.get("income") and context.get("savings"):
            if context["savings"] < 500:
                response_text += " First priority: build that emergency fund to $500, then we stack from there."
            elif context["savings"] < 1000:
                response_text += " Good start on savings! Now let's get you to $1000, then we start investing."
            else:
                response_text += " Solid savings base! Time to start putting that money to work with investments."
        
        return StackMasterResponse(
            response=response_text,
            advice_type=advice_type,
            actionable_steps=self._get_actionable_steps(advice_type, context),
            motivational_message=self._get_motivational_message(advice_type)
        )
    
    def _determine_advice_type(self, message: str) -> str:
        """Determine the type of advice based on message content"""
        message_lower = message.lower()
        for category, keywords in self.keywords.items():
            if any(keyword in message_lower for keyword in keywords):
                return category
        return "general"
    
    def _get_actionable_steps(self, advice_type: str, context: Dict[str, Any]) -> List[str]:
        """Generate actionable steps based on advice type"""
        steps = {
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
        return steps.get(advice_type, steps["general"])
    
    def _get_motivational_message(self, advice_type: str) -> str:
        """Generate motivational message"""
        messages = {
            "investment": "Your future self will thank you for starting today!",
            "credit": "Every payment on time is money in your pocket!",
            "savings": "Small steps lead to big stacks!",
            "general": "You got this! Every expert was once a beginner."
        }
        return messages.get(advice_type, messages["general"])

# Global variables
stack_master = HuggingFaceStackMaster()

@asynccontextmanager
async def lifespan(app: FastAPI):
    """Initialize on startup"""
    print("🚀 StackApp FREE Hugging Face API initialized!")
    print("💰 The Stack Master is ready - No API keys required!")
    print("🆓 Using Hugging Face free models!")
    yield
    print("StackApp FREE API shutting down...")

# Initialize FastAPI app
app = FastAPI(
    title="StackApp FREE API (Hugging Face)",
    description="The Black Community's Financial Powerhouse - Free Backend API",
    version="1.0.0-MVP-FREE-HF",
    lifespan=lifespan
)

# CORS middleware for frontend integration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

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
        "message": "StackApp FREE API is ready to help you stack your bread! 💰",
        "cost": "FREE - No API keys required!",
        "ai_provider": "Hugging Face Free Models"
    }

@app.get("/health")
async def health_check():
    """Health check endpoint"""
    return {"status": "healthy", "timestamp": datetime.now().isoformat()}

# Stack Master AI Coach Endpoints
@app.post("/stack-master/chat", response_model=StackMasterResponse)
async def chat_with_stack_master(request: StackMasterMessage):
    """Chat with The Stack Master AI Coach (FREE with Hugging Face)"""
    try:
        response = await stack_master.get_response(request.message, request.context)
        return response
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error chatting with Stack Master: {str(e)}")

@app.post("/stack-master/analyze-stack")
async def analyze_user_stack(request: StackAnalysisRequest):
    """Analyze user's current financial stack and provide recommendations (FREE)"""
    try:
        # Create analysis based on user data
        analysis = f"""
        Yo, let me break down your financial stack:
        
        Current Income: ${request.current_income or 'Not provided'}
        Current Savings: ${request.current_savings or 'Not provided'}
        Monthly Expenses: ${request.monthly_expenses or 'Not provided'}
        Credit Score: {request.credit_score or 'Not provided'}
        
        Here's what I see:
        """
        
        if request.current_savings and request.current_savings < 500:
            analysis += "First priority: build that emergency fund to $500. That's your foundation."
        elif request.current_savings and request.current_savings < 1000:
            analysis += "Good start on savings! Let's get you to $1000, then we start investing."
        else:
            analysis += "Solid savings base! Time to start putting that money to work."
        
        if request.credit_score and request.credit_score < 650:
            analysis += " Your credit needs work - let's get you to 700+ for better rates."
        
        return {
            "user_id": request.user_id,
            "analysis": analysis,
            "recommendations": {
                "immediate_actions": ["Build emergency fund", "Pay bills on time", "Track spending"],
                "short_term_goals": ["Save $500", "Improve credit score", "Start investing $25/month"],
                "long_term_strategies": ["Build wealth through investments", "Create multiple income streams"]
            },
            "stack_score": 7.2,
            "motivational_message": "Time to stack your bread and build your future! 💰"
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error analyzing stack: {str(e)}")

# Premium FinRobot Endpoints (Beta $9.99)
class PremiumUserRequest(BaseModel):
    """Request model for premium features"""
    user_id: str
    subscription_tier: str = "beta"  # beta, premium, enterprise
    payment_verified: bool = False

@app.post("/premium/finrobot-agents")
async def access_finrobot_agents(request: PremiumUserRequest):
    """Access FinRobot agents - Premium feature ($9.99 beta)"""
    if not request.payment_verified:
        raise HTTPException(
            status_code=402, 
            detail={
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
        )
    
    return {
        "message": "Welcome to FinRobot Premium! 🚀",
        "available_agents": [
            "Equity Research Agent",
            "Portfolio Optimization Agent", 
            "Risk Assessment Agent",
            "Market Analysis Agent"
        ],
        "subscription_tier": request.subscription_tier,
        "beta_price": "$9.99/month",
        "features_unlocked": True
    }

@app.post("/premium/advanced-analysis")
async def advanced_financial_analysis(request: PremiumUserRequest):
    """Advanced financial analysis using FinRobot - Premium feature"""
    if not request.payment_verified:
        raise HTTPException(
            status_code=402,
            detail={
                "error": "Payment required", 
                "message": "Advanced analysis requires $9.99 beta subscription",
                "upgrade_url": "/upgrade-to-premium"
            }
        )
    
    return {
        "message": "Advanced FinRobot analysis unlocked! 💰",
        "analysis_type": "Premium FinRobot Analysis",
        "features": [
            "Multi-factor analysis",
            "Real-time market data",
            "Advanced portfolio optimization",
            "Risk-adjusted returns"
        ]
    }

@app.get("/subscription/plans")
async def get_subscription_plans():
    """Get available subscription plans"""
    return {
        "plans": {
            "free": {
                "price": "$0",
                "features": [
                    "Qwen AI Stack Master",
                    "Basic financial advice",
                    "Community features",
                    "Educational content"
                ],
                "ai_model": "Qwen/Qwen2.5-7B-Instruct"
            },
            "beta": {
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
                "popular": True
            },
            "premium": {
                "price": "$29.99/month",
                "features": [
                    "Everything in Beta",
                    "Real-time market data",
                    "Advanced portfolio tools",
                    "1-on-1 coaching sessions"
                ]
            }
        }
    }

# Free tier endpoints (using Qwen model)
@app.post("/investment/advice")
async def get_investment_advice(request: StackMasterMessage):
    """Get investment advice using Qwen model (FREE)"""
    try:
        response = await stack_master.get_response(
            f"Give investment advice for: {request.message}", 
            request.context
        )
        return {
            "advice": response.response,
            "tier": "free",
            "ai_model": "Qwen/Qwen2.5-7B-Instruct",
            "upgrade_message": "Want FinRobot agents? Upgrade to $9.99 beta!"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error getting investment advice: {str(e)}")

@app.post("/credit/building-plan")
async def create_credit_plan(request: StackMasterMessage):
    """Create credit building plan using Qwen model (FREE)"""
    try:
        response = await stack_master.get_response(
            f"Create a credit building plan for: {request.message}",
            request.context
        )
        return {
            "plan": response.response,
            "tier": "free", 
            "ai_model": "Qwen/Qwen2.5-7B-Instruct",
            "upgrade_message": "Want advanced FinRobot credit analysis? Upgrade to $9.99 beta!"
        }
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error creating credit plan: {str(e)}")

@app.get("/community/stack-challenges")
async def get_stack_challenges():
    """Get community challenges (FREE)"""
    return {
        "challenges": [
            {
                "title": "30-Day Emergency Fund Challenge",
                "description": "Build a $500 emergency fund in 30 days",
                "reward": "Financial security foundation",
                "tier": "free"
            },
            {
                "title": "Credit Score Boost Challenge", 
                "description": "Increase your credit score by 50 points",
                "reward": "Better loan rates and opportunities",
                "tier": "free"
            }
        ],
        "premium_challenges": [
            {
                "title": "Advanced Portfolio Challenge",
                "description": "Build a diversified investment portfolio",
                "reward": "FinRobot portfolio optimization",
                "tier": "premium",
                "price": "$9.99"
            }
        ]
    }

@app.get("/education/topics")
async def get_education_topics():
    """Get financial education topics (FREE)"""
    return {
        "topics": [
            {
                "title": "Building Your First Emergency Fund",
                "description": "Learn how to build financial security",
                "tier": "free",
                "ai_model": "Qwen"
            },
            {
                "title": "Understanding Credit Scores",
                "description": "Master your credit and unlock opportunities", 
                "tier": "free",
                "ai_model": "Qwen"
            }
        ],
        "premium_topics": [
            {
                "title": "Advanced Investment Strategies",
                "description": "FinRobot-powered investment analysis",
                "tier": "premium",
                "ai_model": "FinRobot",
                "price": "$9.99"
            }
        ]
    }

if __name__ == "__main__":
    print("🚀 Starting StackApp FREE Hugging Face API...")
    print(f"📱 {STACKAPP_CONFIG['app_name']} - {STACKAPP_CONFIG['tagline']}")
    print("💰 The Stack Master is ready to help you stack your bread!")
    print("🆓 FREE VERSION - Hugging Face models - No API keys required!")
    
    uvicorn.run(
        "stackapp_api_huggingface:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )
