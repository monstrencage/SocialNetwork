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

(** Conversions vers et depuis json *)

(** {2 Préliminaires} *)

type 'a obj = 
	| C : Fb.contact obj
	| F : Fb.contact list obj
	| M : Fb.message list obj
	| L : Fb.like list obj
	| I : Fb.info obj
(** Type utlisé pour choisir le format (et donc le type) du résultat
 de la traduction d'un objet json reçu de puis Facebook. *)
	
exception Fail of string*Yojson.Safe.json*string
(** Exception très utile pour le débuggage : permet de voir le nom
 de la fonction qui a échoué (dans le [string]), et l'objet Json
 qui l'a troublé. *)

exception Private of int
(** Parfois, les commentaires d'un message sont configurés de telle
 manière qu'on n'y a pas accès, mais qu' en revanche leur nombre
 est accessible. Cette exception permet de réccupérer ce nombre
 et de l'intéger dans le message (champ [nb_com]). *)

val from_string : string -> Yojson.Safe.json
(** Traduit un string dans le format json. *)
	
val print : Yojson.Safe.json -> unit
(** Affiche un objet json sur la sortie standard. *)

(** {2 Fonctions de traduction {% \og simples\fg %}} *)
val	to_contact : Yojson.Safe.json -> Fb.contact
(** Traduit un objet json dans le format [Fb.contact]. *)

val	to_comment : Yojson.Safe.json -> Fb.comment
(** Traduit un objet json dans le format [Fb.comment]. *)

val to_post : Yojson.Safe.json -> Fb.message
(** Traduit un objet json dans le format [Fb.message]. *)

val to_like : Yojson.Safe.json -> Fb.like
(** Traduit un objet json dans le format [Fb.like]. *)

val to_info : Yojson.Safe.json -> Fb.info
(** Traduit un objet json dans le format [Fb.info]. *)
		
val to_contacts : Yojson.Safe.json -> Fb.contact list
(** Traduit un objet json dans le format [Fb.contact list]. *)
	
val to_comments : Yojson.Safe.json -> Fb.comment list
(** Traduit un objet json dans le format [Fb.comment list]. *)
   
val to_posts : Yojson.Safe.json -> Fb.message list
(** Traduit un objet json dans le format [Fb.message list]. *)

val to_likes : Yojson.Safe.json -> Fb.like list
(** Traduit un objet json dans le format [Fb.like list]. *)

val translate : string -> 'a obj -> 'a
(** Fonction de traduction principale : prend une chaîne de
 caractères (telle que reçue depuis internet) et le type du
 résultat attendu (grâce à un objet ['a obj]) et renvoie un
 objet [Fb] qui correspond. *)

(** {2 Fonctions de traduction des {% \og batch requests\fg %}} *)

val to_contacts_batch : Yojson.Safe.json -> Fb.contact list list
(** Traduit un objet json dans le format [Fb.contact list list]. *)
   
val to_posts_batch : Yojson.Safe.json -> Fb.message list list
(** Traduit un objet json dans le format [Fb.comment list list]. *)

val to_likes_batch : Yojson.Safe.json -> Fb.like list list
(** Traduit un objet json dans le format [Fb.message list list]. *)

val to_info_batch : Yojson.Safe.json -> Fb.info list
(** Traduit un objet json dans le format [Fb.info list]. *)

val translate_list : string -> 'a obj -> 'a list
(** Seconde fonction de traduction : pour le résultat d'une
 'batch request'. *)
