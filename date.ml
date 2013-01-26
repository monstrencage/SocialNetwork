  (**************************************************************************)
  (*  SocialNetwork : a highly functionnal library for social combinators.  *)
  (*                                                                        *)
  (*  Author(s):  Paul Brunet                                               *)
  (*                                                                        *)
  (*  This library is free software: you can redistribute it and/or modify  *)
  (*  it under the terms of the GNU Lesser General Public License as        *)
  (*  published by the Free Software Foundation, either version 2 of the    *)
  (*  License, or (at your option) any later version.  A special linking    *)
  (*  exception to the GNU Lesser General Public License applies to this    *)
  (*  library, see the LICENSE file for more information.                   *)
  (**************************************************************************)

open Unix	

type t = Unix.tm

let sec d = d.tm_sec

let min d = d.tm_min

let hour d = d.tm_hour

let day d = d.tm_mday

let mon d = d.tm_mon + 1

let year d = d.tm_year + 1900

let now () = (Unix.gmtime(Unix.gettimeofday())) 

let origin = 
  (snd (Unix.mktime { 
    Unix.tm_sec = 0;
    tm_min = 0;
    tm_hour = 0;
    tm_mday = 0;
    tm_mon = 0;
    tm_year = 0;
    tm_wday = -1;
    tm_yday = -1;
    tm_isdst = true; 
  }))

let from_string s=
  let r1 = Str.regexp "\\([0-9][0-9][0-9][0-9]\\)-\\([0-9][0-9]\\)-\\([0-9][0-9]\\)T\\([0-9][0-9]\\):\\([0-9][0-9]\\):\\([0-9][0-9]\\)\\+\\([0-9][0-9][0-9][0-9]\\)"
  and r2 = Str.regexp "\\([0-9][0-9]\\)/\\([0-9][0-9]\\)/\\([0-9][0-9][0-9][0-9]\\)"
  and r3 = Str.regexp "\\([0-9][0-9]\\)/\\([0-9][0-9]\\)"
  in
  if (Str.string_match r1 s 0)
  then 
    (snd (Unix.mktime { 
      Unix.tm_sec = int_of_string (Str.matched_group 6 s);
      tm_min = int_of_string (Str.matched_group 5 s);
      tm_hour = int_of_string (Str.matched_group 4 s);
      tm_mday = int_of_string (Str.matched_group 3 s);
      tm_mon = int_of_string (Str.matched_group 2 s) - 1;
      tm_year = int_of_string (Str.matched_group 1 s) - 1900;
      tm_wday = -1;
      tm_yday = -1;
      tm_isdst = true; (** Daylight time savings in effect *)
    }))
  else
    if (Str.string_match r2 s 0)
    then 
      (snd (Unix.mktime { 
	Unix.tm_sec = 0;
	tm_min = 0;
	tm_hour = 0;
	tm_mday = int_of_string (Str.matched_group 2 s);
	tm_mon = int_of_string (Str.matched_group 1 s) - 1;
	tm_year = int_of_string (Str.matched_group 3 s) - 1900;
	tm_wday = -1;
	tm_yday = -1;
	tm_isdst = true;
      }))
    else 
      if (Str.string_match r3 s 0)
      then 
	(snd (Unix.mktime { 
	  Unix.tm_sec = 0;
	  tm_min = 0;
	  tm_hour = 0;
	  tm_mday = int_of_string (Str.matched_group 2 s);
	  tm_mon = int_of_string (Str.matched_group 1 s) - 1;
	  tm_year = 0;
	  tm_wday = -1;
	  tm_yday = -1;
	  tm_isdst = true;
	}))
      else failwith ("unknown date format :"^s)
	
let double_digit i = 
  if i<10 
  then "0"^(string_of_int i)
  else (string_of_int i)		
    
let to_string t =
  ((double_digit (t.tm_mon+1))^"/"^
      (double_digit (t.tm_mday))^"/"^
      (string_of_int (t.tm_year+1900)))

let print t =
  ((double_digit (t.tm_mday))^"/"^
      (double_digit (t.tm_mon+1))^"/"^
      (string_of_int (t.tm_year+1900)))
    
let sec_to_string t= (to_string(Unix.gmtime t))

let now_to_string () = (sec_to_string (Unix.gettimeofday()))

