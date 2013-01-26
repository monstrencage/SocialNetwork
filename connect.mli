(** Communications {% \textsc{Http} %} *)

val get : string -> string
(** [get url] renvoie le résultat de la requête {% \textsc{Http} %} [url]. *)

val get_list : ((string*string) * (string list) * string) -> string
(** [get_list] effectue une {% \og batch request\fg %} et en revoie le résultat. *)
