NB. Title:
NB. Author:
NB.

NB.*Foo v This is the short caption for foo
NB.-descrip: This is a description of the verb Foo
NB.- it can continue over multiple lines
NB.-note: This is extra details for Foo
NB.-y: 
NB.-result:
NB.-eg:
NB.-author: 
NB.-seealso:
Foo=: 4 : 0
 t=. *: y
 x + t
)

NB.* v This is the short Caption
NB.-descrip: This is a description of the name Bar
NB.- 
NB.- This is extra details for Bar
NB.-y:
NB.-x:
NB.- 
NB.-result:
NB.-eg:
NB.-author:
NB.-seealso: 
Bar=: + *:

NB.* a Caption
NB.-descrip: This is a description of the adjective
NB.- 
NB.-note: This is extra details for myadverb
NB.- including an additional line
NB.-usage:
NB.-y: literal list
NB.-x: boolean switch (optional) 
NB.-u: verb to be modified
NB.-result: Something swish!
NB.-eg: pattern=: 'a.b'
NB.- strings=: 'abb';'a.b'
NB.- pattern myadverb strings
NB.-author:
NB.-seealso: 
myadverb=: 4 : 0
 t=. *: y
 x + t
)

NB. v Caption
NB. This does something don't document
NB. eg: my multiline example
NB. not to document
