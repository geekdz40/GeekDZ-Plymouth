# GeekDZ Plymouth Theme

A sophisticated Plymouth boot theme for Arch Linux featuring smooth logo morphing and neon effects.

## Features

- **Smooth Logo Morphing**: Transitions from official Arch Linux logo to GeekDZ logo with crossfade effects
- **Neon Glow Effects**: Pulsing cyan glow around the GeekDZ logo (#00ccff)
- **Dynamic Text**: "GeekDZ — Building the Future" appears with fade in/out animation
- **Pure Black Theme**: Completely black background matching GeekDZ logo aesthetic
- **Lightweight**: Uses 2D sprites and optimized PNG images, compatible with Plymouth limitations
- **Total Animation Duration**: ~4.5 seconds for optimal boot experience

## Animation Timeline

1. **0.0s - 0.4s**: Arch Linux logo fade-in (400ms)
2. **0.4s - 1.1s**: Arch logo remains visible (700ms)  
3. **1.1s - 2.0s**: Smooth morph to GeekDZ logo with crossfade, scale (1.0 → 1.08 → 1.0), and rotation (±6°) (900ms)
4. **2.0s - 3.2s**: GeekDZ logo with neon blue glow pulsing twice (600ms per pulse)
5. **2.0s - 3.5s**: Text label fade in/out simultaneously with glow effects
6. **3.5s+**: Final state with GeekDZ logo only

## Installation

### Prerequisites

- Arch Linux system
- Plymouth installed (`sudo pacman -S plymouth`)
- Root privileges for file placement
- ImageMagick for logo generation

### Step 1: Copy Theme Files

```bash
# Create theme directory
sudo mkdir -p /usr/share/plymouth/themes/geekdz

# Copy theme files
sudo cp geekdz.plymouth /usr/share/plymouth/themes/geekdz/
sudo cp geekdz.script /usr/share/plymouth/themes/geekdz/
sudo cp assets/arch-logo.png /usr/share/plymouth/themes/geekdz/
sudo cp assets/geekdz-logo.png /usr/share/plymouth/themes/geekdz/
sudo cp assets/background.png /usr/share/plymouth/themes/geekdz/

# Set proper permissions
sudo chmod 644 /usr/share/plymouth/themes/geekdz/*
```

### Step 2: Enable the Theme

```bash
# Set as default Plymouth theme and rebuild initramfs
sudo plymouth-set-default-theme -R geekdz

# Alternative: Manual initramfs rebuild
# sudo plymouth-set-default-theme geekdz
# sudo mkinitcpio -P
```

### Step 3: Configure GRUB (if using GRUB)

Ensure your GRUB configuration includes `splash quiet` parameters:

```bash
# Edit GRUB configuration
sudo nano /etc/default/grub

# Ensure this line contains 'splash quiet':
GRUB_CMDLINE_LINUX_DEFAULT="splash quiet"

# Regenerate GRUB configuration
sudo grub-mkconfig -o /boot/grub/grub.cfg
```

### Step 4: Reboot

```bash
sudo reboot
```

## Testing & Preview

### Safe Preview (Use with Caution)

```bash
# Preview without rebooting (may interfere with current session)
sudo plymouthd --debug --debug-file=/tmp/plymouth-debug.log
sudo plymouth --show-splash

# Stop preview
sudo plymouth --quit
sudo killall plymouthd
```

### Testing in Virtual Machine

The safest way to test is in a VM:

```bash
# Install in VM and reboot to see full effect
# Monitor VM console during boot process
```

## Troubleshooting

### Theme Not Appearing

1. **Check theme installation**:
   ```bash
   sudo plymouth-set-default-theme --list
   ls -la /usr/share/plymouth/themes/geekdz/
   ```

2. **Verify initramfs contains theme**:
   ```bash
   sudo mkinitcpio -P
   lsinitcpio /boot/initramfs-linux.img | grep plymouth
   ```

3. **Check GRUB configuration**:
   ```bash
   grep "splash quiet" /boot/grub/grub.cfg
   ```

### Boot Freezing

If system freezes during boot:

1. **Boot from Live USB**
2. **Mount root partition** and remove splash parameters:
   ```bash
   sudo mount /dev/sdXY /mnt
   sudo chroot /mnt
   nano /etc/default/grub
   # Remove 'splash quiet' from GRUB_CMDLINE_LINUX_DEFAULT
   grub-mkconfig -o /boot/grub/grub.cfg
   exit
   sudo umount /mnt
   ```

### Debug Information

```bash
# Check Plymouth logs
journalctl -b | grep plymouth

# Check system logs during boot
journalctl -b | grep -E "plymouth|splash"

# Verify theme syntax
sudo plymouth-set-default-theme geekdz --rebuild-initrd

# Test with debug output
sudo plymouthd --debug --debug-file=/tmp/plymouth-debug.log &
sudo plymouth --show-splash
# Check /tmp/plymouth-debug.log for errors
```

### Performance Issues

If animations are choppy:

1. **Reduce image sizes** (currently optimized for 512×512)
2. **Simplify animations** by modifying timing constants in `geekdz.script`
3. **Disable on slower hardware** by falling back to text mode

## File Structure

```
/usr/share/plymouth/themes/geekdz/
├── geekdz.plymouth          # Theme metadata and configuration
├── geekdz.script           # Main animation script (Plymouth Script Language)
├── arch-logo.png           # Official Arch Linux logo (512×512, transparent, 19KB)
├── geekdz-logo.png         # GeekDZ logo (512×512, black background, 85KB)
└── background.png          # Pure black background (1920×1080, 559B)
```

## Customization

### Modify Animation Timing

Edit timing constants in `geekdz.script`:

```javascript
FADE_IN_DURATION = 0.4;     // Logo fade-in time
ARCH_VISIBLE_DURATION = 0.7; // How long Arch logo stays visible
MORPH_DURATION = 0.9;        // Morph animation duration
PULSE_DURATION = 0.6;        // Each neon pulse duration
```

### Change Colors

Modify background colors:

```javascript
Window.SetBackgroundTopColor(0.039, 0.039, 0.039);    // RGB values 0-1
Window.SetBackgroundBottomColor(0.039, 0.039, 0.039);
```

### Replace Logos

- Replace `arch-logo.png` and `geekdz-logo.png` with your own 512×512 transparent PNGs
- Keep file names the same, or update references in `geekdz.script`

## Technical Notes

- **Plymouth Script Language**: Uses Plymouth's custom scripting language (not standard JavaScript)
- **Sprite Layers**: Uses Z-ordering (96-102) for proper layering
- **Performance**: Optimized for 2D operations, no 3D/OpenGL effects
- **Fallback**: Displays "Booting..." text if images fail to load
- **Memory Usage**: ~500KB for theme files (suitable for initramfs)

## Compatibility

- **Arch Linux**: Primary target
- **Other Distributions**: Should work with modifications to paths
- **Hardware**: Requires basic 2D graphics support
- **Resolution**: Adaptive to screen size, optimized for 1920×1080

## License

MIT License - Feel free to modify and distribute.

## Credits

- Theme concept and implementation: GeekDZ
- Base Plymouth script structure inspired by open-source Plymouth themes
- Arch Linux logo: Official Arch Linux branding