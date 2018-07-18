//
//  DepthTool.h
//  Taker
//
//  Created by qws on 2018/5/16.
//  Copyright © 2018年 com.pepsin.fork.video_taker. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>
#import "CVPixelBufferTools.h"

@interface DepthTool : NSObject

+ (instancetype)sharedInstance;

void minMaxFromPixelBuffer(CVPixelBufferRef pixelBuffer, float* minValue, float* maxValue, MTLPixelFormat pixelFormat);

//Image to CVPixelBuffer
+ (CVPixelBufferRef)getPixelBufferFromUIImage:(UIImage *)image;
+ (CVPixelBufferRef)getPixelBufferFromCGImage:(CGImageRef)image;
+ (CVPixelBufferRef)getPixelBufferFromCIImage:(CIImage *)image pixelBuffer:(CVPixelBufferRef)inputPixelBuffer;

//CVPixelBuffer to iamge/data
+ (UIImage *)getUIImageFromSampleBuffer:(CMSampleBufferRef)sampleBuffer;
+ (UIImage *)getUIImageFromCVPixelBuffer:(CVPixelBufferRef)cvPixelBuffer;
+ (UIImage *)getUIImageFromCVPixelBuffer:(CVPixelBufferRef)cvPixelBuffer uiOrientation:(UIImageOrientation)uiOrientation;
+ (unsigned char *)getImageDataFromPixelBuffer:(CVPixelBufferRef)pixelBuffer;

//get CVPixelBuffer Properties
+ (NSDictionary *)createPixelBufferAttributes:(CVPixelBufferRef)pixelBuffer;
+ (NSArray *)getPixelBufferProperties:(CVPixelBufferRef)pixelBuffer;
+ (CMFormatDescriptionRef)getPixelBufferFormatDescription:(CVPixelBufferRef)pixelBuffer;

//modify CVPixelBuffer
+ (CVPixelBufferRef)resizePixelBufferWith:(CVPixelBufferRef)pixelBuffer newSize:(CGSize)newSize;
+ (CVPixelBufferRef)useDepthBlurWith:(CVPixelBufferRef)pixelBuffer depthData:(AVDepthData *)depthData  API_AVAILABLE(ios(11.0));

//Require iOS 11
+ (BOOL)hasDepthCamera;
+ (BOOL)hasDepthCameraFront;
+ (BOOL)hasDepthCameraBack;
+ (BOOL)hasDepthCameraWithPosition:(AVCaptureDevicePosition)position;
+ (NSArray *)caculateDepthWith:(AVDepthData *)depthData atNormPoint:(CGPoint)normPoint API_AVAILABLE(ios(11.0));
+ (NSData *)imageApplyDepthData:(NSData *)imageData depthData:(AVDepthData *)depthData representationDict:(NSDictionary *)representationDict API_AVAILABLE(ios(11.0));
+ (AVDepthData *)depthDataFromImageData:(NSData *)imageData  API_AVAILABLE(ios(11.0));
+ (NSDictionary *)getDepthDataDisparityDictWith:(AVDepthData *)depthData API_AVAILABLE(ios(11.0));


@end
