# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  # boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    # efiInstallAsRemovable = true;
    enable = true;
    device = "nodev"; # <- 安装 GRUB 到当前的 ESP 挂载点
    efiSupport = true; # <- EFI 支持
    useOSProber = true; # <- 检测其它系统
    # gfxmodeEfi = "1440x900"; # <- 引导界面分辨率
  };
  networking.hostName = "nixos"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

# Enable OpenGL
  hardware.graphics = {
    enable = true;
  };

  # Load nvidia driver for Xorg and Wayland
  services.xserver.videoDrivers = ["nvidia"];

  hardware.nvidia = {

    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead 
    # of just the bare essentials.
    powerManagement.enable = false;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of 
    # supported GPUs is at: 
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus 
    # Only available from driver 515.43.04+
    open = false;

    # Enable the Nvidia settings menu,
	# accessible via `nvidia-settings`.
    nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };
  hardware.nvidia.prime = {
    reverseSync.enable = true;
    # Enable if using an external GPU
    allowExternalGpu = false;
		# Make sure to use the correct Bus ID values for your system!
		intelBusId = "PCI:0:2:0";
		nvidiaBusId = "PCI:1:0:0";
		# amdgpuBusId = "PCI:54:0:0"; For AMD GPU
	};

  # Set your time zone.
  time.timeZone = "Asia/Shanghai";

  # Select internationalisation properties.
  i18n.defaultLocale = "zh_CN.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "zh_CN.UTF-8";
    LC_IDENTIFICATION = "zh_CN.UTF-8";
    LC_MEASUREMENT = "zh_CN.UTF-8";
    LC_MONETARY = "zh_CN.UTF-8";
    LC_NAME = "zh_CN.UTF-8";
    LC_NUMERIC = "zh_CN.UTF-8";
    LC_PAPER = "zh_CN.UTF-8";
    LC_TELEPHONE = "zh_CN.UTF-8";
    LC_TIME = "zh_CN.UTF-8";
  };

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-chinese-addons
      fcitx5-catppuccin
      fcitx5-configtool
      fcitx5-mozc
      fcitx5-gtk
      rime-data
      fcitx5-rime
    ];

    # type = "ibus";
    # ibus.engines = with pkgs.ibus-engines; [
    #   libpinyin
    # ];
  };


  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };
  services.xserver.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.displayManager.lightdm = {
    enable = true;
    # background = "/home/dustwind/Pictures/background/1.png";
  };

  
  services.gvfs.enable = true;
  services.udisks2.enable = true;
  services.dbus.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dustwind = {
    isNormalUser = true;
    description = "dustwind";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [];
    shell = pkgs.fish;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAID19OobR/BfRaQJpKDnSM9fHJZMicZa155Cp0KC0ohFc 1692038362@qq.com"
    ];
  };

  systemd = {
    user.services.polkit-gnome-authentication-agent-1 = {
      description = "polkit-gnome-authentication-agent-1";
      wantedBy = [ "graphical-session.target" ];
      wants = [ "graphical-session.target" ];
      after = [ "graphical-session.target" ];
      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
        Restart = "on-failure";
        RestartSec = 1;
        TimeoutStopSec = 10;
      };
    };
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
	vim
	git
	firefox
	kitty
	polybarFull
	feh
	i3status
	wget
	curl
	rofi
	conky
	fastfetch
	picom
	nix-search
	neovim
	gcc
	clang
	cargo
	brightnessctl
	killall
  networkmanager
  networkmanagerapplet
  dunst
  conky
  mpd
  xfce.thunar
  xfce.thunar-dropbox-plugin
  xfce.thunar-archive-plugin
  xfce.thunar-volman
  vscode
  gvfs
  polkit
  polkit_gnome
  qq
  ffmpeg
  nodejs_latest
  home-manager
  jetbrains.pycharm-community-bin
  python313Packages.python
  python313Packages.pip
  python313Packages.pipx
  python313Packages.numpy
  nb-cli
  go-musicfox
  nvtopPackages.nvidia
  lshw
  uv

      # create a fhs environment by command `fhs`, so we can run non-nixos packages in nixos!
    (let base = pkgs.appimageTools.defaultFhsEnvArgs; in
      pkgs.buildFHSEnv (base // {
      name = "fhs";
      targetPkgs = pkgs:
        # pkgs.buildFHSEnv 只提供一个最小的 FHS 环境，缺少很多常用软件所必须的基础包
        # 所以直接使用它很可能会报错
        #
        # pkgs.appimageTools 提供了大多数程序常用的基础包，所以我们可以直接用它来补充
        (base.targetPkgs pkgs) ++ (with pkgs; [
          pkg-config
          ncurses
          python313Packages.python
          python313Packages.pyqt5
              # core
          glibc
          gcc
          binutils

          # GUI support
          xorg.libX11
          xorg.libXrender
          xorg.libXext
          xorg.libXrandr
          xorg.libXcursor
          xorg.libXi
          xorg.libXfixes

          # GTK/Qt optional
          gtk3
          qt5.full

          # fonts
          fontconfig
          freetype
                # 如果你的 FHS 程序还有其他依赖，把它们添加在这里
        ]
      );
      profile = "export FHS=1";
      runScript = "bash";
      extraOutputsToInstall = ["dev"];
    }))
  ];

  environment.variables = {
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # programs.zsh = {
  #   enable = true;
  #   enableCompletion = true;
  #   autosuggestions.enable = true;
  #   syntaxHighlighting.enable = true;

  #   ohMyZsh = {
  #     enable = true;
  #     theme = "robbyrussell"; # 可选：或 robbyrussell / bira / powerlevel10k
  #     plugins = [ "git" "z" ];
  #   };
  # };
  programs.fish = {
    enable = true;
    interactiveShellInit = "functions -e fish_greeting";
  };

  fonts.packages = with pkgs;[
	dejavu_fonts
	ubuntu_font_family
	noto-fonts-cjk-sans
	noto-fonts-cjk-serif
	fira-code
	noto-fonts-emoji
	nerd-fonts.droid-sans-mono
	font-awesome
	icomoon-feather
  adwaita-fonts
  noto-fonts-color-emoji
  source-code-pro
  hack-font
  jetbrains-mono
  maple-mono.variable
] ++ builtins.filter lib.attrsets.isDerivation (builtins.attrValues pkgs.nerd-fonts);
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

}
