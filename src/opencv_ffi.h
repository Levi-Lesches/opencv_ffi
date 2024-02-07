#include <stdint.h>
#include <stdio.h>
#include <stdlib.h>

#if _WIN32
#define FFI_PLUGIN_EXPORT __declspec(dllexport)
#else
#define FFI_PLUGIN_EXPORT
#endif

struct VideoCapture;
typedef struct VideoCapture VideoCapture;

struct Mat;
typedef struct Mat Mat;

typedef struct {
    int id;
    float upperLeft_x;
    float upperLeft_y;
    float upperRight_x;
    float upperRight_y;
    float lowerRight_x;
    float lowerRight_y; 
    float lowerLeft_x;
    float lowerLeft_y;
} ArucoMarker;

typedef struct {
    ArucoMarker* markers;
    int count;
} ArucoMarkers;

#ifdef __cplusplus
extern "C" {
#endif

// VideoCapture code
FFI_PLUGIN_EXPORT VideoCapture* VideoCapture_getByIndex(int index);
FFI_PLUGIN_EXPORT VideoCapture* VideoCapture_getByName(char* name);
FFI_PLUGIN_EXPORT void VideoCapture_destroy(VideoCapture* capture);
FFI_PLUGIN_EXPORT void VideoCapture_release(VideoCapture* capture);
FFI_PLUGIN_EXPORT int VideoCapture_isOpened(VideoCapture* capture);
FFI_PLUGIN_EXPORT int VideoCapture_read(VideoCapture* capture, Mat* image);
FFI_PLUGIN_EXPORT void VideoCapture_setProperty(VideoCapture* capture, int propertyID, int value);
FFI_PLUGIN_EXPORT double VideoCapture_getProperty(VideoCapture* capture, int propertyID);

// Matrix code
FFI_PLUGIN_EXPORT Mat* Mat_create();
FFI_PLUGIN_EXPORT Mat* Mat_createFrom(int rows, int cols, uint8_t* data);
FFI_PLUGIN_EXPORT void Mat_destroy(Mat* matrix);

// ArUco code
FFI_PLUGIN_EXPORT ArucoMarkers* detectMarkers(int dictionaryEnum, Mat* image);
FFI_PLUGIN_EXPORT void drawDetectedMarkers(Mat* image, ArucoMarkers* data);
FFI_PLUGIN_EXPORT void ArucoMarkers_free(ArucoMarkers* pointer);

// Misc code
FFI_PLUGIN_EXPORT void imshow(Mat* image);
FFI_PLUGIN_EXPORT int encodeJpg(Mat* image, int quality, uint8_t** pointer);
FFI_PLUGIN_EXPORT void setLogLevel(int level);
FFI_PLUGIN_EXPORT void freeImage(uint8_t* pointer);
		
#ifdef __cplusplus
}
#endif
