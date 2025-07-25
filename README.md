# Beef Game Utils

This is a collection of some classes from [LibGDX](https://github.com/libgdx/libgdx/) that I personally use in my game, ported from Java to Beef + one original class not from LibGDX. **Not** a port of the entire LibGDX framework.

Because [LibGDX](https://github.com/libgdx/libgdx/) is under the Apache 2.0 license, all files containing code originally from LibGDX are under that license.
The changes from the original LibGDX code include the removal of some functions that I personally don't use and obviously changes in syntax and used std functions to adapt it to Beef.

The Scheduler is not ported from LibGDX, therefore I have put it under MIT.

The in-code documentation of LibGDX is almost the same as the original, except I have changed the @Link segments as Beef's documentation doesn't use @Link, and made some other small tweaks. Besides that, the documentation was not adapted to this library, so some things might mention stuff that's only possible in the actual LibGDX, but I decided to keep the documentation as a lot of it applies to this library too.