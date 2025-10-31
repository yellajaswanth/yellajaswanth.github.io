#!/bin/bash

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

# Function to check if command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to check if Homebrew is installed
check_homebrew() {
    if ! command_exists brew; then
        print_status "Homebrew not found. Installing Homebrew..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        
        # Add Homebrew to PATH for current session
        if [[ -f "/opt/homebrew/bin/brew" ]]; then
            export PATH="/opt/homebrew/bin:$PATH"
        elif [[ -f "/usr/local/bin/brew" ]]; then
            export PATH="/usr/local/bin:$PATH"
        fi
        
        print_success "Homebrew installed successfully"
    else
        print_success "Homebrew already installed"
    fi
}

# Function to check and install Ruby
check_ruby() {
    local ruby_path=""
    local ruby_version=""
    
    # Check if we have a good Ruby version
    if command_exists ruby; then
        ruby_version=$(ruby --version | grep -o 'ruby [0-9]\+\.[0-9]\+' | cut -d' ' -f2)
        if [[ "$ruby_version" > "3.0" ]]; then
            print_success "Ruby $ruby_version already installed and up to date"
            return 0
        else
            print_warning "Ruby $ruby_version is outdated (need 3.0+)"
        fi
    fi
    
    print_status "Installing Ruby via Homebrew..."
    brew install ruby
    
    # Find the installed Ruby path
    if [[ -f "/opt/homebrew/opt/ruby/bin/ruby" ]]; then
        ruby_path="/opt/homebrew/opt/ruby"
    elif [[ -f "/usr/local/opt/ruby/bin/ruby" ]]; then
        ruby_path="/usr/local/opt/ruby"
    else
        print_error "Could not find Ruby installation path"
        exit 1
    fi
    
    # Add Ruby to PATH
    export PATH="$ruby_path/bin:$PATH"
    export PATH="$ruby_path/lib/ruby/gems/$(ruby --version | grep -o 'ruby [0-9]\+\.[0-9]\+' | cut -d' ' -f2 | sed 's/\./\.0/')/bin:$PATH"
    
    print_success "Ruby installed at $ruby_path"
}

# Function to check and install Jekyll
check_jekyll() {
    if command_exists jekyll; then
        print_success "Jekyll already installed"
    else
        print_status "Installing Jekyll..."
        gem install jekyll bundler
        print_success "Jekyll installed successfully"
    fi
}

# Function to check and install dependencies
check_dependencies() {
    if [[ -f "Gemfile" ]]; then
        print_status "Installing Ruby dependencies from Gemfile..."
        bundle install
        if [[ $? -eq 0 ]]; then
            print_success "Dependencies installed successfully"
        else
            print_warning "Some dependencies may have warnings, but continuing..."
        fi
    else
        print_warning "No Gemfile found, skipping dependency installation"
    fi
}

# Function to set up environment variables
setup_environment() {
    # Get the Ruby path
    local ruby_path=""
    if [[ -f "/opt/homebrew/opt/ruby/bin/ruby" ]]; then
        ruby_path="/opt/homebrew/opt/ruby"
    elif [[ -f "/usr/local/opt/ruby/bin/ruby" ]]; then
        ruby_path="/usr/local/opt/ruby"
    fi
    
    if [[ -n "$ruby_path" ]]; then
        # Add to current session
        export PATH="$ruby_path/bin:$PATH"
        export PATH="$ruby_path/lib/ruby/gems/$(ruby --version | grep -o 'ruby [0-9]\+\.[0-9]\+' | cut -d' ' -f2 | sed 's/\./\.0/')/bin:$PATH"
        
        # Check if already in shell config
        local shell_config=""
        if [[ "$SHELL" == *"zsh"* ]]; then
            shell_config="$HOME/.zshrc"
        elif [[ "$SHELL" == *"bash"* ]]; then
            shell_config="$HOME/.bashrc"
        fi
        
        if [[ -n "$shell_config" ]]; then
            local path_line="export PATH=\"$ruby_path/bin:\$PATH\""
            local gem_path_line="export PATH=\"$ruby_path/lib/ruby/gems/$(ruby --version | grep -o 'ruby [0-9]\+\.[0-9]\+' | cut -d' ' -f2 | sed 's/\./\.0/')/bin:\$PATH\""
            
            if ! grep -q "$path_line" "$shell_config"; then
                print_status "Adding Ruby to $shell_config for future sessions..."
                echo "" >> "$shell_config"
                echo "# Ruby and Jekyll paths" >> "$shell_config"
                echo "$path_line" >> "$shell_config"
                echo "$gem_path_line" >> "$shell_config"
                print_success "Environment variables added to $shell_config"
            fi
        fi
    fi
}

# Function to check if Jekyll server is already running
check_server_running() {
    if lsof -i :4000 >/dev/null 2>&1; then
        print_warning "Jekyll server already running on port 4000"
        echo "Server address: http://localhost:4000"
        echo "Press Ctrl+C to stop the server"
        return 0
    fi
    return 1
}

# Function to start Jekyll server
start_server() {
    print_status "Starting Jekyll server..."
    
    # Check if we're in the right directory
    if [[ ! -f "_config.yml" ]]; then
        print_error "Not in a Jekyll project directory. Please run this script from your Jekyll project root."
        exit 1
    fi
    
    # Start the server
    print_success "Jekyll server starting..."
    echo "Server will be available at: http://localhost:4000"
    echo "Press Ctrl+C to stop the server"
    echo ""
    
    bundle exec jekyll serve --host 0.0.0.0
}

# Function to build Jekyll site and copy CSS files
build_site() {
    print_status "Building Jekyll site..."
    
    if bundle exec jekyll build; then
        print_success "Site built successfully"
        
        # Copy CSS files to root directory for live server
        if [[ -f "_site/style.css" ]]; then
            cp _site/style.css . 2>/dev/null
            cp _site/style.css.map . 2>/dev/null
            print_success "CSS files copied to root directory"
        fi
    else
        print_error "Failed to build site"
        exit 1
    fi
}

# Main execution
main() {
    echo "🚀 Jekyll Server Setup and Start Script"
    echo "========================================"
    echo ""
    
    # Check if we're in a Jekyll project
    if [[ ! -f "_config.yml" ]]; then
        print_error "This doesn't appear to be a Jekyll project directory."
        print_error "Please run this script from your Jekyll project root (where _config.yml is located)."
        exit 1
    fi
    
    # Check if server is already running
    if check_server_running; then
        exit 0
    fi
    
    # Install and setup everything
    check_homebrew
    check_ruby
    check_jekyll
    check_dependencies
    setup_environment
    
    # Build the site and copy CSS files
    build_site
    
    # Start the server
    start_server
}

# Run main function
main "$@" 