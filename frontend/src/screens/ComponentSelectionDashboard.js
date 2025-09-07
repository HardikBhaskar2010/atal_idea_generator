import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useQuery } from 'react-query';
import { motion } from 'framer-motion';
import { Search, Filter, Grid, List, Plus, ArrowRight, Cpu, Zap, Gauge, Eye } from 'lucide-react';
import toast from 'react-hot-toast';

import { apiService } from '../services/apiService';
import { useUser } from '../contexts/UserContext';
import LoadingSpinner from '../components/common/LoadingSpinner';
import DevelopedByFooter from '../components/common/DevelopedByFooter';

const ComponentSelectionDashboard = () => {
  const navigate = useNavigate();
  const { selectedComponents, updateSelectedComponents } = useUser();
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCategory, setSelectedCategory] = useState('All');
  const [viewMode, setViewMode] = useState('grid');
  const [localSelectedComponents, setLocalSelectedComponents] = useState(selectedComponents || []);

  const { data: components = [], isLoading, error } = useQuery(
    'components',
    apiService.getComponents,
    {
      onError: (error) => {
        toast.error('Failed to load components');
        console.error('Components fetch error:', error);
      }
    }
  );

  const categories = ['All', ...new Set(components.map(comp => comp.category))];

  const filteredComponents = components.filter(component => {
    const matchesSearch = component.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
                         component.description.toLowerCase().includes(searchTerm.toLowerCase());
    const matchesCategory = selectedCategory === 'All' || component.category === selectedCategory;
    return matchesSearch && matchesCategory;
  });

  const toggleComponentSelection = (component) => {
    const isSelected = localSelectedComponents.some(comp => comp.id === component.id);
    let newSelection;
    
    if (isSelected) {
      newSelection = localSelectedComponents.filter(comp => comp.id !== component.id);
      toast.success(`Removed ${component.name}`);
    } else {
      newSelection = [...localSelectedComponents, component];
      toast.success(`Added ${component.name}`);
    }
    
    setLocalSelectedComponents(newSelection);
  };

  const handleContinue = () => {
    if (localSelectedComponents.length === 0) {
      toast.error('Please select at least one component to continue');
      return;
    }
    
    updateSelectedComponents(localSelectedComponents);
    toast.success(`Selected ${localSelectedComponents.length} components`);
    navigate('/theme-selection');
  };

  const getCategoryIcon = (category) => {
    switch (category.toLowerCase()) {
      case 'microcontrollers': return Cpu;
      case 'sensors': return Gauge;
      case 'actuators': return Zap;
      default: return Plus;
    }
  };

  if (isLoading) {
    return (
      <div className="min-h-screen bg-surface-light dark:bg-surface-dark flex items-center justify-center">
        <LoadingSpinner size="lg" text="Loading components..." />
      </div>
    );
  }

  if (error) {
    return (
      <div className="min-h-screen bg-surface-light dark:bg-surface-dark flex items-center justify-center">
        <div className="text-center">
          <h2 className="text-2xl font-bold text-gray-900 dark:text-white mb-4">
            Failed to Load Components
          </h2>
          <p className="text-gray-600 dark:text-gray-400 mb-4">
            Please check your connection and try again.
          </p>
          <button 
            onClick={() => window.location.reload()}
            className="btn-primary"
          >
            Retry
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-surface-light dark:bg-surface-dark">
      {/* Header */}
      <div className="sticky top-0 z-10 bg-white/80 dark:bg-gray-800/80 backdrop-blur-sm border-b border-gray-200 dark:border-gray-700">
        <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-4">
          <div className="flex items-center justify-between mb-4">
            <div>
              <h1 className="text-2xl font-bold text-gray-900 dark:text-white">
                Component Selection
              </h1>
              <p className="text-gray-600 dark:text-gray-400">
                Select components for your next project ({localSelectedComponents.length} selected)
              </p>
            </div>
            
            {localSelectedComponents.length > 0 && (
              <motion.button
                initial={{ scale: 0 }}
                animate={{ scale: 1 }}
                onClick={handleContinue}
                className="btn-primary flex items-center space-x-2 shadow-lg hover:shadow-xl transform hover:scale-105 transition-all duration-200"
              >
                <span>Continue</span>
                <ArrowRight className="h-4 w-4" />
              </motion.button>
            )}
          </div>

          {/* Search and Filter Bar */}
          <div className="flex flex-col sm:flex-row gap-4">
            <div className="relative flex-1">
              <Search className="absolute left-3 top-1/2 transform -translate-y-1/2 text-gray-400 h-5 w-5" />
              <input
                type="text"
                placeholder="Search components..."
                value={searchTerm}
                onChange={(e) => setSearchTerm(e.target.value)}
                className="input-field pl-10"
              />
            </div>
            
            <div className="flex items-center space-x-2">
              <select
                value={selectedCategory}
                onChange={(e) => setSelectedCategory(e.target.value)}
                className="input-field min-w-32"
              >
                {categories.map(category => (
                  <option key={category} value={category}>{category}</option>
                ))}
              </select>
              
              <div className="flex bg-gray-100 dark:bg-gray-700 rounded-lg p-1">
                <button
                  onClick={() => setViewMode('grid')}
                  className={`p-2 rounded ${viewMode === 'grid' ? 'bg-white dark:bg-gray-600 shadow' : ''}`}
                >
                  <Grid className="h-4 w-4" />
                </button>
                <button
                  onClick={() => setViewMode('list')}
                  className={`p-2 rounded ${viewMode === 'list' ? 'bg-white dark:bg-gray-600 shadow' : ''}`}
                >
                  <List className="h-4 w-4" />
                </button>
              </div>
            </div>
          </div>
        </div>
      </div>

      {/* Components Grid/List */}
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-8">
        {filteredComponents.length === 0 ? (
          <div className="text-center py-16">
            <div className="text-gray-400 mb-4">
              <Filter className="h-16 w-16 mx-auto" />
            </div>
            <h3 className="text-lg font-medium text-gray-900 dark:text-white mb-2">
              No components found
            </h3>
            <p className="text-gray-600 dark:text-gray-400">
              Try adjusting your search or filter criteria
            </p>
          </div>
        ) : (
          <div className={
            viewMode === 'grid'
              ? 'grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4 gap-6'
              : 'space-y-4'
          }>
            {filteredComponents.map((component, index) => {
              const isSelected = localSelectedComponents.some(comp => comp.id === component.id);
              const CategoryIcon = getCategoryIcon(component.category);
              
              return (
                <motion.div
                  key={component.id}
                  initial={{ opacity: 0, y: 20 }}
                  animate={{ opacity: 1, y: 0 }}
                  transition={{ delay: index * 0.1 }}
                  className={`card p-6 cursor-pointer transition-all duration-200 hover:shadow-lg ${
                    isSelected ? 'ring-2 ring-primary bg-primary/5' : 'hover:shadow-md'
                  }`}
                  onClick={() => toggleComponentSelection(component)}
                >
                  <div className="flex items-start justify-between mb-4">
                    <div className={`p-2 rounded-lg ${isSelected ? 'bg-primary text-white' : 'bg-gray-100 dark:bg-gray-700'}`}>
                      <CategoryIcon className="h-6 w-6" />
                    </div>
                    <span className={`px-2 py-1 rounded-full text-xs font-medium ${
                      component.availability === 'Available'
                        ? 'bg-green-100 text-green-800 dark:bg-green-800 dark:text-green-100'
                        : component.availability === 'Partially Available'
                        ? 'bg-yellow-100 text-yellow-800 dark:bg-yellow-800 dark:text-yellow-100'
                        : 'bg-red-100 text-red-800 dark:bg-red-800 dark:text-red-100'
                    }`}>
                      {component.availability}
                    </span>
                  </div>
                  
                  <h3 className="font-semibold text-gray-900 dark:text-white mb-2">
                    {component.name}
                  </h3>
                  
                  <p className="text-sm text-gray-600 dark:text-gray-400 mb-3 line-clamp-2">
                    {component.description}
                  </p>
                  
                  <div className="flex items-center justify-between">
                    <span className="text-sm font-medium text-primary">
                      {component.price_range}
                    </span>
                    <span className="text-xs text-gray-500 dark:text-gray-400">
                      {component.category}
                    </span>
                  </div>
                  
                  {isSelected && (
                    <motion.div
                      initial={{ scale: 0 }}
                      animate={{ scale: 1 }}
                      className="mt-3 text-center"
                    >
                      <span className="inline-flex items-center px-2 py-1 rounded-full text-xs font-medium bg-primary text-white">
                        ✓ Selected
                      </span>
                    </motion.div>
                  )}
                </motion.div>
              );
            })}
          </div>
        )}
      </div>

      {/* Floating Action Button */}
      {localSelectedComponents.length > 0 && (
        <motion.div
          initial={{ scale: 0 }}
          animate={{ scale: 1 }}
          className="fixed bottom-8 right-8 z-20"
        >
          <button
            onClick={handleContinue}
            className="bg-primary hover:bg-primary/90 text-white p-4 rounded-full shadow-lg hover:shadow-xl transform hover:scale-110 transition-all duration-200"
          >
            <ArrowRight className="h-6 w-6" />
          </button>
        </motion.div>
      )}

      <DevelopedByFooter />
    </div>
  );
};

export default ComponentSelectionDashboard;