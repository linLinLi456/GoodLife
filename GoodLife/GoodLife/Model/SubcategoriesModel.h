//
//  SubcategoriesModel.h
//  GoodLife
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "JSONModel.h"

@protocol SubcategoriesModel <NSObject>

@end

@interface SubcategoriesModel : JSONModel

@property (nonatomic,copy) NSString *_id;
@property (nonatomic,copy) NSString *iconUrl;
@property (nonatomic,copy) NSString *name;

@end
/*
 {
 "_id": "553b9a8aff4c352f3cb68066",
 "iconUrl": "http://image.jaxus.cn/category-icon/1.6/%E4%B8%AD%E9%A4%90.png",
 "name": "中餐"
 },
 */