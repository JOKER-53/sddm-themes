#!/bin/bash

echo "========================================"
echo "    SDDM Theme Test Runner"
echo "========================================"
echo "This will load each theme one by one."
echo "To move to the next theme, just press [Enter] in this terminal window."
echo ""

# Find all directories in the current folder
for dir in */ ; do
    theme=$(basename "$dir")
    
    # Check if it's an actual SDDM theme by looking for metadata.desktop
    if [ -f "$PWD/$theme/metadata.desktop" ]; then
        echo "--------------------------------------------------"
        echo "▶ Now testing: $theme"
        
        # Launch the greeter in the background, suppress the messy QML logs
        sddm-greeter-qt6 --test-mode --theme "$PWD/$theme" > /dev/null 2>&1 &
        GREETER_PID=$!
        
        # Wait for the user to press Enter
        read -p "Press [Enter] for the next theme (or Ctrl+C to quit)..."
        
        # Kill the greeter so the next one can open
        kill $GREETER_PID 2>/dev/null
        wait $GREETER_PID 2>/dev/null
    fi
done

echo "--------------------------------------------------"
echo "✅ All themes have been tested!"
