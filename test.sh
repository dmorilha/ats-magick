#/bin/sh
set -e -x -u;
DIR=${DIR:=`mktemp -d;`}
convert apache.png $@ $DIR/apache-2.png;
CONVERT=${CONVERT:="convert mpr:b $@ mpr:a"};
MAGICK="`echo -n ${CONVERT} | base64 -w 0 - | node -p 'escape(require("fs").readFileSync("/dev/stdin", "utf-8"));';`";
echo -n "${MAGICK}" | KEY=${KEY:=keys/rsa256-private} ./sign.sh > $DIR/a;
echo -n "${MAGICK}" | KEY=${KEY:=keys/rsa256-public} SIG=${SIG:=$DIR/a} ./verify.sh;
echo -e "\n?magick=${MAGICK}&magickSig=`base64 -w 0 $DIR/a | node -p 'escape(require("fs").readFileSync("/dev/stdin", "utf-8"));'`";
