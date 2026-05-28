-- Spring Boot LSP attachment for application.yml / .properties + bean nav.
-- vscode-spring-boot-tools is installed via Mason (langs.lua); it ships a
-- self-contained spring-boot-language-server-*-exec.jar that we launch
-- with `java -jar`. JAVA_HOME is resolved by java.lua at load time.

local function spring_boot_jar()
  local mason_pkg = vim.fn.stdpath("data") .. "/mason/packages"
  local glob = mason_pkg .. "/vscode-spring-boot-tools/extension/language-server/spring-boot-language-server-*-exec.jar"
  local matches = vim.fn.glob(glob, true, true)
  if type(matches) == "table" and #matches > 0 then return matches[1] end
  return nil
end

local function spring_boot_cmd()
  local jar = spring_boot_jar()
  if not jar then return nil end
  local java = (vim.env.JAVA_HOME and vim.env.JAVA_HOME ~= "")
    and (vim.env.JAVA_HOME .. "/bin/java")
    or "java"
  return { java, "-jar", jar }
end

return {
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      local cmd = spring_boot_cmd()
      if not cmd then return opts end -- Mason hasn't installed it yet; skip.
      opts.servers = opts.servers or {}
      opts.servers.spring_boot_ls = {
        cmd = cmd,
        filetypes = { "java", "yaml", "properties", "jproperties" },
        root_markers = { "pom.xml", "build.gradle", "build.gradle.kts", "settings.gradle", ".git" },
        init_options = { workspaceFolders = nil },
        single_file_support = false,
      }
      return opts
    end,
  },
}
