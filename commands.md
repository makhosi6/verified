### Generate build script

```bash
dart run build_runner build --delete-conflicting-outputs
```

### Clear App Cache & Everything

```
dart pub cache clean -f;flutter pub cache clean -f; flutter clean;flutter pub get
```

### Build for the web

```
flutter build web --web-renderer canvaskit
```

### Common fix for pod/cocoapod error on iOS

- run the following commands, follow the sequence

  ```bash

      # get into the ios folder
      cd ios/

      # clear all outdated pods
      sudo rm -r Pods
      #
      rm -f Podfile.lock

      # clean and reinstall
      pod install --repo-update --verbose ## use --verbose flag to track the changes, bacause this install can take up to 15mins since 'MobileVLCKit' is very big.

      # clean and reinstall (this command is not neccesary run this only if the one above failed/didn't work)
      pod cache clean --all;pod deintegrate --verbose;pod setup --verbose;pod install --verbose

      # DONE
      cd ../;flutter run
  ```

  ## firebase local server
  - `firebase emulators:start`


  ## ngrok 
  - `ngrok start --config "/Users/makhosi/~/Library/Application Support/ngrok/ngrok.yml" --all`