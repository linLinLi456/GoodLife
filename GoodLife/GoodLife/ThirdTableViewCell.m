//
//  ThirdTableViewCell.m
//  GoodLife
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "ThirdTableViewCell.h"
#import "Cources.h"
@implementation ThirdTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)showDataWithModel:(Cources *)model {
    [self.IconUrl sd_setImageWithURL:[NSURL URLWithString:model.iconUrl]];
    self.title.text = model.title;
    self.providerName.text = model.providerName;
    if (model.price == 0) {
        self.price.text = @"免费";
    } else {
        self.price.text = [NSString stringWithFormat:@"￥%.2f",model.price/100.0];
    }
}

//-(void)initDataWithModel:(RanksModel *)model {
//    for (NSInteger i = 0; i<model.courses.count; i++) {
//        Cources *courcesModel = model.courses[i];
//        [self.IconUrl sd_setImageWithURL:[NSURL URLWithString:courcesModel.iconUrl]];
//        self.title.text = courcesModel.title;
//        self.providerName.text = courcesModel.providerName;
//        if (courcesModel.price == 0) {
//            self.price.text = @"免费";
//        } else {
//            self.price.text = [NSString stringWithFormat:@"￥%.2f",courcesModel.price/100.0];
//        }
//    }
//}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
