-- Makefile snippets: phony targets, variables, common test/build/run patterns.
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("mk_target", fmt([[
{name}: {deps}
	{body}
]], { name = i(1, "target"), deps = i(2, ""), body = i(3, "@echo doing it") })),

  s("mk_phony", fmt([[
.PHONY: {targets}

{targets}: {deps}
	{body}
]], { targets = i(1, "test build"), deps = i(2, ""), body = i(3, "@echo $@") })),

  s("mk_var", fmt([[
{name} := {value}
]], { name = i(1, "BIN"), value = i(2, "./bin/app") })),

  s("mk_test_target", fmt([[
.PHONY: test
test:
	{cmd}
]], { cmd = i(1, "go test ./...") })),

  s("mk_help", fmt([[
.PHONY: help
.DEFAULT_GOAL := help

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | \
		awk 'BEGIN {{FS = ":.*?## "}}; {{printf "  \033[36m%-20s\033[0m %s\n", $$1, $$2}}'
]], {})),
}
