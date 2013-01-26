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

(** Outils divers *)

val bind : ('a -> 'b list) -> 'a list -> 'b list
(** Est-il nécessaire de préciser ce que fait cette fonction? *)

val is_in : 'a list -> 'a -> bool
(** Appartenence à une liste *)

val no : ('a -> bool) -> 'a -> bool
(** [no f x] correspond à {% $\neg$ %}[(f x)] *)

val conj : 'a list -> 'a list -> 'a list
(** [conj l1 l2] renvoie la liste des éléments appartenant
 à [l1] et à [l2]. *)

val disj : 'a list -> 'a list -> 'a list
(** [disj l1 l2] renvoie la liste des éléments appartenant
 à [l1] ou à [l2] (sans répétitions). *)

val filter_twice : 'a list -> 'a list
(** [filter l] renvoie la liste des éléments apparaissant
 deux fois dans [l]. *)

val clean : 'a list -> 'a list
(** Élimine les doublons dans une liste. *)

val pos : int -> int
(** [pos x] envoie le maximum de [0] et [x]. *)

val elect_max : ('a -> int) -> 'a list -> 'a
(** [elect_max f l] renvoie l'élement de [l] maximisant la fonction [f]. *)

val elect_min : ('a -> int) -> 'a list -> 'a
(** [elect_max f l] renvoie l'élement de [l] minimisant la fonction [f]. *)

val selectM : ('b -> int) -> 'a list * 'b list -> 'a 
(** [selectM f (l1,l2)] renvoie l'élément [x] de [l1] tel que l'élément 
[y] de [l2] correspondant (de même index) maximise [f]. *)

val selectm : ('b -> int) -> 'a list * 'b list -> 'a 
(** [selectm f (l1,l2)] renvoie l'élément [x] de [l1] tel que l'élément 
[y] de [l2] correspondant (de même index) minimise [f]. *)

val filter : ('b -> bool) -> 'a list * 'b list -> 'a list
(** [filter f (l1,l2)] renvoie le même résultat que :
 [List.filter (fun (x,y) -> f y) (List.combine l1 l2)]. *)

val chrono_com : ('a -> 'b) -> 'a -> 'b
(** [chrono_com] sert à chonométrer les communications. *)

val chrono : string -> ('a -> 'b) -> 'a -> 'b
(** [chrono s f x] calcule [f x], écrit le temps écoulé précédé de [s], puis 
renvoie le résultat du calcul. *)

val chrono_list : (unit -> 'a) list -> unit
(** [chrono_list l] effectue [List.map (fun f -> f()) l] puis écrit le temps 
écoulé. *)
