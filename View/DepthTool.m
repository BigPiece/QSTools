//
//  DepthTool.m
//  Taker
//
//  Created by qws on 2018/5/16.
//  Copyright © 2018年 com.pepsin.fork.video_taker. All rights reserved.
//

#import "DepthTool.h"

@interface DepthTool()

@end


@implementation DepthTool
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

#pragma mark -
#pragma mark - DepthTool

+ (CVPixelBufferRef)useDepthBlurWith:(CVPixelBufferRef)pixelBuffer depthData:(AVDepthData *)depthData  API_AVAILABLE(ios(11.0))
{
    CIImage *inputImage = [CIImage imageWithCVImageBuffer:pixelBuffer];
    CIImage *depthImage = [CIImage imageWithCVImageBuffer:depthData.depthDataMap];
    
    CGRect normalizedRect = CGRectMake(0.5, 0.5, 1.0 / inputImage.extent.size.width, 1.0 / inputImage.extent.size.height);
    CIVector *normalizedFocusRect = [CIVector vectorWithCGRect:normalizedRect];
    NSNumber *aperture = @(5);
    
    CIFilter *depthBlurFilter = [CIFilter filterWithName:@"CIDepthBlurEffect"];
    [depthBlurFilter setValue:inputImage forKey:kCIInputImageKey];
    [depthBlurFilter setValue:depthImage forKey:kCIInputDisparityImageKey];
    [depthBlurFilter setValue:normalizedFocusRect forKey:@"inputFocusRect"];
    [depthBlurFilter setValue:aperture forKey:@"inputAperture"];
//    [depthBlurFilter setValue:@(0.5) forKey:@"inputScaleFactor"];

    CIImage *outputImage = depthBlurFilter.outputImage;
    
    CVPixelBufferRef outPixelBuffer = [DepthTool getPixelBufferFromCIImage:outputImage pixelBuffer:pixelBuffer];
    return outPixelBuffer;
}

/**
 读取imageData的深度Data
 
 @param imageData imageData
 @return AVDepthData
 */
+ (nullable AVDepthData *)depthDataFromImageData:(nonnull NSData *)imageData  API_AVAILABLE(ios(11.0)){
    AVDepthData *depthData = nil;
    
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
    if (imageSource) {
        NSDictionary *auxDataDictionary = (__bridge NSDictionary *)CGImageSourceCopyAuxiliaryDataInfoAtIndex(imageSource, 0, kCGImageAuxiliaryDataTypeDisparity);
        if (auxDataDictionary) {
            depthData = [AVDepthData depthDataFromDictionaryRepresentation:auxDataDictionary error:NULL];
            depthData = [depthData depthDataByConvertingToDepthDataType:kCVPixelFormatType_DisparityFloat32]; // Convert to 32-bit disparity for use on the CPU
        }
        CFRelease(imageSource);
    }
    
    return depthData;
}




/**
 给ImageData添加深度data （ImageI/O）
 
 @param imageData imageData
 @param depthData 深度data
 @param calibrationDict * kCGImageAuxiliaryDataInfoData - the depth data (CFDataRef),* kCGImageAuxiliaryDataInfoDataDescription - the depth data description (CFDictionary)
 * kCGImageAuxiliaryDataInfoMetadata - metadata (CGImageMetadataRef)
 @return NSData
 */
+ (NSData *)imageApplyDepthData:(NSData *)imageData depthData:(AVDepthData *)depthData representationDict:(NSDictionary *)representationDict API_AVAILABLE(ios(11.0)) {
    //http://stackoverflow.com/questions/5125323/problem-setting-exif-data-for-an-image/5294574#5294574
    
    CGImageSourceRef source;
    source = CGImageSourceCreateWithData((CFDataRef)imageData, NULL);
    
    CFStringRef UTI = CGImageSourceGetType(source);
    NSMutableData *dest_data = [NSMutableData data];
    CGImageDestinationRef destination = CGImageDestinationCreateWithData((CFMutableDataRef)dest_data,UTI,1,NULL);
    if(!destination) {
        NSLog(@"***Could not create image destination ***");
        return imageData;
    }
    
    if (@available(iOS 11.0, *)) {
        NSString *str = (__bridge NSString *)kCGImageAuxiliaryDataTypeDisparity;
        NSMutableDictionary *dict = [depthData dictionaryRepresentationForAuxiliaryDataType:&str].mutableCopy;
        
        /*
         * kCGImageAuxiliaryDataInfoData - the depth data (CFDataRef)
         * kCGImageAuxiliaryDataInfoDataDescription - the depth data description (CFDictionary)
         * kCGImageAuxiliaryDataInfoMetadata - metadata (CGImageMetadataRef)
         */
        
        if (!depthData.cameraCalibrationData) {
            dict[@"kCGImageAuxiliaryDataInfoMetadata"] = representationDict[@"kCGImageAuxiliaryDataInfoMetadata"];
        }
        
        CGImageDestinationAddImageFromSource(destination,source,0, NULL);
        CGImageDestinationAddAuxiliaryDataInfo(destination, kCGImageAuxiliaryDataTypeDisparity, (__bridge CFDictionaryRef)dict);
    }
    
    BOOL success = NO;
    success = CGImageDestinationFinalize(destination);
    if(!success) {
        NSLog(@"***Could not create data from image destination ***");
        return imageData;
    }
    CFRelease(destination);
    CFRelease(source);
    return dest_data;
}




