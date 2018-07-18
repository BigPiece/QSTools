//
//  UIButton+enlargeEdge.m
//  ZXCheMo
//
//  Created by qws on 2017/3/1.
//  Copyright © 2017年 qws. All rights reserved.
//

#import "UIButton+enlargeEdge.h"
#import <objc/runtime.h>

@implementation UIButton (enlargeEdge)

static char enlargeEdgeInsetKey;

- (void)setEnlargedInsets:(UIEdgeInsets)enlargedInsets
{
    objc_setAssociatedObject(self, &enlargeEdgeInsetKey, [NSValue valueWithUIEdgeInsets:enlargedInsets], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIEdgeInsets)enlargedInsets
{
    return  [objc_getAssociatedObject(self, &enlargeEdgeInsetKey) UIEdgeInsetsValue];
}

- (void)enlargedInsetsWithTop:(CGFloat)top left:(CGFloat)left bottom:(CGFloat)bottom right:(CGFloat)right
{
    self.enlargedInsets = UIEdgeInsetsMake(top, left, bottom, right);
}


- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    if (self.alpha <= 0.01 || self.hidden == YES || self.userInteractionEnabled == NO) {
        return nil;
    }
    
    CGRect largedRect;
    if (!(self.enlargedInsets.top == 0 && self.enlargedInsets.left == 0 && self.enlargedInsets.bottom == 0 && self.enlargedInsets.right == 0)) {
        largedRect = CGRectMake(
                                    self.bounds.origin.x - self.enlargedInsets.left,
                                    self.bounds.origin.y - self.enlargedInsets.top,
                                    self.bounds.size.width + self.enlargedInsets.left + self.enlargedInsets.right,
                                    self.bounds.size.height + self.enlargedInsets.top + self.enlargedInsets.bottom
                                    );
    } else {
        largedRect = self.bounds;
    }
    
    return CGRectContainsPoint(largedRect, point) ? self : nil;
}

@end
