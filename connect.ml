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
open Http_client.Convenience

let get_ = http_get

let get s = (Tools.chrono_com get_ s)
  
let make_batch l = 
  let rec aux=function
    | [] -> ""
    | t::q -> "{\"method\": \"GET\", \"relative_url\":\""^t^"\"},"^(aux q)
  in
  ("batch","["^(aux l)^"]")  
    
let get_b = http_post

let get_list (a,l,url)=
  let l=[(fst a,snd a);
	 make_batch l]
  in
  Tools.chrono_com (get_b url) l
