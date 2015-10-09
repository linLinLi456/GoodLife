//
//  SXWeatherBgM.h
//  GoodLife
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "JSONModel.h"

@interface SXWeatherBgM : JSONModel

@property(nonatomic,copy) NSString *nbg1;

/** 这个是真正的背景图*/
@property(nonatomic,copy) NSString *nbg2;

@property(nonatomic,copy) NSString *aqi;

@property(nonatomic,copy) NSString *pm2_5;

@end
