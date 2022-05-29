# Video von Kamera über rtsp,udp senden:
# Video von Kamera ist H264,1920x1080x30fps wird in rtsp verpackt wird, in udp verpackt und gesendet.
gst-launch-1.0 v4l2src ! video/x-h264,width=1920,height=1080,framerate=30/1 ! h264parse ! rtph264pay config-interval=1 pt=96 ! udpsink sync=false host=127.0.0.1 port=5000

# ! Wird in der pipeline an einer stelle in eine Datei geschrieben (hier filesink) muss mit -e die pipeline kontrolliert geschlossen werden können.
# Video von Kamera ist H264,1920x1080x30fps wird in mp4 Datei gespeichert. Gleichzeitig wird der gleiche videostream in rtsp verpackt, wird in udp verpackt und gesendet.
gst-launch-1.0 -e v4l2src ! video/x-h264,width=1920,height=1080,framerate=30/1 ! h264parse ! tee name=t ! queue ! mp4mux ! filesink location=filestream.mp4 t. ! queue ! rtph264pay config-interval=1 pt=96 ! udpsink sync=false host=127.0.0.1 port=5000



# Video von udp,rtsp empfangen und anzeigen.
# Video on Kamera ist raw Format wird h264 encoded und in rtsp,udp verpackt und gesendet.
gst-launch-1.0 v4l2src ! videoconvert ! video/x-raw,format=YVYU,width=640,height=480,framerate=30/1 ! videoconvert ! x264enc ! h264parse ! rtph264pay config-interval=1 pt=96 ! udpsink sync=false host=127.0.0.1 port=5000

# rtsp stream wird über udp empfangen und entpackt, decoded(decodebin decoded h264 in raw) und angezeigt.
gst-launch-1.0 udpsrc port=5000 caps = "application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96" ! rtph264depay ! decodebin ! videoconvert ! autovideosink sync=false

# rtsp stream wird über udp empfangen und entpackt und der enthaltende h264 stream wird gespeichert. Gleichzeitig wird der gleiche h264 stream decoded (decodebin decoded h264 in raw) und angezeigt.
gst-launch-1.0 udpsrc port=5000 caps = "application/x-rtp, media=(string)video, clock-rate=(int)90000, encoding-name=(string)H264, payload=(int)96" ! rtph264depay ! h264parse ! tee name=t ! queue ! mp4mux ! filesink location=filestream.mp4 t. ! queue ! decodebin ! videoconvert ! autovideosink sync=false

