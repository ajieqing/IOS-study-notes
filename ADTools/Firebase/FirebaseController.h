
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
//0、在Appdeletage中调用[FirebaseControll manager] 如果需要，可以实现removeADDelegate;
//1、配置ad_ratio：    例子 ：#define ad_ratio_album @"album_ad_ration" //@“”的内容与后台保持一致
//2、将配置好的ad_ratio加入到_array中
//    在array的get方法中添加       例子：        [_array addObject:ad_ratio_album];//控制选图界面位置横幅广告
//3、自定义loadAD加载广告方法。具体控制方法可参考一下例子
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
 //需要实现两个基本回调
 - (void)interstitialDidReceiveAd:(GADInterstitial *)ad {
 NSLog(@"interstitialDidReceiveAd");
 interstitial = ad;
 }
 
 -(void)interstitialDidDismissScreen:(GADInterstitial *)ad{
 if (ad == interstitial) {
 interstitial = nil;
 }
 }
 //在viewDidLoaded中调用
 -(void)loadInterstitialAD{
 if ([[FirebaseController manager]canLoadADByAdRatio:Instasquare_share_Interstitial_ad_ratio andTimeRaio:nil andDayTimeRatio:nil andDefaultDayTimeRatio:3]) {
 [self.adManaer createInterstitialAdWithDeletage:self withID:share_award];
 }
 }
 //在具体需要展示的位置调用，返回值是广告是否展示
 - (BOOL)showInterstitialAD {
 if (interstitial) {
 return [self.adManaer showInterstitialAdWithViewController:self withAD:interstitial];
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
//ad_ratio字段控制广告比率
-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio;
//ad_ratio字段控制广告比率 defaultAdRatio为ad_ratio的默认值
-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio andDefaultAdRatio:(NSInteger)defaultAdRatio;
-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio andDefaultAdRatio:(NSInteger)defaultAdRatio isAD:(BOOL)isAD;

-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio andDefaultAdRatio:(NSInteger)defaultAdRatio andTimeRaio:(NSString *)time_ratio;


-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio andDefaultAdRatio:(NSInteger)defaultAdRatio andTimeRaio:(NSString *)time_ratio andDefaultTimeRatio:(NSInteger)defaultTimeRatio;

-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio andDefaultAdRatio:(NSInteger)defaultAdRatio andTimeRaio:(NSString *)time_ratio andDefaultTimeRatio:(NSInteger)defaultTimeRatio andDayTimeRatio:(NSString *)dayTime_ratio;

//ad_ratio与time_ratio,dayTime_ratio字段同时控制广告能否显示  defaultTimeRatio 为time_ratio的默认值
//所有的控制字段皆可为空。空代表不做控制，用默认值控制
-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio andDefaultAdRatio:(NSInteger)defaultAdRatio andTimeRaio:(NSString *)time_ratio andDefaultTimeRatio:(NSInteger)defaultTimeRatio andDayTimeRatio:(NSString *)dayTime_ratio andDefaultDayTimeRatio:(NSInteger)defaultDayTimeRatio;
-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio andDefaultAdRatio:(NSInteger)defaultAdRatio andTimeRaio:(NSString *)time_ratio andDefaultTimeRatio:(NSInteger)defaultTimeRatio andDayTimeRatio:(NSString *)dayTime_ratio andDefaultDayTimeRatio:(NSInteger)defaultDayTimeRatio isAD:(BOOL)isAD;


//time_ratio字段控制每天最多显示次数 0代表无，100代表无限制，1-99控制次数
//ad_ratio与time_ratio字段同时控制广告能否显示，每天每三次弹一次
-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio andTimeRaio:(NSString *) time_ratio;
//ad_ratio与time_ratio字段同时控制广告能否显示，每天每time次弹一次
//ad_ratio与time_ratio,dayTime_ratio字段同时控制广告能否显示 dayTime_ratio控制每天每几次弹一次 0代表无，100代表无限制，1-99控制次数 默认6次
-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio andTimeRaio:(NSString *) time_ratio andDayTimeRatio:(NSString*)dayTime_ratio;

-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio andTimeRaio:(NSString *)time_ratio andDefaultTimeRatio:(NSInteger)defaultTimeRatio andDayTimeRatio:(NSString *)dayTime_ratio;

//ad_ratio与time_ratio,dayTime_ratio字段同时控制广告能否显示 defaultDayTimeRatio 为dayTime_ratio的默认值
-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio andTimeRaio:(NSString *)time_ratio andDayTimeRatio:(NSString *)dayTime_ratio andDefaultDayTimeRatio:(NSInteger)defaultDayTimeRatio;

@end
@protocol FirebaseControllerDeletage<NSObject>
@optional
//firebase数据接收回调,每次调用manager方法都会调用，可按需实现
-(void)onFirebaseReceivedDate;
@end
@protocol RemoveADDelegate<NSObject>
@required
//能否加载广告回调
-(BOOL)canLoadAD;
@end
