img="$1"
mesg="Screenshots can be edited with swappy by using Alt+e"
choices="Selection|Window|Monitor|All"

_rofi() {
    rofi -dmenu \
        -theme "$HOME/.cache/wallust/rofi-menu-noinput.rasi" \
        -sep '|' \
        -disable-history true \
        -kb-custom-1 "Alt-e" \
        -mesg "$mesg" \
        -cycle true \
        -lines 4 \
        "$@"
}

selected=$(echo "$choices" | _rofi -)
# exit code 10 is Alt-e
exit_code=$?

# first arg is the grimblast command
screenshot() {
    mkdir -p "$(dirname "$img")"

    if [ "$exit_code" -eq 10 ]; then
        grimblast save "$1" - | swappy -f - -o "$img"
        notify-send "Screenshot saved to $img" -i "$img"
    else
        grimblast --notify copysave "$1" "$img"
    fi
}

# small sleep delay is required so rofi menu doesnt appear in the screenshot
case "$selected" in
    "All")
        delay=$(echo "0|3|5" | _rofi "$@")
        sleep 0.5
        sleep "$delay"
        screenshot screen
        ;;
    "Monitor")
        delay=$(echo "0|3|5" | _rofi "$@")
        sleep 0.5
        sleep "$delay"
        screenshot output
        ;;
    "Selection")
        screenshot area
        ;;
    "Window")
        delay=$(echo "0|3|5" | _rofi "$@")
        sleep 0.5
        sleep "$delay"
        screenshot active
        ;;
esac