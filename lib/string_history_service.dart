import 'package:diff_match_patch/diff_match_patch.dart';

class StringHistoryService {
  List<Diff> getDiffBetweenStrings(String before, String after) => diff(before, after);

  List<String> getListOfInsertedStrings(List<Diff> diffs) =>
      diffs.where((diff) => diff.operation == DIFF_INSERT).map((e) => e.text).toList();

  List<String> getListOfEqualStrings(List<Diff> diffs) =>
      diffs.where((diff) => diff.operation == DIFF_EQUAL).map((e) => e.text).toList();

  List<String> getListOfDeletedStrings(List<Diff> diffs) =>
      diffs.where((diff) => diff.operation == DIFF_DELETE).map((e) => e.text).toList();

  String createStringAfterChanges({required String before, required List<Diff> diffs}) {
    final patches = patchMake(diffs);
    final withChanges = patchApply(patches, before);
    return withChanges.first;
  }

}
