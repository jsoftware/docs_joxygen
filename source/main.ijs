NB. =========================================================
NB. Main words for script

NB.* v take list of scripts and creates docs from inline markup
NB.-result: writes PDF document, returns empty
NB.! add option to input filename of joxygenized 
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
 case. 'pdf' do. raw writeJoxy_rgsjoxypdf_ outfn NB. write docs to pdf file
 NB. case. 'term' do. NB. output docs to terminal?
 case. do. echo 'This format is not currently supported.'
 end.
 NB. outputs publish markup
 NB. runs format/publish to create PDF
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
