//
//  HollowMaskView.h
//  DualTest
//
//  Created by qws on 2019/9/17.
//  Copyright © 2019 qws. All rights reserved.
/*
 这是一个中空的遮罩View，maskRect为中空区域，颜色为空，其他区域颜色为黑色，作为UIView.maskView使用，实现中空的遮罩涂层
 */

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HollowMaskView : UIView
@property (nonatomic, assign) CGRect maskRect;

- (instancetype)initWithFrame:(CGRect)frame maskRect:(CGRect)maskRect;
@end

NS_ASSUME_NONNULL_END
