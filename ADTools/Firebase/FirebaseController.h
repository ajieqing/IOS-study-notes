//
//  FirebaseController.h
//  InstaSquare
//
//  Created by 阿杰 on 2017/12/27.
//  Copyright © 2017年 baiwamg. All rights reserved.
//

//使用方法：
/**
 使用前先倒入Firebase库
 Firebase.h
 FirebaseABTesting.framework
 FirebaseAnalytics.framework
 FirebaseCore.framework
 FirebaseCoreDiagnostics.framework
 FirebaseInstanceID.framework
 FirebaseNanoPB.framework
 FirebaseRemoteConfig.framework
 GoogleToolboxForMac.framework
 nanopb.framework
 Protobuf.framework
 
 cocopod导入
 platform :ios, '8.0'
 target '******' do
 pod 'Firebase/RemoteConfig'
 pod 'Firebase/Core'
 end
 
 添加两个plist文件
 GoogleService-Info.plist//从后台下载
 RemoteConfigDefaults.plist//可以从别的软件导入
 */
//0、在Appdeletage中调用[FirebaseControll manager];
//1、配置ad_ratio：    例子 ：#define ad_ratio_album @"album_ad_ration" //@“”的内容与后台保持一致
//2、将配置好的ad_ratio加入到_array中
//    在array的get方法中添加       例子：        [_array addObject:ad_ratio_album];//控制选图界面位置横幅广告
//3、根据需要实现loadAD代理方法。具体控制方法可参考一下例子
//
/*******************例子：*********
 //加载banner广告
 -(void)loadAD{
    if([[FirebaseController manager] canLoadADByAdRatio:ad_ratio_album])
     {
            //具体加载广告的代码
             _adview =[self.adManaer createAlbumAdViewWithViewController:self withFrame:CGRectMake(0, kSHeight - 50 - self.backgroundView.height, kSWidth, 50)];
             [self.view addSubview:_adview];
     }
 }
 //加载插屏广告
 -(void)loadAD{
 if([[FirebaseController manager] canLoadADByAdRatio:ad_ratio_album andTimeRaio:ad_ratio_album_times])
 {
 //具体加载广告的代码
 [self.adManaer createInterstitialAdWithDeletage:self withID:ad_id];
 }
 }
 //广告加载完成需要做一些操作
 -(void)interstitialDidReceiveAd:(GADInterstitial *)ad{
 if (ad.isReady) {
 if ([ad.adUnitID isEqualToString:ad_id])
 resAD = YES;
 }
 }
 //如果需要多次展示，请重复加载
 -(void)interstitialDidDismissScreen:(GADInterstitial *)ad{
 if ([ad.adUnitID isEqualToString:ad_id]) {
 [self loadResAD];
 }
 }
 //在需要展示的位置展示广告
 -(BOOL)showResAD{
 if (resAD) {
 if([[FirebaseController manager] canLoadADByAdRatio:nil  andTimeRaio:ad_ratio_album_times andDayTimeRatio:ad_ratio_album_days andDefaultDayTimeRatio:15])
 {
 //具体加载广告的代码
 [[ADManager manager] showInterstitialAdWithViewController:self withID:ad_id];
 resAD = NO;
 return YES;
 }
 }
 return NO;
 }
 */
//4.在viewdidload方法中调用loadAD;
//5、如果需要每隔一段时间自动加载广告，则实现FirebaseControllerDeletage
//6、如果需要加入去广告控制，则实现RemoveADDelegate


#import <Foundation/Foundation.h>
#import "Firebase.h"
@protocol RemoveADDelegate;

@protocol FirebaseControllerDeletage;
@interface FirebaseController : NSObject
@property(nonatomic,weak) id<FirebaseControllerDeletage> deletage;
@property (nonatomic,weak) id<RemoveADDelegate> removeAdDelegate;
@property(nonatomic,strong) NSMutableArray * array;
@property (nonatomic,strong) FIRRemoteConfig *remoteConfig;
+(FirebaseController*)manager;
//ad字段控制广告比率
-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio;
//time字段控制每天最多显示次数 0代表无，100代表无限制，1-99控制次数
-(NSInteger)numberOfOneDayCanLoadByTimeRatio:(NSString *) time_ratio;
//ad与time字段同时控制广告能否显示，每天每三次弹一次
-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio andTimeRaio:(NSString *) time_ratio;
//ad与time字段同时控制广告能否显示，每天每time次弹一次
-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio andTimeRaio:(NSString *) time_ratio andTime:(NSInteger) time;
//ad与time,dayTime_ratio字段同时控制广告能否显示
-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio andTimeRaio:(NSString *)time_ratio andDayTimeRatio:(NSString*)dayTime_ratio;

//ad与time,dayTime_ratio字段同时控制广告能否显示
-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio andTimeRaio:(NSString *)time_ratio andDayTimeRatio:(NSString *)dayTime_ratio andDefaultDayTimeRatio:(NSInteger)defaultDayTimeRatio;
@end
@protocol FirebaseControllerDeletage<NSObject>
@required
-(void)loadAD;
@optional
-(void)onFirebaseReceivedDate;
@end
@protocol RemoveADDelegate<NSObject>
@required
-(BOOL)canLoadAD;
@end
