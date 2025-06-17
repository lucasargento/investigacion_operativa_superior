#!/bin/bash

# Initialize PIDs
BACKEND_PID=0
FRONTEND_PID=0

# Function to handle script termination
cleanup() {
    echo "Shutting down servers..."
    # Kill backend process (FastAPI/Uvicorn) if it's running
    if [ "$BACKEND_PID" -ne 0 ]; then
        echo "Killing backend (PID: $BACKEND_PID)"
        kill $BACKEND_PID 2>/dev/null
    fi
    # Kill frontend process (React Dev Server) if it's running
    if [ "$FRONTEND_PID" -ne 0 ]; then
        echo "Killing frontend (PID: $FRONTEND_PID)"
        kill $FRONTEND_PID 2>/dev/null
    fi

    # Fallback: Kill any remaining processes on ports 8000 (backend) and 3000 (frontend)
    echo "Performing fallback port cleanup..."
    lsof -ti:8000 | xargs kill -9 2>/dev/null
    lsof -ti:3000 | xargs kill -9 2>/dev/null
    
    echo "Servers shut down."
    exit
}

# Set up trap to catch termination signal
trap cleanup SIGINT SIGTERM EXIT

# Start backend server (FastAPI with Uvicorn)
echo "Starting FastAPI backend server on http://0.0.0.0:8000..."
uvicorn app:app --host 0.0.0.0 --port 8000 &
BACKEND_PID=$!

# Wait a moment for backend to initialize
sleep 2

# Start frontend server (React Development Server)
echo "Starting React frontend server on http://localhost:3000..."
cd frontend && npm start &
FRONTEND_PID=$!

# Wait for both processes
wait $BACKEND_PID $FRONTEND_PID
