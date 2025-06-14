#!/usr/bin/env bash
# Check which files would be lost on reboot with impermanence

echo "Checking for files that would be lost on reboot..."
echo "================================================"

# Dynamically get persisted directories from current bind mounts
echo "Reading persistence configuration from active mounts..."

# Get all bind mounts from /persist
persist_dirs=()
while IFS= read -r line; do
  # Extract the mount point (second field)
  mount_point=$(echo "$line" | awk '{print $3}')
  persist_dirs+=("$mount_point")
done < <(mount | grep "^/persist" | grep -E "(type fuse|bind)")

# Start building exclude pattern
excludes="{tmp,sys,proc,dev,run,etc/passwd,etc/shadow,nix,persist,boot,efi"

# Add dynamically detected persistence directories
for dir in "${persist_dirs[@]}"; do
  # Remove leading / for fd exclude pattern
  excludes="$excludes,${dir#/}"
done

# Also exclude common system directories that are always persisted
excludes="$excludes,var/lib/nixos,var/lib/systemd"

excludes="$excludes}"

echo "Found ${#persist_dirs[@]} persisted directories"
echo "Excluding: $excludes"
echo ""

# Function to group files by directory
group_files() {
  local threshold=5  # Minimum files to group
  declare -A dir_counts
  local files=()
  
  # Read all files into array
  while IFS= read -r file; do
    files+=("$file")
  done
  
  # Count files per directory
  for file in "${files[@]}"; do
    dir=$(dirname "$file")
    # Only group if directory has at least 2 levels (to avoid grouping everything under root/)
    if [[ "$dir" =~ ^[^/]+/[^/]+ ]]; then
      ((dir_counts["$dir"]++))
    fi
  done
  
  # Find directories with many files
  declare -A grouped_dirs
  for dir in "${!dir_counts[@]}"; do
    if [ "${dir_counts[$dir]}" -ge "$threshold" ]; then
      grouped_dirs["$dir"]=1
    fi
  done
  
  # Output files, grouping when appropriate
  declare -A shown_dirs
  for file in "${files[@]}"; do
    local show=1
    # Check if this file is in a grouped directory
    for grouped_dir in "${!grouped_dirs[@]}"; do
      if [[ "$file" == "$grouped_dir"/* ]]; then
        if [ -z "${shown_dirs[$grouped_dir]}" ]; then
          # First time showing this grouped dir
          echo "$grouped_dir/ [${dir_counts[$grouped_dir]} files]"
          shown_dirs["$grouped_dir"]=1
        fi
        show=0
        break
      fi
    done
    
    if [ "$show" -eq 1 ]; then
      echo "$file"
    fi
  done
}

# Run fd and process output
if [ "$1" = "--show-persisted" ]; then
  echo "Currently persisted directories:"
  printf '%s\n' "${persist_dirs[@]}" | sort
elif [[ "$1" == "-n" && "$2" =~ ^[0-9]+$ ]]; then
  # Limited output with -n flag
  limit=$2
  output=$(sudo fd --one-file-system --base-directory / --type f --hidden --exclude "$excludes" | group_files)
  line_count=$(echo "$output" | wc -l)
  
  if [ "$line_count" -gt "$limit" ]; then
    echo "$output" | head -"$limit"
    echo ""
    echo "Note: Showing first $limit entries (was $line_count total)."
  else
    echo "$output"
  fi
else
  # Default: show all files
  sudo fd --one-file-system --base-directory / --type f --hidden --exclude "$excludes" | group_files
fi