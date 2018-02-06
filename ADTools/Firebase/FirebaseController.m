//
//  FirebaseController.m
//  InstaSquare
//
//  Created by 阿杰 on 2017/12/27.
//  Copyright © 2017年 baiwamg. All rights reserved.
//

#import "FirebaseController.h"

static FirebaseController* manager;

@implementation FirebaseController
+(FirebaseController*)manager{
    if (!manager) {
        [FIRApp configure];
        manager = [[FirebaseController alloc]init];
        [manager setRemoteConfig];
    }
    return manager;
}


- (void)setRemoteConfig
{
    if (self.remoteConfig) {
        return;
    }
    self.remoteConfig = [FIRRemoteConfig remoteConfig];
    
    FIRRemoteConfigSettings *remoteConfigSettings = [[FIRRemoteConfigSettings alloc] initWithDeveloperModeEnabled:NO];
    self.remoteConfig.configSettings = remoteConfigSettings;
    
    [self.remoteConfig setDefaultsFromPlistFileName:@"RemoteConfigDefaults"];
    
    [self fetchConfig];
}
-(NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];

        //在下面添加配置的ad_ratio
        [_array addObject:instabox_fb_ad_ratio];
        [_array addObject:instabox_main_ad_ratio];
        [_array addObject:instabox_album_ad_ratio];
        [_array addObject:instabox_share_ad_ratio];
    }
    return _array;
}
- (void)fetchConfig {
    
    long expirationDuration = 3600;
    
    if (self.remoteConfig.configSettings.isDeveloperModeEnabled) {
        expirationDuration = 0;
    }
    
    [self.remoteConfig fetchWithExpirationDuration:expirationDuration completionHandler:^(FIRRemoteConfigFetchStatus status, NSError *error) {
        if (error) {
            NSLog(@"%@",error);
        }
        NSLog(@"----------fetchWithExpirationDuration---------%ld---------------",(long)status);
        NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
        
        for (NSString *ration in self.array) {
            if (status == FIRRemoteConfigFetchStatusSuccess) {
                [self.remoteConfig activateFetched];
                NSString *adRatioStr = _remoteConfig[ration].stringValue;
                if ([self isPureInt:adRatioStr]) {
                    [def setObject:adRatioStr forKey:ration];
                }else{
                    [def setObject:@"100" forKey:ration];
                }
            } else {
                [def setObject:@"100" forKey:ration];
            }
        }
        [def synchronize];
        [self loadAD];
    }];
    
}

- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    NSString * adRatioStr = [def objectForKey:ad_ratio];//根据具体的需求获取控制标志。
    if (!adRatioStr) {
        adRatioStr = @"100";
    }
    int adRatio = [adRatioStr intValue];
    
    int ratio = arc4random() % 100 + 1;
    if(adRatio == 100)//100 显示广告
    {
        return YES;
    }
    else if(adRatio > 0)//不为 0 100时 按比例显示广告
    {
        if (ratio <= adRatio) {
            return YES;
        }
    }
    return NO;
}

-(void)loadAD{
    if (self.deletage && [self.deletage respondsToSelector:@selector(loadAD)]) {
        [self.deletage loadAD];
    }
}
@end

