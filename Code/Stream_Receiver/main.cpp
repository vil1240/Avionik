#include <iostream>
#include <opencv2/opencv.hpp>

using namespace cv;
using namespace std;

void receiver();

int main()
{
    receiver();
    return 0;
}

void receiver()
{
    // The sink caps for the 'rtpjpegdepay' need to match the src caps of the 'rtpjpegpay' of the sender pipeline
    // Added 'videoconvert' at the end to convert the images into proper format for appsink, without
    // 'videoconvert' the receiver will not read the frames, even though 'videoconvert' is not present
    // in the original working pipeline
    VideoCapture cap("udpsrc port=5000 ! application/x-rtp,media=video,payload=26,clock-rate=90000,encoding-name=JPEG,framerate=30/1 ! rtpjpegdepay ! jpegdec ! videoconvert ! appsink",CAP_GSTREAMER);

    if(!cap.isOpened())
    {
        cout<<"VideoCapture not opened"<<endl;
        exit(-1);
    }

    Mat frame;

    while(true) {

        cap.read(frame);

        if(frame.empty())
            break;

        imshow("Receiver", frame);
        if(waitKey(1) == 'r')
            break;
    }
    destroyWindow("Receiver");
}