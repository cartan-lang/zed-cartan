; A triple-quoted literal holds prose (spec §2.1), so its contents are
; set in markdown: the document's doc string above all, and any string
; written in the form the language provides for prose. The delimiters
; stay the language's — the content node is a leaf holding the text alone, and it
; is what the injection covers.

((triple_string_content) @injection.content
 (#set! injection.language "markdown"))
