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

open Fb

type 'a obj = 
| C : contact obj
| F : contact list obj
| M : message list obj
| L : like list obj
| I : info obj

exception Fail of string*Yojson.Safe.json*string

exception Private of int
    
let from_string s = Yojson.Safe.from_string s
  
let print = Yojson.Safe.pretty_to_channel stdout

let string_to_gender s=
  if (s="male")
  then Male
  else
    if (s="female")
    then Female
    else failwith "string_to_gender"
      
let unwrap_assoc = function
  | `Assoc(l) -> l
  | j -> raise (Fail("unwrap_assoc",j,Yojson.Safe.to_string j))

let list_from_json = function
  | (d,`List(l))::q when (d="data")-> l
  | (c,`Int(i))::q -> []
  | (s,j)::q -> raise (Fail("list_from_json3",j,Yojson.Safe.to_string j))
  | [] -> failwith "list_from_json : empty"

let (!$) f l = List.map f (list_from_json (unwrap_assoc l))

let (!+) f l = List.iter f (unwrap_assoc l)
  
let rec fields o j=
  let n = ref ""
  and i = ref ""
  and d = ref (Date.origin)
  and cat = ref ""
  and m = ref ""
  and g = ref Unknown
  and from = ref (make_contact "" "")
  and fto = ref []
  and com = ref []
  and nb_com = ref 0
  and lik = ref []
  and lik_m = ref []
  and l = ref 0
  in
  let aux = function
    | (f,`String(s)) when 
	((f="description")
	 or(f="story")
	 or(f="caption")
	 or(f="message"))
	-> (m := !m^s)
    | (f,`String(s)) when 
	((f="created_time")
	 or(f="birthday"))
	-> (d:=(Date.from_string s))
    | (f,`String(s)) when (f="name")
	-> (n:=s)
    | (f,`String(s)) when (f="id")
	-> (i := s)
    | (f,`String(s)) when (f="category")
	-> (cat := s)
    | (f,`String(s)) when (f="gender")
	-> (g:=(string_to_gender s))
    | (_,`String(_)) -> ()
    | (f,j) when (f="from") -> (from:=(to_contact j))
    | (f,j) when (f="to") -> (fto := !$ to_contact j)
    | (f,j) when (f="comments") -> (try com := !$ to_comment j
      with Private(i) -> nb_com:=i)
    | (f,j) when (f="likes") ->
      (match o with
      | `C -> (match j with
	| `Int i -> l:=i
	| _ -> raise (Fail("fields : likes",j,Yojson.Safe.to_string j)))
      | `P -> lik_m := !$ to_contact j
      | _ -> lik := !$ to_like j)
    | _ -> ()
  in
  (!+ aux j);
  (!n,!i,!d,!cat,!m,!from,!fto,!com,!g,!lik,!lik_m,!l,!nb_com)
    
and to_contact j =
  let (n,i,d,cat,m,fro,fto,com,g,lik,lik_m,l,k)=(fields `F j)
  in
  (make_contact n i)
and to_comment j=
  let (n,i,d,cat,m,fro,fto,com,g,lik,lik_m,l,k)=(fields `C j)
  in
  make_comment i m d fro l
and to_post j=
  let (n,i,d,cat,m,fro,fto,com,g,lik,lik_m,l,k)=(fields `P j)
  in
  make_message i m d fro fto com lik_m (if k = 0 then List.length com else k)
and to_like j=
  let (n,i,d,cat,m,fro,fto,com,g,lik,lik_m,l,k)=(fields `L j)
  in
  make_like i n cat d
and to_info j=
  let (n,i,d,cat,m,fro,fto,com,g,lik,lik_m,l,k)=(fields `I j)
  in
  make_info n d g
    
let to_contacts = (!$ to_contact);;

let to_comments = (!$ to_comment);;

let to_posts = (!$ to_post);;

let to_likes = (!$ to_like);;

let translate : type a. string -> a obj -> a = (fun j -> 
  function
  | C -> to_contact (from_string j)
  | F -> to_contacts (from_string j)
  | M -> to_posts (from_string j)
  | L -> to_likes (from_string j)
  | I -> to_info (from_string j))

let unwrap_list = function
  | `List(l) -> l
  | j -> raise (Fail("unwrap_list",j,Yojson.Safe.to_string j))

let unwrap_batch j=
  let rec aux = function
    | (s,`String(j'))::q -> if (String.compare s "body" = 0) then (from_string j') else (aux q)
    | (s,t)::q -> (aux q)
    | [] -> failwith "unwrap_batch : empty"
  in
  (List.map (fun d -> aux (unwrap_assoc d)) (unwrap_list j))
    
let (!%) f j = (List.map f (unwrap_batch j))

let to_contact_batch = (!% to_contact)

let to_contacts_batch = (!% to_contacts)

let to_posts_batch =(!% to_posts)

let to_likes_batch = (!% to_likes)

let to_info_batch = (!% to_info)

let translate_list : type a. string -> a obj -> a list = fun j -> 
  function
  | C -> to_contact_batch (from_string j)
  | F -> to_contacts_batch (from_string j)
  | M -> to_posts_batch (from_string j)
  | L -> to_likes_batch (from_string j)
  | I -> to_info_batch (from_string j)
