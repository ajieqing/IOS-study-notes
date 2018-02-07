//
//  TouchImageView.m
//  BeautyVideo
//
//  Created by 阿杰 on 2018/2/7.
//  Copyright © 2018年 baiwang. All rights reserved.
//

#import "TouchImageView.h"

@implementation TouchImageView{
    CGFloat x,y,s,r;

}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self makeTouchEventEnable];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self makeTouchEventEnable];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self makeTouchEventEnable];
    }
    return self;
}


-(void)makeTouchEventEnable{
    x=y=r=0;
    s=1;
    [self setUserInteractionEnabled:YES];
    
    [self setMultipleTouchEnabled:YES];
    UIPanGestureRecognizer *gestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGestureRecognizer:)];
    gestureRecognizer.delegate = self;
    gestureRecognizer.maximumNumberOfTouches =1;
    [self addGestureRecognizer:gestureRecognizer];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGestureRecognizer:)];
    pinchGestureRecognizer.delegate = self;
    [self addGestureRecognizer:pinchGestureRecognizer];
    UIRotationGestureRecognizer *rotationGestureRecognizer = [[UIRotationGestureRecognizer alloc] initWithTarget:self action:@selector(handleRotationGestureRecognizer:)];
    rotationGestureRecognizer.delegate = self;
    [self addGestureRecognizer:rotationGestureRecognizer];
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureRecognizer:)];
    longPressGestureRecognizer.delegate = self;
    [self addGestureRecognizer:longPressGestureRecognizer];
}


-(void)handlePanGestureRecognizer:(UIPanGestureRecognizer*)pan{
    switch (pan.state) {
        case UIGestureRecognizerStateBegan:
            x = y =0;
            break;
        default:
            break;
    }
    CGPoint point = [pan translationInView:pan.view];
    self.transform = CGAffineTransformTranslate(self.transform, (point.x) - x,(point.y) - y);
    x = point.x;
    y = point.y;
}


-(void)handlePinchGestureRecognizer:(UIPinchGestureRecognizer*)pinch{
    switch (pinch.state) {
        case UIGestureRecognizerStateBegan:
            s = 1;
            break;
        default:
            break;
    }
    self.transform = CGAffineTransformScale(self.transform, pinch.scale/s, pinch.scale/s);
    
    s = pinch.scale;
}
-(void)handleRotationGestureRecognizer:(UIRotationGestureRecognizer*)rotation{
    switch (rotation.state) {
        case UIGestureRecognizerStateBegan:
            r = 0;
            break;
        default:
            break;
    }
    self.transform = CGAffineTransformRotate(self.transform, rotation.rotation  - r);
    r = rotation.rotation;
}
-(void)handleLongPressGestureRecognizer:(UILongPressGestureRecognizer*)longPress{
    
}








//手指触摸屏幕后回调的方法，返回NO则不再进行手势识别，方法触发等
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch{
    return YES;
}
//开始进行手势识别时调用的方法，返回NO则结束，不再触发手势
- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer{
    return YES;
}
//是否支持多时候触发，返回YES，则可以多个手势一起触发方法，返回NO则为互斥
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
@end
