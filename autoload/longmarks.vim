" main purpose of this script is to provide way to define multikey
" marks, which are usefull to navigate similar file structures

function! s:LoadMarksFromFile() abort
  let l:contents = readfile(g:longmarks_session_path)
  return json_decode(l:contents)
endfunction


" save state on exit
if exists('g:longmarks_session_path')
  augroup LongMarksSaveMarksOnLeave
    autocmd!
    autocmd VimLeave * call s:SaveMarks()
  augroup END
endif


function! s:LoadMarks() abort
  let l:longmarks = {}
  if exists('g:longmarks_session_path') && filereadable(g:longmarks_session_path)
    let l:longmarks = s:LoadMarksFromFile()
  endif

  return l:longmarks
endfunction


function! s:SaveMarks() abort
  let l:contents = [json_encode(s:longmarks)]
  call writefile(l:contents, g:longmarks_session_path)
endfunction


" render mappings in buffer
function! s:GetBufferContents() abort
  let l:prepared_mappings = []
  let l:mappings_list = items(s:longmarks)

  for [mapping, file_info] in l:mappings_list
    let [filename, position] = file_info
    let l:single_mapping = printf('%-6S', mapping) . ' ' . fnamemodify(filename, ':t')
    let l:prepared_mappings = insert(l:prepared_mappings, l:single_mapping)
  endfor

  return l:prepared_mappings
endfunction


function! s:ConfigureBuffer() abort
  setlocal nofoldenable
  setlocal buftype=nofile
  setlocal noswapfile
  setlocal nobuflisted
  setlocal nowrap
  setlocal nospell
  setlocal nomodifiable
endfunction

function! s:GoToFile(file, position) abort
  execute 'bdelete'
  execute 'wincmd p'
  execute 'edit ' . a:file
  call setpos('.', a:position)
endfunction

function! s:SetMappings() abort
  for s:mark in items(s:longmarks)
    let l:binding = s:mark[0]
    let [l:file, l:position] = s:mark[1]
    let open_call = ' :call <SID>GoToFile("' . l:file . '", ' . string(l:position) . ')'
    execute 'nnoremap <buffer> <silent>' . l:binding . l:open_call '<cr>'

    " dismiss buffer window with esc
    nnoremap <buffer> <silent> <Esc> :q<cr><c-w>p
  endfor
endfunction

function! longmarks#OpenMarksBuffer() abort
  let l:mappings = s:GetBufferContents()
  let l:size = len(l:mappings)
  if l:size == 0
    echo 'Please define at least one mapping'
  else
    execute 'botright ' . l:size . 'new +call\ setline(1,' . 'l:mappings' . ')'
    call s:ConfigureBuffer()
    call s:SetMappings()
  endif
endfunction

function! longmarks#AddMark() abort
  let l:mappings = {}
  let l:binding = input('Enter mapping:')

  if l:binding ==? ''
    redraw
    echo "Mapping shouldn't be empty string"
    return
  endif

  let l:file = expand('%:p')
  let l:position = getpos('.')
  let l:mappings[l:binding] = [l:file, l:position]
  let s:longmarks = extend(s:longmarks, l:mappings)
endfunction

let s:longmarks = s:LoadMarks()
