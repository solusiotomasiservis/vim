set nowrap
set sidescroll=1
set sidescrolloff=10
set splitbelow
set splitright
set colorcolumn=88

" guibg is for GUI/Neovim, ctermbg is for Terminal
" highlight ColorColumn guibg=#ff0000 ctermbg=red
" This sets the background to red
" For a 'thinner' look in some terminals, use a dark red
highlight ColorColumn guibg=red ctermbg=grey

" =============================================================================
"   4. PLUGIN CONFIGURATIONS (Logic Only)
" =============================================================================
call plug#begin()
Plug 'tmhedberg/SimpylFold'
Plug 'psf/black', {'tag': 'stable'}
Plug 'Yggdroot/indentLine'
call plug#end()

" --- NERDTree ---
let g:NERDTreeWinPos = "left"

autocmd BufWritePost *.py execute "silent !black " . shellescape(expand("%")) | silent! checktime | redraw!
" augroup python_autoformat
"    autocmd!
"    autocmd BufWritePost *.py execute "silent !black %" | silent! checktime | redraw!
" augroup END

" Unmap Ctrl+v so it stops pasting and starts block selecting
if has('win32') || has('win64')
    " On Windows, sometimes Ctrl+q is used as a fallback for block select
    " This ensures Ctrl+v does what it's supposed to do
    nnoremap <C-v> <C-v>
    vnoremap <C-v> <C-v>
endif

" --- SimpylFold  ---
let g:SimpylFold_fold_docstring = 0
let g:SimpylFold_fold_import = 0
let g:SimpylFold_docstring_preview = 1

" --- SimpylFold  ---

" 1. Use a subtle character for the line (like a vertical bar)
let g:indentLine_char = '│'

" 2. Set the color to match your Monokai theme (Dark Gray)
let g:indentLine_defaultGroup = 'SpecialKey'
let g:indentLine_color_gui = '#464646'
let g:indentLine_color_term = 239

" 3. Prevent the plugin from hiding 'concealed' text (like quotes in JSON)
let g:indentLine_setConceal = 0

" 4. Ensure it works even with the fold column active
let g:indentLine_showFirstIndentLevel = 1
" Show indent guides on empty lines so the 'path' isn't broken
let g:indentLine_concealcursor = 'inc'
let g:indentLine_concealevel = 2

" This ensures the vertical line continues through blank spaces
let g:indentLine_showFirstIndentLevel = 1



" --- Ripgrep Configuration ---

" Define the base command with all ignore rules
" --vimgrep: Output format for Vim
" --smart-case: Smart case search
" --hidden: Search hidden files (dotfiles)
" --glob: EXPLICITLY IGNORE these patterns
let g:rg_command = 'rg --vimgrep --no-heading --smart-case --hidden --follow ' .
    \ '--glob "!.git/*" ' .
    \ '--glob "!__pycache__/*" ' .
    \ '--glob "!*.pyc" ' .
    \ '--glob "!node_modules/*"'

" 1. Apply to 'ackprg' (For searching text inside files)
let g:ackprg = g:rg_command

" 2. Apply to 'grepprg' (For standard Vim :grep command)
let &grepprg = g:rg_command

" 3. Apply to FZF (For Ctrl+P file finding)
" FZF needs a slightly different format (files-only mode)
let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow ' .
    \ '--glob "!.git/*" ' .
    \ '--glob "!__pycache__/*" ' .
    \ '--glob "!*.pyc" ' .
    \ '--glob "!node_modules/*"'

" Update the FZF :Files command to use this
command! -bang -nargs=? -complete=dir Files
    \ call fzf#vim#files(<q-args>, {'source': $FZF_DEFAULT_COMMAND, 'options': '--tiebreak=index'}, <bang>0)


" =============================================================================
"   5. KEYBOARD SHORTCUTS CHEAT SHEET
"   (Everything you press is defined here)
" =============================================================================

" --- The Leader Key ---
let mapleader = ","
let maplocalleader = "\\"

" --- 1. General Editing ---
" Escape insert mode quickly
inoremap jk <Esc>
" Use ; for : (saves shift key)
nnoremap ; :
" Save file
nnoremap <leader>w :w<CR>
" Sudo write
cnoremap w!! w !sudo tee % >/dev/null
" Stop highlighting search results
map <leader><space> :noh<cr>
" Prevent window from popping up when pressing q:
map q: :q

" --- 2. Navigation ---
" Go to Start of line
noremap H ^
" Go to End of line
noremap L $
" Move between split windows (Ctrl + h/j/k/l)
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>
" Resize vertical split
nnoremap <Leader>d :vertical resize

" --- 3. Text Manipulation ---
" Yank to end of line
noremap Y y$
" Delete to end of line
nnoremap D d$
" Indent/Dedent visually selected text (keeps selection)
vnoremap < <gv
vnoremap > >gv
" Move line up/down (Alt + j/k) - Optional, very useful
" nnoremap <M-j> :m .+1<CR>==
" nnoremap <M-k> :m .-2<CR>==
" inoremap <M-j> <Esc>:m .+1<CR>==gi
" inoremap <M-k> <Esc>:m .-2<CR>==gi
" vnoremap <M-j> :m '>+1<CR>gv=gv
" vnoremap <M-k> :m '<-2<CR>gv=gv

" --- 5. Plugin Shortcuts ---


" [ Tabs ]
" Next Tab
" map tn :tabn<CR>
" map tp :tabp<CR>
" Previous Tab
" map tt :tabnew
" Duplicate into new Tab
" map ts :tab split<CR>

" [ Custom ] Split line at cursor (Shift + s)
" Acts like pressing Enter in normal mode to break the line
nnoremap S i<CR><Esc>

" " Force-clear any existing Ctrl-v mapping
" unmap <C-v>
" iunmap <C-v>

" Explicitly tell Vim to use Ctrl-v for Visual Block
nnoremap vv <C-v>
nmap <space>, :Buffers<CR>

" --- Folding Settings ---
set foldmethod=indent   " Fold based on indention levels
set foldcolumn=2
set foldlevel=99        " Start with all folds open (change to 0 to start closed)
set foldexpr=SimpylFold(v:lnum)
set foldmethod=syntax

" 5. Fix E216 Error
" Removed the invalid 'BufWinPost' and replaced with proper events
"  "autocmd BufWinEnter *.py normal! zx
"  autocmd BufEnter *.py setlocal foldmethod=syntax
"  autocmd FileType xml,html setlocal foldmethod=syntax


" =============================================================================
" FOLD COLOR CUSTOMIZATION
" =============================================================================

" 1. Change the look of the collapsed line (The 'Folded' group)
" guibg: Background color (Darker gray)
" guifg: Text color (Bright orange/yellow to match Monokai)
highlight Folded guibg=#3E3D32 guifg=#E6DB74 ctermbg=237 ctermfg=229 gui=italic

" 2. Change the look of the sidebar gutter (The 'FoldColumn' group)
" This makes the folding 'bars' easier to see on the left
highlight FoldColumn guibg=NONE guifg=#66D9EF ctermbg=NONE ctermfg=81
" =============================================================================
" FLAKE8 & NEOMAKE CONFIGURATION
" =============================================================================

" 1. Set Flake8 as the primary linter for Python
let g:neomake_python_enabled_makers = ['flake8']

" 2. Point Flake8 to your project-specific config if it's in a subfolder
" This tells the maker to look for a .flake8 file in the current directory
let g:neomake_python_flake8_maker = {
    \ 'args': ['--config=.flake8'],
    \ }

" 3. Run Neomake automatically on save 
autocmd! BufWritePost *.py Neomake
