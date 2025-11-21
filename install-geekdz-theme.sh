#!/bin/bash

# GeekDZ Plymouth Theme Installer
# Run with: sudo ./install-geekdz-theme.sh

set -e

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

# Check if running as root
if [[ $EUID -ne 0 ]]; then
   print_error "This script must be run as root (use sudo)"
   exit 1
fi

# Check if Plymouth is installed
if ! command -v plymouth &> /dev/null; then
    print_error "Plymouth is not installed. Install with: pacman -S plymouth"
    exit 1
fi

print_status "Installing GeekDZ Plymouth theme..."

# Create theme directory
THEME_DIR="/usr/share/plymouth/themes/geekdz"
print_status "Creating theme directory: $THEME_DIR"
mkdir -p "$THEME_DIR"

# Copy theme files
print_status "Copying theme files..."
cp geekdz.plymouth "$THEME_DIR/"
cp geekdz.script "$THEME_DIR/"

# Copy assets
if [ -d "assets" ]; then
    cp assets/arch-logo.png "$THEME_DIR/"
    cp assets/geekdz-logo.png "$THEME_DIR/"
    cp assets/background.png "$THEME_DIR/"
    print_success "Assets copied successfully"
else
    print_error "Assets directory not found. Make sure you're running this from the GeekDZ-Plymouth directory"
    exit 1
fi

# Set proper permissions
print_status "Setting file permissions..."
chmod 644 "$THEME_DIR"/*

# List available themes for verification
print_status "Available Plymouth themes:"
plymouth-set-default-theme --list

# Ask user if they want to set as default
echo
read -p "Do you want to set GeekDZ as the default Plymouth theme? (y/N): " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_status "Setting GeekDZ as default theme and rebuilding initramfs..."
    plymouth-set-default-theme -R geekdz
    print_success "Theme set as default and initramfs rebuilt"
    
    # Check GRUB configuration
    print_status "Checking GRUB configuration..."
    if [ -f "/etc/default/grub" ]; then
        if grep -q "splash quiet" /etc/default/grub; then
            print_success "GRUB already configured with 'splash quiet'"
        else
            print_warning "GRUB configuration may need 'splash quiet' parameters"
            print_warning "Edit /etc/default/grub and add 'splash quiet' to GRUB_CMDLINE_LINUX_DEFAULT"
            print_warning "Then run: grub-mkconfig -o /boot/grub/grub.cfg"
        fi
    else
        print_warning "GRUB configuration file not found"
    fi
    
    echo
    print_success "GeekDZ Plymouth theme installed successfully!"
    print_status "Reboot your system to see the new boot animation."
else
    print_success "GeekDZ Plymouth theme installed but not set as default"
    print_status "To activate later, run: sudo plymouth-set-default-theme -R geekdz"
fi

echo
print_status "Installation complete!"
print_status "Theme files located at: $THEME_DIR"
print_status "See README.md for troubleshooting and customization options"