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
