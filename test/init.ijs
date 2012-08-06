NB. =========================================================
NB. types/datetime
NB. Addon for extending the dates.ijs system script.
NB. Ric Sherlock, 2009 09 09
NB. Some of the verbs in this script were derived from 
NB. APL+Win functions written by Davin Church.

require 'dates dll strings numeric'
NB. require 'numeric'  NB. round is defined in numeric but is not yet in J7

coclass 'rgsdatetime'

NB. =========================================================
NB. Constants

NB.*J0Date n Add to J's dayno to get Julian dayno
NB.-note: Note that for astronomical use the start of a Julian day
NB.- is noon so for an accurate representation of a Julian day/time
NB.- combination 2378496.5 should be added instead.
J0Date=: 2378497

NB.*MS0Date n Add to Microsoft date to get a J dayno
NB.-note: Note that the first date supported by Microsoft Excel is 1900 1 1
NB.- but dates between 1900 1 1 and 1900 1 28 will not convert properly
NB.- because Excel incorrectly denotes 1900 as a leap year, 
NB.- http://support.microsoft.com/kb/214326
MS0Date=: 36522 

NB.*Linux0DateTime n Add to Linux-style date to get a J dayno
Linux0DateTime=: 62091

WKDAYS=: ;:'Sunday Monday Tuesday Wednesday Thursday Friday Saturday'
MONTHS=: ''; ;:'January February March April May June July August September October November December'
DATECODES=: ;:'D DD DDD DDDD M MM MMM MMMM YY YYYY'
TIMECODES=: ;:'d h hh m mm s ss sss c cc ccc p pp'

