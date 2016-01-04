// Copyright (c) 2015, George Kormaris. All rights reserved. Use of this source code

// is governed by a BSD-style license that can be found in the LICENSE file.

library getscript.base;

import 'dart:html';
import 'dart:async';

/// Loads a script with DOM access, if not already loaded.
///
/// Returns a `Future<ScriptElement>`
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
  // Running in Javascript
  if (identical(1, 1.0)) {
    String location = uri.toString();
    // Script must be a dart file
    if (location.endsWith('.dart')) {
      location += '.js';
    } else {
      return new ArgumentError('$location does not point to a .dart file');
    }
    // See if it already exists
    ElementList allScripts = querySelectorAll('script');
    for (ScriptElement script in allScripts) {
      // 2) or 3)
      if (script.getAttribute('src') != null) {
        if (script.getAttribute('src').contains(location)) {
          //3)
          if (script.getAttribute('loaded') == 'true') {
            return script;
          } else {
            // 2)
            return await script.onLoad.first.then((e) {
              script.setAttribute('loaded', 'true');
              return script;
            }).catchError((e) {
              return e;
            });
          }
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
    }).catchError((e) {
      return e;
    });
  } else {
    return spawnDomUri(uri, [], '');
  }
}
