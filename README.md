 flutter config --enable-web



flutter build web --release
Output folder: build/web/
You can host this folder on any web server (NGINX, Firebase Hosting, Netlify, etc.).
Open index.html in a browser to test locally.


flutter build apk --release


flutter build apk --debug


flutter run -d chrome

flutter run -d chrome --web-port=5173

build/app/outputs/flutter-apk/app-release.apk

flutter build apk --split-per-abi

flutter build appbundle --release


flutter pub run rebuild_tracker
flutter pub run leak_tracker
flutter pub run size_analyzer
flutter analyze

dart pub run dart_code_metrics:metrics lib/


ios
flutter build ios --release
