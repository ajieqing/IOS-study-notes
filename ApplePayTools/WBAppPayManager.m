//
//  WBAppPayManager.m
//  StyleInstaMirror
//
//  Created by 阿杰 on 2017/12/13.
//  Copyright © 2017年 bw. All rights reserved.
//

#import "WBAppPayManager.h"
static WBAppPayManager * manager;
static BOOL ISBUY;

@implementation WBAppPayManager

+(WBAppPayManager*)manager{
    if (!manager) {
        manager = [[WBAppPayManager alloc]init];
        manager.restoreFlag = NO;
//        [[SKPaymentQueue defaultQueue] addTransactionObserver:manager];
    }
    return manager;
}
-(void)buyProductsWithId:(NSString *)productsId{
    ISBUY = YES;
    self.productID = productsId;
    if (self.delegate&&[self.delegate respondsToSelector: @selector(buyStart)]) {
        [self.delegate buyStart];
    }
    [[SKPaymentQueue defaultQueue] addTransactionObserver:manager];

    if ([SKPaymentQueue canMakePayments]) {

        NSLog(@"允许程序内付费购买");
        SKProductsRequest *productsRequest = [[SKProductsRequest alloc]
                                              initWithProductIdentifiers:[NSSet setWithArray:@[_productID]]];
        // Keep a strong reference to the request.
        self.request = productsRequest;
        productsRequest.delegate = self;
        [productsRequest start];
    }
    else
    {
        NSLog(@"不允许程序内付费购买");
        UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:@"提示"
                                                            message:@"您的手机没有打开程序内付费购买"
                                                           delegate:nil cancelButtonTitle:NSLocalizedString(@"关闭",nil) otherButtonTitles:nil];

        [alerView show];
        
    }
}

//弹出错误信息
- (void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    [self buyWithResult:RESTOREFAILED];
    NSLog(@"-------弹出错误信息----------");
    UIAlertView *alerView =  [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert",NULL) message:[error localizedDescription]
                                                       delegate:nil cancelButtonTitle:NSLocalizedString(@"Close",nil) otherButtonTitles:nil];
    [alerView show];
    
}


//沙盒测试环境验证
#define SANDBOX @"https://sandbox.itunes.apple.com/verifyReceipt"
//正式环境验证
#define AppStore @"https://buy.itunes.apple.com/verifyReceipt"
/**
 *  验证购买，避免越狱软件模拟苹果请求达到非法购买问题
 *
 */


