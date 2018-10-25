//
//  QSADTools.m
//  QSRuler
//
//  Created by qws on 2018/7/3.
//  Copyright © 2018年 qws. All rights reserved.
//

#import "QSADTools.h"

/*-----------
 *1.广告Key值就是默认的ID
 *2.如果从服务器取不到，就用这个默认的值
 *3.如果取到了就存在UserDefault里 用key取value值，value则为ID
 *
 ------------*/

// API
#define ADID_API_URL             @"http://67.209.179.95/adid.py"
#define ADID_API_Arg_Key         @"product"
#define ADID_API_Arg_Value       @"element" //不同的包改这个值

// 友盟key
#define UMAppKey                 @"5b863d1ef29d983119000113"

// 谷歌admob
#define AdmobAppKey              @"ca-app-pub-9904235060835176~2281625515"
#define AdmobBannerKey           @"ca-app-pub-9904235060835176/6502999604"
#define AdmobInterstitialKey     @"ca-app-pub-9904235060835176/6940299098"
#define AdmobJiLiShiPinKey       @"ca-app-pub-9904235060835176/5216153884"

// 腾讯广点通
#define GDTAppkey                @""
#define GDTPlacementKey          @""
#define GDTPlacementKaiPingKey   @""
#define GDTPlacementChaPingKey   @""

// vungle 广告配置
#define VungleAppKey             @"5974c4ebcb3ec0837a00067f"
#define VunglePlacementKey       @"DEFAULT45167"

#define kInterstitialDefaultCount (3)
#define kInterstitialMaxCount (3)

typedef void(^ADCallBackBlockWithParam)(id);

#define _SCREEN_HEIGHT (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])?([[UIScreen mainScreen] bounds].size.width):([[UIScreen mainScreen] bounds].size.height))
#define _SCREEN_WIDTH  (UIInterfaceOrientationIsLandscape([[UIApplication sharedApplication] statusBarOrientation])?([[UIScreen mainScreen] bounds].size.height):([[UIScreen mainScreen] bounds].size.width))


@interface QSADTools()
<
//Admob
GADInterstitialDelegate,
GADBannerViewDelegate,
GADAdSizeDelegate,
//GDT
GDTSplashAdDelegate,
//Vungle
VungleSDKDelegate
>

@property (nonatomic, strong) NSMutableArray<GADInterstitial *> *interstitialArr;
@property (nonatomic, strong) GADBannerView *bannerView;
//@property (nonatomic, strong) dispatch_queue_t reloadBannerSyncQueue;
@property (nonatomic, strong) NSBlockOperation *reloadBannerOperation;
@property (nonatomic, strong) NSOperationQueue *reloadBannerSyncQueue;
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
        // 1.默认的
        // 2.本地的
        // 3.网络的
        [self applyDefaultADID];
        [self getDefaultADID];
        [self getRemoteAdID];
    }
    return self;
}


#pragma mark -
#pragma mark - AD keys
- (void)applyDefaultADID {
    self.UMAppID = UMAppKey;
    self.AdmobAppID = AdmobAppKey;
    self.AdmobBannerID = AdmobBannerKey;
    self.AdmobInterstitialID = AdmobInterstitialKey;
    self.AdmobJiLiShiPinID = AdmobJiLiShiPinKey;
    self.GDTAppID = GDTAppkey;
    self.GDTPlacementID = GDTPlacementKey;
    self.GDTPlacementKaiPingID = GDTPlacementKaiPingKey;
    self.GDTPlacementChaPingID = GDTPlacementChaPingKey;
    self.VungleAppID = VungleAppKey;
    self.VunglePlacementID = VunglePlacementKey;
}

- (NSArray *)getADKeys {
    return @[UMAppKey,
             AdmobAppKey,
             AdmobBannerKey,
             AdmobInterstitialKey,
             AdmobJiLiShiPinKey,
             GDTAppkey,
             GDTPlacementKey,
             GDTPlacementKaiPingKey,
             GDTPlacementChaPingKey,
             VungleAppKey,
             VunglePlacementKey,
             ];
}

- (NSArray *)getADValues {
    return @[self.UMAppID,
             self.AdmobAppID,
             self.AdmobBannerID,
             self.AdmobInterstitialID,
             self.AdmobJiLiShiPinID,
             self.GDTAppID,
             self.GDTPlacementID,
             self.GDTPlacementKaiPingID,
             self.GDTPlacementChaPingID,
             self.VungleAppID,
             self.VunglePlacementID,
             ];
}

