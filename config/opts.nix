{
  config = {
    opts = {
      # -- encoding --
      encoding = "utf-8";
      fileencoding = "utf-8";

      # more space no command line
      cmdheight = 0;

      # disable showing INSERT NORMAL, etc.
      showmode = false;

      # only one status line
      laststatus = 3;

      # Enable ruler
      number = true;

      # Enable relative line numbers
      relativenumber = true;

      # enable 24-bit colors
      termguicolors = true;

      # mouse mode for all
      mouse = "a";

      # auto-sync yanks to system clipboard (uses OSC 52 over SSH)
      clipboard = ["unnamedplus"];

      # -- Searching --

      # ignore case
      ignorecase = true;

      # ignore case unless one char is capitalized
      smartcase = true;

      # shows search highlights will Searching
      incsearch = true;

      # for regular expressions turn magic on
      magic = true;

      # show matching brackets when text indicator is over them
      showmatch = true;

      # how many tenths of a second to wait until highlighting matching bracket
      matchtime = 2;

      # use rg for default grep search
      grepprg = "rg --vimgrep";
      grepformat = "%f:%l:%c:%m";

      # ignore compiled files when completing filenames
      wildignore = "*.o,*~,*.pyc";

      # -- Files, backups, and undo --

      swapfile = false;
      backup = false;
      undofile = true;

      # -- Text, Tabs and indents --

      # use spaces instead of tabs
      expandtab = true;

      # 1 tab == 2 spaces
      tabstop = 2;
      softtabstop = 2;

      # do not show tab pages line ontop
      showtabline = 0;

      # Enable auto indenting and set it to spaces
      smarttab = true;
      smartindent = true;
      shiftwidth = 2;

      # Enable smart indenting (see https://stackoverflow.com/questions/1204149/smart-wrap-in-vim)
      breakindent = true;

      # Enable text wrap
      wrap = true;

      # Better splitting
      splitbelow = true;
      splitright = true;

      # break on special chars close to 80 instead of right at 80 chars
      linebreak = true;
      textwidth = 80;

      conceallevel = 2;

      fillchars = {
        eob = " ";
        fold = " ";
        foldopen = "";
        foldsep = " ";
        foldclose = "";
        vert = "▏";
      };
      foldmethod = "expr";
      foldexpr = "v:lua.vim.treesitter.foldexpr()";
      foldtext = "";
      foldcolumn = "0";
      foldlevel = 99;
      foldlevelstart = 99;
      foldenable = true;

      # Reduce which-key timeout to 10ms
      timeoutlen = 10;

      # Decrease updatetime
      updatetime = 250; # faster completion (4000ms default)

      # Set completeopt to have a better completion exper
      # mostly just for cmpience
      completeopt = [
        "menuone"
        "noselect"
        "noinsert"
      ];

      # no shada
      shada = "";

      splitkeep = "screen";

      # -- Sessions
      # vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
      #
      #
      # -- NOTE: needs checktime autocommand still...idk why
      # vim.opt.autoread = true
      autoread = true;

      # NOTE: is this needed for snacks statuscol?
      signcolumn = "auto:2";

      spell = true;
      spellfile = "/Users/lucas/.config/nvim/spell/en.utf-8.add";
      spelllang = "en";

      cursorline = true;
    };
  };
}
