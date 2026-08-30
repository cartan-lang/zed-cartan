; Each delimited node carries its own `@end`: Zed ends the match's
; indent range at the closing token it holds. A free-standing @outdent
; would instead truncate the innermost surviving range around the
; token — and a single-line `{ … }` or `[ … ]` contributes no range of
; its own, so its closer would eat into the enclosing body's.

(_ "(" ")" @end) @indent
(_ "[" "]" @end) @indent
(_ "{" "}" @end) @indent
