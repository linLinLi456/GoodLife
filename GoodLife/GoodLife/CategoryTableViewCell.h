//
//  CategoryTableViewCell.h
//  GoodLife
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CategoryModel.h"

typedef void(^Myblock)(NSString *_id,CategoryModel *model);

@interface CategoryTableViewCell : UITableViewCell

@property (nonatomic,strong) CategoryModel *model;

@property (nonatomic,copy) Myblock block;

@property (nonatomic,copy) NSString *pid;

@property (nonatomic,copy) NSString *firstId;

@property (nonatomic,copy) NSString *secondId;

@property (nonatomic,copy) NSString *thirdId;

@property (nonatomic,copy) NSString *fourId;

@property (weak, nonatomic) IBOutlet UILabel *categoryName;

@property (weak, nonatomic) IBOutlet UIButton *firstBtn;
@property (weak, nonatomic) IBOutlet UIButton *secondBtn;

@property (weak, nonatomic) IBOutlet UIButton *thirdBtn;
@property (weak, nonatomic) IBOutlet UIButton *fourBtn;


@property (weak, nonatomic) IBOutlet UILabel *firstName;
@property (weak, nonatomic) IBOutlet UILabel *secondName;
@property (weak, nonatomic) IBOutlet UILabel *thirdName;
@property (weak, nonatomic) IBOutlet UILabel *fourName;
@property (nonatomic,strong) NSArray *subcategories;

- (IBAction)MoreClick:(UIButton *)sender;
- (IBAction)firstBtn:(UIButton *)sender;
- (IBAction)SecondBtn:(UIButton *)sender;
- (IBAction)ThirdBtn:(UIButton *)sender;
- (IBAction)FourBtn:(UIButton *)sender;

-(void)showDataWithModel:(CategoryModel *)model;

@end
