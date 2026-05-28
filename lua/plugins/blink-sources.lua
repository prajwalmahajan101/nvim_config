-- Custom blink.cmp sources: dictionary (English), emoji (`:smile:`), git (#issue / @user).
-- Activated per-filetype by `sources.per_filetype` in completion.lua. The
-- plugin specs below declare the source modules; completion.lua references
-- them by name in `providers`.

return {
  -- Dictionary completion (markdown/text/gitcommit)
  {
    "saghen/blink.cmp",
    dependencies = {
      {
        "Kaiser-Yang/blink-cmp-dictionary",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
      {
        "moyiz/blink-emoji.nvim",
      },
      {
        "Kaiser-Yang/blink-cmp-git",
        dependencies = { "nvim-lua/plenary.nvim" },
      },
    },
    opts = {
      sources = {
        providers = {
          dictionary = {
            name = "Dict",
            module = "blink-cmp-dictionary",
            min_keyword_length = 3,
            score_offset = -2, -- below lsp/snippets
            opts = {
              dictionary_directories = function()
                local dirs = {}
                for _, d in ipairs({ "/usr/share/dict", "/usr/share/words" }) do
                  if vim.uv.fs_stat(d) then table.insert(dirs, d) end
                end
                return dirs
              end,
              get_command = "rg", -- fast lookup
              get_command_args = function(_, kw)
                return { "--color=never", "--no-line-number", "-i", "^" .. kw }
              end,
            },
          },
          emoji = {
            name = "Emoji",
            module = "blink-emoji",
            score_offset = 15, -- bump above buffer/dictionary when user types `:`
            opts = { insert = true, ignored_filetypes = { "" } },
          },
          git = {
            name = "Git",
            module = "blink-cmp-git",
            opts = {
              git_centers = {
                github = {
                  -- Uses `gh` CLI if authenticated; gracefully no-ops otherwise.
                  issue = { get_token = function() return nil end },
                },
              },
            },
          },
        },
      },
    },
  },
}
