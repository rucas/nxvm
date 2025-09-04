{
  plugins.codecompanion = {
    enable = true;
    settings = {
      adapters.http = {
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
      strategies = {
        agent = {
          adapter = "anthropic";
        };
        chat = {
          adapter = "anthropic";
        };
        inline = {
          adapter = "anthropic";
        };
      };
    };
  };
}
