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

module Requetes (S : Social.T) = struct

  module Obj = S.Obj

  module GetObj = S.GetObj
    
  open Obj
  
  open GetObj

  type ('a,'b) comb =
  | Get : ('a,'b) req -> ('a,'b) comb
  | SelectM : (('a list, 'b list) comb * ('b -> int)) -> ('a list,'a) comb
  | Selectm : (('a list, 'b list) comb * ('b -> int)) -> ('a list,'a) comb
  | Filter : (('a list, 'b list) comb * ('b -> bool)) -> ('a list,'a list) comb
  | Comp : ('a,'b) comb * ('b,'c) comb -> ('a,'c) comb
  | Ou : ('a,'b list) comb * ('a,'b list) comb -> ('a,'b list) comb
  | Et : ('a,'b list) comb * ('a,'b list) comb -> ('a,'b list) comb
  | Map : ('a,'b) comb -> ('a list,'b list) comb
  | Bind : ('a,'b list) comb -> ('a list,'b list) comb

  let rec opt : type a b. (a,b) comb -> (a,b) comb = function
    | Map (Comp (c1,c2)) -> Comp (opt (Map c1),opt (Map c2))
    | Bind (Comp (c1,c2)) -> Comp (opt (Map c1),opt (Bind c2))
    | Ou (c1,c2) -> Ou (opt c1, opt c2)
    | Et (c1,c2) -> Et (opt c1, opt c2)
    | Map c -> Map (opt c)
    | Bind c -> Bind (opt c)
    | SelectM (c,f) -> SelectM (opt c,f)
    | Selectm (c,f) -> Selectm (opt c,f)
    | Filter (c,f) -> Filter (opt c,f)
    | c -> c

  let rec get_obj : type a b. a -> (a,b) comb -> b = fun x ->
    function
    | Get r -> get x r
    | SelectM (c,f) -> Tools.selectM f (x,get_obj x c)
    | Selectm (c,f) -> Tools.selectm f (x,get_obj x c)
    | Filter (c,f) -> 
      Tools.filter f (x,get_obj x c)
    | Comp (c1,c2) -> 
      (let y = get_obj x c1
       in get_obj y c2)
    | Ou (Get r1,Get r2) ->
      (match (get_list [([x], r1);([x],r2)]) with
      | [l1;l2] -> (Tools.disj l1 l2)
      | _ -> failwith "get_obj : Ou")
    | Ou (Map (Get r1),Map (Get r2)) ->
      (Tools.clean (get_list [(x,r1);(x,r2)]))
    | Ou (Bind (Get r1),Bind (Get r2)) ->
      (Tools.clean (List.concat (get_list [(x,r1);(x,r2)])))
    | Ou (c1,c2) ->
      (Tools.disj (get_obj x c1) (get_obj x c2))
    | Et (Get r1,Get r2) ->
      (match (get_list [([x],r1);([x],r2)]) with
      | [l1;l2] -> (Tools.conj l1 l2)
      | _ -> failwith "get_obj : Et")
    | Et (Map (Get r1),Map (Get r2)) ->
      (Tools.filter_twice (get_list [(x,r1);(x,r2)]))
    | Et (Bind (Get r1),Bind (Get r2)) ->
      (Tools.filter_twice (List.concat (get_list [(x,r1);(x,r2)])))
    | Et (c1,c2) ->
      (Tools.conj (get_obj x c1) (get_obj x c2))
    | Map (Get r) -> get_list [x, r]
    | Map c -> (List.map (fun y -> get_obj y c) x)
    | Bind (Get r) -> List.concat (get_list [x,r])
    | Bind c -> (Tools.bind (fun y -> get_obj y c) x)

  let ( |> ) = fun c c' -> Comp (c,c')   
    
  let ( @ ) q d = get_obj d (opt q)
    
  let contact_from_id id = (Get Contact)@id

  let contacts_from_ids l =
    (Map (Get Contact))@l
      
  let getage c = (age ((Get Infos)@c))

  let getages_dumb l =
    List.map getage l
      
  let getages l = 
    (List.map age ((Map (Get Infos))@l))
end

module Facebook = 
  Requetes (struct 
    module Obj = Fb
    module GetObj = Getfb
  end)

module Facebook2 = 
  Requetes (struct 
    module Obj = struct
      include Fb
      let gender _ = raise Getfb.NotSupported
    end
    module GetObj = Getfb_public
  end)