-(void)verifyPurchaseWithPaymentTransaction{
    NSUserDefaults * storage = [NSUserDefaults standardUserDefaults];
    NSLog(@"----------verifyPurchaseWithPaymentTransaction------------");
    //从沙盒中获取交易凭证并且拼接成请求体数据
    // Load the receipt from the app bundle.
    NSURL *receiptURL = [[NSBundle mainBundle] appStoreReceiptURL];
    NSData *receipt = [NSData dataWithContentsOfURL:receiptURL];
    if (!receipt) {
        /* No local receipt -- handle the error. */
        NSLog(@"-------------handle the error.-------1-----");
        [self buyWithResult:RESTOREFAILED];
        
        [storage setObject:@"0" forKey:@"AD"];

        [storage synchronize];
        return;
    }
    /* ... Send the receipt data to your server ... */
    
    // Create the JSON object that describes the request
    NSError *error;
    
    //dfae61bc13eb415282d5b414ddc82087
    NSDictionary *requestContents = @{
                                      @"receipt-data": [receipt base64EncodedStringWithOptions:0],
                                      @"password":@"b35a9456043f41a8980a40becde43a4d"
                                      };
    NSData *requestData = [NSJSONSerialization dataWithJSONObject:requestContents
                                                          options:0
                                                            error:&error];
    
    if (!requestData) { /* ... Handle error ... */
        NSLog(@"---------Handle error------2----------");
        [self buyWithResult:RESTOREFAILED];
        
        [storage setObject:@"0" forKey:@"AD"];

            [storage synchronize];
        return;
    }
    
    // Create a POST request with the receipt data.
    NSURL *storeURL = [NSURL URLWithString:AppStore];
    NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
    [storeRequest setHTTPMethod:@"POST"];
    [storeRequest setHTTPBody:requestData];
    
    // Make a connection to the iTunes Store on a background queue.
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               if (connectionError) {
                                   /* ... Handle error ... */
                                   NSLog(@"---------Handle error ...--------3-------");
                                   [storage setObject:@"0" forKey:@"AD"];

                                   [storage synchronize];
                                       
                                   [self buyWithResult:RESTOREFAILED];
                                   return;
                               } else {
                                   NSError *error;
                                   NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                   if (!jsonResponse) { /* ... Handle error ...*/
                                       NSLog(@"---------... Handle error ...---------4------");
                                       [self buyWithResult:RESTOREFAILED];
                                       
                                       [storage setObject:@"0" forKey:@"AD"];

                                       return;
                                   }
                                   /* ... Send a response back to the device ... */
                                   //
                                   
                                   int statue = [[jsonResponse valueForKey:@"status"] intValue];
                                   if (statue==0) {
                                       NSLog(@"Success");
                                       NSArray * receiptArray = jsonResponse[@"latest_receipt_info"];
                                       NSDictionary * receipt = [receiptArray lastObject];
                                       if (receipt==nil) {
                                           receipt =jsonResponse[@"receipt"];
                                           
                                       }
                                       if (receipt) {
                                           [storage setObject:@"1" forKey:@"AD"];
                                           [storage synchronize];
                                           [self buyWithResult:RESTORESUCCESS];
                                       }else{
                                           [storage setObject:@"0" forKey:@"AD"];
                                           [storage synchronize];
                                           [self buyWithResult:RESTOREFAILED];
                                       }
                                       
                                   }else{
                                       if (statue == 21007) {
                                           NSLog(@"------------SANDBOX----------");
                                           // Create a POST request with the receipt data.
                                           NSURL *storeURL = [NSURL URLWithString:SANDBOX];
                                           NSMutableURLRequest *storeRequest = [NSMutableURLRequest requestWithURL:storeURL];
                                           [storeRequest setHTTPMethod:@"POST"];
                                           [storeRequest setHTTPBody:requestData];
                                           
                                           // Make a connection to the iTunes Store on a background queue.
                                           NSOperationQueue *queue = [[NSOperationQueue alloc] init];
                                           [NSURLConnection sendAsynchronousRequest:storeRequest queue:queue
                                                                  completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                                                                      if (connectionError) {
                                                                          /* ... Handle error ... */
                                                                          NSLog(@"---------Handle error ...--------3-------");
                                                                          
                                                                          [self buyWithResult:RESTOREFAILED];
                                                                          
                                                                          
                                                                              [storage setObject:@"0" forKey:@"AD"];
                                                                              [storage synchronize];
                                                                         
                                                                          return;
                                                                      } else {
                                                                          NSError *error;
                                                                          NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
                                                                          if (!jsonResponse) { /* ... Handle error ...*/
                                                                              NSLog(@"---------... Handle error ...---------4------");
                                                                              [storage setObject:@"0" forKey:@"AD"];

                                                                              [self buyWithResult:RESTOREFAILED];
                                                                              
                                                                              return;
                                                                          }
                                                                          /* ... Send a response back to the device ... */
                                                                          //
                                                                          
                                                                          int statue = [[jsonResponse valueForKey:@"status"] intValue];
                                                                          if (statue==0) {
                                                                              NSLog(@"Success");
                                                                              NSArray * receiptArray = jsonResponse[@"latest_receipt_info"];
                                                                                                      NSDictionary * receipt = [receiptArray lastObject];

                                                                              
                                                                              if (receipt==nil) {
                                                                                  receipt =jsonResponse[@"receipt"];
                                                                                  
                                                                              }
                                                                              
                                                                              if (receipt) {
                                                                                  [storage setObject:@"1" forKey:@"AD"];

                                                                                  [storage synchronize];
                                                             [self buyWithResult:RESTORESUCCESS];
                                                                              }else{
                                                                                  [storage setObject:@"0" forKey:@"AD"];
                                                                                  [storage synchronize];
                                                                                  [self buyWithResult:RESTOREFAILED];
                  }
                                                                              
                                                                              
                                                                              
                                                                          }else{
                                                                              
                                                                              [self buyWithResult:RESTOREFAILED];
                                                                              
                                                                              [storage setObject:@"0" forKey:@"AD"];

                                                                              
                                                                          }
                                                                      }
                                                                  }];
                                       }else{
                                           
                                           [self buyWithResult:RESTOREFAILED];
                                           
                                           [storage setObject:@"0" forKey:@"AD"];
                                           
                                       }
                                   }
                               }
                           }];
}
-(BOOL)isvipWithReceipt:(NSDictionary *) receipt{
    if (receipt) {
        BOOL b = [receipt[@"is_trial_period"]boolValue];
        if (b) {
            return YES;
        }
        b = [receipt[@"is_in_intro_offer_period"]boolValue];
        [NSTimeZone setDefaultTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        NSDate * now = [NSDate date];
        [NSTimeZone setDefaultTimeZone:[NSTimeZone systemTimeZone]];
        NSTimeInterval t = [receipt[@"expires_date_ms"]doubleValue]/1000;
        NSDate * time = [NSDate dateWithTimeIntervalSince1970:t];
        NSDate * data = [time earlierDate:now];
        
        if (data==time) {
            return NO;
        }else{
            return YES;
        }
    }
    return NO;
}

- (void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions//交易结果
{
    for (SKPaymentTransaction *transaction in transactions) {

        ISBUY = YES;
        switch (transaction.transactionState) {
                // Call the appropriate custom method for the transaction state.
            case SKPaymentTransactionStateFailed:
                [self failedTransaction:transaction];
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];

                break;
            case SKPaymentTransactionStatePurchased:{

                [self completeTransaction:transaction];
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];

                break;
            }
            case SKPaymentTransactionStateRestored:{
                //下载处理
                [self provideContent:transaction.transactionIdentifier];
                [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
                break;
            }
            default:

                break;
        }
    }
}


- (void) completeTransaction: (SKPaymentTransaction *)transaction

{
    NSLog(@"-----completeTransaction--------");
    // Your application should implement these two methods.
    
    //下载处理
    [self provideContent:transaction.transactionIdentifier];
    ISBUY = YES;

    [self verifyPurchaseWithPaymentTransaction];

    // Remove the transaction from the payment queue.
}
-(void)buyWithResult:(RestoreResult)result{
    if (!ISBUY) {
        return;
    }
    [[SKPaymentQueue defaultQueue] removeTransactionObserver:manager];

    if (_restoreFlag) {
        _restoreFlag = NO;
        if (self.delegate && [self.delegate respondsToSelector:@selector(restoreWithResult:)]) {
            [self.delegate restoreWithResult:result];
        }
        
    }else{
        if (self.delegate&&[self.delegate respondsToSelector: @selector(buyWithResult:)]) {
            if (result == RESTOREFAILED) {
                [self.delegate buyWithResult:NO];
            }else{
                [self.delegate buyWithResult:YES];
            }
        }
    }
    ISBUY = NO;
}

//处理下载内容
-(void)provideContent:(NSString *)product{
    NSLog(@"-----下载--------");
}

- (void) failedTransaction: (SKPaymentTransaction *)transaction{
    NSLog(@"---------失败--------%@----",transaction.error);
    [self buyWithResult:RESTOREFAILED];
}

-(void) paymentQueueRestoreCompletedTransactionsFinished: (SKPaymentTransaction *)transaction{
    NSLog(@"--------paymentQueueRestoreCompletedTransactionsFinished--------");
//    [self completeTransaction:transaction];
    ISBUY = YES;
    [self verifyPurchaseWithPaymentTransaction];
}

- (void) restore{
    if (self.delegate&&[self.delegate respondsToSelector: @selector(buyStart)]) {
        [self.delegate buyStart];
    }
    [[SKPaymentQueue defaultQueue] addTransactionObserver:manager];

    _restoreFlag = YES;
    ISBUY = YES;
    if ([SKPaymentQueue canMakePayments]) {
        // Yes, In-App Purchase is enabled on this device.
        // Proceed to restore purchases.
        
        // Request to restore previous purchases.
        [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
        
    } else {
        // Notify user that In-App Purchase is Disabled.
        [self buyWithResult:RESTOREFAILED];
    }
}
-(void) paymentQueue:(SKPaymentQueue *) paymentQueue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    NSLog(@"-------paymentQueue----");
    [self buyWithResult:RESTOREFAILED];
}

-(void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray<SKPaymentTransaction *> *)transactions{
    
}
// SKProductsRequestDelegate protocol method
- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    self.products = response.products;
    if (self.products.count==0) {
        [self buyWithResult:RESTOREFAILED];
        return;
    }
    

    SKProduct *p = nil;
    for (SKProduct *pro in self.products) {
        if([pro.productIdentifier isEqualToString:COMMODITYKEY]){
            p = pro;
        }
    }
    
    SKPayment *payment = [SKPayment paymentWithProduct:p];
    [[SKPaymentQueue defaultQueue] addPayment:payment];

}

-(void)dealloc
{
//    [[SKPaymentQueue defaultQueue] removeTransactionObserver:self];//解除监听
    
}
@end
