{ pkgs, preCommitCheck, ... }:

{
  # Devenv configuration separated into its own file. This imports the
  # preCommitCheck object computed in flake.nix so we can include the same
  # packages and shellHook the project previously used in the mkShell-based
  # devShell.

  env = {
    DEVENV = "1";
  };

  # Merge packages from the git-hooks pre-commit-check (if present) with the
  # repository's usual developer tools.
  packages = (builtins.concatLists [ (if preCommitCheck == null then [] else preCommitCheck.enabledPackages) ]) ++ with pkgs; [
    git
    curl
    pre-commit
    treefmt
  ];

  # If the preCommitCheck provides a shellHook, reuse it here so the same
  # repository checks run when entering the devenv shell.
  shellHook = if preCommitCheck == null then "" else preCommitCheck.shellHook;

  languages.nix.enable = true;
  languages.nodejs.enable = true;

  scripts = {
    hello.exec = "echo 'devenv shell active'";
  };
}
