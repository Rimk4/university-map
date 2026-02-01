#!/bin/bash

flutter clean
rm -rf pubspec.lock
flutter pub get
flutter run
