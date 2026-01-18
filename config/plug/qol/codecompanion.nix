{ self', pkgs, ... }:
{
  extraPackages = [
    self'.packages.claude-code-acp
    pkgs.nodejs
  ];
  plugins.codecompanion = {
    enable = true;
    settings = {
      adapters = {
        acp = {
          claude_code = {
            __raw = ''
              function()
                return require('codecompanion.adapters').extend('claude_code', {
                  env = {
                    CLAUDE_CODE_OAUTH_TOKEN = "cmd:op read 'op://private/Claude/OAuth Token' --no-newline"
                  },
                  -- schema = {
                  --   model = {
                  --     default = "claude-3-5-sonnet-20241022",
                  --   },
                  -- },
                  --handlers = {
                  --  setup = function()
                  --    return {
                  --      name = "claude_code",
                  --      cmd = "${self'.packages.claude-code-acp}/bin/claude-code-acp",
                  --    }
                  --  end,
                  --},
                })
              end
            '';
          };
        };
        http = {
          anthropic = {
            __raw = ''
              function()
                return require('codecompanion.adapters').extend('anthropic', {
                  env = {
                    api_key = "cmd:op read 'op://private/Claude/API Key' --no-newline"
                  },
                })
              end
            '';
          };
        };
      };
      strategies = {
        agent = {
          adapter = "claude_code";
        };
        chat = {
          adapter = "claude_code";
        };
        inline = {
          adapter = "claude_code";
        };
      };
    };
  };
}
