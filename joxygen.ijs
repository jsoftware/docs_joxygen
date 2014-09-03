NB. init

NB.* n body tags (NTC are required, desc follows this)
NB. in order of presentation
NTC=: ;:'name type caption'
Tags=: ;:'syntax example note'
TagNames=: ;:'Syntax Example Note'

NB. n types
Types=: 'acvmdn'
TypeNames=: ;:'adverb conjunction verb monad dyad noun'
NB. util

h0=: '% '&, @ (,&LF2)
h1=: '# '&, @ (,&LF2)
h2=: '## '&, @ (,&LF2)
h3=: '### '&, @ (,&LF2)
tr=: '<tr>'&, @ (,&('</tr>',LF))

NB. markdown anchor
anchor=: '[' , ] , '](#' , ,&')'

NB. markdown anchor script
anchorscript=: '[' , ] , '](' , ,&'.htm)'@(i.&'.' {. ])

NB. first 1's in mask
firstones=: > |.!.0

NB. apply verb with mask, preserving header
fmask=: 1 : (':';'((x i. 1) {. y),;x <@u;. 1 y')

NB. add LF2 if nonempty
lf2sep=: , LF2 #~ 0<#

NB. separate names in map:
mapsep=: 2 }. ;@:(', '&,&.>)

NB. remove trailing whitespace
remtws=: #~ [: (+./\.) -.@(e.&(' ',TAB))

NB. add '.' if needed
termstop=: ,'.'-.{:

NB. uppercase first letter
upper1=: toupper@{. , }.

NB. =========================================================
NB. add desc to definition
adddesc=: 3 : 0
if. -. (<'desc') e. {."1 y do.
  y=. (3{.y),('desc';upper1 termstop (<2 1) pick y),3}.y
end.
y
)

NB. =========================================================
NB. cleanentry
NB. argument is boxed list of lines
NB. remove leading, trailing empty lines
NB. returns text string. not LF terminated
cleanentry=: 3 : 0
dat=. y #~ (*./\b) +: *./\.b=. 0=#&> y
}: ; dat ,each LF
)

NB. =========================================================
fixblocks=: 3 : 0
len=. 0 i.~ (4<#&>y) *. (<'NB.- ') = 5 {.each y
t=. ('NB.-|' , 4&}.) each len{.y
t=. (<'NB.-')([,],[) t
t,len}.y
)

NB. =========================================================
fixcontinue=: 3 : 0
if. 0=#y do. '' return. end.
b=. firstones (4<#&>y) *. (<'NB.- ') = 5 {.each y
t=. b fixblocks fmask y
b=. firstones (<'NB.+') = 4 {.each t
b fixverbatim fmask t
)

NB. =========================================================
fixverbatim=: 3 : 0
len=. 0 i.~ (<'NB.+') = 4 {.each y
cmt=. <'NB.+~~~'
cmt,(len{.y),cmt,len}.y
)

NB. =========================================================
getassigns=: 3 : 0
txt=. ; y ,each LF
rx=. Rxnna_jregex_,'([[:alpha:]][[:alnum:]_]*) *=:'
hit=. rx rxmatches txt
if. 0=#hit do. '' return. end.
({:"2 hit) rxfrom txt
)

NB. =========================================================
hdef=: 3 : 0
'name type'=. y
'## ',name,' (',(>TypeNames {~ Types i.type),') ## {.hdef #',name,'}',LF2
)

NB. =========================================================
NB. nbsp: replace spaces
nbsp=: 3 : 0
n=. (y=' ') i. 0
(;n#<'&nbsp;'), n}. y
)

NB. =========================================================
NB. chop: NB.*foo n some text
splithdr=: 3 : 0
y=. 4}.y
x=. y i. ' '
nam=. x {. y
y=. dlb (x+1) }. y
typ=. {. y
assert. typ e. Types
cap=. dltb }.y
nam;typ;cap
)

NB. =========================================================
NB. chop: scriptid - script desc
splitname=: 3 : 0
x=. y i. '-'
(dltb x {. y);dltb (x+1) }. y
)
NB. main

NB. =========================================================
makedocs=: 3 : 0
dat=. makedoc1 each Files
hdr=. 0 {:: each dat
scp=. makescripts hdr
nms=. }. each dat
ndx=. /: tolower each 0 {:: each nms
hdr=. ndx{hdr
nms=. ndx{nms
lnk=. ; hdr makelink each nms
nms=. ;nms
ndx=. /: tolower each nms
lnk=. ndx{lnk
nms=. ndx{nms
map=. makemap nms;<lnk
r=. IndexHdr,LF2
r=. r,scp,map
m=. jpath '~temp/joxygen.md'
h=. jpath '~temp/joxygen.htm'
r fwrite m
shell 'pandoc ',m,' -c "joxygen.css" -f markdown-auto_identifiers -o ',h
(freads h) fwritenew Target,'/index.htm'
)

NB. =========================================================
makedoc1=: 3 : 0
smoutput y
txt=. 'b' fread Source,'/',y
dat=. parse txt
makescript dat
hdr=. 0 pick dat
hdr=. splitname (hdr i. LF){.hdr
hdr;(<0 1){:: each }.dat
)

NB. =========================================================
makelink=: 4 : 0
s=. (i.&'.' {.]) 0 pick x
'[' ,each y ,each (<'](',s,'.htm#') ,each y ,each ')'
)

NB. =========================================================
makerefs=: 3 : 0
ndx=. y i.&>']'
lnk=. (ndx+2)}.each }:each y
; lnk ,each LF
)

