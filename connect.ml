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

let get_ s =
  let connection = Curl.init () 
  and b =Buffer.create 80
  in
  let f = (
    fun x -> 
      Buffer.add_string b x; String.length x)
  in
  Curl.setopt connection (Curl.CURLOPT_URL s);
  Curl.setopt connection (Curl.CURLOPT_WRITEFUNCTION (f));
  Curl.perform connection; 
  (Buffer.contents b)
;;

let get s = (Tools.chrono_com get_ s)
  
let make_batch l = 
  let rec aux=function
    | [] -> ""
    | t::q -> "{\"method\": \"GET\", \"relative_url\":\""^t^"\"},"^(aux q)
  in
  (Curl.CURLFORM_CONTENT ("batch","["^(aux l)^"]",Curl.DEFAULT))  
    
let get_b url l =
  let b =Buffer.create 80
  in
  let f = (
    fun x -> 
      Buffer.add_string b x; String.length x)
  and connection = Curl.init () 
  in
  Curl.setopt connection (Curl.CURLOPT_URL url);
  Curl.setopt connection (Curl.CURLOPT_WRITEFUNCTION (f));
  Curl.setopt connection (Curl.CURLOPT_HTTPPOST l);
  Curl.perform connection;
  (Buffer.contents b)
;;

let get_list (a,l,url)=
  let l=[Curl.CURLFORM_CONTENT (fst a,snd a,Curl.DEFAULT);
	 make_batch l]
  in
  Tools.chrono_com (get_b url) l
;;

let get_batch (l,url)=
  let t=(Unix.gettimeofday())
  and connection = Curl.init () 
  and b =Buffer.create 80
  in
  let f = (
    fun x -> 
      Buffer.add_string b x; String.length x)
  and l=[(*Curl.CURLFORM_CONTENT (fst a,snd a,Curl.DEFAULT);*)
    make_batch l]
  in
  Curl.setopt connection (Curl.CURLOPT_URL url);
  Curl.setopt connection (Curl.CURLOPT_WRITEFUNCTION (f));
  Curl.setopt connection (Curl.CURLOPT_HTTPPOST l);
  Curl.perform connection;
  Printf.printf "Communication : %f s." (Unix.gettimeofday()-.t);
  print_newline (); 
  (Buffer.contents b)
;;
