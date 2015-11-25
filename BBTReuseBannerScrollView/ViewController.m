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

@interface ViewController () <BBTBannerScrollViewDataSource> {
    BBTBannerScrollView *_bannerScrollView;
    NSInteger _createTime;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self createBannerScrollView];
    [_bannerScrollView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark ################### Delegate ######################

#pragma mark - HGBannerScrollViewDataSource

- (NSInteger)numberOfBannerScrollView:(BBTBannerScrollView *)bannerScrollView {
    return 10;
}

- (BBTBannerItemView *)bannerScrollView:(BBTBannerScrollView *)bannerScrollView itemViewForIndex:(NSInteger)index {
    static NSString *reuseIndentifier = @"BBTBannerItemView";
    BBTBannerItemView *itemView = [bannerScrollView dequeueReuseableItemViewWithIdentifier:reuseIndentifier];
    if (itemView == nil) {
        _createTime ++;
        itemView = [[BBTBannerItemView alloc] initWithIndentifier:reuseIndentifier];
        NSLog(@"第%@次创建",@(_createTime));
    }
    
    itemView.title = [NSString stringWithFormat:@"%@",@(index)];
    
    return itemView;
}

#pragma mark ################### Getter && Setter ######################

- (BBTBannerScrollView *)createBannerScrollView {
    if (!_bannerScrollView) {
        _bannerScrollView = [[BBTBannerScrollView alloc] initWithFrame:self.view.bounds];
        _bannerScrollView.dataSource = self;
        [self.view addSubview:_bannerScrollView];
    }
    
    return _bannerScrollView;
}


@end

