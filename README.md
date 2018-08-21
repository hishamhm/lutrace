lutrace
=======

luTrace (Lua Micro Trace) is a tiny stand-alone module that prints a trace of
functions executed by a script (like strace, ltrace, etc.)

by Hisham Muhammad - http://hisham.hm/

License: MIT/X11

Usage: LUTRACE_FILTER=my_module LUTRACE_TIME=1 lua -llutrace your_script.lua

## Environment variables

* LUTRACE_FILTER - can be used to provide a string pattern to act as a filter
to source code filenames, so you can "grep" only for modules or packages you're
interested in.
* LUTRACE_EXCLUDE - the reverse of LUTRACE_FILTER: a string pattern used to
exclude lines from the trace
* LUTRACE_ON - if set to `0`, disables tracing
* LUTRACE_TIME - if set to any value, adds timestamps to the tracing output

Loading this module automatically sets a debug hook that 
activates tracing. This module exports no functions.

For more advanced tracing and coverage analysis, see also:

* LuaTrace: https://github.com/geoffleyland/luatrace
* LuaCov: http://keplerproject.github.io/luacov/

