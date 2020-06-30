# iboxpro_flutter

Flutter плагин для работы с библиотекой [iboxpro](https://www.2can.ru/developer).  
Этот проект использует библиотеку iboxpro, которая является собственностью 2can.

## Предварительные настройки

1. Получить логин и пароль на [сайте](https://www.2can.ru)
2. Указать `version` в `pubspec.yaml`. Апи iboxpro отправляет версию, если ее не указать, то приложение упадет
3. Настроить нативные среды

### iOS

Указать в `Info.plist`

```xml
    <key>NSAppTransportSecurity</key>
    <dict>
        <key>NSAllowsArbitraryLoads</key>
        <true/>
    </dict>
    <key>UIBackgroundModes</key>
    <array>
        <string>external-accessory</string>
        <string>bluetooth-central</string>
    </array>
    <key>NSMicrophoneUsageDescription</key>
    <string>Used for iBoxPro</string>
```

Для полного функционала также указать

```xml
    <key>NSLocationUsageDescription</key>
    <string>Used for iBoxPro</string>
    <key>NSLocationAlwaysUsageDescription</key>
    <string>Used for iBoxPro</string>
```

### Android

Указать в `AndroidManifest.xml`

```xml
    <uses-permission android:name="android.permission.INTERNET" />
    <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
    <uses-permission android:name="android.permission.BLUETOOTH_ADMIN" />
    <uses-permission android:name="android.permission.BLUETOOTH" />
```

Для полного функционала также указать

```xml
    <uses-permission android:name="android.permission.CAMERA" />
    <uses-permission android:name="android.permission.WRITE_EXTERNAL_STORAGE" />
    <uses-permission android:name="android.permission.READ_PHONE_STATE" />
    <uses-permission android:name="android.permission.RECORD_AUDIO" />
    <uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
    <uses-permission android:name="android.permission.ACTION_HEADSET_PLUG" />
    <uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
    <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
```

После этого плагин можно использовать в приложении.  
Использование плагина можно посмотреть в приложении-пример.
