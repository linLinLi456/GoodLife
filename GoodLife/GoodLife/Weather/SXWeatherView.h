//
//  SXWeatherView.h
//  GoodLife
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SXWeatherModel;

typedef void(^pushOtherVC)(NSInteger index);

@interface SXWeatherView : UIView

@property(nonatomic,strong)SXWeatherModel *weatherModel;

@property (nonatomic,copy) pushOtherVC block;

+ (instancetype)view;
- (void)addAnimate;

@end
