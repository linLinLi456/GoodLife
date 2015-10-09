//
//  MyTableViewController.m
//  GoodLife
//
//  Created by qianfeng on 15/10/3.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "MyTableViewController.h"
#import "ThirdTableViewCell.h"
#import "WMPageController.h"
#import "CourceVideoViewController.h"

@interface MyTableViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
//    AFHTTPRequestOperationManager *_manager;
}
//@property (nonatomic, strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic) NSInteger page;
//@property (nonatomic)        BOOL  isRefreshing;
//@property (nonatomic)        BOOL isLoadMore;


@end

@implementation MyTableViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    static NSString *const WMControllerDidFullyDisplayedNotification = @"WMControllerDidFullyDisplayedNotification";
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getId:) name:WMControllerDidFullyDisplayedNotification object:nil];
    self.dataArr = [[NSMutableArray alloc] init];
    self.navigationController.navigationBarHidden = YES;
    [self createTableView];
}

-(void)getId:(NSNotification *)info {
    self.pid = info.userInfo[@"id"];
    [self.dataArr removeAllObjects];
    [self firstDownload];
    [self createRefreshView];
}
-(void)firstDownload {
    self.isRefreshing = NO;
    self.isLoadMore = NO;
    self.page = 1;
    NSString *url = [NSString stringWithFormat:kCourseUrl,self.pid,20*(self.page-1),20*self.page];
    [self addTaskWithUrl:url isRefresh:NO];
}
-(void)resetParame {
    self.page = 1;
}
-(void)createRefreshView {
    __weak typeof(self) weakSelf = self;
    [weakSelf.tableView addRefreshHeaderViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        weakSelf.isRefreshing = YES;
        [weakSelf resetParame];
        NSString *url = [NSString stringWithFormat:kCourseUrl,weakSelf.pid,20*(weakSelf.page-1),20*weakSelf.page];
        
        [weakSelf addTaskWithUrl:url isRefresh:YES];
    }];
    [weakSelf.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isLoadMore) {
            return;
        }
        weakSelf.isLoadMore = YES;
        weakSelf.page ++;
        NSString *url = [NSString stringWithFormat:kCourseUrl,weakSelf.pid,20*(weakSelf.page-1),20*weakSelf.page];
        [weakSelf addTaskWithUrl:url isRefresh:YES];
    }];
}
-(void)endRefreshing {
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [_tableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if (self.isLoadMore) {
        self.isLoadMore = NO;
        [_tableView footerEndRefreshing];
    }
    
}
-(void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.width, self.view.height-150) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}

-(void)addTaskWithUrl:(NSString *)url isRefresh:(BOOL)isRefresh {
    __weak typeof(self) weakSelf = self;
    
    BOOL isExit = [[NSFileManager defaultManager] fileExistsAtPath:[LZXHelper getFullPathWithFile:url]];
    BOOL isTimeOut = [LZXHelper isTimeOutWithFile:[LZXHelper getFullPathWithFile:url] timeOut:60*60];
    if ((isExit == YES) && (isTimeOut == NO) && (isRefresh == NO)) {
        NSData *data = [NSData dataWithContentsOfFile:[LZXHelper getFullPathWithFile:url]];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
        NSArray *ary = dict[@"courses"];
        for (NSDictionary *dict in ary) {
            Cources *model = [[Cources alloc] init];
            model._id = dict[@"_id"];
            model.title = dict[@"title"];
            model.iconUrl = dict[@"iconUrl"];
            model.price = [dict[@"price"] integerValue];
            model.providerId = dict[@"providerId"];
            model.providerName = dict[@"providerName"];
            [self.dataArr addObject:model];
        }
        [self.tableView reloadData];
        return;
    }
    
    [weakSelf.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (self.page == 1) {
                [weakSelf.dataArr removeAllObjects];
                [[NSFileManager defaultManager] createFileAtPath:[LZXHelper getFullPathWithFile:url] contents:responseObject attributes:nil];
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *cources = dict[@"courses"];
            for (NSDictionary *dict in cources) {
                Cources *model = [[Cources alloc] init];
                model._id = dict[@"_id"];
                model.title = dict[@"title"];
                model.iconUrl = dict[@"iconUrl"];
                model.price = [dict[@"price"] integerValue];
                model.providerId = dict[@"providerId"];
                model.providerName = dict[@"providerName"];
                [weakSelf.dataArr addObject:model];
            }
            [weakSelf.tableView reloadData];
            [weakSelf endRefreshing];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"third";
    ThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ThirdTableViewCell" owner:nil options:nil] lastObject];
    }
    Cources *model = self.dataArr[indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CourceVideoViewController *cource = [[CourceVideoViewController alloc] init];
     Cources *model = self.dataArr[indexPath.row];
    cource.model = model;
    [self.navigationController pushViewController:cource animated:YES];
}

@end
