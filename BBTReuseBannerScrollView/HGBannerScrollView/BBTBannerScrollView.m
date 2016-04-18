//
//  BBTBannerScrollView.m
//  BBTBannerScrollView
//
//  Created by XiaoDou on 15/11/16.
//  Copyright © 2015年 北京嗨购电子商务有限公司. All rights reserved.
//

#import "BBTBannerItemView.h"
#import "BBTBannerScrollView.h"

#define kBannerViewMaxPage           (3)
#define kBannerViewHalfRate          (0.5)

typedef enum : NSUInteger {
    BBTBannerViewScrollDirectionNone,
    BBTBannerViewScrollDirectionLeft,
    BBTBannerViewScrollDirectionRight
} BBTBannerViewScrollDirection;

@interface BBTBannerScrollView () <UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    NSInteger _totalPage;
    NSInteger _currentIndex;
    NSInteger _nextIndex;
    BBTBannerItemView *_currentItemView;
    BBTBannerItemView *_otherItemView;
}
@property (nonatomic, assign) BBTBannerViewScrollDirection scrollDirection;

@end

@implementation BBTBannerScrollView

#pragma mark ###################### LifeCycle ######################

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createScrollView];
        [self currentItemView];
        [self otherItemView];
        [self resetBannerScrollViewIndex];
    }
    
    return self;
}

#pragma mark ###################### Public ######################

- (void)setBannerImageArray:(NSMutableArray *)bannerImageArray {
    _bannerImageArray = bannerImageArray;
    _totalPage = _bannerImageArray.count;
    [self resetBannerScrollViewIndex];
    [self setBannerScrollViewContentSize];
    _currentItemView.title = _bannerImageArray.firstObject;
}

- (void)setScrollDirection:(BBTBannerViewScrollDirection)scrollDirection {
    if (_scrollDirection == scrollDirection) {
        return;
    }
    _scrollDirection = scrollDirection;
    if (scrollDirection == BBTBannerViewScrollDirectionNone) {
        return;
    }
    if (_scrollDirection == BBTBannerViewScrollDirectionRight) {
        _otherItemView.frame = CGRectMake(0, 0, self.width, self.height);
        _nextIndex = _currentIndex - 1;
        if (_nextIndex < 0) {//如果小于0 则改成最后一张
            _nextIndex = _totalPage - 1;
        }
    } else if (_scrollDirection == BBTBannerViewScrollDirectionLeft){
        _otherItemView.frame = CGRectMake(CGRectGetMaxX(_currentItemView.frame), 0, self.width, self.height);
        _nextIndex = _currentIndex + 1;
        if (_nextIndex > (_totalPage - 1)) {
            _nextIndex = 0;
        }
    }
    _otherItemView.title = self.bannerImageArray[_nextIndex];
}

#pragma mark ###################### Delegate ######################

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    if (offsetX > self.width) {
        self.scrollDirection = BBTBannerViewScrollDirectionLeft;
    } else if (offsetX < self.width) {
        self.scrollDirection = BBTBannerViewScrollDirectionRight;
    } else {
        self.scrollDirection = BBTBannerViewScrollDirectionNone;
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self pauseBannerScrollView];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self pauseBannerScrollView];
}

#pragma mark ###################### Private ######################

- (void)resetBannerScrollViewIndex {
    _currentIndex = 0;
    _scrollDirection = BBTBannerViewScrollDirectionNone;
}

- (void)setBannerScrollViewContentSize {
    if (_totalPage > 1) {//大于一页时才可以滚动
        _scrollView.scrollEnabled = YES;
        _currentItemView.frame = CGRectMake(self.width, 0, self.width, self.height);
        _otherItemView.frame = CGRectMake(CGRectGetMaxX(_currentItemView.frame), 0, self.width, self.height);
        [_scrollView setContentSize:CGSizeMake(self.width * kBannerViewMaxPage, self.height)];
        [_scrollView setContentOffset:CGPointMake(self.width, 0)];
    } else {
        _scrollView.scrollEnabled = NO;
    }
}

- (void)pauseBannerScrollView {
    //未滚动则不重新设置title
    if (_scrollDirection == BBTBannerViewScrollDirectionNone) {
      return;
    }
    
    _currentIndex = _nextIndex;
    _currentItemView.frame = CGRectMake(self.width, 0, self.width, self.height);
    _currentItemView.title = _otherItemView.title;
    _scrollView.contentOffset = CGPointMake(self.width, 0);
}

#pragma mark #################### Getter && Setter ####################

- (CGFloat)width {
    return CGRectGetWidth(self.frame);
}

- (CGFloat)height {
    return CGRectGetHeight(self.frame);
}

- (UIScrollView *)createScrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.scrollsToTop = NO;
        _scrollView.delegate = self;
        [self addSubview:_scrollView];
    }
    
    return _scrollView;
}

- (BBTBannerItemView *)currentItemView {
    if (!_currentItemView) {
        CGRect frame = CGRectMake(0, 0, self.width, self.height);
        _currentItemView = [[BBTBannerItemView alloc] initWithFrame:frame];
        [_scrollView addSubview:_currentItemView];
    }
    
    return _currentItemView;
}

- (BBTBannerItemView *)otherItemView {
    if (!_otherItemView) {
        CGRect frame = CGRectMake(0, 0, self.width, self.height);
        _otherItemView = [[BBTBannerItemView alloc] initWithFrame:frame];
        [_scrollView addSubview:_otherItemView];
    }
    
    return _otherItemView;
}

@end
