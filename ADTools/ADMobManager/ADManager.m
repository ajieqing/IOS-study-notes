//
//  ADManager.m
//  InstaSquare
//
//  Created by 阿杰 on 2017/12/26.
//  Copyright © 2017年 baiwamg. All rights reserved.
//

#import "ADManager.h"
@interface ADManager ()
@property(nonatomic, strong) GADInterstitial*interstitial;
@property(nonatomic, strong) NSMutableDictionary *interstitials;

@end
static ADManager * manager;
@implementation ADManager
+(ADManager*)manager{
    if (!manager) {
        manager = [[super alloc]init];
        [GADMobileAds configureWithApplicationID:ADMOBAPPID];
    }
    return manager;
}

- (GADBannerView *)createBannerAdViewWithViewController:(UIViewController<GADBannerViewDelegate> *)viewController withFrame:(CGRect)frame withID:(NSString *)adID{
    
    //admob
    GADBannerView *bannerView = [[GADBannerView alloc] initWithAdSize:kGADAdSizeSmartBannerPortrait];
    bannerView.frame = frame;
    
    
    if (TESTMODE) {
        bannerView.adUnitID = test_banner_award;
    }else{
        bannerView.adUnitID = adID;
    }
    bannerView.rootViewController = viewController;
    //    if ([WBLang isPad]) {
    //        bannerView.adSize =  kGADAdSizeLeaderboard;
    //    }
    bannerView.delegate = viewController;
    
    GADRequest *request = [GADRequest request];
    if (TESTMODE) {
        request.testDevices = @[ test_devices ];
    }
    [bannerView loadRequest:request];
    
    return bannerView;
    
}
- (void)createInterstitialAdWithDeletage:(id<GADInterstitialDelegate>)deletage withID:(NSString *)adID{
    if (TESTMODE) {
        self.interstitial = [[GADInterstitial alloc]
                             initWithAdUnitID:test_interstitial_award];
    }else{
        self.interstitial = [[GADInterstitial alloc]
                             initWithAdUnitID:adID];
    }
    self.interstitial.delegate = deletage;
    GADRequest *request = [GADRequest request];
    if (TESTMODE) {
        request.testDevices = @[ test_devices ];
    }
    [self.interstitial loadRequest:request];
    if (!self.interstitials) {
        self.interstitials = [NSMutableDictionary dictionary];
    }
    [self.interstitials setObject:self.interstitial forKey:adID];
}
- (BOOL)showInterstitialAdWithViewController:(UIViewController *)viewController {
    if (self.interstitial.isReady) {
        [self.interstitial presentFromRootViewController:viewController];
        return YES;
    } else {
        NSLog(@"Ad wasn't ready");
        return NO;
    }
}

-(void)createInterstitialAdWithDeletage:(id<GADInterstitialDelegate>)deletage withIDs:(NSArray *)adIDs{
    if (!self.interstitials) {
        self.interstitials = [NSMutableDictionary dictionary];
    }
    for (NSString * adID in adIDs) {
        GADInterstitial * interstitial;
        if (TESTMODE) {
            interstitial = [[GADInterstitial alloc]
                                 initWithAdUnitID:test_interstitial_award];
        }else{
            interstitial = [[GADInterstitial alloc]
                                 initWithAdUnitID:adID];
        }
        interstitial.delegate = deletage;
        GADRequest *request = [GADRequest request];
        if (TESTMODE) {
            request.testDevices = @[ test_devices ];
        }
        [interstitial loadRequest:request];
        [self.interstitials setObject:interstitial forKey:adID];
    }
}

-(BOOL)showInterstitialAdWithViewController:(UIViewController *)viewController withID:(NSString *)adID{
    GADInterstitial * interstitial = [self.interstitials objectForKey:adID];
    if (interstitial) {
        if (interstitial.isReady) {
            [interstitial presentFromRootViewController:viewController];
            return YES;
        } else {
            NSLog(@"Ad wasn't ready");
            return NO;
        }
    }
    return NO;
}

- (void)createVideoAdWithViewController:(id<GADRewardBasedVideoAdDelegate>)viewController  withID:(NSString *)adID{
    [GADRewardBasedVideoAd sharedInstance].delegate = viewController;
    if (TESTMODE) {
        GADRequest *request = [GADRequest request];
        request.testDevices = @[ test_devices ];
        [[GADRewardBasedVideoAd sharedInstance] loadRequest:request
                                               withAdUnitID:test_video_award];
    }else{
        [[GADRewardBasedVideoAd sharedInstance] loadRequest:[GADRequest request]
                                               withAdUnitID:adID];
    }
}
- (BOOL)showVideoAdWithViewController:(UIViewController *)viewController {
    if ([[GADRewardBasedVideoAd sharedInstance] isReady]) {
        [[GADRewardBasedVideoAd sharedInstance] presentFromRootViewController:viewController];
        return YES;
    }else {
        NSLog(@"Ad wasn't ready");
        return NO;
    }
}

- (void)dealloc{
    NSLog(@"========%@dealloc========",self.class);
}
@end

