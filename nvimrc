let g:mapleader = "\<Space>"

" Autoinstall vim-plug {{{
if empty(glob(expand($HOME . '/.config/nvim/autoload/plug.vim')))
  silent !curl -fLo expand($HOME . '/.config/nvim/autoload/plug.vim') --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall
endif
" }}}
" Plugins initialization start {{{
call plug#begin(expand($HOME . '/.config/nvim/plugged')) " }}}
" Appearance
" ====================================================================
Plug 'frankier/neovim-colors-solarized-truecolor-only'
Plug 'itchyny/lightline.vim' " A light and configurable statusline/tabline plugin for Vim {{{
  let g:lightline = {
        \ 'colorscheme': 'lightline_solarized_dark',
        \ 'active': {
        \   'left': [ [ 'mode', 'paste' ],
        \             [ 'fugitive', 'gitgutter', 'filename' ] ],
        \   'right': [ [ 'percent', 'lineinfo' ],
        \              [ 'syntastic' ],
        \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
        \ },
        \ 'component_function': {
        \   'fugitive': 'LightLineFugitive',
        \   'gitgutter': 'LightLineGitGutter',
        \   'readonly': 'LightLineReadonly',
        \   'modified': 'LightLineModified',
        \   'syntastic': 'SyntasticStatuslineFlag',
        \   'filename': 'LightLineFilename'
        \ },
        \ 'separator': { 'left': '', 'right': '' },
        \ 'subseparator': { 'left': '>', 'right': '<' }
        \ }
  function! LightLineModified()
    if &filetype == "help"
      return ""
    elseif &modified
      return "+"
    elseif &modifiable
      return ""
    else
      return ""
    endif
  endfunction

  function! LightLineReadonly()
    if &filetype == "help"
      return ""
    elseif &readonly
      return "RO"
    else
      return ""
    endif
  endfunction

  function! LightLineFugitive()
    return exists('*fugitive#head') ? fugitive#head() : ''
  endfunction

  function! LightLineGitGutter()
    if ! exists('*GitGutterGetHunkSummary')
          \ || ! get(g:, 'gitgutter_enabled', 0)
          \ || winwidth('.') <= 90
      return ''
    endif
    let symbols = [
          \ g:gitgutter_sign_added,
          \ g:gitgutter_sign_modified,
          \ g:gitgutter_sign_removed
          \ ]
    let hunks = GitGutterGetHunkSummary()
    let ret = []
    for i in [0, 1, 2]
      if hunks[i] > 0
        call add(ret, symbols[i] . hunks[i])
      endif
    endfor
    return join(ret, ' ')
  endfunction

  function! LightLineFilename()
    return ('' != LightLineReadonly() ? LightLineReadonly() . ' ' : '') .
        \ ('' != expand('%:t') ? expand('%:t') : '[No Name]') .
        \ ('' != LightLineModified() ? ' ' . LightLineModified() : '')
  endfunction
" }}}
Plug 'taohex/lightline-solarized'
" Plug 'edkolev/tmuxline.vim' " Simple tmux statusline generator with support for powerline symbols and statusline / airline / lightline integration. {{{
" let g:tmuxline_powerline_separators = 0
" let g:tmuxline_separators = {
"    \ 'left' : '',
"    \ 'left_alt': '>',
"    \ 'right' : '',
"    \ 'right_alt' : '<',
"    \ 'space' : ' '}
" }}}
Plug 'Yggdroot/indentLine' " A vim plugin to display the indention levels with thin vertical modelines. {{{
  let g:indentLine_char = '⎸'
" }}}
Plug 'kshenoy/vim-signature' " Plugin to toggle, display and navigate marks {{{
  let g:SignatureMarkerTextHL = 'Typedef'
  let g:SignatureMap = {
    \ 'Leader'             :  "m",
    \ 'PlaceNextMark'      :  "m,",
    \ 'ToggleMarkAtLine'   :  "m.",
    \ 'PurgeMarksAtLine'   :  "m-",
    \ 'DeleteMark'         :  "dm",
    \ 'PurgeMarks'         :  "m<Space>",
    \ 'PurgeMarkers'       :  "m<BS>",
    \ 'GotoNextLineAlpha'  :  "",
    \ 'GotoPrevLineAlpha'  :  "",
    \ 'GotoNextSpotAlpha'  :  "",
    \ 'GotoPrevSpotAlpha'  :  "",
    \ 'GotoNextLineByPos'  :  "]'",
    \ 'GotoPrevLineByPos'  :  "['",
    \ 'GotoNextSpotByPos'  :  "]`",
    \ 'GotoPrevSpotByPos'  :  "[`",
    \ 'GotoNextMarker'     :  "[+",
    \ 'GotoPrevMarker'     :  "[-",
    \ 'GotoNextMarkerAny'  :  "]=",
    \ 'GotoPrevMarkerAny'  :  "[=",
    \ 'ListLocalMarks'     :  "m/",
    \ 'ListLocalMarkers'   :  "m?"
    \ }
" }}}
Plug 'tpope/vim-sleuth' " Heuristically set buffer options.
Plug 'junegunn/limelight.vim' " Hyperfocus-writing in Vim. {{{
  let g:limelight_default_coefficient = 0.7
  let g:limelight_conceal_ctermfg = 238
  nmap <silent> gl :Limelight!!<CR>
  xmap gl <Plug>(Limelight)
" }}}

" Completion
" ====================================================================
Plug 'Valloric/YouCompleteMe', { 'do': 'python2 install.py --tern-completer' } " A code-completion engine for Vim {{{
  let g:ycm_autoclose_preview_window_after_completion = 1
  let g:ycm_seed_identifiers_with_syntax = 1
  let g:ycm_collect_identifiers_from_tags_files = 1
  let g:ycm_key_invoke_completion = '<c-j>'
  let g:ycm_complete_in_strings = 1
" }}}
Plug 'SirVer/ultisnips' " The ultimate snippet solution for Vim {{{
  nnoremap <leader>se :UltiSnipsEdit<CR>
  let g:UltiSnipsSnippetsDir = '~/config/nvim/UltiSnips'
  let g:UltiSnipsEditSplit = 'horizontal'
  let g:UltiSnipsListSnippets = '<nop>'
  let g:UltiSnipsExpandTrigger = '<c-l>'
  let g:UltiSnipsJumpForwardTrigger = '<c-l>'
  let g:UltiSnipsJumpBackwardTrigger = '<c-b>'
  let g:ulti_expand_or_jump_res = 0
" }}}
Plug 'honza/vim-snippets' " Snippets files for various programming languages.

" File Navigation
" ====================================================================
Plug 'scrooloose/nerdtree' " {{{
  let g:NERDTreeMinimalUI = 1
  let g:NERDTreeHijackNetrw = 0
  let g:NERDTreeWinSize = 31
  let g:NERDTreeChDirMode = 2
  let g:NERDTreeAutoDeleteBuffer = 1
  let g:NERDTreeShowBookmarks = 1
  let g:NERDTreeCascadeOpenSingleChildDir = 1

  map <F1> :call NERDTreeToggleAndFind()<cr>
  map <F2> :NERDTreeToggle<CR>

  function! NERDTreeToggleAndFind()
    if (exists('t:NERDTreeBufName') && bufwinnr(t:NERDTreeBufName) != -1)
      execute ':NERDTreeClose'
    else
      execute ':NERDTreeFind'
    endif
  endfunction
" }}}
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' } " A command-line fuzzy finder {{{
   let g:fzf_layout = { 'down': '~40%' }
" }}}
Plug 'junegunn/fzf.vim' " Things you can do with fzf and Vim. {{{
  let g:fzf_nvim_statusline = 0 " disable statusline overwriting
  nnoremap <silent> <leader><space> :Files<CR>
  nnoremap <silent> <leader>a :Buffers<CR>
  nnoremap <silent> <leader>A :Windows<CR>
  nnoremap <silent> <leader>; :BLines<CR>
  nnoremap <silent> <leader>o :BTags<CR>
  nnoremap <silent> <leader>O :Tags<CR>
  nnoremap <silent> <leader>? :History<CR>
  nnoremap <silent> <leader>/ :execute 'Ag ' . input('Ag/')<CR>
  nnoremap <silent> <leader>. :AgIn

  nnoremap <silent> K :call SearchWordWithAg()<CR>
  vnoremap <silent> K :call SearchVisualSelectionWithAg()<CR>
  nnoremap <silent> <leader>gl :Commits<CR>
  nnoremap <silent> <leader>ga :BCommits<CR>
  nnoremap <silent> <leader>ft :Filetypes<CR>

  imap <C-x><C-f> <plug>(fzf-complete-file-ag)
  imap <C-x><C-l> <plug>(fzf-complete-line)

  function! SearchWordWithAg()
    execute 'Ag' expand('<cword>')
  endfunction

  function! SearchVisualSelectionWithAg() range
    let old_reg = getreg('"')
    let old_regtype = getregtype('"')
    let old_clipboard = &clipboard
    set clipboard&
    normal! ""gvy
    let selection = getreg('"')
    call setreg('"', old_reg, old_regtype)
    let &clipboard = old_clipboard
    execute 'Ag' selection
  endfunction

  function! SearchWithAgInDirectory(...)
    call fzf#vim#ag(join(a:000[1:], ' '), extend({'dir': a:1}, g:fzf_layout))
  endfunction
  command! -nargs=+ -complete=dir AgIn call SearchWithAgInDirectory(<f-args>)
" }}}
Plug 'zenbro/mirror.vim' " Efficient way to edit remote files on multiple environments with Vim. {{{
  nnoremap <leader>mp :MirrorPush<CR>
  nnoremap <leader>ml :MirrorPull<CR>
  nnoremap <leader>md :MirrorDiff<CR>
  nnoremap <leader>me :MirrorEdit<CR>
  nnoremap <leader>mo :MirrorOpen<CR>
  nnoremap <leader>ms :MirrorSSH<CR>
  nnoremap <leader>mi :MirrorInfo<CR>
  nnoremap <leader>mc :MirrorConfig<CR>
" }}}

" Text Navigation
" ====================================================================
Plug 'Lokaltog/vim-easymotion' " Vim motions on speed! {{{
  let g:EasyMotion_do_mapping = 0
  let g:EasyMotion_smartcase = 1
  let g:EasyMotion_off_screen_search = 0
  nmap ; <Plug>(easymotion-s2)
" }}}
Plug 'rhysd/clever-f.vim' " Extended f, F, t and T key mappings for Vim. {{{
  let g:clever_f_across_no_line = 1
" }}}

" Text Manipulation
" ==================================================================== 
Plug 'tpope/vim-surround' " Quoting/parenthesizing made simple.
Plug 'junegunn/vim-easy-align' " A Vim alignment plugin. {{{
  let g:easy_align_ignore_comment = 0 " align comments
  vnoremap <silent> <Enter> :EasyAlign<cr>
" }}}
Plug 'tomtom/tcomment_vim' " An extensible & universal comment vim-plugin that also handles embedded filetypes.
Plug 'Raimondi/delimitMate' " Provides insert mode auto-completion for quotes, parens, brackets, etc. {{{
  let delimitMate_expand_cr = 2
  let delimitMate_expand_space = 1 " {|} => { | }
" }}}
Plug 'AndrewRadev/splitjoin.vim' " A vim plugin that simplifies the transition between multiline and single-line code.
Plug 'AndrewRadev/switch.vim' " A simple Vim plugin to switch segments of text with predefined replacements. {{{
  let g:switch_mapping = '\'
" }}}
Plug 'tpope/vim-speeddating' " use CTRL-A/CTRL-X to increment dates, times, and more
Plug 'tpope/vim-abolish' " easily search for, substitute, and abbreviate multiple variants of a word

" Text Objects
" ====================================================================
Plug 'kana/vim-textobj-user' " Create your own text objects.
Plug 'kana/vim-textobj-indent' " Text objects for indented blocks of lines
" Plug 'nelstrom/vim-textobj-rubyblock'

" Languages
" ====================================================================
Plug 'scrooloose/syntastic' " {{{
  let g:syntastic_enable_signs          = 1
  let g:syntastic_enable_highlighting   = 1
  let g:syntastic_cpp_check_header      = 1
  let g:syntastic_enable_balloons       = 1
  let g:syntastic_echo_current_error    = 1
  let g:syntastic_check_on_wq           = 0
  let g:syntastic_error_symbol          = '✘'
  let g:syntastic_warning_symbol        = '!'
  let g:syntastic_style_error_symbol    = ':('
  let g:syntastic_style_warning_symbol  = ':('
  let g:syntastic_vim_checkers          = ['vint']
"  let g:syntastic_elixir_checkers       = ['elixir']
"  let g:syntastic_python_checkers       = ['flake8']
  let g:syntastic_javascript_checkers   = ['eslint']
"  let g:syntastic_enable_elixir_checker = 0

"  let g:syntastic_ruby_rubocop_exec = '~/.rubocop.sh'
"  let g:syntastic_ruby_rubocop_args = '--display-cop-names --rails'

"  function! RubocopAutoCorrection()
"    echo 'Starting rubocop autocorrection...'
"    cexpr system('rubocop -D -R -f emacs -a ' . expand(@%))
"    edit
"    SyntasticCheck rubocop
"    copen
"  endfunction

"  augroup syntasticCustomCheckers
"    autocmd!
"    autocmd FileType ruby nnoremap <leader>` :SyntasticCheck rubocop<CR>
"    autocmd FileType ruby nnoremap <leader>! :call RubocopAutoCorrection()<CR>
"  augroup END
" }}}
Plug 'mattn/emmet-vim' " Support for expanding abbreviations similar to emmet. {{{
  let g:user_emmet_leader_key='<Tab>'
  let g:user_emmet_settings = {
      \  'javascript.jsx' : {
      \      'extends' : 'jsx',
      \  },
      \}
  let g:user_emmet_expandabbr_key = '<c-e>'
" }}}
Plug 'Valloric/MatchTagAlways' " Always highlights the enclosing html/xml tags.
Plug 'tpope/vim-ragtag' " A set of mappings for HTML, XML, PHP, ASP, and more. {{{
  let g:ragtag_global_maps = 1
" }}}
" Plug 'vim-ruby/vim-ruby'
" Plug 'tpope/vim-rails'
" Plug 'tpope/vim-rake'
" Plug 'tpope/vim-bundler'
" Plug 'yaymukund/vim-rabl'
" Plug 'tpope/vim-liquid'
" Plug 'tpope/vim-jdaddy'
" Plug 'Shougo/context_filetype.vim' 
Plug 'othree/html5.vim' " HTML5 omnicomplete and syntax.
Plug 'pangloss/vim-javascript' " Vastly improved Javascript indentation and syntax. {{{
 let g:used_javascript_libs = 'jquery'
" }}}
Plug 'mxw/vim-jsx' " React JSX syntax highlighting and indenting.
Plug 'jparise/vim-graphql' " GraphQL file detection, syntax highlighting, and indentation.
Plug 'ap/vim-css-color' " Preview colours in source code while editing
" Plug 'lervag/vimtex' " {{{
  " let g:vimtex_view_method = 'zathura'
  " augroup latex
  "   autocmd!
  "   autocmd FileType tex nnoremap <buffer><F5> :VimtexCompile<CR>
  "   autocmd FileType tex map <silent> <buffer><F8> :call vimtex#latexmk#errors_open(0)<CR>
  " augroup END
" }}}
Plug 'StanAngeloff/php.vim' " An up-to-date syntax for PHP (7.x supported).
" Plug 'qbbr/vim-twig' " Twig syntax and snippets.
" Plug 'ekalinin/Dockerfile.vim' " Syntax file & snippets for Docker's Dockerfile
" Plug 'w0rp/ale' " Asyncronous Lint Engine

" Git
" ====================================================================
Plug 'tpope/vim-fugitive' " Git wrapper so awesome, it should be illegal. {{{
  " Fix broken syntax highlight in gitcommit files
  " (https://github.com/tpope/vim-git/issues/12)
  let g:fugitive_git_executable = 'LANG=en_US.UTF-8 git'

  nnoremap <silent> <leader>gs :Gstatus<CR>
  nnoremap <silent> <leader>gd :Gdiff<CR>
  nnoremap <silent> <leader>gc :Gcommit<CR>
  nnoremap <silent> <leader>gb :Gblame<CR>
  nnoremap <silent> <leader>ge :Gedit<CR>
  nnoremap <silent> <leader>gE :Gedit<space>
  nnoremap <silent> <leader>gr :Gread<CR>
  nnoremap <silent> <leader>gR :Gread<space>
  nnoremap <silent> <leader>gw :Gwrite<CR>
  nnoremap <silent> <leader>gW :Gwrite!<CR>
  nnoremap <silent> <leader>gq :Gwq<CR>
  nnoremap <silent> <leader>gQ :Gwq!<CR>

  function! ReviewLastCommit()
    if exists('b:git_dir')
      Gtabedit HEAD^{}
      nnoremap <buffer> <silent> q :<C-U>bdelete<CR>
    else
      echo 'No git a git repository:' expand('%:p')
    endif
  endfunction
  nnoremap <silent> <leader>g` :call ReviewLastCommit()<CR>

  augroup fugitiveSettings
    autocmd!
    autocmd FileType gitcommit setlocal nolist
    autocmd BufReadPost fugitive://* setlocal bufhidden=delete
  augroup END
" }}}
Plug 'airblade/vim-gitgutter' " Shows a git diff in the gutter (sign column) and stages/undoes hunks. {{{
  let g:gitgutter_map_keys = 0
  let g:gitgutter_max_signs = 200
  let g:gitgutter_realtime = 1
  let g:gitgutter_eager = 1
  let g:gitgutter_sign_removed = '–'
  let g:gitgutter_diff_args = '--ignore-space-at-eol'
  nmap <silent> ]h :GitGutterNextHunk<CR>
  nmap <silent> [h :GitGutterPrevHunk<CR>
  nnoremap <silent> <Leader>gu :GitGutterRevertHunk<CR>
  nnoremap <silent> <Leader>gp :GitGutterPreviewHunk<CR><c-w>j
  nnoremap cog :GitGutterToggle<CR>
  nnoremap <Leader>gt :GitGutterAll<CR>
" }}}
Plug 'esneider/YUNOcommit.vim' " Y U NO commit after so many writes???

" Utility
" ====================================================================
Plug 'ludovicchabant/vim-gutentags' " Manages your tag files {{{
  let g:gutentags_ctags_executable = expand($HOME . '/.local/bin/ctags')
"  let g:gutentags_trace = 1
  let g:gutentags_ctags_exclude = [
      \ '*.min.js',
      \ '*html*',
      \ 'jquery*.js',
      \ '*/vendor/*',
      \ '*/node_modules/*',
      \ '*/python2.7/*',
      \ '*/migrate/*.rb'
      \ ]
  let g:gutentags_generate_on_missing = 0
  let g:gutentags_generate_on_write = 0
  let g:gutentags_generate_on_new = 0
  nnoremap <leader>t! :GutentagsUpdate!<CR>

  au FileType php let g:gutentags_ctags_extra_args = ['--fields=+aimlS', '--languages=php']
" }}}
Plug 'tpope/vim-characterize' " Unicode character metadata.
Plug 'tpope/vim-unimpaired' " Pairs of handy bracket mappings. {{{
  nnoremap coe :set <C-R>=&expandtab ? 'noexpandtab' : 'expandtab'<CR><CR>
" }}}
Plug 'tpope/vim-eunuch' " Helpers for UNIX.
" Plug 'tpope/vim-dispatch' " Asynchronous build and test dispatcher.
" Plug 'janko-m/vim-test' " Run your tests at the speed of thought. {{{
"   function! TerminalSplitStrategy(cmd) abort
"     tabnew | call termopen(a:cmd) | startinsert
"   endfunction
"   let g:test#custom_strategies = get(g:, 'test#custom_strategies', {})
"   let g:test#custom_strategies.terminal_split = function('TerminalSplitStrategy')
"   let test#strategy = 'terminal_split'
"
"   nnoremap <silent> <leader>rr :TestFile<CR>
"   nnoremap <silent> <leader>rf :TestNearest<CR>
"   nnoremap <silent> <leader>rs :TestSuite<CR>
"   nnoremap <silent> <leader>ra :TestLast<CR>
"   nnoremap <silent> <leader>ro :TestVisit<CR>
" " }}}
Plug 'tyru/open-browser.vim' " Open URI with your favorite browser. {{{
  let g:netrw_nogx = 1
  vmap gx <Plug>(openbrowser-smart-search)
  nmap gx <Plug>(openbrowser-search)
" }}}
Plug 'Shougo/junkfile.vim' " Create temporary file for memo, testing, etc. {{{
  nnoremap <leader>jo :JunkfileOpen
  let g:junkfile#directory = $HOME . '/config/nvim/cache/junkfile'
" }}}
Plug 'junegunn/vim-peekaboo' " See the contents of the registers. {{{
  let g:peekaboo_delay = 400
" }}}
Plug 'mbbill/undotree' " Undo history visualizer. {{{
  set undofile
  " Auto create undodir if not exists
  let undodir = expand($HOME . '/.config/nvim/cache/undodir')
  if !isdirectory(undodir)
    call mkdir(undodir, 'p')
  endif
  let &undodir = undodir

  nnoremap <leader>z :UndotreeToggle<CR>
" }}}

" Debugger
Plug 'joonty/vdebug' " A powerful, fast, multi-language debugger for Vim {{{
let g:vdebug_options= {
\    "port" : 9209,
\    "server" : 'localhost',
\    "timeout" : 20,
\    "on_close" : 'detach',
\    "break_on_open" : 1,
\    "ide_key" : '',
\    "path_maps" : {},
\    "debug_window_level" : 0,
\    "debug_file_level" : 0,
\    "debug_file" : "",
\    "watch_window_style" : 'expanded',
\    "marker_default" : '⬦',
\    "marker_closed_tree" : '▸',
\    "marker_open_tree" : '▾'
\} " }}}

" Misc
" ====================================================================
Plug 'itchyny/calendar.vim', { 'on': 'Calendar' } " Calendar application. {{{
  let g:calendar_date_month_name = 1
" }}}
" Plug 'xolox/vim-misc'
" Plug 'xolox/vim-notes' " {{{
"   let g:notes_directories = ['~/Documents/Notes']
" }}}
call plug#end() " Plugins initialization finished {{{
" }}}

" True Color {{{
let $NVIM_TUI_ENABLE_TRUE_COLOR=1
set termguicolors
" }}}
" Indentation {{{
" ====================================================================
set expandtab     " replace <Tab with spaces
set tabstop=2     " number of spaces that a <Tab> in the file counts for
set softtabstop=2 " remove <Tab> symbols as it was spaces
set shiftwidth=2  " indent size for << and >>
set shiftround    " round indent to multiple of 'shiftwidth' (for << and >>)
" }}}
" Search {{{
" ====================================================================
set ignorecase " ignore case of letters
set smartcase  " override the 'ignorecase' when there is uppercase letters
set gdefault   " when on, the :substitute flag 'g' is default on
" }}}
" Colors and highlightings {{{
" ====================================================================
set background=dark
colorscheme solarized
" hi! CursorLine cterm=NONE gui=NONE ctermbg=0
" hi IndentGuidesOdd  ctermbg=NONE
" hi IndentGuidesEven ctermbg=0

set cursorline     " highlight current line
set colorcolumn=80 " highlight column

" Various columns
" highlight! SignColumn ctermbg=233 guibg=#0D0D0D
" highlight! FoldColumn ctermbg=233 guibg=#0D0D0D

" Syntastic
highlight SyntasticErrorSign guifg=black guibg=#E01600 ctermfg=16 ctermbg=160
highlight SyntasticErrorLine guibg=#0D0D0D ctermbg=232
highlight SyntasticWarningSign guifg=black guibg=#FFED26 ctermfg=16 ctermbg=11
highlight SyntasticWargningLine guibg=#171717
highlight SyntasticStyleWarningSign guifg=black guibg=#bcbcbc ctermfg=16 ctermbg=250
highlight SyntasticStyleErrorSign guifg=black guibg=#ff8700 ctermfg=16 ctermbg=208
" }}}
" Key Mappings " {{{
nnoremap <leader>vi :tabedit $MYVIMRC<CR>

" Toggle quickfix
map <silent> <F8> :copen<CR>

" Quick way to save file
nnoremap <leader>w :w<CR>

" Y behave like D or C
nnoremap Y y$

" Disable search highlighting
nnoremap <silent> <Esc><Esc> :nohlsearch<CR><Esc>
nnoremap <CR> :noh<CR><CR>

nnoremap <leader>% :call CopyCurrentFilePath()<CR> " Copy current file path to clipboard {{{
function! CopyCurrentFilePath()
  let @+ = expand('%')
  echo @+
endfunction " }}}

" Keep search results at the center of screen {{{
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz
" }}}

" Select all text
noremap vA ggVG

" Same as normal H/L behavior, but preserves scrolloff {{{
nnoremap H :call JumpWithScrollOff('H')<CR>
nnoremap L :call JumpWithScrollOff('L')<CR>
function! JumpWithScrollOff(key)
  set scrolloff=0
  execute 'normal! ' . a:key
  set scrolloff=999
endfunction " }}}

" Switch between tabs {{{
nmap <leader>1 1gt
nmap <leader>2 2gt
nmap <leader>3 3gt
nmap <leader>4 4gt
nmap <leader>5 5gt
nmap <leader>6 6gt
nmap <leader>7 7gt
nmap <leader>8 8gt
nmap <leader>9 9gt
" }}}

" Creating splits with empty buffers in all directions
nnoremap <Leader>hn :leftabove  vnew<CR>
nnoremap <Leader>ln :rightbelow vnew<CR>
nnoremap <Leader>kn :leftabove  new<CR>
nnoremap <Leader>jn :rightbelow new<CR>

" If split in given direction exists - jump, else create new split
function! JumpOrOpenNewSplit(key, cmd, fzf) " {{{
  let current_window = winnr()
  execute 'wincmd' a:key
  if current_window == winnr()
    execute a:cmd
    if a:fzf
      Files
    endif
  else
    if a:fzf
      Files
    endif
  endif
endfunction " }}}
nnoremap <silent> <Leader>hh :call JumpOrOpenNewSplit('h', ':leftabove vsplit', 0)<CR>
nnoremap <silent> <Leader>ll :call JumpOrOpenNewSplit('l', ':rightbelow vsplit', 0)<CR>
nnoremap <silent> <Leader>kk :call JumpOrOpenNewSplit('k', ':leftabove split', 0)<CR>
nnoremap <silent> <Leader>jj :call JumpOrOpenNewSplit('j', ':rightbelow split', 0)<CR>

" Same as above, except it opens unite at the end
nnoremap <silent> <Leader>h<Space> :call JumpOrOpenNewSplit('h', ':leftabove vsplit', 1)<CR>
nnoremap <silent> <Leader>l<Space> :call JumpOrOpenNewSplit('l', ':rightbelow vsplit', 1)<CR>
nnoremap <silent> <Leader>k<Space> :call JumpOrOpenNewSplit('k', ':leftabove split', 1)<CR>
nnoremap <silent> <Leader>j<Space> :call JumpOrOpenNewSplit('j', ':rightbelow split', 1)<CR>

" Remove trailing whitespaces in current buffer
nnoremap <Leader><BS>s :1,$s/[ ]*$//<CR>:nohlsearch<CR>1G

" Universal closing behavior
nnoremap <silent> Q :call CloseSplitOrDeleteBuffer()<CR>
function! CloseSplitOrDeleteBuffer() " {{{
  if winnr('$') > 1
    wincmd c
  else
    execute 'bdelete'
  endif
endfunction " }}}

" Delete all hidden buffers
nnoremap <silent> <Leader><BS>b :call DeleteHiddenBuffers()<CR>
function! DeleteHiddenBuffers() " {{{
  let tpbl=[]
  call map(range(1, tabpagenr('$')), 'extend(tpbl, tabpagebuflist(v:val))')
  for buf in filter(range(1, bufnr('$')), 'bufexists(v:val) && index(tpbl, v:val)==-1')
    silent execute 'bwipeout' buf
  endfor
endfunction " }}}

" http://vim.wikia.com/wiki/Set_working_directory_to_the_current_file
nnoremap <Leader>cd :cd %:p:h<CR>:pwd<CR>

" new file in current directory
map <Leader>nf :e <C-R>=expand("%:p:h") . "/" <CR>

" Thank you Vim Regex! http://vimregex.com/
noremap ;; :%s:::g<Left><Left><Left>
noremap ;' :%s:::cg<Left><Left><Left><Left>
cmap ;\ \(\)<Left><Left>

let g:session_dir = '$HOME/.config/nvim/sessions/'
nnoremap <Leader>sl :wall<Bar>execute "source " . g:session_dir . fnamemodify(getcwd(), ':t')<CR>
nnoremap <Leader>ss :execute "mksession! " . g:session_dir . fnamemodify(getcwd(), ':t')<CR>
" }}}
" Terminal {{{
" ====================================================================
nnoremap <silent> <leader><Enter> :tabnew<CR>:terminal<CR>

" Opening splits with terminal in all directions
nnoremap <Leader>h<Enter> :leftabove  vnew<CR>:terminal<CR>
nnoremap <Leader>l<Enter> :rightbelow vnew<CR>:terminal<CR>
nnoremap <Leader>k<Enter> :leftabove  new<CR>:terminal<CR>
nnoremap <Leader>j<Enter> :rightbelow new<CR>:terminal<CR>

" Insert mode like
if has('nvim')
  tnoremap <expr> <A-r> '<C-\><C-N>"'.nr2char(getchar()).'pi'
endif

" Open tig
nnoremap <Leader>gg :tabnew<CR>:terminal tig<CR>

tnoremap <F1> <C-\><C-n>
tnoremap <C-\><C-\> <C-\><C-n>:bd!<CR>

function! TerminalInSplit(args)
  botright split
  execute 'terminal' a:args
endfunction

nnoremap <leader><F1> :execute 'terminal ranger ' . expand('%:p:h')<CR>
nnoremap <leader><F2> :terminal ranger<CR>
augroup terminalSettings
  autocmd!
"  autocmd FileType ruby nnoremap <leader>\ :call TerminalInSplit('pry')<CR>
augroup END
" }}}
" Autocommands {{{
" ====================================================================
augroup vimGeneralCallbacks
  autocmd!
  autocmd BufWritePost .nvimrc nested source ~/.nvimrc
augroup END

augroup fileTypeSpecific
  autocmd!

  " JST support
"  autocmd BufNewFile,BufRead *.ejs set filetype=jst
"  autocmd BufNewFile,BufRead *.jst set filetype=jst
"  autocmd BufNewFile,BufRead *.djs set filetype=jst
"  autocmd BufNewFile,BufRead *.hamljs set filetype=jst
"  autocmd BufNewFile,BufRead *.ect set filetype=jst

"  autocmd BufNewFile,BufRead *.js.erb set filetype=javascript

  " Gnuplot support
  autocmd BufNewFile,BufRead *.plt set filetype=gnuplot

"  autocmd FileType jst set syntax=htmldjango
augroup END

augroup quickFixSettings
  autocmd!
  autocmd FileType qf
        \ nnoremap <buffer> <silent> q :close<CR> |
        \ map <buffer> <silent> <F4> :close<CR> |
        \ map <buffer> <silent> <F8> :close<CR>
augroup END

augroup terminalCallbacks
  autocmd!
  autocmd TermClose * call feedkeys('<cr>')
augroup END
"}}}
" Cursor configuration {{{
" ====================================================================
" Use a blinking upright bar cursor in Insert mode, a solid block in normal
" and a blinking underline in replace mode
  let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1
  let &t_SI = "\<Esc>[5 q"
  let &t_SR = "\<Esc>[3 q"
  let &t_EI = "\<Esc>[2 q"
" }}}
" vim: set sw=2 ts=2 et foldlevel=0 foldmethod=marker:
