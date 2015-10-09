//
//  SubModel.h
//  GoodLife
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "JSONModel.h"
#import "CategoryModel.h"

@interface SubModel : JSONModel

@property (nonatomic,strong) NSArray <CategoryModel> *subcategories;

@end
