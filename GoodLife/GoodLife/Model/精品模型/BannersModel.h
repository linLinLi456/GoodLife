//
//  BannersModel.h
//  GoodLife
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "JSONModel.h"
#import "MarksModel.h"

@protocol BannersModel <NSObject>

@end

@interface BannersModel : JSONModel

@property (nonatomic,copy) NSString *_id;
@property (nonatomic) NSNumber *aType;
@property (nonatomic,copy) NSString *courseId;
@property (nonatomic) NSNumber *iType;
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,strong) NSArray <MarksModel,Optional> *marks;
@property (nonatomic,copy) NSString *title;

@end
/*
 {
 "_id": "5605f23311d8c24522b8b119",
 "aType": 0,
 "courseId": "54ba0320bba4cd54e9fa021c",
 "iType": 7,
 "imageUrl": "http://image.jaxus.cn/5605f26b11d8c24522b8b11b.jpg",
 "marks": [],
 "title": "懒妈早餐系列"
 },
 */