" TODO:
" Upload!

map <Leader>reval :call RunReval()<cr>

func! s:LoadDefaultOptions()
  let s:rcfile = $HOME.'/.reval.vimrc'
  if filereadable(s:rcfile)
    exec 'so' s:rcfile
  end

  if !exists('g:revallang')
    " Should be ruby, but I'm going easy on late adopters:
    let g:revallang = 'perl'
  end

  if 'perl' == g:revallang
    if !exists('g:revalfile')|let g:revalfile = tempname().'-reval.pm'|end
    if !exists('g:revalrunner')|let g:revalrunner = 'perl -wp'|end
    if !exists('g:revalbody')|let g:revalbody = 's//…/g'|end
    if !exists('g:revalstartpos')|let g:revalstartpos = 3|end
  elseif 'ruby' == g:revallang
    if !exists('g:revalfile')|let g:revalfile = tempname().'-reval.rb'|end
    if !exists('g:revalrunner')|let g:revalrunner = 'ruby -wKup'|end
    if !exists('g:revalbody')|let g:revalbody = "gsub(//,'…')"|end
    if !exists('g:revalstartpos')|let g:revalstartpos = 7|end
  else
    echoerr 'Unexpected g:revallang = "'.g:revallang.'". Perhaps you want to be awesome and edit reval.vim to include a config for it then notify rking@panoptic.com with the patch?'
    finish
  end

  " Default to treating the input file as a whole string.
  " This is a farily aggressive default, but I believe it is more the way you
  " expect it to work, so that \A means the beginning of the file, not each
  " line, for example.  If you are doing much customization of the above
  " variables, you'll probably want to 'let g:revallinewise = 1' so that it
  " disables this appendage.
  if !exists('g:revallinewise')|let g:revallinewise = 0|end
  if !g:revallinewise
    let g:revalrunner = g:revalrunner.' -0400'
  end

  " TODO feature! -- Make this default to % if they're already on a buffer
  " Something like: map <Leader>reval :let g:revalinput = %<cr>...
  if !exists('g:revalinput')|let g:revalinput = tempname().'revalinput'|end

  call LoadDefaultRevalCmd()
endfunc

func! LoadDefaultRevalCmd()
  if !exists('g:revalcmd')
    let g:revalcmd = g:revalrunner.' '.g:revalfile.' 2>&1 < '.g:revalinput
  end
endfunc

func! TestTheRegex()
  call s:LoadDefaultOptions() " in case the user changed vars since RunReval()
  w
  wincmd j
  wincmd l
  %d
  let l:output = system(g:revalcmd)
  for line in split(l:output, "\n")
    call append(line('$'), line)
  endfo
  1d " <- kind of a hack. (Required because we append() starting with line 1.)
  0
  wincmd k
endfunc

func! PerlDebugTestTheRegex()
    let l:revalrunner = g:revalrunner
    let l:revalcmd = g:revalcmd
    let g:revalrunner = 'perl -p -mre=debug'
    unlet g:revalcmd
    call LoadDefaultRevalCmd()
    call TestTheRegex()
    let g:revalrunner = l:revalrunner
    let g:revalcmd = l:revalcmd
endfunc

func! s:StartInputFile()
  exec 'e' g:revalinput
  $
  if getpos('.')[1] == "1"
    call s:PopulateInputFile()
  end
  w
  0
endfunc

func! s:PopulateInputFile()
    a
brokenfront> etc..
-- This is the test input file. --
/* Change the above code, hit Enter,
 * then look to the right -->
 */
[lots more stuff here.]
0 1 2 23 456 0.2 -3 1,258
0b1101 012 0xF00F
Lorem "ipsum," Robots etc.

Tab	 Here and space here: 
etc <withattrs a="b">etc</withattrs>
<tag>etc</tag> <empty></empty> <> etc
  
<brokenend
.
endfunc

func! s:StartOutputFile()
  vnew
  wincmd r
  setlocal noswapfile
  setlocal buftype=nofile
  setlocal bufhidden=delete
  syn match revalMatch '…'
  hi link revalMatch Todo
endfunc

func! s:StartRegexFile()
  exec 'topleft sp' g:revalfile
  3wincmd _
  " TODO: Make the following window-specific somehow so that when we quit we
  " get back to normal:
  noremap <cr> :call TestTheRegex()<cr>
  noremap <leader>d :call PerlDebugTestTheRegex()<cr>

  if exists('g:revalcrazyrun')
    au InsertLeave *.pm call TestTheRegex()
  end
  call setline('.', g:revalbody)
  " Thanks to #vim's bairui for this spiff-up!:
  call setpos('.', [0, 1, g:revalstartpos, 0])
  w
endfunc

func! RunReval()
  call s:LoadDefaultOptions()
  call s:StartInputFile()
  call s:StartOutputFile()
  call s:StartRegexFile()
endfunc
