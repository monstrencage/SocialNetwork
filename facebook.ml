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

module Priv = 
  SocialNetwork.Requetes (struct 
    module Obj = Fb
    module GetObj = GetFb
  end)

module Pub = 
  SocialNetwork.Requetes (struct 
    module Obj = struct
      include Fb
      let gender _ = raise GetFb.NotSupported
    end
    module GetObj = GetFbPublic
  end)