/**
 获取DepthData的Disparity representation dictionary
 
 @param depthData Disparity
 @return NSDictionary (kCGImageAuxiliaryDataInfoData,kCGImageAuxiliaryDataInfoDataDescription,kCGImageAuxiliaryDataInfoMetadata)
 */
+ (NSDictionary *)getDepthDataDisparityDictWith:(AVDepthData *)depthData API_AVAILABLE(ios(11.0))
{
    NSString *str = (__bridge NSString *)kCGImageAuxiliaryDataTypeDisparity;
    NSDictionary *representationDict = [depthData dictionaryRepresentationForAuxiliaryDataType:&str];
    
    //    NSData *depthDataInfo = representationDict[(__bridge NSString *)kCGImageAuxiliaryDataInfoData];
    //    NSDictionary *depthDatadescription = representationDict[(__bridge NSString *)kCGImageAuxiliaryDataInfoDataDescription];
    //    CGImageMetadataRef depthDataMetadata = (__bridge CGImageMetadataRef)(representationDict[(__bridge NSString *)kCGImageAuxiliaryDataInfoMetadata]);
    
    return representationDict;
}




/**
 计算深度图某个点的深度（m）

 @param depthData AVDepthData
 @param normPoint 归一化的CGPoint
 @return 深度，单位米
 */
+ (NSArray *)caculateDepthWith:(AVDepthData *)depthData atNormPoint:(CGPoint)normPoint API_AVAILABLE(ios(11.0))
{
    depthData = [depthData depthDataByConvertingToDepthDataType:kCVPixelFormatType_DisparityFloat16];
    CVPixelBufferRef depthMap = depthData.depthDataMap;
    CVPixelBufferLockBaseAddress(depthMap, 0);
    size_t width = CVPixelBufferGetWidth(depthMap);
    size_t height = CVPixelBufferGetHeight(depthMap);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(depthMap);
    size_t bytesPerPixel = bytesPerRow / width;
    unsigned char* bitMapData = malloc(width * height * bytesPerPixel);
    CIContext *ciCtx = [CIContext context];
    [ciCtx render:[CIImage imageWithCVPixelBuffer:depthData.depthDataMap] toBitmap:bitMapData rowBytes:bytesPerRow bounds:(CGRectMake(0, 0, width, height)) format:kCIFormatRGBA8 colorSpace:nil];
    
    //计算距离分布
    unsigned int histogramBins[256] = {0};
    for (int x = 0; x < width*height; x++) {
        int k = bitMapData[x*bytesPerPixel];
        histogramBins[k]++;
    }
    
    int histogram[3]  = {0};
    for (int i = 1; i<256; i++) {//舍去inf值
        double dis = 1.0 / (i / 255.0);
        if (dis <= 1) {
            histogram[0]+=histogramBins[i];
        }else if (dis > 1 && dis <=2.5){
            histogram[1]+=histogramBins[i];
        }else{
            histogram[2]+=histogramBins[i];
        }
    }
//    printf("\n");
    for (int i = 0; i<3; i++) {
//        printf("%f-",histogram[i]/76800.0);
    }
//    printf("\n");
    
    
    
    CGPoint point = CGPointMake(width * normPoint.x, normPoint.y);
    size_t index = bytesPerPixel * (width * point.y + point.x);
    double depthR = 1.0 / (bitMapData[index + 0] / 255.0);
//    NSLog(@"DepthTool r = %f, 2 = %f",depthR,3);
    CVPixelBufferUnlockBaseAddress(depthMap, 0);
    free(bitMapData);
    NSArray *outputArray = @[@(histogram[0]),@(histogram[1]),@(histogram[2]),@(depthR)];

    return outputArray;
}




/**
 判断当前设备谁否支持深度摄像

 @return
 */
