//
//  QSADTools.h
//  QSRuler
//
//  Created by qws on 2018/7/3.
//  Copyright © 2018年 qws. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class GADBannerView;

@interface QSADTools : NSObject
@property (nonatomic, assign) BOOL firstOpen;
+ (instancetype)sharedInstance;
+ (GADBannerView *)creatGADBannerViewWith:(UIViewController *)viewController;
+ (void)reloadADWith:(GADBannerView *)bannerView;
- (void)showInterstitialWithVC:(UIViewController *)vc;
@end
