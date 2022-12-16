# About

This is my version of a simple haskell workflow to get started learning the language.

# Prerequisites

1. Install nix
2. Use home manager (optional)


# Resources

1. https://github.com/Gabriella439/haskell-nix/tree/main/project0
2. https://nixos.wiki/wiki/FAQ/Pinning_Nixpkgs
3. https://bytes.zone/posts/callcabal2nix/
4. https://haskell4nix.readthedocs.io/nixpkgs-users-guide.html
5. https://discourse.nixos.org/t/super-simple-haskell-development-with-nix/14287/2
6. https://discourse.nixos.org/t/nix-haskell-development-2020/6170
7. https://funprog.srid.ca/nix/haskellpackages-shellfor-withhoogle-is-great.html


# Steps

## 1. Bootstrap cabal project

Benefit of using nix is you don't need to install cabal on your system and can just run it as a once off to create the project.

```
mkdir my-cool-project
cd my-cool-project
nix-shell --pure --packages ghc cabal-install git  --run 'cabal init'
```

## 2. nix stuff

I essentially just copied https://funprog.srid.ca/nix/haskellpackages-shellfor-withhoogle-is-great.html.

`default.nix` is the entry point.

- I pin the nixpkgs to a specific version as recommended [here](https://github.com/Gabriella439/haskell-nix/tree/main/project0#pinning-nixpkgs).
- `callCabal2nix` is used to nixify things. It creates a derivation ready to go, other examples use the cli version that writes to a file. You can read more about it [here](https://bytes.zone/posts/callcabal2nix/).
- If you're running from within `nix-shell` it will setup some nice local dev things like

  - [ghcid](https://github.com/ndmitchell/ghcid)
  - [haskell-language-server](https://github.com/haskell/haskell-language-server)
  - [stylish-haskell](https://github.com/haskell/stylish-haskell)

  You'll notice these appear in `default.nix` under derivation that sets up the shell. You'll need to install the corresponding plugins to vscode.


## 3. local dev loop

All these commands are run in the terminal

1. `nix-shell`
2. from within `nix-shell`, open vscode for reasons mentioned [here](https://haskell4nix.readthedocs.io/nixpkgs-users-guide.html#how-to-make-haskell-language-server-find-a-ghc-from-nix-shell).
3. Enter `ghcid` if you want an auto reloading repl
4. Otherwise `cabal new-repl` for a manual repl.
    The repl has hoogle support so you can type in `:doc a -> a` and search for types this way.


**Improvements**

Instead of having to run `nix-shell` everytime you `cd` into the project you can install [direnv](https://github.com/direnv/direnv/wiki/Nix) for nix.

It's pretty straight forward once you have `direnv` installed just add `.envrc` with `use nix` at the top and done. Your terminal will have the nix shell environment loaded in ready to go.


## 4. building

`nix-build` - will create a derivation in the nix store that contains the executable you can invoke like the 1 below.

```
/nix/store/4v2ni1yf4mqddyriqnaihkwlflk8fbjf-hello-haskell-nix-0.1.0.0/bin/hello-haskell-nix
```

But it's easier to just use the binary that is output into the `result/bin` within your project.

```
result/bin/hello-haskell-nix
```

## 5. Other stuff

It can be confusing to know what base package version corresponds to what ghc version. In `default.nix` I used `ghc902` which based on this guide says to use base `4.15.1.0` which is what I put in the cabal file. You can see the version mappings [here](https://wiki.haskell.org/Base_package).


`build-depends` in cabal file only needs the base version specified as nix packages contain a curated package set that works for that version like how stack works (or something).

The other reason I used `ghc902` was because the nix cache had it all in there and I didn't have to waste time waiting for the whole of ghc to build on my local machine. Not sure why, I assume recent versions aren't completely cached or something.
