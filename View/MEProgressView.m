//
//  MEProgressView.m
//  Taker
//
//  Created by 初毅 on 2017/10/17.
//  Copyright © 2017年 com.pepsin.fork.video_taker. All rights reserved.
//

#import "MEProgressView.h"

#define MERGBColor(rgbValue, alphaValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:alphaValue]
#define MEColorGold               MERGBColor(0xae995a, 1)
#define ME_CLAMP(_x_, _low_, _high_)  (((_x_) > (_high_)) ? (_high_) : (((_x_) < (_low_)) ? (_low_) : (_x_)))

@interface MEProgressView()

// 因为 UIProgressView 的高度固定是2，所以要用两个layer
@property (nonatomic) UIProgressView *playProgressLayer;
@property (nonatomic) UIProgressView *playProgressLayer2;
@property (nonatomic) UIProgressView *loadedProgressLayer;
@property (nonatomic) UIProgressView *loadedProgressLayer2;
@property (nonatomic) CGFloat playProgress;
@property (nonatomic) CGFloat loadedProgress;
@end

@implementation MEProgressView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    self.layer.masksToBounds = YES;
    self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
    [self setupViews];
    [self setDefaultPercent];
    return self;
}

- (void)setupViews{
    self.loadedProgressLayer = [[UIProgressView alloc]init];
    self.loadedProgressLayer.progressTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    self.loadedProgressLayer.trackTintColor = [UIColor clearColor];
    [self addSubview:self.loadedProgressLayer];
    
    self.loadedProgressLayer2 = [[UIProgressView alloc]init];
    self.loadedProgressLayer2.progressTintColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    self.loadedProgressLayer2.trackTintColor = [UIColor clearColor];
    [self addSubview:self.loadedProgressLayer2];
    
    self.playProgressLayer = [[UIProgressView alloc]init];
    self.playProgressLayer.progressTintColor = MEColorGold;
    self.playProgressLayer.trackTintColor = [UIColor clearColor];
    [self addSubview:self.playProgressLayer];
    
    self.playProgressLayer2 = [[UIProgressView alloc]init];
    self.playProgressLayer2.progressTintColor = MEColorGold;
    self.playProgressLayer2.trackTintColor = [UIColor clearColor];
    [self addSubview:self.playProgressLayer2];
}

- (void)setDefaultPercent{
    [self setPlayProgress:0 animate:NO];
    [self setLoadedProgress:0 animate:NO];
}

- (void)setFrame:(CGRect)frame{
    [super setFrame:frame];
    [self resetSubViewsFrame];
}

- (void)resetSubViewsFrame {
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.2];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    self.playProgressLayer.frame = self.bounds;
    self.loadedProgressLayer.frame = self.bounds;
    
    self.playProgressLayer2.frame = CGRectMake(0, 2, self.bounds.size.width, self.bounds.size.height);
    self.loadedProgressLayer2.frame = CGRectMake(0, 2, self.bounds.size.width, self.bounds.size.height);
    
    [CATransaction commit];
}

- (void)setPlayProgress:(CGFloat)playProgress animate:(BOOL)animate{
    if (isnan(playProgress)) {
        playProgress = 0;
    }
    playProgress = ME_CLAMP(playProgress, 0, 1);
    
    if (fabs(playProgress - self.playProgress)>0.1) {
        animate = NO;
    }
    
    self.playProgress = playProgress;
    [self.playProgressLayer setProgress:playProgress animated:animate];
    [self.playProgressLayer2 setProgress:playProgress animated:animate];
    
}

- (void)setLoadedProgress:(CGFloat)loadedProgress animate:(BOOL)animate{
    if (isnan(loadedProgress)) {
        loadedProgress = 0;
    }
    loadedProgress = ME_CLAMP(loadedProgress, 0, 1);
    
    if (fabs(loadedProgress - self.loadedProgress)>0.1) {
        animate = NO;
    }
    
    self.loadedProgress = loadedProgress;
    [self.loadedProgressLayer setProgress:loadedProgress animated:animate];
    [self.loadedProgressLayer2 setProgress:loadedProgress animated:animate];
}

@end
