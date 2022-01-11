import 'dart:math';

import 'package:flutter_test/flutter_test.dart';
import 'package:google_diff_match_patch/string_history_service.dart';

//TODO: rename to API tests
void main() {
  final service = StringHistoryService();

  group(
    'Insert operations',
    () {
      test('should return added String value', () {
        //GIVEN
        var initialString = 'abc';
        var addedString = ' def';
        var finalString = initialString + addedString;
        //WHEN
        var diffBetweenStrings = service.getDiffBetweenStrings(initialString, finalString);
        var result = service.getListOfInsertedStrings(diffBetweenStrings).first;
        //THEN
        expect(result, addedString);
      });

      test('should return list of inserted strings', () {
        //GIVEN
        var initialString = 'abc';
        var finalString = 'xyz abXc def';
        var expected = ['xyz ', 'X', ' def'];
        //WHEN
        var diffBetweenStrings = service.getDiffBetweenStrings(initialString, finalString);
        var result = service.getListOfInsertedStrings(diffBetweenStrings);
        //THEN
        expect(result, expected);
      });

      test('should return empty list if strings are Equal', () {
        //GIVEN
        var initialString = 'abc def ghi';
        var finalString = 'abc def ghi';
        //WHEN
        var diffBetweenStrings = service.getDiffBetweenStrings(initialString, finalString);
        var result = service.getListOfInsertedStrings(diffBetweenStrings);
        //THEN
        expect(result.isEmpty, true);
      });


    },
  );

  group(
    'Removed operations',
        () {
      test('should return list of removed Strings', () {
        //GIVEN
        var initialString = 'abc def ghi jk';
        var finalString = 'def';
        var expected = ['abc ', ' ghi jk'];
        //WHEN
        var diffBetweenStrings = service.getDiffBetweenStrings(initialString, finalString);
        var result = service.getListOfDeletedStrings(diffBetweenStrings);
        //THEN
        expect(result, expected);
      });

      test('should return initial String when all content removed', () {
        //GIVEN
        var initialString = 'abc def ghi jk';
        var finalString = '';
        //WHEN
        var diffBetweenStrings = service.getDiffBetweenStrings(initialString, finalString);
        var result = service.getListOfDeletedStrings(diffBetweenStrings).first;
        //THEN
        expect(result, initialString);
      });

      test('should return empty list if strings are Equal', () {
        //GIVEN
        var initialString = 'abc def ghi jk';
        var finalString = 'abc def ghi jk';
        //WHEN
        var diffBetweenStrings = service.getDiffBetweenStrings(initialString, finalString);
        var result = service.getListOfDeletedStrings(diffBetweenStrings);
        //THEN
        expect(result.isEmpty, true);
      });
    },
  );

  group(
    'Equal operations',
        () {
      test('should return list of equal strings', () {
        //GIVEN
        var initialString = 'abc def ghi jkl';
        var finalString = 'XXX abc deXXf ghi jkl abc def';
        var expected = ['abc de', 'f ghi jkl'];
        //WHEN
        var diffBetweenStrings = service.getDiffBetweenStrings(initialString, finalString);
        var result = service.getListOfEqualStrings(diffBetweenStrings);
        //THEN
        expect(result, expected);
      });

      test('should return only white chars if all are different', () {
        //GIVEN
        var initialString = 'abc def ghi';
        var finalString = 'jkl mno prs';
        var expected = [' ', ' '];

        //WHEN
        var diffBetweenStrings = service.getDiffBetweenStrings(initialString, finalString);
        var result = service.getListOfEqualStrings(diffBetweenStrings);
        //THEN
        expect(result, expected);
      });

      test('should return only first correct char on reversed String containing uniq chars', () {
        //GIVEN
        var initialString = 'abc def ghi';
        var finalString = 'ihg fed cba';
        var expected = [' ', 'f', ' '];

        //WHEN
        var diffBetweenStrings = service.getDiffBetweenStrings(initialString, finalString);
        var result = service.getListOfEqualStrings(diffBetweenStrings);
        //THEN
        expect(result, expected);
      });

      group(
        'combine operations',
          (){
            test('should recreated initial string from diffs', () {
              //GIVEN
              var initialString = 'abc def ghi';
              var finalString = 'ABC abc deXXXf XYZ GHI';

              //WHEN
              var diffBetweenStrings = service.getDiffBetweenStrings(initialString, finalString);
              var result = service.createStringAfterChanges(before: initialString, diffs: diffBetweenStrings);
              //THEN
              expect(result, finalString);
            });

          }

      );


    },
  );
}
