//
//  MyHelper.h
//  UIControlDemo
//
//  Created by Hailong.wang on 15/8/3.
//  Copyright (c) 2015年 Hailong.wang. All rights reserved.
//

#ifndef UIControlDemo_MyHelper_h
#define UIControlDemo_MyHelper_h


#import "UIView+Addition.h"
#import "Factory.h"
#import "MyAddView.h"

//44是一个特殊的常量，默认行高和NavigationBar的高度为44
#define Default 44
//距离左边边距为10
#define LeftDistance 10
//控件间的距离
#define ControlDistance 20
//屏幕宽度
#define ScreenWidth [UIScreen mainScreen].bounds.size.width
//屏幕高度
#define ScreenHeight [UIScreen mainScreen].bounds.size.height

//安全释放宏
#define Release_Safe(_control) [_control release], _control = nil;
//传入RGBA四个参数，得到颜色
//美工和设计通过PS给出的色值是0~255
//苹果的RGB参数给出的是0~1
//那我们就让美工给出的 参数/255 得到一个0-1之间的数
#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//传入RGB三个参数，得到颜色
#define RGB(r,g,b) RGBA(r,g,b,1.f)
//取得随机颜色
#define RandomColor RGB(arc4random()%256,arc4random()%256,arc4random()%256)
#define kIsOpen @"isOpen"//是否打开过
#pragma mark - SystemColor
#define BlackColor [UIColor blackColor]
#define WhiteColor [UIColor whiteColor]
#define RedColor [UIColor redColor]
#define BlueColor [UIColor blueColor]
#define OrangeColor [UIColor orangeColor]
#define LightGrayColor [UIColor lightGrayColor]
#define LightTextColor [UIColor lightTextColor]

#endif





