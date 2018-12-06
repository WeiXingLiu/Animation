//
//  LWXPhotoBrowser.m
//  Animation
//
//  Created by LWX on 2018/2/26.
//  Copyright © 2018年 LWX. All rights reserved.
//

#import "LWXPhotoBrowser.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppDelegate.h"
#import "LWXAnimationTransation.h"

#define LWXWeakSelf(type)  __weak typeof(type) weak##type = type;

#define IMAGE_MAX_SIZE_5k 5120*2880

static LWXPhotoBrowser *detailInstance = nil;

@interface LWXPhotoBrowser()
@property (nonatomic, strong) LWXAnimationTransation *animatedTransition;

@property (strong, nonatomic) UIWindow *keyWindow;

@property (strong, nonatomic) NSMutableArray *photos;
@property (strong, nonatomic) UINavigationController *photoNavigationController;
@end

@implementation LWXPhotoBrowser
+ (id)defaultManager
{
    @synchronized(self){
        static dispatch_once_t pred;
        dispatch_once(&pred, ^{
            detailInstance = [[self alloc] init];
        });
    }
    
    return detailInstance;
}

#pragma mark - getter

- (UIWindow *)keyWindow
{
    if(_keyWindow == nil)
    {
        _keyWindow = [[UIApplication sharedApplication] keyWindow];
    }
    
    return _keyWindow;
}

- (NSMutableArray *)photos
{
    if (_photos == nil) {
        _photos = [[NSMutableArray alloc] init];
    }
    
    return _photos;
}

- (UINavigationController *)photoNavigationController
{
    if (_photoNavigationController == nil) {
        _photoNavigationController = [[UINavigationController alloc] initWithRootViewController:self.photoBrowser];
        _photoNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    }
    
    [self.photoBrowser reloadData];
    return _photoNavigationController;
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return [self.photos count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photos.count)
    {
        return [self.photos objectAtIndex:index];
    }
    
    return nil;
}


#pragma mark - private


#pragma mark - public
#pragma mark - public
- (void)showBrowserWithImages:(NSArray *)imageArray
              originImageView:(UIImageView *)originImageView
                  currentPage:(NSInteger)currentPage
                     getFrame:(BrowserGetFrame)getFrame
             deleteImageBlock:(DeleteImageBlock)deleteBlock{
    if (imageArray && [imageArray count] > 0) {
        NSMutableArray *photoArray = [NSMutableArray array];
        for (id object in imageArray) {
            MWPhoto *photo;
            if ([object isKindOfClass:[UIImage class]]) {
                //                CGFloat imageSize = ((UIImage*)object).size.width * ((UIImage*)object).size.height;
                //                if (imageSize > IMAGE_MAX_SIZE_5k) {
                //                    photo = [MWPhoto photoWithImage:[self scaleImage:object toScale:(IMAGE_MAX_SIZE_5k)/imageSize]];
                //                } else {
                photo = [MWPhoto photoWithImage:object];
                //                }
            }
            else if ([object isKindOfClass:[NSURL class]])
            {
                photo = [MWPhoto photoWithURL:object];
            }
            else if ([object isKindOfClass:[NSString class]])
            {
                photo = [MWPhoto photoWithURL:[NSURL URLWithString:object]];
            }else if ([object isKindOfClass:[ALAsset class]]) {
                CGImageRef fullScreenImageRef = ((ALAsset *)object).defaultRepresentation.fullScreenImage;
                photo = [MWPhoto photoWithImage:[UIImage imageWithCGImage:fullScreenImageRef]];
            }
            [photoArray addObject:photo];
        }
        
        self.photos = photoArray;
    }
    //    [self.photoBrowser setCurrentPhotoIndex:currentPage];
    
    _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    _photoBrowser.getFrame = getFrame;
    _photoBrowser.displayActionButton = YES;
    _photoBrowser.displayNavArrows = YES;
    _photoBrowser.displaySelectionButtons = NO;
    _photoBrowser.alwaysShowControls = NO;
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"//去除警告
    _photoBrowser.wantsFullScreenLayout = YES;
#pragma clang diagnostic pop
    _photoBrowser.zoomPhotosToFill = YES;
    _photoBrowser.enableGrid = NO;
    _photoBrowser.startOnGrid = NO;
    [_photoBrowser setCurrentPhotoIndex:currentPage];
    
//    _photoNavigationController = [[UINavigationController alloc] initWithRootViewController:_photoBrowser];
//    _photoNavigationController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //    }
    
    [_photoBrowser reloadData];
    if (deleteBlock) {
        LWXWeakSelf(self);
        _photoBrowser.deleteBlock = ^(NSInteger location){
            deleteBlock(location);
            
            [weakself.photos removeObjectAtIndex:location];
            if (weakself.photos.count == 0) {
                [weakself.photoNavigationController dismissViewControllerAnimated:YES completion:nil];
            } else {
                [weakself.photoBrowser setCurrentPhotoIndex:(location == 0) ? 0 : (--location)];
                [weakself.photoBrowser reloadData];
            }
        };
    }
    [self showBrowser:originImageView];
}

- (void)showBrowser:(UIImageView *)originImageView {
    //1. 设置代理
    UINavigationController *navController = [[self topViewController] navigationController];
    self.animatedTransition = nil;
     navController.delegate = self.animatedTransition;
    
    //2. 传入必要的参数
    [self.animatedTransition setOriginView:originImageView];
    [self.animatedTransition setOriginImage:originImageView.image];
    [self.animatedTransition setDestinationFrame:[self backScreenImageViewRectWithImage:originImageView.image]];
    [self.animatedTransition setBackColor:[UIColor blackColor]];
    //3.push跳转
    [navController pushViewController:self.photoBrowser animated:YES];
}

- (UIViewController*)topViewController {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    return [self topViewControllerWithRootViewController:app.window.rootViewController];
}

- (UIViewController*)topViewControllerWithRootViewController:(UIViewController*)rootViewController {
    
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    } else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController* navigationController = (UINavigationController*)rootViewController;
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    } else if (rootViewController.presentedViewController) {
        UIViewController* presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    } else {
        return rootViewController;
    }
}

- (LWXAnimationTransation *)animatedTransition{
    if (!_animatedTransition) {
        _animatedTransition = [[LWXAnimationTransation alloc] init];
    }
    return _animatedTransition;
}

//返回imageView在window上全屏显示时的frame
- (CGRect)backScreenImageViewRectWithImage:(UIImage *)image{
    
    CGSize size = image.size;
    CGSize newSize;
    newSize.width = [[UIScreen mainScreen] bounds].size.width;
    newSize.height = newSize.width / size.width * size.height;
    
    CGFloat imageY = ( [[UIScreen mainScreen] bounds].size.height - newSize.height) * 0.5;
    
    if (imageY < 0) {
        imageY = 0;
    }
    CGRect rect =  CGRectMake(0, imageY, newSize.width, newSize.height);
    
    return rect;
}


- (UIImage *)scaleImage:(UIImage *)image toScale:(float)scaleSize
{
    UIGraphicsBeginImageContext(CGSizeMake(image.size.width * scaleSize, image.size.height * scaleSize));
    [image drawInRect:CGRectMake(0, 0, image.size.width * scaleSize, image.size.height * scaleSize)];
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

@end
