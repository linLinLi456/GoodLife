//
//  UserTableViewCell.h
//  GoodLife
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserModel.h"
@interface UserTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *userIcon;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UIButton *userBtn;
- (IBAction)userBtnClick:(UIButton *)sender;
-(void)showDataWithModel:(UserModel *)model;
@end
