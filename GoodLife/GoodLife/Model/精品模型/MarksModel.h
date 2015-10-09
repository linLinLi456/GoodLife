//
//  MarksModel.h
//  GoodLife
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "JSONModel.h"

@protocol  MarksModel<NSObject>

@end

@interface MarksModel : JSONModel

@property (nonatomic) NSNumber *color;
@property (nonatomic,copy) NSString *imageUrl;
@property (nonatomic,copy) NSString *title;

@end
