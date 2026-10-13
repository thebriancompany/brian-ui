import 'package:brian_ui/brian_ui.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(
    WidgetsApp(
      color: BrianStaticColors.white,
      builder: (context, child) {
        final brightness = MediaQuery.platformBrightnessOf(context);
        final data = BrianThemeData.forBrightness(brightness);
        return BrianTheme(
          data: data,
          child: Center(
            child: BrianButton(onPressed: () {}, child: const Text('시작하기')),
          ),
        );
      },
    ),
  );
}
