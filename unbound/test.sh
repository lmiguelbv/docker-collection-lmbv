docker exec -it unbound sh -lc '
  echo "# forward-zone blocks:" ;
  grep -Rin "^[[:space:]]*forward-zone:" /usr/local/unbound || true ;
  echo "# lines naming the ROOT (.) forward:" ;
  grep -Rin "^[[:space:]]*name:[[:space:]]*\"\\.\"" /usr/local/unbound || true
'
