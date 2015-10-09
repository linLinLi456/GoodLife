//
//  MGSpotyViewController.h
//  MGSpotyView
//
//  Created by Matteo Gobbi on 25/06/2014.
//  Copyright (c) 2014 Matteo Gobbi. All rights reserved.
//

#import <UIKit/UIKit.h>

extern CGFloat const kMGOffsetEffects;

@interface MGSpotyViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *TableView;
@property (nonatomic, strong) UIView *overView;
@property (nonatomic, strong) UIImageView *mainImageView;

- (instancetype)initWithMainImage:(UIImage *)image;

@end
