-- Shell snippets: strict mode, getopts, mktemp/trap, dep guard.
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("sh_strict", fmt([[
#!/usr/bin/env bash
set -euo pipefail
IFS=$'\n\t'

{body}
]], { body = i(1, "# ...") })),

  s("sh_arg_parse", fmt([[
usage() {{
  echo "Usage: $0 [-h] [-v] [-o output]" >&2
  exit "${{1:-0}}"
}}

while getopts ":hvo:" opt; do
  case "$opt" in
    h) usage 0 ;;
    v) verbose=1 ;;
    o) output="$OPTARG" ;;
    \?) echo "Unknown option: -$OPTARG" >&2; usage 1 ;;
    :)  echo "-$OPTARG requires an argument" >&2; usage 1 ;;
  esac
done
shift $((OPTIND - 1))

{body}
]], { body = i(1, "# rest...") })),

  s("sh_temp", fmt([[
tmp=$(mktemp -d -t {prefix}.XXXXXX)
trap 'rm -rf "$tmp"' EXIT INT TERM

{body}
]], { prefix = i(1, "myscript"), body = i(2, "# work in $tmp") })),

  s("sh_check_dep", fmt([[
for cmd in {deps}; do
  command -v "$cmd" >/dev/null 2>&1 || {{ echo "Missing dependency: $cmd" >&2; exit 1; }}
done
]], { deps = i(1, "curl jq") })),

  s("sh_main", fmt([[
main() {{
  {body}
}}

main "$@"
]], { body = i(1, "# entry") })),
}
