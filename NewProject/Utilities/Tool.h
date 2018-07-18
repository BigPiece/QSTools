//
//  Tool.h
//  QSRuler
//
//  Created by qws on 2018/4/27.
//  Copyright © 2018年 qws. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface Tool : NSObject
+ (instancetype)sharedInstance;

+ (CGFloat)getPointsPerMM;
+ (CGFloat)getPointsWithMM:(CGFloat)mm;
+ (void)makeShadowWith:(UIView *)view;
+ (UIView *)addShadowViewWith:(UIView *)view;
@end