let ndaysago n =
  let today = (Unix.gettimeofday())
  and ndays = ((float_of_int n) *. 24. *. 60. *. 60.)
  in
  Unix.gmtime(today -. ndays)
    
let nmonthsago n =
  let today = (now())
  in
  let rec aux n d=
    if (n<12)
    then
      if (n<=d.tm_mon)
      then 
	(snd (Unix.mktime { 
	  Unix.tm_sec = d.tm_sec;
	  tm_min = d.tm_min;
	  tm_hour = d.tm_hour;
	  tm_mday = d.tm_mday;
	  tm_mon = d.tm_mon - n;
	  tm_year = d.tm_year;
	  tm_wday = d.tm_wday;
	  tm_yday = d.tm_yday;
	  tm_isdst = d.tm_isdst;
	}))
      else
	(snd (Unix.mktime { 
	  Unix.tm_sec = d.tm_sec;
	  tm_min = d.tm_min;
	  tm_hour = d.tm_hour;
	  tm_mday = d.tm_mday;
	  tm_mon = 11 + d.tm_mon - n;
	  tm_year = d.tm_year - 1;
	  tm_wday = d.tm_wday;
	  tm_yday = d.tm_yday;
	  tm_isdst = d.tm_isdst;
	}))
    else
      aux (n-12) (snd (Unix.mktime { 
	Unix.tm_sec = d.tm_sec;
	tm_min = d.tm_min;
	tm_hour = d.tm_hour;
	tm_mday = d.tm_mday;
	tm_mon = d.tm_mon;
	tm_year = d.tm_year - 1;
	tm_wday = d.tm_wday;
	tm_yday = d.tm_yday;
	tm_isdst = d.tm_isdst;
      }))
  in (aux n today)
  
let a_week_ago () = (ndaysago 7)

let a_month_ago () = (nmonthsago 1)
  
let a_year_ago () = (nmonthsago 12)

let last_anniversary d =
  let today = (now())
  in
  if (d.tm_mon < today.tm_mon) or ((d.tm_mon = today.tm_mon) & (d.tm_mday <= today.tm_mday))
  then
    (snd (Unix.mktime {
      Unix.tm_sec = d.tm_sec;
      tm_min = d.tm_min;
      tm_hour = d.tm_hour;
      tm_mday = d.tm_mday;
      tm_mon = d.tm_mon;
      tm_year = today.tm_year;
      tm_wday = -1;
      tm_yday = -1;
      tm_isdst = d.tm_isdst;
    }))
  else
    (snd (Unix.mktime { 
      Unix.tm_sec = d.tm_sec;
      tm_min = d.tm_min;
      tm_hour = d.tm_hour;
      tm_mday = d.tm_mday;
      tm_mon = d.tm_mon;
      tm_year = today.tm_year-1;
      tm_wday = -1;
      tm_yday = -1;
      tm_isdst = d.tm_isdst;
    }))

let age d=
  let today = (now())
  in
  if ((print d)= "31/12/1899")
  then (-1)
  else (
    if (mon d <mon today) 
      or ((mon d=mon today) & (day d<= day today))
    then (year today- year d)
    else (year today- year d- 1))
    
let around d =
  let d=fst (Unix.mktime d)
  in
  Unix.localtime(d-. 24.*.60.*.60.),Unix.localtime(d+. 24.*.60.*.60.)
    
let (<<+) d1 d2 =
  ((year d1 < year d2) or
      ((year d1 = year d2) &
	  ((mon d1 < mon d2) or
	      ((mon d1 = mon d2) &
		  ((day d1 < day d2) or
		      ((day d1 = day d2) &
			  ((hour d1 < hour d2) or
			      ((hour d1 = hour d2) &
				  ((min d1 < min d2) or
				      ((min d1 = min d2) &
					  (sec d1 < sec d2)))))))))))

let (<<=) d1 d2 =
  ((year d1 < year d2) or
      ((year d1 = year d2) &
	  ((mon d1 < mon d2) or
	      ((mon d1 = mon d2) &
		  ((day d1 < day d2) or
		      ((day d1 = day d2) &
			  ((hour d1 < hour d2) or
			      ((hour d1 = hour d2) &
				  ((min d1 < min d2) or
				      ((min d1 = min d2) &
					  (sec d1 <= sec d2)))))))))))
