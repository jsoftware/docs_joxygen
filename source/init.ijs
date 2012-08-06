NB. init
require 'tables/csv'

coclass 'rgsjoxygen'

NB. n Valid tags for joxygen comments
NB. descrip The order of tags in Tags is order they appear in docs
Tags=: ;:'name type caption descrip note usage y x m n u v result author seealso eg'

NB. n Valid types for words in joxygen
Types=: ;:'a c v m d n' 
TypeNames=: ;:'adverb conjunction verb monad dyad noun'
