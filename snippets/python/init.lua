-- Python snippets: FastAPI, Pydantic, Django, pytest.
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local t = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("fapi_get", fmt([[
@app.get("/{path}", response_model={model})
async def {name}({params}) -> {ret}:
    {body}
]], {
    path = i(1, "items"),
    model = i(2, "ItemOut"),
    name = i(3, "list_items"),
    params = i(4, ""),
    ret = i(5, "ItemOut"),
    body = i(6, "..."),
  })),

  s("fapi_post", fmt([[
@app.post("/{path}", response_model={model}, status_code=201)
async def {name}(payload: {payload}) -> {model}:
    {body}
]], {
    path = i(1, "items"),
    model = i(2, "ItemOut"),
    name = i(3, "create_item"),
    payload = i(4, "ItemIn"),
    body = i(5, "..."),
  })),

  s("pyd", fmt([[
class {name}(BaseModel):
    {field}: {type}
    {rest}
]], {
    name = i(1, "Item"),
    field = i(2, "id"),
    type = i(3, "int"),
    rest = i(4, ""),
  })),

  s("dview", fmt([[
class {name}(View):
    def get(self, request, *args, **kwargs):
        {body}
]], {
    name = i(1, "ItemView"),
    body = i(2, "return JsonResponse({})"),
  })),

  s("pyfix", fmt([[
@pytest.fixture
def {name}({deps}):
    {body}
    return {value}
]], {
    name = i(1, "client"),
    deps = i(2, ""),
    body = i(3, "..."),
    value = i(4, "..."),
  })),
}
