syntax region MarkdownLink start=/\[\[/ms=e+1 end=/\]\]/me=s-1 oneline
highlight link MarkdownLink Underlined

syntax region MarkdownBold start=/\*\*/ end=/\*\*/
highlight link MarkdownBold String

syntax region MarkdownHighlight start=/==/ end=/==/
highlight link MarkdownHighlight TODO
