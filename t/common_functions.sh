
TESTNUMBERFILE="`mktemp`"
echo 0 > /tmp/microservice_testnumberfile

start_test() {
    TESTNUMBER="`cat /tmp/microservice_testnumberfile`"
    TESTNUMBER="$((TESTNUMBER+1))"
    echo "$TESTNUMBER" > /tmp/microservice_testnumberfile
}

equals() {
    start_test
    VAR1=$1 ; shift
    VAR2=$1 ; shift
    [ "$VAR1" == "$VAR2" ] && echo "ok $TESTNUMBER $*"
    [ "$VAR1" == "$VAR2" ] || echo "not ok $TESTNUMBER $* '$VAR1' == '$VAR2'"
}

is_file() {
    start_test
    VAR1=$1 ; shift
    [ -f "$VAR1" ] && echo "ok $TESTNUMBER $*"
    [ -f "$VAR1" ] || echo "not ok $TESTNUMBER $* '$VAR1'"
}

is_dir() {
    start_test
    VAR1=$1 ; shift
    [ -d "$VAR1" ] && echo "ok $TESTNUMBER $*"
    [ -d "$VAR1" ] || echo "not ok $TESTNUMBER $* '$VAR1'"
}

end_test() {
    rm -f /tmp/microservice_testnumberfile
}
