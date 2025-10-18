#!/bin/bash
curl -sL https://firebase.tools | bash
firebase login

brew tap leoafarias/fvm
brew install fvm
fvm install 3.35.4
fvm global 3.35.4

dart pub global activate flutterfire_cli
dart pub global activate get_cli
dart pub global activate flutter_gen 5.8.0

curl -fsSL https://raw.githubusercontent.com/Snoobdog10x/share-shell-script/main/cli_installer.sh | sh -s -- main