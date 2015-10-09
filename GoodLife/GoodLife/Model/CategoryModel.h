//
//  CategoryModel.h
//  GoodLife
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "JSONModel.h"
#import "SubcategoriesModel.h"

@protocol CategoryModel <NSObject>

@end

@interface CategoryModel : JSONModel

@property (nonatomic,copy) NSString *_id;
@property (nonatomic,copy) NSString *iconUrl;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,strong) NSArray <SubcategoriesModel> *subcategories;

@end