- (void)getDefaultADID {
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSArray *values = [self getADValues];
    NSArray *keys   = [self getADKeys];
    for (int i = 0 ; i < keys.count; i++) {
        NSString *k = keys[i];
        NSString *v = values[i];
        NSString *diskValue = [userDefault stringForKey:k];
        if (diskValue) {
            v = diskValue;
        }
    }
}

- (void)getRemoteAdID {
   
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setValue:ADID_API_Arg_Value forKey:ADID_API_Arg_Key];
    [self sendGET:ADID_API_URL params:params successBlock:^(NSDictionary *responseObject) {
        NSLog(@"adid:%@",responseObject);
        //从网络获取成功后存入本地
        BOOL success = [responseObject[@"result"] isEqualToString:@"True"];
        if (success) {
            NSDictionary *adidInfo = responseObject[@"ad_id"];
            NSDictionary *admob = adidInfo[@"admob"];
            NSString *adAppID = admob[@"adAppID"];
            NSString *adBannerID = admob[@"adBannerID"];
            NSString *adInterstitialID = admob[@"adInterstitialID"];
            NSString *adJiLiShiPinID = admob[@"adJiLiShiPinID"];

            NSDictionary *gdt = adidInfo[@"gdt"];
            NSString *gdtAppkey = gdt[@"gdtAppkey"];
            NSString *gdtPlacementId = gdt[@"gdtPlacementId"];
            NSString *gdtPlacementChaPingID = gdt[@"gdtPlacementChaPingID"];
            NSString *gdtPlacementKaiPingID = gdt[@"gdtPlacementKaiPingID"];
            
            NSString *umengID = adidInfo[@"umeng"];
            
            NSDictionary *vungle = adidInfo[@"vungle"];
            NSString *vungleAppID = vungle[@"vungleAppID"];
            NSString *vunglePlacementID = vungle[@"vunglePlacementID"];
            
            
            NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
            [userDefault setObject:umengID forKey:UMAppKey];
            [userDefault setObject:adAppID forKey:AdmobAppKey];
            [userDefault setObject:adBannerID forKey:AdmobBannerKey];
            [userDefault setObject:adInterstitialID forKey:AdmobInterstitialKey];
            [userDefault setObject:adJiLiShiPinID forKey:AdmobJiLiShiPinKey];
            [userDefault setObject:gdtAppkey forKey:GDTAppkey];
            [userDefault setObject:gdtPlacementId forKey:GDTPlacementKey];
            [userDefault setObject:gdtPlacementChaPingID forKey:GDTPlacementChaPingKey];
            [userDefault setObject:gdtPlacementKaiPingID forKey:gdtPlacementKaiPingID];
            [userDefault setObject:vungleAppID forKey:VungleAppKey];
            [userDefault setObject:vunglePlacementID forKey:VunglePlacementKey];
            
            [userDefault synchronize];
            //保存到userdefault后，再取出来使用
            [self getDefaultADID];
            
        } else {
            NSLog(@"response error = %@",responseObject[@"ad_id"]);
        }
        
    } failedBlock:^(NSError *error) {
        NSLog(@"request error = %@",error);
    }];
}

- (void)sendGET:(NSString *)url params:(NSDictionary *)params successBlock:(ADCallBackBlockWithParam)successBlock failedBlock:(ADCallBackBlockWithParam)failedBlock
{
    //配置
    NSURLSessionConfiguration *sessionConfig = [NSURLSessionConfiguration defaultSessionConfiguration];
    sessionConfig.timeoutIntervalForRequest = 15;
    AFHTTPResponseSerializer *httpResponseSerializer = [AFHTTPResponseSerializer serializer];
    httpResponseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    AFHTTPRequestSerializer *httpRequestSerializer = [AFHTTPRequestSerializer serializer];
    
    //Session
    AFURLSessionManager *sessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:sessionConfig];
    sessionManager.responseSerializer = httpResponseSerializer;
    
    //Request
    NSURLRequest *request = [httpRequestSerializer requestWithMethod:@"GET" URLString:url parameters:params error:nil];
    
    //DataTask
    NSURLSessionDataTask *dataTask = [sessionManager dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            if (failedBlock) {
                failedBlock(error);
            }
        } else {
            if (successBlock) {
                NSString *str = [[NSString alloc] initWithData:responseObject encoding:(NSUTF8StringEncoding)];
                NSData *data = [str dataUsingEncoding:(NSUTF8StringEncoding)];
                id dict = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingAllowFragments) error:nil];
                successBlock(dict);
            }
        }
    }];
    
    //Resume don·t forget！
    [dataTask resume];
}

