//
//  QSADTools.m
//  QSRuler
//
//  Created by qws on 2018/7/3.
//  Copyright © 2018年 qws. All rights reserved.
//

#import "QSADTools.h"
#import "ValueDefinitions.h"

#define kInterstitialDefaultCount (2)
#define kInterstitialMaxCount (6)

@interface QSADTools()<GADInterstitialDelegate,GADBannerViewDelegate,GADAdSizeDelegate>
@property (nonatomic, strong) NSMutableArray<GADInterstitial *> *interstitialArr;

@end


@implementation QSADTools

+ (instancetype)sharedInstance {
    static id instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [GADMobileAds configureWithApplicationID:adAppID];
        for (int i = 0 ; i < kInterstitialDefaultCount; i++) {
            [self creatInterstital];
        }
    }
    return self;
}

#pragma mark -
#pragma mark - banner
+ (GADBannerView *)creatGADBannerViewWith:(UIViewController *)viewController {
    if ([QSADTools sharedInstance].firstOpen) {
        return nil;
    }
    // 创建横幅广告view kGADAdSizeSmartBannerPortrait
    GADAdSize defaultSize = kGADAdSizeSmartBannerPortrait;
    CGSize size = CGSizeFromGADAdSize(defaultSize);
    
    CGPoint originPoint = CGPointMake((kSCREEN_WIDTH - size.width) * 0.5, kSCREEN_HEIGHT - size.height);
    GADBannerView *adBanner = [[GADBannerView alloc] initWithAdSize:defaultSize
                                                             origin:originPoint];
    adBanner.delegate = [QSADTools sharedInstance];
    adBanner.adSizeDelegate = [QSADTools sharedInstance];
    adBanner.backgroundColor = [UIColor clearColor];
    // 设置广告位标示
    adBanner.adUnitID = adBannerID;
    // 设置广告视图的根控制器
    adBanner.rootViewController = viewController;
    // 自动加载广告
    adBanner.autoloadEnabled = YES;
    
    return adBanner;
}

+ (void)reloadADWith:(GADBannerView *)bannerView {
    GADRequest *request = [GADRequest request];
    request.testDevices = @[@"4b2ba1691ff9f07e8b6479f8092cffd4",kGADSimulatorID];
    [bannerView loadRequest:request];
}

- (void)adView:(GADBannerView *)bannerView willChangeAdSizeTo:(GADAdSize)size {
    kLog(@"willChangeAdSizeTo adSize = %@ frame = %@",NSStringFromGADAdSize(bannerView.adSize),NSStringFromCGRect(bannerView.frame));
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    kLog(@"adViewDidReceiveAd adSize = %@ frame = %@",NSStringFromGADAdSize(bannerView.adSize),NSStringFromCGRect(bannerView.frame));
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    
    kLog(@"didFailToReceiveAdWithError: %@",error);
}

- (void)adViewWillPresentScreen:(GADBannerView *)bannerView {
    kLog(@"adViewWillPresentScreen");
}

- (void)adViewWillDismissScreen:(GADBannerView *)bannerView {
    kLog(@"adViewWillDismissScreen");
}

- (void)adViewDidDismissScreen:(GADBannerView *)bannerView {
    kLog(@"adViewDidDismissScreen");
}

- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView {
    kLog(@"adViewWillLeaveApplication");
}


#pragma mark -
#pragma mark - Interstitial
//显示插屏广告
- (void)showInterstitialWithVC:(UIViewController *)vc {
    if (self.firstOpen) {
        return;
    }
    GADInterstitial *inter = [self getReadyInterstitial];
    if (inter) {
        [inter presentFromRootViewController:vc];
    }
}



//获取一个可用的ad
- (GADInterstitial *)getReadyInterstitial {
    __block GADInterstitial *inter;
    __block BOOL has = NO;
    [self.interstitialArr enumerateObjectsUsingBlock:^(GADInterstitial * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj.isReady && !obj.hasBeenUsed) {
            inter = obj;
            has = YES;
            *stop = YES;
        }
    }];
    
    if (has == NO) {
        inter = [self creatInterstital];
    }
    return inter;
}

// 创建广告 并请求
- (GADInterstitial *)creatInterstital {
    if (self.interstitialArr.count >= kInterstitialMaxCount) {
        return nil;
    }
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:adInterstitialID];
    interstitial.delegate = self;
    [self.interstitialArr addObject:interstitial];
    
    GADRequest *gadRequest = [GADRequest request];
    gadRequest.testDevices = @[@"4b2ba1691ff9f07e8b6479f8092cffd4",@"f59d2a2ef0adfd9cb29d0d34d0cd3d81",kGADSimulatorID];
    [interstitial loadRequest:gadRequest];
    
    return interstitial;
}

//完成后如果用过了就删除
- (void)completeWithAD:(GADInterstitial *)ad {
    if (ad.hasBeenUsed) {
        [self.interstitialArr removeObject:ad];
        [self creatInterstital];
    }
}
- (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
    if (!ad.isReady) {
        [self.interstitialArr removeObject:ad];
        [self creatInterstital];
    }
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {}

// 弹出失败
- (void)interstitialDidFailToPresentScreen:(GADInterstitial *)ad {
    [self completeWithAD:ad];
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {}

// 广告在屏幕消失
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    [self completeWithAD:ad];
}

#pragma mark -
#pragma mark - Getter
- (NSMutableArray<GADInterstitial *> *)interstitialArr {
    if (!_interstitialArr) {
        _interstitialArr = [NSMutableArray array] ;
    }
    return _interstitialArr;
}

@end
