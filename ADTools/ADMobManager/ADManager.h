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
 GoogleMobileAdsSdk
 */
//在AppDeletage中调用[ADManager manager];
//在下面的宏定义中配置ADmob的APPID以及广告的id
//具体创建广告和控制方法情参考FirebaseControl.h的说明
//ADMob广告的插屏广告为一次性广告，如果某个广告位需要展示多次，单次展示完后需要在回调中重新加载
//TESTMODE 为测试开关，记得改为NO



#import <Foundation/Foundation.h>
//ADmob的appid
#define ADMOBAPPID @""
//广告ID



//测试ID
//
#define test_banner_award @"ca-app-pub-3940256099942544/2934735716"//横幅广告
#define test_video_award @"ca-app-pub-3940256099942544/1712485313"//视频广告
#define test_interstitial_award @"ca-app-pub-3940256099942544/4411468910"//插屏广告
#define test_devices @"19aed38176933c43a3be1762e7926237"
//测试模式
#define TESTMODE YES
@import GoogleMobileAds;

@interface ADManager : NSObject
+(ADManager*)manager;
//创建banner广告view，将其添加到你的view中
- (GADBannerView *)createBannerAdViewWithViewController:(UIViewController *)viewController withFrame:(CGRect)frame withID:(NSString *)adID;
//创建插屏单个广告，创建方法应提前执行，以达到良好的体验效果
- (void)createInterstitialAdWithDeletage:(id<GADInterstitialDelegate>)deletage withID:(NSString *)adID;
//展示最后创建的插屏广告，用于单个页面只有一个插屏广告时掉用，在需要展示的广告位展示
- (BOOL)showInterstitialAdWithViewController:(UIViewController *)viewController;
//同时创建多个插屏广告
- (void)createInterstitialAdWithDeletage:(id<GADInterstitialDelegate>)deletage withIDs:(NSArray *)adIDs;
//根据id展示具体的插屏广告，返回是否广告是否准备成功，
- (BOOL)showInterstitialAdWithViewController:(UIViewController *)viewController withID:(NSString *)adID;

//创建视频广告，视频广告只能同时存在一个
- (void)createVideoAdWithViewController:(id<GADRewardBasedVideoAdDelegate>)viewController withID:(NSString *)adID;
//展示视频广告
- (BOOL)showVideoAdWithViewController:(UIViewController *)viewController ;
@end


