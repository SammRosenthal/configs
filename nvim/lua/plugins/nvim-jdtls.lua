return {
  "mfussenegger/nvim-jdtls",
  ft = "java",  -- Lazy load only for Java files
  dependencies = {
    "mfussenegger/nvim-dap",  -- For debugging support
  },
}
