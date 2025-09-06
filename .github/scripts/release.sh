#!/bin/bash

# Release Script for REChain®️ VC Lab
# This script helps create and manage releases

set -e

echo "🚀 Creating release for REChain®️ VC Lab..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

print_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Check if we're in a git repository
if [ ! -d ".git" ]; then
    print_error "Not in a git repository. Please run this script from the project root."
    exit 1
fi

# Check if GitHub CLI is installed
if ! command -v gh &> /dev/null; then
    print_error "GitHub CLI (gh) is not installed. Please install it first."
    exit 1
fi

# Function to get current version
get_current_version() {
    if [ -f "pubspec.yaml" ]; then
        grep "version:" pubspec.yaml | sed 's/version: //' | tr -d ' '
    else
        print_error "pubspec.yaml not found"
        exit 1
    fi
}

# Function to get next version
get_next_version() {
    local current_version=$1
    local version_type=$2
    
    case $version_type in
        major)
            echo $current_version | awk -F. '{print $1+1".0.0"}'
            ;;
        minor)
            echo $current_version | awk -F. '{print $1"."$2+1".0"}'
            ;;
        patch)
            echo $current_version | awk -F. '{print $1"."$2"."$3+1}'
            ;;
        *)
            print_error "Invalid version type. Use major, minor, or patch"
            exit 1
            ;;
    esac
}

# Function to update version in pubspec.yaml
update_version() {
    local new_version=$1
    
    print_status "Updating version to $new_version..."
    
    if [ -f "pubspec.yaml" ]; then
        sed -i "s/version: .*/version: $new_version/" pubspec.yaml
        print_success "Version updated in pubspec.yaml"
    else
        print_error "pubspec.yaml not found"
        exit 1
    fi
}

# Function to build all platforms
build_all_platforms() {
    print_status "Building for all platforms..."
    
    # Build Android
    print_status "Building Android APK..."
    flutter build apk --release
    
    # Build Android App Bundle
    print_status "Building Android App Bundle..."
    flutter build appbundle --release
    
    # Build Web
    print_status "Building Web..."
    flutter build web --release
    
    # Build Windows
    print_status "Building Windows..."
    flutter build windows --release
    
    # Build macOS
    print_status "Building macOS..."
    flutter build macos --release
    
    # Build Linux
    print_status "Building Linux..."
    flutter build linux --release
    
    print_success "All platforms built successfully"
}

# Function to create release notes
create_release_notes() {
    local version=$1
    local release_type=$2
    
    print_status "Creating release notes..."
    
    # Create release notes file
    cat > RELEASE_NOTES.md << EOF
# REChain®️ VC Lab v$version

## Release Type: $release_type

## What's New

### Features
- <!-- Add new features here -->

### Improvements
- <!-- Add improvements here -->

### Bug Fixes
- <!-- Add bug fixes here -->

### Security
- <!-- Add security updates here -->

## Installation

### Android
- Download APK from the release assets
- Install on your Android device

### Web
- Visit the web version at [your-web-url]

### Desktop
- Download the appropriate installer for your platform

## Breaking Changes
- <!-- List any breaking changes -->

## Migration Guide
- <!-- Add migration instructions if needed -->

## Full Changelog
- See [CHANGELOG.md](CHANGELOG.md) for the complete list of changes

## Support
- Report issues on [GitHub Issues](https://github.com/your-username/rechain-vc-lab/issues)
- Join our community discussions

---
*Generated on $(date)*
EOF
    
    print_success "Release notes created"
}

# Function to create git tag
create_tag() {
    local version=$1
    local message=$2
    
    print_status "Creating git tag v$version..."
    
    git tag -a "v$version" -m "$message"
    
    print_success "Git tag created"
}

# Function to push changes
push_changes() {
    local version=$1
    
    print_status "Pushing changes..."
    
    git add .
    git commit -m "Release v$version"
    git push origin main
    git push origin "v$version"
    
    print_success "Changes pushed"
}

# Function to create GitHub release
create_github_release() {
    local version=$1
    local release_type=$2
    
    print_status "Creating GitHub release..."
    
    # Create release with assets
    gh release create "v$version" \
        --title "REChain®️ VC Lab v$version" \
        --notes-file RELEASE_NOTES.md \
        --latest \
        build/app/outputs/flutter-apk/app-release.apk \
        build/app/outputs/bundle/release/app-release.aab \
        build/web/ \
        build/windows/x64/runner/Release/ \
        build/macos/Build/Products/Release/ \
        build/linux/x64/release/bundle/
    
    print_success "GitHub release created"
}

# Function to update changelog
update_changelog() {
    local version=$1
    local release_type=$2
    
    print_status "Updating changelog..."
    
    # Add new version to changelog
    if [ -f "CHANGELOG.md" ]; then
        # Create temporary file with new version
        cat > temp_changelog.md << EOF
# Changelog

## [v$version] - $(date +%Y-%m-%d)

### $release_type

- <!-- Add changes here -->

EOF
        
        # Append existing changelog
        tail -n +2 CHANGELOG.md >> temp_changelog.md
        
        # Replace original changelog
        mv temp_changelog.md CHANGELOG.md
        
        print_success "Changelog updated"
    else
        print_warning "CHANGELOG.md not found"
    fi
}

# Function to show help
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help              Show this help message"
    echo "  -t, --type TYPE         Release type (major, minor, patch)"
    echo "  -v, --version VERSION   Specific version to release"
    echo "  -m, --message MESSAGE   Release message"
    echo "  --dry-run               Show what would be done without executing"
    echo "  --skip-build            Skip building platforms"
    echo "  --skip-push             Skip pushing to git"
    echo ""
    echo "Examples:"
    echo "  $0 --type patch         Create a patch release"
    echo "  $0 --version 1.2.3      Create a specific version release"
    echo "  $0 --dry-run            Show what would be done"
}

