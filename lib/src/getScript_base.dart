// Copyright (c) 2015, George Kormaris. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library getScript.base;

import 'dart:html';
import 'dart:async';

/// Loads a script with DOM access, if not already loaded.
///
/// Usage:
///      String name = 'one.dart';
///      getScript(Uri.parse(name));
///

/* Three possibilities when loading a script:
   1) It doesn't exist in the DOM.
   2) It exists in the DOM, but hasn't loaded.
   3) It exists in the DOM and has loaded.
 */
Future getScript(Uri uri) async {
  if (identical(1, 1.0)) {
    // Running in Javascript
    String location = uri.toString() + '.js';
    var allScripts = querySelectorAll('script');
    for (var script in allScripts) {
      // 2) or 3)
      if (script.getAttribute('src').contains(location)) {
        //3)
        if (script.getAttribute('loaded') == 'true') {
          return script;
        } else {
          // 2)
          return await script.onLoad.first.then((e) {
            script.setAttribute('loaded', 'true');
            return script;
          });
        }
      }
    }
    var script = new ScriptElement()
      ..setAttribute('src', location)
      ..setAttribute('type', 'text/javascript')
      ..setAttribute('loaded', 'false');
    document.body.append(script);
    return await script.onLoad.first.then((e) {
      script.setAttribute('loaded', 'true');
      return script;
    });
  } else {
    return spawnDomUri(uri, [], '');
  }
}

onError(Event e) {
  print("error: $e");
}