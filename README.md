# iboxpro_flutter

Flutter плагин для работы с библиотекой [iboxpro](https://www.2can.ru/developer).
__Работает только на ios__

Этот проект использует библиотеку iboxpro, которая является собственностью 2can.

## Предварительные настройки

1. Получить логин и пароль на [сайте](https://www.2can.ru)
2. Указать `version` в `pubspec.yaml`. Апи iboxpro отправляет версию, если ее не указать, то приложение упадет
3. Указать в `Info.plist`

```info
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
    <key>NSLocationUsageDescription</key>
    <string>Used for iBoxPro</string>
    <key>NSLocationAlwaysUsageDescription</key>
    <string>Used for iBoxPro</string>
    <key>NSMicrophoneUsageDescription</key>
    <string>Used for iBoxPro</string>
```

После этого плагин можно использовать в приложении.
Для примера использования можно посмотреть приложение-пример.
