import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { motion, AnimatePresence } from 'framer-motion';
import { useSpring, animated, config } from '@react-spring/web';
import { QrCode, Brain, FolderHeart, ChevronRight, SkipForward, Sparkles } from 'lucide-react';
import DevelopedByFooter from '../components/common/DevelopedByFooter';
import ParticleBackground from '../components/common/ParticleBackground';

const OnboardingFlow = () => {
  const navigate = useNavigate();
  const [currentPage, setCurrentPage] = useState(0);
  const [isAnimating, setIsAnimating] = useState(false);

  // Enhanced background animation
  const [backgroundSpring] = useSpring(() => ({
    from: { 
      background: 'linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%)'
    },
    to: async (next) => {
      while (true) {
        await next({ 
          background: 'linear-gradient(135deg, #667eea 0%, #764ba2 100%)' 
        });
        await next({ 
          background: 'linear-gradient(135deg, #f093fb 0%, #f5576c 100%)' 
        });
        await next({ 
          background: 'linear-gradient(135deg, #4facfe 0%, #00f2fe 100%)' 
        });
        await next({ 
          background: 'linear-gradient(135deg, #43e97b 0%, #38f9d7 100%)' 
        });
        await next({ 
          background: 'linear-gradient(135deg, #f5f7fa 0%, #c3cfe2 100%)' 
        });
      }
    },
    config: { duration: 8000 },
  }));

  // Floating elements animation
  const [floatingSpring] = useSpring(() => ({
    from: { transform: 'translateY(0px)' },
    to: { transform: 'translateY(-20px)' },
    config: config.slow,
    loop: { reverse: true },
  }));

  const onboardingData = [
    {
      title: 'Scan Components',
      description: 'Use your camera to scan QR codes and barcodes on electronic components. Instantly identify parts and add them to your project inventory.',
      icon: QrCode,
      color: 'text-primary',
      bgColor: 'bg-gradient-to-br from-primary/10 to-primary/20',
      particleColor: 'rgba(46, 125, 50, 0.3)',
    },
    {
      title: 'AI-Powered Ideas',
      description: 'Get creative project suggestions based on your available components. Our AI generates unique, feasible ideas tailored to your skill level.',
      icon: Brain,
      color: 'text-accent',
      bgColor: 'bg-gradient-to-br from-accent/10 to-accent/20',
      particleColor: 'rgba(255, 111, 0, 0.3)',
    },
    {
      title: 'Build Your Library',
      description: 'Save your favorite project ideas, export detailed reports, and share innovations with your team. Track your STEM learning journey.',
      icon: FolderHeart,
      color: 'text-secondary',
      bgColor: 'bg-gradient-to-br from-secondary/10 to-secondary/20',
      particleColor: 'rgba(25, 118, 210, 0.3)',
    },
  ];

  useEffect(() => {
    // Check if user has completed onboarding
    const hasCompletedOnboarding = localStorage.getItem('onboardingCompleted');
    if (hasCompletedOnboarding) {
      navigate('/component-selection');
    }
  }, [navigate]);

  const nextPage = () => {
    if (currentPage < onboardingData.length - 1) {
      setCurrentPage(currentPage + 1);
    }
  };

  const skipOnboarding = () => {
    setCurrentPage(onboardingData.length - 1);
  };

  const completeOnboarding = () => {
    localStorage.setItem('onboardingCompleted', 'true');
    navigate('/component-selection');
  };

  const currentData = onboardingData[currentPage];
  const Icon = currentData.icon;

  return (
    <div className="min-h-screen bg-gradient-to-br from-surface-light to-gray-50 dark:from-surface-dark dark:to-gray-900 flex flex-col">
      {/* Skip button */}
      {currentPage < onboardingData.length - 1 && (
        <div className="flex justify-end pt-6 pr-6">
          <button
            onClick={skipOnboarding}
            className="flex items-center space-x-2 text-gray-600 dark:text-gray-400 hover:text-primary transition-colors"
          >
            <span className="font-medium">Skip</span>
            <SkipForward className="h-4 w-4" />
          </button>
        </div>
      )}

      {/* Main content */}
      <div className="flex-1 flex flex-col items-center justify-center px-6 pb-8">
        <AnimatePresence mode="wait">
          <motion.div
            key={currentPage}
            initial={{ opacity: 0, y: 20 }}
            animate={{ opacity: 1, y: 0 }}
            exit={{ opacity: 0, y: -20 }}
            transition={{ duration: 0.3 }}
            className="text-center max-w-md mx-auto"
          >
            {/* Icon */}
            <motion.div
              initial={{ scale: 0 }}
              animate={{ scale: 1 }}
              transition={{ delay: 0.2, type: "spring", stiffness: 200 }}
              className={`inline-flex items-center justify-center w-24 h-24 rounded-full ${currentData.bgColor} mb-8`}
            >
              <Icon className={`h-12 w-12 ${currentData.color}`} />
            </motion.div>

            {/* Title */}
            <motion.h1
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.3 }}
              className="text-3xl font-bold text-gray-900 dark:text-white mb-4"
            >
              {currentData.title}
            </motion.h1>

            {/* Description */}
            <motion.p
              initial={{ opacity: 0, y: 10 }}
              animate={{ opacity: 1, y: 0 }}
              transition={{ delay: 0.4 }}
              className="text-gray-600 dark:text-gray-400 text-lg leading-relaxed mb-12"
            >
              {currentData.description}
            </motion.p>
          </motion.div>
        </AnimatePresence>

        {/* Page indicators */}
        <div className="flex space-x-2 mb-8">
          {onboardingData.map((_, index) => (
            <div
              key={index}
              className={`h-2 rounded-full transition-all duration-300 ${
                index === currentPage
                  ? 'w-8 bg-primary'
                  : index < currentPage
                  ? 'w-2 bg-primary/60'
                  : 'w-2 bg-gray-300 dark:bg-gray-600'
              }`}
            />
          ))}
        </div>

        {/* Navigation buttons */}
        <motion.div
          initial={{ opacity: 0, y: 20 }}
          animate={{ opacity: 1, y: 0 }}
          transition={{ delay: 0.5 }}
          className="w-full max-w-sm"
        >
          {currentPage < onboardingData.length - 1 ? (
            <button
              onClick={nextPage}
              className="w-full btn-primary flex items-center justify-center space-x-2 py-4 text-lg font-semibold rounded-xl shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-200"
            >
              <span>Next</span>
              <ChevronRight className="h-5 w-5" />
            </button>
          ) : (
            <button
              onClick={completeOnboarding}
              className="w-full bg-gradient-to-r from-primary to-secondary hover:from-primary/90 hover:to-secondary/90 text-white flex items-center justify-center space-x-2 py-4 text-lg font-semibold rounded-xl shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-200"
            >
              <span>Get Started</span>
              <ChevronRight className="h-5 w-5" />
            </button>
          )}
        </motion.div>
      </div>

      {/* Footer */}
      <DevelopedByFooter />
    </div>
  );
};

export default OnboardingFlow;