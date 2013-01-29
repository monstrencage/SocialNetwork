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

exception Empty

exception NotSupported

let handle : type a b. (a -> (b list)) -> a -> (b list) =
fun f x ->
  try f x
  with Empty -> []

let (<<+) = Date.(<<+)

let (<<=) = Date.(<<=)

let prefixe = "https://graph.facebook.com/";;

let access_token = ("access_token="^Auth.access_token);;

let access_batch = ("access_token",Auth.access_token);;

type ('a,'b) req =
| Contact : (id,contact) req
| Contacts : (contact,contact list) req
| MutualF : contact -> (contact, contact list) req
| Posts : (contact, message list) req
| Feed : (contact, message list) req
| Likes : (contact, like list) req
| Infos : (contact, info) req
| Since : Date.t * ('a,'b list) req -> ('a,'b list) req
| Until : Date.t * ('a,'b list) req -> ('a,'b list) req
         
let rec since_until : type a b. (a,b) req -> (a,b) req = function
  | Since (d,r) -> (Since (d,since_until r))
  | Until (d1,r) -> 
    (match (since_until r) with 
    |Since (d2,r) -> (Since (d2,since_until (Until (d1,r)))) 
    | r -> (Until (d1,r)))
  | r -> r
         
let opt_req : type a b. (a,b) req -> (a,b) req = (fun r -> 
  let rec aux : type a b. (a,b) req -> (a,b) req = function
    | Since (d1,Since (d2,r)) -> 
      (if (d1 <<+ d2)
       then (aux (Since (d2,r)))
       else (aux (Since (d1,r))))
    | Until (d1,Until (d2,r)) -> 
      (if (d1 <<+ d2)
       then (aux (Until (d1,r)))
       else (aux (Until (d2,r))))
    | Since (d2,Until (d,r)) -> 
      (match (aux (Until (d,r))) with
      | Until (d1,r) -> 
        (if (d1 <<+ d2)
         then raise Empty
         else (Since (d2,Until (d1,r))))
      | _ -> failwith "opt_req : since until")
    | r -> r
  in (aux (since_until r)))

let retry f x k = 
  let rec aux k =
    try
      (f x)
    with
    | Json.Fail(mes,j,str) -> 
      if k = 0
      then failwith ("Problème de communication :"^str)
      else 
	(Printf.printf 
	   "Problème de communication : %s\nSending again...\n" 
	   str;
	 aux (k-1))
  in
  aux k

let get_ (s,o) = 
  let f s =
    (Json.translate
       (Connect.get (prefixe^s^access_token))
       o)
  in
  retry f s 2

let rec to_string : type a b. a -> (a,b) req -> string*b Json.obj = fun x r->
  match (opt_req r) with
  | Contact -> x^"?fields=name&",Json.C 
  | Contacts -> raise NotSupported
  | MutualF(y) -> raise NotSupported
    (* Les pages publiques n'ont pas de notion d'amis. *)
  | Posts -> (f_id x)^"/posts?limit=1000&",Json.M
  | Feed -> (f_id x)^"/feed?limit=1000&",Json.M
  | Likes -> (f_id x)^"/likes?",Json.L
  | Infos -> (f_id x)^"?fields=name,birthday&",Json.I 
    (* Le genre n'est pas supporté par les pages publiques. *)
  | Since (d,r) -> 
    let s,o = (to_string x r)
    in s^"since="^(Date.to_string d)^"&",o
  | Until (d,r) -> 
    let s,o = (to_string x r)
    in s^"until="^(Date.to_string d)^"&",o

let rec reqtype : type a b. (a,b) req -> b Json.obj = function
  | Contact -> Json.C 
  | Contacts -> Json.F
  | MutualF(y) -> Json.F
  | Posts -> Json.M
  | Feed -> Json.M
  | Likes -> Json.L
  | Infos -> Json.I
  | Since (d,r) -> (reqtype r)
  | Until (d,r) -> (reqtype r)

let get : type a b. a -> (a,b) req -> b = fun a r ->
  let (s,o) = (to_string a r)
  in
  match o with 
  | Json.F -> handle get_ (s,o)
  | Json.M -> handle get_ (s,o)
  | Json.L -> handle get_ (s,o)
  | Json.I -> get_ (s,o)
  | Json.C -> get_ (s,o)
        
let req_in_packs l=
  let rec aux = function
    | [],_ -> [],[]
    | l,0  -> [],l
    | h::t,n -> (let a,b = aux (t,n-1) in (h::a,b))
  in
  let rec aux2 l =
    match (aux (l,48)) with
    | rl,[] -> [(access_batch,rl,prefixe)]
    | rl,q  -> (access_batch,rl,prefixe)::(aux2 q)
  in
  (aux2 l)
    
let req_to_list (l, q)=
  List.map (fun u -> fst (to_string u q)) l
    
let req_type = function
  | [] -> failwith "Undefined req type"
  | (l,q)::t -> (reqtype q)

let get_list l=
  let aux l=
    let reql = req_in_packs (Tools.bind req_to_list l)
    and o = req_type l
    in
    (Tools.bind 
       (fun req -> 
	 Json.translate_list (Connect.get_list req) o) 
       reql)
  in retry (handle aux) l 2
