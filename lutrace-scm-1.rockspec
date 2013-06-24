package = "lutrace"
version = "scm-1"
source = {
   url = "https://github.com/hishamhm/lutrace/archive/master.zip",
   dir = "lutrace-master",
}
description = {
   summary = "A tiny module for tracing functions executed by a Lua script.",
   detailed = [[
      luTrace (Lua Micro Trace) is a tiny stand-alone module that prints a
      trace of functions executed by a script (like strace, ltrace, etc.) 
      Loading this module automatically sets a debug hook that activates tracing.
   ]],
   homepage = "https://github.com/hishamhm/lutrace",
   license = "MIT/X11",
}
dependencies = {
   "lua >= 5.1, < 5.3"
}
build = {
   type = "builtin",
   modules = {
      ["lutrace"] = "lutrace.lua",
   }
}
