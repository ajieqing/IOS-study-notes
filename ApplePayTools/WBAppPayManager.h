//
//  WBAppPayManager.h
//  StyleInstaMirror
//
//  Created by 阿杰 on 2017/12/13.
//  Copyright © 2017年 bw. All rights reserved.
//
//使用说明：
//0、配置APPKEY：APPKEY为后台生成的唯一共享产品ID
//1、修改COMMODITYKEY：COMMODITYKEY为https://itunesconnect.apple.com/WebObjects/iTunesConnect.woa/ra/ng/app上配置的内购项ID，如果有多个内购项，可根据情况添加新的COMMODITYKEY:如#define COMMODITYKEY_1 @"b376c10144a74541b0e87236117f391b"，同时在storeviewcontroll里添加对应的按钮,在ARRAY中添加对应的字段，如：#define ARRAY @[COMMODITYKEY,COMMODITYKEY_1]
//2、在appdeletage中调用verifyPurchaseWithPaymentTransaction方法
//3、在需要的类中实现onbuyfinish代理。注意，onbuyfinish的方法可能会多次调用，建议只处理简单的界面处理和逻辑代码。
//4、在创建storeviewcontroll对象的时候，实现refreshStatusBlock回调。refreshStatusBlock是在退出时候storeviewcontroll的回调方法，可以进行大规模的界面更新和逻辑处理。但是要注意使用弱引用。以免内存溢出。
//5、使用的时候调用WBStoreClockTool的isVIP判断是否购买。restore方法用来恢复购买



#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "OnBuyFinish.h"
#define COMMODITYKEY @"com.baiwang.InstaBoxX.noad"

@interface WBAppPayManager : NSObject<SKPaymentTransactionObserver,SKProductsRequestDelegate >
+ (WBAppPayManager *)manager;
@property (nonatomic, strong)  NSString *productID;
@property (nonatomic, weak) id <OnBuyFinish> delegate;

@property (nonatomic, strong) SKProductsRequest *request;
@property (nonatomic, strong) NSArray *products;
@property (nonatomic, strong) NSMutableArray *observers;
@property (nonatomic, assign) BOOL restoreFlag;

- (void)buyProductsWithId:(NSString *)productsId;

- (void) restore;

-(void)verifyPurchaseWithPaymentTransaction;
@end
