# Social Media API Setup Guide

This guide will help you set up API credentials for integrating real data from various social media platforms.

## 🚀 Quick Start

To enable real data integration, you need to set up API keys as environment variables in Replit.

### Current Behavior (Important!)

**By default, the app uses sample/mock data** to demonstrate all features without requiring any API setup.

To use **real data from your social media accounts**:

1. You need to obtain API credentials from each platform (see platform setup sections below)
2. Build the app with `--dart-define` flags for each secret

**Example build command with real API keys:**
```bash
flutter run -d web-server --web-port=5000 --web-hostname=0.0.0.0 \
  --dart-define=FACEBOOK_ACCESS_TOKEN=your_token_here \
  --dart-define=INSTAGRAM_ACCESS_TOKEN=your_token_here
```

**Note**: The app gracefully falls back to mock data when API credentials aren't provided, so you can use it immediately without any setup!

---

## 📱 Platform Setup

### Facebook / Meta

#### Required Secrets:
```
FACEBOOK_APP_ID=your_app_id_here
FACEBOOK_APP_SECRET=your_app_secret_here
FACEBOOK_ACCESS_TOKEN=your_access_token_here
```

#### How to Get Facebook API Credentials:

1. Go to [Facebook Developers](https://developers.facebook.com/)
2. Create a new app or select an existing one
3. Go to **Settings > Basic** to find your App ID and App Secret
4. For Access Token:
   - Go to **Tools > Graph API Explorer**
   - Select your app
   - Request the following permissions:
     - `pages_show_list`
     - `pages_read_engagement`
     - `pages_manage_posts`
     - `pages_messaging`
   - Generate Access Token

**Note:** Facebook Access Tokens expire. For production, implement OAuth flow for long-lived tokens.

---

### Instagram

#### Required Secrets:
```
INSTAGRAM_CLIENT_ID=your_client_id_here
INSTAGRAM_CLIENT_SECRET=your_client_secret_here
INSTAGRAM_ACCESS_TOKEN=your_access_token_here
```

#### How to Get Instagram API Credentials:

1. Instagram uses Facebook's Graph API
2. Go to [Facebook Developers](https://developers.facebook.com/)
3. Create a Facebook app and enable Instagram Basic Display or Instagram Graph API
4. For **Instagram Basic Display**:
   - Add Instagram product to your app
   - Configure OAuth redirect URI
   - Get Client ID and Client Secret from Instagram Basic Display settings
5. For **Instagram Graph API** (Business accounts):
   - Connect your Instagram Business Account to a Facebook Page
   - Use the Facebook Page access token
   - Request permissions: `instagram_basic`, `instagram_content_publish`, `instagram_manage_messages`

---

### Twitter / X

#### Required Secrets:
```
TWITTER_API_KEY=your_api_key_here
TWITTER_API_SECRET=your_api_secret_here
TWITTER_ACCESS_TOKEN=your_access_token_here
TWITTER_ACCESS_TOKEN_SECRET=your_access_token_secret_here
```

#### How to Get Twitter API Credentials:

1. Go to [Twitter Developer Portal](https://developer.twitter.com/)
2. Apply for a developer account (if you don't have one)
3. Create a new project and app
4. Go to your app settings
5. Under **Keys and tokens**, you'll find:
   - API Key (Consumer Key)
   - API Secret Key (Consumer Secret)
   - Generate Access Token and Secret

**Note:** Twitter API has different access levels (Essential, Elevated, Premium). Make sure you have the appropriate access for your needs.

---

### LinkedIn

#### Required Secrets:
```
LINKEDIN_CLIENT_ID=your_client_id_here
LINKEDIN_CLIENT_SECRET=your_client_secret_here
LINKEDIN_ACCESS_TOKEN=your_access_token_here
```

#### How to Get LinkedIn API Credentials:

1. Go to [LinkedIn Developers](https://www.linkedin.com/developers/)
2. Create a new app
3. Under **Auth** tab, you'll find:
   - Client ID
   - Client Secret
4. Request the following API products:
   - Sign In with LinkedIn
   - Share on LinkedIn
   - Marketing Developer Platform (for analytics)
5. Set up OAuth 2.0:
   - Add redirect URLs
   - Request appropriate scopes: `r_liteprofile`, `r_emailaddress`, `w_member_social`, `r_organization_social`
6. Exchange authorization code for access token

---

### YouTube

#### Required Secrets:
```
YOUTUBE_API_KEY=your_api_key_here
YOUTUBE_CLIENT_ID=your_client_id_here
YOUTUBE_CLIENT_SECRET=your_client_secret_here
```

#### How to Get YouTube API Credentials:

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Create a new project or select existing one
3. Enable **YouTube Data API v3**
4. Go to **Credentials**
5. Create credentials:
   - **API Key** for public data access
   - **OAuth 2.0 Client ID** for user-specific operations
6. For OAuth:
   - Download the client configuration
   - Extract Client ID and Client Secret
   - Implement OAuth flow to get access token

---

### TikTok

#### Required Secrets:
```
TIKTOK_CLIENT_KEY=your_client_key_here
TIKTOK_CLIENT_SECRET=your_client_secret_here
TIKTOK_ACCESS_TOKEN=your_access_token_here
```

#### How to Get TikTok API Credentials:

1. Go to [TikTok for Developers](https://developers.tiktok.com/)
2. Apply for app approval
3. Create a new app
4. Under app details, you'll find:
   - Client Key
   - Client Secret
5. Configure OAuth settings
6. Request appropriate permissions for:
   - Video management
   - User info
   - Analytics

---

## ✅ Testing Your Setup

Once you've added the API keys to Replit Secrets, you can test the connection:

1. The app will automatically detect configured platforms
2. Check the app logs for connection status
3. Look for messages like:
   ```
   === API Configuration Status ===
   Facebook: ✓ Configured
   Instagram: ✓ Configured
   Twitter: ✗ Not configured
   LinkedIn: ✗ Not configured
   YouTube: ✗ Not configured
   TikTok: ✗ Not configured
   ==============================
   ```

---

## 🔒 Security Best Practices

1. **Never commit API keys to git** - Always use environment variables
2. **Use short-lived tokens** when possible
3. **Implement token refresh** for long-running applications
4. **Rotate keys regularly**
5. **Use minimum required permissions**
6. **Monitor API usage** to detect unauthorized access

---

## 📊 Current Integration Status

The ContentFlow app currently supports:
- ✅ **Facebook** - Messages, Posts, Analytics
- ✅ **Instagram** - Messages, Posts, Analytics
- ⏳ **Twitter/X** - Coming soon
- ⏳ **LinkedIn** - Coming soon
- ⏳ **YouTube** - Coming soon
- ⏳ **TikTok** - Coming soon

---

## 🆘 Troubleshooting

### "API not configured" errors
- Make sure you've added the required secrets in Replit
- Verify the secret names match exactly (case-sensitive)
- Restart the workflow after adding secrets

### "Invalid token" errors
- Your access token may have expired
- Generate a new token from the platform's developer portal
- For production, implement OAuth token refresh

### "Permission denied" errors
- Check that your app has requested the necessary permissions
- Some permissions require app review by the platform

### Rate limiting
- Most platforms have rate limits
- Implement caching to reduce API calls
- Consider upgrading to higher-tier API access if needed

---

## 📚 Additional Resources

- [Facebook Graph API Docs](https://developers.facebook.com/docs/graph-api/)
- [Instagram API Docs](https://developers.facebook.com/docs/instagram-api/)
- [Twitter API Docs](https://developer.twitter.com/en/docs)
- [LinkedIn API Docs](https://docs.microsoft.com/en-us/linkedin/)
- [YouTube API Docs](https://developers.google.com/youtube/v3)
- [TikTok API Docs](https://developers.tiktok.com/doc)

---

## 🎯 Next Steps

1. Set up at least one platform's API credentials
2. Add the secrets to Replit
3. Restart the app
4. The app will automatically use real data instead of mock data
5. Gradually add more platforms as needed

For help with OAuth flows or advanced integrations, consult the platform-specific documentation linked above.
