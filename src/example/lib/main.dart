import 'package:flutter/material.dart';
import 'package:notification_builder/notification_builder.dart';

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notification Builder',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationBuilder<ColorNotification>(
        builder: (context, notification, child) {
          // Use a fallback value like this.
          final color = notification?.color ?? Colors.white;

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.fastOutSlowIn,
            decoration: BoxDecoration(color: color),
            child: child,
          );
        },
        // Note: it is more efficient to use this `child` parameter for widgets
        // that don't depend on notifications.
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(),
              ColoredBox(
                color: Colors.white,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 12.0),
                    const Text(
                      'Tap to change the color using a Notification Builder!',
                      style: TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        ChangeColorButton(color: Colors.red, title: 'Red'),
                        SizedBox(width: 8.0),
                        ChangeColorButton(color: Colors.green, title: 'Green'),
                        SizedBox(width: 8.0),
                        ChangeColorButton(color: Colors.blue, title: 'Blue'),
                      ],
                    ),
                    const SizedBox(height: 24.0),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ChangeColorButton extends StatelessWidget {
  const ChangeColorButton({
    Key? key,
    required this.title,
    required this.color,
  }) : super(key: key);

  final String title;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      color: Colors.black,
      onPressed: () {
        ColorNotification(color).dispatch(context);
      },
      child: Text(
        title,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}

class ColorNotification extends Notification {
  const ColorNotification(this.color);

  final Color color;
}
