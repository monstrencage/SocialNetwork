open Facebook.Pub;;

open Obj;;

open GetObj;;

let chrono f x= (Tools.chrono "Temps total" f x);;


Printf.printf "Requêtes sur les candidats à la présidentientielle 2012.\n\n";;

(** Liste des identifiants des candidats à la présidentielle. *)
let p = [
    "JLMelenchon";"nicolassarkozy";"francoishollande.fr";"jacquescheminade2012";
    "EvaJoly.fr";"nicolasdupontaignan";"bayrou";"MLP.officiel"];;
    
Printf.printf "Liste des personalités politiques :\n";
List.iter (Printf.printf "%s; ") p; print_newline ();;

(** Comme liste de contacts *)
Printf.printf "\nComme liste de contacts :\n";;
let pp = (Map (Get Contact))@p;;
List.iter print_contact pp;
print_newline;;

(** La personnalité politique qui poste le plus depuis une date donnée. *)
let posts_max d= 
    ((Map (Get Contact))
     |>(SelectM (Map (Get (Since (Date.from_string d, Posts))), List.length)))@p;;
    
(** Depuis le 1er avril. *)
Printf.printf "\nLa personnalité politique qui poste le plus depuis le 1er avril:\n";;
let pM = chrono posts_max "04/01/2012";;
print_contact pM;
print_newline;;

let nb_comm = List.fold_left (fun acc c -> acc + nb_com c) 0;;

(** La personnalité politique dont les posts sont les moins commentés. *)
let comm_min l=
    ((Map (Get Contact))
     |>(Selectm (Map (Get Posts), nb_comm)))@l;;

Printf.printf "\nLa personnalité politique dont les posts sont les moins commentés:\n";;
let c = chrono comm_min p;;
print_contact c;
print_newline;;

(** Le post le moins commenté d'une personnalité politique.*)
let le_post_le_moins_commente_de pers =
    Tools.elect_min 
        nb_com 
        (((Get Contact)|>(Get Posts))@pers);;
        
Printf.printf "Le post le moins commenté d'une personnalité politique :\n";;
Printf.printf "Jacques Cheminade :\n";;
let chem = chrono le_post_le_moins_commente_de "jacquescheminade2012";;
print_message chem;;

Printf.printf "François Hollande:\n";;
let fran = chrono le_post_le_moins_commente_de "francoishollande.fr";;
print_message fran;;

(** La liste des personnalités politiques ayant plus qu'un nombre de posts donné. *)
let plus_de_posts n=
    (((Map (Get Contact))|>(Filter(Map (Get Posts),fun x -> List.length x > n)))@p);;

Printf.printf "La liste des personnalités politiques ayant plus de 200 posts :\n";;
let pp200 = chrono plus_de_posts 200;;
List.iter print_contact pp200;;

Printf.printf "La liste des personnalités politiques ayant plus de 150 posts :\n";;                         
let pp150 = chrono plus_de_posts 150;;
List.iter print_contact pp150;;

Printf.printf "La liste des personnalités politiques ayant plus de 10 posts :\n";;                           
let pp10 = chrono plus_de_posts 10;;
List.iter print_contact pp10;;

Printf.printf "La liste des personnalités politiques ayant plus de 5 posts :\n";; 
let pp5 = chrono plus_de_posts 5;;
List.iter print_contact pp5;;
