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
 -(void)loadAD{
 if([[FirebaseController manager] canLoadADByAdRatio:ad_ratio_album])
 {
 //具体加载广告的代码
 _adview =[self.adManaer createAlbumAdViewWithViewController:self withFrame:CGRectMake(0, kSHeight - 50 - self.backgroundView.height, kSWidth, 50)];
 [self.view addSubview:_adview];
 }
 }
 */
//4.在viewdidload方法中调用loadAD;


#import <Foundation/Foundation.h>
#import "Firebase.h"
#define instabox_main_ad_ratio @"instabox_main_ad_ratio"
#define instabox_album_ad_ratio @"instabox_album_ad_ratio"
#define instabox_share_ad_ratio @"instabox_share_ad_ratio"
#define instabox_fb_ad_ratio @"instabox_fb_ad_ratio"


@protocol FirebaseControllerDeletage;
@interface FirebaseController : NSObject
@property(nonatomic,weak) id<FirebaseControllerDeletage> deletage;
@property(nonatomic,strong) NSMutableArray * array;
@property (nonatomic,strong) FIRRemoteConfig *remoteConfig;
+(FirebaseController*)manager;
-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio;
@end
@protocol FirebaseControllerDeletage<NSObject>
@optional
-(void)loadAD;
@end

