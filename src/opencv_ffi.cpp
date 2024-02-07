#include <opencv2/videoio.hpp>
#include <opencv2/core.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/core/utils/logger.hpp>
#include <opencv2/objdetect.hpp>
#include <opencv2/objdetect/aruco_detector.hpp>

#include "opencv_ffi.h"
#include <vector>


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

FFI_PLUGIN_EXPORT void VideoCapture_setProperty(VideoCapture* capture, int propertyID, int value) {
	cv::VideoCapture* pointer = reinterpret_cast<cv::VideoCapture*>(capture);
	pointer->set(propertyID, value);
}

FFI_PLUGIN_EXPORT double VideoCapture_getProperty(VideoCapture* capture, int propertyID) {
	cv::VideoCapture* pointer = reinterpret_cast<cv::VideoCapture*>(capture);
	return pointer->get(propertyID);
}

// ArUco code
FFI_PLUGIN_EXPORT ArucoMarkers* detectMarkers(int dictionaryEnum, Mat* image) {	
	// Initialize step
	cv::Mat* cvImage = reinterpret_cast<cv::Mat*>(image);
	cv::aruco::Dictionary dictionary = cv::aruco::getPredefinedDictionary(dictionaryEnum);
	cv::aruco::DetectorParameters params = cv::aruco::DetectorParameters();
	cv::aruco::ArucoDetector detector(dictionary, params);

	// Forward to the OpenCV function
	std::vector<int> ids;
	std::vector<std::vector<cv::Point2f>> corners, rejected;
	detector.detectMarkers(*cvImage, corners, ids, rejected);

	size_t count = ids.size();
	ArucoMarker* markers = new ArucoMarker[count];
	for (int i = 0; i < count; i++) {
		int id = ids[i];
		std::vector<cv::Point2f> markerCorners = corners[i];
		markers[i] = ArucoMarker { };
		markers[i].id = ids[i];
		markers[i].upperLeft_x = markerCorners[0].x;
		markers[i].upperLeft_y = markerCorners[0].y;
		markers[i].upperRight_x = markerCorners[1].x;
		markers[i].upperRight_y = markerCorners[1].y;
		markers[i].lowerRight_x = markerCorners[2].x;
		markers[i].lowerRight_y = markerCorners[2].y;
		markers[i].lowerLeft_x = markerCorners[3].x;
		markers[i].lowerLeft_y = markerCorners[3].y;
	}

	auto result = new ArucoMarkers;
	result->markers = markers;
	result->count = (int) count;
	return result;
}

FFI_PLUGIN_EXPORT void drawDetectedMarkers(Mat* image, ArucoMarkers* data) {
	std::vector<std::vector<cv::Point2f>> corners, rejected;
	std::vector<int> ids;
	for (int i = 0; i < data->count; i++) {
		ids.push_back(data->markers[i].id);
		std::vector<cv::Point2f> markerCorners;
		markerCorners.push_back(cv::Point2f(data->markers[i].upperLeft_x, data->markers[i].upperLeft_y));
		markerCorners.push_back(cv::Point2f(data->markers[i].upperRight_x, data->markers[i].upperRight_y));
		markerCorners.push_back(cv::Point2f(data->markers[i].lowerRight_x, data->markers[i].lowerRight_y));
		markerCorners.push_back(cv::Point2f(data->markers[i].lowerLeft_x, data->markers[i].lowerLeft_y));
		corners.push_back(markerCorners);
	}
	cv::Mat* cvImage = reinterpret_cast<cv::Mat*>(image);
	cv::aruco::drawDetectedMarkers(*cvImage, corners, ids);
}

FFI_PLUGIN_EXPORT void ArucoMarkers_free(ArucoMarkers* pointer) {
	delete[] pointer->markers;
	delete pointer;
}

FFI_PLUGIN_EXPORT Mat* Mat_create() {
	return reinterpret_cast<Mat*>(new cv::Mat());
}

FFI_PLUGIN_EXPORT Mat* Mat_createFrom(int rows, int cols, uint8_t* data) {
	return reinterpret_cast<Mat*>(new cv::Mat(rows, cols, CV_8UC3, data));
}

FFI_PLUGIN_EXPORT void Mat_destroy(Mat* matrix) {
	reinterpret_cast<cv::Mat*>(matrix)->~Mat();
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
