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
      };

      timeoutlen = 500;
      updatetime = 2000;

      # no shada
      shada = "";

      #
      #
      # -- Autocomplete
      # vim.opt.completeopt = "menu,menuone,noselect"
      #
      # -- Sessions
      # vim.opt.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
      #
      # vim.opt.splitkeep = "screen"
      #
      # vim.opt.conceallevel = 2
      #
      # -- NOTE: needs checktime autocommand still...idk why
      # vim.opt.autoread = true
    };
  };
}
