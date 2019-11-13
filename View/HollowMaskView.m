//
//  HollowMaskView.m
//  DualTest
//
//  Created by qws on 2019/9/17.
//  Copyright © 2019 qws. All rights reserved.
//

#import "HollowMaskView.h"

@interface HollowMaskView()
@property (nonatomic, strong) CAShapeLayer *hollowLayer;
@end

@implementation HollowMaskView
- (instancetype)initWithFrame:(CGRect)frame maskRect:(CGRect)maskRect
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.maskRect = maskRect;
        self.hollowLayer = [CAShapeLayer layer];
        [self setPath];
        [self.layer addSublayer:self.hollowLayer];
    }
    return self;
}

- (void)setMaskRect:(CGRect)maskRect {
    _maskRect = maskRect;
    [self setPath];
}

- (void)setPath {
    CGMutablePathRef mPath = CGPathCreateMutable();
    CGPathAddPath(mPath, NULL, CGPathCreateWithRect(self.bounds, NULL));
    CGPathAddPath(mPath, NULL, CGPathCreateWithRect(self.maskRect, NULL));
    self.hollowLayer.path = mPath;
    self.hollowLayer.fillRule = kCAFillRuleEvenOdd;
    self.hollowLayer.fillColor = [UIColor blackColor].CGColor;
}

@end
