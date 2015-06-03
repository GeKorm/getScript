# getScript

Dynamic code loading for dart scripts, similar to jQuery's `getScript()`.
The loaded modules have full access to the DOM, but no access to
the code of other modules.

## Usage

A simple usage example:

    import 'package:getScript/getScript.dart';

    main() {
      String name = 'one.dart';
      getScript(Uri.parse(name));
    }
Returns a `Future<ScriptElement>`
If the script is already loaded, getScript() will not attempt to load it
again, so it can be safely used multiple times without triggering superfluous
requests.

## Features and bugs

Currently, a Future is returned to indicate that the module has loaded only
when running in Javascript.
As a workaround during development in Dartium, you can dispatch a custom 
DOM event from the module and listen for it in the main script.

Please file feature requests and bugs at the [issue tracker][tracker].

[tracker]: https://www.github.com/GeKorm/getScript/issues
