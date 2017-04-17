" Environment {

    " Identify platform {
        silent function! OSX()
            return has('macunix')
        endfunction
        silent function! LINUX()
            return has('unix') && !has('macunix') && !has('win32unix')
        endfunction
        silent function! WINDOWS()
            return  (has('win32') || has('win64'))
        endfunction
    " }

    " Basics {
        set nocompatible        " Must be first line
        if !WINDOWS()
            set shell=/bin/sh
        endif
    " }

    " Windows Compatible {
        " On Windows, also use '.vim' instead of 'vimfiles'; this makes synchronization
        " across (heterogeneous) systems easier.
        if WINDOWS()
          set runtimepath=$HOME/.vim,$VIM/vimfiles,$VIMRUNTIME,$VIM/vimfiles/after,$HOME/.vim/after
        endif
    " }

    " Arrow Key Fix {
        if &term[:4] == "xterm" || &term[:5] == 'screen' || &term[:3] == 'rxvt'
            inoremap <silent> <C-[>OC <RIGHT>
        endif
    " }

" }

" Use before config if available {
    if filereadable(expand("~/.vimrc.before"))
        source ~/.vimrc.before
    endif
" }

" Use bundles config {
    if filereadable(expand("~/.vimrc.bundles"))
        source ~/.vimrc.bundles
    endif
" }

" General {

    set background=dark         " Assume a dark background

    filetype plugin indent on   " Automatically detect file types.
    syntax on                   " Syntax highlighting
    set mouse=a                 " Automatically enable mouse usage
    set mousehide               " Hide the mouse cursor while typing
    scriptencoding utf-8

    if has('clipboard')
        if has('unnamedplus')  " When possible use + register for copy-paste
            set clipboard=unnamed,unnamedplus
        else         " On mac and Windows, use * register for copy-paste
            set clipboard=unnamed
        endif
    endif

    " Most prefer to automatically switch to the current file directory when
    " a new buffer is opened; to prevent this behavior, add the following to
    " your .vimrc.before.local file:
    "   let g:vim_no_autochdir = 1
    if !exists('g:vim_no_autochdir')
        autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
        " Always switch to the current file directory
    endif

    "set autowrite                       " Automatically write a file when leaving a modified buffer
    set shortmess+=filmnrxoOtT          " Abbrev. of messages (avoids 'hit enter')
    set viewoptions=folds,options,cursor,unix,slash " Better Unix / Windows compatibility
    set virtualedit=onemore             " Allow for cursor beyond last character
    set history=1000                    " Store a ton of history (default is 20)
    set spell                         " Spell checking on
    set hidden                          " Allow buffer switching without saving
    set iskeyword-=.                    " '.' is an end of word designator
    set iskeyword-=#                    " '#' is an end of word designator
    set iskeyword-=-                    " '-' is an end of word designator

    " Instead of reverting the cursor to the last position in the buffer, we
    " set it to the first line when editing a git commit message
    au FileType gitcommit au! BufEnter COMMIT_EDITMSG call setpos('.', [0, 1, 1, 0])

    " Restore cursor to file position in previous editing session
    " To disable this, add the following to your .vimrc.before.local file:
    "   let g:vim_no_restore_cursor = 1
    if !exists('g:vim_no_restore_cursor')
        function! ResCur()
            if line("'\"") <= line("$")
                silent! normal! g`"
                return 1
            endif
        endfunction

        augroup resCur
            autocmd!
            autocmd BufWinEnter * call ResCur()
        augroup END
    endif

    " Setting up the directories {
        set backup                  " Backups are nice ...
        if has('persistent_undo')
            set undofile                " So is persistent undo ...
            set undolevels=1000         " Maximum number of changes that can be undone
            set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
        endif

        " To disable views add the following to your .vimrc.before.local file:
        "   let g:vim_no_views = 1
        if !exists('g:vim_no_views')
            " Add exclusions to mkview and loadview
            " eg: *.*, svn-commit.tmp
            let g:skipview_files = [
                \ '\[example pattern\]'
                \ ]
        endif
    " }
" }

" Vim UI {

    if !exists('g:override_vim_bundles')
        color molokai
    endif

    set tabpagemax=15               " Only show 15 tabs
    set showmode                    " Display the current mode

    set cursorline                  " Highlight current line

    highlight clear SignColumn      " SignColumn should match background
    highlight clear LineNr          " Current line number row will have same background color in relative mode
    "highlight clear CursorLineNr    " Remove highlight color from current line number

    if has('cmdline_info')
        set ruler                   " Show the ruler
        set rulerformat=%30(%=\:b%n%y%m%r%w\ %l,%c%V\ %P%) " A ruler on steroids
        set showcmd                 " Show partial commands in status line and
                                    " Selected characters/lines in visual mode
    endif

    if has('statusline')
        set laststatus=2

        " Broken down into easily includeable segments
        set statusline=%<%f\                     " Filename
        set statusline+=%w%h%m%r                 " Options
        if !exists('g:override_vim_bundles')
            set statusline+=%{fugitive#statusline()} " Git Hotness
        endif
        set statusline+=\ [%{&ff}/%Y]            " Filetype
        set statusline+=\ [%{getcwd()}]          " Current dir
        set statusline+=%=%-14.(%l,%c%V%)\ %p%%  " Right aligned file nav info
    endif

    set backspace=indent,eol,start  " Backspace for dummies
    set linespace=0                 " No extra spaces between rows
    set number                      " Line numbers on
    set showmatch                   " Show matching brackets/parenthesis
    set incsearch                   " Find as you type search
    set hlsearch                    " Highlight search terms
    set winminheight=0              " Windows can be 0 line high
    set ignorecase                  " Case insensitive search
    set smartcase                   " Case sensitive when uc present
    set wildmenu                    " Show list instead of just completing
    set wildmode=list:longest,full  " Command <Tab> completion, list matches, then longest common part, then all.
    set whichwrap=b,s,h,l,<,>,[,]   " Backspace and cursor keys wrap too
    set scrolljump=5                " Lines to scroll when cursor leaves screen
    set scrolloff=3                 " Minimum lines to keep above and below cursor
    set foldenable                  " Auto fold code
    set list
    set listchars=tab:›\ ,trail:•,extends:#,nbsp:. " Highlight problematic whitespace
" }

" Formatting {

    set nowrap                      " Do not wrap long lines
    set autoindent                  " Indent at the same level of the previous line
    set shiftwidth=4                " Use indents of 4 spaces
    set expandtab                   " Tabs are spaces, not tabs
    set tabstop=4                   " An indentation every four columns
    set softtabstop=4               " Let backspace delete indent
    set nojoinspaces                " Prevents inserting two spaces after punctuation on a join (J)
    set splitright                  " Puts new vsplit windows to the right of the current
    set splitbelow                  " Puts new split windows to the bottom of the current
    set matchpairs+=<:>             " Match, to be used with %
    set pastetoggle=<F5>           " pastetoggle (sane indentation on pastes)
    "set comments=sl:/*,mb:*,elx:*/  " auto format comment blocks
    " Remove trailing whitespaces and ^M chars
    " To disable the stripping of whitespace, add the following to your
    " .vimrc.before.local file:
    "   let g:vim_keep_trailing_whitespace = 1
    autocmd FileType c,cpp,java,go,php,javascript,puppet,python,rust,twig,xml,yml,perl,sql autocmd BufEnter <buffer> StripWhitespace
    autocmd BufNewFile,BufRead *.html.twig set filetype=html.twig
    autocmd FileType haskell,puppet,ruby,yml setlocal expandtab shiftwidth=2 softtabstop=2
    autocmd FileType go autocmd BufEnter <buffer> IndentGuidesDisable
    " preceding line best in a plugin but here for now.

    autocmd BufNewFile,BufRead *.coffee set filetype=coffee

    " Workaround vim-commentary for Haskell
    autocmd FileType haskell setlocal commentstring=--\ %s
    " Workaround broken colour highlighting in Haskell
    autocmd FileType haskell,rust setlocal nospell

" }

" Key (re)Mappings {

    " The default leader is '\', but many people prefer ',' as it's in a standard
    " location. To override this behavior and set it back to '\' (or any other
    " character) add the following to your .vimrc.before.local file:
    "   let g:vim_leader='\'
    if !exists('g:vim_leader')
        let mapleader = ','
    else
        let mapleader=g:vim_leader
    endif
    if !exists('g:vim_localleader')
        let maplocalleader = ','
    else
        let maplocalleader=g:vim_localleader
    endif

    " The default mappings for editing and applying the vim configuration
    " are <leader>ev and <leader>sv respectively. Change them to your preference
    " by adding the following to your .vimrc.before.local file:
    "   let g:vim_edit_config_mapping='<leader>ec'
    "   let g:vim_apply_config_mapping='<leader>sc'
    if !exists('g:vim_edit_config_mapping')
        let s:vim_edit_config_mapping = '<leader>ev'
    else
        let s:vim_edit_config_mapping = g:vim_edit_config_mapping
    endif
    if !exists('g:vim_apply_config_mapping')
        let s:vim_apply_config_mapping = '<leader>sv'
    else
        let s:vim_apply_config_mapping = g:vim_apply_config_mapping
    endif

    " Easier moving in tabs and windows
    " The lines conflict with the default digraph mapping of <C-K>
    " If you prefer that functionality, add the following to your
    " .vimrc.before.local file:
    "   let g:vim_no_easyWindows = 1
    if !exists('g:vim_no_easyWindows')
        map <C-J> <C-W>j<C-W>_
        map <C-K> <C-W>k<C-W>_
        map <C-L> <C-W>l<C-W>_
        map <C-H> <C-W>h<C-W>_
    endif
    " Wrapped lines goes down/up to next row, rather than next line in file.
    noremap j gj
    noremap k gk

    " End/Start of line motion keys act relative to row/wrap width in the
    " presence of `:set wrap`, and relative to line for `:set nowrap`.
    " Default vim behaviour is to act relative to text line in both cases
    " If you prefer the default behaviour, add the following to your
    " .vimrc.before.local file:
    "   let g:vim_no_wrapRelMotion = 1
    if !exists('g:vim_no_wrapRelMotion')
        " Same for 0, home, end, etc
        function! WrapRelativeMotion(key, ...)
            let vis_sel=""
            if a:0
                let vis_sel="gv"
            endif
            if &wrap
                execute "normal!" vis_sel . "g" . a:key
            else
                execute "normal!" vis_sel . a:key
            endif
        endfunction

        " Map g* keys in Normal, Operator-pending, and Visual+select
        noremap $ :call WrapRelativeMotion("$")<CR>
        noremap <End> :call WrapRelativeMotion("$")<CR>
        noremap 0 :call WrapRelativeMotion("0")<CR>
        noremap <Home> :call WrapRelativeMotion("0")<CR>
        noremap ^ :call WrapRelativeMotion("^")<CR>
        " Overwrite the operator pending $/<End> mappings from above
        " to force inclusive motion with :execute normal!
        onoremap $ v:call WrapRelativeMotion("$")<CR>
        onoremap <End> v:call WrapRelativeMotion("$")<CR>
        " Overwrite the Visual+select mode mappings from above
        " to ensure the correct vis_sel flag is passed to function
        vnoremap $ :<C-U>call WrapRelativeMotion("$", 1)<CR>
        vnoremap <End> :<C-U>call WrapRelativeMotion("$", 1)<CR>
        vnoremap 0 :<C-U>call WrapRelativeMotion("0", 1)<CR>
        vnoremap <Home> :<C-U>call WrapRelativeMotion("0", 1)<CR>
        vnoremap ^ :<C-U>call WrapRelativeMotion("^", 1)<CR>
    endif

    " The following two lines conflict with moving to top and
    " bottom of the screen
    " If you prefer that functionality, add the following to your
    " .vimrc.before.local file:
    "   let g:vim_no_fastTabs = 1
    if !exists('g:vim_no_fastTabs')
        map <S-H> gT
        map <S-L> gt
        noremap <leader>th :tabfirst<CR>
        noremap <leader>tl :tablast<CR>
        noremap <leader>1 1gt
        noremap <leader>2 2gt
        noremap <leader>3 3gt
        noremap <leader>4 4gt
        noremap <leader>5 5gt
        noremap <leader>6 6gt
        noremap <leader>7 7gt
        noremap <leader>8 8gt
        noremap <leader>9 9gt
    endif

    if !exists('g:vim_no_fastBuffers')
        noremap <leader>bf :bf<CR>
        noremap <leader>bl :bl<CR>
        noremap <leader>b1 :b1<CR>
        noremap <leader>b2 :b2<CR>
        noremap <leader>b3 :b3<CR>
        noremap <leader>b4 :b4<CR>
        noremap <leader>b5 :b5<CR>
        noremap <leader>b6 :b6<CR>
        noremap <leader>b7 :b7<CR>
        noremap <leader>b8 :b8<CR>
        noremap <leader>b9 :b9<CR>
    endif

    " Stupid shift key fixes
    if !exists('g:vim_no_keyfixes')
        if has("user_commands")
            command! -bang -nargs=* -complete=file E e<bang> <args>
            command! -bang -nargs=* -complete=file W w<bang> <args>
            command! -bang -nargs=* -complete=file Wq wq<bang> <args>
            command! -bang -nargs=* -complete=file WQ wq<bang> <args>
            command! -bang Wa wa<bang>
            command! -bang WA wa<bang>
            command! -bang Q q<bang>
            command! -bang QA qa<bang>
            command! -bang Qa qa<bang>
        endif

        cmap Tabe tabe
    endif

    " Yank from the cursor to the end of the line, to be consistent with C and D.
    nnoremap Y y$

    " Code folding options
    nmap <leader>f0 :set foldlevel=0<CR>
    nmap <leader>f1 :set foldlevel=1<CR>
    nmap <leader>f2 :set foldlevel=2<CR>
    nmap <leader>f3 :set foldlevel=3<CR>
    nmap <leader>f4 :set foldlevel=4<CR>
    nmap <leader>f5 :set foldlevel=5<CR>
    nmap <leader>f6 :set foldlevel=6<CR>
    nmap <leader>f7 :set foldlevel=7<CR>
    nmap <leader>f8 :set foldlevel=8<CR>
    nmap <leader>f9 :set foldlevel=9<CR>

    " Most prefer to toggle search highlighting rather than clear the current
    " search results. To clear search highlighting rather than toggle it on
    " and off, add the following to your .vimrc.before.local file:
    "   let g:vim_clear_search_highlight = 1
    if exists('g:vim_clear_search_highlight')
        nmap <silent> <leader>/ :nohlsearch<CR>
    else
        nmap <silent> <leader>/ :set invhlsearch<CR>
    endif


    " Find merge conflict markers
    map <leader>fc /\v^[<\|=>]{7}( .*\|$)<CR>

    " Shortcuts
    " Change Working Directory to that of the current file
    cmap cwd lcd %:p:h
    cmap cd. lcd %:p:h

    " Visual shifting (does not exit Visual mode)
    vnoremap < <gv
    vnoremap > >gv

    " Allow using the repeat operator with a visual selection (!)
    " http://stackoverflow.com/a/8064607/127816
    vnoremap . :normal .<CR>

    " For when you forget to sudo.. Really Write the file.
    cmap w!! w !sudo tee % >/dev/null

    " Some helpers to edit mode
    " http://vimcasts.org/e/14
    cnoremap %% <C-R>=fnameescape(expand('%:h')).'/'<cr>
    map <leader>ew :e %%
    map <leader>es :sp %%
    map <leader>ev :vsp %%
    map <leader>et :tabe %%

    " Adjust viewports to the same size
    map <Leader>= <C-w>=

    " Map <Leader>ff to display all lines with keyword under cursor
    " and ask which one to jump to
    nmap <Leader>ff [I:let nr = input("Which one: ")<Bar>exe "normal " . nr ."[\t"<CR>

    " Easier horizontal scrolling
    map zl zL
    map zh zH

    " Easier formatting
    nnoremap <silent> <leader>q gwip

    " FIXME: Revert this f70be548
    " fullscreen mode for GVIM and Terminal, need 'wmctrl' in you PATH
    map <silent> <F11> :call system("wmctrl -ir " . v:windowid . " -b toggle,fullscreen")<CR>

    nmap     <leader>sf <Plug>CtrlSFPrompt
    vmap     <leader>sf <Plug>CtrlSFVwordPath
    vmap     <leader>sF <Plug>CtrlSFVwordExec
    nmap     <leader>sn <Plug>CtrlSFCwordPath
    nmap     <leader>sp <Plug>CtrlSFPwordPath
    nnoremap <leader>so :CtrlSFOpen<CR>
    nnoremap <leader>st :CtrlSFToggle<CR>
    inoremap <leader>st <Esc>:CtrlSFToggle<CR>
" }

" Plugins {

    " GoLang {
        if count(g:vim_bundle_groups, 'go')
            let g:rehash256 = 1
            let g:molokai_original = 1
            let g:go_highlight_functions = 1
            let g:go_highlight_methods = 1
            let g:go_highlight_structs = 1
            let g:go_highlight_operators = 1
            let g:go_highlight_build_constraints = 1
            let g:go_fmt_command = "goimports"
            let g:syntastic_go_checkers = ['golint', 'govet', 'errcheck']
            let g:syntastic_mode_map = { 'mode': 'active', 'passive_filetypes': ['go'] }
            au FileType go nmap <Leader>s <Plug>(go-implements)
            au FileType go nmap <Leader>i <Plug>(go-info)
            au FileType go nmap <Leader>e <Plug>(go-rename)
            au FileType go nmap <leader>r <Plug>(go-run)
            au FileType go nmap <leader>b <Plug>(go-build)
            au FileType go nmap <leader>t <Plug>(go-test)
            au FileType go nmap <Leader>gd <Plug>(go-doc)
            au FileType go nmap <Leader>gv <Plug>(go-doc-vertical)
            au FileType go nmap <leader>co <Plug>(go-coverage)
        endif
    " }

    " Ctrlp.vim {
        if count(g:vim_bundle_groups, 'unite')
            let g:ctrlp_working_path_mode = 'ra'    " search for nearest ancestor like .git, .hg, and the directory of the current file
            let g:ctrlp_match_window_bottom = 0        " show the match window at the top of the screen
            let g:ctrlp_by_filename = 1
            let g:ctrlp_max_height = 10                " maxiumum height of match window
            let g:ctrlp_switch_buffer = 'et'        " jump to a file if it's open already
            let g:ctrlp_regexp = 1
            let g:ctrlp_use_caching = 1                " enable caching
            let g:ctrlp_clear_cache_on_exit=0          " speed up by not removing clearing cache evertime
            let g:ctrlp_mruf_max = 250                 " number of recently opened files
            let g:ctrlp_map = '<c-p>'
            let g:ctrlp_cmd = 'CtrlP'
            let g:ctrlp_follow_symlinks=1
            let g:ctrlp_mruf_relative = 1
            let g:ctrlp_mruf_exclude = '/tmp/.*\|/temp/.*'
            let g:ctrlp_custom_ignore = {
                        \   'dir':  '\v[\/]\.(git|hg|svn|build)$',
                        \   'file': '\v\.(exe|so|dll|zip|tar|tar.gz)$',
                        \   'link': 'SOME_BAD_SYMBOLIC_LINKS',
                        \ }

            " If ag available, use it to replace grep
            if executable('ag')
                " Use Ag over Grep
                set grepprg=ag\ --nogroup\ --nocolor
                " Use ag in CtrlP for listing files.
                let g:ctrlp_user_command = 'ag %s -l --nocolor -g ""'
                " Ag is fast enough that CtrlP doesn't need to cache
                let g:ctrlp_use_caching = 0
            else
                let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']
            endif

            let g:ctrlp_match_func = { 'match': 'pymatcher#PyMatch' }
            nnoremap <Leader>fr :CtrlPMRU<CR>
            nnoremap <C-p> :CtrlP<CR>
        endif
    " }

    " Unite {
        if count(g:vim_bundle_groups, 'unite')
            let g:unite_source_menu_menus = {}

            " menu prefix key (for all Unite menus)
            nnoremap [menu] <Nop>
            nmap <LocalLeader> [menu]

            let g:unite_source_history_yank_enable = 1
            let g:unite_enable_start_insert = 0
            let g:unite_enable_short_source_mes = 0
            let g:unite_force_overwrite_statusline = 0
            let g:unite_prompt = '>>> '
            let g:unite_marked_icon = '✓'
            let g:unite_candidate_icon = '∘'
            let g:unite_winheight = 15
            let g:unite_update_time = 200
            let g:unite_split_rule = 'botright'
            let g:unite_source_buffer_time_format = '(%d-%m-%Y %H:%M:%S) '
            let g:unite_source_file_mru_time_format = '(%d-%m-%Y %H:%M:%S) '
            let g:unite_source_directory_mru_time_format = '(%d-%m-%Y %H:%M:%S) '

            " unite.vim useful resources:
            " https://github.com/joedicastro/dotfiles/tree/master/vim
            " menus menu
            nnoremap <silent>[menu]m :Unite -silent -winheight=40 menu<CR>

            " [menu]x : menu.edition {
                let g:unite_source_menu_menus.x = {
                            \ 'description' : '    text             ⌘ [menu]x',
                            \}
                let g:unite_source_menu_menus.x.command_candidates = [
                            \['►   show-hidden-chars',
                            \'set list!'],
                            \['►   x d ➞  delete-trailing-whitespaces                         ⌘  SPC x d',
                            \'StripWhitespace'],
                            \['►   a | ➞  align-repeat-bar                                    ⌘  SPC a |',
                            \'Tabularize /|'],
                            \['►   a = ➞  align-repeat-equal                                  ⌘  SPC a =',
                            \'Tabularize /^[^=]*\zs='],
                            \['►   s c ➞  cancel-highlight-of-searched-result                 ⌘  SPC s c',
                            \'nohl'],
                            \['►   t p ➞  toggle-paste-mode                                   ⌘  SPC t p',
                            \'setlocal paste!'],
                            \]
                nnoremap <silent>[menu]x :Unite -silent -winheight=20
                            \ menu:x<CR>
            " }

            " [menu]f : menu.files {
                let g:unite_source_menu_menus.f = {
                            \ 'description' : '    fzf.vim          ⌘ [menu]f',
                            \}
                " supported by fzf
                let g:unite_source_menu_menus.f.command_candidates = [
                            \['►   Buffers                                          (fzf)',
                            \'Buffers'],
                            \['►   Files                                            (fzf)',
                            \'Files'],
                            \['►   GFiles                                           (fzf)',
                            \'GFiles?'],
                            \['►   Windows                                          (fzf)',
                            \'Windows'],
                            \['►   Marks                                            (fzf)',
                            \'Marks'],
                            \['►   Maps                                             (fzf)',
                            \'Maps'],
                            \['►   History                                          (fzf)',
                            \'History'],
                            \['►   History:                                         (fzf)',
                            \'History:'],
                            \['►   History/                                         (fzf)',
                            \'History/'],
                            \]
                nnoremap <silent>[menu]f :Unite -silent -winheight=20
                            \ menu:f<CR>
            " }

            " [menu]p : menu.plugins {
                let g:unite_source_menu_menus.p = {
                            \ 'description' : '    plugins          ⌘ [menu]s',
                            \}
                let g:unite_source_menu_menus.p.command_candidates = [
                            \['►   install-plugin                                    (vim-plug)',
                            \'PlugInstall'],
                            \['►   clean-plugin                                      (vim-plug)',
                            \'PlugClean'],
                            \['►   update-plugin                                     (vim-plug)',
                            \'PlugUpdate'],
                            \['►   show-plugin-status                                (vim-plug)',
                            \'PlugStatus'],
                            \['►   ycm-restart-server                                (ycmd)',
                            \'YcmRestartServer'],
                            \['►   generate-markdown-toc                             (markdown-toc)',
                            \'GenTocGFM'],
                            \]
                nnoremap <silent>[menu]p :Unite -silent
                            \ menu:p<CR>
            " }

            " [menu]u : menu.unite.vim {
                let g:unite_source_menu_menus.u = {
                            \ 'description' : '    unite.vim        ⌘ [menu]u',
                            \}
                let g:unite_source_menu_menus.u.command_candidates = [
                            \['►    ➞  unite sources',
                            \'Unite source'],
                            \]
                nnoremap <silent>[menu]u :Unite -silent
                            \ menu:u<CR>
            " }
        endif
    " }

    " tmux {
        if count(g:vim_bundle_groups, 'tmux')

            let g:ctrlp_extensions = ['buffertag', 'tag', 'tmux']
            "CtrlP tmux window
            nnoremap <Leader>mw :CtrlPTmux w<cr>
            "CtrlP tmux buffer
            nnoremap <Leader>mf :CtrlPTmux b<cr>
            "CtrlP tmux session
            nnoremap <Leader>mm :CtrlPTmux<cr>
            "CtrlP tmux command
            nnoremap <Leader>md :CtrlPTmux c<cr>
            "CtrlP tmux command interactively
            nnoremap <Leader>mi :CtrlPTmux ci<cr>
        endif
    " }

    " TextObj Sentence {
        if count(g:vim_bundle_groups, 'writing')
            augroup textobj_sentence
              autocmd!
              autocmd FileType markdown call textobj#sentence#init()
              autocmd FileType textile call textobj#sentence#init()
              autocmd FileType text call textobj#sentence#init()
            augroup END
        endif
    " }

    " TextObj Quote {
        if count(g:vim_bundle_groups, 'writing')
            augroup textobj_quote
                autocmd!
                autocmd FileType markdown call textobj#quote#init()
                autocmd FileType textile call textobj#quote#init()
                autocmd FileType text call textobj#quote#init({'educate': 0})
            augroup END
        endif
    " }

    " PIV {
        if isdirectory(expand("~/.vim/bundle/PIV"))
            let g:DisableAutoPHPFolding = 0
            let g:PIVAutoClose = 0
        endif
    " }

    " Misc {
        if isdirectory(expand("~/.vim/bundle/nerdtree"))
            let g:NERDShutUp=1
        endif
        if isdirectory(expand("~/.vim/bundle/matchit.zip"))
            let b:match_ignorecase = 1
        endif
        if isdirectory(expand("~/.vim/bundle/apiblueprint.vim"))
            autocmd FileType apiblueprint nnoremap <C-b> :call GenerateRefract()<cr>
        endif
    " }

    " Ctags {
        set tags=./tags;/,~/.vimtags;,~/.vim/tags

        " Make tags placed in .git/tags file available in all levels of a repository
        let gitroot = substitute(system('git rev-parse --show-toplevel'), '[\n\r]', '', 'g')
        if gitroot != ''
            let &tags = &tags . ',' . gitroot . '/.git/tags'
        endif
    " }

    " AutoCloseTag {
        " Make it so AutoCloseTag works for xml and xhtml files as well
        au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
        nmap <Leader>ac <Plug>ToggleAutoCloseMappings
    " }

    " SnipMate {
        " Setting the author var
        " If forking, please overwrite in your .vimrc.local file
        let g:snips_author = 'Jerry <jeryaiwei@gmail.com>'
    " }

    " NerdTree {
        if isdirectory(expand("~/.vim/bundle/nerdtree"))
            map <C-e> <plug>NERDTreeTabsToggle<CR>
            map <leader>e :NERDTreeFind<CR>
            nmap <leader>nt :NERDTreeFind<CR>

            let NERDTreeShowBookmarks=1
            let NERDTreeIgnore=['\.py[cd]$', '\~$', '\.swo$', '\.swp$', '^\.git$', '^\.hg$', '^\.svn$', '\.bzr$']
            let NERDTreeChDirMode=0
            let NERDTreeQuitOnOpen=1
            let NERDTreeMouseMode=2
            let NERDTreeShowHidden=1
            let NERDTreeKeepTreeInNewTab=1
            let g:nerdtree_tabs_open_on_gui_startup=0
            let g:NERDTreeIndicatorMapCustom = {
                        \ 'Modified'  : '✹',
                        \ 'Staged'    : '✚',
                        \ 'Untracked' : '✭',
                        \ 'Renamed'   : '➜',
                        \ 'Unmerged'  : '═',
                        \ 'Deleted'   : '✖',
                        \ 'Dirty'     : '✗',
                        \ 'Clean'     : '✓',
                        \ 'Unknown'   : '?'
                        \ }

            " nerdtree-syntax-highlight {
                let s:brown = "905532"
                let s:aqua =  "3AFFDB"
                let s:blue = "689FB6"
                let s:darkBlue = "44788E"
                let s:purple = "834F79"
                let s:lightPurple = "834F79"
                let s:red = "AE403F"
                let s:beige = "F5C06F"
                let s:yellow = "F09F17"
                let s:orange = "D4843E"
                let s:darkOrange = "F16529"
                let s:pink = "CB6F6F"
                let s:salmon = "EE6E73"
                let s:green = "8FAA54"
                let s:lightGreen = "31B53E"
                let s:white = "FFFFFF"
                let s:rspec_red = 'FE405F'
                let s:git_orange = 'F54D27'

                let g:NERDTreeExtensionHighlightColor = {} " this line is needed to avoid error
                let g:NERDTreeExtensionHighlightColor['css'] = s:blue " sets the color of css files to blue
                let g:NERDTreeExtensionHighlightColor = {} " this line is needed to avoid error
                let g:NERDTreeExtensionHighlightColor['python'] = s:green " sets the color of css files to blue
                let g:NERDTreeExtensionHighlightColor = {} " this line is needed to avoid error
                let g:NERDTreeExtensionHighlightColor['org'] = s:pink " sets the color of css files to blue

                let g:NERDTreeExactMatchHighlightColor = {} " this line is needed to avoid error
                let g:NERDTreeExactMatchHighlightColor['tex'] = s:rspec_red " sets the color of css files to blue
                let g:NERDTreeExactMatchHighlightColor = {} " this line is needed to avoid error
                let g:NERDTreeExactMatchHighlightColor['.gitignore'] = s:git_orange " sets the color for .gitignore files
                let g:NERDTreeExactMatchHighlightColor = {} " this line is needed to avoid error
                let g:NERDTreeExactMatchHighlightColor['.ipynb'] = s:lightPurple " sets the color for .ipynb files
                let g:NERDTreeExactMatchHighlightColor = {} " this line is needed to avoid error
                let g:NERDTreeExactMatchHighlightColor['.py'] = s:red " sets the color for .ipynb files

                let g:NERDTreePatternMatchHighlightColor = {} " this line is needed to avoid error
                let g:NERDTreePatternMatchHighlightColor['.*_spec\.rb$'] = s:rspec_red " sets the color for files ending with _spec.rb
                let g:NERDTreePatternMatchHighlightColor = {} " this line is needed to avoid error
                let g:NERDTreePatternMatchHighlightColor['*.py$'] = s:red " sets the color for files ending with _spec.rb
           " }
        endif
    " }

    " TypeScript {
        if isdirectory(expand("~/.vim/bundle/typescript-vim"))
            let g:typescript_indent_disable = 1
            let g:typescript_compiler_binary = 'tsc'
            let g:typescript_compiler_options = ''

            autocmd FileType typescript :set makeprg=tsc
            autocmd QuickFixCmdPost [^l]* nested cwindow
            autocmd QuickFixCmdPost    l* nested lwindow
        endif
    " }

    " Tabularize {
        if isdirectory(expand("~/.vim/bundle/tabular"))
            nmap <Leader>a& :Tabularize /&<CR>
            vmap <Leader>a& :Tabularize /&<CR>
            nmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
            vmap <Leader>a= :Tabularize /^[^=]*\zs=<CR>
            nmap <Leader>a=> :Tabularize /=><CR>
            vmap <Leader>a=> :Tabularize /=><CR>
            nmap <Leader>a: :Tabularize /:<CR>
            vmap <Leader>a: :Tabularize /:<CR>
            nmap <Leader>a:: :Tabularize /:\zs<CR>
            vmap <Leader>a:: :Tabularize /:\zs<CR>
            nmap <Leader>a, :Tabularize /,<CR>
            vmap <Leader>a, :Tabularize /,<CR>
            nmap <Leader>a,, :Tabularize /,\zs<CR>
            vmap <Leader>a,, :Tabularize /,\zs<CR>
            nmap <Leader>a<Bar> :Tabularize /<Bar><CR>
            vmap <Leader>a<Bar> :Tabularize /<Bar><CR>
        endif
    " }

    " Session List {
        set sessionoptions=blank,buffers,curdir,folds,tabpages,winsize
        if isdirectory(expand("~/.vim/bundle/sessionman.vim/"))
            nmap <leader>sl :SessionList<CR>
            nmap <leader>ss :SessionSave<CR>
            nmap <leader>sc :SessionClose<CR>
        endif
    " }

    " JSON {
        nmap <leader>jt <Esc>:%!python -m json.tool<CR><Esc>:set filetype=json<CR>
        let g:vim_json_syntax_conceal = 0
    " }

    " PyMode {
        " Disable if python support not present
        if !has('python') && !has('python3')
            let g:pymode = 0
        endif

        if isdirectory(expand("~/.vim/bundle/python-mode"))
            let g:pymode_lint_checkers = ['pyflakes']
            let g:pymode_trim_whitespaces = 0
            let g:pymode_options = 0
            let g:pymode_rope = 0
        endif
    " }

    " FZF {
        " deps tmux
       nmap <Leader>? <plug>(fzf-maps-n)
       xmap <Leader>? <plug>(fzf-maps-x)
       omap <Leader>? <plug>(fzf-maps-o)

       nnoremap <Leader>ag :Ag<CR>
       nnoremap <Leader>bb :Buffers<CR>
       nnoremap <Leader>ww :Windows<CR>
       nnoremap <Leader>ff :Files ~<CR>

       " fzf-filemru {
           if isdirectory(expand("~/.vim/bundle/fzf-filemru"))
               nnoremap <Leader>pr :ProjectMru --tiebreak=end<cr>
           endif
       " }
    " }

    " TagBar {
        if isdirectory(expand("~/.vim/bundle/tagbar/"))
            nnoremap <silent> <leader>tt :TagbarToggle<CR>
        endif
    "}

    " Rainbow {
        if isdirectory(expand("~/.vim/bundle/rainbow/"))
            let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle
        endif
    "}

    " Fugitive {
        if isdirectory(expand("~/.vim/bundle/vim-fugitive/"))
            nnoremap <silent> <leader>gs :Gstatus<CR>
            nnoremap <silent> <leader>gd :Gdiff<CR>
            nnoremap <silent> <leader>gc :Gcommit<CR>
            nnoremap <silent> <leader>gb :Gblame<CR>
            nnoremap <silent> <leader>gl :Glog<CR>
            nnoremap <silent> <leader>gp :Git push<CR>
            nnoremap <silent> <leader>gr :Gread<CR>
            nnoremap <silent> <leader>gw :Gwrite<CR>
            nnoremap <silent> <leader>ge :Gedit<CR>
            " Mnemonic _i_nteractive
            nnoremap <silent> <leader>gi :Git add -p %<CR>
            nnoremap <silent> <leader>gg :SignifyToggle<CR>
        endif
    "}

    " YouCompleteMe {
        if count(g:vim_bundle_groups, 'youcompleteme')
            let g:acp_enableAtStartup = 0

            " enable completion from tags
            let g:ycm_collect_identifiers_from_tags_files = 1

            " remap Ultisnips for compatibility for YCM
            let g:UltiSnipsExpandTrigger = '<C-j>'
            let g:UltiSnipsJumpForwardTrigger = '<C-j>'
            let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
            let g:ycm_complete_in_comments = 1  "在注释输入中也能补全
            let g:ycm_complete_in_strings = 1   "在字符串输入中也能补全
            let g:ycm_use_ultisnips_completer = 1 "提示UltiSnips
            let g:ycm_collect_identifiers_from_comments_and_strings = 1   "注释和字符串中的文字也会被收入补全
            let g:ycm_collect_identifiers_from_tags_files = 1
            let g:ycm_global_ycm_extra_conf = "~/.vim/.ycm_extra_conf.py"
            " 开启语法关键字补全
            let g:ycm_seed_identifiers_with_syntax=1

            " 跳转到定义处, 分屏打开
            let g:ycm_goto_buffer_command = 'horizontal-split'
            " nnoremap <leader>jd :YcmCompleter GoToDefinition<CR>
            nnoremap <leader>jd :YcmCompleter GoToDefinitionElseDeclaration<CR>
            nnoremap <leader>gd :YcmCompleter GoToDeclaration<CR>

            " 直接触发自动补全 insert模式下
            " let g:ycm_key_invoke_completion = '<C-Space>'
            " 黑名单,不启用
            let g:ycm_filetype_blacklist = {
                \ 'tagbar' : 1,
                \ 'gitcommit' : 1,
                \}


            " Enable omni completion.
            autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
            autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
            autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
            autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
            autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
            autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
            autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

            " Haskell post write lint and check with ghcmod
            " $ `cabal install ghcmod` if missing and ensure
            " ~/.cabal/bin is in your $PATH.
            if !executable("ghcmod")
                autocmd BufWritePost *.hs GhcModCheckAndLintAsync
            endif

            " For snippet_complete marker.
            if !exists("g:vim_no_conceal")
                if has('conceal')
                    set conceallevel=2 concealcursor=i
                endif
            endif

            " Disable the neosnippet preview candidate window
            " When enabled, there can be too much visual noise
            " especially when splits are used.
            if has("autocmd") && exists("+omnifunc")
                autocmd Filetype *
                    \if &omnifunc == "" |
                    \setlocal omnifunc=syntaxcomplete#Complete |
                    \endif
            endif

            hi Pmenu  guifg=#000000 guibg=#F8F8F8 ctermfg=black ctermbg=Lightgray
            hi PmenuSbar  guifg=#8A95A7 guibg=#F8F8F8 gui=NONE ctermfg=darkcyan ctermbg=lightgray cterm=NONE
            hi PmenuThumb  guifg=#F8F8F8 guibg=#8A95A7 gui=NONE ctermfg=lightgray ctermbg=darkcyan cterm=NONE

            " Automatically open and close the popup menu / preview window
            au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
            set completeopt=menu,preview,longest
        endif


    " }

    " ultisnips {{{
        if count(g:vim_bundle_groups, 'youcompleteme')
            let g:UltiSnipsSnippetDirectories  = ['UltiSnips']
            let g:UltiSnipsSnippetsDir = '~/.vim/UltiSnips'
            " 定义存放代码片段的文件夹 .vim/UltiSnips下，使用自定义和默认的，将会的到全局，有冲突的会提示
            " 进入对应filetype的snippets进行编辑
            map <leader>us :UltiSnipsEdit<CR>

        endif
    " }}}

    " EasyTags {
       " Disabling for now. It doesn't work well on large tag files
        let g:loaded_easytags = 1  " Disable until it's working better
        let g:easytags_cmd = 'ctags'
        let g:easytags_dynamic_files = 1
        if !has('win32') && !has('win64')
            let g:easytags_resolve_links = 1
        endif
    " }

    " Delimitmate {
        au FileType * let b:delimitMate_autoclose = 1

        " If using html auto complete (complete closing tag)
        au FileType xml,html,xhtml let b:delimitMate_matchpairs = "(:),[:],{:}"
    " }

    " AutoCloseTag {
        " Make it so AutoCloseTag works for xml and xhtml files as well
        au FileType xhtml,xml ru ftplugin/html/autoclosetag.vim
    " }

    " FIXME: Isn't this for Syntastic to handle?
    " Haskell post write lint and check with ghcmod
    " $ `cabal install ghcmod` if missing and ensure
    " ~/.cabal/bin is in your $PATH.
    if !executable("ghcmod")
        autocmd BufWritePost *.hs GhcModCheckAndLintAsync
    endif

    " UndoTree {
        if isdirectory(expand("~/.vim/bundle/undotree/"))
            nnoremap <Leader>u :UndotreeToggle<CR>
            " If undotree is opened, it is likely one wants to interact with it.
            let g:undotree_SetFocusWhenToggle=1
        endif
    " }

    " indent_guides {
        if isdirectory(expand("~/.vim/bundle/vim-indent-guides/"))
            let g:indent_guides_start_level = 2
            let g:indent_guides_guide_size = 1
            let g:indent_guides_enable_on_vim_startup = 1
        endif
    " }

    " Wildfire {
        let g:wildfire_objects = {
                \ "*" : ["i'", 'i"', "i)", "i]", "i}", "ip"],
                \ "html,xml" : ["at"],
                \ }
    " }

    " vim-airline {
        " Set configuration options for the statusline plugin vim-airline.
        " Use the powerline theme and optionally enable powerline symbols.
        " To use the symbols , , , , , , and .in the statusline
        " segments add the following to your .vimrc.before.local file:
        "   let g:airline_powerline_fonts=1
        " If the previous symbols do not render for you then install a
        " powerline enabled font.

        " See `:echo g:airline_theme_map` for some more choices
        " Default in terminal vim is 'dark'
        let g:airline#extensions#tabline#enabled = 1
        let g:airline#extensions#tabline#buffer_idx_mode = 1
        let g:airline#extensions#tabline#buffer_nr_show = 1
        let g:airline#extensions#tabline#buffer_nr_format = '%s:'
        "let g:airline#extensions#tabline#fnamemod = ':t'
        let g:airline#extensions#tabline#fnamecollapse = 1
        let g:airline#extensions#tabline#fnametruncate = 0
        let g:airline#extensions#tabline#formatter = 'unique_tail_improved'
        let g:airline#extensions#default#section_truncate_width = {
                \ 'b': 79,
                \ 'x': 60,
                \ 'y': 88,
                \ 'z': 45,
                \ 'warning': 80,
                \ 'error': 80,
                \ }
        let g:airline#extensions#default#layout = [
                    \ [ 'a', 'error', 'warning', 'b', 'c' ],
                    \ [ 'x', 'y', 'z' ]
                    \ ]

        " Distinct background color is enough to discriminate the warning and
        " error information.
        let g:airline#extensions#ale#error_symbol = '•'
        let g:airline#extensions#ale#warning_symbol = '•'

        if !exists('g:airline_theme')
            let g:airline_theme = 'simple'
        endif
        if !exists('g:airline_powerline_fonts')
            " Use the default set of separators with a few customizations
            let g:airline_left_sep='›'  " Slightly fancier than '>'
            let g:airline_right_sep='‹' " Slightly fancier than '<'
        endif
    " }

" }

" GUI Settings {

    " GVIM- (here instead of .gvimrc)
    if has('gui_running')
        set guioptions-=T           " Remove the toolbar
        set lines=40                " 40 lines of text instead of 24
        if !exists("g:vim_no_big_font")
            if LINUX()
                set guifont=Andale\ Mono\ Regular\ 12,Menlo\ Regular\ 11,Consolas\ Regular\ 12,Courier\ New\ Regular\ 14
            elseif OSX()
                set guifont=Andale\ Mono\ Regular:h12,Menlo\ Regular:h11,Consolas\ Regular:h12,Courier\ New\ Regular:h14
            elseif WINDOWS()
                set guifont=Andale_Mono:h10,Menlo:h10,Consolas:h10,Courier_New:h10
            endif
        endif
    else
        if &term == 'xterm' || &term == 'screen'
            set t_Co=256            " Enable 256 colors to stop the CSApprox warning and make xterm vim shine
        endif
        "set term=builtin_ansi       " Make arrow and other keys work
    endif

" }

" Functions {

    " Initialize directories {
        function! InitializeDirectories()
            let parent = $HOME
            let prefix = 'vim'
            let dir_list = {
                        \ 'backup': 'backupdir',
                        \ 'views': 'viewdir',
                        \ 'swap': 'directory' }

            if has('persistent_undo')
                let dir_list['undo'] = 'undodir'
            endif

            " To specify a different directory in which to place the vimbackup,
            " vimviews, vimundo, and vimswap files/directories, add the following to
            " your .vimrc.before.local file:
            "   let g:vim_consolidated_directory = <full path to desired directory>
            "   eg: let g:vim_consolidated_directory = $HOME . '/.vim/'
            if exists('g:vim_consolidated_directory')
                let common_dir = g:vim_consolidated_directory . prefix
            else
                let common_dir = parent . '/.' . prefix
            endif

            for [dirname, settingname] in items(dir_list)
                let directory = common_dir . '/data/' . dirname . '/'
                if exists("*mkdir")
                    if !isdirectory(directory)
                        call mkdir(directory)
                    endif
                endif
                if !isdirectory(directory)
                    echo "Warning: Unable to create backup directory: " . directory
                    echo "Try: mkdir -p " . directory
                else
                    let directory = substitute(directory, " ", "\\\\ ", "g")
                    exec "set " . settingname . "=" . directory
                endif
            endfor
        endfunction
        call InitializeDirectories()
    " }

    " Initialize NERDTree as needed {
        function! NERDTreeInitAsNeeded()
            redir => bufoutput
            buffers!
            redir END
            let idx = stridx(bufoutput, "NERD_tree")
            if idx > -1
                NERDTreeMirror
                NERDTreeFind
                wincmd l
            endif
        endfunction
    " }

    " Shell command {
        function! s:RunShellCommand(cmdline)
            botright new

            setlocal buftype=nofile
            setlocal bufhidden=delete
            setlocal nobuflisted
            setlocal noswapfile
            setlocal nowrap
            setlocal filetype=shell
            setlocal syntax=shell

            call setline(1, a:cmdline)
            call setline(2, substitute(a:cmdline, '.', '=', 'g'))
            execute 'silent $read !' . escape(a:cmdline, '%#')
            setlocal nomodifiable
            1
        endfunction

        command! -complete=file -nargs=+ Shell call s:RunShellCommand(<q-args>)
    " e.g. Grep current file for <search_term>: Shell grep -Hn <search_term> %
    " }

    function! s:IsvimFork()
        let s:is_fork = 0
        let s:fork_files = ["~/.vimrc.fork", "~/.vimrc.before.fork", "~/.vimrc.bundles.fork"]
        for fork_file in s:fork_files
            if filereadable(expand(fork_file, ":p"))
                let s:is_fork = 1
                break
            endif
        endfor
        return s:is_fork
    endfunction

    function! s:ExpandFilenameAndExecute(command, file)
        execute a:command . " " . expand(a:file, ":p")
    endfunction

    function! s:EditvimConfig()
        call <SID>ExpandFilenameAndExecute("tabedit", "~/.vimrc")
        call <SID>ExpandFilenameAndExecute("vsplit", "~/.vimrc.before")
        call <SID>ExpandFilenameAndExecute("vsplit", "~/.vimrc.bundles")

        execute bufwinnr(".vimrc") . "wincmd w"
        call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.local")
        wincmd l
        call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.before.local")
        wincmd l
        call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.bundles.local")

        if <SID>IsvimFork()
            execute bufwinnr(".vimrc") . "wincmd w"
            call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.fork")
            wincmd l
            call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.before.fork")
            wincmd l
            call <SID>ExpandFilenameAndExecute("split", "~/.vimrc.bundles.fork")
        endif

        execute bufwinnr(".vimrc.local") . "wincmd w"
    endfunction

    execute "noremap " . s:vim_edit_config_mapping " :call <SID>EditvimConfig()<CR>"
    execute "noremap " . s:vim_apply_config_mapping . " :source ~/.vimrc<CR>"
" }

" Use fork vimrc if available {
    if filereadable(expand("~/.vimrc.fork"))
        source ~/.vimrc.fork
    endif
" }

" Use local vimrc if available {
    if filereadable(expand("~/.vimrc.local"))
        source ~/.vimrc.local
    endif
" }
