//
//  MEProgressView.h
//  Taker
//
//  Created by 初毅 on 2017/10/17.
//  Copyright © 2017年 com.pepsin.fork.video_taker. All rights reserved.
//

#import <UIKit/UIKit.h>
#define kMEProgressViewHeight (3)

@interface MEProgressView : UIView
@property (nonatomic,readonly) CGFloat playProgress;
@property (nonatomic,readonly) CGFloat loadedProgress;

- (void)setDefaultPercent;
- (void)setPlayProgress:(CGFloat)playProgress animate:(BOOL)animate;
- (void)setLoadedProgress:(CGFloat)loadedProgress animate:(BOOL)animate;
@end
