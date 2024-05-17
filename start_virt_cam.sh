# https://adityatelange.in/blog/android-phone-webcam-linux/#fn:2
# https://github.com/umlaeute/v4l2loopback/issues/247

sudo modprobe v4l2loopback exclusive_caps=1 max_buffers=2 card_label="Virt Cam"

output=$(v4l2-ctl --list-devices)

x=$(echo "$output" | awk '/Virt Cam/{getline; print $1}')

echo "The device path for Virt Cam is: $x"

echo "Available ADB devices are: "

adb devices

echo "Starting scrcpy..."

front_or_back=$(read -p "Front or back camera? ")

scrcpy --video-source=camera --no-audio --camera-facing=$front_or_back --v4l2-sink=/dev/video2

cleanup() {
    echo "Running cleanup..."
    sudo modprobe -r v4l2loopback
}

trap cleanup EXIT
trap cleanup SIGINT