NB. =========================================================
makescripts=: 3 : 0
a=. anchorscript each {.&>y
b=. {:&>y
r=. h2 'Scripts'
a=. '<td class="noun">'&, each a ,each <'</td>'
b=. '<td class="noun">'&, each b ,each <'</td>'
c=. ;tr each a,each b
r,'<table class="noun">',c,'</table>',LF2
)
NB. parse

NB. =========================================================
NB. parse script
NB. return boxed list:  header,defs
parse=: 3 : 0
dat=. remtws each y
cmt=. 4{.each dat
ndx=. cmt i. <'NB.%'
assert. ndx<#dat
len=. 1 + +/ *./\ (ndx+1) }. cmt e. 'NB.-';'NB.+'
hdr=. cleanentry 4}.each fixcontinue len{.ndx}.dat
msk=. (4{.each dat)=<'NB.*'
dat=. parse1 each msk <;.1 dat
nms=. (<0 1)&{:: each dat
nms=. nms -. getassigns y
if. #nms do.
  smoutput 'names documented but not assigned:',;' ',each nms
end.
(<hdr),dat
)

NB. =========================================================
parse1=: 3 : 0
r=. NTC ,. splithdr 0 pick {.y
y=. }.y
y=. y #~ *./\ (4{.each y) e. 'NB.-';'NB.+'
y=. 4 }.each fixcontinue y
msk=. y e. Tags,each ':'
desc=. cleanentry (msk i.1) {. y
r=. r,'desc';desc
r=. r,parsetag &> msk <;.1 y
r #~ 0<#&>{:"1 r
)

NB. =========================================================
parsetag=: 3 : 0
hdr=. 0 pick y
ndx=. hdr i.':'
tag=. ndx{.hdr
bal=. cleanentry }. y
tag;bal
)
NB. script

NB. =========================================================
makedefs=: 3 : 0
; makedef1 each y
)

NB. =========================================================
makedef1=: 3 : 0
r=. hdef 2 {. {:"1 y
r=. r, ; makedef2 "1 [ 3}.y
)

NB. =========================================================
makedef2=: 3 : 0
'id txt'=. y
if. id-:'desc' do.
  hdr=. ''
else.
  hdr=. h3 >TagNames {~ Tags i. <id
end.
<hdr,txt,LF2
)

NB. =========================================================
makelibhtm=: 3 : 0
)

NB. =========================================================
makemap=: 3 : 0
r=. h2 'Definitions'
'nms anchors'=. y
key=. toupper {.&> nms
nms=. mapsep each key </. anchors
key=. ~. key
a=. '<td class="key">'&, each key ,each <'</td>'
b=. '<td>'&, each nms ,each <'</td>'
c=. ;tr each a ,each b
r, '<table class="map">',c,'</table>',LF2
)

NB. =========================================================
makeonelines=: 3 : 0
if. 0=#y do. '' return. end.
r=. '<hr>'
t=. >(3{.{:"1) each y
v=. 0{"1 t
a=. '<td id="'&, each v ,each '" class="rid">'&, each v ,each <'</td>'
b=. '<td class="rtype">'&, each (1{"1 t) ,each <'</td>'
c=. '<td class="rdef">'&, each (2{"1 t) ,each <'</td>'
d=. ;tr each a ,each b ,each c
r,'<table class="rdef">',d,'</table>'
)

NB. =========================================================
makepost=: ]

NB. =========================================================
makescript=: 3 : 0
hdr=. <;._2 LF ,~ 0 pick y
id=. 0 pick splitname 0 pick hdr
nam=. (id i.'.') {. id
dat=. }. y
nms=. (<0 1){::each dat
ndx=. /:tolower each nms
dat=. ndx{dat
nms=. ndx{nms
typ=. ;(<1 1){::each dat
r=. h0 id
r=. r,lf2sep ; (}.hdr) ,each LF
r=. r,makemap nms;<anchor each nms
msk=. 3 = #&> dat
r=. r,makeonelines msk#dat
r=. r,makedefs adddesc each (-.msk)#dat
m=. jpath '~temp/joxygen.md'
h=. jpath '~temp/joxygen.htm'
r fwrite m
shell 'pandoc ',m,' -c "joxygen.css" -f markdown-auto_identifiers -o ',h
(freads h) fwritenew Target,'/',nam,'.htm'
)
