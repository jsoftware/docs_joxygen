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
NB. =========================================================
NB. application specific utils

readScripts=:  'b'&freads each

writeJoxy=: ;@[ writecsv '.joxy' ,~ ] NB. force suffix to .joxy
readJoxy=: [: (((<'name') = {."1) <;.1 ]) readcsv

NB. v Checks that name is assigned in sentence
chkAssign=: ((<'=:')&e.)@;:

NB. v Gets the first assigned name in a sentence
getAssignName=: ({~ (<'=:') <:@:i.~ ])@;:

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
NB. =========================================================
NB. Parsing

NB. v Parses Joxygen comments from a J script
parseJoxygen=: 3 : 0
 msk=. ((>JoxyCmt) e.~ ]) 4&{.&> y
 mskend=. 0, 2 >/\ msk 
 assgn=. y #~ 0, 2 >/\ msk
 blks=. (mskend <;.2 msk) #&.> mskend <;.2 y
 msk=. chkAssign&> assgn
 assgn=. msk # assgn
 blks=. msk # blks  NB. drop blocks where no name assigned in following line
 if. 0=#blks do. '' return. end.
 assert. assgn =&# blks
 assgn;<blks
 assgn parseNameBlk each blks
)

NB. v Parses a block associated with a name
NB. y: boxed blocks of documentation
NB. x: boxed assignment lines for documentation blocks
parseNameBlk=: 4 : 0
 nme=. getAssignName &> boxopen x
 'type caption'=. parseTypeCaption getTypeCaption y
 tmp=. y #~ -. mskTypeCaption y
 tags=. (4 }. ' '&taketo) each tmp
 msk=. (0 < #)&> tags
 tags=. (}: , ':' -.~ {:)&.> msk # tags  NB. drop trailing ':' from tag
 assert. tags e. Tags
 cnt=. ' '&takeafter each tmp
 cnt=. LF&joinstring&.> msk <;.1 cnt
 NB. all groups of lines start with a valid tag name and
 NB. end before another line with a valid tag name
 NB. join groups of lines together
 NB. change to the following later??
 NB. 1st group of lines followed by empty line is Description
 NB. 2nd group of lines followed by empty line is Details
  
 tags=. ('name';'type';'caption'),tags
 cnt=. nme,(type;caption),boxxopen cnt
 tags,.cnt
)

NB. v Creates boolean mask of items containing Type and Captions entries
mskTypeCaption=: (<JoxyHdr) = 4&{.&.>

NB. v Gets the line containing the (name), type and caption from a block
getTypeCaption=: ;@(#~ mskTypeCaption)

NB. v parse type and caption from line containing (name), type and caption
NB. result: type;caption
parseTypeCaption=: 3 : 0
 tmp=. ' '&takeafter y
 (' '&taketo ; ' '&takeafter) tmp
)
NB. =========================================================
NB. Markdown output for use with PanDoc

coclass 'rgsjoxymarkdown'
coinsert 'joxygen'

writeJoxy=: 4 : 0
 txt=. LF&joinstring makeWordSection each x
 txt=. Head,txt
 txt fwrites y,'.txt' NB. create input files for format/publish 
 NB. 2!:0 'pandoc -f markdown -o ',(jpath '~temp/mymarkdown.pdf'),' ', jpath '~temp/mymarkdown.txt'
)

Head=: 0 : 0
% J topics documented 
)

NB. v Creates section of text markup for a Word
makeWordSection=: 3 : 0
 tbl=. y #~ ({."1 y) e. Tags
 tbl=. processContent tbl
 msk=. Tags e. {."1 tbl
 tmpl=. msk # Word_tmpl
 tmpl=. ;({. , (<tmpl_typecaption) , 3&}.) tmpl
 srch=. ('<%' , ,&'%>') each {."1 tbl
 tmpl rplc , srch ,. {:"1 tbl  
)

NB. v Makes changes to some content to display better
processContent=: 3 : 0
 tbl=. y
 idx=. tbl getidx 'type' NB. replace type letters with names
 tbl=. (TypeNames {~ Types i. (<idx;1){tbl) (<idx;1)}tbl
NB.  if. (<,'x') e. {."1 tbl do. 
NB.    idx=. tbl getidx ,'x' NB. insert </br> where likely required in y,x,result
NB.    tbl=. (<((LF,'  ');'<br/>') stringreplace (<idx;1){::tbl) (<idx;1)}tbl 
NB.  end.
)

getidx=: ({."1@[ i. boxopen@])
getval=: ({:"1@[ {~ getidx)

tmpl_name=: 0 : 0

## <%name%> *<%type%>*##
)

tmpl_typecaption=: 0 : 0
<%caption%>
)

tmpl_descrip=: 0 : 0

### Description ###
<%descrip%>
)

tmpl_note=: 0 : 0

### Note ###
<%note%>
)

tmpl_usage=: 0 : 0

### Usage ###
~~~
<%usage%>
~~~
)

tmpl_y=: 0 : 0

### Right Argument (*y*) ###
<%y%>
)

tmpl_x=: 0 : 0

### Left Argument (*x*) ###
<%x%>
)

tmpl_m=: 0 : 0

### m ###
<%m%>
)
tmpl_n=: 0 : 0

