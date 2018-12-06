//
//  PushViewController.m
//  Animation
//
//  Created by LWX on 2018/2/26.
//  Copyright © 2018年 LWX. All rights reserved.
//

#import "PushViewController.h"
#import "LWXAnimationTransation.h"

@interface PushViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) LWXAnimationTransation *animatedTransition;
@end

@implementation PushViewController

- (LWXAnimationTransation *)animatedTransition{
    if (!_animatedTransition) {
        _animatedTransition = [[LWXAnimationTransation alloc] init];
    }
    return _animatedTransition;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    UIImage *image = [UIImage imageNamed:@"example1.jpg"];
    
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = [self backScreenImageViewRectWithImage:image];
    _imageView.image = image;
    _imageView.userInteractionEnabled = YES;
    
    [self.view addSubview:self.imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_imageView addGestureRecognizer:tap];
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    //1. 设置代理
    self.animatedTransition = nil;
    self.navigationController.delegate = self.animatedTransition;
    
    //2. 传入必要的参数
    [self.animatedTransition setOriginView:self.imageView];
    [self.animatedTransition setOriginImage:self.imageView.image];
    [self.animatedTransition setDestinationFrame:CGRectMake(100, 100, 100, 100)];
    //3.push跳转
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController pushViewController:second animated:YES];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
