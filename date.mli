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

(** Manipulation de dates *)

type t
(** Type des dates. Il est implémenté comme [Unix.tm]. *)

(** {2 Accesseurs et conversions}*)

val sec : t -> int
val min : t -> int
val hour : t -> int
val day : t -> int
val mon : t -> int
val year : t -> int

val from_string : string -> t
(** Cette fonction lit une chaine de caractères et construit
 une date lui correspondant. Elle supporte différents formats.
 Attention : 04/02/2012 correspond au 2 avril 2012, et pas au
 4 février (format américain oblige). *)

val to_string : t -> string
(** Traduit une date en [string] au format MM/JJ/AAAA. *)

val print : t -> string
(** Traduit une date en [string] au format JJ/MM/AAAA.
 C'est cette fonction qui est utilisée pour l'affichage. *)

val sec_to_string : float -> string

(** {2 Références et dates relatives} *)

val now : unit -> t
(** Obtenir la date au moment de l'appel [now ()]. *)

val now_to_string : unit -> string

val origin : t
(** Origine des dates (le 31 décembre 1899). *)

val ndaysago : int -> t
(** [ndayago n] renvoie la date d'il y a [n] jours. *)

val nmonthsago : int -> t
(** [nmonthago n] renvoie la date d'il y a [n] mois. *)

val a_week_ago : unit -> t
(** [a_week_ago ()] renvoie la date d'il y a une semaine. *)

val a_month_ago : unit -> t
(** [a_month_ago ()] renvoie la date d'il y a un mois. *)
		
val a_year_ago : unit -> t
(** [a_year_ago ()] renvoie la date d'il y a un an. *)

val last_anniversary : t -> t
(** [last_anniversary d] renvoie la date du dernier anniversaire de [d]. *)

val age : t -> int
(** [age d] renvoie l'âge en années de [d]. *)

val around: t -> t * t
(** [around d] renvoie un intervalle de un jour avant [d] un jour après [d]. *)

val (<<+) : t -> t -> bool
(** Opérateur infixe d'inégalité stricte entre deux dates. *)

val (<<=) : t -> t -> bool
(** Opérateur infixe d'inégalité large entre deux dates. *)
