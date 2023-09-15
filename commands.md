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
