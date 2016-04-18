//
//  HGBannerItemView.m
//  HGAutoLayoutSample
//
//  Created by XiaoDou on 15/11/16.
//  Copyright © 2015年 北京嗨购电子商务有限公司. All rights reserved.
//

#import "BBTBannerItemView.h"

@interface BBTBannerItemView () {
    UILabel *_titleLabel;
}

@end

@implementation BBTBannerItemView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self titleLabel];
    }
    
    return self;
}

#pragma mark ############### Getter && Getter ################

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:self.frame];
        _titleLabel.font = [UIFont systemFontOfSize:50];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_titleLabel];
    }
    
    return _titleLabel;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    _titleLabel.text = title;
}

@end
