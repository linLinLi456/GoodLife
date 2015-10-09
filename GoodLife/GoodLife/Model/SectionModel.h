//
//  SectionModel.h
//  GoodLife
//
//  Created by qianfeng on 15/10/7.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "JSONModel.h"
#import "LectureModel.h"

@protocol SectionModel <NSObject>

@end

@interface SectionModel : JSONModel

@property (nonatomic,strong) NSArray<LectureModel> *lectures;
@property (nonatomic,copy) NSString *_id;
@property (nonatomic,copy) NSString *title;
@property (nonatomic) NSNumber *price;
//@property (nonatomic) NSNumber *listPrice;

@end
