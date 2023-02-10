#!/bin/bash

cd /home/node-source

npm ci
node index.js &> node.log &

while true
do
  # Fetch the latest changes from the remote repository
  git fetch origin

  # Check if the local branch is behind the remote branch
  LOCAL=$(git rev-parse @)
  REMOTE=$(git rev-parse @{u})
  BASE=$(git merge-base @ @{u})

  if [ $LOCAL = $REMOTE ]; then
    echo "Local branch is up to date with remote."
  else
    echo "Local branch is behind remote, updating..."
    
    # Stop the node.js server
    pkill node
    # Update the local branch with the remote branch, forcing the update
    
    git stash
    git stash drop
    git reset --hard origin/main
    
    # Start the node.js server again
    node index.js &> node.log &
  fi

  # Sleep for 5 minutes before checking for updates again
  sleep 300
done
