import 'package:brian_ui/brian_ui.dart';
import 'package:brian_ui_website/badge_examples.dart';
import 'package:brian_ui_website/site_widgets.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

import 'website_test.dart' show openPage;

void main() {
  for (final width in [375.0, 1280.0]) {
    testWidgets('Badge 페이지의 사용 사례와 코드를 너비 $width에서 표시한다', (tester) async {
      await openPage(tester, '/components/badge', size: Size(width, 1000));
      expect(find.byType(BadgeExamples), findsOneWidget);
      expect(find.text('Playground'), findsNothing);
      for (final heading in [
        '콘텐츠 분류',
        '혜택과 부가 정보',
        '처리 상태',
        '상세 정보의 테두리 배지',
        '주요 안내 강조',
        '긴 라벨과 너비 제한',
        '크기와 스타일 비교',
      ]) {
        expect(find.text(heading), findsOneWidget);
      }
      final examples = find.byType(BadgeExamples);
      expect(
        find.descendant(of: examples, matching: find.byType(CodeExample)),
        findsNWidgets(7),
      );
      final longBadge = find.widgetWithText(BrianBadge, '관리자의 최종 승인을 기다리는 중');
      expect(tester.getSize(longBadge).width, 140);
      final paragraph = tester.renderObject<RenderParagraph>(
        find.descendant(of: longBadge, matching: find.byType(RichText)),
      );
      expect(paragraph.didExceedMaxLines, isTrue);
      final badges = tester.widgetList<BrianBadge>(find.byType(BrianBadge));
      for (final size in BrianBadgeSize.values) {
        for (final tone in BrianBadgeTone.values) {
          for (final variant in BrianBadgeVariant.values) {
            expect(
              badges.any(
                (b) => b.size == size && b.tone == tone && b.variant == variant,
              ),
              isTrue,
            );
          }
        }
      }
      expect(tester.takeException(), isNull);
    });
  }
}
