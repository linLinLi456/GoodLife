//
//  SubjectTableViewCell.m
//  GoodLife
//
//  Created by qianfeng on 15/10/5.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "SubjectTableViewCell.h"

@implementation SubjectTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)showDataWithModel:(SubjectModel *)model {
    [self.ImageView sd_setImageWithURL:[NSURL URLWithString:model.bannerUrl]];
    self.titleLabel.text = model.description;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