# Function to dry run
dry_run() {
    local version_type=$1
    local current_version=$(get_current_version)
    local next_version=$(get_next_version $current_version $version_type)
    
    print_status "Dry run mode - showing what would be done:"
    echo "  Current version: $current_version"
    echo "  Next version: $next_version"
    echo "  Release type: $version_type"
    echo "  Would update pubspec.yaml"
    echo "  Would build all platforms"
    echo "  Would create git tag"
    echo "  Would push changes"
    echo "  Would create GitHub release"
    echo "  Would update changelog"
}

# Main execution
main() {
    local version_type="patch"
    local specific_version=""
    local release_message=""
    local dry_run_mode=false
    local skip_build=false
    local skip_push=false
    
    # Parse arguments
    while [[ $# -gt 0 ]]; do
        case $1 in
            -h|--help)
                show_help
                exit 0
                ;;
            -t|--type)
                version_type="$2"
                shift 2
                ;;
            -v|--version)
                specific_version="$2"
                shift 2
                ;;
            -m|--message)
                release_message="$2"
                shift 2
                ;;
            --dry-run)
                dry_run_mode=true
                shift
                ;;
            --skip-build)
                skip_build=true
                shift
                ;;
            --skip-push)
                skip_push=true
                shift
                ;;
            *)
                print_error "Unknown option: $1"
                show_help
                exit 1
                ;;
        esac
    done
    
    # Get version
    if [ -n "$specific_version" ]; then
        version=$specific_version
    else
        current_version=$(get_current_version)
        version=$(get_next_version $current_version $version_type)
    fi
    
    # Set default message if not provided
    if [ -z "$release_message" ]; then
        release_message="Release v$version"
    fi
    
    # Dry run mode
    if [ "$dry_run_mode" = true ]; then
        dry_run $version_type
        exit 0
    fi
    
    # Execute release process
    print_status "Starting release process for version $version..."
    
    update_version $version
    update_changelog $version $version_type
    create_release_notes $version $version_type
    
    if [ "$skip_build" = false ]; then
        build_all_platforms
    fi
    
    create_tag $version "$release_message"
    
    if [ "$skip_push" = false ]; then
        push_changes $version
    fi
    
    create_github_release $version $version_type
    
    print_success "Release v$version created successfully!"
    print_status "Release URL: https://github.com/$(gh repo view --json owner,name -q '.owner.login + "/" + .name")/releases/tag/v$version"
}

# Run main function
main "$@"
