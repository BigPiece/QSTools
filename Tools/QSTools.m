//
//  QSTools.m
//  QSClearMines
//
//  Created by 郄文硕 on 2017/5/9.
//  Copyright © 2017年 qws. All rights reserved.
//

#import "QSTools.h"

@interface QSTools()<UIAlertViewDelegate>

@end

@implementation QSTools
singleton_implementation(QSTools);

- (NSArray *)numColorArr
{
    if (!_numColorArr) {
        _numColorArr = @[[UIColor colorWithRed:210.0 / 255 green:210.0 /255 blue:210.0 /255 alpha:1],
                         [UIColor grayColor],
                         [UIColor darkGrayColor],
                         [UIColor blackColor],
                         [UIColor brownColor],
                         [UIColor orangeColor],
                         [UIColor purpleColor],
                         [UIColor redColor]];
    }
    return _numColorArr;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.quickSignModel = NO;
        self.setAdDisCount  = 0;
        [self setupCommon];
    }
    return self;
}

- (void)setupCommon
{
    if (![QSUserDefault integerForKey:kMapWidth]) {
        self.mapWidth           = 9;
        self.mapHeight          = 9;
        self.mapMineNumber      = 10;
        self.gameLevel          = GameLevelEasy;
    }else {
        self.mapWidth       = [QSUserDefault integerForKey:kMapWidth];
        self.mapHeight      = [QSUserDefault integerForKey:kMapHeight];
        self.mapMineNumber  = [QSUserDefault integerForKey:kMapMineNumber];
        self.gameLevel      = [QSUserDefault integerForKey:kGameLevelStatus];
    }
    
    if (![QSUserDefault integerForKey:kGameNumStyle]) {
        self.numStyle = NumberStyleClassics;
    }else {
        self.numStyle = [QSUserDefault integerForKey:kGameNumStyle];
    }
    
    if (![QSUserDefault integerForKey:kBestValueEasyKey]) {
        self.bestEasy = INT_MAX;
        self.bestMid  = INT_MAX;
        self.bestHard = INT_MAX;
    }else {
        self.bestEasy = [QSUserDefault integerForKey:kBestValueEasyKey];
        self.bestMid  = [QSUserDefault integerForKey:kBestValueMiddleKey];
        self.bestHard = [QSUserDefault integerForKey:kBestValueHardKey];
    }
    
    if (![QSUserDefault integerForKey:kTapNumCount]) {
        self.tapNumCount = 0;
    }else {
        self.tapNumCount = [QSUserDefault integerForKey:kTapNumCount];
    }
}

// 地图宽度
- (void)setMapWidth:(NSUInteger)mapWidth
{
    _mapWidth = mapWidth;
    [QSUserDefault setInteger:mapWidth forKey:kMapWidth];
    [QSUserDefault synchronize];
}

// 地图高度
- (void)setMapHeight:(NSUInteger)mapHeight
{
    _mapHeight = mapHeight;
    [QSUserDefault setInteger:mapHeight forKey:kMapHeight];
    [QSUserDefault synchronize];
}

// 地雷数量
- (void)setMapMineNumber:(NSUInteger)mapMineNumber
{
    _mapMineNumber = mapMineNumber;
    [QSUserDefault setInteger:mapMineNumber forKey:kMapMineNumber];
    [QSUserDefault synchronize];
}

// 游戏难度状态
- (void)setGameLevel:(GameLevel)gameLevel
{
    _gameLevel = gameLevel;
    [QSUserDefault setInteger:gameLevel forKey:kGameLevelStatus];
    [QSUserDefault synchronize];
}

// 数字风格
- (void)setNumStyle:(NumberStyle)numStyle
{
    _numStyle = numStyle;
    [QSUserDefault setInteger:numStyle forKey:kGameNumStyle];
    [QSUserDefault synchronize];
}

