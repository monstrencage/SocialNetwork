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

(** Types des objets Facebook *)

(** {2 Définitions de types et accesseurs} *)

(** Ces types sont définis comme des enregistrements, mais on a choisi ici de 
 masquer cela dans l'interface, afin d'obliger à utiliser les accesseurs et 
 d'assurer la généricité du code. *)

type id = string
(** Type des identifiants. *)
	
type gender = Male | Female | Unknown
(** Genre d'un utilisateur. *)

(** {3 Informations} *)

type info
(** Informations prises en charge sur les utilisateurs. Il est important de noter
que le genre n'est pas défini sur les pages publiques. *)
val make_info : string -> Date.t -> gender -> info
val name : info -> string
val birthday : info -> Date.t
val gender : info -> gender
val age : info -> int

(** {3 Contacts} *)	

type contact
(** Type d'un ami. *)
val make_contact : string -> id -> contact
val f_name : contact -> string
val f_id : contact -> id

(** {3 {% \og Likes\fg %}} *)

type like
(** Type d'un {% \og like\fg %} Facebook. *)
val make_like : id -> string -> string -> Date.t -> like
val l_id : like -> id
val l_name : like -> string
val cat : like -> string
val since : like -> Date.t

(** {3 Commentaires} *)

type comment
(** Type d'un commentaire. *)

val make_comment : id -> string -> Date.t -> contact -> int -> comment
val c_id : comment -> id
val c_content : comment -> string
val c_date : comment -> Date.t
val c_from : comment -> contact
val c_like : comment -> int

(** {3 Messages} *)

type message
(** Type d'un message. *)
val make_message :
  id ->
  string ->
  Date.t ->
  contact -> contact list -> comment list -> contact list -> int -> message
val m_id : message -> id
val content : message -> string
val date : message -> Date.t
val from : message -> contact
val fto : message -> contact list
val comments : message -> comment list
val m_likes : message -> contact list
val nb_com : message -> int

(** {2 Fonctions d'impression} *)  
val gender_to_string : gender -> string
val print_info : info -> unit
val print_contact : contact -> unit
val print_comment : comment -> unit
val print_message : message -> unit
val print_like : like -> unit
val print_name : string -> unit
val print_date : Date.t -> unit
val print_gender : gender -> unit

