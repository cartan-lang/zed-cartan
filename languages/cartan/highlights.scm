; Generic patterns first, specific ones after: where two patterns match
; one node the later wins, so a registry constructor outranks the plain
; call it is also an instance of.

(comment) @comment

(string) @string
(triple_string) @string
(number) @number
(boolean) @boolean

; `none` — the None unit kind's sole value (builtins.md R50), dressed
; as the truth literals are
(none) @boolean

; ---------------------------------------------------------------------
; keywords and operators
; ---------------------------------------------------------------------

[
  "use"
  "as"
  "port"
  "state"
  "fiber"
  "every"
  "while"
  "with"
  "but"
  "if"
  "then"
  "else"
  "for"
  "each"
  "in"
  "fold"
  "reduce"
] @keyword

; controls are heads, not keywords (user's ruling, 2026-08-16): `tap`
; is a token only because its juxtaposed writes needed the grammar's
; help, so it takes the capture every other control takes
(tap_expression "tap" @type)

[
  "and"
  "or"
  "not"
] @keyword.operator

[
  "+"
  "-"
  "*"
  "/"
  "^"
  "@"
  "=="
  "!="
  "<"
  "<="
  ">"
  ">="
  "="
  ".."
  "..="
] @operator

; the two arrows that are not operators over values: a write and a local
[
  "<-"
  ":="
] @keyword.operator

; the mark and the prime — the call-site derivative (builtins.md R42)
(primes) @operator
(mark) @operator

; the argument mark — this slot may be absent (builtins.md R55)
(absent_expression "?" @operator)

[
  "("
  ")"
  "["
  "]"
  "{"
  "}"
] @punctuation.bracket

[
  ","
  ":"
  "."
] @punctuation.delimiter

; ---------------------------------------------------------------------
; names
; ---------------------------------------------------------------------

(identifier) @variable

; `fig.panel` — the namespace a `use` bound, and the name inside it.
; The `as` of the `use` line draws the same way, as a port declaration
; draws the way a write to that port does.
(use_declaration alias: (identifier) @namespace)
(qualified_identifier namespace: (identifier) @namespace)

; a call head, before the registry says which kind it is
(call_expression function: (identifier) @function)
(call_expression function: (qualified_identifier name: (identifier) @function))

; a function's own name and its parameters
(function_definition name: (identifier) @function)
(parameter name: (identifier) @variable)

; ports are the durable surface: their declarations and every write
(port_declaration name: (identifier) @variable.special)

; a product fiber is a type: its name where it is declared and where
; it constructs, its components as properties, and a projection's
; name likewise (R:product-fiber)
(fiber_declaration name: (identifier) @type)
(component name: (identifier) @property)
(product_component name: (identifier) @property)
(fiber_type name: (identifier) @type)
; a parameter's type annotation reads in the same grammar, and its
; alternative — the `None` kind (wishlist item 71, R:absence-value) —
; is a fiber type of its own, painted by the pattern above
(type_annotation alternative: (fiber_type name: (identifier) @type))
(projection_expression name: (identifier) @property)

(write target: (port_path (identifier) @variable.special))

; configuration keys, which are the only names a call zone carries
(map_entry key: (identifier) @property)

; a body local, erased at elaboration
(local name: (identifier) @variable)

; a body's own transient port, which the evaluator names per occurrence
(state_local name: (identifier) @variable.special)

; ---------------------------------------------------------------------
; the registry (src/views.rs) and the builtins (src/eval.rs)
; ---------------------------------------------------------------------

; utility functions. This set and the three below are the registry and
; the dispatch table as `cartan emit api` reports them; regenerate
; against that dump rather than against memory, and
; `crates/conformance/tests/docs.rs` holds the two to each other.
((call_expression function: (identifier) @function.builtin)
 (#any-of? @function.builtin
  "array" "concat" "append"
  "reshape" "flatten" "transpose" "swapaxes" "shape" "len"
  "site" "space" "start" "upper" "shift"
  "interior" "exterior" "partition" "tile" "rel" "rebase"
  "sin" "cos" "tan" "asin" "acos" "atan" "atan2"
  "exp" "log" "log10" "sqrt" "abs"
  "sum" "mean" "min" "max" "clamp" "merge"
  "vec" "dot" "norm"
  "xextent" "yextent" "zextent"
  "extent" "pad" "width" "center" "frame" "ticks" "fmt"
  "join" "split" "slice" "trim" "lpad" "rpad"
  "contains" "starts_with" "ends_with"
  "load" "ray" "origin" "direction"
  "interp" "step" "rgb" "rgba" "oklch" "hex" "mix"
  "refuse"
  "complex" "re" "im" "conj" "arg"
  "rot" "inv"
  "mat" "diag" "det" "trace" "solve"
  "covec" "metric" "pull"))

; elements, canvases and layout — what a figure is made of
((call_expression function: (identifier) @constructor)
 (#any-of? @constructor
  "line" "area" "points" "segments" "labels" "marks"
  "span" "faces" "edges"
  "canvas1d" "canvas2d" "canvas3d" "text" "block"))

; the same names where the call takes no parens, so the name is written
; bare — a signature whose slots are all configuration, and a canvas
; that states its elements in a payload
((identifier) @constructor
 (#any-of? @constructor
  "block" "viridis"
  "canvas1d" "canvas2d" "canvas3d"))

; a name standing for the literal an author would have written. The
; imaginary unit is `complex(0.0, 1.0)` and `i` is an ordinary
; identifier, so the letter draws as whatever a document binds (R77).
((identifier) @constant.builtin
 (#any-of? @constant.builtin "pi"))

; controls — the interactive surface, named in the text or absent
((call_expression function: (identifier) @type)
 (#any-of? @type "scrub" "hover" "key" "wheel"))

; ---------------------------------------------------------------------
; reserved words under error recovery
; ---------------------------------------------------------------------

; A document that does not parse — one mid-edit, or a fence of notation
; rather than cartan — is read in tree-sitter's error recovery, and in
; that state a reserved word can lex as the grammar's word token,
; `identifier`, rather than as the token it names. Every pattern above
; matches on the node type, so all of them miss such a word and it
; draws as a plain name. The four below match on the text instead,
; which keeps a reserved word's color wherever it stands.
;
; `crates/cartan/src/lexer.rs` reserves every word listed here, so a
; document that elaborates never binds one as a name, a namespace or a
; configuration key, and these patterns change nothing a valid document
; draws. They are written as `#match?` alternations rather than
; `#any-of?` rosters because the builtin pin in
; `crates/conformance/tests/docs.rs` reads every `#any-of?` name in
; this file as a builtin; a second pin in that same test holds these
; four lists to the lexer's table.

((identifier) @keyword
 (#match? @keyword
  "^(use|as|port|state|fiber|every|while|with|but|if|then|else|for|each|in|fold|reduce)$"))

((identifier) @keyword.operator
 (#match? @keyword.operator "^(and|or|not)$"))

((identifier) @boolean
 (#match? @boolean "^(true|false|none)$"))

; `tap`, which takes the capture it takes on `tap_expression`
((identifier) @type
 (#match? @type "^(tap)$"))
