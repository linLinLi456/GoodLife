//
//  UserTableViewCell.m
//  GoodLife
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "UserTableViewCell.h"

@implementation UserTableViewCell

- (void)awakeFromNib {
    // Initialization code
}
-(void)showDataWithModel:(UserModel *)model {
   
    self.imageView.layer.masksToBounds = YES;
    self.imageView.layer.cornerRadius = 20;
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UIImage * originImage = image;
        if (originImage.size.width != 40) {
            originImage = [self OriginImage:originImage scaleToSize:CGSizeMake(40, 40)];
        }
        [self.imageView setImage:originImage];
    }];
    self.userName.text = model.username;
}
//将不适合的图片设置成想要尺寸的图片
-(UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (IBAction)userBtnClick:(UIButton *)sender {
}
@end
