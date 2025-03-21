# clipper.nvim
**clipper.nvim** is the Neovim plugin to enhance Neovim's clipboard functionality.
clipper keeps track of **your yank history** and allowing you to access it through **Harpoon-like UI**.

clipper.nvim keeps a history of your past yanks, allowing you to easily pick and reuse previously copied text through an intuitive UI.

You don’t need to do anything special—just yank as usual, and clipper.nvim will automatically record your yank history.

To access your past yanks, simply open clipper.nvim’s dialog by running the clipper command. 
Navigate through your history and press Enter on the item you want to use. This will register it in both Neovim’s " register and the 0 register, so you can paste it instantly with p.

It feels like having an infinite clipboard at your fingertips. Give it a try and see the magic for yourself! 🚀



## Demo

https://github.com/user-attachments/assets/0152b099-9eea-4774-9c55-f8c28b5950f5



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
{
  "TlexCypher/clipper.nvim",
  lazy = false, -- lazy should not be true.
  dependencies = { -- this is dependency for ui.
      "nvim-lua/plenary.nvim"
  },
  config = function()
    require("clipper").setup({
        -- available options are here.
        win_width = 80,
        win_height = 20,
        -- see plenary.nvim documentation.
        borderchars = {"******", "#########"}
        -- default is true.
        -- If yank_only is true,copied contents by pressing d, c key etc are not registered.
        yank_only = false, 
        callback = function() do
        -- your desire when hit the enter on the plenary.nvim based dialog.
        end
    })
  end
}
```

## Contribution
Any type of contribution is welcome!
I'm looking forward to recieve PR, comments!

