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

