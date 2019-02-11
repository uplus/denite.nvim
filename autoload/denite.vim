"=============================================================================
" FILE: denite.vim
" AUTHOR: Shougo Matsushita <Shougo.Matsu at gmail.com>
" License: MIT license
"=============================================================================

function! denite#initialize() abort
  return denite#init#_initialize()
endfunction
function! denite#start(sources, ...) abort
  call inputsave()
  try
    let user_context = get(a:000, 0, {})
    return s:start(a:sources, user_context)
  finally
    call inputrestore()
  endtry
endfunction

" Statusline functions
function! denite#get_status(name) abort
  return !exists('b:denite_statusline') ? '' :
        \ get(b:denite_statusline, a:name, '')
endfunction
function! denite#get_status_mode() abort
  return denite#get_status('mode')
endfunction
function! denite#get_status_sources() abort
  return denite#get_status('sources')
endfunction
function! denite#get_status_path() abort
  return denite#get_status('path')
endfunction
function! denite#get_status_linenr() abort
  return denite#get_status('linenr')
endfunction

function! s:start(sources, user_context) abort
  if denite#initialize()
    return
  endif

  " Add current position to the jumplist.
  let pos = getpos('.')
  execute line('.')
  call setpos('.', pos)

  return denite#util#rpcrequest('_denite_start', [a:sources, a:user_context])
endfunction

function! denite#do_action(context, action_name, targets) abort
  return denite#util#rpcrequest('_denite_do_action',
        \ [a:context, a:action_name, a:targets])
endfunction
