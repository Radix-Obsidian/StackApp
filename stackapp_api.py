#!/usr/bin/env python3
"""
StackApp API - The Black Community's Financial Powerhouse Backend
Streamlined MVP version of FinRobot for StackApp

Core Features:
- AI Financial Coach ("The Stack Master")
- Investment Analysis
- Credit Building Guidance
- Financial Education
- Community Features
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

# Import FinRobot components we need for MVP
from finrobot.agents.workflow import SingleAssistant
from finrobot.data_source import FinnHubUtils, YFinanceUtils, FMPUtils
from finrobot.functional.analyzer import AnalyzerUtils
from finrobot.functional.charting import ChartingUtils
from finrobot.utils import get_current_date, register_keys_from_json
import autogen

# StackApp Configuration
STACKAPP_CONFIG = {
    "app_name": "StackApp",
    "tagline": "Stack Your Bread, Stack Your Future",
    "version": "1.0.0-MVP",
    "ai_coach_name": "The Stack Master",
    "target_community": "Black Community Financial Empowerment"
}

# API Models
class StackAnalysisRequest(BaseModel):
    """Request model for stack analysis"""
    user_id: str
    current_income: Optional[float] = None
    current_savings: Optional[float] = None
    monthly_expenses: Optional[float] = None
    credit_score: Optional[int] = None
    investment_goals: Optional[List[str]] = []
    risk_tolerance: Optional[str] = "moderate"  # conservative, moderate, aggressive

class InvestmentAdviceRequest(BaseModel):
    """Request model for investment advice"""
    user_id: str
    amount_to_invest: float
    investment_horizon: str  # short-term, medium-term, long-term
    risk_tolerance: str
    investment_type: Optional[str] = "stocks"  # stocks, etfs, crypto, real_estate

class CreditBuildingRequest(BaseModel):
    """Request model for credit building advice"""
    user_id: str
    current_score: int
    current_debt: float
    monthly_income: float
    goals: List[str] = []

class StackMasterMessage(BaseModel):
    """Message to the Stack Master AI Coach"""
    user_id: str
    message: str
    context: Optional[Dict[str, Any]] = {}

class StackMasterResponse(BaseModel):
    """Response from the Stack Master AI Coach"""
    response: str
    advice_type: str  # investment, credit, savings, general
    actionable_steps: List[str] = []
    motivational_message: str = ""

# Global variables for AI agents
stack_master_agent = None
market_analyst_agent = None

@asynccontextmanager
async def lifespan(app: FastAPI):
    """Initialize AI agents on startup"""
    global stack_master_agent, market_analyst_agent
    
    # Load API keys
    try:
        register_keys_from_json("config_api_keys")
    except:
        print("Warning: API keys not found. Some features may not work.")
    
    # Initialize LLM config
    llm_config = {
        "config_list": autogen.config_list_from_json(
            "OAI_CONFIG_LIST",
            filter_dict={"model": ["gpt-4-0125-preview"]},
        ),
        "timeout": 120,
        "temperature": 0.7,  # More creative for Stack Master
    }
    
    # Initialize Stack Master AI Coach
    stack_master_system_message = f"""
    You are "The Stack Master" - an AI financial coach for StackApp, the Black community's financial powerhouse.
    
    Your personality:
    - Real talk, street smart, culturally aware
    - Encouraging but honest about financial reality
    - Use language that resonates with Black culture
    - Focus on building wealth, not just spending money
    - Be motivational but practical
    
    Your expertise:
    - Investment strategies for building wealth
    - Credit building and repair
    - Budgeting and saving techniques
    - Business and entrepreneurship
    - Real estate investment
    - Financial education and literacy
    
    Your communication style:
    - "Yo, let's talk about your stack"
    - "Time to stack your bread, not just spend it"
    - "Your stack is your power"
    - "From the block to the boardroom"
    - Use terms like "stacking", "building your stack", "stacking chips"
    
    Always provide:
    1. Real, actionable advice
    2. Motivational encouragement
    3. Cultural context and understanding
    4. Step-by-step guidance
    5. Honest assessment of financial situations
    
    Remember: You're not just giving financial advice, you're empowering a community to build generational wealth.
    """
    
    stack_master_agent = SingleAssistant(
        "Stack_Master",
        llm_config,
        system_message=stack_master_system_message,
        human_input_mode="NEVER",
    )
    
    # Initialize Market Analyst
    market_analyst_agent = SingleAssistant(
        "Market_Analyst",
        llm_config,
        human_input_mode="NEVER",
    )
    
    print("🚀 StackApp API initialized - The Stack Master is ready!")
    yield
    
    # Cleanup on shutdown
    print("StackApp API shutting down...")

# Initialize FastAPI app
app = FastAPI(
    title="StackApp API",
    description="The Black Community's Financial Powerhouse - Backend API",
    version="1.0.0-MVP",
    lifespan=lifespan
)

# CORS middleware for frontend integration
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],  # Configure properly for production
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
        "message": "StackApp API is ready to help you stack your bread! 💰"
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
        if not stack_master_agent:
            raise HTTPException(status_code=500, detail="Stack Master not initialized")
        
        # Create context-aware message
        context_info = ""
        if request.context:
            context_info = f"\nUser context: {json.dumps(request.context, indent=2)}\n"
        
        full_message = f"{context_info}User message: {request.message}"
        
        # Get response from Stack Master
        response = stack_master_agent.chat(full_message)
        
        # Extract the last message as the response
        if hasattr(stack_master_agent, 'chat_messages') and stack_master_agent.chat_messages:
            last_message = stack_master_agent.chat_messages[-1]
            response_text = last_message.get('content', 'Sorry, I need a moment to think about that.')
        else:
            response_text = "Yo, let me help you stack your bread! What's your financial situation looking like?"
        
        # Determine advice type and extract actionable steps
        advice_type = "general"
        actionable_steps = []
        motivational_message = ""
        
        if any(word in response_text.lower() for word in ["invest", "investment", "stock", "portfolio"]):
            advice_type = "investment"
        elif any(word in response_text.lower() for word in ["credit", "score", "debt", "loan"]):
            advice_type = "credit"
        elif any(word in response_text.lower() for word in ["save", "saving", "budget", "money"]):
            advice_type = "savings"
        
        # Extract motivational message (usually the last sentence)
        sentences = response_text.split('.')
        if len(sentences) > 1:
            motivational_message = sentences[-2].strip() + "."
        
        return StackMasterResponse(
            response=response_text,
            advice_type=advice_type,
            actionable_steps=actionable_steps,
            motivational_message=motivational_message
        )
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error chatting with Stack Master: {str(e)}")

@app.post("/stack-master/analyze-stack")
async def analyze_user_stack(request: StackAnalysisRequest):
    """Analyze user's current financial stack and provide recommendations"""
    try:
        if not stack_master_agent:
            raise HTTPException(status_code=500, detail="Stack Master not initialized")
        
        # Create analysis message
        analysis_message = f"""
        Analyze this user's financial stack and provide recommendations:
        
        Current Income: ${request.current_income or 'Not provided'}
        Current Savings: ${request.current_savings or 'Not provided'}
        Monthly Expenses: ${request.monthly_expenses or 'Not provided'}
        Credit Score: {request.credit_score or 'Not provided'}
        Investment Goals: {', '.join(request.investment_goals) if request.investment_goals else 'Not specified'}
        Risk Tolerance: {request.risk_tolerance}
        
        Provide:
        1. Assessment of current financial health
        2. Specific recommendations for improvement
        3. Actionable steps to build their stack
        4. Motivational message in StackApp style
        """
        
        response = stack_master_agent.chat(analysis_message)
        
        # Extract response
        if hasattr(stack_master_agent, 'chat_messages') and stack_master_agent.chat_messages:
            analysis_response = stack_master_agent.chat_messages[-1].get('content', '')
        else:
            analysis_response = "Let me analyze your stack and help you build it up!"
        
        return {
            "user_id": request.user_id,
            "analysis": analysis_response,
            "recommendations": {
                "immediate_actions": [],
                "short_term_goals": [],
                "long_term_strategies": []
            },
            "stack_score": 0,  # Will implement scoring logic
            "motivational_message": "Time to stack your bread and build your future! 💰"
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error analyzing stack: {str(e)}")

# Investment Analysis Endpoints
@app.post("/investment/advice")
async def get_investment_advice(request: InvestmentAdviceRequest):
    """Get personalized investment advice"""
    try:
        if not market_analyst_agent:
            raise HTTPException(status_code=500, detail="Market analyst not initialized")
        
        advice_message = f"""
        Provide investment advice for:
        - Amount to invest: ${request.amount_to_invest}
        - Investment horizon: {request.investment_horizon}
        - Risk tolerance: {request.risk_tolerance}
        - Investment type: {request.investment_type}
        
        Give specific, actionable advice in StackApp style - real talk about building wealth.
        """
        
        response = market_analyst_agent.chat(advice_message)
        
        if hasattr(market_analyst_agent, 'chat_messages') and market_analyst_agent.chat_messages:
            advice_response = market_analyst_agent.chat_messages[-1].get('content', '')
        else:
            advice_response = "Let me help you turn that money into a real stack!"
        
        return {
            "user_id": request.user_id,
            "advice": advice_response,
            "recommended_actions": [],
            "risk_assessment": request.risk_tolerance,
            "potential_returns": "Varies based on market conditions"
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error getting investment advice: {str(e)}")

@app.get("/investment/stock-analysis/{ticker}")
async def analyze_stock(ticker: str):
    """Analyze a specific stock for investment potential"""
    try:
        if not market_analyst_agent:
            raise HTTPException(status_code=500, detail="Market analyst not initialized")
        
        # Use FinRobot tools to get stock data
        analysis_message = f"""
        Analyze {ticker} stock for investment potential. Use available tools to get:
        1. Current stock price and trends
        2. Company profile and news
        3. Financial metrics
        4. Investment recommendation
        
        Provide analysis in StackApp style - real talk about whether this stock can help build wealth.
        """
        
        response = market_analyst_agent.chat(analysis_message)
        
        if hasattr(market_analyst_agent, 'chat_messages') and market_analyst_agent.chat_messages:
            stock_analysis = market_analyst_agent.chat_messages[-1].get('content', '')
        else:
            stock_analysis = f"Let me analyze {ticker} and see if it's worth stacking!"
        
        return {
            "ticker": ticker.upper(),
            "analysis": stock_analysis,
            "recommendation": "BUY/HOLD/SELL",  # Will implement logic
            "confidence": "High/Medium/Low",  # Will implement logic
            "last_updated": datetime.now().isoformat()
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error analyzing stock {ticker}: {str(e)}")

# Credit Building Endpoints
@app.post("/credit/building-plan")
async def create_credit_building_plan(request: CreditBuildingRequest):
    """Create a personalized credit building plan"""
    try:
        if not stack_master_agent:
            raise HTTPException(status_code=500, detail="Stack Master not initialized")
        
        credit_message = f"""
        Create a credit building plan for:
        - Current credit score: {request.current_score}
        - Current debt: ${request.current_debt}
        - Monthly income: ${request.monthly_income}
        - Goals: {', '.join(request.goals) if request.goals else 'Improve credit score'}
        
        Provide a step-by-step plan to build credit and improve financial standing.
        Use StackApp style - real talk about credit and building wealth.
        """
        
        response = stack_master_agent.chat(credit_message)
        
        if hasattr(stack_master_agent, 'chat_messages') and stack_master_agent.chat_messages:
            credit_plan = stack_master_agent.chat_messages[-1].get('content', '')
        else:
            credit_plan = "Let me help you build that credit and stack your bread!"
        
        return {
            "user_id": request.user_id,
            "current_score": request.current_score,
            "target_score": min(850, request.current_score + 100),  # Realistic target
            "plan": credit_plan,
            "timeline": "6-12 months",
            "monthly_actions": [],
            "motivational_message": "Credit is power - let's build yours! 💪"
        }
        
    except Exception as e:
        raise HTTPException(status_code=500, detail=f"Error creating credit plan: {str(e)}")

# Community Features Endpoints
@app.get("/community/stack-challenges")
async def get_stack_challenges():
    """Get current stack building challenges"""
    challenges = [
        {
            "id": "30-day-save",
            "name": "30-Day Stack Challenge",
            "description": "Save $100 in 30 days",
            "reward": "Stack Master badge",
            "participants": 1250,
            "difficulty": "Beginner"
        },
        {
            "id": "credit-boost",
            "name": "Credit Boost Challenge",
            "description": "Improve credit score by 50 points in 6 months",
            "reward": "Credit Builder badge",
            "participants": 890,
            "difficulty": "Intermediate"
        },
        {
            "id": "investment-start",
            "name": "First Investment Challenge",
            "description": "Make your first $100 investment",
            "reward": "Investor badge",
            "participants": 2100,
            "difficulty": "Beginner"
        }
    ]
    return {"challenges": challenges}

@app.get("/community/success-stories")
async def get_success_stories():
    """Get community success stories"""
    stories = [
        {
            "id": "story-1",
            "user": "Marcus J.",
            "achievement": "Built $50K stack in 2 years",
            "story": "Started with $500, now I'm stacking serious bread!",
            "category": "Investment",
            "verified": True
        },
        {
            "id": "story-2", 
            "user": "Keisha M.",
            "achievement": "Improved credit from 580 to 750",
            "story": "StackApp helped me understand credit and build my score",
            "category": "Credit Building",
            "verified": True
        }
    ]
    return {"stories": stories}

# Financial Education Endpoints
@app.get("/education/topics")
async def get_education_topics():
    """Get available financial education topics"""
    topics = [
        {
            "id": "budgeting-basics",
            "title": "Budgeting Basics - Stack Your Money Right",
            "description": "Learn how to budget and save money effectively",
            "difficulty": "Beginner",
            "duration": "15 minutes"
        },
        {
            "id": "investment-101",
            "title": "Investment 101 - Turn $10 into $100",
            "description": "Introduction to investing and building wealth",
            "difficulty": "Beginner", 
            "duration": "20 minutes"
        },
        {
            "id": "credit-mastery",
            "title": "Credit Mastery - Build Your Financial Power",
            "description": "Understanding credit and how to improve your score",
            "difficulty": "Intermediate",
            "duration": "25 minutes"
        }
    ]
    return {"topics": topics}

# Utility Endpoints
@app.get("/market/trending-stocks")
async def get_trending_stocks():
    """Get trending stocks for investment opportunities"""
    # This would integrate with FinRobot's market analysis
    trending = [
        {"ticker": "AAPL", "name": "Apple Inc.", "change": "+2.5%", "sentiment": "Bullish"},
        {"ticker": "TSLA", "name": "Tesla Inc.", "change": "+1.8%", "sentiment": "Bullish"},
        {"ticker": "NVDA", "name": "NVIDIA Corp.", "change": "+3.2%", "sentiment": "Very Bullish"}
    ]
    return {"trending_stocks": trending}

if __name__ == "__main__":
    print("🚀 Starting StackApp API...")
    print(f"📱 {STACKAPP_CONFIG['app_name']} - {STACKAPP_CONFIG['tagline']}")
    print("💰 The Stack Master is ready to help you stack your bread!")
    
    uvicorn.run(
        "stackapp_api:app",
        host="0.0.0.0",
        port=8000,
        reload=True,
        log_level="info"
    )
