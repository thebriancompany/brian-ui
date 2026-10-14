import 'dart:ui' show SemanticsValidationResult;

import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform;
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

import '../button/brian_button.dart';
import '../radius/brian_radius.dart';
import '../spacing/brian_spacing.dart';
import '../theme/brian_theme.dart';
import '../theme/brian_theme_data.dart';

/// 한 줄 입력의 외곽선 또는 밑줄 표현입니다.
///
/// {@category TextInput}
enum BrianTextInputVariant { outline, underline }

/// 한 줄 텍스트 입력입니다. BrianTheme과 Overlay 아래에서 유한한 너비로 사용합니다.
///
/// 라벨·도움말·오류 문구는 BrianField와 조합합니다.
/// Material·Cupertino 없이 EditableText의 편집 및 선택 동작을 사용합니다.
///
/// {@category TextInput}
class BrianTextInput extends StatelessWidget {
  const BrianTextInput({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.placeholder,
    this.semanticLabel,
    this.enabled = true,
    this.readOnly = false,
    this.isInvalid = false,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.contextMenuBuilder,
    this.variant = BrianTextInputVariant.outline,
    this.obscureText = false,
    this.showClearButton = false,
    this.clearButtonLabel = '입력 지우기',
    this.prefix,
    this.suffix,
  }) : assert(controller == null || initialValue == null),
       assert(clearButtonLabel.length > 0);

  /// 외부 컨트롤러는 호출자가 해제합니다. initialValue와 함께 지정할 수 없습니다.
  final TextEditingController? controller;

  /// 내부 컨트롤러를 만들 때만 사용합니다. 이후 값 변경은 controller로 제어합니다.
  final String? initialValue;

  /// 외부 포커스 노드는 호출자가 해제합니다.
  final FocusNode? focusNode;

  final String? placeholder;

  /// 입력의 접근성 이름입니다. Field의 라벨도 이 속성으로 전달합니다.
  final String? semanticLabel;

  /// false이면 입력·선택·포커스와 앞뒤 슬롯의 동작을 차단합니다.
  final bool enabled;

  /// 값을 변경하지 못하지만 포커스·선택·복사는 허용합니다.
  final bool readOnly;

  /// 오류 테두리와 접근성 오류 상태를 표시합니다. 오류 문구는 Field에서 제공합니다.
  final bool isInvalid;

  final bool autofocus;

  /// 사용자 편집과 지우기 버튼에 호출됩니다. controller의 직접 변경에는 호출하지 않습니다.
  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onSubmitted;

  final TextInputType? keyboardType;

  final TextInputAction? textInputAction;

  final List<TextInputFormatter>? inputFormatters;

  final Iterable<String>? autofillHints;

  final TextCapitalization textCapitalization;

  final bool autocorrect;

  /// 생략하면 기본 편집 메뉴를 제공합니다. 앱의 지역화·메뉴 정책에 맞게 교체할 수 있습니다.
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  final BrianTextInputVariant variant;

  /// 숨김 상태에서도 선택·붙여넣기는 허용하며 복사·잘라내기는 차단합니다.
  final bool obscureText;

  /// 편집 가능하고 값이 있을 때 지우기 버튼을 표시합니다.
  final bool showClearButton;

  final String clearButtonLabel;

  final Widget? prefix;

  final Widget? suffix;

  @override
  Widget build(BuildContext context) => _BrianEditable(
    controller: controller,
    initialValue: initialValue,
    focusNode: focusNode,
    placeholder: placeholder,
    semanticLabel: semanticLabel,
    enabled: enabled,
    readOnly: readOnly,
    isInvalid: isInvalid,
    autofocus: autofocus,
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    inputFormatters: inputFormatters,
    autofillHints: autofillHints,
    textCapitalization: textCapitalization,
    autocorrect: autocorrect,
    contextMenuBuilder: contextMenuBuilder,
    variant: variant,
    obscureText: obscureText,
    showClearButton: showClearButton,
    clearButtonLabel: clearButtonLabel,
    prefix: prefix,
    suffix: suffix,
    minLines: 1,
    maxLines: 1,
  );
}

