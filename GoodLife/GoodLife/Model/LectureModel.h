//
//  LectureModel.h
//  GoodLife
//
//  Created by qianfeng on 15/10/7.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "JSONModel.h"

@protocol LectureModel <NSObject>

@end

@interface LectureModel : JSONModel

@property (nonatomic,copy) NSString *_id;
@property (nonatomic,copy) NSString *length;
//@property (nonatomic) NSNumber *listPrice;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *videoId;
@property (nonatomic) NSNumber *price;

@end
/*
 {
 "_id": "55ed811e659e9372936ef880",
 "length": "677",
 "listPrice": 0,
 "preview": true,
 "previewTime": -1,
 "price": 0,
 "rType": "video",
 "size": "33634349",
 "title": "有时间的话来我们家吧！——单词",
 "videoId": "55ed3354d3a0b26b2a26a850",
 "videoMd5": "9a19bf49a99447e271d8e6e9d7ec3b37"
 }
 */