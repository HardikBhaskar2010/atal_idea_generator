from fastapi import FastAPI, HTTPException, Depends
from fastapi.middleware.cors import CORSMiddleware
from fastapi.responses import JSONResponse
from motor.motor_asyncio import AsyncIOMotorClient
from pydantic import BaseModel, Field
from typing import List, Optional, Dict, Any
from datetime import datetime
import os
import uuid
from enum import Enum

# Initialize FastAPI app
app = FastAPI(title="Atal Idea Generator API", version="1.0.0")

# CORS middleware
app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"],
)

# MongoDB connection
MONGO_URL = os.environ.get("MONGO_URL", "mongodb://localhost:27017")
client = AsyncIOMotorClient(MONGO_URL)
db = client.atal_idea_generator

# Pydantic Models
class DifficultyLevel(str, Enum):
    BEGINNER = "Beginner"
    INTERMEDIATE = "Intermediate"
    ADVANCED = "Advanced"

class ComponentAvailability(str, Enum):
    AVAILABLE = "Available"
    PARTIALLY_AVAILABLE = "Partially Available"
    NOT_AVAILABLE = "Not Available"

class Component(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    name: str
    category: str
    description: str
    price_range: str
    availability: ComponentAvailability
    image_url: Optional[str] = None
    specifications: Dict[str, Any] = Field(default_factory=dict)
    created_at: datetime = Field(default_factory=datetime.now)

class UserPreferences(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    selected_themes: List[str] = Field(default_factory=list)
    skill_level: DifficultyLevel = DifficultyLevel.BEGINNER
    preferred_duration: str = "1-2 hours"
    team_size: str = "Individual"
    interests: List[str] = Field(default_factory=list)
    notifications_enabled: bool = True
    dark_mode_enabled: bool = False
    last_updated: datetime = Field(default_factory=datetime.now)

class SavedIdea(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    title: str
    description: str
    problem_statement: str
    working_principle: str
    difficulty: DifficultyLevel
    estimated_cost: str
    components: List[str]
    innovation_elements: List[str]
    scalability_options: List[str]
    availability: ComponentAvailability
    created_at: datetime = Field(default_factory=datetime.now)
    updated_at: datetime = Field(default_factory=datetime.now)
    is_favorite: bool = False
    tags: List[str] = Field(default_factory=list)
    notes: str = ""

class UserStats(BaseModel):
    id: str = Field(default_factory=lambda: str(uuid.uuid4()))
    ideas_generated: int = 0
    projects_completed: int = 0
    components_scanned: int = 0
    days_active: int = 0
    last_active_date: datetime = Field(default_factory=datetime.now)

class IdeaGenerationRequest(BaseModel):
    selected_components: List[str]
    user_preferences: Optional[UserPreferences] = None
    theme: Optional[str] = None
    count: int = 5

# Database helper functions
async def get_collection(collection_name: str):
    return db[collection_name]

# Intelligent idea generation function
async def generate_intelligent_ideas(request: IdeaGenerationRequest):
    """Generate project ideas using intelligent rule-based system"""
    
    # Base project templates with component mappings
    project_templates = [
        {
            "title": "Smart Plant Watering System",
            "description": "An automated irrigation system that monitors soil moisture and waters plants when needed using Arduino and sensors.",
            "problem_statement": "Many people struggle to maintain proper watering schedules for their plants, leading to over-watering or under-watering, which can harm plant health.",
            "working_principle": "The system uses a soil moisture sensor to detect when the soil becomes dry. When moisture levels drop below a threshold, the Arduino triggers a water pump to irrigate the plant.",
            "difficulty": "Beginner",
            "estimated_cost": "₹850",
            "required_components": ["Arduino Uno", "Soil Moisture Sensor", "Water Pump", "LCD Display", "Relay Module"],
            "innovation_elements": ["Automatic threshold adjustment", "SMS notifications", "Solar panel integration"],
            "scalability_options": ["Multiple plant monitoring", "IoT connectivity", "Weather API integration"],
            "tags": ["Agriculture", "IoT", "Automation"],
            "theme": "Agriculture"
        },
        {
            "title": "Air Quality Monitor with Alert System",
            "description": "A comprehensive air quality monitoring device that measures PM2.5, CO2, and temperature, providing real-time alerts for poor air quality.",
            "problem_statement": "Indoor air pollution is a growing concern, especially in urban areas. People need an affordable way to monitor air quality in their homes and workplaces.",
            "working_principle": "Multiple sensors collect data on air quality parameters. The microcontroller processes this data and displays it on an OLED screen. When pollution levels exceed safe thresholds, the system triggers visual and audio alerts.",
            "difficulty": "Intermediate",
            "estimated_cost": "₹1,250",
            "required_components": ["ESP32", "PM2.5 Sensor", "CO2 Sensor", "DHT22 Temperature Sensor", "OLED Display", "Buzzer"],
            "innovation_elements": ["Machine learning predictions", "Smart home integration", "Historical data logging"],
            "scalability_options": ["Community air quality mapping", "Government database integration", "Mobile app with health recommendations"],
            "tags": ["Environment", "Health", "IoT"],
            "theme": "Environment"
        },
        {
            "title": "Smart Traffic Light Controller",
            "description": "An intelligent traffic management system that adjusts signal timing based on real-time traffic density using computer vision and sensors.",
            "problem_statement": "Traditional traffic lights operate on fixed timers, causing unnecessary delays and fuel consumption when traffic patterns vary throughout the day.",
            "working_principle": "Camera modules and ultrasonic sensors detect vehicle density at intersections. An AI algorithm processes this data to optimize signal timing, reducing wait times and improving traffic flow efficiency.",
            "difficulty": "Advanced",
            "estimated_cost": "₹2,100",
            "required_components": ["Raspberry Pi 4", "Camera Module", "Ultrasonic Sensors", "Servo Motors", "LED Traffic Lights"],
            "innovation_elements": ["Emergency vehicle priority detection", "Pedestrian crossing integration", "Weather-adaptive timing"],
            "scalability_options": ["City-wide traffic optimization", "GPS navigation integration", "Public transportation priority"],
            "tags": ["Transportation", "AI", "Smart City"],
            "theme": "Transportation"
        },
        {
            "title": "Waste Segregation Robot",
            "description": "An automated waste sorting system that uses computer vision to identify and separate recyclable materials from general waste.",
            "problem_statement": "Improper waste segregation leads to environmental pollution and makes recycling processes inefficient. Manual sorting is time-consuming and often inaccurate.",
            "working_principle": "A camera captures images of waste items on a conveyor belt. Machine learning algorithms classify materials as plastic, metal, paper, or organic waste. Robotic arms then sort items into appropriate bins.",
            "difficulty": "Advanced",
            "estimated_cost": "₹3,500",
            "required_components": ["Raspberry Pi 4", "Camera Module", "Servo Motors", "Conveyor Belt", "Ultrasonic Sensors", "Robotic Arm Kit"],
            "innovation_elements": ["Multi-spectral imaging", "Self-learning algorithm", "Waste management tracking integration"],
            "scalability_options": ["Industrial-scale processing", "Household sorting units", "Smart city integration"],
            "tags": ["Environment", "Robotics", "AI"],
            "theme": "Environment"
        },
        {
            "title": "Smart Health Monitoring Wearable",
            "description": "A wearable device that continuously monitors vital signs including heart rate, body temperature, and activity levels with emergency alert features.",
            "problem_statement": "Early detection of health issues is crucial, especially for elderly people living alone. Traditional monitoring requires frequent hospital visits and is not continuous.",
            "working_principle": "Wearable sensors collect biometric data continuously. The device processes this information to detect anomalies and can send emergency alerts to family members or healthcare providers when critical thresholds are exceeded.",
            "difficulty": "Intermediate",
            "estimated_cost": "₹1,800",
            "required_components": ["ESP32", "Heart Rate Sensor", "Temperature Sensor", "Accelerometer", "OLED Display", "Bluetooth Module"],
            "innovation_elements": ["AI-powered health trend analysis", "Telemedicine integration", "Medication reminder system"],
            "scalability_options": ["Hospital patient monitoring", "Insurance health tracking", "Elderly care facility integration"],
            "tags": ["Healthcare", "IoT", "Wearables"],
            "theme": "Healthcare"
        }
    ]
    
    # Filter projects based on available components
    selected_components = set(request.selected_components)
    matching_projects = []
    
    for template in project_templates:
        # Calculate component match score
        required_components = set(template["required_components"])
        match_score = len(selected_components.intersection(required_components)) / len(required_components)
        
        # Include projects with at least 30% component match
        if match_score >= 0.3:
            # Create project instance
            project = {
                "id": str(uuid.uuid4()),
                "title": template["title"],
                "description": template["description"],
                "problem_statement": template["problem_statement"],
                "working_principle": template["working_principle"],
                "difficulty": template["difficulty"],
                "estimated_cost": template["estimated_cost"],
                "components": template["required_components"],
                "innovation_elements": template["innovation_elements"],
                "scalability_options": template["scalability_options"],
                "availability": "Available" if match_score >= 0.7 else "Partially Available",
                "created_at": datetime.now(),
                "updated_at": datetime.now(),
                "is_favorite": False,
                "tags": template["tags"],
                "notes": "",
                "match_score": match_score
            }
            matching_projects.append(project)
    
    # Sort by match score and user preferences
    if request.user_preferences:
        # Adjust scoring based on difficulty preference
        for project in matching_projects:
            if project["difficulty"] == request.user_preferences.skill_level:
                project["match_score"] += 0.2
    
    # Sort by match score (descending) and return top results
    matching_projects.sort(key=lambda x: x["match_score"], reverse=True)
    
    # Return requested number of projects (default 5)
    result_count = min(request.count, len(matching_projects))
    return matching_projects[:result_count] if matching_projects else [
        # Fallback project if no matches found
        {
            "id": str(uuid.uuid4()),
            "title": "Custom Component Project",
            "description": "A flexible project that can be adapted to use your selected components for learning and experimentation.",
            "problem_statement": "Learning electronics and programming requires hands-on experience with available components.",
            "working_principle": "Use your selected components to build a basic circuit and program it to perform simple tasks like LED control, sensor reading, or data display.",
            "difficulty": "Beginner",
            "estimated_cost": "₹500",
            "components": request.selected_components,
            "innovation_elements": ["Modular design", "Educational focus", "Expandable functionality"],
            "scalability_options": ["Add more sensors", "Implement wireless communication", "Create user interface"],
            "availability": "Available",
            "created_at": datetime.now(),
            "updated_at": datetime.now(),
            "is_favorite": False,
            "tags": ["Education", "Basic Electronics"],
            "notes": ""
        }
    ]

# API Routes

@app.get("/")
async def root():
    return {"message": "Atal Idea Generator API is running!"}

@app.get("/api/health")
async def health_check():
    return {"status": "healthy", "timestamp": datetime.now()}

# Component endpoints
@app.get("/api/components", response_model=List[Component])
async def get_components():
    """Get all available components"""
    collection = await get_collection("components")
    components = await collection.find().to_list(None)
    return [Component(**comp) for comp in components]

@app.get("/api/components/{component_id}", response_model=Component)
async def get_component(component_id: str):
    """Get a specific component by ID"""
    collection = await get_collection("components")
    component = await collection.find_one({"id": component_id})
    if not component:
        raise HTTPException(status_code=404, detail="Component not found")
    return Component(**component)

@app.get("/api/components/category/{category}")
async def get_components_by_category(category: str):
    """Get components by category"""
    collection = await get_collection("components")
    components = await collection.find({"category": category}).to_list(None)
    return [Component(**comp) for comp in components]

# User Preferences endpoints
@app.get("/api/preferences", response_model=UserPreferences)
async def get_user_preferences():
    """Get user preferences"""
    collection = await get_collection("user_preferences")
    prefs = await collection.find_one({})
    if not prefs:
        # Return default preferences
        default_prefs = UserPreferences()
        await collection.insert_one(default_prefs.dict())
        return default_prefs
    return UserPreferences(**prefs)

@app.post("/api/preferences", response_model=UserPreferences)
async def save_user_preferences(preferences: UserPreferences):
    """Save user preferences"""
    collection = await get_collection("user_preferences")
    preferences.last_updated = datetime.now()
    await collection.replace_one({}, preferences.dict(), upsert=True)
    return preferences

# Saved Ideas endpoints
@app.get("/api/ideas", response_model=List[SavedIdea])
async def get_saved_ideas():
    """Get all saved ideas"""
    collection = await get_collection("saved_ideas")
    ideas = await collection.find().sort("created_at", -1).to_list(None)
    return [SavedIdea(**idea) for idea in ideas]

@app.post("/api/ideas", response_model=SavedIdea)
async def save_idea(idea: SavedIdea):
    """Save a new idea"""
    collection = await get_collection("saved_ideas")
    idea.updated_at = datetime.now()
    await collection.insert_one(idea.dict())
    
    # Update stats
    await increment_stat("ideas_generated")
    return idea

@app.put("/api/ideas/{idea_id}", response_model=SavedIdea)
async def update_idea(idea_id: str, idea: SavedIdea):
    """Update an existing idea"""
    collection = await get_collection("saved_ideas")
    idea.updated_at = datetime.now()
    result = await collection.replace_one({"id": idea_id}, idea.dict())
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Idea not found")
    return idea

@app.delete("/api/ideas/{idea_id}")
async def delete_idea(idea_id: str):
    """Delete an idea"""
    collection = await get_collection("saved_ideas")
    result = await collection.delete_one({"id": idea_id})
    if result.deleted_count == 0:
        raise HTTPException(status_code=404, detail="Idea not found")
    return {"message": "Idea deleted successfully"}

@app.patch("/api/ideas/{idea_id}/favorite")
async def toggle_favorite(idea_id: str, is_favorite: bool):
    """Toggle favorite status of an idea"""
    collection = await get_collection("saved_ideas")
    result = await collection.update_one(
        {"id": idea_id}, 
        {"$set": {"is_favorite": is_favorite, "updated_at": datetime.now()}}
    )
    if result.matched_count == 0:
        raise HTTPException(status_code=404, detail="Idea not found")
    return {"message": "Favorite status updated"}

@app.get("/api/ideas/search")
async def search_ideas(query: str):
    """Search ideas by title, description, or tags"""
    collection = await get_collection("saved_ideas")
    ideas = await collection.find({
        "$or": [
            {"title": {"$regex": query, "$options": "i"}},
            {"description": {"$regex": query, "$options": "i"}},
            {"tags": {"$in": [query]}}
        ]
    }).to_list(None)
    return [SavedIdea(**idea) for idea in ideas]

# AI Idea Generation endpoint
@app.post("/api/generate-ideas")
async def generate_ideas(request: IdeaGenerationRequest):
    """Generate project ideas using AI based on selected components"""
    # This will be implemented with actual AI integration
    # For now, return mock data similar to Flutter app
    mock_ideas = [
        {
            "id": str(uuid.uuid4()),
            "title": "Smart Plant Watering System",
            "description": "An automated irrigation system that monitors soil moisture and waters plants when needed using Arduino and sensors.",
            "problem_statement": "Many people struggle to maintain proper watering schedules for their plants, leading to over-watering or under-watering, which can harm plant health.",
            "working_principle": "The system uses a soil moisture sensor to detect when the soil becomes dry. When moisture levels drop below a threshold, the Arduino triggers a water pump to irrigate the plant.",
            "difficulty": "Beginner",
            "estimated_cost": "₹850",
            "components": ["Arduino Uno", "Soil Moisture Sensor", "Water Pump", "LCD Display", "Relay Module"],
            "innovation_elements": ["Automatic threshold adjustment", "SMS notifications", "Solar panel integration"],
            "scalability_options": ["Multiple plant monitoring", "IoT connectivity", "Weather API integration"],
            "availability": "Available",
            "created_at": datetime.now(),
            "updated_at": datetime.now(),
            "is_favorite": False,
            "tags": ["Agriculture", "IoT", "Automation"],
            "notes": ""
        }
    ]
    
    return mock_ideas

# User Stats endpoints
@app.get("/api/stats", response_model=UserStats)
async def get_user_stats():
    """Get user statistics"""
    collection = await get_collection("user_stats")
    stats = await collection.find_one({})
    if not stats:
        default_stats = UserStats()
        await collection.insert_one(default_stats.dict())
        return default_stats
    return UserStats(**stats)

async def increment_stat(stat_key: str, increment: int = 1):
    """Increment a user statistic"""
    collection = await get_collection("user_stats")
    await collection.update_one(
        {},
        {
            "$inc": {stat_key: increment},
            "$set": {"last_active_date": datetime.now()}
        },
        upsert=True
    )

# Initialize default data
@app.on_event("startup")
async def initialize_database():
    """Initialize database with default data"""
    # Initialize components collection
    components_collection = await get_collection("components")
    if await components_collection.count_documents({}) == 0:
        default_components = [
            {
                "id": str(uuid.uuid4()),
                "name": "Arduino Uno",
                "category": "Microcontrollers",
                "description": "A microcontroller board based on the ATmega328P",
                "price_range": "₹400-600",
                "availability": "Available",
                "specifications": {"voltage": "5V", "pins": 14},
                "created_at": datetime.now()
            },
            {
                "id": str(uuid.uuid4()),
                "name": "Raspberry Pi 4",
                "category": "Single Board Computers",
                "description": "A small single-board computer developed by the Raspberry Pi Foundation",
                "price_range": "₹3000-5000",
                "availability": "Available",
                "specifications": {"ram": "4GB", "ports": "USB, HDMI, GPIO"},
                "created_at": datetime.now()
            },
            {
                "id": str(uuid.uuid4()),
                "name": "Soil Moisture Sensor",
                "category": "Sensors",
                "description": "Sensor to measure the moisture content in soil",
                "price_range": "₹100-200",
                "availability": "Available",
                "specifications": {"type": "Analog", "voltage": "3.3-5V"},
                "created_at": datetime.now()
            }
        ]
        await components_collection.insert_many(default_components)

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8001)