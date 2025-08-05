{
  autoCmd = [
    {
      event = [
        "FocusGained"
        "BufEnter"
      ];
      command = "checktime";
      desc = "Check for external file changes when gaining focus or entering buffer";
    }
    {
      event = "BufLeave";
      command = "set nocursorline";
      desc = "Disable cursor line highlight when leaving a buffer";
    }
    {
      event = "BufEnter";
      command = "set cursorline";
      desc = "Enable cursor line highlight when entering a buffer";
    }
  ];
}
