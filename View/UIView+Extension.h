//
//  UIView+Extension.h
//  MJRefreshExample
//
//  Created by MJ Lee on 14-5-28.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Extension)
// shortcuts for frame properties
@property (nonatomic, assign) CGPoint origin;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGSize rotateSize;

// shortcuts for the coords
@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat bottom;

// shortcuts for positions
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

// shortcuts for dimensions
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, readonly) CGFloat orientationWidth;
@property (nonatomic, readonly) CGFloat orientationHeight;
@property (nonatomic, assign) BOOL visible;

//@property (nonatomic,weak)UIViewController *viewController;
/**
 *  Loads and returns the 1st view for the specified nib
 *
 *  @param nibName
 *
 *  @return a UIView instance
 */
+ (instancetype)viewWithNibName:(NSString *)nibName;

// shortcuts for subviews
- (UIView *)descendantOrSelfWithClass:(Class)cls;
- (UIView *)ancestorOrSelfWithClass:(Class)cls;
- (void)removeAllSubviews;


/**
 *  Rounded corners using performant Bezier Path
 *
 *  @param inRadius radius of the corners
 */
- (void)addBezierPathRoundedCornersWithRadius:(CGFloat)inRadius;

- (void)setRoundedCorners:(UIRectCorner)corners radius:(CGFloat)radius;
- (void)setRoundedCornersWithRadius:(CGFloat)radius;


/**
 *  Animates AutoLayout changes (source: http://stackoverflow.com/questions/13296232/ios-how-does-one-animate-to-new-autolayout-constraint-height)
 *
 *  @param duration the duration of the animation
 */
- (void)animateConstraintsWithDuration:(NSTimeInterval)duration;

+ (UIView *)lineView;
+ (CGSize)maxSizeWithScale:(CGFloat)smallScale inSize:(CGSize)bigSize;
- (BOOL)isDisplayedInScreen;
CGRect NoNanRect(CGRect rect);
CGFloat NoNanFloat(CGFloat value);

//无限旋转当前视图
- (void)rotate:(NSTimeInterval)duration;
@end
