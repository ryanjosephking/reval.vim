" TODO:
" Add plugin skeleton stuff from How_to_write_a_plugin
" Rubify
" Add ~/.reval.vimrc
" Upload!

map <Leader>reval :call RunReval()<cr>

if !exists('g:revallang')
  let g:revallang = 'perl' " Should be ruby, but I'm going easy on late adopters
end

if 'perl' == g:revallang
  if !exists('g:revalrunner')
    let g:revalrunner = 'perl -p'
  end
  if !exists('g:revalfile')
    let g:revalfile = 'reval.pm'
  end
  if !exists('g:revalbody')
    let g:revalbody = 's//…/g'
  end
else
  echoerr 'Unexpected g:revallang = "'.g:revallang.'"'
  echo '...perhaps you want to be awesome and edit' % 'then notify rking@panoptic.com ?'
end

if !exists('g:revalinput')
  " TODO feature! -- Make this default to % if they're already on a buffer
  " Something like: map <Leader>reval :let g:revalinput = %<cr>...
  let g:revalinput = 'in'
end

if !exists('g:revalcmd')
  let g:revalcmd = g:revalrunner.' '.g:revalfile.' 2>&1 < '.g:revalinput
end



func! TestTheRegex()
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

func! s:StartInputFile()
  exec 'e' g:revalinput
  $
  if getpos('.')[1] == "1"
    call s:PopulateInputFile()
  end
  w
  0
endfunc

func! s:StartOutputFile()
  vsplit
  wincmd l
  " XXX I want this to be a truly empty buffer, like when you start vim with
  " no args:
  e /tmp/unused
  setlocal buftype=nofile
  syn match revalMatch '…'
  hi link revalMatch Todo
endfunc

func! s:PopulateInputFile()
    a
brokenfront> etc..
-- This is the test input file. --
/* Look make a change above code, hit Enter,
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
end
endfunc

func! s:StartRegexFile()
  exec 'topleft sp' g:revalfile
  3wincmd _
  " TODO: Make the following window-specific somehow so that when we quit we
  " get back to normal:
  noremap <cr> :call TestTheRegex()<cr>
  if exists('g:revalcrazyrun')
    au InsertLeave *.pm call TestTheRegex()
  end
  call setline('.', g:revalbody)
  call setpos('.', [0, 1, 3, 0]) " Thanks to #vim's bairui for this spiff-up!
  w
endfunc

func! RunReval()
  call s:StartInputFile()
  call s:StartOutputFile()
  call s:StartRegexFile()
endfunc
