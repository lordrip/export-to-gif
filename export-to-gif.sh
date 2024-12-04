#!/bin/bash

# Convert a video file to a GIF using FFmpeg
# Usage: export-to-gif.sh -i input.mp4 -o output.gif [--fps N] [--verbose]
# Usage batch mode:
# for file in *.mp4; do ./export-to-gif.sh -i "$file" -o "${file%.mp4}.gif"; done

# Options:
#   -i input.mp4: Input video file
#   -o output.gif: Output GIF file
#   --fps N: Set the frame rate (default: 10)
#   --verbose: Print FFmpeg commands


# Initialize variables
verbose=0
fps=10 # Default FPS

# Parse arguments
while [[ $# -gt 0 ]]; do
  case $1 in
    -i)
      input_file="$2"
      shift 2
      ;;
    -o)
      output_file="$2"
      shift 2
      ;;
    --fps)
      fps="$2"
      shift 2
      ;;
    --verbose)
      verbose=1
      shift
      ;;
    *)
      echo "Usage: $0 -i input.mp4 -o output.gif [--fps N] [--verbose]"
      exit 1
      ;;
  esac
done

# Check if both input and output files are provided
if [ -z "$input_file" ] || [ -z "$output_file" ]; then
  echo "Error: Input and output file arguments are required."
  echo "Usage: $0 -i input.mp4 -o output.gif [--fps N] [--verbose]"
  exit 1
fi

# Create a unique temporary palette file
palette_file=$(mktemp --dry-run --suffix=.png)

# Function to run commands with optional verbosity
run_command() {
  if [ "$verbose" -eq 1 ]; then
    "$@"
  else
    "$@" >/dev/null 2>&1
  fi
}

# Generate the palette
run_command ffmpeg -i "$input_file" -vf "fps=$fps,scale=640:-1:flags=lanczos,palettegen" "$palette_file"

# Create the GIF using the palette
run_command ffmpeg -y -i "$input_file" -i "$palette_file" -lavfi "fps=$fps,scale=1024:-1:flags=lanczos [x]; [x][1:v] paletteuse=dither=floyd_steinberg" "$output_file"

# Clean up the palette file
rm -f "$palette_file"

echo "GIF successfully created: $output_file"
