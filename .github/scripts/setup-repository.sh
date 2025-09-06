#!/bin/bash

# GitHub Repository Setup Script for REChain®️ VC Lab
# This script helps set up the repository with all necessary configurations

set -e

echo "🚀 Setting up REChain®️ VC Lab repository..."

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
    print_warning "GitHub CLI (gh) is not installed. Some features may not work."
    print_status "Install it from: https://cli.github.com/"
fi

# Function to setup GitHub repository settings
setup_repository() {
    print_status "Setting up repository settings..."
    
    # Enable issues and discussions
    if command -v gh &> /dev/null; then
        gh repo edit --enable-issues --enable-discussions --enable-wiki
        print_success "Repository features enabled"
    else
        print_warning "Please manually enable issues, discussions, and wiki in GitHub settings"
    fi
}

# Function to setup branch protection
setup_branch_protection() {
    print_status "Setting up branch protection rules..."
    
    if command -v gh &> /dev/null; then
        # Create branch protection rule for main branch
        gh api repos/:owner/:repo/branches/main/protection \
            --method PUT \
            --field required_status_checks='{"strict":true,"contexts":["ci","test","security-scan"]}' \
            --field enforce_admins=true \
            --field required_pull_request_reviews='{"required_approving_review_count":1,"dismiss_stale_reviews":true}' \
            --field restrictions=null
        
        print_success "Branch protection rules set up"
    else
        print_warning "Please manually set up branch protection rules in GitHub settings"
    fi
}

# Function to setup labels
setup_labels() {
    print_status "Setting up repository labels..."
    
    if command -v gh &> /dev/null; then
        # Create labels from labels.yml
        if [ -f ".github/labels.yml" ]; then
            gh label create --file .github/labels.yml
            print_success "Labels created"
        else
            print_warning "labels.yml not found"
        fi
    else
        print_warning "Please manually create labels from .github/labels.yml"
    fi
}

# Function to setup projects
setup_projects() {
    print_status "Setting up project boards..."
    
    if command -v gh &> /dev/null; then
        # Create project from project.yml
        if [ -f ".github/project.yml" ]; then
            gh project create --title "REChain VC Lab Development" --body "Main development project board"
            print_success "Project board created"
        else
            print_warning "project.yml not found"
        fi
    else
        print_warning "Please manually create project boards"
    fi
}

# Function to setup milestones
setup_milestones() {
    print_status "Setting up milestones..."
    
    if command -v gh &> /dev/null; then
        # Create milestones
        gh api repos/:owner/:repo/milestones \
            --method POST \
            --field title="v1.0.0" \
            --field description="Initial release" \
            --field due_on="2024-12-31T23:59:59Z"
        
        print_success "Milestones created"
    else
        print_warning "Please manually create milestones"
    fi
}

# Function to setup webhooks
setup_webhooks() {
    print_status "Setting up webhooks..."
    
    if command -v gh &> /dev/null; then
        # Create webhook for CI/CD
        gh api repos/:owner/:repo/hooks \
            --method POST \
            --field name="web" \
            --field config='{"url":"https://your-ci-server.com/webhook","content_type":"json"}' \
            --field events='["push","pull_request"]'
        
        print_success "Webhooks created"
    else
        print_warning "Please manually set up webhooks in GitHub settings"
    fi
}

# Function to setup team access
setup_team_access() {
    print_status "Setting up team access..."
    
    if command -v gh &> /dev/null; then
        # Add team with write access
        gh api repos/:owner/:repo/collaborators/your-team \
            --method PUT \
            --field permission="push"
        
        print_success "Team access configured"
    else
        print_warning "Please manually configure team access in GitHub settings"
    fi
}

# Function to verify setup
verify_setup() {
    print_status "Verifying setup..."
    
    # Check if all required files exist
    required_files=(
        ".github/workflows/ci.yml"
        ".github/workflows/test.yml"
        ".github/workflows/deploy.yml"
        ".github/workflows/security.yml"
        ".github/ISSUE_TEMPLATE/bug_report.md"
        ".github/ISSUE_TEMPLATE/feature_request.md"
        ".github/pull_request_template.md"
        "README.md"
        "LICENSE"
        "CONTRIBUTING.md"
        "CODE_OF_CONDUCT.md"
        "SECURITY.md"
    )
    
    for file in "${required_files[@]}"; do
        if [ -f "$file" ]; then
            print_success "✓ $file exists"
        else
            print_error "✗ $file missing"
        fi
    done
}

# Main execution
main() {
    print_status "Starting repository setup..."
    
    setup_repository
    setup_branch_protection
    setup_labels
    setup_projects
    setup_milestones
    setup_webhooks
    setup_team_access
    verify_setup
    
    print_success "Repository setup completed!"
    print_status "Next steps:"
    echo "  1. Review and customize the generated configurations"
    echo "  2. Set up your CI/CD pipeline"
    echo "  3. Configure your team access"
    echo "  4. Start developing!"
}

# Run main function
main "$@"
