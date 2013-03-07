NB. =========================================================
NB. Main words for script

Note 'plan for whole addon'
Pass name of addon and scripts to parse.
Looks for manifest & reads it.
Appends manifest info to `raw` that is parsed to `writeJoxy`.
Also need ability to add free form sections (not named objects) to scripts.
)

NB.* v take addon path and creates docs from inline markup
NB.-result: writes docs, returns empty
joxygenizeAddon=: 3 : 0
 empty''
)

NB.* v Creates docs from inline markup in a list of scripts
NB.-result: Writes to document, returns empty.
joxygenize=: 3 : 0
 ('~temp/joxydocs';'raw') joxygenize y
 :
 NB. gets script(s)
 'outfn fmt'=. 2 {. boxopen x
 scriptnms=. boxopen y
 script=. ; readScripts scriptnms
 raw=. parseJoxygen script NB. parses script(s)
 select. fmt
   case. 'raw' do. raw writeJoxy outfn             NB. write raw docs to file
   case. 'pdf' do. raw writeJoxy_rgsjoxypdf_ outfn NB. write docs to pdf file using format/publish addon
   case. 'markdown' do. raw writeJoxy_rgsjoxymarkdown_ outfn
   NB. case. 'term' do. NB. output docs to terminal?
   case. do. echo 'This format is not currently supported.'
 end.
 empty''
)




NB.* v Check for valid documentation
checkValidDocs=: 3 : 0
 NB. last line in block contains assignment of name
 NB. doc name (if present) matches assigned name
 NB. mandatory parameters are:
 NB.   Type, Caption
 NB.  Verbs: y, result
 NB.  Adverbs: u
 NB.  Conjunction: one from each of n,u and m,v
 NB. optional parameters are:
 NB.    Description
)

joxygenize_z_=: joxygenize_joxygen_
