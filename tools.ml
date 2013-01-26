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

open List

let bind f l=(List.concat (List.map f l))

let is_in l = (fun e -> mem e l)

let no f = (fun x -> (not (f x)))

let conj l l' = filter (is_in l) l'

let disj l l' = (l @ (filter (no (is_in l)) l'))

let filter_twice l= 
  let rec aux e= function
    | [] -> ([],false)
    | t::q -> 
      (if t=e
       then (q,true)
       else
          let (q',b) = (aux e q)
          in (t::q',b))
  in
  let rec aux2 = function
    | [] -> []
    | t::q ->
      begin
        let (q',b) = (aux t q)
        in
        if b
        then t::(aux2 q')
        else (aux2 q')
      end
  in
  (aux2 l)

let clean = function
  | [] -> []
  | t::q -> t::(filter (no (fun x -> x=t)) q)  

let pos i = max i 0;;

let elect_max f= function
  | []   -> failwith "elect_max : empty list"
  | t::q -> begin
    let rec aux m e= function
      | []    -> e
      | e'::q -> 
        let a=(f e') in
        if (a>m)
        then (aux a e' q) 
        else (aux m e q)
    in
    aux (pos (f t)) t q
  end;;

let elect_min f = function
  | []   -> failwith "elect_min : empty list"
  | t::q -> begin
    let rec aux m e= function
      | []    -> e
      | e'::l -> 
        let a=(f e') in
        if (0<a)&(a<m) 
        then (aux a e' l) 
        else (aux m e l)
    in
    aux (pos (f t)) t q
  end;;

let selectM f = function
  | [],[]   -> failwith "selectM : empty list"
  | t::q,t'::q' -> begin
    let rec aux v m e= function
      | [],[]    -> e
      | e'::q,e''::q' -> 
        let a=(f e'') in
        if (a>v) 
        then (aux a e'' e' (q,q')) 
        else (aux v m e (q,q'))
      | _ -> failwith "selectM : lists of different sizes"
    in
    aux (pos (f t')) t' t (q,q')
  end
  | _ -> failwith "selectM : lists of different sizes";;

let selectm f = function
  | [],[]   -> failwith "selectm : empty list"
  | t::q,t'::q' -> begin
    let rec aux v m e= function
      | [],[]    -> e
      | e'::q,e''::q' -> 
        let a=(f e'') in
        if (0<a)&(a<v) 
        then (aux a e'' e' (q,q')) 
        else (aux v m e (q,q'))
      | _ -> failwith "selectm : lists of different sizes"
    in
    aux (pos (f t')) t' t (q,q')
  end
  | _ -> failwith "selectm : lists of different sizes";;


let rec filter f = function
  | [],[] -> []
  | t::q,t'::q' ->
    (if (f t')
     then t::(filter f (q,q'))
     else (filter f (q,q')))
  | _ -> failwith "filter : lists of different sizes";;

let chrono_com f x =
  let c = (Unix.gettimeofday ())
  in
  print_string "Envoi de la requête";
  print_newline();
  let o = (f x)
  in
  Printf.printf "Temps de communication : %f s." 
    (Unix.gettimeofday () -. c);
  print_newline();
  o;;

let chrono s f x =
  let c = (Unix.gettimeofday ())
  in
  let o = (f x)
  in
  Printf.printf "%s : %f s.\n" s (Unix.gettimeofday () -. c);
  o;;

let chrono_list reql =
  let c = (Unix.gettimeofday ())
  in
  let _ = (List.map (fun f -> f()) reql)
  in
  Printf.printf "Temps écoulé : %f s.\n" (Unix.gettimeofday () -. c);;
