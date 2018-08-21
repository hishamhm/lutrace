--- luTrace (Lua Micro Trace) is a tiny stand-alone module that prints
-- a trace of functions executed by a script (like strace, ltrace, etc.)
--
-- luTrace 0.1
-- by Hisham Muhammad - http://hisham.hm/
-- License: MIT/X11
--
-- Usage: LUTRACE_FILTER=my_module lua -llutrace your_script.lua
--
-- The environment variable LUTRACE_FILTER can be used to provide a
-- string to act as a filter to source code filenames, so you can
-- "grep" only for modules or packages you're interested in.
--
-- Loading this module automatically sets a debug hook that 
-- activates tracing. This module exports no functions.
--
-- For more advanced tracing and coverage analysis, see also:
--
-- * LuaTrace: https://github.com/geoffleyland/luatrace
-- * LuaCov: http://keplerproject.github.io/luacov/

local function turn_on()
   local var = os.getenv("LUTRACE_ON")
   if not var then
      return true
   elseif var == "0" then
      return false
   else
      return true
   end
end

local lutrace = {
   opt = {
      filter = os.getenv("LUTRACE_FILTER"),
      exclude = os.getenv("LUTRACE_EXCLUDE"),
      time = os.getenv("LUTRACE_TIME"),
      dirs = tonumber(os.getenv("LUTRACE_DIRS") or 3),
      on = turn_on(),
   }
}

local function stars(levels)
   if levels < 5 then
      return ("*"):rep(levels)
   elseif levels < 10 then
      return ("*"):rep(levels-1)..tostring(levels)
   elseif levels < 100 then
      return ("*"):rep(levels-2)..tostring(levels)
   else
      return ("*"):rep(10).."...*"..tostring(levels)
   end
end

local function split(s, sep)
   local pieces = {}
   for w in s:gmatch("([^"..sep.."]*)"..sep.."*") do table.insert(pieces, w) end
   return pieces
end

local function where(info, dirs)
   if not info then
      return "?"
   end
   if not info.short_src then
      return "?"
   end
   local parts = split(info.short_src, "/")
   local path
   if #parts > dirs+1 then
      path = ".../"..table.concat(parts, "/", #parts-dirs, #parts-1)
   else
      path = info.short_src
   end
   return path..":"..info.currentline..":"
end

debug.sethook(function()
   if not lutrace.opt.on then
      return
   end
   local levels = 2
   while debug.getinfo(levels, "") do
      levels = levels + 1
   end
   local caller = debug.getinfo(3, "Sl")
   local info = debug.getinfo(2, "nSu")
   if lutrace.opt.filter and not info.source:match(lutrace.opt.filter) then return end
   if lutrace.opt.exclude and info.source:match(lutrace.opt.exclude) then return end
   local args = {}
   for i = 1, (info.nparams or 0) do
      local k, v = debug.getlocal(2, i)
      if type(v) == "string" then v="\""..v.."\"" end
      table.insert(args, k.."="..tostring(v))
   end
   if info.isvararg then
      local i = -1
      while true do
         local k,v = debug.getlocal(2, i)
         if type(v) == "string" then v="\""..v.."\"" end
         
         if not k then break end
         table.insert(args, tostring(v))
         i = i - 1
      end
   end
   local dirs = where(caller, lutrace.opt.dirs)
   if lutrace.opt.time then
      io.stderr:write(tostring(os.time()).." ")
   end
   io.stderr:write(stars(levels).." "..(dirs and dirs.."\t" or "")..(info.name or "?").."("..table.concat(args, ", ")..")\n")
end, "c")

return {}

