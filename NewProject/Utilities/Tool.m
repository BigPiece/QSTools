//
//  Tool.m
//  QSRuler
//
//  Created by qws on 2018/4/27.
//  Copyright © 2018年 qws. All rights reserved.
//

#import "Tool.h"
#import "ValueDefinitions.h"


@implementation Tool
+ (instancetype)sharedInstance {
    static dispatch_once_t onceToken;
    static id instance;
    dispatch_once(&onceToken, ^{
        instance = [self new];
    });
    return instance;
}

+ (CGFloat)getPointsPerMM {
    CGFloat sc_w = [[UIScreen mainScreen] bounds].size.width;
    CGFloat sc_h = [[UIScreen mainScreen] bounds].size.height;
    CGFloat sc_s;
    CGFloat ff = [[UIScreen mainScreen] nativeBounds].size.height;
    if (ff == 1136) {
        sc_s = 4.0;
    }else if(ff == 1334.0){
        sc_s = 4.7;
    }else if (ff== 1920){
        sc_s = 5.5;
    }else if (ff== 2436){
        sc_s = 5.8;
    }else{
        sc_s = 3.5;
    }
    CGFloat pointsPerMM = sqrt(sc_w * sc_w + sc_h * sc_h)/(sc_s * 25.4);//mm

    return pointsPerMM;
}

+ (CGFloat)getPointsWithMM:(CGFloat)mm {
    return [Tool getPointsPerMM] * mm;
}

+ (void)makeShadowWith:(UIView *)view {
    view.layer.shadowColor = colorBlack444444.CGColor;
    view.layer.shadowOffset = CGSizeMake(0, 2);
    view.layer.shadowRadius = 3;
    view.layer.shadowOpacity = 0.7;
}

+ (UIView *)addShadowViewWith:(UIView *)view {
    UIView *shadowView = [[UIView alloc] initWithFrame:view.frame];
    shadowView.backgroundColor = colorWhite;
    shadowView.layer.shadowColor = colorBlack444444.CGColor;
    shadowView.layer.shadowOffset = CGSizeMake(0, 2);
    shadowView.layer.shadowRadius = 3;
    shadowView.layer.shadowOpacity = 0.7;
    return shadowView;
}


@end
