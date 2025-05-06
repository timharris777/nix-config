# home.nix

{ config, pkgs, lib, ... }:
let
  # inherit (lib.lists) foldl forEach;
  dotfilesDir = 
    if pkgs.stdenv.isDarwin 
    then config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix/dotfiles"
    else config.lib.file.mkOutOfStoreSymlink "/home/timharris/nix/dotfiles";

  link = config.lib.file.mkOutOfStoreSymlink;
  getDotfilesDir = builtins.toString ../dotfiles;
  dotfilesPre = lib.lists.filter (e: ! (e == "" || e == [] )) (lib.filesystem.listFilesRecursive getDotfilesDir);
  dotfiles = pkgs.lib.lists.forEach dotfilesPre (x: pkgs.lib.strings.removePrefix "${getDotfilesDir}/" "${x}" );
  # dotfiles = lib.lists.filter (e: ! (e == "" || e == [])) dotfilesPre;
in
{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "23.05"; # Please read the comment before changing.
   
  # Copy dotfiles where they need to go
  home.file = lib.listToAttrs (map (dotfile: {
      name = "${dotfile}";
      value = {source = link "${dotfilesDir}/${dotfile}";};
    }) dotfiles);

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}