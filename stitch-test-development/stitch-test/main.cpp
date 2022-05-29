#include <iostream>
#include <deque>
#include <vector>
#include <chrono>

#include <cpp-utils/types.hpp>

#include <opencv2/stitching.hpp>
#include <opencv2/opencv.hpp>

bool printError(cv::Stitcher::Status result, const std::string &message = "") {
  if (!message.empty() && result != cv::Stitcher::Status::OK) {
    std::cout << message << ": ";
  }
  
  switch (result)
  {
    case (cv::Stitcher::Status::OK): {
      return true;
    }

    case (cv::Stitcher::Status::ERR_NEED_MORE_IMGS): {
      std::cout << "Stitcher needs more images" << std::endl; 
      return false;
    }

    case (cv::Stitcher::Status::ERR_HOMOGRAPHY_EST_FAIL): {
      std::cout << "Stitcher failed to estimate homography matrix" << std::endl; 
      return false;
    }

    case (cv::Stitcher::Status::ERR_CAMERA_PARAMS_ADJUST_FAIL): {
      std::cout << "Stitcher failed to adjust camera parameters" << std::endl; 
      return false;
    }
  }
}

i32 main() {
  cv::VideoCapture camera;

  camera.open(0);
  camera.set(cv::CAP_PROP_BUFFERSIZE, 1);

  std::deque<cv::UMat> frame_queue;
  bool frame_limit = false;

  cv::Ptr<cv::Stitcher> stitcher = cv::Stitcher::create();
  stitcher->setBlender(cv::makePtr<cv::detail::MultiBandBlender>(true));
  stitcher->setWarper(cv::makePtr<cv::SphericalWarperGpu>());
  stitcher->setExposureCompensator(cv::makePtr<cv::detail::NoExposureCompensator>());
  stitcher->setSeamFinder(cv::makePtr<cv::detail::NoSeamFinder>());

  auto last_timestamp = std::chrono::steady_clock::now();

  while (true) {
    if (!frame_limit) {
      cv::UMat &last_frame = frame_queue.emplace_back();
      camera >> last_frame;

      if (last_frame.empty()) {
        std::cout << "Invalid image." << std::endl;
        continue;
      }

      std::cout << "Captured image "<< last_frame.cols << "x" << last_frame.rows << std::endl;
    }

    cv::UMat panorama;

    std::vector<cv::UMat> frame_vector(frame_queue.begin(), frame_queue.end());

    if (!frame_limit) {
      cv::Stitcher::Status result = stitcher->estimateTransform(frame_vector);

      if (result == cv::Stitcher::Status::ERR_HOMOGRAPHY_EST_FAIL || result == cv::Stitcher::Status::ERR_CAMERA_PARAMS_ADJUST_FAIL) {
        frame_queue.pop_back();
        frame_limit = false;
      }

      if (!printError(result, "Estimate transform")) {       
        goto show_image;
      }
    }

    try {
      printError(stitcher->composePanorama(frame_vector, panorama), "Compose panorama");
    } catch (cv::Exception &e) {
      frame_queue.pop_back();
      frame_limit = false;
    }

  show_image:
    cv::InputArray image = panorama.empty() ? cv::InputArray(frame_queue.front()) : cv::InputArray(panorama);
    cv::imshow("Webcam", image);

    if (frame_limit) {
      auto timestamp = std::chrono::steady_clock::now();
      std::chrono::milliseconds time_difference = std::chrono::duration_cast<std::chrono::milliseconds>(timestamp - last_timestamp);
      last_timestamp = timestamp;

      std::cout << panorama.cols << "x" << panorama.rows << " (" << time_difference.count() << "ms)" << std::endl;
    } else {
      std::cout << "Please press a key" << std::endl;
      cv::waitKey();
    }

    static const u16 frames = 6;
    if (frame_queue.size() == frames && !frame_limit) {
      frame_limit = true;
      std::cout << "Frame limit reached" << std::endl;
    }
  }

  return 0;
}
