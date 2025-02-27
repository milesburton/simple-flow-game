#!/bin/bash

# Set project name
PROJECT_NAME="youtube-ai-avatar"

echo "🚀 Setting up project: $PROJECT_NAME"

# Create the project directory
mkdir $PROJECT_NAME && cd $PROJECT_NAME

# Initialize Vite with React and TypeScript
echo "🔧 Initializing Vite..."
npm create vite@latest $PROJECT_NAME --template react-ts
cd $PROJECT_NAME

# Install dependencies
echo "📦 Installing dependencies..."
npm install \
  @tensorflow/tfjs @tensorflow-models/facemesh three \
  styled-components react-player ytdl-core fluent-ffmpeg ws express \
  @types/styled-components @types/ws

# Create required directories
echo "📁 Creating project structure..."
mkdir -p \
  src/components \
  src/styles \
  src/utils \
  backend \
  public

# Create empty core files
touch \
  src/components/avatar.tsx \
  src/components/video-player.tsx \
  src/components/layout.tsx \
  src/styles/avatar.module.css \
  src/styles/global.css \
  src/utils/extract-frames.ts \
  src/utils/face-tracking.ts \
  src/app.tsx \
  src/main.tsx \
  vite.config.ts \
  backend/server.ts \
  backend/extract-audio.ts \
  backend/lipsync.ts \
  backend/generate-speech.ts \
  Dockerfile \
  docker-compose.yml \
  .gitignore \
  README.md

# Initialize git repository
echo "🔄 Initializing Git repository..."
git init
echo "node_modules/" > .gitignore

# Display success message
echo "✅ Setup complete! Run the following to start your project:"
echo "cd $PROJECT_NAME && npm run dev"

