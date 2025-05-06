# nix-config and dotfiles

1. Install Determinate Linux
    ```
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate
    ```
2. Checkout repo:
    ```
    git clone https://github.com/timharris777/nix-config.git ~/.config/nix
    ```
3. Run the following command for initial setup:
    ```
    nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake ~/.config/nix#macos
    ```
4. For subsequent updates the following can be run:
    ```
    darwin-rebuild switch --flake ~/.config/nix#macos
    ```