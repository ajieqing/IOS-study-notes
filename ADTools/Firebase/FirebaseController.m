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
    [manager fetchConfig];
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

}
-(NSMutableArray *)array{
    if (!_array) {
        _array = [NSMutableArray array];
        
        
        //在下面添加配置的ad_ratio

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
        if (self.deletage && [self.deletage respondsToSelector:@selector(onFirebaseReceivedDate)]) {
            [self.deletage onFirebaseReceivedDate];
        }
    }];
 
}

- (BOOL)isPureInt:(NSString *)string{
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio{
    BOOL canloadAD = YES;
    if (self.removeAdDelegate && [self.removeAdDelegate respondsToSelector:@selector(canLoadAD)]) {
        canloadAD = [self.removeAdDelegate canLoadAD];
    }
    if (canloadAD == NO) {
        return NO;
    }
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    NSString * adRatioStr = @"100";
    if (ad_ratio) {
        adRatioStr = [def objectForKey:ad_ratio];//根据具体的需求获取控制标志。
    }
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
-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio andTimeRaio:(NSString *) time_ratio{
    return [self canLoadADByAdRatio:ad_ratio andTimeRaio:time_ratio andTime:3];
}

-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio andTimeRaio:(NSString *)time_ratio andTime:(NSInteger)dayTime{
    if ([self canLoadADByAdRatio:ad_ratio]) {
        NSString * numberKey = [time_ratio stringByAppendingString:@"_number"];
        NSString * dateKey = [time_ratio stringByAppendingString:@"_date"];
        NSString * timeKey = [time_ratio stringByAppendingString:@"_time"];
        if (!time_ratio) {
            numberKey = [time_ratio stringByAppendingString:@"default_number"];
            dateKey = [time_ratio stringByAppendingString:@"default_date"];
            timeKey = [time_ratio stringByAppendingString:@"default_time"];
        }
        NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
        NSInteger number = [def integerForKey:numberKey];//当天出现的次数。
        NSInteger time = [def integerForKey:timeKey];//当天出现的次数。
        NSDate * date = [def objectForKey:dateKey];//上次出现的日期。
        if (!date) {
            number = 0;
            date = [NSDate date];
        }
        if([self numberOfDaysAtDate:date andDate:[NSDate date]] >0){
            number = 0;
            date = [NSDate date];
            time = 0;
        }
        if (number < [self numberOfOneDayCanLoadByTimeRatio:time_ratio]) {
            if (time % dayTime == dayTime -1) {
                number ++;
                [def setInteger:number forKey:numberKey];
                [def setObject:date forKey:dateKey];
                time = 0;
                [def setInteger:time forKey:timeKey];
                return YES;
            }
            time ++;
            [def setInteger:time forKey:timeKey];
        }
        NSLog(@"number = %ld   daytime = %ld   time = %ld  max = %ld",number,dayTime,time,[self numberOfOneDayCanLoadByTimeRatio:time_ratio]);
    }
    return NO;
}

-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio andTimeRaio:(NSString *)time_ratio andDayTimeRatio:(NSString *)dayTime_ratio{
    return [self canLoadADByAdRatio:ad_ratio andTimeRaio:time_ratio andDayTimeRatio:dayTime_ratio andDefaultDayTimeRatio:6];
}

-(BOOL)canLoadADByAdRatio:(NSString *)ad_ratio andTimeRaio:(NSString *)time_ratio andDayTimeRatio:(NSString *)dayTime_ratio andDefaultDayTimeRatio:(NSInteger)defaultDayTimeRatio{
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    NSString * adRatioStr = [NSString stringWithFormat:@"%ld",defaultDayTimeRatio];
    if (dayTime_ratio) {
        adRatioStr = [def objectForKey:dayTime_ratio];//根据具体的需求获取控制标志。
    }
    if (!adRatioStr) {
        adRatioStr = [NSString stringWithFormat:@"%ld",defaultDayTimeRatio];
    }
    int adRatio = [adRatioStr intValue];
    return [self canLoadADByAdRatio:ad_ratio andTimeRaio:time_ratio andTime:adRatio];
}

-(NSInteger)numberOfDaysAtDate:(NSDate *) firstData andDate:(NSDate*)secondData{
    NSCalendar *gregorian = [[NSCalendar alloc]
                             initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    [gregorian setFirstWeekday:2];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *fromDate;
    NSDate *toDate;
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&fromDate interval:NULL forDate:firstData];
    [gregorian rangeOfUnit:NSCalendarUnitDay startDate:&toDate interval:NULL forDate:secondData];
    NSDateComponents *dayComponents = [gregorian components:NSCalendarUnitDay fromDate:fromDate toDate:toDate options:0];
    return labs(dayComponents.day);
}

-(NSInteger)numberOfOneDayCanLoadByTimeRatio:(NSString *) time_ratio{
    NSInteger number = NSIntegerMax;
    if (self.removeAdDelegate && [self.removeAdDelegate respondsToSelector:@selector(canLoadAD)]) {
        number = [self.removeAdDelegate canLoadAD]?number:0;
    }
    NSUserDefaults * def = [NSUserDefaults standardUserDefaults];
    NSString * adRatioStr = @"3";
    if (time_ratio) {
        adRatioStr = [def objectForKey:time_ratio];//根据具体的需求获取控制标志。
    }
    if (!adRatioStr) {
        adRatioStr = @"3";
    }
    int adRatio = [adRatioStr intValue];
    if(adRatio == 100)//100 显示广告
    {
        number = NSIntegerMax;
    }else{
        number = adRatio;
    }
    return number;
}

-(void)loadAD{
    if (self.removeAdDelegate && [self.removeAdDelegate respondsToSelector:@selector(canLoadAD)]) {
        if (![self.removeAdDelegate canLoadAD]) {
            return;
        }
    }
    if (self.deletage && [self.deletage respondsToSelector:@selector(loadAD)]) {
        [self.deletage loadAD];
    }

}

-(void)dealloc{
    [[NSUserDefaults standardUserDefaults]synchronize];
}
@end
