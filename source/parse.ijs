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
  tags=. }:&.> msk # tags
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
