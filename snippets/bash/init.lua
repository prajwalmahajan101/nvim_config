-- Bash inherits sh snippets — same triggers, same expansions.
return dofile(vim.fn.stdpath("config") .. "/snippets/sh/init.lua")
