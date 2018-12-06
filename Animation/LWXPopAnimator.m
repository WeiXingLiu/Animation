//
//  LWXPopAnimator.m
//  Animation
//
//  Created by LWX on 2018/2/26.
//  Copyright © 2018年 LWX. All rights reserved.
//

#import "LWXPopAnimator.h"

@implementation LWXPopAnimator
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
    UIView *containerView = [transitionContext containerView];
    
    UIViewController *fromViewController = [transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    UIView *fromView = fromViewController.view;
    [containerView addSubview:fromView];
    
    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIView *toView = toViewController.view;
    [containerView addSubview:toView];
    
    UIView *backView = [[UIView alloc] initWithFrame:containerView.bounds];
    backView.backgroundColor = self.backColor;
    [containerView addSubview:backView];
    
    [containerView addSubview:self.originView];
    
    [UIView animateWithDuration:[self transitionDuration:transitionContext] animations:^{
        self.originView.frame = self.destinationFrame;
        backView.alpha = 0;
    } completion:^(BOOL finished) {
        [self.originView removeFromSuperview];
        [backView removeFromSuperview];

        BOOL wasCancelled = [transitionContext transitionWasCancelled];
        //设置transitionContext通知系统动画执行完毕
        [transitionContext completeTransition:!wasCancelled];
    }];
}
@end
