//
//  OnBuyFinish.h
//  InstaSquare
//
//  Created by 阿杰 on 2017/10/23.
//  Copyright © 2017年 baiwamg. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum{
    RESTOREFAILED,RESTORESUCCESS
}RestoreResult;

@protocol OnBuyFinish<NSObject>

@required
-(void)buyWithResult:(BOOL)result;
-(void)buyStart;
@optional
-(void)restoreWithResult:(RestoreResult)result;
@end
