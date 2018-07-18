//
//  UIButton+enlargeEdge.h
//  ZXCheMo
//
//  Created by qws on 2017/3/1.
//  Copyright © 2017年 qws. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (enlargeEdge)

@property (assign, nonatomic) UIEdgeInsets enlargedInsets;

- (void)enlargedInsetsWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right;

@end