/// 여러 줄 텍스트 입력입니다. 기본 세 줄에서 내용에 따라 높이가 늘어납니다.
/// BrianTheme과 Overlay 아래에서 유한한 너비로 사용합니다.
///
/// 라벨·도움말·오류 문구는 BrianField와 조합합니다.
/// Material·Cupertino 없이 EditableText의 편집 및 선택 동작을 사용합니다.
///
/// {@category TextArea}
class BrianTextArea extends StatelessWidget {
  const BrianTextArea({
    super.key,
    this.controller,
    this.initialValue,
    this.focusNode,
    this.placeholder,
    this.semanticLabel,
    this.enabled = true,
    this.readOnly = false,
    this.isInvalid = false,
    this.autofocus = false,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.autofillHints,
    this.textCapitalization = TextCapitalization.none,
    this.autocorrect = true,
    this.contextMenuBuilder,
    this.minLines = 3,
    this.maxLines,
  }) : assert(controller == null || initialValue == null),
       assert(minLines > 0),
       assert(maxLines == null || maxLines >= minLines);

  /// 외부 컨트롤러는 호출자가 해제합니다. initialValue와 함께 지정할 수 없습니다.
  final TextEditingController? controller;

  /// 내부 컨트롤러를 만들 때만 사용합니다. 이후 값 변경은 controller로 제어합니다.
  final String? initialValue;

  /// 외부 포커스 노드는 호출자가 해제합니다.
  final FocusNode? focusNode;

  final String? placeholder;

  /// 입력의 접근성 이름입니다. Field의 라벨도 이 속성으로 전달합니다.
  final String? semanticLabel;

  /// false이면 입력·선택·포커스와 앞뒤 슬롯의 동작을 차단합니다.
  final bool enabled;

  /// 값을 변경하지 못하지만 포커스·선택·복사는 허용합니다.
  final bool readOnly;

  /// 오류 테두리와 접근성 오류 상태를 표시합니다. 오류 문구는 Field에서 제공합니다.
  final bool isInvalid;

  final bool autofocus;

  /// 사용자 편집과 지우기 버튼에 호출됩니다. controller의 직접 변경에는 호출하지 않습니다.
  final ValueChanged<String>? onChanged;

  final ValueChanged<String>? onSubmitted;

  final TextInputType? keyboardType;

  final TextInputAction? textInputAction;

  final List<TextInputFormatter>? inputFormatters;

  final Iterable<String>? autofillHints;

  final TextCapitalization textCapitalization;

  final bool autocorrect;

  /// 생략하면 기본 편집 메뉴를 제공합니다. 앱의 지역화·메뉴 정책에 맞게 교체할 수 있습니다.
  final EditableTextContextMenuBuilder? contextMenuBuilder;

  /// 최소 표시 줄 수입니다. 글자 확대에 따라 실제 높이도 늘어납니다.
  final int minLines;

  /// null이면 내용에 따라 계속 늘어납니다. minLines와 같으면 고정 줄 수로 내부 스크롤합니다.
  final int? maxLines;

  @override
  Widget build(BuildContext context) => _BrianEditable(
    controller: controller,
    initialValue: initialValue,
    focusNode: focusNode,
    placeholder: placeholder,
    semanticLabel: semanticLabel,
    enabled: enabled,
    readOnly: readOnly,
    isInvalid: isInvalid,
    autofocus: autofocus,
    onChanged: onChanged,
    onSubmitted: onSubmitted,
    keyboardType: keyboardType,
    textInputAction: textInputAction,
    inputFormatters: inputFormatters,
    autofillHints: autofillHints,
    textCapitalization: textCapitalization,
    autocorrect: autocorrect,
    contextMenuBuilder: contextMenuBuilder,
    minLines: minLines,
    maxLines: maxLines,
    variant: BrianTextInputVariant.outline,
    obscureText: false,
    showClearButton: false,
    clearButtonLabel: '입력 지우기',
  );
}

