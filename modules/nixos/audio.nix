{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.modules.audio;
in {
  options.modules.audio = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Enable PipeWire audio system";
    };

    defaultSink = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Default audio sink name";
      example = "alsa_output.pci-0000_00_1f.3.analog-stereo";
    };

    defaultSource = lib.mkOption {
      type = lib.types.nullOr lib.types.str;
      default = null;
      description = "Default audio source name";
      example = "alsa_input.pci-0000_00_1f.3.analog-stereo";
    };

    sampleRate = lib.mkOption {
      type = lib.types.int;
      default = 48000;
      description = "Default sample rate";
    };

    quantumSize = lib.mkOption {
      type = lib.types.int;
      default = 1024;
      description = "Quantum size (buffer size)";
    };

    extraConfig = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "Extra PipeWire configuration";
    };
  };

  config = lib.mkIf cfg.enable {
    services.pipewire = {
      enable = true;
      socketActivation = false;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      jack.enable = true;
      pulse.enable = true;
      wireplumber.enable = true;

      extraConfig.pipewire = {
        "10-clock-rate" = {
          "context.properties" =
            {
              "default.clock.rate" = cfg.sampleRate;
              "default.clock.quantum" = cfg.quantumSize;
              "default.clock.min-quantum" = 32;
              "default.clock.max-quantum" = 8192;
            }
            // cfg.extraConfig;
        };
      };
    };

    security.rtkit.enable = true;

    systemd.services.rtkit-daemon.serviceConfig.ExecStart = [
      ""
      "${pkgs.rtkit}/libexec/rtkit-daemon --our-realtime-priority=95 --max-realtime-priority=90"
    ];

    systemd.user.services = {
      pipewire.wantedBy = ["default.target"];
      pipewire-pulse.wantedBy = ["default.target"];
    };

    # Set default devices using WirePlumber config
    services.pipewire.wireplumber.extraConfig = lib.mkMerge [
      (lib.mkIf (cfg.defaultSink != null) {
        "10-default-sink" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {
                  "node.name" = cfg.defaultSink;
                }
              ];
              actions = {
                update-props = {
                  "priority.session" = 1500;
                  "priority.driver" = 1500;
                };
              };
            }
          ];
        };
      })
      (lib.mkIf (cfg.defaultSource != null) {
        "10-default-source" = {
          "monitor.alsa.rules" = [
            {
              matches = [
                {
                  "node.name" = cfg.defaultSource;
                }
              ];
              actions = {
                update-props = {
                  "priority.session" = 1500;
                  "priority.driver" = 1500;
                };
              };
            }
          ];
        };
      })
    ];
  };
}
