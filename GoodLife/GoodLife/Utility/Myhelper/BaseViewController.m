//
//  BaseViewController.m
//  UIViewController2
//
//  Created by Hailong.wang on 15/7/30.
//  Copyright (c) 2015年 Hailong.wang. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = WhiteColor;
    //添加视图
    [self createView];
    //初始化数据
    [self initData];
    //添加行为
    [self addTouchAction];
    [self setbackgroundColor];
    [self createNavagationBar];
     self.automaticallyAdjustsScrollViewInsets=NO;
}
//创建上导航按钮
-(void)createNavagationBar{
    UIButton *letbtn=[Factory createButtonWithTitle:nil frame:CGRectMake(0, 0,220, 25) target:self selector:@selector(didclicked:) ];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
    imageView.image = [UIImage imageNamed: @"back"];
//    imageView.userInteractionEnabled = YES;
    [letbtn addSubview:imageView];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, 180, 25)];
    label.text = self.navTitle;
    label.textAlignment = NSTextAlignmentLeft;
    label.textColor = [UIColor whiteColor];
    [letbtn addSubview:label];
    [letbtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [letbtn setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    letbtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
    [self createNavigationLeftButton:letbtn];
}
//左边菜单跳转
-(void)didclicked:(UIButton *)button{
    [self.navigationController popViewControllerAnimated:YES];
}
//右边按钮弹出下拉框
-(void)tochoose:(UIButton *)button{
    
}
//设置上导航背景图片
-(void)setbackgroundColor{
//    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed: @"HPBannerBottomMask"] forBarMetrics:UIBarMetricsDefault];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//创建视图
- (void)createView {
    //不做实现，只是为了使用方便
}
- (void)toNextView {
}
//初始化数据源
- (void)initData {
    //不做实现，只是为了使用方便
}
//添加事件
- (void)addTouchAction {
    //不做实现，只是为了使用方便
}
//创建上导航左侧按钮(以view作模板)
- (void)createNavigationLeftButton:(id)view {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = leftItem;
}
//创建上导航左侧按钮(系统标题)
- (void)createNavigationLeftButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    self.navigationItem.leftBarButtonItem = leftItem;
}
//创建上导航右侧按钮(以view作模板)
- (void)createNavigationRightButton:(id)view {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = rightItem;
}
//创建上导航右侧按钮(系统标题)
- (void)createNavigationRightButtonWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    self.navigationItem.rightBarButtonItem = rightItem;
}
- (void)backAction {
    [self.navigationController popViewControllerAnimated:YES];
}

@end





