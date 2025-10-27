# ContentFlow - Social Media Management Platform

## Overview

ContentFlow is a cross-platform social media management application built with Flutter. It enables users to manage multiple social media accounts (Facebook, Instagram, Twitter, LinkedIn, YouTube, TikTok) from a unified interface, featuring message management, content scheduling, analytics, and AI-assisted post creation.

**Data Sources**: The application is designed with dual-mode operation:
- **Mock Data Mode** (default): Uses sample data for immediate testing without API setup
- **Real Data Mode**: Connects to actual social media APIs when credentials are provided via `--dart-define` flags

The app gracefully falls back to mock data when API credentials aren't configured, ensuring it works out of the box while supporting real integrations when needed.

Supports web, mobile (iOS/Android), desktop (Windows, Linux, macOS) platforms.

## User Preferences

Preferred communication style: Simple, everyday language.

## System Architecture

### Frontend Architecture

**Framework**: Flutter (SDK ^3.29.2)
- **Cross-platform support**: Single codebase targeting web, iOS, Android, Windows, Linux, and macOS
- **UI Structure**: Feature-based organization with presentation layer separation
  - `lib/presentation/` - Screen implementations
  - `lib/widgets/` - Reusable UI components
  - `lib/theme/` - Application theming and styling
  - `lib/routes/` - Navigation and routing configuration

**State Management**: Not explicitly defined in the visible code, but follows standard Flutter patterns

**Key UI Features**:
- Messages inbox for cross-platform communication
- Content calendar for scheduling posts
- Analytics dashboard with performance metrics
- AI-assisted post composer
- Splash screen for app initialization

### Backend Architecture

**Authentication & Data Storage**: Supabase
- Used for backend services and data persistence
- Configuration via environment variables (`SUPABASE_URL`, `SUPABASE_ANON_KEY`)

**API Integration Pattern**:
- **Dual-mode operation**: Falls back to mock data when API credentials are unavailable
- **Build-time configuration**: API keys passed via `--dart-define` flags during build (cross-platform compatible)
- **Graceful degradation**: Application remains functional without real API access
- **Service layer architecture**: Base service interface with platform-specific implementations
- **Factory pattern**: Centralized service creation and management

**Social Media Integration Status**:
- ✅ **Facebook/Meta API**: Service layer implemented with real API calls for messages and posts
- ✅ **Instagram API**: Service layer implemented with real API calls for messages and posts
- ⏳ **Twitter/X, LinkedIn, YouTube, TikTok**: Service stubs created, awaiting API implementation

**Implemented Features with Real Data**:
- Messages Inbox: Loads real messages from Facebook and Instagram when configured
- Content Calendar: Displays real posts from Facebook and Instagram when configured
- Analytics Dashboard: Ready for real analytics data integration

**Recent Changes** (October 27, 2025):
- Fixed compilation error in advanced_options_widget.dart
- Created complete API service layer with data models (SocialMediaMessage, SocialMediaPost, AnalyticsData)
- Implemented Facebook and Instagram service integrations
- Updated Messages Inbox and Content Calendar to use real API calls
- Created cross-platform API configuration using `const String.fromEnvironment`
- Added API configuration status logging to main.dart
- Created comprehensive documentation (API_SETUP.md, README_USER.md)

### Data Management

**Image Caching**: Uses `cached_network_image` package for efficient image loading and caching across platforms

**Assets**:
- SVG support for vector graphics
- Image assets stored in `assets/images/`
- Asset manifest auto-generated during build

### External Dependencies

**AI Services** (Optional):
- OpenAI API - For AI-assisted content generation
- Google Gemini API - Alternative AI provider
- Anthropic API - Alternative AI provider
- Perplexity API - Alternative AI provider

**Backend Services**:
- Supabase - Authentication, database, and backend infrastructure
- Configuration stored in `env.json` for development

**Social Media APIs**:
- Facebook Graph API - Requires app credentials and access token
- Instagram Basic Display API - Requires access token
- Additional platforms pending implementation

**UI Components**:
- Fluttertoast - Toast notifications
- Flutter Material Icons - Icon set

**Platform-Specific Build Systems**:
- CMake for Linux, Windows, and macOS builds
- Gradle for Android (inferred from standard Flutter structure)
- Xcode for iOS (inferred from standard Flutter structure)

**Development Environment**:
- Replit-compatible with web server support
- Default web server runs on port 5000
- Environment variables managed through Replit Secrets

**Build Configuration**:
- Build-time secrets injection via `--dart-define` flags
- Separate configurations for debug, profile, and release builds
- Multi-platform build support through Flutter's build system