### n ###
<%n%>
)
tmpl_u=: 0 : 0

### u ###
<%u%>
)
tmpl_v=: 0 : 0

### v ###
<%v%>
)

tmpl_result=: 0 : 0

### Result ###
<%result%>
)

tmpl_author=: 0 : 0

### Author(s) ###
<%author%>
)

tmpl_seealso=: 0 : 0

### See Also ###
<%seealso%>
)
tmpl_eg=: 0 : 0

### Examples ###
~~~
<%eg%>
~~~
)

Word_tmpl=: ([: ". 'tmpl_'&,) each Tags

NB. =========================================================
NB. PDF output using format/publish

require 'format/publish'
coclass 'rgsjoxypdf'
coinsert 'joxygen'

writeJoxy=: 4 : 0
 txt=. LF&joinstring makeWordSection each x
 txt=. Head,txt
 txt fwrites y,'.txt' NB. create input files for format/publish 
 publish jpath y,'.txt' NB. run format/publish to create PDF
)

Head=: 0 : 0
<toc align=center, tocalign=right, toclevel=1>J topics documented:</toc>

)

NB. v Creates section of text markup for a Word
makeWordSection=: 3 : 0
 tbl=. y #~ ({."1 y) e. Tags
 tbl=. processContent tbl
 msk=. Tags e. {."1 tbl
 tmpl=. msk # Word_tmpl
 tmpl=. ;({. , (<tmpl_typecaption) , 3&}.) tmpl
 srch=. ('<%' , ,&'%>') each {."1 tbl
 tmpl rplc , srch ,. {:"1 tbl  
)

NB. v Makes changes to some content to display better
processContent=: 3 : 0
 tbl=. y
 idx=. tbl getidx 'type' NB. replace type letters with names
 tbl=. (TypeNames {~ Types i. (<idx;1){tbl) (<idx;1)}tbl
 if. (<,'x') e. {."1 tbl do. 
   idx=. tbl getidx ,'x' NB. insert </br> where likely required in y,x,result
   tbl=. (<((LF,'  ');'<br/>') stringreplace (<idx;1){::tbl) (<idx;1)}tbl 
 end.
)

getidx=: ({."1@[ i. boxopen@])
getval=: ({:"1@[ {~ getidx)

tmpl_name=: 0 : 0
<h1><%name%></h1>
)

tmpl_typecaption=: 0 : 0
<%type%>:  <%caption%>
)

tmpl_descrip=: 0 : 0
<h2>Description</h2>
<%descrip%>
)

tmpl_note=: 0 : 0
<h2>Note</h2>
<para><%note%></para>
)

tmpl_usage=: 0 : 0
<h2>Usage</h2>
<pre><%usage%></pre>
)

tmpl_y=: 0 : 0
<h2>Right Argument (y)</h2>
<%y%>
)

tmpl_x=: 0 : 0
<h2>Left Argument (x)</h2>
<%x%>
)

tmpl_m=: 0 : 0
<h2>m</h2>
<%m%>
)
tmpl_n=: 0 : 0
<h2>n</h2>
<%n%>
)
tmpl_u=: 0 : 0
<h2>u</h2>
<%u%>
)
tmpl_v=: 0 : 0
<h2>v</h2>
<%v%>
)

tmpl_result=: 0 : 0
<h2>Result</h2>
<para><%result%></para>
)

tmpl_author=: 0 : 0
<h2>Author(s)</h2>
<para><%author%></para>
)

tmpl_seealso=: 0 : 0
<h2>See Also</h2>
<%seealso%>
)
tmpl_eg=: 0 : 0
<h2>Examples</h2>
<pre><%eg%></pre>
)

Word_tmpl=: ([: ". 'tmpl_'&,) each Tags

 
NB. define paragraph styles for format/publish
