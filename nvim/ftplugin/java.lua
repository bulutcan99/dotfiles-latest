local jdtls = require("jdtls")

local root_dir = vim.fs.root(0, { "build.gradle", "build.gradle.kts", "pom.xml", ".git" })
if root_dir == nil then
  return
end

local cmd = vim.fn.exepath("jdtls")
if cmd == "" then
  cmd = vim.fn.stdpath("data") .. "/mason/bin/jdtls"
end

jdtls.start_or_attach({
  name = "jdtls",
  cmd = { cmd },
  root_dir = root_dir,
  init_options = {
    bundles = {},
  },
  settings = {
    java = {},
  },
})
