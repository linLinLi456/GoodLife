//
//  SuperModel.h
//  GoodLife
//
//  Created by qianfeng on 15/10/6.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "JSONModel.h"

@interface SuperModel : JSONModel

@property (nonatomic,copy) NSString *_id;
@property (nonatomic,copy) NSString *avatarUrl;
@property (nonatomic) NSNumber *enrolledNo;
@property (nonatomic) NSNumber <Optional>*fans_amount;
@property (nonatomic,copy) NSString <Optional>*providerId;
@property (nonatomic,copy) NSString <Optional>*providerIntro;
@property (nonatomic) NSNumber <Optional>*providerType;
@property (nonatomic) NSNumber <Optional>*publishedNo;
@property (nonatomic,copy) NSString <Optional>*signature;
@property (nonatomic,copy) NSString *username;
@property (nonatomic,copy) NSString <Optional>*webProviderId;

@end
/*
 {
 "_id": "549bda80bba4cd497350e99e",
 "avatarUrl": "http://image.jaxus.cn/avatar/provider_549bda80bba4cd497350e99e1419500916.jpg",
 "enrolledNo": 0,
 "fans_amount": 17,
 "gender": true,
 "providerId": "549be123bba4cd497350e9a1",
 "providerIntro": "英语词汇记忆讲师",
 "providerType": 0,
 "publishedNo": 1,
 "signature": "搜狐教育英语专栏作家； \n有道词典特邀词汇记忆讲师；\n互联网上最受欢迎的单词记忆节目《铁夫破词》的创立者； \n自由音乐人......",
 "stat": 1,
 "username": "赵铁夫",
 "webProviderId": "549bda80bba4cd497350e99f"
 }
 */