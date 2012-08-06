NB. =========================================================
NB. Utility verbs

NB. escaped v process an escaped string
NB. eg: '\' escaped '\Date is: D\\MM\\YYYY'
NB. result: 2-item list of boxed mask & string:
NB.          0{:: boolean mask of non-escaped characters
NB.          1{:: string with escape character compressed out
NB. y is: An escaped string
NB. x is: character used to escape string
escaped=: 3 : 0
  '\' escaped y                         NB. default escape char
:
  mskesc=. y = x
  mskfo=. 2 < /\ 0&, mskesc             NB. 1st occurences of x
  mskesc=. mskesc ([ ~: *.) 0,}: mskfo  NB. unescaped 1st occurences of x
  mskunescaped=. -. 0,}: mskesc         NB. unescaped characters
  (-.mskesc)&# &.> mskunescaped;y       NB. compress out unescaped x
)

NB. round v round y to nearest x (e.g. 1000 round 12345)
NB. from j602 numeric script (which is not yet available in j7)
round=: [ * [: <. 0.5 + %~

fmt=: 8!:0

