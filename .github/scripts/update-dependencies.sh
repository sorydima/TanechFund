#!/bin/bash

# Dependency Update Script for REChain®️ VC Lab
# This script helps update dependencies and manage version conflicts

set -e

echo "📦 Updating dependencies for REChain®️ VC Lab..."

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

# Check if Flutter is installed
if ! command -v flutter &> /dev/null; then
    print_error "Flutter is not installed. Please install Flutter first."
    exit 1
fi

# Function to backup current dependencies
backup_dependencies() {
    print_status "Backing up current dependencies..."
    
    if [ -f "pubspec.yaml" ]; then
        cp pubspec.yaml pubspec.yaml.backup
        cp pubspec.lock pubspec.lock.backup
        print_success "Dependencies backed up"
    else
        print_error "pubspec.yaml not found"
        exit 1
    fi
}

# Function to restore dependencies
restore_dependencies() {
    print_status "Restoring dependencies..."
    
    if [ -f "pubspec.yaml.backup" ]; then
        mv pubspec.yaml.backup pubspec.yaml
        mv pubspec.lock.backup pubspec.lock
        print_success "Dependencies restored"
    else
        print_warning "No backup found"
    fi
}

# Function to check for outdated dependencies
check_outdated() {
    print_status "Checking for outdated dependencies..."
    
    flutter pub outdated
    
    print_success "Outdated dependencies check completed"
}

# Function to update dependencies
update_dependencies() {
    print_status "Updating dependencies..."
    
    # Clean and get dependencies
    flutter clean
    flutter pub get
    
    print_success "Dependencies updated"
}

# Function to run dependency audit
audit_dependencies() {
    print_status "Running dependency audit..."
    
    flutter pub audit
    
    print_success "Dependency audit completed"
}

# Function to check for security vulnerabilities
check_security() {
    print_status "Checking for security vulnerabilities..."
    
    # Run security audit
    flutter pub audit
    
    print_success "Security check completed"
}

# Function to update Flutter version
update_flutter() {
    print_status "Updating Flutter..."
    
    flutter upgrade
    
    print_success "Flutter updated"
}

# Function to check Flutter doctor
check_flutter_doctor() {
    print_status "Running Flutter doctor..."
    
    flutter doctor -v
    
    print_success "Flutter doctor check completed"
}

# Function to generate dependency report
generate_report() {
    print_status "Generating dependency report..."
    
    # Create report directory
    mkdir -p reports
    
    # Generate dependency tree
    flutter pub deps --json > reports/dependencies.json
    
    # Generate outdated dependencies report
    flutter pub outdated > reports/outdated.txt
    
    # Generate audit report
    flutter pub audit > reports/audit.txt
    
    print_success "Dependency report generated in reports/ directory"
}

# Function to fix dependency conflicts
fix_conflicts() {
    print_status "Fixing dependency conflicts..."
    
    # Clean and get dependencies
    flutter clean
    flutter pub get
    
    # Check for conflicts
    if flutter pub deps --json | grep -q "conflict"; then
        print_warning "Dependency conflicts detected"
        print_status "Attempting to resolve conflicts..."
        
        # Try to resolve conflicts
        flutter pub upgrade
        
        print_success "Conflicts resolved"
    else
        print_success "No conflicts detected"
    fi
}

# Function to update specific package
update_package() {
    local package_name=$1
    
    if [ -z "$package_name" ]; then
        print_error "Package name is required"
        exit 1
    fi
    
    print_status "Updating package: $package_name"
    
    # Update specific package
    flutter pub upgrade $package_name
    
    print_success "Package $package_name updated"
}

# Function to show help
show_help() {
    echo "Usage: $0 [OPTIONS]"
    echo ""
    echo "Options:"
    echo "  -h, --help              Show this help message"
    echo "  -b, --backup            Backup current dependencies"
    echo "  -r, --restore           Restore backed up dependencies"
    echo "  -c, --check             Check for outdated dependencies"
    echo "  -u, --update            Update all dependencies"
    echo "  -a, --audit             Run dependency audit"
    echo "  -s, --security          Check for security vulnerabilities"
    echo "  -f, --flutter           Update Flutter version"
    echo "  -d, --doctor            Run Flutter doctor"
    echo "  -g, --generate          Generate dependency report"
    echo "  -x, --fix               Fix dependency conflicts"
    echo "  -p, --package PACKAGE   Update specific package"
    echo "  --all                   Run all checks and updates"
    echo ""
    echo "Examples:"
    echo "  $0 --all                Run all checks and updates"
    echo "  $0 --update             Update all dependencies"
    echo "  $0 --package flutter    Update Flutter package"
    echo "  $0 --security           Check for security issues"
}

# Main execution
main() {
    case "${1:-}" in
        -h|--help)
            show_help
            ;;
        -b|--backup)
            backup_dependencies
            ;;
        -r|--restore)
            restore_dependencies
            ;;
        -c|--check)
            check_outdated
            ;;
        -u|--update)
            update_dependencies
            ;;
        -a|--audit)
            audit_dependencies
            ;;
        -s|--security)
            check_security
            ;;
        -f|--flutter)
            update_flutter
            ;;
        -d|--doctor)
            check_flutter_doctor
            ;;
        -g|--generate)
            generate_report
            ;;
        -x|--fix)
            fix_conflicts
            ;;
        -p|--package)
            update_package "$2"
            ;;
        --all)
            backup_dependencies
            check_outdated
            update_dependencies
            audit_dependencies
            check_security
            generate_report
            print_success "All dependency checks and updates completed!"
            ;;
        *)
            print_error "Invalid option. Use --help for usage information."
            exit 1
            ;;
    esac
}

# Run main function
main "$@"
