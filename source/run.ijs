NB. run
load '~Addons/docs/joxygen/joxygen.ijs'


NB. joxygenize '~Addons/docs/joxygen/test/simplescript.ijs'
NB.  ('~temp/joxydocs';'pdf') joxygenize '~Addons/docs/joxygen/test/simplescript.ijs'

simple=: <'~Addons/docs/joxygen/test/simplescript.ijs'

datetime=: <;._2 'init.ijs utils.ijs dayno.ijs '
datetime=: '~Addons/docs/joxygen/test/'&,each datetime

test=: datetime

raw=: ; readScripts_rgsjoxygen_ test
parsed=: parseJoxygen_rgsjoxygen_ raw

('~temp/datetime';'pdf') joxygenize test
