//
//  BBTBannerScrollView.h
//  BBTBannerScrollView
//
//  Created by XiaoDou on 15/11/16.
//  Copyright © 2015年 北京嗨购电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBTBannerScrollView : UIView

@property (nonatomic, weak) id dataSource;
@property (nonatomic, weak) id delegate;

- (void)reloadData;
- (id)itemViewOfIndex:(NSInteger)index;
- (id)dequeueReuseableItemViewWithIdentifier:(NSString *)reuseIndentifier;

@end

@protocol BBTBannerScrollViewDataSource <NSObject>
@required

- (NSInteger)numberOfBannerScrollView:(BBTBannerScrollView *)bannerScrollView;
- (id)bannerScrollView:(BBTBannerScrollView *)bannerScrollView itemViewForIndex:(NSInteger)index;

@end

@protocol BBTBannerScrollViewDelegate <NSObject>
@optional

- (void)bannerScrollView:(BBTBannerScrollView *)bannerScrollView didScrollToIndex:(NSInteger)index;

@end