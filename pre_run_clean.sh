#!/bin/bash

# Default options
VERBOSE=false
CLEAN_PUB_CACHE=false

# Parse command line arguments
while [[ "$#" -gt 0 ]]; do
  case $1 in
    -v|--verbose) VERBOSE=true ;;
    -c|--clean-pub-cache) CLEAN_PUB_CACHE=true ;;
    -h|--help) 
      echo "Usage: ./pre_run_clean.sh [options]"
      echo "Options:"
      echo "  -v, --verbose     Enable verbose mode"
      echo "  -c, --clean-pub-cache  Clean Flutter pub cache"
      echo "  -h, --help        Show this help message"
      exit 0
      ;;
    *) echo "Unknown parameter: $1"; exit 1 ;;
  esac
  shift
done

# Print function for verbose mode
function print_verbose() {
  if [ "$VERBOSE" = true ]; then
    echo -e "[$(date '+%Y-%m-%d %H:%M:%S')] $1"
  fi
}

# Error handling function
function handle_error() {
  echo "Error: $1"
  exit 1
}

# Check if command exists
function check_command() {
  if ! command -v $1 &> /dev/null; then
    handle_error "$1 command not found. Please install it first."
  fi
}

# Remove .lock files
function remove_lock_files() {
  print_verbose "Removing .lock files..."
  find . -type f -name "*.lock" -delete || handle_error "Failed to remove lock files"
  print_verbose "✓ Lock files removed"
}

# Run Flutter clean
function flutter_clean() {
  check_command flutter
  
    print_verbose "Running 'flutter clean' in project root..."
    (flutter clean) || handle_error "Flutter clean failed in project root"
    print_verbose "✓ Flutter clean completed in project root"
}

# Clean Flutter pub cache
function clean_pub_cache() {
  if [ "$CLEAN_PUB_CACHE" = true ]; then
    check_command flutter
    print_verbose "Cleaning Flutter pub cache..."
    (flutter pub cache clean) || handle_error "Flutter pub cache clean failed"
    print_verbose "✓ Flutter pub cache cleaned"
  fi
}

# Remove build directories
function remove_build_dirs() {
  print_verbose "Removing build directories..."
  
  # Remove cxx and CMake related files
  rm -rf android/build/ android/.cxx android/CMakeFiles android/CMakeCache.txt android/cmake_install.cmake android/Makefile
  print_verbose "✓ Removed cxx and CMake related files"
  
  # Remove jniLibs content
     rm -rf android/src/main/jniLibs/*
     print_verbose "✓ Removed jniLibs content"
  
  # Remove Frameworks content
     rm -rf ios/Frameworks/libproxy_core.xcframework macos/Frameworks/libproxy_core.xcframework
     print_verbose "✓ Removed Frameworks content"
}

# Run all tasks
function run_all_tasks() {
  print_verbose "Starting pre setup tasks..."
    
  remove_lock_files
  flutter_clean
  clean_pub_cache
  remove_build_dirs
  
  print_verbose "✓ All pre setup tasks completed successfully"
  
  if [ "$VERBOSE" = false ]; then
    echo "Clean completed successfully"
  fi
}

# Execute main function
run_all_tasks