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


(** Le module [Facebook.Priv] est obtenu en faisant [Requetes (struct module 
    Obj = Fb ; module GetObj = Getfb end)]. 
    Il permet de faire des requêtes sur les utilisateurs standard de Facebook. *)
module Priv : 
sig (**/**)
  module Obj :
  sig
    type id = string
    type gender = Fb.gender = Male | Female | Unknown
    type info = Fb.info
    val make_info : string -> Date.t -> gender -> info
    val name : info -> string
    val birthday : info -> Date.t
    val gender : info -> gender
    val age : info -> int
    type contact = Fb.contact
    val make_contact : string -> id -> contact
    val f_name : contact -> string
    val f_id : contact -> id
    type like = Fb.like
    val make_like : id -> string -> string -> Date.t -> like
    val l_id : like -> id
    val l_name : like -> string
    val cat : like -> string
    val since : like -> Date.t
    type comment = Fb.comment
    val make_comment :
      id -> string -> Date.t -> contact -> int -> comment
    val c_id : comment -> id
    val c_content : comment -> string
    val c_date : comment -> Date.t
    val c_from : comment -> contact
    val c_like : comment -> int
    type message = Fb.message
    val make_message :
      id ->
      string ->
      Date.t ->
      contact ->
      contact list -> comment list -> contact list -> int -> message
    val m_id : message -> id
    val content : message -> string
    val date : message -> Date.t
    val from : message -> contact
    val fto : message -> contact list
    val comments : message -> comment list
    val m_likes : message -> contact list
    val nb_com : message -> int
    val print_info : info -> unit
    val print_contact : contact -> unit
    val print_comment : comment -> unit
    val print_message : message -> unit
    val print_like : like -> unit
    val print_name : string -> unit
    val print_date : Date.t -> unit
    val print_gender : gender -> unit
  end
  module GetObj :
  sig
    exception NotSupported
    type ('a, 'b) req =
    | Contact : (string, Fb.contact) req
    | Contacts : (Fb.contact, Fb.contact list) req
    | MutualF : Fb.contact -> (Fb.contact, Fb.contact list) req
    | Posts : (Fb.contact, Fb.message list) req
    | Feed : (Fb.contact, Fb.message list) req
    | Likes : (Fb.contact, Fb.like list) req
    | Infos : (Fb.contact, Fb.info) req
    | Since : Date.t * ('a, 'b list) req -> ('a, 'b list) req
    | Until : Date.t * ('a, 'b list) req -> ('a, 'b list) req
    val get : 'a -> ('a, 'b) req -> 'b
    val get_list : ('a list * ('a, 'b) req) list -> 'b list
  end
  type ('a, 'b) comb =
    Get : ('a, 'b) GetObj.req -> ('a, 'b) comb
  | SelectM :
      (('a list, 'b list) comb * ('b -> int)) -> ('a list, 'a) comb
  | Selectm :
      (('a list, 'b list) comb * ('b -> int)) -> ('a list, 'a) comb
  | Filter :
      (('a list, 'b list) comb * ('b -> bool)) -> ('a list, 'a list)
    comb
  | Comp : ('a, 'b) comb * ('b, 'c) comb -> ('a, 'c) comb
  | Ou : ('a, 'b list) comb * ('a, 'b list) comb -> ('a, 'b list) comb
  | Et : ('a, 'b list) comb * ('a, 'b list) comb -> ('a, 'b list) comb
  | Map : ('a, 'b) comb -> ('a list, 'b list) comb
  | Bind : ('a, 'b list) comb -> ('a list, 'b list) comb
  val opt : ('a, 'b) comb -> ('a, 'b) comb
  val get_obj : 'a -> ('a, 'b) comb -> 'b
  val ( |> ) : ('a, 'b) comb -> ('b, 'c) comb -> ('a, 'c) comb
  val ( @ ) : ('a, 'b) comb -> 'a -> 'b
  val contact_from_id : string -> Fb.contact
  val contacts_from_ids : string list -> Fb.contact list
  val getage : Fb.contact -> int
  val getages_dumb : Fb.contact list -> int list
  val getages : Fb.contact list -> int list
end
  
(** Ce module est similaire au précédent, mais est destiné au pages publiques. Il
    lève donc l'exception [NotSupported] si on appelle la fonction [gender] ou si l'on
    fait appel aux requêtes de base [Contacts] et [MutualF]. *)
module Pub : 
sig (**/**)
  module Obj :
  sig
    type id = string
    type gender = Fb.gender = Male | Female | Unknown
    type info = Fb.info
    val make_info : string -> Date.t -> gender -> info
    val name : info -> string
    val birthday : info -> Date.t
    val gender : info -> gender
    val age : info -> int
    type contact = Fb.contact
    val make_contact : string -> id -> contact
    val f_name : contact -> string
    val f_id : contact -> id
    type like = Fb.like
    val make_like : id -> string -> string -> Date.t -> like
    val l_id : like -> id
    val l_name : like -> string
    val cat : like -> string
    val since : like -> Date.t
    type comment = Fb.comment
    val make_comment :
      id -> string -> Date.t -> contact -> int -> comment
    val c_id : comment -> id
    val c_content : comment -> string
    val c_date : comment -> Date.t
    val c_from : comment -> contact
    val c_like : comment -> int
    type message = Fb.message
    val make_message :
      id ->
      string ->
      Date.t ->
      contact ->
      contact list -> comment list -> contact list -> int -> message
    val m_id : message -> id
    val content : message -> string
    val date : message -> Date.t
    val from : message -> contact
    val fto : message -> contact list
    val comments : message -> comment list
    val m_likes : message -> contact list
    val nb_com : message -> int
    val print_info : info -> unit
    val print_contact : contact -> unit
    val print_comment : comment -> unit
    val print_message : message -> unit
    val print_like : like -> unit
    val print_name : string -> unit
    val print_date : Date.t -> unit
    val print_gender : gender -> unit
  end
  module GetObj :
  sig
    exception NotSupported
    type ('a, 'b) req =
    | Contact : (string, Fb.contact) req
    | Contacts : (Fb.contact, Fb.contact list) req
    | MutualF : Fb.contact -> (Fb.contact, Fb.contact list) req
    | Posts : (Fb.contact, Fb.message list) req
    | Feed : (Fb.contact, Fb.message list) req
    | Likes : (Fb.contact, Fb.like list) req
    | Infos : (Fb.contact, Fb.info) req
    | Since : Date.t * ('a, 'b list) req -> ('a, 'b list) req
    | Until : Date.t * ('a, 'b list) req -> ('a, 'b list) req
    val get : 'a -> ('a, 'b) req -> 'b
    val get_list : ('a list * ('a, 'b) req) list -> 'b list
  end
  type ('a, 'b) comb =
    Get : ('a, 'b) GetObj.req -> ('a, 'b) comb
  | SelectM :
      (('a list, 'b list) comb * ('b -> int)) -> ('a list, 'a) comb
  | Selectm :
      (('a list, 'b list) comb * ('b -> int)) -> ('a list, 'a) comb
  | Filter :
      (('a list, 'b list) comb * ('b -> bool)) -> ('a list, 'a list)
    comb
  | Comp : ('a, 'b) comb * ('b, 'c) comb -> ('a, 'c) comb
  | Ou : ('a, 'b list) comb * ('a, 'b list) comb -> ('a, 'b list) comb
  | Et : ('a, 'b list) comb * ('a, 'b list) comb -> ('a, 'b list) comb
  | Map : ('a, 'b) comb -> ('a list, 'b list) comb
  | Bind : ('a, 'b list) comb -> ('a list, 'b list) comb
  val opt : ('a, 'b) comb -> ('a, 'b) comb
  val get_obj : 'a -> ('a, 'b) comb -> 'b
  val ( |> ) : ('a, 'b) comb -> ('b, 'c) comb -> ('a, 'c) comb
  val ( @ ) : ('a, 'b) comb -> 'a -> 'b
  val contact_from_id : string -> Fb.contact
  val contacts_from_ids : string list -> Fb.contact list
  val getage : Fb.contact -> int
  val getages_dumb : Fb.contact list -> int list
  val getages : Fb.contact list -> int list
end
  
