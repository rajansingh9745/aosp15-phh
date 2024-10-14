#!/bin/bash

# Define the base directory for patches
PATCH_BASE_DIR="patches/TrebleDroid"

# Define the root of the Android source code as the current directory
ANDROID_ROOT_DIR="$(pwd)"

# Initialize counters
total_patches=0
successful_patches=0
failed_patches=0
already_applied_patches=0

# Function to check if a patch has already been applied
is_patch_applied() {
  local patch_file="$1"
  local target_dir="$2"

  # Navigate to the target directory
  cd "$ANDROID_ROOT_DIR/$target_dir" || { echo "Failed to navigate to $target_dir"; return 1; }

  # Perform a dry run of the patch application
  patch --dry-run -p1 < "$ANDROID_ROOT_DIR/$patch_file" 2>&1 | grep -q "Reversed (or previously applied) patch detected"

  # Return the exit status of the grep command
  local status=$?

  # Return to the Android root directory
  cd "$ANDROID_ROOT_DIR"

  return $status
}

# Function to apply a patch
apply_patch() {
  local patch_file="$1"
  local target_dir="$2"

  # Check if the patch has already been applied
  if is_patch_applied "$patch_file" "$target_dir"; then
    echo "Patch already applied: $patch_file (in $target_dir)"
    ((already_applied_patches++))
    return
  fi

  # Navigate to the target directory
  cd "$ANDROID_ROOT_DIR/$target_dir" || { echo "Failed to navigate to $target_dir"; return 1; }

  # Apply the patch
  patch -p1 < "$ANDROID_ROOT_DIR/$patch_file"

  # Check if the patch was applied successfully
  if [ $? -eq 0 ]; then
    echo "Patch applied successfully: $patch_file (in $target_dir)"
    ((successful_patches++))
  else
    echo "Failed to apply patch: $patch_file (in $target_dir)"
    ((failed_patches++))
  fi

  # Return to the Android root directory
  cd "$ANDROID_ROOT_DIR"
}

# Function to transform subfolder names
transform_subfolder_name() {
  local subfolder="$1"

  # Remove the "platform_" prefix and replace underscores with slashes
  transformed_subfolder=$(echo "$subfolder" | sed 's/^platform_//' | tr '_' '/')

  echo "$transformed_subfolder"
}

# Iterate through all patch files in the PATCH_BASE_DIR
while read -r patch_file; do
  # Determine the target directory based on the patch file path
  subfolder=$(dirname "$patch_file" | sed "s|^$PATCH_BASE_DIR/||")
  target_dir=$(transform_subfolder_name "$subfolder")

  echo "Processing patch file: $patch_file"
  echo "Target directory: $target_dir"

  # Apply the patch
  apply_patch "$patch_file" "$target_dir"

  # Increment the total patches counter
  ((total_patches++))
done < <(find "$PATCH_BASE_DIR" -type f -name "*.patch")

# Print the summary report
echo "----------------------------------------"
echo "Patch Application Summary Report"
echo "----------------------------------------"
echo "Total patches processed: $total_patches"
echo "Patches successfully applied: $successful_patches"
echo "Patches already applied: $already_applied_patches"
echo "Patches failed: $failed_patches"
echo "----------------------------------------"

echo "All patches processed!"
