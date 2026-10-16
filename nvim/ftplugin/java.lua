-- Find the root directory of the Java project
-- Strategy: Look for Maven parent pom.xml with <modules> tag first
-- This handles cases where .git is at a different level than Maven project

local function find_maven_parent(start_path)
  local current = start_path
  local last_pom_dir = nil

  while current ~= "/" and current ~= "." do
    local pom_path = current .. "/pom.xml"
    if vim.fn.filereadable(pom_path) == 1 then
      last_pom_dir = current
      -- Check if this pom has <modules> tag (parent/aggregator pom)
      local pom_content = vim.fn.readfile(pom_path)
      for _, line in ipairs(pom_content) do
        if line:match("<modules>") then
          return current -- Found parent pom with modules
        end
      end
    end
    current = vim.fn.fnamemodify(current, ":h")
  end

  -- If no parent pom with modules found, return the last pom.xml we found
  return last_pom_dir
end

local start_path = vim.fn.expand("%:p:h")
local root_dir = find_maven_parent(start_path)

-- Fall back to other markers if no Maven project found
if not root_dir then
  -- Try using jdtls.setup if available
  local ok, jdtls_setup = pcall(require, "jdtls.setup")
  if ok then
    root_dir = jdtls_setup.find_root({ ".git", "mvnw", "gradlew", "build.gradle" })
  else
    -- Manual fallback: search upward for .git
    local current = start_path
    while current ~= "/" and current ~= "." do
      if vim.fn.isdirectory(current .. "/.git") == 1 then
        root_dir = current
        break
      end
      current = vim.fn.fnamemodify(current, ":h")
    end
  end
end

-- If no root found, use current buffer's directory
if not root_dir then
  vim.notify("JDTLS: No project root found (no pom.xml, .git, mvnw, or gradlew)", vim.log.levels.WARN)
  root_dir = vim.fn.expand("%:p:h")
end

-- Workspace directory: unique per project to avoid conflicts
local project_name = vim.fn.fnamemodify(root_dir, ":p:h:t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspace/" .. project_name

-- Create workspace directory if it doesn't exist
vim.fn.mkdir(workspace_dir, "p")

-- JDTLS installation paths (Homebrew)
local jdtls_path = "/opt/homebrew/opt/jdtls/libexec"
local java_debug_path = "/opt/homebrew/opt/java-debug/libexec"

-- OS-specific config directory
local config_dir = jdtls_path .. "/config_mac_arm"
if vim.fn.has("linux") == 1 then
  if vim.fn.system("uname -m"):find("aarch64") or vim.fn.system("uname -m"):find("arm64") then
    config_dir = jdtls_path .. "/config_linux_arm"
  else
    config_dir = jdtls_path .. "/config_linux"
  end
elseif vim.fn.has("win32") == 1 then
  config_dir = jdtls_path .. "/config_win"
end

-- JDTLS configuration
local config = {
  -- The name of the language server
  name = "jdtls",

  -- Command to start JDTLS
  cmd = {
    "java",
    "-Declipse.application=org.eclipse.jdt.ls.core.id1",
    "-Dosgi.bundles.defaultStartLevel=4",
    "-Declipse.product=org.eclipse.jdt.ls.core.product",
    "-Dlog.protocol=true",
    "-Dlog.level=ALL",
    "-Xmx1g",
    "--add-modules=ALL-SYSTEM",
    "--add-opens", "java.base/java.util=ALL-UNNAMED",
    "--add-opens", "java.base/java.lang=ALL-UNNAMED",
    "-jar", vim.fn.glob(jdtls_path .. "/plugins/org.eclipse.equinox.launcher_*.jar"),
    "-configuration", config_dir,
    "-data", workspace_dir,
  },

  -- Root directory for this project
  root_dir = root_dir,

  -- LSP settings
  settings = {
    java = {
      -- Eclipse settings
      eclipse = {
        downloadSources = true,
      },
      -- Maven settings
      configuration = {
        updateBuildConfiguration = "automatic",  -- Auto-import when pom.xml changes
      },
      -- Maven execution
      maven = {
        downloadSources = true,
      },
      -- Compiler settings
      implementationsCodeLens = {
        enabled = true,
      },
      referencesCodeLens = {
        enabled = true,
      },
      references = {
        includeDecompiledSources = true,
      },
      -- Formatting
      format = {
        enabled = true,  -- Use JDTLS built-in formatting
      },
      -- Completion settings
      completion = {
        favoriteStaticMembers = {
          "org.hamcrest.MatcherAssert.assertThat",
          "org.hamcrest.Matchers.*",
          "org.hamcrest.CoreMatchers.*",
          "org.junit.jupiter.api.Assertions.*",
          "java.util.Objects.requireNonNull",
          "java.util.Objects.requireNonNullElse",
          "org.mockito.Mockito.*",
        },
        importOrder = {
          "java",
          "javax",
          "com",
          "org",
        },
      },
      -- Spring Boot specific
      signatureHelp = { enabled = true },
      contentProvider = { preferred = "fernflower" },
      sources = {
        organizeImports = {
          starThreshold = 9999,
          staticStarThreshold = 9999,
        },
      },
    },
  },

  -- Initialize options
  init_options = {
    bundles = {},  -- Debug adapter bundles (optional)
  },

  -- LSP handlers (same as other LSP servers in your config)
  on_attach = function(client, bufnr)
    -- Keymaps are set globally in lua/sam/lsp.lua
    -- Additional Java-specific keymaps below
  end,

  -- Capabilities (completion support)
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
}

-- Add debug adapter bundles if java-debug is installed
local java_debug_jar = vim.fn.glob(java_debug_path .. "/com.microsoft.java.debug.plugin-*.jar")
if java_debug_jar ~= "" then
  config.init_options.bundles = { java_debug_jar }
end

-- Start JDTLS
local ok, jdtls = pcall(require, "jdtls")
if not ok then
  vim.notify("JDTLS: nvim-jdtls plugin not loaded! Make sure it's installed via :Lazy sync", vim.log.levels.ERROR)
  return
end

jdtls.start_or_attach(config)

-- Java-specific keymaps (buffer-local)
-- In ftplugin, buffer 0 refers to current buffer
local opts = { buffer = 0, noremap = true, silent = true }

-- Run Spring Boot application
vim.keymap.set("n", "<leader>jr", function()
  vim.cmd("!mvn spring-boot:run")
end, vim.tbl_extend("force", opts, { desc = "Run Spring Boot" }))

-- Run tests
vim.keymap.set("n", "<leader>jt", function()
  vim.cmd("!mvn test")
end, vim.tbl_extend("force", opts, { desc = "Run Maven tests" }))

-- Build project
vim.keymap.set("n", "<leader>jb", function()
  vim.cmd("!mvn clean install")
end, vim.tbl_extend("force", opts, { desc = "Maven build" }))

-- Organize imports
vim.keymap.set("n", "<leader>jo", function()
  require("jdtls").organize_imports()
end, vim.tbl_extend("force", opts, { desc = "Organize imports" }))

-- Extract variable
vim.keymap.set("v", "<leader>jv", function()
  require("jdtls").extract_variable()
end, vim.tbl_extend("force", opts, { desc = "Extract variable" }))

-- Extract method
vim.keymap.set("v", "<leader>jm", function()
  require("jdtls").extract_method()
end, vim.tbl_extend("force", opts, { desc = "Extract method" }))

-- Update project configuration (force reload pom.xml)
vim.keymap.set("n", "<leader>ju", function()
  require("jdtls").update_project_config()
end, vim.tbl_extend("force", opts, { desc = "Update project config" }))
