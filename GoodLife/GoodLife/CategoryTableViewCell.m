//
//  CategoryTableViewCell.m
//  GoodLife
//
//  Created by qianfeng on 15/9/29.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "CategoryTableViewCell.h"
#import "SubcategoriesModel.h"

@implementation CategoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)showDataWithModel:(CategoryModel *)model {
    self.model = model;
    self.categoryName.text = model.name;
    self.subcategories = model.subcategories;
    self.pid = model._id;
    NSMutableArray *ary = [[NSMutableArray alloc] init];
    for (SubcategoriesModel *model in self.subcategories) {
        [ary addObject:model];
    }
    SubcategoriesModel *model1 = ary[0];
    [self.firstBtn sd_setImageWithURL:[NSURL URLWithString:model1.iconUrl] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UIImage * originImage = [image  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.firstBtn setImage:originImage forState:UIControlStateNormal];
    }];
    self.firstName.text = model1.name;
    self.firstId = model1._id;
    
    model1 = ary[1];
    [self.secondBtn sd_setImageWithURL:[NSURL URLWithString:model1.iconUrl] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UIImage * originImage = [image  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.secondBtn setImage:originImage forState:UIControlStateNormal];
    }];
    self.secondName.text = model1.name;
    self.secondId = model1._id;
    
    model1 = ary[2];
    [self.thirdBtn sd_setImageWithURL:[NSURL URLWithString:model1.iconUrl] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UIImage * originImage = [image  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.thirdBtn setImage:originImage forState:UIControlStateNormal];
    }];
    self.thirdName.text = model1.name;
    self.thirdId = model1._id;
    
    model1 = ary[3];
    [self.fourBtn sd_setImageWithURL:[NSURL URLWithString:model1.iconUrl] forState:UIControlStateNormal completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UIImage * originImage = [image  imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        [self.fourBtn setImage:originImage forState:UIControlStateNormal];
    }];
    self.fourName.text = model1.name;
    self.fourId = model1._id;
    
}
- (IBAction)MoreClick:(UIButton *)sender {
    NSLog(@"%@",self.pid);
    self.block(self.pid,self.model);
}

- (IBAction)firstBtn:(UIButton *)sender {
    NSLog(@"%@",self.firstId);
    self.block(self.firstId,self.model);
}

- (IBAction)SecondBtn:(UIButton *)sender {
    NSLog(@"%@",self.secondId);
    self.block(self.secondId,self.model);
}

- (IBAction)ThirdBtn:(UIButton *)sender {
    self.block(self.thirdId,self.model);
}

- (IBAction)FourBtn:(UIButton *)sender {
    self.block(self.fourId,self.model);
}
@end
