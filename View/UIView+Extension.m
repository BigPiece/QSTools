//
//  UIView+Extension.m
//  MJRefreshExample
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "UIView+Extension.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

@interface OnePxLineView : UIView
@end
@implementation OnePxLineView
@end

@implementation UIView (Extension)

#pragma mark - Nibs

+ (instancetype)viewWithNibName:(NSString *)nibName {
    UINib *nib = [UINib nibWithNibName:nibName bundle:nil];
    NSArray *objects = [nib instantiateWithOwner:nil options:nil];
    for (NSObject *object in objects) {
        if ([object isKindOfClass:[self class]]) {
            return (UIView *)object;
        }
    }
    return nil;
}


#pragma mark - Shortcuts for frame properties

- (CGPoint)origin {
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size {
    return self.frame.size;
}

- (CGSize)rotateSize{
    return CGSizeMake(self.frame.size.height, self.frame.size.width);
}

- (void)setSize:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}


#pragma mark - Shortcuts for the coords

- (CGFloat)left {
    return self.frame.origin.x;
}

- (void)setLeft:(CGFloat)x {
    if (isnan(x)) {
        x = 0;
    }
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top {
    return self.frame.origin.y;
}

- (void)setTop:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right {
    return self.frame.origin.x + self.frame.size.width;
}

- (void)setRight:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setBottom:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (BOOL)visible{
    return !self.hidden;
}

- (void)setVisible:(BOOL)visible{
    self.hidden = !visible;
}


#pragma mark - Shortcuts for positions

- (CGFloat)centerX {
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY {
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}


#pragma mark - Shortcuts for dimensions

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)orientationWidth {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
    ? self.height : self.width;
}

- (CGFloat)orientationHeight {
    return UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)
    ? self.width : self.height;
}

#pragma mark - Shortcuts for subviews

- (UIView *)descendantOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls])
        return self;
    
    for (UIView * child in self.subviews) {
        UIView *it = [child descendantOrSelfWithClass:cls];
        if (it != nil) {
            return it;
        }
    }
    
    return nil;
}

- (UIView*)ancestorOrSelfWithClass:(Class)cls {
    if ([self isKindOfClass:cls]) {
        return self;
        
    } else if (self.superview) {
        return [self.superview ancestorOrSelfWithClass:cls];
        
    } else {
        return nil;
    }
}

- (void)removeAllSubviews {
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}


#pragma mark - Rounded corners

- (void)addBezierPathRoundedCornersWithRadius:(CGFloat)inRadius {
    if (!self.layer.mask) {
        CAShapeLayer * shapeLayer = [CAShapeLayer layer];
        //Setting the background color of the masking shape layer to clear color is key
        //otherwise it would mask everything
        shapeLayer.backgroundColor = [UIColor clearColor].CGColor;
        shapeLayer.path = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:inRadius].CGPath;
        
        
        
        self.layer.masksToBounds = YES;
        self.layer.mask = shapeLayer;
        shapeLayer.frame = self.layer.bounds;
    }
}

- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius {
    CGRect rect = self.bounds;
    
    // Create the path
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect
                                                   byRoundingCorners:corners
                                                         cornerRadii:CGSizeMake(radius, radius)];
    
    // Create the shape layer and set its path
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    
    // Set the newly created shape layer as the mask for the view's layer
    self.layer.mask = maskLayer;
}

- (void)setRoundedCornersWithRadius:(CGFloat)radius {
    [self addBezierPathRoundedCornersWithRadius:radius];
}

#pragma mark - Autolayout

- (void)animateConstraintsWithDuration:(NSTimeInterval)duration {
    [UIView animateWithDuration:duration
                     animations:^{
                         [self layoutIfNeeded];
                     }];
}

#define kLineColor colorGrayCC
//+ (UIView *)lineView{
//    OnePxLineView *line = [OnePxLineView new];
//    line.height = k1pxHeight;
//    line.width = kScreenWidth;
//    line.backgroundColor = kLineColor;
//    return line;
//}

// 从一个bigSize中获得一个按一定比例撑满的smallSize
+ (CGSize)maxSizeWithScale:(CGFloat)smallScale inSize:(CGSize)bigSize{
    CGFloat bigScale = bigSize.width/bigSize.height;
    CGSize smallSize = CGSizeZero;
    if (bigScale < smallScale) { // 宽
        smallSize.width = ceil(bigSize.width);
        smallSize.height = ceil(bigSize.width / smallScale);
    }else{ // 长
        smallSize.height = ceil(bigSize.height);
        smallSize.width = ceil(bigSize.height * smallScale);
    }
    smallSize.width = NoNanFloat(smallSize.width);
    smallSize.height = NoNanFloat(smallSize.height);
    return smallSize;
}

// 判断View是否显示在屏幕上
- (BOOL)isDisplayedInScreen
{
    if (self == nil) {
        return FALSE;
    }
    
    CGRect screenRect = [UIScreen mainScreen].bounds;
    
    // 转换view对应window的Rect
    CGRect rect  = [self convertRect:self.frame toView:[[UIApplication sharedApplication].delegate window].rootViewController.view];
    if (CGRectIsEmpty(rect) || CGRectIsNull(rect)) {
        return FALSE;
    }
    
    // 若view 隐藏
    if (self.hidden) {
        return FALSE;
    }
    
    // 若没有superview
    if (self.superview == nil) {
        return FALSE;
    }
    
    // 若size为CGrectZero
    if (CGSizeEqualToSize(rect.size, CGSizeZero)) {
        return  FALSE;
    }
    
    // 获取 该view与window 交叉的 Rect
    CGRect intersectionRect = CGRectIntersection(rect, screenRect);
    if (CGRectIsEmpty(intersectionRect) || CGRectIsNull(intersectionRect)) {
        return FALSE;
    }
    
    return TRUE;
}

CGRect NoNanRect(CGRect rect){
    CGFloat x = rect.origin.x;
    CGFloat y = rect.origin.y;
    CGFloat width = rect.size.width;
    CGFloat height = rect.size.height;
    return CGRectMake(NoNanFloat(x), NoNanFloat(y), NoNanFloat(width), NoNanFloat(height));
}

CGFloat NoNanFloat(CGFloat value){
    if (isnan(value)) {
        return 0;
    }
    return value;
}
//-(void)setViewController:(UIViewController *)viewController
//{
//    [self willChangeValueForKey:@"viewController"];
//    objc_setAssociatedObject(self, &UIViewSuperViewController,
//                             viewController,
//                             OBJC_ASSOCIATION_RETAIN);
//    [self didChangeValueForKey:@"viewController"];
//}
//
//-(UIViewController *)viewController
//{
//    return objc_getAssociatedObject(self, &UIViewSuperViewController);
//}

- (void)rotate:(NSTimeInterval)duration
{
    CABasicAnimation *rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat:M_PI * 2.0];
    rotationAnimation.duration = duration;
    rotationAnimation.repeatCount = 2147483647;
    rotationAnimation.removedOnCompletion = NO;
    rotationAnimation.fillMode = kCAFillModeForwards;
    
    [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    
    [self.layer addAnimation:rotationAnimation forKey:@"Rotation"];
  
}
@end
