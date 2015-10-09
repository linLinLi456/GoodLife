//
//  BigModel.h
//  GoodLife
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "JSONModel.h"
#import "ItemsModel.h"

@interface BigModel : JSONModel

@property (nonatomic,strong) NSArray <ItemsModel> *items;

@end
