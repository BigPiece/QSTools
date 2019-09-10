//
//  QSTools.h
//  QSClearMines
//
//  Created by 郄文硕 on 2017/5/9.
//  Copyright © 2017年 qws. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ValueDefinitions.h"

typedef NS_ENUM(NSUInteger, GameLevel) {
    GameLevelEasy,
    GameLevelMiddle,
    GameLevelHard,
    GameLevelDIY
};

typedef NS_ENUM(NSUInteger, NumberStyle) {
    NumberStyleDefault,
    NumberStyleClassics
};

@interface QSTools : NSObject
singleton_interface(QSTools);

@property (assign, nonatomic) GameLevel             gameLevel;
@property (assign, nonatomic) NumberStyle           numStyle;
@property (assign, nonatomic) BOOL                  quickSignModel;
@property (assign, nonatomic) NSUInteger            mapWidth;
@property (assign, nonatomic) NSUInteger            mapHeight;
@property (assign, nonatomic) NSUInteger            mapMineNumber;
@property (assign, nonatomic) NSUInteger            settingTapCount;
@property (assign, nonatomic) NSUInteger            setAdDisCount;
@property (assign, nonatomic) NSUInteger            levelTapCount;
@property (assign, nonatomic) NSUInteger            tapNumCount;


// 默认数字颜色
@property (strong, nonatomic) NSArray               *numColorArr;

// 最佳纪录
@property (assign, nonatomic) NSUInteger            bestEasy;
@property (assign, nonatomic) NSUInteger            bestMid;
@property (assign, nonatomic) NSUInteger            bestHard;

//+ (void)checkUpAppVersion;
+ (void)openRateURL;
@end
