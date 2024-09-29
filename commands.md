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

  - `ngrok start --config "~/Library/Application Support/ngrok/ngrok.yml" --all`

  ### push with a tag/ref

  - ```bash
    <!-- set remote configs -->
    gh variable set CONFIG_FILE < "lib/app_config.dart"
    <!-- push to git with a tag -->
    git add .
    git commit -m "Add two pages/tutorials, remove unused pkgs, version bump: v1.1.40.beta"
    git tag -a v1.1.40.beta -m "Add two pages/tutorials, version bump: v1.1.40.beta"
    git push origin v1.1.40.beta
    git push --follow-tags

    ```

### prepare secrets for git

- ```

  base64 -i android/key.properties -o android/key.base64

  base64 -i android/key.properties -o android/key.base64

  base64 -i android/verified.pem -o android/verified_pem.base64

  base64 -i lib/app_config.dart -o lib/app_config.base64

  base64 -i lib/helpers/security/nonce.private.dart -o lib/helpers/security/nonce_private.base64

  base64 -i server/nonce.js -o server/nonce.base64

  ```

### run backend server

- ```bash
    docker-compose build
    docker-compose -p verified up -d --force-recreate --build --remove-orphans --timestamps
    docker-compose down

  ```

### Build

- ```bash
    docker build -t makhosi/{{image}}:1.0.0 -t makhosi/{{image}}:latest . --platform="linux/amd64"
  ```

### Apple Push Notification

- Trigger a Apple Push Notification; `xcrun simctl push booted com.byteestudio.Verified ios/push.json`

### Apple trigger deep-link click

- `/usr/bin/xcrun simctl openurl booted "app://byteestudio.com/foo/secure/123e4567-e89b-12d3-a456-426614174000/123e4567-e89b-12d3-a456-426614174000"`

### Android trigger deep-link click

- `adb shell am start -a android.intent.action.VIEW  -d "app://byteestudio.com/foo/secure/89b-12d3-a456-426614174000/123e4567-e89b-12d3-a456-426614174000" `

## buddle and merge certs
- `cd localhost`
- `cd verified.byteestudio.com`
- `cat certificate.crt ca_bundle.crt >> merged_certificate.crt`

## firebase analytics debug view

- ```bash
  adb shell setprop log.tag.FA VERBOSE
  adb shell setprop log.tag.FA-SVC VERBOSE
  adb logcat -v time -s FA FA-SVC
  adb shell setprop debug.firebase.analytics.app "com.byteestudio.verified"
  ```

### check-out
- https://regulaforensics.com
- https://usesmileid.com
- https://regulaforensics.com
- https://verifyid.co.za
- https://dha.gov.za
- https://www.mie.co.za
- https://connect.iidentifii.com/