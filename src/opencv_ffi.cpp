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
	bool success = cv::imencode(".jpg", *cvImage, vec);
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
