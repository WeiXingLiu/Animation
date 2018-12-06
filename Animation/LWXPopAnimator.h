//
//  LWXPopAnimator.h
//  Animation
//
//  Created by LWX on 2018/2/26.
//  Copyright © 2018年 LWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LWXPopAnimator : NSObject<UIViewControllerAnimatedTransitioning>
@property (nonatomic, strong) UIImageView *originView;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, assign) CGRect destinationFrame;
@property (nonatomic, strong) UIColor *backColor;
@end
