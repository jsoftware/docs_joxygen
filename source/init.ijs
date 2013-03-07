NB. =========================================================
NB.% docs/joxygen - Generate documentation from commented J source
NB.% Ric Sherlock
NB.% 2013-03-03

NB. init
require 'tables/csv'

coclass 'joxygen'

NB.* n Valid tags for joxygen comments
NB.-descrip: The order of tags in Tags is order they appear in docs.
Tags=: ;:'name type caption descrip note usage y x m n u v result author seealso eg'

NB. n Valid types for words in joxygen
Types=: ;:'a c v m d n' 
TypeNames=: ;:'adverb conjunction verb monad dyad noun'

NB. n Comment syntax 
JoxyTitle=: 'NB.%'
JoxyHdr=: 'NB.*'
JoxyBdy=: 'NB.-'
JoxyCmt=: JoxyTitle;JoxyHdr;JoxyBdy
