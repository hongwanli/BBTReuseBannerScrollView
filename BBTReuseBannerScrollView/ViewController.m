//
//  ViewController.m
//  BBTReuseBannerScrollView
//
//  Created by XiaoDou on 15/11/25.
//  Copyright © 2015年 北京嗨购电子商务有限公司. All rights reserved.
//

#import "ViewController.h"
#import "BBTBannerItemView.h"
#import "BBTBannerScrollView.h"

@interface ViewController () {
    BBTBannerScrollView *_bannerScrollView;
    NSInteger _createTime;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createBannerScrollView].bannerImageArray = [NSMutableArray arrayWithObjects:@"1",@"2",@"3", nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ################### Getter && Setter ######################

- (BBTBannerScrollView *)createBannerScrollView {
    if (!_bannerScrollView) {
        _bannerScrollView = [[BBTBannerScrollView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:_bannerScrollView];
    }
    
    return _bannerScrollView;
}


@end

