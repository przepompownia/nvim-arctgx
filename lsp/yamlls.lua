return {
  settings = {
    yaml = {
      schemaStore = {
        enable = false,
        url = '',
      },
      schemas = require('schemastore').yaml.schemas {
        extra = {
          -- {
          --   description = 'Symfony YAML configs',
          --   fileMatch = {'config/packages/messenger.yaml'},
          --   name = 'symfony-1.0.json',
          --   url = os.getenv('HOME') .. '/tmp/symfony-1.0.json',
          -- },
        },
      },
    },
  },
}
