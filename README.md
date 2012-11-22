# Expgen

Expgen solves a very simple problem: Given a regular expression, find a string
which matches that regular expression. Use it like this:

``` ruby
Expgen.gen(/foo\w+b[a-z]{2,3}/) # => "fooxbdp"
```

For a full list of supported syntax, see the spec file.

Some things are really difficult to generate accurate expressions for, it's
even quite easy to create a regexp which matches *no* strings. For example
`/a\bc/` will not match any string, since there can never be a word boundary
between characters.

The following is a list of things Expgen does *not* support:

- Anchors (are ignored)
- Lookaheads and lookbehinds
- Subexpressions
- Backreferences

# License

MIT, see separate LICENSE.txt file
