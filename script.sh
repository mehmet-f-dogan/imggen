#!/bin/bash

# Check if ImageMagick is installed
if ! command -v convert &> /dev/null; then
    echo "ImageMagick is not installed. Please install it first."
    exit 1
fi

# Check for correct number of arguments
if [ "$#" -lt 1 ]; then
    echo "Usage: $0 <text>"
    exit 1
fi

# Assign arguments to variables
imagepath="brody.jpeg"
text="$1"
font="DejaVu-Sans-Mono"      # Default font is Arial if not provided
pointsize=50      # Set the desired font size here

# Get image dimensions
width=$(identify -format "%w" "$imagepath")
height=$(identify -format "%h" "$imagepath")

# Calculate line position and size
line_y=$((height / 2 - 50))
line_height=100
line_width="$width"

# Create the overlay with the transparent line and text //-font "$font"
convert "$imagepath" -fill "rgba(0,0,0,0.7)" \
    -draw "rectangle 0,$line_y $line_width,$((line_y + line_height))" \
    -gravity center -font "$font" -pointsize "$pointsize" -fill white \
    -annotate +0+0 "$text" "./output.jpeg"

echo "Output saved to output.jpeg"
