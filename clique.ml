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

(* Outils*)
  
let argmax f x y =
  if (f x < f y)
  then y
  else x;;
(** [argmax f x y] returns [x] if [f(x)] is bigger than [f(y)], 
    [y] otherwise. *)

let compare_inv c1 c2 =
  let n1 = (List.length (snd c1))
  and n2 = (List.length (snd c2))
  in (n2 - n1);;
(** [compare_inv (x,l1) (y,l2)] returns 0 if l1 and l2 have the same length,
    a positive value if l2 is bigger than l1 and a negative value otherwise. *)  

let make_index l ll=
  let h= (Hashtbl.create (List.length l))
  in
  let rec aux = function
    | [],[] -> ()
    | t::q,l::ql ->
      (Hashtbl.add h t (Tools.is_in l); aux (q,ql))
    | _ -> failwith "make_index : there must be as many indexes as values"
  in
  (aux (l,ll); (Hashtbl.find h))
(** [make_index] takes a list of indexes [idx] and a list of lists [val]. 
    It requires that [idx] and [val] have the same length. It then computes a 
    function [f : 'a -> 'b -> bool] such that if [a] is the {% $i^{th}$ %} element
    of the list [idx], and [l] the {% $i^{th}$ %} list of [val], then [f a b]
    returns [true] if [b] is in [l] and [false] otherwise.*)
    
let conflict p l = 
  let rec aux = function
    | [] -> None
    | t::q ->
      if (p t)
      then 
	(match (aux q) with
	| None -> None
	| Some(l') -> Some(t::l'))
      else 
	(match (aux q) with
	| None -> Some(q)
	| Some(l') -> Some(l'))
  in 
  (aux l);;
(** [conflict p l] returns the list of elements [l] that do not verify
    the predicate [p] (i.e. [p(elt) = false]), or returns [None] if there 
    are no such elements *)

let ( $$ ) l1 l2 = (List.filter (Tools.no (Tools.is_in l2)) l1)
(** [l1 $$ l2] renvoie la liste des éléments de [l1] n'apparaissant 
    pas dans [l2] *)

(* Le calcul *)
  
let clique fr frfr =
  let idx = make_index fr frfr
  in 
  let clik_with fj=
    let rec aux clik init = function
      | [] -> clik
      | t::q ->
	match (conflict (idx t) clik) with
	| None -> (aux (t::clik) init q)
	| Some(l) -> 
	  let cl = aux clik init q
	  in
	  if (List.length cl = List.length init - 1)
	  then cl
	  else
	    argmax 
	      List.length 
	      cl
	      (aux 
		 (t::l) 
		 (List.filter (idx t) init) 
		 (List.filter (idx t) (init $$ (t::clik))))
    in
    (aux [] fj fj)
  in
  let rec aux = function
    | [j,fj] -> (clik_with fj,j)
    | (j,fj)::q -> 
      let (c,j') = (aux q)
      in 
      let cl = (clik_with (fj $$ (fst (List.split q))))
      in
      if (List.length cl > List.length c)
      then (cl,j)
      else (c,j')
    | [] -> failwith "clique_exact"
  in
  let (cl,j) = aux (List.fast_sort compare_inv (List.combine fr frfr))
  in (j::cl);;



let clique_smpl fr frfr =
  let idx = make_index fr frfr
  in 
  let clik_with fj=
    let rec aux clik init = function
      | [] -> clik
      | t::q ->
	match (conflict (idx t) clik) with
	| None -> (aux (t::clik) init q)
	| Some(l) -> 
	  let cl = aux clik init q
	  in
	  argmax 
	    List.length 
	    cl
	    (aux 
	       (t::l) 
	       (List.filter (idx t) init) 
	       (List.filter (idx t) (init $$ (t::clik))))
    in
    (aux [] fj fj)
  in
  let rec aux l1 l2 = 
    match (l1,l2) with
    | [j],[fj] -> (clik_with fj,j)
    | j::q1,fj::q2 -> 
      let (c,j') = (aux q1 q2)
      in 
      let cl = (clik_with (fj $$ q1))
      in
      if (List.length cl > List.length c)
      then (cl,j)
      else (c,j')
    | _ -> failwith "clique_exact"
  in
  let (cl,j) = aux fr frfr
  in (j::cl);;
