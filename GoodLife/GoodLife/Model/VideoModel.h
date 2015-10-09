//
//  VideoModel.h
//  GoodLife
//
//  Created by qianfeng on 15/10/7.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "JSONModel.h"

#import "SectionModel.h"

@interface VideoModel : JSONModel

@property (nonatomic,strong) NSArray <SectionModel> *sections;
@property (nonatomic) NSNumber *totalLectures;

@end
