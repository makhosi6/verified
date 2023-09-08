### Generate build script

```bash 
flutter packages pub run build_runner build --delete-conflicting-outputs
```

### Clear App Cache & Everything

```
dart pub cache clean -f;flutter pub cache clean -f; flutter clean;flutter pub get
```