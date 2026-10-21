import 'dart:math' as math;

import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

/// 부모 제약을 우선하고 남는 공간에서 투명한 터치 영역을 확보합니다.
class ControlTouchTarget extends SingleChildRenderObjectWidget {
  const ControlTouchTarget({
    super.key,
    required this.minimumSize,
    required super.child,
  });

  final Size? minimumSize;

  @override
  RenderObject createRenderObject(BuildContext context) =>
      _RenderControlTouchTarget(minimumSize ?? Size.zero);

  @override
  void updateRenderObject(BuildContext context, RenderObject renderObject) =>
      (renderObject as _RenderControlTouchTarget).minimumSize =
          minimumSize ?? Size.zero;
}

class _RenderControlTouchTarget extends RenderShiftedBox {
  _RenderControlTouchTarget(this._minimumSize) : super(null);

  Size _minimumSize;
  set minimumSize(Size value) {
    if (_minimumSize == value) return;
    _minimumSize = value;
    markNeedsLayout();
  }

  Size _targetSize(BoxConstraints constraints, Size childSize) =>
      constraints.constrain(
        Size(
          math.max(_minimumSize.width, childSize.width),
          math.max(_minimumSize.height, childSize.height),
        ),
      );

  @override
  double computeMinIntrinsicWidth(double height) =>
      math.max(_minimumSize.width, super.computeMinIntrinsicWidth(height));

  @override
  double computeMaxIntrinsicWidth(double height) =>
      math.max(_minimumSize.width, super.computeMaxIntrinsicWidth(height));

  @override
  double computeMinIntrinsicHeight(double width) =>
      math.max(_minimumSize.height, super.computeMinIntrinsicHeight(width));

  @override
  double computeMaxIntrinsicHeight(double width) =>
      math.max(_minimumSize.height, super.computeMaxIntrinsicHeight(width));

  @override
  Size computeDryLayout(BoxConstraints constraints) =>
      _targetSize(constraints, child?.getDryLayout(constraints) ?? Size.zero);

  @override
  double? computeDryBaseline(
    BoxConstraints constraints,
    TextBaseline baseline,
  ) {
    final childBaseline = child?.getDryBaseline(constraints, baseline);
    if (childBaseline == null) return null;
    final childSize = child!.getDryLayout(constraints);
    return childBaseline +
        (_targetSize(constraints, childSize).height - childSize.height) / 2;
  }

  @override
  void performLayout() {
    // 부모의 최소 크기·전체 너비 계약은 전달하되 터치 최소 크기는 전달하지 않습니다.
    child?.layout(constraints, parentUsesSize: true);
    final childSize = child?.size ?? Size.zero;
    size = _targetSize(constraints, childSize);
    if (child != null) {
      final parentData = child!.parentData! as BoxParentData;
      parentData.offset = Offset(
        (size.width - childSize.width) / 2,
        (size.height - childSize.height) / 2,
      );
    }
  }
}
