# Segment

Segment is an SDK-like app designed to showcase the power and functionality of the `proxy_core` plugin. Its primary purpose is to serve as a reference implementation and demonstration of how to integrate and utilize the `proxy_core` plugin for advanced proxy and connection management features in Flutter applications.

---

An app for freedom of internet

## Getting Started 🚀
First run the following command to generate the necessary files:

1. Run `./pre_run_clean.sh`
2. Run `flutter pub run build_runner build`
3. Run `flutter gen-l10n`

Run the following commands to run the app:

```sh
# Development
$ flutter run main.dart
```

## Working with Translations 🌐

This project relies on [flutter_localizations](#links) and
follows
the [official internationalization guide for Flutter](#links).

### Adding Strings

1. To add a new localizable string, open the `app_en.arb` file
   at `lib/l10n/arb/app_en.arb`.

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

2. Then add a new key/value and description and run `flutter gen-l10n`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    },
    "helloWorld": "Hello World",
    "@helloWorld": {
        "description": "Hello World Text"
    }
}
```
3. Use the new string

```dart
@override
Widget build(BuildContext context) {
  final l10n = context.l10n;
  return Text(l10n.helloWorld);
}
```

### Adding Supported Locales

Update the `CFBundleLocalizations` array in the `Info.plist`
at `ios/Runner/Info.plist` to include the new locale.

```xml
<!--...-->
<array>
   <key>CFBundleLocalizations</key>
   <string>en</string>
   <string>es</string>
</array><!--...-->
```

### Adding Translations

1. For each supported locale, add a new ARB file in `lib/l10n/arb`.

```
├── l10n
│   ├── arb
│   │   ├── app_en.arb
│   │   └── app_es.arb
```

2. Add the translated strings to each `.arb` file:

`app_en.arb`

```arb
{
    "@@locale": "en",
    "counterAppBarTitle": "Counter",
    "@counterAppBarTitle": {
        "description": "Text shown in the AppBar of the Counter Page"
    }
}
```

`app_es.arb`

```arb
{
    "@@locale": "es",
    "counterAppBarTitle": "Contador",
    "@counterAppBarTitle": {
        "description": "Texto mostrado en la AppBar de la página del contador"
    }
}
```

## Links

[flutter_localizations](https://api.flutter.dev/flutter/flutter_localizations/flutter_localizations-library.html)

[envied](https://pub.dev/packages/envied)

[internationalization](https://flutter.dev/docs/development/accessibility-and-localization/internationalization)

## License
[MIT License](https://github.com/mahsanet/segment_private/blob/main/LICENSE)