#pragma mark -
#pragma mark - Admob
- (void)setupAdmob {
    [GADMobileAds configureWithApplicationID:self.AdmobAppID];
    for (int i = 0 ; i < kInterstitialDefaultCount; i++) {
        [self creatInterstital];
    }
    self.bannerView = [self creatGADBannerViewWith:nil];
}

#pragma mark - banner
- (void)addBannerAtBottomWithVC:(UIViewController *)vc {
    CGFloat naviHeight = vc.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    if (vc.navigationController.navigationBar.translucent == YES) { //半透明的，不减导航和状态栏高度
        naviHeight = 0;
    }
    
    CGFloat top =
    (vc.view.frame.size.height + vc.view.frame.origin.y)
    - naviHeight
    - self.bannerView.frame.size.height;
    
    if (@available(iOS 11.0, *)) {
        UIEdgeInsets safeInset = [UIApplication sharedApplication].keyWindow.safeAreaInsets;
        top -= safeInset.bottom;
    }
    
    [self addBannerWithVC:vc top:top];
}

- (void)addBannerWithVC:(UIViewController *)vc top:(CGFloat)top{
    if (![vc.view.subviews containsObject:self.bannerView]) {
        [vc.view addSubview:self.bannerView];
    }
    CGRect frame = self.bannerView.frame;
    frame.origin.y = top;
    self.bannerView.frame = frame;
    NSLog(@"bannertop = %f",top);
    
    if (self.bannerView.rootViewController != vc) {
        self.bannerView.rootViewController = vc;
        [self loadDefaultBannerView];
    }
}

- (GADBannerView *)creatGADBannerViewWith:(UIViewController *)viewController {
    if ([QSADTools sharedInstance].firstOpen) {
        return nil;
    }
    // 创建横幅广告view kGADAdSizeSmartBannerPortrait
    GADAdSize defaultSize = kGADAdSizeSmartBannerPortrait;
    CGSize size = CGSizeFromGADAdSize(defaultSize);
    
    CGPoint originPoint = CGPointMake((_SCREEN_WIDTH - size.width) * 0.5, _SCREEN_HEIGHT - size.height);
    GADBannerView *adBanner = [[GADBannerView alloc] initWithAdSize:defaultSize
                                                             origin:originPoint];
    adBanner.delegate = [QSADTools sharedInstance];
    adBanner.adSizeDelegate = [QSADTools sharedInstance];
    adBanner.backgroundColor = [UIColor clearColor];
    // 设置广告位标示
    adBanner.adUnitID = self.AdmobBannerID;

    // 自动加载广告
    adBanner.autoloadEnabled = YES;
    
//    adBanner.layer.borderColor = [UIColor greenColor].CGColor;
//    adBanner.layer.borderWidth = 2;
    
    // 设置广告视图的根控制器
    if (viewController) {
        adBanner.rootViewController = viewController;
        [self reloadADWith:adBanner];
    }
    return adBanner;
}

- (void)loadDefaultBannerView {
    [self reloadADWith:self.bannerView];
}

- (void)reloadADWith:(GADBannerView *)bannerView {
    if (!bannerView) {
        return;
    }
    GADRequest *request = [GADRequest request];
//    request.testDevices = @[@"4b2ba1691ff9f07e8b6479f8092cffd4",kGADSimulatorID];
    [bannerView loadRequest:request];
}

- (void)adView:(GADBannerView *)bannerView willChangeAdSizeTo:(GADAdSize)size {
    NSLog(@"willChangeAdSizeTo adSize = %@ frame = %@",NSStringFromGADAdSize(bannerView.adSize),NSStringFromCGRect(bannerView.frame));
}

- (void)adViewDidReceiveAd:(GADBannerView *)bannerView {
    NSLog(@"adViewDidReceiveAd adSize = %@ frame = %@",NSStringFromGADAdSize(bannerView.adSize),NSStringFromCGRect(bannerView.frame));
}

- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error {
    NSBlockOperation *reloadOperation = [NSBlockOperation blockOperationWithBlock:^{
        [self reloadADWith:bannerView];
    }];
    if (self.reloadBannerSyncQueue.operationCount == 0) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.reloadBannerSyncQueue addOperation:reloadOperation];
        });
    }
    NSLog(@"didFailToReceiveAdWithError: %@",error);
}

