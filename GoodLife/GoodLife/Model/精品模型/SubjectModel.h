//
//  SubjectModel.h
//  GoodLife
//
//  Created by qianfeng on 15/10/5.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "JSONModel.h"

@interface SubjectModel : JSONModel

@property (nonatomic,copy) NSString *bannerUrl;
@property (nonatomic,copy) NSString *description;
@property (nonatomic,copy) NSString *title;

@end
