!/bin/bash
INTERFACE="wlp2s0"

function show_help() {
    echo "Usage: $0 [set|change|clear] [DOWNLOAD] [UPLOAD]"
    echo
    echo "Commands:"
    echo "  set DOWNLOAD UPLOAD    : Set new limit in kbit/s"
    echo "  change DOWNLOAD UPLOAD : Change existing limit"
    echo "  clear                  : Remove all limits"
    echo
    echo "Example:"
    echo "  $0 set 1024 512   # limit 1 Mbps download, 512 kbps upload"
    echo "  $0 clear          # remove limit"
    exit 1
}

if [ $# -lt 1 ]; then
    show_help
fi

COMMAND=$1
DOWNLOAD=$2
UPLOAD=$3

case $COMMAND in
    set)
        if [ -z "$DOWNLOAD" ] || [ -z "$UPLOAD" ]; then
            show_help
        fi
        sudo tc qdisc del dev $INTERFACE root 2>/dev/null
        sudo tc qdisc add dev $INTERFACE root handle 1: htb default 10
        sudo tc class add dev $INTERFACE parent 1: classid 1:10 htb rate ${DOWNLOAD}kbit ceil ${DOWNLOAD}kbit
        sudo tc filter add dev $INTERFACE protocol ip parent 1:0 prio 1 u32 match ip src 0.0.0.0/0 flowid 1:10
        echo "Limit set: Download ${DOWNLOAD} kbit/s, Upload ${UPLOAD} kbit/s"
        ;;
    change)
        if [ -z "$DOWNLOAD" ] || [ -z "$UPLOAD" ]; then
            show_help
        fi
        sudo tc class change dev $INTERFACE parent 1: classid 1:10 htb rate ${DOWNLOAD}kbit ceil ${DOWNLOAD}kbit
        echo "Limit changed: Download ${DOWNLOAD} kbit/s, Upload ${UPLOAD} kbit/s"
        ;;
    clear)
        sudo tc qdisc del dev $INTERFACE root 2>/dev/null
        echo "Limit removed"
        ;;
    *)
        show_help
        ;;
esac
