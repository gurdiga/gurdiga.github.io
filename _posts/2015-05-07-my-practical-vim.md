---
layout: post
title: My practical Vim
date: '2015-05-07T07:39:39+03:00'
tags:
- vim
---
Last night I have finished re-reading Drew Neil’s “Practical Vim” and I
gathered a whole lot of little things that I want to try, and include in
my workflow if they fit.

## Normal mode

1. {number}G — go to that line
2. @: — repeat the last ex-mode command
3. = — autoindent
4. g;/g, — navigate change list
5. gi — back to last insertion in insert mode

## Insert mode

1. <C-r>{register}, e. g. <C-r>0 to paste the text that I just yanked, as if it were being typed one character at a time; <C-r><C-p>0 inserts text literally.
2. <C-o>{any one normal mode command}
3. <C-r>=6+35<CR>
4. <C-x><C-f> — filename completion
5. <C-x><C-n> — current buffer keywords
6. <C-x><C-i> — included file keywords; see :h 'include'
7. <C-x><C-l> — whole line completion
8. <C-x><C-o> — omni-completion; see :h compl-omni-filetypes
9. <C-e> — revert to the originally typed text (exit  from autocompletion)
10. <C-n><C-p> — trick: The first command invokes autocomplete, summons the pop-up menu, and selects the first item in the word list. The second command selects the previous item in the word list, taking us back to where we started but without dismissing the pop-up menu. Now we can continue to type, and Vim will filter the word list in real time.
11. <C-n> — :h 'complete’
12. <C-r>/ — insert the last search pattern

## Visual mode

1. o — go to other end of highlighted text

## Ex commands

1. :setlocal makeprg=NODE_DISABLE_COLORS=1\ nodelint\ % — use this to not need jshint/csslint/tidty in every project¹.
2. <C-r>{register}
3. <C-r><C-w> — insert the word under cursor
4. read !ls -la — read the output from a shell command into the current buffer
5. %write !sort — pass the range to the shell command and insert into the current buffery
6. <C-f> mapping to switch to the command-line window, preserving a copy of the command that was typed at the prompt
7. :read !{cmd} — direct standard output into a buffer. As you might expect, the  :write !{cmd}  does the inverse—is this useful with pbcopy?
8. :2,$!sort — sort the lines in a given range
9. :argdo {ex cmd} — execute the ex command for all the files given as CLI args
10. :edit %:h<Tab> — is expanded to the full path of the current file’s directory
11. :w !sudo tee % > /dev/null — or maybe :w !sudo cat > % — write a file that needs sudo, for example /etc/hosts
12. :& — repeats the last :substitute command (see :h:&), the g& command is a handy shortcut
13. :vimgrep /<C-r>// \*/.txt
14. :global — check chapter 15 for thoughts on implementing code refactorings

## Windows

1. <C-w>\_ — maximize the current window

## General

1. runtime macros/matchit.vim — match opening and closing XML tags with %

## Finding files

1. :set path+=app/**
2. :find ticket<Tab>

## Search

1. /\Vverbatim text — except / and \

## Check

1. :h digraph-table
2. :h motion.txt
3. :h text-objects
4. :h function-list
5. :h :s_flags
6. :h g&
7. :h popupmenu-completion
8. :grep -i Waldo *
9. :h option-list
10. :h filename-modifiers

¹ Some time ago I was wondering how should I set my linting system: I
considered a separate repository with makefiles, a separate npm package
on GitHub, even looked at other editors and IDEs. The :make and :compile
in Vim seem to be a promising option. =]

:make, :compile, and :grep act as a level of abstraction and lets you
change the underlying tools without having to also change editing
habits.