// 简单纪录
- (void)setBestEasy:(NSUInteger)bestEasy
{
    _bestEasy = bestEasy;
    [QSUserDefault setInteger:bestEasy forKey:kBestValueEasyKey];
    [QSUserDefault synchronize];
}

// 中级纪录
- (void)setBestMid:(NSUInteger)bestMid
{
    _bestMid = bestMid;
    [QSUserDefault setInteger:bestMid forKey:kBestValueMiddleKey];
    [QSUserDefault synchronize];
}

// 高级纪录
- (void)setBestHard:(NSUInteger)bestHard
{
    _bestHard = bestHard;
    [QSUserDefault setInteger:bestHard forKey:kBestValueHardKey];
    [QSUserDefault synchronize];
}

- (void)setTapNumCount:(NSUInteger)tapNumCount
{
    _tapNumCount = tapNumCount;
    [QSUserDefault setInteger:tapNumCount forKey:kTapNumCount];
    [QSUserDefault synchronize];
}


+ (void)openRateURL
{
    NSURL *rateURL = [NSURL URLWithString:kRateUrlStr];
    [[UIApplication sharedApplication] openURL:rateURL];
}

#pragma mark - 检测appStore上的最新版本,与app当前版本作比较，如果不一样，那就说明需要提醒用户更新了。
//+ (void)checkUpAppVersion
//{
//    [[HelperNetSession shareInstance] getWithUrl:CheckVersionUrl Params:nil View:nil isShowIndicator:NO completionBlock:^(id responseObject) {
//        
//        NSArray *array      = responseObject[@"results"];
//        NSDictionary *dict  = [NSDictionary dictionaryWithDictionary:array[0]];
//        NSString *asvStr    = [dict[@"version"] stringByReplacingOccurrencesOfString:@"." withString:@""];
//        
//        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
//        NSString *appvStr = [[infoDictionary objectForKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""];
//        
//        BOOL needToUpDate = NO;
//
//        //计算版本号位数差
//        int placeMistake = (int)(asvStr.length - appvStr.length);
//        
//        //根据placeMistake的绝对值判断两个版本号是否位数相等
//        if (abs(placeMistake) == 0) {
//            //位数相等
//            needToUpDate = [asvStr integerValue] > [appvStr integerValue];
//        }else {
//            //位数不等 //multipleMistake差的倍数
//            NSInteger multipleMistake = pow(10, abs(placeMistake));
//            NSInteger server = [asvStr integerValue];
//            NSInteger local  = [appvStr integerValue];
//            if (server > local) {
//                needToUpDate = server > local * multipleMistake;
//            }else {
//                needToUpDate = server * multipleMistake > local;
//            }
//        }
//        
//        if (needToUpDate) {
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"版本有更新" message:[NSString stringWithFormat:@"检测到新版本(%@),是否更新?",dict[@"version"]] delegate:self cancelButtonTitle:@"取消"otherButtonTitles:@"更新",nil];
//            [alert show];
//        }
//
//    } failBlock:^(NSError *error) {
//        ;
//    }];
//}
//
//- (void)alertView:(UIAlertView*)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    //实现跳转到应用商店进行更新
//    if(buttonIndex==1) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:updateVersionUrl]];
//    }
//}


- (NSArray *)getSuperViewsWithView:(UIView *)view {
    if (!view || !view.superview) {
        return nil;
    }
    NSMutableArray *mutableArray = [NSMutableArray array];
    UIView *sv = view.superview;
    while (sv) {
        [mutableArray addObject:sv];
        sv = sv.superview;
    }
    return mutableArray;
}

- (UIView *)recentCommonViewWithView:(UIView *)view1 andView:(UIView *)view2 {
    if (!view1 || !view2) {
        return nil;
    }
    NSArray *superViews1 = [self getSuperViewsWithView:view1];
    NSArray *superViews2 = [self getSuperViewsWithView:view2];
    
    for (UIView *view in superViews1) {
        if ([superViews2 containsObject:view]) {
            return view;
        }
    }
    return nil;
}
@end
