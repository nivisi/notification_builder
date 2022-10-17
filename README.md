# notification_builder [![pub version][pub-version-img]][pub-version-url]

🦻 A widget that builds using notifications dispatched via the build context.

### Table of contents
 - [About](https://github.com/nivisi/notification_builder#about)
   - [The problem](https://github.com/nivisi/notification_builder#the-problem)
   - [The solution](https://github.com/nivisi/notification_builder#the-solution)
   - [Result](https://github.com/nivisi/notification_builder#result)
   - [If you don't want certain notification to trigger rebuilds...](https://github.com/nivisi/notification_builder#if-you-dont-want-certain-notification-to-trigger-rebuilds)
 - [Getting started](https://github.com/nivisi/notification_builder#getting-started)
   - [pub](https://github.com/nivisi/notification_builder#pub)
   - [Import](https://github.com/nivisi/notification_builder#import)

## About

Notifications — is a tool Flutter uses to pass the data higher in the widget tree hierarchy. Somewhere in depth of your widget tree you can fire a notification and it will go up, like a bubble. And on top, you can catch it using a `NotificationBuilder` to build your UI.

### The problem

Imagine the following widget tree:

```dart
MyWidget(
  color: // I want this to be changed once the button below is clicked!
  child: const SomeChild(
    child: AnotherChild(
      // More and more widgets...
      child: ChildWithTheButton(),
    ),
  ),  
);

class ChildWithTheButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return TextButton(
      title: 'Change colour',
      onPressed: // Here! I want the colour to be changed on this button pressed!
    );
  }
}
```

You could either pass something like a `ChangeNotifier<Color>`, or pass a callback function to set the state, or even use an `InheritedWidget`. Another option is to use a `NotificationListener`.

### The solution

---

> 💡 [Click here](https://github.com/nivisi/notification_builder/blob/develop/src/example/lib/main.dart) to check out the full example.

---

Define your notification:
```dart
class ColorNotification extends Notification {
  const ColorNotification(this.color);

  final Color color;
}
```

Use a NotificationBuilder to catch notifications:
```dart
// MyWidget
NotificationBuilder<ColorNotification>(
  builder: (context, notification, child) {
    // Note: the notification parameter will be null at the very first build.
    // Use a fallback value like this.
    final color = notification?.color ?? Colors.white;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      curve: Curves.fastOutSlowIn,
      decoration: BoxDecoration(color: color),
      child: child,
    );
  },
  child: const SomeChild(...),
),
```

Fire notifications from the widget tree below the builder:
```dart
onPressed: () {
  ColorNotification(color).dispatch(context);
},
```

### Result

<img width=300 src="https://user-images.githubusercontent.com/33932162/196101537-e3330376-f65c-45db-9101-f69396518437.gif"/>

### If you don't want certain notification to trigger rebuilds...

Then you can use the `buildWhen` parameter!

```dart
buildWhen: (notification) {
  // Now if the passed notification will have a red color it will be ignored!
  return notification.color != Colors.red,
}
```

## Getting started

### pub

Add the package to `pubspec.yaml`:

```
dependencies:
  notification_builder:
```

### Import

Add the dependency to your file:

```dart
import 'package:notification_builder/notification_builder.dart';
```

<!-- References -->
[pub-version-img]: https://img.shields.io/badge/pub-v0.0.1-0175c2?logo=flutter
[pub-version-url]: https://pub.dev/packages/notification_builder
