#!/bin/bash

# Clone the repo if it doesn't exist
if [ ! -d "my-java-project" ]; then
  git clone https://github.com/silversixpence-crypto/my-java-project.git
fi

# Change to the repo directory
cd my-java-project

# Build the project
./gradlew build

# Start the app inside a screen session
screen -dmS my-java-app java -jar build/libs/my-java-project.jar

# Check for updates every 10 minutes
while true; do
  git fetch origin main
  
  LOCAL=$(git rev-parse @)
  REMOTE=$(git rev-parse @{u})
  BASE=$(git merge-base @ @{u})

  if [ $LOCAL = $REMOTE ]; then
    echo "Local branch is up to date with remote."
  else
    echo "Local branch is behind remote, updating..."
    
    # Issue command to watchdog to terminate application
    curl -X POST http://localhost:8081/control/stop
    
    # Wait for app to terminate
    while screen -list | grep -q "my-java-app"; do
      sleep 1
    done
    
    git pull
    ./gradlew build
    
    # Start app
    screen -dmS my-java-app java -jar build/libs/my-java-project.jar
  fi
  sleep 10m
done
