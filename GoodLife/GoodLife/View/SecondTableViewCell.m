//
//  SecondTableViewCell.m
//  GoodLife
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "SecondTableViewCell.h"
#import "TopicsModel.h"
#import "SubjectViewController.h"
#import "SuperViewController.h"



@implementation SecondTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cellId"];
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;
    self.collectionView.backgroundColor = [UIColor whiteColor];
}
-(void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
    NSLog(@"%ld",_dataArr.count);
    [self.collectionView reloadData];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [self.collectionView dequeueReusableCellWithReuseIdentifier:@"cellId" forIndexPath:indexPath];
    TopicsModel *model = [self.dataArr objectAtIndex:indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 187, 80)];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.imageUrl]];
    [cell.contentView addSubview:imageView];
    return cell;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        TopicsModel *model = self.dataArr[indexPath.row];
        if (self.firstDelegate && [self.firstDelegate respondsToSelector:@selector(secondTableViewCell:didSelectWithItem:)]) {
            [self.firstDelegate secondTableViewCell:self didSelectWithItem:model];
        }
    } else {
        TopicsModel *model = self.dataArr[indexPath.row];
        if (self.secondDelegate && [self.secondDelegate respondsToSelector:@selector(secondCell:didSelectWithItem:)]) {
            [self.secondDelegate secondCell:self didSelectWithItem:model];
        }
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
