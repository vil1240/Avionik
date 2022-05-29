
"""gstreamer with tut:
gst-launch-1.0 v4l2src device=/dev/video0 ! video/x-raw, format=I420, width=640, height=480 ! omxh264enc ! rtph264pay ! udpsink host=127.0.0.1 port=5002

gst-launch-1.0 udpsrc port="5002" caps="application/x-rtp, media=(string)video, encoding-name=(string)H264, sampling=(string)YCbCr-4:2:0, width=(string)640, height=(string)480" ! rtph264depay ! decodebin ! videoconvert ! xvimagesink
"""

"""
raspivid -n -w 1280 -h 720 -b 4500000 -fps 30 -t 0 -o - | gst-launch-1.0 -v fdsrc ! h264parse ! tee name=splitter ! queue ! rtph264pay config-interval=10 pt=96 ! udpsink host=127.0.0.1 port=5000 splitter. ! queue filesink location="videofile.h264"

gst-launch-1.0 -v tcpclientsrc host=127.0.0.1 port=5000 caps='application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264' ! rtph264depay ! avdec_h264 ! videoconvert ! autovideosink sync=false


gst-launch-1.0 filesrc location=~/Monitor/02-20210714102504.mkv ! decodebin ! omxh264enc ! rtph264pay config-interval=1 pt=96 ! udpsink host=127.0.0.1 port=5000
gst-launch-1.0 v4l2src device=/dev/video0 ! video/x-raw, format=I420, width=640, height=480 ! omxh264enc ! rtph264pay config-interval=1 pt=96 ! udpsink host=127.0.0.1 port=5000
"""