+ (BOOL)hasDepthCamera {
    return [self hasDepthCameraFront] || [self hasDepthCameraBack];
}

+ (BOOL)hasDepthCameraWithPosition:(AVCaptureDevicePosition)position {
    switch (position) {
        case AVCaptureDevicePositionUnspecified:
            return [self hasDepthCamera];
            break;
        case AVCaptureDevicePositionBack:
            return [self hasDepthCameraBack];
        case AVCaptureDevicePositionFront:
            return [self hasDepthCameraFront];
    }
}

+ (BOOL)hasDepthCameraFront {
    static dispatch_once_t onceFrontToken;
    static BOOL frontHas = NO;
    dispatch_once(&onceFrontToken, ^{
        if ([UIDevice currentDevice].systemVersion.floatValue >= 11.1) {
            if (@available(iOS 11.1, *)) {
                AVCaptureDeviceDiscoverySession *sessions = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInTrueDepthCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionFront];
                NSArray *devices = sessions.devices;
                for (AVCaptureDevice *device in devices.reverseObjectEnumerator){
                    if (device.deviceType == AVCaptureDeviceTypeBuiltInTrueDepthCamera) {
                        frontHas = YES;
                    }
                }
            } else {
                frontHas = NO;
            }
        }
    });
    return frontHas;
}

+ (BOOL)hasDepthCameraBack {
    static dispatch_once_t onceBackToken;
    static BOOL backHas = NO;
    dispatch_once(&onceBackToken, ^{
        if ([UIDevice currentDevice].systemVersion.floatValue >= 11.0) {
            AVCaptureDeviceDiscoverySession *sessions = [AVCaptureDeviceDiscoverySession discoverySessionWithDeviceTypes:@[AVCaptureDeviceTypeBuiltInDualCamera] mediaType:AVMediaTypeVideo position:AVCaptureDevicePositionBack];
            NSArray *devices = sessions.devices;
            for (AVCaptureDevice *device in devices.reverseObjectEnumerator){
                if (device.deviceType == AVCaptureDeviceTypeBuiltInDualCamera ) {
                    backHas = YES;
                }
            }
        }
    });
    return backHas;
}






/**
 计算PixelBuffer所有Pixel的R通道的最大最小值
 
 @param pixelBuffer pixelBuffer
 @param minValue 最小值输出指针
 @param maxValue 最大值输出指针
 @param pixelFormat MTLPixelFormatR16Float/MTLPixelFormatR32Float
 */
void minMaxFromPixelBuffer(CVPixelBufferRef pixelBuffer, float* minValue, float* maxValue, MTLPixelFormat pixelFormat)
{
    int width          = (int)CVPixelBufferGetWidth(pixelBuffer);
    int height         = (int)CVPixelBufferGetHeight(pixelBuffer);
    int bytesPerRow    = (int)CVPixelBufferGetBytesPerRow(pixelBuffer);
    
    CVPixelBufferLockBaseAddress(pixelBuffer, kCVPixelBufferLock_ReadOnly);
    unsigned char* pixelBufferPointer = CVPixelBufferGetBaseAddress(pixelBuffer);
    __fp16* bufferP_F16 = (__fp16 *) pixelBufferPointer;
    float*  bufferP_F32 = (float  *) pixelBufferPointer;
    
    bool isFloat16 = (pixelFormat == MTLPixelFormatR16Float);
    uint32_t increment = isFloat16 ?  bytesPerRow/sizeof(__fp16) : bytesPerRow/sizeof(float);
    
    float min = MAXFLOAT;
    float max = -MAXFLOAT;
    
    for (int j=0; j < height; j++)
    {
        for (int i=0; i < width; i++)
        {
            float val = ( isFloat16 ) ?  bufferP_F16[i] :  bufferP_F32[i] ;
            if (!isnan(val)) {
                if (val>max) max = val;
                if (val<min) min = val;
            }
        }
        if ( isFloat16 ) {
            bufferP_F16 +=increment;
        }  else {
            bufferP_F32 +=increment;
        }
    }
    
    CVPixelBufferUnlockBaseAddress(pixelBuffer, kCVPixelBufferLock_ReadOnly);
    
    *minValue = min;
    *maxValue = max;
}




#pragma mark -
#pragma mark - CVPixelBufferTools

/**
 创建一个无数据的CVPixelBuffer，大小格式和传入的pixelbuffer一样
 
 @param inputPixelBuffer 传入的
 @return 无数据的
 */
