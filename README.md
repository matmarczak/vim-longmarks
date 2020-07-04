# vim-longmarks

Vim plugin which emulates marks for multikey mappings.

[![Build Status](https://travis-ci.org/matmarczak/vim-longmarks.svg?branch=master)](https://travis-ci.org/matmarczak/vim-longmarks)

## Overview

Please note that you have to define your own mappings in order
to use the plugin.

For example:

To add new marks:
`nnoremap <leader>m :LongMarksAddMark<cr>`

To jump to mark:
`nnoremap <leader>g :LongMarksGoTo<cr>`

If you want to save marks between editor sessions
define additional variable for session file. Session file
uses `JSON` format. For instance:

`let g:longmarks_session_path='longmarks_session.json'`

For additional informationn please consult [docs](doc/longmarks.txt).
