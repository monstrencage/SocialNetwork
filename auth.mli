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

(** Identifiants *)

(** Pour le moment, le programme utilise une authentification {% \og statique\fg %},
 où l'utilisateur entre manuellement à la compilation le jeton d'accès. *)

val user : string
(** Nom d'utilisateur Facebook. *)

val access_token : string
(** Jeton d'accès de l'application. *)
