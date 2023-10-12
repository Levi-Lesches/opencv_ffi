#include <opencv2/videoio.hpp>
#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/core/utils/logger.hpp>

#include "opencv_ffi.h"

FFI_PLUGIN_EXPORT VideoCapture* VideoCapture_getByIndex(int index) {
	return reinterpret_cast<VideoCapture*>(new cv::VideoCapture(index, 0));
}

FFI_PLUGIN_EXPORT VideoCapture* VideoCapture_getByName(char* name) {
	std::string filename = name;
	return reinterpret_cast<VideoCapture*>(new cv::VideoCapture(filename, 0));
}

FFI_PLUGIN_EXPORT void VideoCapture_destroy(VideoCapture* capture) {
	delete reinterpret_cast<cv::VideoCapture*>(capture);
}

FFI_PLUGIN_EXPORT void VideoCapture_release(VideoCapture* capture) {
	reinterpret_cast<cv::VideoCapture*>(capture)->release();
}

FFI_PLUGIN_EXPORT int VideoCapture_isOpened(VideoCapture* capture) {
	return reinterpret_cast<cv::VideoCapture*>(capture)->isOpened();
}

FFI_PLUGIN_EXPORT int VideoCapture_read(VideoCapture* capture, Mat* image) {
	cv::Mat* cvImage = reinterpret_cast<cv::Mat*>(image);
	return reinterpret_cast<cv::VideoCapture*>(capture)->read(*cvImage);
}

FFI_PLUGIN_EXPORT void VideoCapture_setResolution(VideoCapture* capture, int width, int height) {
	cv::VideoCapture* pointer = reinterpret_cast<cv::VideoCapture*>(capture);
	pointer->set(cv::CAP_PROP_FRAME_WIDTH, width);
	pointer->set(cv::CAP_PROP_FRAME_HEIGHT, height);
}
// The specific values for each camera control may be different for different cameras

// For Camera controls: 
// On Linux 
// To see minimum and maximum values of each setting use
// $ v4l2-ctl -d 0 -l

// On Windows 
// Use AMCap and check camera properties or use FFMPEG 
// For FFMPEG I recommend using Chocolatey

// $ ffmpeg -list_devices true f dshow -i dummy
// ffmpeg -f dshow -list_options true -i video="Your video device"
// *make sure there are no spaces between video="Your video device"

/* Zoom:
*/ 

FFI_PLUGIN_EXPORT void VideoCapture_zoom(VideoCapture* capture, int zoomLevel) {
    cv::VideoCapture* pointer = reinterpret_cast<cv::VideoCapture*>(capture);
    pointer->set(cv::CAP_PROP_ZOOM, zoomLevel);
}

/* Pan:
*/ 
FFI_PLUGIN_EXPORT void VideoCapture_pan(VideoCapture* capture, int panLevel) {
    cv::VideoCapture* pointer = reinterpret_cast<cv::VideoCapture*>(capture);
    pointer->set(cv::CAP_PROP_PAN, panLevel); 
}

/* Tilt:
*/ 
FFI_PLUGIN_EXPORT void VideoCapture_tilt(VideoCapture* capture, int tiltLevel) {
    cv::VideoCapture* pointer = reinterpret_cast<cv::VideoCapture*>(capture);
    pointer->set(cv::CAP_PROP_ZOOM, tiltLevel);
}

/* Focus:
*/ 
FFI_PLUGIN_EXPORT void VideoCapture_focus(VideoCapture* capture, int focusLevel) {
    cv::VideoCapture* pointer = reinterpret_cast<cv::VideoCapture*>(capture);
    pointer->set(cv::CAP_PROP_FOCUS, focusLevel);
}

/* Autofocus:	
*/
FFI_PLUGIN_EXPORT void VideoCapture_toggleAutofocus(VideoCapture* capture, int autofocusToggle) {
    cv::VideoCapture* pointer = reinterpret_cast<cv::VideoCapture*>(capture);
    pointer->set(cv::CAP_PROP_AUTOFOCUS, autofocusToggle);
}

FFI_PLUGIN_EXPORT Mat* Mat_create() {
	return reinterpret_cast<Mat*>(new cv::Mat());
}

FFI_PLUGIN_EXPORT void Mat_destroy(Mat* matrix) {
	delete reinterpret_cast<cv::Mat*>(matrix);
}

FFI_PLUGIN_EXPORT void imshow(Mat* image) {
	cv::Mat* cvImage = reinterpret_cast<cv::Mat*>(image);
	cv::imshow("Wrapper", *cvImage);
	cv::waitKey(1);
}

FFI_PLUGIN_EXPORT int encodeJpg(Mat* image, int quality, uint8_t** pointer) {
	cv::Mat* cvImage = reinterpret_cast<cv::Mat*>(image);
	std::vector<uchar> vec;
	std::vector<int> compression_params;
	compression_params.push_back(cv::IMWRITE_JPEG_QUALITY);
	compression_params.push_back(quality);
	bool success = cv::imencode(".jpg", *cvImage, vec, compression_params);
	if (!success) return 0;

	// If this worked, work save the [vec] to a buffer at [pointer].
	uint8_t* result = (uint8_t*) calloc(vec.size(), sizeof(uint8_t));
	std::copy(vec.begin(), vec.end(), result);
	*pointer = result;
	return static_cast<int>(vec.size());
}

FFI_PLUGIN_EXPORT void setLogLevel(int level) {
	cv::utils::logging::setLogLevel(static_cast<cv::utils::logging::LogLevel>(level));
}

FFI_PLUGIN_EXPORT void freeImage(uint8_t* pointer) {
	free(pointer);
}
