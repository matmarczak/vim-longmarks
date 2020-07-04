let s:suite = themis#suite('Longmarks test suite')
let s:assert = themis#helper('assert')

let s:scope = themis#helper('scope')
let s:longmarks_funcs = s:scope.funcs('autoload/longmarks.vim')
let s:longmarks_vars = s:scope.vars('autoload/longmarks.vim')


function! s:suite.before()
  let g:longmarks_session_path='longmarks.json'
endfunction

function! s:suite.before_each()
  " reset declared marks
  let s:longmarks_vars.longmarks = {}
endfunction

function! s:suite.test_save_mappings()
  call s:longmarks_funcs.SaveMarks()

  " check if file exists
  call s:assert.true(filereadable(g:longmarks_session_path))

  " check file has one line
  let l:file_length = len(readfile(g:longmarks_session_path))
  call s:assert.equals(l:file_length, 1)

  call delete(g:longmarks_session_path)
endfunction

function! s:suite.test_add_mark()
  call feedkeys("foo\<cr>")
  call longmarks#AddMark()
  call s:assert.equals(keys(s:longmarks_vars.longmarks), ['foo'])
endfunction

function! s:suite.test_add_empty_mark_fails()
  call feedkeys("\<cr>")
  call longmarks#AddMark()
  call s:assert.equals(len(s:longmarks_vars.longmarks), 0)
endfunction

function! s:suite.test_scenario_add_mark_and_goto()
  " Primary usecase

  " set up
  let l:filename = 'test_buffer.vim'
  let l:mapping = 'foo'
  execute 'write! ' . l:filename

  " add mark then go to
  call feedkeys(l:mapping . "\<cr>")
  LongMarksAddMark
  edit other_file.vim
  LongMarksGoTo
  execute 'normal ' . l:mapping

  " check mark added
  call s:assert.equals(len(s:longmarks_vars.longmarks), 1)
  call s:assert.equals(['foo'], keys(s:longmarks_vars.longmarks))

  " jump to defined file
  let l:saved_filename = fnamemodify(s:longmarks_vars.longmarks.foo[0], ':t')
  let l:current_buffer_filename = expand('%:t')
  call s:assert.equals(l:saved_filename, l:current_buffer_filename)

  " cleanup
  call delete(l:filename)
endfunction
