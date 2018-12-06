//
//  LWXPhotoBrowser.h
//  Animation
//
//  Created by LWX on 2018/2/26.
//  Copyright © 2018年 LWX. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MWPhotoBrowser.h"
@interface LWXPhotoBrowser : NSObject
@property (strong, nonatomic) MWPhotoBrowser *photoBrowser;

+ (id)defaultManager;

//default
- (void)showBrowserWithImages:(NSArray *)imageArray
                       originImageView:(UIImageView *)originImageView
                  currentPage:(NSInteger)currentPage
                     getFrame:(BrowserGetFrame)getFrame
             deleteImageBlock:(DeleteImageBlock)deleteBlock;

@end
