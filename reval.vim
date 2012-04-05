" TODO:
" git
" Rubify
" Add ~/.reval.vimrc
" Upload!

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
    let g:revalbody = 's//MATCH/g'
  end
else
  echoerr 'Unexpected g:revallang = "'.g:revallang.'"'
  echo '...perhaps you want to be awesome and edit' % 'then notify rking@panoptic.com ?'
end

if !exists('g:revalhl')
  let g:revalhl = 'MATCH'
end

if !exists('g:revalinput')
  " TODO feature! -- Make this default to % if they're already on a buffer
  " Something like: map <Leader>reval :let g:revalinput = %<cr>...
  let g:revalinput = 'in'
end

if !exists('g:revalcmd')
  let g:revalcmd = g:revalrunner.' '.g:revalfile.' 2>&1 < '.g:revalinput
end

noremap <cr> :call TestTheRegex()<cr>
if exists('g:revalcrazyrun')
  au InsertLeave *.pm call TestTheRegex()
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
  1d " kind of a hack. Is required because we append() starting with line 1.
  exec 'silent! /' . g:revalhl
  wincmd k
endfunc

func! s:StartInputFile()
  exec 'vsplit' g:revalinput
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
/* Look make a change above,
 * hit Enter, then look to the right -->
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
  call setline('.', g:revalbody)
  call setpos('.', [0, 1, 3, 0]) " Thanks to #vim's bairui for this spiff-up!
  w
endfunc

call s:StartInputFile()
call s:StartRegexFile()
