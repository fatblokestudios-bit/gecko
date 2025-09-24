# Gluten Free Gecko SEA

## Overview

Gluten Free Gecko SEA is a Progressive Web Application (PWA) designed to help users find gluten-free restaurants in Southeast Asia. The app features a mobile-first design with native app-like functionality, including offline capabilities, installable interface, and user reputation system. The application focuses on providing a seamless experience for discovering and reviewing gluten-free dining options across the region.

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

### Frontend Architecture
- **Single Page Application (SPA)**: Built with vanilla JavaScript, HTML5, and CSS3 for lightweight performance
- **Mobile-First Design**: Responsive design optimized for mobile devices with touch-friendly interfaces
- **Component-Based Structure**: Modular approach with separate concerns for different app sections (restaurants, profile, paywall)
- **Progressive Web App (PWA)**: Full PWA implementation with service worker for offline functionality and app installation capabilities

### State Management
- **Local Storage Persistence**: User subscription status and reputation points stored in browser localStorage
- **Client-Side State**: Simple state management using JavaScript variables for current tab and user data
- **No External State Library**: Lightweight approach without Redux or similar frameworks

### User Interface
- **Native Mobile Experience**: Custom status bar simulation and mobile app styling
- **Tab-Based Navigation**: Multi-tab interface for restaurants, profile, and premium features
- **Subscription Model**: Freemium model with basic and premium tiers
- **Reputation System**: Point-based user engagement system starting at 120 points

### Offline Capabilities
- **Service Worker Implementation**: Caches critical resources for offline access
- **Cache Strategy**: Cache-first approach for static assets with network fallback
- **Installable App**: Full PWA installation support with custom install prompts

### Cross-Platform Considerations
- **Flutter Migration Path**: Attached Flutter code indicates planned native mobile app development
- **Consistent Design**: Shared design principles between web and potential native implementations

## External Dependencies

### Browser APIs
- **Service Worker API**: For PWA functionality and offline capabilities
- **Web App Manifest**: For app installation and metadata
- **LocalStorage API**: For client-side data persistence
- **Installation Prompt API**: For custom app installation experience

### Development Tools
- **No Build Process**: Direct browser-compatible code without transpilation
- **No Package Manager**: Vanilla implementation without npm or yarn dependencies
- **No CSS Framework**: Custom CSS with modern features and mobile optimizations

### Future Integrations
- **Restaurant Data Source**: Will require API integration for restaurant listings and reviews
- **Payment Processing**: Subscription management system for premium features
- **User Authentication**: Account system for reputation tracking and personalized features
- **Geolocation Services**: For location-based restaurant recommendations