-- Markdown snippets: doc scaffolding for API/docs work.
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("apidoc", fmt([[
## {method} `/{path}`

**Description:** {desc}

### Request

```json
{req}
```

### Response

```json
{resp}
```
]], {
    method = i(1, "GET"),
    path = i(2, "items"),
    desc = i(3, "..."),
    req = i(4, "{}"),
    resp = i(5, "{}"),
  })),

  s("mermaid", fmt([[
```mermaid
{kind}
    {body}
```
]], { kind = i(1, "flowchart TD"), body = i(2, "A --> B") })),

  s("plantuml", fmt([[
```plantuml
@startuml
{body}
@enduml
```
]], { body = i(1, "Alice -> Bob: hello") })),
}
