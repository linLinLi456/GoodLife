//
//  RanksModel.h
//  GoodLife
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "JSONModel.h"

#import "Cources.h"

@protocol RanksModel <NSObject>

@end

@interface RanksModel : JSONModel

@property (nonatomic,strong) NSArray <Cources> *courses;
@property (nonatomic,copy) NSString *_id;
@property (nonatomic,copy) NSString *title;

@end
