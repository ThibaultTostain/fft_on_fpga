#!/bin/bash

# Virtual environment name
VENV_NAME=".venv"

# Function to ask for confirmation
confirm() {
    read -p "$1 [y/n] " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        return 0
    else
        return 1
    fi
}

# Introduction message
echo "This program will:"
echo "1. Update apt and install python3-full via apt (requires sudo)"
echo "2. Create a Python virtual environment ($VENV_NAME)"
echo "3. Activate the virtual environment ($VENV_NAME)"
echo "4. Install depencies in the virtual environment"
echo ""

if ! confirm "Do you want to continue?"; then
    echo "Installation cancelled."
    exit 0
fi

# Step 1: Install python3-full
echo "Installing python3-full..."
if sudo apt update && sudo apt install -y python3-full; then
    echo "python3-full installed successfully."
else
    echo "Error: Failed to install python3-full."
    exit 1
fi

# Step 2: Create the virtual environment
echo "Creating virtual environment '$VENV_NAME'..."
if [ ! -d "$VENV_NAME" ]; then
    python3 -m venv "$VENV_NAME"
    if [ $? -ne 0 ]; then
        echo "Error: Failed to create virtual environment."
        exit 1
    fi
    echo "Virtual environment created."
else
    echo "The virtual environment '$VENV_NAME' already exists."
fi


# Step 3: Activate the virtual environnement
echo "Activate the virtual environnement..."
if source $VENV_NAME/bin/activate; then
    echo "Virtual environnement activate correctly."
else
    echo "Error: Failed to activate the virtual environnement."
    exit 1
fi

# Step 4: Activate the environment and install pandas
echo "Installing dependencies in the virtual environment..."
source "$VENV_NAME/bin/activate"
if pip install notebook numpy matplotlib; then
    echo "Dependencies installed successfully."
    echo "You can activate the environment with: source $VENV_NAME/bin/activate"
else
    echo "Error: Failed to install dependencies."
    exit 1
fi
