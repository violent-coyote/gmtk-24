#!/bin/bash

# Path to your Godot executable inside the .app bundle
GODOT_PATH="/Users/carlosmichael/Library/Application Support/Godot/app_userdata/Godot Version Manager/versions/godot-4.3-stable-spine.app/Contents/MacOS/Godot"

# Path to your project directory (current directory)
PROJECT_PATH="$(pwd)"

# Name of your export preset
EXPORT_PRESET="Web"

# Output path for your exported project
OUTPUT_PATH="$PROJECT_PATH/../dist"

# itch.io details
ITCH_USER="crabonfireco"
ITCH_GAME="trait-tycoon"
ITCH_CHANNEL="web" 

# Function to increment the version number
increment_version() {
    local version=$(grep 'config/version=' "$PROJECT_PATH/project.godot" | sed 's/config\/version="\(.*\)"/\1/')
    local major=$(echo $version | cut -d. -f1)
    local minor=$(echo $version | cut -d. -f2)
    local patch=$(echo $version | cut -d. -f3)
    
    patch=$((patch + 1))
    
    new_version="$major.$minor.$patch"
    sed -i '' "s/config\/version=\".*\"/config\/version=\"$new_version\"/" "$PROJECT_PATH/project.godot"
    
    echo "Version updated to $new_version" >&2
    echo $new_version
}

# Check if project.godot exists
if [ ! -f "$PROJECT_PATH/project.godot" ]; then
    echo "Error: project.godot not found in the current directory"
    exit 1
fi

# Call the function to increment the version and store the result
NEW_VERSION=$(increment_version)

# Check if Godot executable exists
if [ ! -f "$GODOT_PATH" ]; then
    echo "Error: Godot executable not found at $GODOT_PATH"
    exit 1
fi

# Clear the dist folder
rm -rf "$OUTPUT_PATH"

# Create the export directory
mkdir -p "$OUTPUT_PATH"

# Export the project using Godot's command line interface
"$GODOT_PATH" --path "$PROJECT_PATH" --export-release "$EXPORT_PRESET" "$OUTPUT_PATH/index.html"

echo "Export completed. Output saved to $OUTPUT_PATH/index.html"

# Package the contents of the dist folder
PACKAGE_NAME="TraitTycoon_v${NEW_VERSION}"
PACKAGE_PATH="$PROJECT_PATH/../${PACKAGE_NAME}.zip"
(cd "$OUTPUT_PATH" && zip -r "$PACKAGE_PATH" .)

echo "Package created: $PACKAGE_PATH"

# Upload to itch.io using Butler
butler push "$PACKAGE_PATH" "$ITCH_USER/$ITCH_GAME:$ITCH_CHANNEL" --userversion "$NEW_VERSION"
