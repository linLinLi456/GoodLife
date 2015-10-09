//
//  ItemsModel.h
//  GoodLife
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "JSONModel.h"
#import "BannersModel.h"
#import "TopicsModel.h"
#import "Cources.h"
#import "MarksModel.h"

@protocol ItemsModel <NSObject>


@end

@interface ItemsModel : JSONModel

@property (nonatomic,strong) NSArray <BannersModel,Optional> *banners;
@property (nonatomic,strong) NSArray <TopicsModel,Optional> *topics;
@property (nonatomic,strong) NSArray <Cources,Optional> *courses;
@property (nonatomic,copy) NSString <Optional>*title;
@property (nonatomic,copy) NSString <Optional>*columnId;

@end
