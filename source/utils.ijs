NB. =========================================================
NB. application specific utils

readScripts=:  'b'&freads each

writeJoxy=: ;@[ writecsv '.joxy' ,~ ] NB. force suffix to .joxy
readJoxy=: [: (((<'name') = {."1) <;.1 ]) readcsv

NB. v Checks that name is assigned in sentence
chkAssign=: ((<'=:')&e.)@;:

NB. v Gets the first assigned name in a sentence
getAssignName=: ({~ (<'=:') <:@:i.~ ])@;:

