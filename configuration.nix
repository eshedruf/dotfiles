# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
    imports =
        [ # Include the results of the hardware scan.
            ./hardware-configuration.nix
        ];

    nix.settings = {
        experimental-features = [ "nix-command" "flakes" ];
    };

    # Bootloader.
    boot.loader = {
        timeout = 30;

        efi = {
            efiSysMountPoint = "/boot";  # Make sure this is the ESP
            canTouchEfiVariables = true;
        };

        systemd-boot.enable = false;    # Disable systemd-boot entirely

        grub = {
            enable = true;
            efiSupport = true;
            efiInstallAsRemovable = false; # No fallback
            devices = ["nodev"];           # UEFI-only install, GRUB installs to ESP
            useOSProber = true;            # Detect Windows and other OSes
            extraEntriesBeforeNixOS = false;
            configurationName = "generation";
        };
    };


    # Use latest kernel.
    boot.kernelPackages = pkgs.linuxPackages_latest;

    boot.kernelModules = [ "bluetooth" "btusb" ];

    networking.hostName = "nixos"; # Define your hostname.
    # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

    # Configure network proxy if necessary
    # networking.proxy.default = "http://user:password@proxy:port/";
    # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

    # Enable networking
    networking.networkmanager.enable = true;

    # Set your time zone.
    time.timeZone = "Asia/Jerusalem";

    # Select internationalisation properties.
    i18n.defaultLocale = "en_IL";

    i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_IL";
        LC_IDENTIFICATION = "en_IL";
        LC_MEASUREMENT = "en_IL";
        LC_MONETARY = "en_IL";
        LC_NAME = "en_IL";
        LC_NUMERIC = "en_IL";
        LC_PAPER = "en_IL";
        LC_TELEPHONE = "en_IL";
        LC_TIME = "en_IL";
    };

    # Enable the X11 windowing system.
    services.xserver.enable = false;

    # GNOME Desktop Environment.
    services.xserver.displayManager.gdm.enable = false;
    services.xserver.desktopManager.gnome.enable = false;

    # SDDM
    services.displayManager.sddm.enable = true;
    services.displayManager.sddm.wayland.enable = true;

    # Hyprland
    programs.hyprland = {
        enable = true;
    };

    environment.sessionVariables = {
        # if cursor becomes invisible
        WLR_NO_HARDWARE_CURSORS = "1";
    };

    hardware = {
        graphics.enable = true;
        nvidia.modesetting.enable = true;
    };

    # Configure keymap in X11
    services.xserver.xkb = {
        layout = "us";
        variant = "";
    };

    # Enable CUPS to print documents.
    services.printing.enable = true;

    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        #jack.enable = true;

        # use the example session manager (no others are packaged yet so this is enabled by default,
        # no need to redefine it in your config for now)
        #media-session.enable = true;
    };

    # Enable touchpad support (enabled default in most desktopManager).
    # services.xserver.libinput.enable = true;

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.users.eshed = {
        isNormalUser = true;
        description = "Eshed";
        extraGroups = [ "networkmanager" "wheel" ];
        packages = with pkgs; [
        #  thunderbird
        ];
    };

    # Install firefox.
    programs.firefox.enable = true;

    # Allow unfree packages
    nixpkgs.config.allowUnfree = true;

    # List packages installed in system profile. To search, run:
    # $ nix search wget
    environment.systemPackages = with pkgs; [
        vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        wget curl
        neovim
        librewolf
        git
        fastfetch
        man
        nmap
        gnupg
        zip unzip
        btop htop
        microsoft-edge
        file
        efibootmgr
        bat

        # GNOME packages
        gnome-tweaks
        dconf-editor

        # Hyprland related packages
        firefox                            # browser (works on Wayland; see note)
        kitty                              # terminal (wayland-friendly terminal)
        alacritty
        waybar                             # status bar
        rofi-wayland
        mako                               # notifications
        grim                               # screenshots
        slurp                              # area selection for screenshots
        wl-clipboard                       # clipboard tools (wl-copy, wl-paste)
        pavucontrol                        # sound control GUI (PulseAudio/pipewire)
        pamixer                            # cli audio control
        swaylock                           # lockscreen
        xdg-desktop-portal-hyprland        # portal for screen sharing, file picker (installed by module too)
    
        (waybar.overrideAttrs (oldAttrs: {
            mesonFlags = oldAttrs.mesonFlags ++ [ "-Dexperimental=true" ];
          })
        )
        
        dunst
        libnotify
        swww
    ];

    environment.gnome.excludePackages = with pkgs; [
        epiphany
    ];

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    # programs.gnupg.agent = {
    #   enable = true;
    #   enableSSHSupport = true;
    # };

    # List services that you want to enable:

    # Enable the OpenSSH daemon.
    services.openssh.enable = true;

    # Enable plocate
    services.locate.enable = true;
    # Open ports in the firewall.
    # networking.firewall.allowedTCPPorts = [ ... ];
    # networking.firewall.allowedUDPPorts = [ ... ];
    # Or disable the firewall altogether.
    # networking.firewall.enable = false;

    fonts.packages = with pkgs; [
        noto-fonts                # general coverage
        noto-fonts-emoji          # emojis everywhere
        noto-fonts-cjk-sans       # Asian fonts (fixes missing glyphs in terminals/waybar)
        liberation_ttf            # fallback for MS fonts
        fira-code                 # programming font
        fira-code-symbols         # ligature support
        (nerd-fonts.fira-code)    # nerd font patched for icons
        (nerd-fonts.jetbrains-mono) # another good coding font with icons
    ];

    # This value determines the NixOS release from which the default
    # settings for stateful data, like file locations and database versions
    # on your system were taken. It‘s perfectly fine and recommended to leave
    # this value at the release version of the first install of this system.
    # Before changing this value read the documentation for this option
    # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
    system.stateVersion = "25.05"; # Did you read the comment?

}
