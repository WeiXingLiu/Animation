//
//  ViewController.m
//  Animation
//
//  Created by LWX on 2018/2/26.
//  Copyright © 2018年 LWX. All rights reserved.
//

#import "ViewController.h"
#import "PushViewController.h"
#import "LWXPhotoBrowser.h"

#define kScreenWidth [[UIScreen mainScreen] bounds]
#define space 10.0
#define eachWdith (kScreenWidth.size.width - space * 5) / 4.0
@interface ViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@end

@implementation ViewController

- (UIImageView *)imageView {
    _imageView = [[UIImageView alloc] init];
    _imageView.frame = CGRectMake(100, 100, 100, 100);
    _imageView.userInteractionEnabled = YES;
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    _imageView.clipsToBounds = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [_imageView addGestureRecognizer:tap];
    return _imageView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    for (int i = 0; i < 8; i ++) {
        UIImageView *imageView = self.imageView;
        imageView.tag = 10 + i;
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"example%d.jpg", i % 4 + 1]];
        
        imageView.frame = CGRectMake((10 * ((i % 4) + 1) + eachWdith * ((i % 4))) , i < 3 ? 100 : 200 , eachWdith, eachWdith);
        [self.view addSubview:imageView];
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    UIImageView *imageView = (UIImageView *)tap.view;
    
    NSMutableArray *imageArr = [NSMutableArray new];
    for (int i = 0 ; i < 8; i ++) {
        UIImageView *mageView = [self.view viewWithTag:10 + i];
        [imageArr addObject:mageView.image];
    }
    
    [[LWXPhotoBrowser defaultManager] showBrowserWithImages:imageArr
                                            originImageView:imageView
                                                currentPage:tap.view.tag - 10
                                                   getFrame:^CGRect(int index) {
                                                       UIImageView *imageView = [self.view viewWithTag:10 + index];
                                                       return imageView.frame;
                                                   }
                                           deleteImageBlock:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
