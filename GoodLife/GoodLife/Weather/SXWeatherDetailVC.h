//
//  SXWeatherDetailVC.h
//  GoodLife
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SXWeatherModel;

@interface SXWeatherDetailVC : UIViewController

@property(nonatomic,strong)SXWeatherModel *weatherModel;
@property (weak, nonatomic) IBOutlet UIImageView *bgImg;
@end
