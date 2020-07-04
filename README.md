# vim-longmarks

Vim plugin which emulates marks for multikey mappings.

## Overview

Please note that You have to define own mappings in order
to use plugin.

For example:

To add new marks:
`nnoremap <leader>m :LongMarksAddMark<cr>`

To jump to mark:
`nnoremap <leader>g :LongMarksGoTo<cr>`

If you want to save marks between editor sessions
define additional variable for session file. Session file
uses `JSON` format. For instance:

`let g:longmarks_session_path=longmarks_session.json`

For additional informationn please consult (docs)[docs/longmarks.txt].