import 'dart:io';

// doc/를 유일한 원본으로 유지하고 Flutter 자산에는 평탄화한 사본을 만듭니다.
void main() {
  final root = File.fromUri(Platform.script).parent.parent;
  final source = Directory('${root.path}/doc');
  final target = Directory('${root.path}/website/assets/guides');
  target.createSync(recursive: true);
  for (final file in target.listSync().whereType<File>()) {
    if (file.path.endsWith('.md')) file.deleteSync();
  }
  var count = 0;
  for (final folder in [
    'foundations',
    'theming',
    'components',
    'contributing',
  ]) {
    for (final file in Directory(
      '${source.path}/$folder',
    ).listSync(recursive: true, followLinks: false).whereType<File>()) {
      if (!file.path.endsWith('.md')) continue;
      final relative = file.path.substring(root.path.length + 1);
      final name = relative.replaceAll(Platform.pathSeparator, '__');
      file.copySync('${target.path}/$name');
      count++;
    }
  }
  stdout.writeln('웹 문서 자산 $count개를 동기화했습니다.');
}
