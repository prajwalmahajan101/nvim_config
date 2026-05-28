-- Java/Spring snippets: controllers, services, repositories, entities.
local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local fmt = require("luasnip.extras.fmt").fmt

return {
  s("spring_controller", fmt([[
@RestController
@RequestMapping("/{path}")
public class {name} {{
    private final {svcType} {svcVar};

    public {name}({svcType} {svcVar}) {{
        this.{svcVar} = {svcVar};
    }}

    @GetMapping
    public ResponseEntity<{ret}> list() {{
        {body}
    }}
}}
]], {
    path = i(1, "items"),
    name = i(2, "ItemController"),
    svcType = i(3, "ItemService"),
    svcVar = i(4, "itemService"),
    ret = i(5, "List<ItemDto>"),
    body = i(6, "return ResponseEntity.ok(itemService.findAll());"),
  })),

  s("spring_service", fmt([[
@Service
@Transactional
public class {name} {{
    private final {repoType} {repoVar};

    public {name}({repoType} {repoVar}) {{
        this.{repoVar} = {repoVar};
    }}

    {body}
}}
]], {
    name = i(1, "ItemService"),
    repoType = i(2, "ItemRepository"),
    repoVar = i(3, "itemRepository"),
    body = i(4, ""),
  })),

  s("spring_repository", fmt([[
@Repository
public interface {name} extends JpaRepository<{entity}, {idType}> {{
    {body}
}}
]], {
    name = i(1, "ItemRepository"),
    entity = i(2, "Item"),
    idType = i(3, "Long"),
    body = i(4, ""),
  })),

  s("autowired", fmt([[
@Autowired
private {type} {name};
]], { type = i(1, "ItemService"), name = i(2, "itemService") })),

  s("entity", fmt([[
@Entity
@Table(name = "{table}")
public class {name} {{
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    {body}
}}
]], { table = i(1, "items"), name = i(2, "Item"), body = i(3, "") })),
}
