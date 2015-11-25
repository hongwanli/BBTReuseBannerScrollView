//
//  BBTBannerScrollView.m
//  BBTBannerScrollView
//
//  Created by XiaoDou on 15/11/16.
//  Copyright © 2015年 北京嗨购电子商务有限公司. All rights reserved.
//

#import "BBTBannerScrollView.h"
#import "BBTBannerItemView.h"

#define kBannerMaxNumber            (4)

@interface BBTBannerScrollView () <UIScrollViewDelegate> {
    UIScrollView *_scrollView;
    NSInteger _totalPage;
    NSInteger _currentIndex;
    NSMutableDictionary *_visibleItemViewsDictionary;
    NSMutableDictionary *_reuseableItemViewsDictionary;
}

@end

@implementation BBTBannerScrollView

#pragma mark ###################### LifeCycle ######################

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _visibleItemViewsDictionary = [NSMutableDictionary dictionary];
        _reuseableItemViewsDictionary = [NSMutableDictionary dictionary];
        [self createScrollView];
    }
    
    return self;
}

#pragma mark ###################### Public ######################

- (void)reloadData {
    [self reset];
    
    if ([self.dataSource respondsToSelector:@selector(numberOfBannerScrollView:)]) {
        _totalPage = [self.dataSource numberOfBannerScrollView:self];
        [_scrollView setContentSize:CGSizeMake(self.frame.size.width * _totalPage, self.frame.size.height)];
    }
    
    [self layoutVisibleItemViews];
}

- (id)itemViewOfIndex:(NSInteger)index {
    BBTBannerItemView *currentItemView = _visibleItemViewsDictionary[@(index)];
    
    return currentItemView;
}

- (id)dequeueReuseableItemViewWithIdentifier:(NSString *)reuseIndentifier {
    NSMutableArray *reuseItemViews = _reuseableItemViewsDictionary[reuseIndentifier];
    BBTBannerItemView *itemView = nil;
    if (reuseItemViews.count > 0) {
        itemView = reuseItemViews[0];
        [reuseItemViews removeObject:itemView];
    }
    
    return itemView;
}

#pragma mark ###################### Delegate ######################

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetX = scrollView.contentOffset.x;
    _currentIndex = offsetX / scrollView.frame.size.width;
    if ([self.delegate respondsToSelector:@selector(bannerScrollView:didScrollToIndex:)]) {
        [self.delegate bannerScrollView:self didScrollToIndex:_currentIndex];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    [self reuseItemViews];
    [self layoutVisibleItemViews];
}

#pragma mark ###################### Private ######################

- (void)reset {
    _currentIndex = 0;
    
    for (UIView *view in _scrollView.subviews) {
        [view removeFromSuperview];
    }
    
    if (_visibleItemViewsDictionary.allValues.count > 0) {
        [_visibleItemViewsDictionary removeAllObjects];
    }
    
    if (_reuseableItemViewsDictionary.allValues.count > 0) {
        [_reuseableItemViewsDictionary removeAllObjects];
    }
}

- (void)layoutVisibleItemViews {
    NSInteger previousIndex = (_currentIndex - 1);
    NSInteger nextIndex = (_currentIndex + 1);
    
    if (_currentIndex >= 0 && _currentIndex <= (_totalPage - 1)) {
        [self layoutItemViewWithIndex:_currentIndex];
    }
    
    if (previousIndex >= 0 && previousIndex <= (_totalPage - 2)) {
        [self layoutItemViewWithIndex:previousIndex];
    }
    
    if (nextIndex >= 1 && nextIndex <= (_totalPage - 1)) {
        [self layoutItemViewWithIndex:nextIndex];
    }
    
    if ([self.delegate respondsToSelector:@selector(bannerScrollView:didScrollToIndex:)]) {
        [self.delegate bannerScrollView:self didScrollToIndex:_currentIndex];
    }
}

- (void)reuseItemViews {
    NSInteger previousIndex = (_currentIndex - 1);
    NSInteger nextIndex = (_currentIndex + 1);
    
    for (NSInteger i = 0; i < _totalPage; i ++) {
        //前一页、当前页和后一页不参与回收
        if (i != previousIndex && i != _currentIndex && i != nextIndex) {
            BBTBannerItemView *itemView = _visibleItemViewsDictionary[@(i)];
            if (itemView) {
                NSMutableArray *reuseableItemViews = (NSMutableArray *)[_reuseableItemViewsDictionary objectForKey:itemView.reuseIndentifier];
                if (reuseableItemViews.count <= 0) {
                    reuseableItemViews = [NSMutableArray array];
                    _reuseableItemViewsDictionary[itemView.reuseIndentifier] = reuseableItemViews;
                }
                
                [reuseableItemViews addObject:itemView];
                
                [_visibleItemViewsDictionary removeObjectForKey:@(i)];
                
                [itemView removeFromSuperview];
            }
        }
    }
}

- (void)layoutItemViewWithIndex:(NSInteger)index {
    BBTBannerItemView *usingItemView = _visibleItemViewsDictionary[@(index)];
    if (usingItemView == nil && [self.dataSource respondsToSelector:@selector(bannerScrollView:itemViewForIndex:)]) {
        CGRect frame = CGRectMake(index * _scrollView.frame.size.width, 0, _scrollView.frame.size.width, _scrollView.frame.size.height);
        BBTBannerItemView *itemView = [self.dataSource bannerScrollView:self itemViewForIndex:index];
        itemView.itemIndex = index;
        itemView.frame = frame;
        [_scrollView addSubview:itemView];
        
        [_visibleItemViewsDictionary setObject:itemView forKey:@(index)];
    }
}

#pragma mark #################### Getter && Setter ####################

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

@end
