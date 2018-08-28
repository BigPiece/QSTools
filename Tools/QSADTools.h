//
//  QSADTools.h
//  QSRuler
//
//  Created by qws on 2018/7/3.
//  Copyright © 2018年 qws. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
#import <UMCommon/UMCommon.h>
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "GDTSplashAd.h"
#import <VungleSDK/VungleSDK.h>

@interface QSADTools : NSObject
@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, assign) BOOL firstOpen;

+ (instancetype)sharedInstance;

#pragma mark -
#pragma mark - Admob
#define kNotifyKey_ADTool_Interstitial_WillPresent @"NoitfyKey_ADTool_Interstitial_WillPresent"
#define kNotifyKey_ADTool_Interstitial_DidFailPresent @"NoitfyKey_ADTool_Interstitial_DidFailPresent"
#define kNotifyKey_ADTool_Interstitial_WillDismiss @"NoitfyKey_ADTool_Interstitial_WillDismiss"
#define kNotifyKey_ADTool_Interstitial_DidDismiss @"NoitfyKey_ADTool_Interstitial_DidDismiss"
@property (nonatomic, strong) NSString *AdmobAppID;
@property (nonatomic, strong) NSString *AdmobBannerID;
@property (nonatomic, strong) NSString *AdmobInterstitialID;
@property (nonatomic, strong) NSString *AdmobJiLiShiPinID;
- (void)setupAdmob;
- (GADBannerView *)creatGADBannerViewWith:(UIViewController *)viewController;
- (void)reloadADWith:(GADBannerView *)bannerView;
- (void)showInterstitialWithVC:(UIViewController *)vc;

#pragma mark -
#pragma mark - UMeng
@property (nonatomic, strong) NSString *UMAppID;
- (void)setupUMeng;

#pragma mark -
#pragma mark - GDT
#define kShowSplashAD               @"showSplashAD"
#define kEnterBackTime              @"kEnterBackTime"
#define kEnterForeTime              @"kEnterForeTime"
@property (nonatomic, strong) NSString *GDTAppID;
@property (nonatomic, strong) NSString *GDTPlacementID;
@property (nonatomic, strong) NSString *GDTPlacementChaPingID;
@property (nonatomic, strong) NSString *GDTPlacementKaiPingID;
@property (strong, nonatomic) GDTSplashAd *splash;
- (void)setupGDT;
- (void)tryToShowSplash;
- (void)recordEnterBackgroundTime;

#pragma mark -
#pragma mark - Vungle
@property (nonatomic, strong) NSString *VungleAppID;
@property (nonatomic, strong) NSString *VunglePlacementID;
@property (nonatomic, copy) void(^vungleSuccessBlock)(void);
- (void)setupVungle;
- (void)tryToShowVungleWithVC:(UIViewController *)vc
                  failedBlock:(void(^)(void))failedBlock
                  successBlock:(void(^)(void))successBlock;

@end









