# Samwise Backend Deployment Guide

## Quick Deploy to Railway (Recommended)

### 1. Create Railway Account
1. Go to [railway.app](https://railway.app)
2. Sign up with GitHub account
3. Connect your GitHub repository

### 2. Deploy Backend
1. Click "New Project" → "Deploy from GitHub repo"
2. Select this repository 
3. Railway will automatically detect Node.js and deploy
4. Set environment variables in Railway dashboard:
   ```
   NODE_ENV=production
   JWT_SECRET=your-super-strong-secret-key-here
   BCRYPT_ROUNDS=12
   MAX_FILE_SIZE=10485760
   ```

### 3. Add MongoDB Database
1. In Railway dashboard, click "Add Service" → "Database" → "MongoDB"
2. Railway will provide `MONGODB_URI` automatically
3. No additional configuration needed

### 4. Custom Domain (Optional)
1. In Railway dashboard, go to Settings → Domains
2. Add your custom domain or use Railway's subdomain
3. Example: `samwise-backend-production.up.railway.app`

### 5. Test Deployment
1. Visit `https://your-railway-domain.railway.app/health`
2. Should return: `{"status":"OK","timestamp":"...","uptime":123}`
3. Test voice message interface: `https://your-railway-domain.railway.app/share/test-id`

## Alternative: Deploy to Vercel

1. Install Vercel CLI: `npm i -g vercel`
2. Run: `vercel --prod`
3. Follow prompts to deploy

## After Deployment

1. Update iOS app's `APIService.swift`:
   ```swift
   private let baseURL = "https://your-domain.railway.app/api"
   ```

2. Test end-to-end:
   - Create run on iPhone
   - Share link with friends
   - Friends record voice messages via web
   - Start run and verify messages play

## Environment Variables for Production

- `NODE_ENV=production`
- `MONGODB_URI=<railway-provides-this>`
- `JWT_SECRET=<strong-secret-key>`
- `BCRYPT_ROUNDS=12`
- `MAX_FILE_SIZE=10485760`

Railway handles CORS automatically based on the domain.