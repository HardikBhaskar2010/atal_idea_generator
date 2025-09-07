import React from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate } from 'react-router-dom';

// Import all screens
import OnboardingFlow from './screens/OnboardingFlow';
import ComponentSelectionDashboard from './screens/ComponentSelectionDashboard';
import ThemeAndSkillSelection from './screens/ThemeAndSkillSelection';
import ComponentDatabaseBrowser from './screens/ComponentDatabaseBrowser';
import AIIdeaGeneration from './screens/AIIdeaGeneration';
import IdeasLibrary from './screens/IdeasLibrary';
import UserProfile from './screens/UserProfile';

// Context Providers
import { ThemeProvider } from './contexts/ThemeContext';
import { UserProvider } from './contexts/UserContext';

// Enhanced components
import EnhancedToastProvider from './components/common/EnhancedToastProvider';

function App() {
  return (
    <ThemeProvider>
      <UserProvider>
        <Router>
          <div className="App min-h-screen bg-surface-light dark:bg-surface-dark transition-colors duration-200">
            <Routes>
              <Route path="/" element={<OnboardingFlow />} />
              <Route path="/onboarding" element={<OnboardingFlow />} />
              <Route path="/component-selection" element={<ComponentSelectionDashboard />} />
              <Route path="/theme-selection" element={<ThemeAndSkillSelection />} />
              <Route path="/component-browser" element={<ComponentDatabaseBrowser />} />
              <Route path="/ai-generation" element={<AIIdeaGeneration />} />
              <Route path="/ideas-library" element={<IdeasLibrary />} />
              <Route path="/profile" element={<UserProfile />} />
              <Route path="*" element={<Navigate to="/" replace />} />
            </Routes>
            
            {/* Enhanced toast notifications */}
            <EnhancedToastProvider />
          </div>
        </Router>
      </UserProvider>
    </ThemeProvider>
  );
}

export default App;