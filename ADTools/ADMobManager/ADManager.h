//
//  ADManager.h
//  ADMOB工具类
//
//  Created by 阿杰 on 2017/12/26.
//  Copyright © 2017年 baiwamg. All rights reserved.
//

//使用方法：
/**
 使用前先倒入ADMob库
 GoogleMobileAdsSdkiOS-7.4
 */
//在AppDeletage中调用[ADManager manager];
//在下面的宏定义中配置ADmob的APPID以及广告的id


#import <Foundation/Foundation.h>
//ADmob的appid
#define ADMOBAPPID @"ca-app-pub-4227955678326630~3841622506"
//广告ID
#define main_banner @"ca-app-pub-4227955678326630/7592826865"
#define album_banner @"ca-app-pub-4227955678326630/3078866787"
#define share @"ca-app-pub-4227955678326630/2932183666"


//测试ID
//
#define test_banner_award @"ca-app-pub-3940256099942544/2934735716"//横幅广告
#define test_video_award @"ca-app-pub-3940256099942544/1712485313"//视频广告
#define test_interstitial_award @"ca-app-pub-3940256099942544/4411468910"//插屏广告
#define test_devices @"19aed38176933c43a3be1762e7926237"
//测试模式
#define TESTMODE NO
@import GoogleMobileAds;

@interface ADManager : NSObject
+(ADManager*)manager;

- (GADBannerView *)createBannerAdViewWithViewController:(UIViewController *)viewController withFrame:(CGRect)frame withID:(NSString *)adID;
- (void)createInterstitialAdWithDeletage:(id<GADInterstitialDelegate>)deletage withID:(NSString *)adID;
- (BOOL)showInterstitialAdWithViewController:(UIViewController *)viewController ;
- (void)createVideoAdWithViewController:(id<GADRewardBasedVideoAdDelegate>)viewController withID:(NSString *)adID;
- (BOOL)showVideoAdWithViewController:(UIViewController *)viewController ;
@end


