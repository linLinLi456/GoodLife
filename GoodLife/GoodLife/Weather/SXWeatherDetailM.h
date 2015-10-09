//
//  SXWeatherDetailM.h
//  GoodLife
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "JSONModel.h"

@protocol SXWeatherDetailM <NSObject>

@end

@interface SXWeatherDetailM : JSONModel

/** 什么风*/
@property(nonatomic,copy)NSString *wind;
/** 农历*/
@property(nonatomic,copy)NSString *nongli;
/** 日期*/
@property(nonatomic,copy)NSString *date;
/** 天气*/
@property(nonatomic,copy)NSString *climate;
/** 温度*/
@property(nonatomic,copy)NSString *temperature;
/** 星期几*/
@property(nonatomic,copy)NSString *week;

@end
