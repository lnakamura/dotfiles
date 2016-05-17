#!/bin/bash

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

# Casks
brew cask install google-chrome
brew cask install dockertoolbox
brew cask install heroku-toolbelt
brew cask install imageoptim
brew cask install postgres

brew install gradle
brew install imagemagick
brew install node
brew install redis
brew install swiftlint
brew install go
brew install pyenv

# Remove outdated versions from the cellar.
brew cleanup
