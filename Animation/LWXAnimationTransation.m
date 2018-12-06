//
//  LWXAnimationTransation.m
//  Animation
//
//  Created by LWX on 2018/2/26.
//  Copyright © 2018年 LWX. All rights reserved.
//

#import "LWXAnimationTransation.h"
#import "LWXPushAnimator.h"
#import "LWXPopAnimator.h"
@interface LWXAnimationTransation()
@property (nonatomic, strong) LWXPushAnimator *customPush;
@property (nonatomic, strong) LWXPopAnimator *customPop;
@end

@implementation LWXAnimationTransation
- (LWXPushAnimator *)customPush {
    if (!_customPush) {
        _customPush = [[LWXPushAnimator alloc] init];
        _customPush.originView = self.originView;
        _customPush.image = self.originImage;
        _customPush.destinationFrame = self.destinationFrame;
        _customPush.backColor = self.backColor;
    }
    return _customPush;
}

- (LWXPopAnimator *)customPop {
    if (!_customPop) {
        _customPop = [[LWXPopAnimator alloc] init];
        _customPop.originView = self.originView;
        _customPop.image = self.originImage;
        _customPop.destinationFrame = self.destinationFrame;
        _customPop.backColor = self.backColor;
    }
    return _customPop;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                            animationControllerForOperation:(UINavigationControllerOperation)operation
                                                         fromViewController:(UIViewController *)fromVC
                                                           toViewController:(UIViewController *)toVC{
    if (operation == UINavigationControllerOperationPush) {
        return self.customPush;
        
    }else if (operation == UINavigationControllerOperationPop){
        return self.customPop;
    }
    return nil;
}
@end
