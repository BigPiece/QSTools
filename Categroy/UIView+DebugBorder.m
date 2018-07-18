//
//  UIView+DebugBorder.m
//  Taker
//
//  Created by n on 16/7/18.
//  Copyright © 2016年 com.pepsin.fork.video_taker. All rights reserved.
//

#import "UIView+DebugBorder.h"

@implementation UIView (DebugBorder)

- (void)addDebugBorder{
    self.layer.borderColor = [self randomColor].CGColor;
    self.layer.borderWidth = 1;
}

- (void)addDebugBorderOnSelfAndSubviewsWithDepth:(NSInteger)depth{
    [self addDebugBorder];
    NSInteger remainingDepth = depth-1;

    if (remainingDepth > 0) {
        for (UIView *v in self.subviews) {
            [v addDebugBorderOnSelfAndSubviewsWithDepth:remainingDepth];
        }
    }
}

- (void)addDebugBackgroundColor{
    self.backgroundColor = [self randomColor];
}

- (void)addDebugBackgroundColorOnSelfAndSubviewsWithDepth:(NSInteger)depth{
    [self addDebugBackgroundColor];
    NSInteger remainingDepth = depth-1;

    if (remainingDepth > 0) {
        for (UIView *v in self.subviews) {
            [v addDebugBackgroundColorOnSelfAndSubviewsWithDepth:remainingDepth];
        }
    }
}

//获取一个随机颜色
-(UIColor *) randomColor
{
    CGFloat hue = ( arc4random() % 256 / 256.0 ); //0.0 to 1.0
    CGFloat saturation = ( arc4random() % 128 / 256.0 ) + 0.5; // 0.5 to 1.0,away from white
    CGFloat brightness = ( arc4random() % 128 / 256.0 ) + 0.5; //0.5 to 1.0,away from black
    return [UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1];
}
@end
