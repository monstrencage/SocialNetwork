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

(** Définition des requêtes de base *)

exception NotSupported
(** Certains champs ne sont pas définis partout. Par exemple,
 demander la liste d'amis d'une page publique lève cette exception. *)

type ('a, 'b) req =
(** Type des requêtes de base. *)
    Contact : (Fb.id, Fb.contact) req 
   (** Trouver le nom à partir de l'identifiant. *)
  | Contacts : (Fb.contact, Fb.contact list) req
   (** Demander la liste de contacts d'un utilisateur. *)
  | MutualF : Fb.contact -> (Fb.contact, Fb.contact list) req
   (** Demander les amis mutuels de deux utilisateurs. *)
  | Posts : (Fb.contact, Fb.message list) req
   (** Liste des {% \og posts\fg %} d'un utilisateur. *)
  | Feed : (Fb.contact, Fb.message list) req
   (** Liste des {% \og feeds\fg %} d'un utilisateurs. *)
  | Likes : (Fb.contact, Fb.like list) req
   (** Liste des mentions {% \og like\fg %} d'un utilisateur. *)
  | Infos : (Fb.contact, Fb.info) req
   (** Informations sur un utilisateur : nom, genre et date d'anniversaire *)
  | Since : Date.t * ('a, 'b list) req -> ('a, 'b list) req
   (** Filter une requête par les dates supérieures à [d]. *)
  | Until : Date.t * ('a, 'b list) req -> ('a, 'b list) req
   (** Filter une requête par les dates inférieures à [d]. *)
   
val get : 'a -> ('a, 'b) req -> 'b
(** Fonction de récupération des informations. *)

val get_list : ('a list * ('a, 'b) req) list -> 'b list
(** [get_list l r] renvoie le même résultat que
[List.map (fun x -> get x r) l].*)
