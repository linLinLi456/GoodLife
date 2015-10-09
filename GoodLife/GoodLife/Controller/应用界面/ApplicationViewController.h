//
//  ApplicationViewController.h
//  GoodLife
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "BaseViewController.h"

#import "AFNetworking.h"

@interface ApplicationViewController : BaseViewController
{
    NSInteger _currentPage;
    BOOL _isRefreshing;
    BOOL _isLoadMore;
    
    AFHTTPRequestOperationManager *_manager;
    
}
@property (nonatomic)        BOOL  isRefreshing;
@property (nonatomic)        BOOL isLoadMore;

@property (nonatomic, strong)AFHTTPRequestOperationManager *manager;

@property (nonatomic, copy) NSString *requestUrl;
@property (nonatomic, copy) NSString *categoryType;

@property (nonatomic, copy) NSString *categoryId;//分类id

#pragma mark - 下面的方法 如果满足不了子类 可以重写
//左右按钮事件函数
- (void)leftClick:(UIButton *)button ;
- (void)rightClick:(UIButton *)button;
//增加任务
- (void)addTaskWithUrl:(NSString *)url isRefresh:(BOOL)isRefresh;
//第一次下载
- (void)firstDownload;
//创建 刷新视图
- (void)createRefreshView ;
//结束刷新
- (void)endRefreshing;

-(void)resetParame;
@end






























