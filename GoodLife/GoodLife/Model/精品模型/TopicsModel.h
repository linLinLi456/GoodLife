//
//  TopicsModel.h
//  GoodLife
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "JSONModel.h"

@protocol TopicsModel <NSObject>

@end

@interface TopicsModel : JSONModel

@property (nonatomic,copy) NSString *_id;
@property (nonatomic,copy) NSString <Optional>*bannerUrl;
@property (nonatomic) NSNumber *iType;
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic) NSNumber <Optional>*tType;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString <Optional>*userId;

@end
/*
 {
 "_id": "551bb178bba4cd78941778c6",
 "bannerUrl": "",
 "iType": 9,
 "imageUrl": "http://image.jaxus.cn/5602449611d8c24522b8aff0.png",
 "tType": 2,
 "title": "Jane Donna",
 "userId": "551b8bc1bba4cd789417784a"
 },
 */