class _BrianEditable extends StatefulWidget {
  const _BrianEditable({
    this.controller,
    this.initialValue,
    this.focusNode,
    this.placeholder,
    this.semanticLabel,
    required this.enabled,
    required this.readOnly,
    required this.isInvalid,
    required this.autofocus,
    this.onChanged,
    this.onSubmitted,
    this.keyboardType,
    this.textInputAction,
    this.inputFormatters,
    this.autofillHints,
    required this.textCapitalization,
    required this.autocorrect,
    this.contextMenuBuilder,
    required this.variant,
    required this.obscureText,
    required this.showClearButton,
    required this.clearButtonLabel,
    this.prefix,
    this.suffix,
    required this.minLines,
    this.maxLines,
  });
  final TextEditingController? controller;
  final String? initialValue;
  final FocusNode? focusNode;
  final String? placeholder;
  final String? semanticLabel;
  final bool enabled;
  final bool readOnly;
  final bool isInvalid;
  final bool autofocus;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final List<TextInputFormatter>? inputFormatters;
  final Iterable<String>? autofillHints;
  final TextCapitalization textCapitalization;
  final bool autocorrect;
  final EditableTextContextMenuBuilder? contextMenuBuilder;
  final BrianTextInputVariant variant;
  final bool obscureText;
  final bool showClearButton;
  final String clearButtonLabel;
  final Widget? prefix;
  final Widget? suffix;
  final int minLines;
  final int? maxLines;

  @override
  State<_BrianEditable> createState() => _BrianEditableState();
}

