{
  programs.thunderbird = {
    enable = true;
    #policies = { };
    #Preferences = { };
    preferencesStatus = "default";
    # "default": Preferences appear as default.
    # "locked": Preferences appear as default and can’t be changed.
    # "user": Preferences appear as changed.
    # "clear": Value has no effect. Resets to factory defaults on each startup.
  };
}
