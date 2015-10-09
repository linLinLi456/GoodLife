//
//  SXWeatherModel.h
//  GoodLife
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "JSONModel.h"
#import "SXWeatherDetailM.h"
#import "SXWeatherBgM.h"
//@class SXWeatherBgM;
//@class SXWeatherDetailM;

@interface SXWeatherModel : JSONModel

/** 数组里面装的是SXWeatherDetailM模型*/
@property(nonatomic,strong)NSArray <SXWeatherDetailM>*detailArray;
@property(nonatomic,strong) SXWeatherBgM *pm2d5;
@property(nonatomic,copy)NSString *dt;
@property(nonatomic,assign)int rt_temperature;

@end
