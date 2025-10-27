# ContentFlow - Social Media Management Platform

Welcome to ContentFlow! 🎉

ContentFlow is a powerful social media management platform that helps you manage your content across multiple platforms including Facebook, Instagram, Twitter, LinkedIn, YouTube, and TikTok.

## 🌟 Features

- **📨 Messages Inbox**: View and manage messages from all your social media platforms in one place
- **📅 Content Calendar**: Schedule and manage your posts across different platforms
- **📊 Analytics Dashboard**: Track your performance with detailed analytics and insights
- **✍️ Post Composer**: Create and publish content with AI assistance
- **🔄 Cross-Platform**: Manage multiple social media accounts from a single interface

## 🚀 Getting Started

### 1. View the App

Your ContentFlow app is now running! You can access it through the web preview in Replit.

### 2. Configure Your Social Media APIs

To see **real data** from your social media accounts instead of sample data:

1. Read the **[API_SETUP.md](./API_SETUP.md)** file for detailed instructions
2. Click on **"Tools"** → **"Secrets"** in Replit
3. Add your API keys for the platforms you want to integrate

**Supported Platforms:**
- ✅ Facebook (Fully integrated)
- ✅ Instagram (Fully integrated)  
- ⏳ Twitter/X (Coming soon)
- ⏳ LinkedIn (Coming soon)
- ⏳ YouTube (Coming soon)
- ⏳ TikTok (Coming soon)

### 3. App Behavior

**Without API Keys:**
- The app will show sample/demo data
- All features are functional but use mock data
- Perfect for testing the interface

**With API Keys:**
- Real messages from your social media accounts
- Actual posts from your connected platforms
- Live analytics and performance data
- Ability to create, edit, and delete posts

## 📱 Main Screens

### Messages Inbox
- View messages from all platforms
- Filter by platform
- Search messages
- Bulk actions (mark as read, archive, delete)

### Content Calendar
- Visual calendar of your scheduled posts
- Week and month views
- Drag-and-drop scheduling
- Platform-specific post management

### Analytics Dashboard
- Performance metrics overview
- Engagement charts
- Audience demographics
- Top performing content
- AI-powered insights

### Account Settings
- Manage connected accounts
- Configure notification preferences
- Privacy settings
- App preferences

## 🔒 Security

- All API keys are stored securely as environment variables
- Never commit API keys to your codebase
- Each platform requires specific permissions
- OAuth tokens are handled securely

## 🛠️ Technical Details

**Built with:**
- Flutter (Web & Mobile)
- Dio for HTTP requests
- Material Design 3
- Responsive design with Sizer

**Architecture:**
- Clean separation of data and presentation layers
- Service-based API integration
- Factory pattern for platform services
- Type-safe data models

## 📚 Documentation

- **[API_SETUP.md](./API_SETUP.md)** - Detailed guide for setting up social media APIs
- **[README.md](./README.md)** - Technical development documentation

## 🆘 Need Help?

If you encounter issues:

1. **Check the logs**: Look at the console output for error messages
2. **Verify API keys**: Make sure they're correctly added to Replit Secrets
3. **Check API permissions**: Ensure your apps have the required permissions
4. **Restart the app**: Sometimes a restart is needed after adding secrets

## 🎯 What's Next?

1. **Set up your first platform** (Facebook or Instagram recommended)
2. **Explore the features** with sample data
3. **Connect more platforms** as you need them
4. **Customize the app** to fit your workflow

---

Enjoy managing your social media content with ContentFlow! 🚀
