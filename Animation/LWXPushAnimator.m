//
//  LWXPushAnimator.m
//  Animation
//
//  Created by LWX on 2018/2/26.
//  Copyright © 2018年 LWX. All rights reserved.
//

#import "LWXPushAnimator.h"

@implementation LWXPushAnimator
- (void)setOriginView:(UIImageView *)originView {
    _originView = [[UIImageView alloc] initWithFrame:originView.frame];
    _originView.image = originView.image;
    _originView.contentMode = UIViewContentModeScaleAspectFill;
    _originView.clipsToBounds = YES;
}

- (NSTimeInterval)transitionDuration:(id<UIViewControllerContextTransitioning>)transitionContext {
    return 0.25;
}

- (void)animateTransition:(id<UIViewControllerContextTransitioning>)transitionContext {
    //转场过渡的容器view
    UIView *containerView = [transitionContext containerView];

    //FromVC
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromViewController.view;
    [containerView addSubview:fromView];
    
    //ToVC
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewController.view;
    [containerView addSubview:toView];
    toView.hidden = YES;

    UIView *blackView = [[UIView alloc] initWithFrame:containerView.bounds];
    blackView.backgroundColor = self.backColor;
    blackView.alpha = 0;
    [containerView addSubview:blackView];
    
    [containerView addSubview:self.originView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        blackView.alpha = 1;
        self.originView.frame = self.destinationFrame;
    } completion:^(BOOL finished) {
        toView.hidden = NO;
        
        [self.originView removeFromSuperview];
        [blackView removeFromSuperview];
        
        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        //设置transitionContext通知系统动画执行完毕
        [transitionContext completeTransition:!wasCancelled];
    }];
    
}
@end
