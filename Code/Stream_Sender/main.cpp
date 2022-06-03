#include <iostream>
#include <opencv2/opencv.hpp>


using namespace cv;
using namespace std;



void sender();

int main(int argc, char** argv )
{
    sender();
    return 0;
}

void sender()
{
    VideoCapture cap("videotestsrc ! video/x-raw,width=1920,height=1080,framerate=60/1 ! appsink",CAP_GSTREAMER);
//    VideoCapture cap("ximagesrc ! video/x-raw,framerate=20/1 ! videoscale ! appsink",CAP_GSTREAMER);

    VideoWriter out("appsrc ! videoconvert ! x264enc tune=zerolatency bitrate=12000 speed-preset=superfast ! h264parse ! rtph264pay ! udpsink host=192.168.188.27 port=5000",
                    CAP_GSTREAMER,0,60,Size(1920,1080),true);


    if(!cap.isOpened() || !out.isOpened())
    {
        cout<<"VideoCapture or VideoWriter not opened"<<endl;
        exit(-1);
    }

    Mat frame;

    while(true) {
        cap.read(frame);
        if(frame.empty())
            break;

        out.write(frame);
        imshow("Sender", frame);
        resizeWindow("Sender", 1920, 1080);
        if(waitKey(1) == 's' || waitKey(1) == 27)
            break;
    }
    destroyWindow("Sender");
}