- (void)adViewWillPresentScreen:(GADBannerView *)bannerView {
    NSLog(@"adViewWillPresentScreen");
}

- (void)adViewWillDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"adViewWillDismissScreen");
}

- (void)adViewDidDismissScreen:(GADBannerView *)bannerView {
    NSLog(@"adViewDidDismissScreen");
}

- (void)adViewWillLeaveApplication:(GADBannerView *)bannerView {
    NSLog(@"adViewWillLeaveApplication");
}

#pragma mark - Interstitial
//显示插屏广告
- (void)showInterstitialWithVC:(UIViewController *)vc {
    if (self.firstOpen) {
        return;
    }
    GADInterstitial *inter = [self getReadyInterstitial];
    if (inter.isReady) {
        [inter presentFromRootViewController:vc];
        self.tapEleCount = self.tapSkinCount = 0;
    } else {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (inter.isReady) {
                [inter presentFromRootViewController:vc];
                self.tapEleCount = self.tapSkinCount = 0;
            }
        });
    }
}

//获取一个可用的ad
- (GADInterstitial *)getReadyInterstitial {
    __block GADInterstitial *inter;
    __block BOOL has = NO;
    [self.interstitialArr enumerateObjectsWithOptions:(NSEnumerationReverse) usingBlock:^(GADInterstitial * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (!obj.hasBeenUsed && obj.isReady) {
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
        [self removeOneInterStitialInArrWith:nil];
    }
    if (self.interstitialArr.count >= kInterstitialMaxCount) {
        return nil;
    }
    GADInterstitial *interstitial = [[GADInterstitial alloc] initWithAdUnitID:self.AdmobInterstitialID];
    interstitial.delegate = self;
    
    GADRequest *gadRequest = [GADRequest request];
//    gadRequest.testDevices = @[@"4b2ba1691ff9f07e8b6479f8092cffd4",kGADSimulatorID];
    [interstitial loadRequest:gadRequest];
    
    [self.interstitialArr insertObject:interstitial atIndex:0];
    
    
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
        [ad loadRequest:[GADRequest request]];
    }
}

//腾出一个位置添加ready的
- (void)removeOneInterStitialInArrWith:(GADInterstitial *)ad {
    [self.interstitialArr enumerateObjectsWithOptions:(NSEnumerationReverse) usingBlock:^(GADInterstitial * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == ad) {
            return;
        }
        if (obj.hasBeenUsed) {
            //删除1个用过的
            [self.interstitialArr removeObject:obj];
            *stop = YES;
        } else {
            if (!obj.isReady) { //删除1个ready的
                [self.interstitialArr removeObject:obj];
                *stop = YES;
            }
        }
    }];
}

- (void)interstitialWillPresentScreen:(GADInterstitial *)ad {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyKey_ADTool_Interstitial_WillPresent object:nil];
}

// 弹出失败
- (void)interstitialDidFailToPresentScreen:(GADInterstitial *)ad {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyKey_ADTool_Interstitial_DidFailPresent object:nil];
    [self completeWithAD:ad];
    NSLog(@"interstitialDidFailToPresentScreen");
}

- (void)interstitialWillDismissScreen:(GADInterstitial *)ad {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyKey_ADTool_Interstitial_WillDismiss object:nil];
}

// 广告在屏幕消失
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad {
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotifyKey_ADTool_Interstitial_DidDismiss object:nil];
    
    [self completeWithAD:ad];
}

- (NSMutableArray<GADInterstitial *> *)interstitialArr {
    if (!_interstitialArr) {
        _interstitialArr = [NSMutableArray array] ;
    }
    return _interstitialArr;
}

#pragma mark -
#pragma mark - UMeng
- (void)setupUMeng {
    [UMConfigure initWithAppkey:self.UMAppID channel:nil];
}