+ (CVPixelBufferRef)creatPixelBufferSameStyleWithOtherPixelBuffer:(CVPixelBufferRef)inputPixelBuffer
{
    return [CVPixelBufferTools creatPixelBufferSameStyleWithOtherPixelBuffer:inputPixelBuffer];
}




/**
 把CIImage转化为一个CVPixelBuffer 大小格式和传入的pixelBuffer一样
 
 @param image CIImage
 @param inputPixelBuffer 参考的pixelbuffer
 @return CVPixelBufferRef
 */
+ (CVPixelBufferRef)getPixelBufferFromCIImage:(CIImage *)image pixelBuffer:(CVPixelBufferRef)inputPixelBuffer
{
    return [CVPixelBufferTools getPixelBufferFromCIImage:image pixelBuffer:inputPixelBuffer];
}




/**
 把UIImage转化为CVPixelBuffer

 @param image UIImage
 @return CVPixelBufferRef
 */
+ (CVPixelBufferRef)getPixelBufferFromUIImage:(UIImage *)image
{
    return [self getPixelBufferFromCGImage:image.CGImage];
}



/**
 把CGImage转化为CVPixelBuffer

 @param image CGImageRef
 @return CVPixelBufferRef
 */
+ (CVPixelBufferRef)getPixelBufferFromCGImage:(CGImageRef)image
{
    return [CVPixelBufferTools getPixelBufferFromCGImage:image];
}





/**
 把CVPixelBuffer转化为一个UIImage
 
 @param cvPixelBuffer
 @return UIImage
 */
+ (UIImage *)getUIImageFromCVPixelBuffer:(CVPixelBufferRef)cvPixelBuffer
{
    return [self getUIImageFromCVPixelBuffer:cvPixelBuffer uiOrientation:UIImageOrientationUp];
}

/**
 把CVPixelBuffer转化为一个UIImage

 @param cvPixelBuffer
 @param uiOrientation UIImageOrientation
 @return UIImage
 */
+ (UIImage *)getUIImageFromCVPixelBuffer:(CVPixelBufferRef)cvPixelBuffer uiOrientation:(UIImageOrientation)uiOrientation
{
    return [CVPixelBufferTools getUIImageFromCVPixelBuffer:cvPixelBuffer uiOrientation:uiOrientation];
}

/**
 把CVPixelbuffer转化为CGImageRef

 @param cvPixelBuffer
 @return CGImageRef
 */
+ (CGImageRef)getCGImageFromCVPixelBuffer:(CVPixelBufferRef)cvPixelBuffer
{
    return [CVPixelBufferTools getCGImageFromCVPixelBuffer:cvPixelBuffer];
}


/**
 把pixelBuffer转化为data
 
 @param pixelBuffer 传入的
 @return unsigned char* 的data
 */
+ (unsigned char *)getImageDataFromPixelBuffer:(CVPixelBufferRef)pixelBuffer
{
    return [CVPixelBufferTools getImageDataFromPixelBuffer:pixelBuffer];
}



/**
 把CMSampleBufferRef转化为UIImage

 @param sampleBuffer
 @return UIImage
 */
+ (UIImage *)getUIImageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer
{
    return [CVPixelBufferTools getUIImageFromSampleBuffer:sampleBuffer];
}





/**
 创建CVPixelBuffer attributes

 @param pixelBuffer 根据pixelBuffer
 @return NSDictionary
 */
+ (NSDictionary *)createPixelBufferAttributes:(CVPixelBufferRef)pixelBuffer
{
    return [CVPixelBufferTools createPixelBufferAttributes:pixelBuffer];
}


/**
 获取Pixelbuffer的属性

 @param pixelBuffer
 @return NSArray
 */
+ (NSArray *)getPixelBufferProperties:(CVPixelBufferRef)pixelBuffer
{
    return [CVPixelBufferTools getPixelBufferProperties:pixelBuffer];
}



/**
 获取PixelBuffer的formatDescription
 
 @param pixelBuffer
 @return CMFormatDescriptionRef
 */
+ (CMFormatDescriptionRef)getPixelBufferFormatDescription:(CVPixelBufferRef)pixelBuffer {
    return [CVPixelBufferTools getPixelBufferFormatDescription:pixelBuffer];
}




/**
 重设CVPixelBuffer 的size
 
 @param pixelBuffer 传入的
 @param newSize 新的size
 @return 新的CVPixelBufferRef
 */
+ (CVPixelBufferRef)resizePixelBufferWith:(CVPixelBufferRef)pixelBuffer newSize:(CGSize)newSize
{
    return [CVPixelBufferTools resizePixelBufferWith:pixelBuffer newSize:newSize];
}






@end
