import 'package:flutter/widgets.dart';

import 'brian_theme_data.dart';

/// 하위 위젯에 Brian UI 테마를 전달합니다.
///
/// [of]로 테마를 읽은 위젯은 데이터가 변경되면 다시 빌드됩니다.
/// 중첩하면 가장 가까운 테마를 사용합니다. 별도 라우트나 오버레이에
/// 지역 테마를 전달하려면 [InheritedTheme.captureAll]을 사용합니다.
///
/// ```dart
/// BrianTheme(
///   data: BrianThemeData.light,
///   child: Builder(
///     builder: (context) => ColoredBox(
///       color: BrianTheme.of(context).colors.background.layerDefault,
///     ),
///   ),
/// )
/// ```
///
/// {@category Theme}
class BrianTheme extends InheritedTheme {
  const BrianTheme({super.key, required this.data, required super.child});

  final BrianThemeData data;

  /// 가장 가까운 테마를 반환하고 변경을 구독합니다.
  ///
  /// 상위에 [BrianTheme]이 없으면 null을 반환합니다.
  static BrianThemeData? maybeOf(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<BrianTheme>()?.data;

  /// 가장 가까운 테마를 반환하고 변경을 구독합니다.
  ///
  /// 상위에 [BrianTheme]이 없으면 [FlutterError]를 던집니다.
  /// 위젯을 BrianTheme으로 감싸고 그 아래의 context를 전달해야 합니다.
  static BrianThemeData of(BuildContext context) {
    final data = maybeOf(context);
    if (data != null) return data;
    throw FlutterError(
      'BrianTheme.of(context)를 호출한 위치에 BrianTheme이 없습니다. '
      '상위에 BrianTheme을 배치하고 그 아래의 BuildContext를 사용하세요.',
    );
  }

  @override
  bool updateShouldNotify(BrianTheme oldWidget) => data != oldWidget.data;

  @override
  Widget wrap(BuildContext context, Widget child) =>
      BrianTheme(data: data, child: child);
}
