NB. run
load '~Addons/docs/joxygen/joxygen.ijs'


NB. joxygenize '~Addons/docs/joxygen/test/simplescript.ijs'
NB.  ('~temp/joxydocs';'pdf') joxygenize '~Addons/docs/joxygen/test/simplescript.ijs'

simple=: <'~Addons/docs/joxygen/test/simplescript.ijs'

test0=: <;._2 'init.ijs utils.ijs dayno.ijs '
test0=: '~Addons/docs/joxygen/test/'&,each test0

test1=: <'~Addons/types/datetime/datetime.ijs'
test2=: <'~Addons/docs/joxygen/joxygen.ijs'

raw=: ; readScripts_joxygen_ test0
parsed=: parseJoxygen_joxygen_ raw

ferase '~temp/datetime.joxy';'~temp/datetime.pdf';'~temp/datetime_markdown.txt'

('~temp/datetime';'raw') joxygenize test1
('~temp/datetime';'pdf') joxygenize test1
('~temp/datetime_markdown';'markdown') joxygenize test1
('~temp/simple';'markdown') joxygenize simple
('~temp/joxygen_markdown';'markdown') joxygenize test2


Note 'run pandoc'
.cabal/bin/pandoc -f markdown -o ~/j64-701-user/temp/datetime_markdown.pdf ~/j64-701-user/temp/datetime_markdown.txt
)
