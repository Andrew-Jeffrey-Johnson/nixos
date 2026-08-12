{ pkgs, ... }:
{
  programs.yazi = {
    enable = true;
    settings = {
      yazi = {
        show_hidden = true;
        ratio = [
          1
          3
          4
        ];
        opener = {
          play = [
            {
              run = "mpv %s";
              orphan = true;
            }
          ];
          edit = [
            {
              run = "$EDITOR %s";
              block = true;
            }
          ];
          openBook = [
            {
              run = pkgs.epy + /bin/epy + " \"$@\"";
              block = true;
            }
          ];
        };
        open = {
          rules = [
            {
              mime = "text/*";
              use = "edit";
            }
            {
              mime = "video/*";
              use = "play";
            }
            {
              name = "*.epub";
              use = "openBook";
            }
            {
              url = "*";
              use = "librewolf";
            }
          ];
        };
      };
    };
  };
}
