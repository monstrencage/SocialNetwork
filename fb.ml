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

type id = string
	
type gender = Male | Female | Unknown

type info = {
  name : string;
	birthday : Date.t;
	gender : gender
}
    
let make_info s b g = {name = s; birthday = b; gender = g}

let name i = i.name
let birthday i = i.birthday
let gender i = i.gender
let age i = (Date.age (i.birthday))
	
type contact = {
	f_name : string;
	f_id : id
}

let make_contact n id = {f_name = n; f_id = id}

let f_name f = f.f_name
let f_id f = f.f_id

type like = {
	l_id : id;
	l_name : string;
	cat : string;
	since : Date.t
}

let make_like id n c s = {l_id = id; l_name = n; cat = c; since = s}

let l_id l = l.l_id
let l_name l = l.l_name
let cat l = l.cat
let since l = l.since

type comment = {
  c_id : id ; 
  c_content : string ; 
  c_date : Date.t;
  c_from : contact;
  c_like : int
}

let make_comment id c d f l = {
  c_id = id ; 
  c_content = c ; 
  c_date = d;
  c_from = f;
  c_like = l
}

let	c_id c= c.c_id 
let	c_content c = c.c_content 
let	c_date c = c.c_date
let	c_from c = c.c_from
let	c_like c = c.c_like

type message = {
  m_id : id ; 
  content : string ; 
  date : Date.t;
  from : contact;
  fto : contact list;
  comments: comment list;
  m_likes : contact list;
  nb_com : int
}

let make_message id c d c1 c2 com l n = {
  m_id = id ; 
  content = c ; 
  date = d;
  from = c1;
  fto = c2;
  comments = com;
  m_likes = l;
  nb_com = n
}

let	m_id m = m.m_id 
let	content m = m.content 
let	date m = m.date
let from m = m.from
let	fto m = m.fto
let	comments m = m.comments
let	m_likes m = m.m_likes
let	nb_com m = m.nb_com

let gender_to_string = function
  | Male -> "Male"
  | Female -> "Female"
  | Unknown -> "Unknown"

let print_info i=
  Printf.printf "Name : %s;\n%! Birthday : %s;\n%! Gender : %s.\n\n%!" 
    i.name (Date.print i.birthday) (gender_to_string i.gender) 

let print_contact f=
  Printf.printf "Name : %s\n%! Id : %s\n%!" f.f_name f.f_id
    
let print_comment c =
  Printf.printf "- From : %s\n%!" c.c_from.f_name;
  Printf.printf "  Date : %s\n%!  Message : %s\n%!" (Date.print c.c_date) c.c_content;
  Printf.printf "  Like : %d\n%!" c.c_like
    
let print_message m=
  Printf.printf "From : %s\n%!" m.from.f_name;
  List.iter (fun f -> (Printf.printf "To : %s\n%!" f.f_name)) m.fto;
  Printf.printf "Date : %s\n%!Message : %s\n%!" (Date.print m.date) m.content;
  Printf.printf "Comments : \n%!";
  List.iter print_comment m.comments;
  Printf.printf "Likes : \n%!";
  List.iter print_contact m.m_likes;
  Printf.printf "\n%!"
    
let print_like l=
  Printf.printf "Name : %s\n%! Category : %s\n%!Since : %s\n\n%!"
    l.l_name l.cat (Date.print l.since)
    
let print_name = Printf.printf "Name : %s\n\n%!"

let print_date d = Printf.printf "Date : %s\n\n%!" (Date.print d)

let print_gender g= Printf.printf "Gender : %s.\n\n%!" (gender_to_string g)
