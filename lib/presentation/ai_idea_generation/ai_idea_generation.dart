import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';
import '../../widgets/custom_icon_widget.dart';
import './widgets/loading_animation_widget.dart';
import './widgets/loading_messages_widget.dart';
import './widgets/project_card_widget.dart';
import './widgets/project_details_modal.dart';

class AiIdeaGeneration extends StatefulWidget {
  const AiIdeaGeneration({super.key});

  @override
  State<AiIdeaGeneration> createState() => _AiIdeaGenerationState();
}

class _AiIdeaGenerationState extends State<AiIdeaGeneration>
    with TickerProviderStateMixin {
  bool _isLoading = true;
  bool _hasError = false;
  List<Map<String, dynamic>> _generatedProjects = [];
  Set<String> _savedProjects = {};

  late AnimationController _fabController;
  late Animation<double> _fabAnimation;

  // Mock data for generated projects
  final List<Map<String, dynamic>> _mockProjects = [
    {
      "id": "1",
      "title": "Smart Plant Watering System",
      "description":
          "An automated irrigation system that monitors soil moisture and waters plants when needed using Arduino and sensors.",
      "problemStatement":
          "Many people struggle to maintain proper watering schedules for their plants, leading to over-watering or under-watering, which can harm plant health.",
      "workingPrinciple":
          "The system uses a soil moisture sensor to detect when the soil becomes dry. When moisture levels drop below a threshold, the Arduino triggers a water pump to irrigate the plant. An LCD display shows current moisture levels and watering status.",
      "difficulty": "Beginner",
      "estimatedCost": "₹850",
      "components": [
        "Arduino Uno",
        "Soil Moisture Sensor",
        "Water Pump",
        "LCD Display",
        "Relay Module",
        "Jumper Wires",
        "Breadboard"
      ],
      "innovationElements": [
        "Automatic threshold adjustment based on plant type",
        "SMS notifications when water tank is empty",
        "Solar panel integration for eco-friendly operation"
      ],
      "scalabilityOptions": [
        "Multiple plant monitoring with individual sensors",
        "IoT connectivity for remote monitoring via mobile app",
        "Weather API integration to adjust watering based on rainfall predictions"
      ],
      "availability": "Available",
      "animationDelay": 100,
    },
    {
      "id": "2",
      "title": "Air Quality Monitor with Alert System",
      "description":
          "A comprehensive air quality monitoring device that measures PM2.5, CO2, and temperature, providing real-time alerts for poor air quality.",
      "problemStatement":
          "Indoor air pollution is a growing concern, especially in urban areas. People need an affordable way to monitor air quality in their homes and workplaces.",
      "workingPrinciple":
          "Multiple sensors collect data on air quality parameters. The microcontroller processes this data and displays it on an OLED screen. When pollution levels exceed safe thresholds, the system triggers visual and audio alerts.",
      "difficulty": "Intermediate",
      "estimatedCost": "₹1,250",
      "components": [
        "ESP32",
        "PM2.5 Sensor",
        "CO2 Sensor",
        "DHT22 Temperature Sensor",
        "OLED Display",
        "Buzzer",
        "LED Strip"
      ],
      "innovationElements": [
        "Machine learning algorithm to predict air quality trends",
        "Integration with smart home systems for automated ventilation",
        "Historical data logging with trend analysis"
      ],
      "scalabilityOptions": [
        "Network of monitors for community-wide air quality mapping",
        "Integration with government air quality databases",
        "Mobile app with personalized health recommendations"
      ],
      "availability": "Partially Available",
      "animationDelay": 200,
    },
    {
      "id": "3",
      "title": "Smart Traffic Light Controller",
      "description":
          "An intelligent traffic management system that adjusts signal timing based on real-time traffic density using computer vision and sensors.",
      "problemStatement":
          "Traditional traffic lights operate on fixed timers, causing unnecessary delays and fuel consumption when traffic patterns vary throughout the day.",
      "workingPrinciple":
          "Camera modules and ultrasonic sensors detect vehicle density at intersections. An AI algorithm processes this data to optimize signal timing, reducing wait times and improving traffic flow efficiency.",
      "difficulty": "Advanced",
      "estimatedCost": "₹2,100",
      "components": [
        "Raspberry Pi 4",
        "Camera Module",
        "Ultrasonic Sensors",
        "Servo Motors",
        "LED Traffic Lights",
        "Power Supply",
        "SD Card"
      ],
      "innovationElements": [
        "Emergency vehicle priority detection using siren recognition",
        "Pedestrian crossing integration with mobile app requests",
        "Weather-adaptive timing for reduced visibility conditions"
      ],
      "scalabilityOptions": [
        "City-wide traffic optimization network",
        "Integration with GPS navigation apps for route optimization",
        "Public transportation priority system integration"
      ],
      "availability": "Available",
      "animationDelay": 300,
    },
    {
      "id": "4",
      "title": "Waste Segregation Robot",
      "description":
          "An automated waste sorting system that uses computer vision to identify and separate recyclable materials from general waste.",
      "problemStatement":
          "Improper waste segregation leads to environmental pollution and makes recycling processes inefficient. Manual sorting is time-consuming and often inaccurate.",
      "workingPrinciple":
          "A camera captures images of waste items on a conveyor belt. Machine learning algorithms classify materials as plastic, metal, paper, or organic waste. Robotic arms then sort items into appropriate bins.",
      "difficulty": "Advanced",
      "estimatedCost": "₹3,500",
      "components": [
        "Raspberry Pi 4",
        "Camera Module",
        "Servo Motors",
        "Conveyor Belt",
        "Ultrasonic Sensors",
        "Robotic Arm Kit",
        "Power Supply"
      ],
      "innovationElements": [
        "Multi-spectral imaging for better material identification",
        "Self-learning algorithm that improves accuracy over time",
        "Integration with waste management tracking systems"
      ],
      "scalabilityOptions": [
        "Industrial-scale waste processing facilities",
        "Household waste sorting units",
        "Integration with smart city waste collection systems"
      ],
      "availability": "Partially Available",
      "animationDelay": 400,
    },
    {
      "id": "5",
      "title": "Smart Health Monitoring Wearable",
      "description":
          "A wearable device that continuously monitors vital signs including heart rate, body temperature, and activity levels with emergency alert features.",
      "problemStatement":
          "Early detection of health issues is crucial, especially for elderly people living alone. Traditional monitoring requires frequent hospital visits and is not continuous.",
      "workingPrinciple":
          "Wearable sensors collect biometric data continuously. The device processes this information to detect anomalies and can send emergency alerts to family members or healthcare providers when critical thresholds are exceeded.",
      "difficulty": "Intermediate",
      "estimatedCost": "₹1,800",
      "components": [
        "ESP32",
        "Heart Rate Sensor",
        "Temperature Sensor",
        "Accelerometer",
        "OLED Display",
        "Bluetooth Module",
        "Battery Pack"
      ],
      "innovationElements": [
        "AI-powered health trend analysis and predictions",
        "Integration with telemedicine platforms",
        "Medication reminder system with compliance tracking"
      ],
      "scalabilityOptions": [
        "Hospital patient monitoring network",
        "Insurance company health tracking programs",
        "Community health monitoring for elderly care facilities"
      ],
      "availability": "Available",
      "animationDelay": 500,
    },
  ];

  @override
  void initState() {
    super.initState();

    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _fabAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeOut,
    ));

    _simulateAIGeneration();
  }

  @override
  void dispose() {
    _fabController.dispose();
    super.dispose();
  }

  Future<void> _simulateAIGeneration() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 8));

      // Simulate successful response
      setState(() {
        _generatedProjects = List.from(_mockProjects);
        _isLoading = false;
      });

      // Show FAB after projects are loaded
      _fabController.forward();
    } catch (e) {
      setState(() {
        _hasError = true;
        _isLoading = false;
      });
    }
  }

  void _generateMoreIdeas() {
    // Shuffle existing projects and add some variation
    final shuffledProjects = List<Map<String, dynamic>>.from(_mockProjects);
    shuffledProjects.shuffle();

    setState(() {
      _generatedProjects = shuffledProjects.take(4).toList();
    });

    // Add animation delay for new cards
    for (int i = 0; i < _generatedProjects.length; i++) {
      _generatedProjects[i]['animationDelay'] = i * 100;
    }
  }

  void _toggleSaveProject(String projectId) {
    setState(() {
      if (_savedProjects.contains(projectId)) {
        _savedProjects.remove(projectId);
      } else {
        _savedProjects.add(projectId);
      }
    });
  }

  void _shareProject(Map<String, dynamic> project) {
    // Implement share functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Sharing "${project['title']}"...'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showProjectDetails(Map<String, dynamic> project) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProjectDetailsModal(project: project),
    );
  }

  void _retryGeneration() {
    _simulateAIGeneration();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'AI Idea Generation',
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: colorScheme.onSurface,
          ),
        ),
        backgroundColor: colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: CustomIconWidget(
            iconName: 'arrow_back',
            color: colorScheme.onSurface,
            size: 6.w,
          ),
        ),
        actions: [
          if (!_isLoading && !_hasError)
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/user-profile');
              },
              icon: CustomIconWidget(
                iconName: 'person',
                color: colorScheme.onSurface,
                size: 6.w,
              ),
            ),
        ],
      ),
      body: _buildBody(),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return _buildLoadingState();
    } else if (_hasError) {
      return _buildErrorState();
    } else if (_generatedProjects.isEmpty) {
      return _buildEmptyState();
    } else {
      return _buildProjectsList();
    }
  }

  Widget _buildLoadingState() {
    return Column(
      children: [
        SizedBox(height: 8.h),
        const LoadingAnimationWidget(),
        SizedBox(height: 4.h),
        const LoadingMessagesWidget(),
      ],
    );
  }

  Widget _buildErrorState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: colorScheme.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'error_outline',
                  color: colorScheme.error,
                  size: 10.w,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'Generation Failed',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Unable to generate project ideas. Please check your internet connection and try again.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Go Back'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _retryGeneration,
                    child: Text('Retry'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(6.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 20.w,
              height: 20.w,
              decoration: BoxDecoration(
                color: colorScheme.primary.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: CustomIconWidget(
                  iconName: 'lightbulb_outline',
                  color: colorScheme.primary,
                  size: 10.w,
                ),
              ),
            ),
            SizedBox(height: 3.h),
            Text(
              'No Ideas Generated',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 1.h),
            Text(
              'Try adjusting your component selection or theme preferences to get better project suggestions.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pushNamed(
                          context, '/component-selection-dashboard');
                    },
                    child: Text('Select Components'),
                  ),
                ),
                SizedBox(width: 4.w),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _retryGeneration,
                    child: Text('Try Again'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProjectsList() {
    return Column(
      children: [
        // Header
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(4.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Generated Ideas',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
              ),
              SizedBox(height: 0.5.h),
              Text(
                '${_generatedProjects.length} project ideas based on your selections',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ],
          ),
        ),

        // Projects list
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.only(bottom: 10.h),
            itemCount: _generatedProjects.length,
            itemBuilder: (context, index) {
              final project = _generatedProjects[index];
              final projectId = project['id'] as String;

              return ProjectCardWidget(
                project: project,
                isSaved: _savedProjects.contains(projectId),
                onViewDetails: () => _showProjectDetails(project),
                onSave: () => _toggleSaveProject(projectId),
                onShare: () => _shareProject(project),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget? _buildFloatingActionButton() {
    if (_isLoading || _hasError || _generatedProjects.isEmpty) {
      return null;
    }

    return AnimatedBuilder(
      animation: _fabAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _fabAnimation.value,
          child: FloatingActionButton.extended(
            onPressed: _generateMoreIdeas,
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
            icon: CustomIconWidget(
              iconName: 'refresh',
              color: Theme.of(context).colorScheme.onPrimary,
              size: 5.w,
            ),
            label: Text(
              'Generate More Ideas',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
          ),
        );
      },
    );
  }
}
