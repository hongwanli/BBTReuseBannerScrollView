//
//  HGBannerItemView.h
//  HGAutoLayoutSample
//
//  Created by XiaoDou on 15/11/16.
//  Copyright © 2015年 北京嗨购电子商务有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BBTBannerItemView : UIView

@property (nonatomic, strong) NSString *reuseIndentifier;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) NSInteger itemIndex;

- (instancetype)initWithIndentifier:(NSString *)reuseIndentifier;

@end
