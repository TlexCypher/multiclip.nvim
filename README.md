# clipper.nvim
**clipper.nvim** is the Neovim plugin to enhance Neovim's clipboard functionality.
Clipper keeps track of **your yank history** and allowing you to access it through **Harpoon-like UI**.

## Demo
Comming soon...

## Installation and dependencies
You can install **clipper.nvim** with major package manager, for instance Lazy.nvim.
#### Lazy.nvim ####
```lua
{
  "TlexCypher/clipper.nvim",
  lazy = false, -- lazy should not be true.
  dependencies = { -- this is dependency for ui.
      "nvim-lua/plenary.nvim"
  },
  config = function()
    require("clipper").setup()
  end
}

```
## Configuration
Basically, no more configuration is necessary.
But you can change window size, and callback function when you hit enter on the window.
Below is a brief example.

```lua

```

## Contribution
Any type of contribution is welcome!
I'm looking forward to recieve PR, comments!

