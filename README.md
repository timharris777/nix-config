# nix-config and dotfiles

1. Install Determinate Linux
    ```
    curl --proto '=https' --tlsv1.2 -sSf -L https://install.determinate.systems/nix | sh -s -- install --determinate
    ```
2. Checkout repo:
    ```
    git clone https://github.com/timharris777/nix-config.git ~/.config/nix
    ```
3. Run nix-darwin
    ```
    nix run nix-darwin --extra-experimental-features nix-command --extra-experimental-features flakes -- switch --flake ~/.config/nix#macos
    ```   