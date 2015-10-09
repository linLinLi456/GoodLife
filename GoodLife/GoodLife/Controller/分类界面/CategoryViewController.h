//
//  CategoryViewController.h
//  GoodLife
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CategoryModel.h"

@interface CategoryViewController : UIViewController

@property (nonatomic,copy) NSString *pid;

@property (nonatomic,strong) CategoryModel *subModel;

@property (nonatomic,copy) NSString *CategoryId;

@end
