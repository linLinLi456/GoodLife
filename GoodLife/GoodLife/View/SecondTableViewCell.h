//
//  SecondTableViewCell.h
//  GoodLife
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SecondTableViewCell;

@protocol FirstCellDelegate <NSObject>

-(void)secondTableViewCell:(SecondTableViewCell *)firstCell didSelectWithItem:(id)item;

@end

@protocol SecondCellDelegate <NSObject>

-(void)secondCell:(SecondTableViewCell *)secondCell didSelectWithItem:(id)item;

@end

@interface SecondTableViewCell : UITableViewCell<UICollectionViewDataSource,UICollectionViewDelegate>
{
    NSArray *_dataArr;
}
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@property (nonatomic) NSArray *dataArr;

@property (nonatomic,assign) id<FirstCellDelegate> firstDelegate;

@property (nonatomic,assign) id<SecondCellDelegate> secondDelegate;

-(void)setDataArr:(NSArray *)dataArr;

//-(void)showDataWithAry:(NSArray *)ary;

@end
