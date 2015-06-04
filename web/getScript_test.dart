// Copyright (c) 2015, George Kormaris. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:html';
import 'dart:async';
import 'package:getScript/getScript.dart';

// TODO: Refactor into a class to avoid all this repeating code.

int passed = 0,
    failed = 0;
DivElement elem = querySelector('#test');

main() async {
  //Run the tests in Javascript
  elem.text = 'main loaded';
  await initTests();
  if (passed == 0 && failed == 0) {
    print('Incorrect test setup.');
  } else if (passed == 0 && failed != 0) {
    print('All tests failed.');
  } else if (passed != 0 && failed == 0) {
    print('All tests passed.');
  } else {
    print('Tests passed: $passed,\nTests failed: $failed.');
  }
}

initTests() async {
  await testReturnedFutureLoaded();
  await testDomAccess();
  await testReturnedFutureExists();
  await testReturnedFutureLoaded();
  await testDomAccess();
  await testReturnedFutureExists();
  await testErrorNotDartScript();
}

testDomAccess() async {
  String name = 'Test DOM access';
  await getScript(Uri.parse('one_test.dart'));
  print(expect(elem.text == 'one loaded', name));
  //return await getScript(Uri.parse('one_test.dart'));
}

testReturnedFutureExists() async {
  String name = 'Test script exists';
  var result = getScript(Uri.parse('one_test.dart'));
  //print(result.toString());
  //print((await result).toString());
  //return await result;
  print(expect((await result) is ScriptElement, name));
  print(expect(!((await result) is Future), name));
}

testReturnedFutureLoaded() async {
  String name = 'Test script loaded future';
  var result = getScript(Uri.parse('one_test.dart'));
  //print(result.toString());
  //print((await result).toString());
  //return await result;
  print(expect((await result) is ScriptElement, name));
  print(expect(!((await result) is Future), name));
}

testErrorNotDartScript() async {
  String name = 'Test script not dart file error';
  var result = getScript(Uri.parse('two_test.dart.e.js'));
  //print(result.toString());
  //print((await result).toString());
  //return await result;
  print(expect((await result) is ArgumentError, name));
  print(expect(
      (await result).message.contains('does not point to a .dart file'), name));
  print(expect(!((await result) is Future), name));
}

String expect(bool testPassed, String name) {
  if (testPassed) {
    passed++;
    return ('Test: $name - PASS');
  } else {
    failed++;
    return ('Test: $name - FAIL');
  }
}
