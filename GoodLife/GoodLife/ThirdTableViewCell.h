//
//  ThirdTableViewCell.h
//  GoodLife
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Cources.h"
#import "RanksModel.h"

@interface ThirdTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *IconUrl;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *providerName;
@property (weak, nonatomic) IBOutlet UILabel *price;
-(void)showDataWithModel:(Cources *)model;
//-(void)initDataWithModel:(RanksModel *)model;
@end
