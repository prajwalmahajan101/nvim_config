-- Go snippets: http handler, table tests, errgroup.
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("hhandler", fmt([[
func {name}(w http.ResponseWriter, r *http.Request) {{
    ctx := r.Context()
    {body}
}}
]], { name = i(1, "handleItems"), body = i(2, "_ = ctx") })),

  s("ttest", fmt([[
func Test{name}(t *testing.T) {{
    tests := []struct {{
        name string
        in   {inType}
        want {wantType}
    }}{{
        {{"{case1}", {in1}, {want1}}},
    }}
    for _, tt := range tests {{
        t.Run(tt.name, func(t *testing.T) {{
            got := {call}
            if got != tt.want {{
                t.Errorf("got %v, want %v", got, tt.want)
            }}
        }})
    }}
}}
]], {
    name = i(1, "Sum"),
    inType = i(2, "int"),
    wantType = i(3, "int"),
    case1 = i(4, "zero"),
    in1 = i(5, "0"),
    want1 = i(6, "0"),
    call = i(7, "Sum(tt.in)"),
  })),

  s("errg", fmt([[
g, ctx := errgroup.WithContext(ctx)
g.Go(func() error {{
    {body}
    return nil
}})
if err := g.Wait(); err != nil {{
    return err
}}
]], { body = i(1, "// work") })),
}
