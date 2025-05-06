# home.nix

{ config, pkgs, lib, ... }:
let
  # Create link shortcut to use for directory symlinks
  link = config.lib.file.mkOutOfStoreSymlink;
  
  # Set dotfiles directory based on OS being mac or nixos
  dotfilesDir = 
    if pkgs.stdenv.isDarwin 
    then config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.config/nix/dotfiles"
    else config.lib.file.mkOutOfStoreSymlink "/home/timharris/.config/nix/dotfiles";

  # Get all dotfiles from the dotfiles directory
  getDotfilesDir = builtins.toString ../dotfiles;
  dotfilesPre = lib.lists.filter (e: ! (e == "" || e == [] )) (lib.filesystem.listFilesRecursive getDotfilesDir);
  dotfiles = pkgs.lib.lists.forEach dotfilesPre (x: pkgs.lib.strings.removePrefix "${getDotfilesDir}/" "${x}" );
in
{
  # You should not change this value, even if you update Home Manager.
  home.stateVersion = "23.05"; # Please read the comment before changing.
   
  # Copy dotfiles where they need to go
  home.file = lib.listToAttrs (map (dotfile: {
      name = "${dotfile}";
      value = {source = link "${dotfilesDir}/${dotfile}";};
    }) dotfiles);

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}