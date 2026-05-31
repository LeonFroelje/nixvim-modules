{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.codecompanionConfig;
in
{
  options.codecompanionConfig = with lib; {
    enable = mkEnableOption "CodeCompanion AI config";

    endpoint = mkOption {
      type = types.str;
      default = "http://127.0.0.1:8081"; # Base URL for your llama-swap
      description = "The local OpenAI-compatible endpoint";
    };

    model = mkOption {
      type = types.str;
      default = "qwen3:8b"; # Your default local model
      description = "The model name currently loaded in llama-swap";
    };
  };

  config = lib.mkIf cfg.enable {
    plugins.codecompanion = {
      enable = true;

      settings = {
        strategies = {
          # Route all chat and inline requests to our custom llama_swap adapter
          chat = {
            adapter = "llama_swap";
          };
          inline = {
            adapter = "llama_swap";
          };
        };

        adapters = {
          # Use Nixvim's __raw to inject the Lua function required by CodeCompanion
          llama_swap = {
            __raw = ''
              function()
                return require("codecompanion.adapters").extend("openai_compatible", {
                  env = {
                    url = "${cfg.endpoint}",
                    chat_url = "/v1/chat/completions",
                    api_key = "LOCAL_DUMMY_KEY",
                  },
                  schema = {
                    model = {
                      default = "${cfg.model}",
                    },
                  },
                })
              end
            '';
          };
        };
      };
    };

    # Keymaps to make it actually feel like a sidebar experience
    keymaps = [
      {
        mode = [
          "n"
          "v"
        ];
        key = "<leader>ai";
        action = "<cmd>CodeCompanionChat Toggle<CR>";
        options = {
          desc = "Toggle CodeCompanion Chat";
          silent = true;
        };
      }
      {
        mode = [ "v" ];
        key = "<leader>ac";
        action = "<cmd>CodeCompanionChat Add<CR>";
        options = {
          desc = "Add selection to CodeCompanion";
          silent = true;
        };
      }
    ];
  };
}
