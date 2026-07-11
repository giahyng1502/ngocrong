#!/bin/bash

# Configuration
PEM_KEY="/Users/giahyng/server/ninja.pem"
SERVER_USER="ubuntu"
SERVER_HOST="ec2-54-255-161-217.ap-southeast-1.compute.amazonaws.com"
REMOTE_DIR="~/nro-server"

# Ensure the key has the right permissions
chmod 400 "$PEM_KEY"

# Ensure remote directory exists
echo "Creating remote directory..."
ssh -o StrictHostKeyChecking=no -i "$PEM_KEY" $SERVER_USER@$SERVER_HOST "mkdir -p $REMOTE_DIR"

# Compile Java locally using Ant
echo "Compiling Java source code locally..."
ant clean jar

# Rsync files to the server
echo "Uploading files to server..."
rsync -avz -e "ssh -o StrictHostKeyChecking=no -i \"$PEM_KEY\"" \
  --exclude="LÂU CỒ MOD" \
  --exclude="PRJ_2Tab_550K" \
  --exclude="PRJ_2Tab_550K.rar" \
  --exclude="Teamobi2026.rar" \
  --exclude="src" \
  --exclude="build" \
  --exclude="nbproject" \
  --exclude=".git" \
  ./ $SERVER_USER@$SERVER_HOST:$REMOTE_DIR/

# SSH into the server to install docker (if not installed) and run docker-compose
echo "Setting up docker and starting services..."
ssh -o StrictHostKeyChecking=no -i "$PEM_KEY" $SERVER_USER@$SERVER_HOST << 'EOF'
  cd ~/nro-server

  # Install docker if not present
  if ! command -v docker &> /dev/null; then
      echo "Installing docker..."
      sudo apt-get update
      sudo apt-get install -y docker.io docker-compose
      sudo usermod -aG docker $USER
  fi

  # Stop any existing instances
  sudo docker compose down || true

  # Build and start services
  sudo docker compose up -d --build
EOF

echo "Deployment complete! Services are starting up."
