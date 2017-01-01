#!/bin/bash

OCAML_VERSION=$1
OCAML_VERSIONS="402 403 404"

for V in $OCAML_VERSIONS
do
    if [ "$OCAML_VERSION" = "$V" ]; then
        echo "=> OCamlFrontend$V.mli (current version)"
        (cd ocaml_parsetrees/$V &&
            echo "(* GENERATED FILE.  DO NOT MODIFY BY HAND *)" &&
            echo "module Location = Location"
            echo "module Longident = Longident"
            echo "module Asttypes = Asttypes"
            echo "module Parsetree = Parsetree"
            echo ""
        ) > OCamlFrontend$V.mli
    else
        echo "=> OCamlFrontend$V.mli"
        (cd ocaml_parsetrees/$V &&
            echo "(* GENERATED FILE.  DO NOT MODIFY BY HAND *)" &&
            echo "module Location : sig" && sed -e 's/^/  /' < location.mli && echo "end" &&
            echo "module Longident : sig" && sed -e 's/^/  /' < longident.mli && echo "end" &&
            echo "module Asttypes : sig" && sed -e 's/^/  /' < asttypes.mli && echo "end" &&
            echo "module Parsetree : sig" && sed -e 's/^/  /' < parsetree.mli && echo "end" &&
            echo ""
        ) > OCamlFrontend$V.mli
    fi
done

sed -e "s/%%OCAML_VERSION%%/${OCAML_VERSION}/" < migrate_parsetree_def.ml.in > migrate_parsetree_def.ml
