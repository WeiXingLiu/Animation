//
//  LWXAnimationTransation.h
//  Animation
//
//  Created by LWX on 2018/2/26.
//  Copyright © 2018年 LWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface LWXAnimationTransation : NSObject<UINavigationControllerDelegate>
@property (nonatomic, strong) UIImageView *originView;
@property (nonatomic, strong) UIImage *originImage;
@property (nonatomic, strong) UIColor *backColor;
@property (nonatomic, assign) CGRect destinationFrame;
@end
