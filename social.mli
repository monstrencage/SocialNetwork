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

(** Interface d'un réseau social *)

(** Voir les modules [Fb] et [GetFb] pour le détail des fonction ci-dessous. *)

module type T = 
  sig
    module Obj : 
      sig
        type id = string
	
        type gender = Male | Female | Unknown

        type info
        val make_info : string -> Date.t -> gender -> info
        val name : info -> string
        val birthday : info -> Date.t
        val gender : info -> gender
        val age : info -> int

        type contact
        val make_contact : string -> id -> contact
        val f_name : contact -> string
        val f_id : contact -> id

        type like
        val make_like : id -> string -> string -> Date.t -> like
        val l_id : like -> id
        val l_name : like -> string
        val cat : like -> string
        val since : like -> Date.t

        type comment
        val make_comment : id -> string -> Date.t -> contact -> int -> comment
        val c_id : comment -> id
        val c_content : comment -> string
        val c_date : comment -> Date.t
        val c_from : comment -> contact
        val c_like : comment -> int

        type message
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
          | Contact : (Obj.id, Obj.contact) req
          | Contacts : (Obj.contact, Obj.contact list) req
          | MutualF : Obj.contact -> (Obj.contact, Obj.contact list) req
          | Posts : (Obj.contact, Obj.message list) req
          | Feed : (Obj.contact, Obj.message list) req
          | Likes : (Obj.contact, Obj.like list) req
          | Infos : (Obj.contact, Obj.info) req
          | Since : Date.t * ('a, 'b list) req -> ('a, 'b list) req
          | Until : Date.t * ('a, 'b list) req -> ('a, 'b list) req
        val get : 'a -> ('a, 'b) req -> 'b
        val get_list : ('a list * ('a, 'b) req) list -> 'b list
      end
  end
    
