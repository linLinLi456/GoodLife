//
//  Cources.h
//  GoodLife
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "JSONModel.h"

#import "MarksModel.h"

@protocol Cources <NSObject>


@end

@interface Cources : JSONModel

@property (nonatomic,copy) NSString *_id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *iconUrl;
@property (nonatomic) NSInteger price;
@property (nonatomic,strong) NSArray <MarksModel,Ignore> *marks;
@property (nonatomic,copy) NSString *providerId;
@property (nonatomic,copy) NSString *providerName;
@end
/*
 {
 "_id": "55ed811e659e9372936ef87e",
 "enrollNum": 21,
 "iconUrl": "http://image.jaxus.cn/55efda8a11d8c225a36c6689.jpg",
 "listPrice": 990,
 "marks": [
 {
 "color": 8443217,
 "imageUrl": "http://image.jaxus.cn/mark/img-54def479ff4c352b67a9a6f1-1423898560295-android.png",
 "title": "连载"
 }
 ],
 "price": 990,
 "providerId": "555c2fbb659e933f35831849",
 "providerName": "上元在线",
 "title": "萌外教教你轻松学日常韩语"
 },
 */