#pragma mark -
#pragma mark - GDT
- (void)setupGDT {
    //开屏广告初始化并展示代码
    GDTSplashAd *splash = [[GDTSplashAd alloc] initWithAppkey:self.GDTAppID placementId:self.GDTPlacementKaiPingID];
    splash.delegate = self; //设置代理
    //根据iPhone设备不同设置不同背景图
    splash.backgroundColor = [UIColor whiteColor];
    splash.fetchDelay = 2; //开发者可以设置开屏拉取时间，超时则放弃展示
    self.splash = splash;
    if (!self.firstOpen) {
        [self.splash loadAdAndShowInWindow:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)tryToShowSplash {
    // 进入后台超过10分钟 显示开屏广告
    if (([[NSDate date] timeIntervalSince1970] - [[NSUserDefaults standardUserDefaults] integerForKey:kEnterBackTime]) > 600) {
        // 显示广告
        [self.splash loadAdAndShowInWindow:[UIApplication sharedApplication].keyWindow];
    }
}

- (void)recordEnterBackgroundTime {
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:kShowSplashAD];
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSInteger enterBackTime = [[NSDate date] timeIntervalSince1970];
    [[NSUserDefaults standardUserDefaults] setInteger:enterBackTime forKey:kEnterBackTime];
}

/**
 *  开屏广告成功展示
 */
-(void)splashAdSuccessPresentScreen:(GDTSplashAd *)splashAd {
    NSLog(@"splashAdSuccessPresentScreen");
}

/**
 *  开屏广告展示失败
 */
-(void)splashAdFailToPresent:(GDTSplashAd *)splashAd withError:(NSError *)error {
    NSLog(@"splashAdFailToPresent error = %@",error);
}

/**
 *  应用进入后台时回调
 *  详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
 */
- (void)splashAdApplicationWillEnterBackground:(GDTSplashAd *)splashAd {
    NSLog(@"splashAdApplicationWillEnterBackground");
}

/**
 *  开屏广告点击回调
 */
- (void)splashAdClicked:(GDTSplashAd *)splashAd{
    
}

/**
 *  开屏广告将要关闭回调
 */
- (void)splashAdWillClosed:(GDTSplashAd *)splashAd{
    
}

/**
 *  开屏广告关闭回调
 */
- (void)splashAdClosed:(GDTSplashAd *)splashAd{
    
}

/**
 *  开屏广告点击以后即将弹出全屏广告页
 */
- (void)splashAdWillPresentFullScreenModal:(GDTSplashAd *)splashAd{
    
}

/**
 *  开屏广告点击以后弹出全屏广告页
 */
- (void)splashAdDidPresentFullScreenModal:(GDTSplashAd *)splashAd{
    
}

/**
 *  点击以后全屏广告页将要关闭
 */
- (void)splashAdWillDismissFullScreenModal:(GDTSplashAd *)splashAd {
    
}

/**
 *  点击以后全屏广告页已经关闭
 */
- (void)splashAdDidDismissFullScreenModal:(GDTSplashAd *)splashAd{
    
}

/**
 * 开屏广告剩余时间回调
 */
- (void)splashAdLifeTime:(NSUInteger)time{
    
}

#pragma mark -
#pragma mark - Vungle
- (void)setupVungle {
    VungleSDK *vungleSdk = [VungleSDK sharedSDK];
    //启动 vungle 发布商库
    NSError *error;
    [vungleSdk startWithAppId:VungleAppKey error:&error];
    if (error) {
        NSLog(@"error at start VungleSDK");
    }
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [vungleSdk loadPlacementWithID:VunglePlacementKey error:nil];
    });
}

- (void)tryToShowVungleWithVC:(UIViewController *)vc
                  failedBlock:(void(^)(void))failedBlock
                 successBlock:(void(^)(void))successBlock
{
    self.vungleSuccessBlock = successBlock;
    VungleSDK *vSdk = [VungleSDK sharedSDK];
    vSdk.delegate = self;
    
    if ([vSdk isAdCachedForPlacementID:self.VunglePlacementID]) {
        // 播放广告
        [vSdk playAd:vc options:nil placementID:self.VunglePlacementID error:nil];
        
    } else {
        if (failedBlock) {
            failedBlock();
        }
        NSError *errorOnLoadAd;
        // 加载失败后再次加载
        [vSdk loadPlacementWithID:self.VunglePlacementID error:&errorOnLoadAd];
        if (errorOnLoadAd) {
            NSLog(@"加载视频时出错%@",errorOnLoadAd);
        }
    }
}

- (void)vungleWillCloseAdWithViewInfo:(VungleViewInfo *)info placementID:(NSString *)placementID
{
    if ([info.completedView boolValue]) {
        if (self.vungleSuccessBlock) {
            self.vungleSuccessBlock();
        }
    }
}


#pragma mark -
#pragma mark - Getter
- (NSOperationQueue *)reloadBannerSyncQueue {
    if (!_reloadBannerSyncQueue) {
        _reloadBannerSyncQueue = [NSOperationQueue mainQueue];
        _reloadBannerSyncQueue.maxConcurrentOperationCount = 1;
    }
    return _reloadBannerSyncQueue;
}


@end
