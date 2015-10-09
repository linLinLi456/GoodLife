//
//  MoreViewController.m
//  GoodLife
//
//  Created by qianfeng on 15/9/28.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "MoreViewController.h"
#import "ThirdTableViewCell.h"
#import "CourceVideoViewController.h"

@interface MoreViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic) NSInteger page;
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArr = [[NSMutableArray alloc] init];
   
    [self firstDownload];
    [self createTableView];
    [self createRefreshView];
}
-(void)firstDownload {
    self.isRefreshing = NO;
    self.isLoadMore = NO;
    self.page = 1;
    NSString *url = [NSString stringWithFormat:kRankMoreUrl,self.pid,20*(self.page-1),20*self.page];
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
        NSString *url = [NSString stringWithFormat:kRankMoreUrl,weakSelf.pid,20*(weakSelf.page-1),20*weakSelf.page];

            [weakSelf addTaskWithUrl:url isRefresh:YES];
    }];
    [weakSelf.tableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isLoadMore) {
            return;
        }
        weakSelf.isLoadMore = YES;
        weakSelf.page ++;
        NSLog(@"page:%ld",weakSelf.page);
        NSString *url = [NSString stringWithFormat:kRankMoreUrl,weakSelf.pid,20*(weakSelf.page-1),20*weakSelf.page];
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
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, self.view.width, self.view.height) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
-(void)addTaskWithUrl:(NSString *)url isRefresh:(BOOL)isRefresh {
    __weak typeof(self) weakSelf = self;
    [MMProgressHUD setPresentationStyle:MMProgressHUDPresentationStyleDrop];
    [MMProgressHUD showDeterminateProgressWithTitle:nil status:@"loading..."];
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
        [MMProgressHUD dismissWithSuccess:@"ok" title:@"数据下载完成"];
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
        [MMProgressHUD dismissWithSuccess:@"ok" title:@"数据下载完成"];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [MMProgressHUD dismissWithError:@"error" title:@"下载失败"];
    }];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
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
    return 100.f;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CourceVideoViewController *cource = [[CourceVideoViewController alloc] init];
    Cources *model = self.dataArr[indexPath.row];
    cource.model = model;
    [self.navigationController pushViewController:cource animated:YES];
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
