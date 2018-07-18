//
//  UIView+DebugBorder.h
//  Taker
//
//  Created by n on 16/7/18.
//  Copyright © 2016年 com.pepsin.fork.video_taker. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (DebugBorder)

///给当前view加上debugBorder
- (void)addDebugBorder;
/// 给自己和所有subview加上debugBorder
- (void)addDebugBorderOnSelfAndSubviewsWithDepth:(NSInteger)depth;


///给当前view加上随机背景
- (void)addDebugBackgroundColor;
/// 给自己和所有subview加上debugBorder
- (void)addDebugBackgroundColorOnSelfAndSubviewsWithDepth:(NSInteger)depth;



@end
