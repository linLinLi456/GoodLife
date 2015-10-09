//
//  SubjectTableViewCell.h
//  GoodLife
//
//  Created by qianfeng on 15/10/5.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubjectModel.h"

@interface SubjectTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *ImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
-(void)showDataWithModel:(SubjectModel *)model;
@end
