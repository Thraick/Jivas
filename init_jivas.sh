#!/bin/bash
# Script to create jivas user, login, and initialize jivas graph

function initialize() {
    if lsof -i :8000 >/dev/null; then
        # Load environment variables
        source .env

        # Try to login first
        JIVAS_TOKEN=$(wget --no-check-certificate --quiet \
        --method POST \
        --timeout=0 \
        --header 'Content-Type: application/json' \
        --header 'Accept: application/json' \
        --body-data '{
        "password": "'"$JIVAS_PASSWORD"'",
        "email": "'"$JIVAS_USER"'"
        }' \
        'http://localhost:8000/user/login' -O - | jq -r '.token')

        # Check if login was successful
        if [ -z "$JIVAS_TOKEN" ]; then
            echo "Login failed. Registering user..."

            # Register user if login failed
            wget --no-check-certificate --quiet \
            --method POST \
            --timeout=0 \
            --header 'Content-Type: application/json' \
            --header 'Accept: application/json' \
            --body-data '{
            "password": "'"$JIVAS_PASSWORD"'",
            "email": "'"$JIVAS_USER"'"
            }' \
            'http://localhost:8000/user/register'

            # Attempt to login again after registration
            JIVAS_TOKEN=$(wget --no-check-certificate --quiet \
            --method POST \
            --timeout=0 \
            --header 'Content-Type: application/json' \
            --header 'Accept: application/json' \
            --body-data '{
            "password": "'"$JIVAS_PASSWORD"'",
            "email": "'"$JIVAS_USER"'"
            }' \
            'http://localhost:8000/user/login' -O - | jq -r '.token')
        fi

        # Check if we successfully obtained a token
        if [ -n "$JIVAS_TOKEN" ]; then
            # Print token
            echo "Jivas token: $JIVAS_TOKEN"

            echo "Initializing jivas graph..."

            # Initialize jivas graph
            wget --no-check-certificate --quiet \
            --method POST \
            --timeout=0 \
            --header 'Accept: application/json' \
            --header 'Authorization: Bearer '"$JIVAS_TOKEN"'' \
            'http://localhost:8000/walker/init_app'

            # Exit the script
            exit
        else
            echo "Failed to obtain a token after registration. Exiting."
            exit 1
        fi
    else
        echo "Server is not running on port 8000. Waiting..."
    fi
}

# Main loop to check if a process is running on port 8000
while true; do
    initialize
    sleep 2  # Wait for 2 seconds before checking again
done