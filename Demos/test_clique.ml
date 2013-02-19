(*Librairies*)
open Facebook.Priv;;

open Obj;;

open GetObj;;        

(* Appels *)

let get_clique moi =
  let fr = (Get Contacts)@moi
  in
    let frfr = ((Map (Get (MutualF moi)))@fr)
    in
      Clique.clique fr frfr;;
      
let id = Auth.user;;  

let moi = (Get Contact)@id;;
      
let ma_clique = (Tools.chrono "Temps total" get_clique moi);;

Printf.printf "\n Résulat :\n\n";;
List.iter print_contact ma_clique;;
Printf.printf "\nTaille de la clique : %d.\n" (List.length ma_clique);;
