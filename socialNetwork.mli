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

(** Requêtes complexes *)

(** Le foncteur [Requetes] prend un module respectant l'interface [Social.T], et construit
 des opérateurs permettant de combiner et d'optimiser des requêtes. *)
 
module Requetes :
  functor (S : Social.T) ->
    sig
      (** Objets de base. *)
      module Obj :
      sig(**/**)
        type id = string
        type gender = S.Obj.gender = Male | Female | Unknown
        type info = S.Obj.info
        val make_info : string -> Date.t -> gender -> info
        val name : info -> string
        val birthday : info -> Date.t
        val gender : info -> gender
        val age : info -> int
        type contact = S.Obj.contact
        val make_contact : string -> id -> contact
        val f_name : contact -> string
        val f_id : contact -> id
        type like = S.Obj.like
        val make_like : id -> string -> string -> Date.t -> like
        val l_id : like -> id
        val l_name : like -> string
        val cat : like -> string
        val since : like -> Date.t
        type comment = S.Obj.comment
        val make_comment :
          id -> string -> Date.t -> contact -> int -> comment
        val c_id : comment -> id
        val c_content : comment -> string
        val c_date : comment -> Date.t
        val c_from : comment -> contact
        val c_like : comment -> int
        type message = S.Obj.message
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
        
      (** Requêtes de base *)
      module GetObj :
      sig (**/**)
        exception NotSupported
        type ('a, 'b) req =
          ('a, 'b) S.GetObj.req =
        | Contact : (S.Obj.id, S.Obj.contact) req
        | Contacts : (S.Obj.contact, S.Obj.contact list) req
        | MutualF :
            S.Obj.contact -> (S.Obj.contact, S.Obj.contact list) req
        | Posts : (S.Obj.contact, S.Obj.message list) req
        | Feed : (S.Obj.contact, S.Obj.message list) req
        | Likes : (S.Obj.contact, S.Obj.like list) req
        | Infos : (S.Obj.contact, S.Obj.info) req
        | Since : Date.t * ('a, 'b list) req -> ('a, 'b list) req
        | Until : Date.t * ('a, 'b list) req -> ('a, 'b list) req
        val get : 'a -> ('a, 'b) req -> 'b
        val get_list : ('a list * ('a, 'b) req) list -> 'b list
      end
	
      (** Combinateurs de requêtes *)
      type ('a, 'b) comb =
        Get : ('a, 'b) GetObj.req -> ('a, 'b) comb
        (** Appeler une requête de base. *)
      | SelectM :
          (('a list, 'b list) comb * ('b -> int)) -> ('a list, 'a) comb
        (** Sélectionner l'élément d'une liste maximisant la composition d'une requête et d'une fonction. *)
      | Selectm :
          (('a list, 'b list) comb * ('b -> int)) -> ('a list, 'a) comb
        (** Sélectionner l'élément d'une liste minimisant la composition d'une requête et d'une fonction. *)
      | Filter :
          (('a list, 'b list) comb * ('b -> bool)) -> ('a list, 'a list) comb
        (** Filter les éléments d'une liste vérifiant la composition d'une requête et d'un condition booléenne. *)
      | Comp : ('a, 'b) comb * ('b, 'c) comb -> ('a, 'c) comb
        (** Composition de deux requêtes. *)
      | Ou : ('a, 'b list) comb * ('a, 'b list) comb -> ('a, 'b list) comb
        (** Disjonction de deux requêtes. *)
      | Et : ('a, 'b list) comb * ('a, 'b list) comb -> ('a, 'b list) comb
        (** Conjonction de deux requêtes. *)
      | Map : ('a, 'b) comb -> ('a list, 'b list) comb
        (** Applique une requête à tous les éléments d'une liste. *)
      | Bind : ('a, 'b list) comb -> ('a list, 'b list) comb
      (** Applique une requête à tous les éléments d'une liste et concatène les listes obtenues. *)
        
      val opt : ('a, 'b) comb -> ('a, 'b) comb
      (** Fonction d'optimisation des requêtes. Il est intéressant de noter qu'ici il est bien plus efficace
	  de tranformer {% $map\ (f\circ g)$ en $(map\ f)\circ(map\ g)$ %} que le contraire, car le temps de 
	  calcul est principalement dû aux communication (et pas au parcours de liste), et que si f et g sont
	  assez simples, on peut obtenir {% $map\ f$ et $map\ g$ %} en une communication chacune. En revanche
	  si on fait {% $map\ (f\circ g)$ %} on devra appliquer successivement {% $g$ %} et {% $f$ %} à tous 
	  les éléments de la liste. *)
      val get_obj : 'a -> ('a, 'b) comb -> 'b
      (** Éxécute une requête. *)
      val ( |> ) : ('a, 'b) comb -> ('b, 'c) comb -> ('a, 'c) comb
      (** Opérateur infixe pour la combinaison des requêtes. *)
      val ( @ ) : ('a, 'b) comb -> 'a -> 'b
      (** Opérateur infixe pour optimiser puis exécuter une requête. *)
	
      (** Autres fonctions utiles. *)
	
      val contact_from_id : S.Obj.id -> S.Obj.contact
      val contacts_from_ids : S.Obj.id list -> S.Obj.contact list
      val getage : S.Obj.contact -> int
      val getages_dumb : S.Obj.contact list -> int list
      val getages : S.Obj.contact list -> int list
    end
      
