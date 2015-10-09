//
//  ObjModel.h
//  GoodLife
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "JSONModel.h"
#import "RanksModel.h"
@interface ObjModel : JSONModel

@property (nonatomic,strong) NSArray <RanksModel> *ranks;

@end
