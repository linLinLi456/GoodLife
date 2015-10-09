//
//  ApplicationViewController.m
//  GoodLife
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "ApplicationViewController.h"

@interface ApplicationViewController ()

@end

@implementation ApplicationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self createAFHttpRequest];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
- (void)createAFHttpRequest {
    self.manager = [AFHTTPRequestOperationManager manager];
    //返回二进制不解析
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}
-(void)leftClick:(UIButton *)button {
    
}
-(void)rightClick:(UIButton *)button {
    
}
- (void)addTaskWithUrl:(NSString *)url isRefresh:(BOOL)isRefresh {
    
}
- (void)firstDownload {
    
}
-(void)createRefreshView {
    
}
-(void)endRefreshing {
    
}
-(void)resetParame {
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