class _BrianEditableState extends State<_BrianEditable>
    implements TextSelectionGestureDetectorBuilderDelegate {
  TextEditingController? _ownedController;
  FocusNode? _ownedFocus;
  final _handleColor = ValueNotifier<Color>(const Color(0x00000000));
  late final _selectionControls = _InputSelectionControls(_handleColor);
  bool _showHandles = false;
  TextEditingController get _controller =>
      widget.controller ?? _ownedController!;
  FocusNode get _focus => widget.focusNode ?? _ownedFocus!;

  @override
  final editableTextKey = GlobalKey<EditableTextState>();
  @override
  bool get forcePressEnabled => false;
  @override
  bool get selectionEnabled => widget.enabled;
  late final _gestures = TextSelectionGestureDetectorBuilder(delegate: this);

  @override
  void initState() {
    super.initState();
    if (widget.controller == null) {
      _ownedController = TextEditingController(text: widget.initialValue);
    }
    if (widget.focusNode == null) _ownedFocus = FocusNode();
    _controller.addListener(_refresh);
    _focus.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void didUpdateWidget(_BrianEditable oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      final oldController = oldWidget.controller ?? _ownedController!;
      oldController.removeListener(_refresh);
      if (widget.controller == null) {
        _ownedController = TextEditingController.fromValue(oldController.value);
      } else {
        _ownedController?.dispose();
        _ownedController = null;
      }
      _controller.addListener(_refresh);
    }
    if (oldWidget.focusNode != widget.focusNode) {
      (oldWidget.focusNode ?? _ownedFocus!).removeListener(_refresh);
      _ownedFocus?.dispose();
      _ownedFocus = widget.focusNode == null ? FocusNode() : null;
      _focus.addListener(_refresh);
    }
    if (!widget.enabled && _focus.hasFocus) _focus.unfocus();
  }

  @override
  void dispose() {
    _controller.removeListener(_refresh);
    _focus.removeListener(_refresh);
    _ownedController?.dispose();
    _ownedFocus?.dispose();
    _handleColor.dispose();
    super.dispose();
  }

  void _clear() {
    _controller.value = const TextEditingValue(
      selection: TextSelection.collapsed(offset: 0),
    );
    widget.onChanged?.call('');
    editableTextKey.currentState?.requestKeyboard();
  }

  @override
  Widget build(BuildContext context) {
    final theme = BrianTheme.of(context);
    final colors = theme.colors;
    // 테마 전환 중에도 핸들 객체를 유지합니다. 오버레이는 현재 빌드가
    // 끝난 뒤 색상만 갱신해 편집 중인 선택 상태를 보존합니다.
    if (_handleColor.value != colors.foreground.brand) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _handleColor.value = colors.foreground.brand;
      });
    }
    final focused = widget.enabled && _focus.hasFocus;
    final foreground = widget.enabled
        ? colors.foreground.neutral
        : colors.foreground.disabled;
    final border = !widget.enabled
        ? colors.stroke.neutralWeak
        : widget.isInvalid
        ? colors.foreground.criticalContrast
        : focused
        ? colors.stroke.focusRing
        : colors.stroke.neutralWeak;
    final underline = widget.variant == BrianTextInputVariant.underline;
    final textStyle = theme.typography.t5Regular.copyWith(color: foreground);
    final canClear =
        widget.showClearButton &&
        widget.enabled &&
        !widget.readOnly &&
        _controller.text.isNotEmpty;
    final editor = _gestures.buildGestureDetector(
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: BrianSpacing.x3),
        child: Stack(
          alignment: AlignmentDirectional.topStart,
          children: [
            if (_controller.text.isEmpty && widget.placeholder != null)
              IgnorePointer(
                child: ExcludeSemantics(
                  child: Text(
                    widget.placeholder!,
                    maxLines: widget.maxLines,
                    overflow: TextOverflow.clip,
                    style: textStyle.copyWith(
                      color: widget.enabled
                          ? colors.foreground.placeholder
                          : colors.foreground.disabled,
                    ),
                  ),
                ),
              ),
            Semantics(
              label: widget.semanticLabel,
              hint: widget.placeholder,
              validationResult: widget.isInvalid
                  ? SemanticsValidationResult.invalid
                  : SemanticsValidationResult.none,
              child: EditableText(
                key: editableTextKey,
                controller: _controller,
                focusNode: _focus,
                readOnly: widget.readOnly || !widget.enabled,
                autofocus: widget.autofocus && widget.enabled,
                style: textStyle,
                cursorColor: colors.foreground.brand,
                backgroundCursorColor: colors.foreground.neutralMuted,
                selectionColor: colors.background.brandWeak,
                minLines: widget.minLines,
                maxLines: widget.maxLines,
                obscureText: widget.obscureText,
                autocorrect: widget.autocorrect && !widget.obscureText,
                enableSuggestions: !widget.obscureText,
                keyboardType:
                    widget.keyboardType ??
                    (widget.maxLines == 1
                        ? TextInputType.text
                        : TextInputType.multiline),
                textInputAction: widget.textInputAction,
                inputFormatters: [
                  if (widget.maxLines == 1)
                    FilteringTextInputFormatter.singleLineFormatter,
                  ...?widget.inputFormatters,
                ],
                autofillHints: widget.autofillHints,
                textCapitalization: widget.textCapitalization,
                onChanged: widget.enabled ? widget.onChanged : null,
                onSubmitted: widget.enabled ? widget.onSubmitted : null,
                rendererIgnoresPointer: true,
                enableInteractiveSelection: selectionEnabled,
                selectionControls: _selectionControls,
                contextMenuBuilder:
                    widget.contextMenuBuilder ??
                    (context, state) => _buildMenu(context, state, theme),
                showSelectionHandles: selectionEnabled && _showHandles,
                onSelectionChanged: (selection, cause) {
                  final mobile =
                      defaultTargetPlatform == TargetPlatform.android ||
                      defaultTargetPlatform == TargetPlatform.iOS;
                  final show =
                      mobile &&
                      cause != SelectionChangedCause.keyboard &&
                      cause != null &&
                      _controller.text.isNotEmpty;
                  if (_showHandles != show) setState(() => _showHandles = show);
                },
              ),
            ),
          ],
        ),
      ),
    );
    return Semantics(
      enabled: widget.enabled,
      child: TextFieldTapRegion(
        child: ExcludeFocus(
          excluding: !widget.enabled,
          child: IgnorePointer(
            ignoring: !widget.enabled,
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTap: () => editableTextKey.currentState?.requestKeyboard(),
              child: Container(
                constraints: const BoxConstraints(minHeight: 52),
                padding: EdgeInsets.symmetric(
                  horizontal: underline ? 0 : BrianSpacing.x4,
                ),
                decoration: BoxDecoration(
                  color: widget.enabled
                      ? colors.background.layerDefault
                      : colors.background.neutralWeak,
                  borderRadius: underline
                      ? null
                      : BorderRadius.circular(BrianRadius.r3),
                  border: underline
                      ? Border(bottom: BorderSide(color: border))
                      : Border.all(color: border),
                ),
                // 포커스 윤곽선은 레이아웃 크기를 바꾸지 않고 덧그립니다.
                foregroundDecoration: focused
                    ? BoxDecoration(
                        borderRadius: underline
                            ? null
                            : BorderRadius.circular(BrianRadius.r3),
                        border: underline
                            ? Border(
                                bottom: BorderSide(color: border, width: 2),
                              )
                            : Border.all(color: border, width: 2),
                      )
                    : null,
                child: IconTheme(
                  data: IconThemeData(size: 20, color: foreground),
                  child: DefaultTextStyle.merge(
                    style: textStyle,
                    child: Row(
                      children: [
                        if (widget.prefix != null) ...[
                          widget.prefix!,
                          const SizedBox(width: BrianSpacing.x2),
                        ],
                        Expanded(child: editor),
                        if (canClear) ...[
                          const SizedBox(width: BrianSpacing.x2),
                          BrianButton.icon(
                            variant: BrianButtonVariant.ghost,
                            size: BrianButtonSize.small,
                            semanticLabel: widget.clearButtonLabel,
                            onPressed: _clear,
                            icon: const Text('×'),
                          ),
                        ],
                        if (widget.suffix != null) ...[
                          const SizedBox(width: BrianSpacing.x2),
                          widget.suffix!,
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _InputSelectionControls extends TextSelectionControls
    with TextSelectionHandleControls {
  _InputSelectionControls(this.color);
  final ValueNotifier<Color> color;

  @override
  Size getHandleSize(double textLineHeight) => const Size(20, 20);
  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) =>
      const Offset(10, 0);
  @override
  Widget buildHandle(
    BuildContext context,
    TextSelectionHandleType type,
    double textLineHeight, [
    VoidCallback? onTap,
  ]) => GestureDetector(
    onTap: onTap,
    child: ValueListenableBuilder<Color>(
      valueListenable: color,
      builder: (context, value, child) => DecoratedBox(
        decoration: BoxDecoration(color: value, shape: BoxShape.circle),
        child: child,
      ),
      child: const SizedBox.square(dimension: 20),
    ),
  );
}

Widget _buildMenu(
  BuildContext context,
  EditableTextState state,
  BrianThemeData theme,
) {
  final strings = WidgetsLocalizations.of(context);
  final labels = {
    ContextMenuButtonType.cut: strings.cutButtonLabel,
    ContextMenuButtonType.copy: strings.copyButtonLabel,
    ContextMenuButtonType.paste: strings.pasteButtonLabel,
    ContextMenuButtonType.selectAll: strings.selectAllButtonLabel,
  };
  final anchors = state.contextMenuAnchors;
  return BrianTheme(
    data: theme,
    child: TextFieldTapRegion(
      child: CustomSingleChildLayout(
        delegate: TextSelectionToolbarLayoutDelegate(
          anchorAbove: anchors.primaryAnchor,
          anchorBelow: anchors.secondaryAnchor ?? anchors.primaryAnchor,
        ),
        child: Container(
          margin: const EdgeInsets.all(BrianSpacing.x2),
          padding: const EdgeInsets.all(BrianSpacing.x1),
          decoration: BoxDecoration(
            color: theme.colors.background.layerDefault,
            border: Border.all(color: theme.colors.stroke.neutralWeak),
            borderRadius: BorderRadius.circular(BrianRadius.r3),
          ),
          child: Wrap(
            children: [
              for (final item in state.contextMenuButtonItems)
                if (labels.containsKey(item.type))
                  BrianButton(
                    variant: BrianButtonVariant.ghost,
                    size: BrianButtonSize.small,
                    onPressed: item.onPressed,
                    child: Text(item.label ?? labels[item.type]!),
                  ),
            ],
          ),
        ),
      ),
    ),
  );
}
