//
//  SearchResultViewController.m
//  GoodLife
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "SearchResultViewController.h"
#import "Cources.h"
#import "ThirdTableViewCell.h"
#import "UserModel.h"
#import "UserTableViewCell.h"
#import "CourceVideoViewController.h"
#import "SuperViewController.h"

@interface SearchResultViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{
    AFHTTPRequestOperationManager *_manager;
}
@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;
@property (nonatomic) NSInteger page;
@property (nonatomic)        BOOL  isRefreshing;
@property (nonatomic)        BOOL isLoadMore;
@property (nonatomic)        BOOL isSelected;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) UITableView *rightTableView;
@property (nonatomic,strong) UITableView *leftTableView;
@property (nonatomic,strong) UILabel *label;
@property (nonatomic,strong) NSMutableArray *data;
@property (weak, nonatomic) IBOutlet UIButton *course;
@property (weak, nonatomic) IBOutlet UIButton *user;

@property (weak, nonatomic) IBOutlet UIScrollView *topScrollView;

- (IBAction)courseClick:(UIButton *)sender;
- (IBAction)userClick:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;

@end

@implementation SearchResultViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataArr = [[NSMutableArray alloc] init];
    self.data = [[NSMutableArray alloc] init];
    self.isSelected = NO;
    [self createTableViews];
    [self createAFHttpRequest];
    [self firstDownload];
    [self createRefreshView];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = NO;
}
-(void)createTableViews {
    self.label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.course.height, self.course.width, 2)];
    [self.course setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.user setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.label.backgroundColor = [UIColor redColor];
    self.topScrollView.showsHorizontalScrollIndicator = YES;
    self.topScrollView.contentSize = CGSizeMake(self.view.width, 0);
    [self.topScrollView addSubview:self.label];
    self.leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 623-64)];
    self.leftTableView.delegate = self;
    self.leftTableView.dataSource = self;
    self.leftTableView.tableFooterView = [[UIView alloc] init];
    [self.ScrollView addSubview:self.leftTableView];
    
    self.rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.view.width, 0, self.view.width, 623-64)];
    self.rightTableView.delegate = self;
    self.rightTableView.dataSource = self;
    self.rightTableView.tableFooterView = [[UIView alloc] init];
    self.ScrollView.delegate = self;
    self.ScrollView.showsVerticalScrollIndicator = NO;
    [self.ScrollView addSubview:self.rightTableView];
    self.ScrollView.contentSize = CGSizeMake(2*self.view.width, 0);
    self.ScrollView.bounces = NO;
    self.ScrollView.pagingEnabled = YES;
    
}
-(void)createAFHttpRequest {
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer  = [AFHTTPResponseSerializer serializer];
}
-(void)firstDownload {
    self.isRefreshing = NO;
    self.isLoadMore = NO;
    self.page = 1;
    NSString *str = [self.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *cource = [NSString stringWithFormat:kSearchCourceUrl,20*(self.page-1),20*self.page,str];
    [self addTaskWithUrl:cource isRefresh:NO];
    
    NSString *string = [self.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *user = [NSString stringWithFormat:kSearchUserUrl,20*(self.page-1),20*self.page,string];
    [self AddTaskWithUrl:user isRefresh:NO];
}
-(void)resetParame {
    self.page = 1;
}
-(void)createRefreshView {
    __weak typeof(self) weakSelf = self;
    [weakSelf.leftTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshAmazingAniView class] beginRefresh:^{
        weakSelf.isRefreshing = YES;
        [weakSelf resetParame];
        NSString *str = [weakSelf.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *url = [NSString stringWithFormat:kSearchCourceUrl,20*(weakSelf.page-1),20*weakSelf.page,str];
        [weakSelf addTaskWithUrl:url isRefresh:YES];
    }];
    [weakSelf.leftTableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isLoadMore) {
            return;
        }
        weakSelf.isLoadMore = YES;
        weakSelf.page ++;
        NSString *str = [weakSelf.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *url = [NSString stringWithFormat:kSearchCourceUrl,20*(weakSelf.page-1),20*weakSelf.page,str];
        [weakSelf addTaskWithUrl:url isRefresh:YES];
        
    }];
    [weakSelf.rightTableView addRefreshHeaderViewWithAniViewClass:[JHRefreshAmazingAniView class] beginRefresh:^{
        weakSelf.isRefreshing = YES;
        [weakSelf resetParame];
        NSString *string = [self.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *user = [NSString stringWithFormat:kSearchUserUrl,20*(self.page-1),20*self.page,string];
        [self AddTaskWithUrl:user isRefresh:YES];
        
    }];
    [weakSelf.rightTableView addRefreshFooterViewWithAniViewClass:[JHRefreshCommonAniView class] beginRefresh:^{
        if (weakSelf.isLoadMore) {
            return;
        }
        weakSelf.isLoadMore = YES;
        weakSelf.page ++;
        
        NSString *string = [self.name stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        NSString *user = [NSString stringWithFormat:kSearchUserUrl,20*(self.page-1),20*self.page,string];
        [self AddTaskWithUrl:user isRefresh:YES];
    }];
}
-(void)endRefreshing {
    if (self.isRefreshing) {
        self.isRefreshing = NO;
        [self.leftTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
        [self.rightTableView headerEndRefreshingWithResult:JHRefreshResultSuccess];
    }
    if (self.isLoadMore) {
        self.isLoadMore = NO;
        [self.leftTableView footerEndRefreshing];
        [self.rightTableView footerEndRefreshing];
    }
    
}

-(void)AddTaskWithUrl:(NSString *)url isRefresh:(BOOL)isRefresh {
    __weak typeof(self) weakSelf = self;
    
    BOOL isExit = [[NSFileManager defaultManager] fileExistsAtPath:[LZXHelper getFullPathWithFile:url]];
    BOOL isTimeOut = [LZXHelper isTimeOutWithFile:[LZXHelper getFullPathWithFile:url] timeOut:60*60];
    if ((isExit == YES) && (isTimeOut == NO) && (isRefresh == NO)) {
        NSData *data = [NSData dataWithContentsOfFile:[LZXHelper getFullPathWithFile:url]];
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
       
        NSArray *users = dict[@"users"];
        for (NSDictionary *dict in users) {
            UserModel *model = [[UserModel alloc] init];
            model._id = dict[@"_id"];
            model.username = dict[@"username"];
            model.avatarUrl = dict[@"avatarUrl"];
            [weakSelf.data addObject:model];
        }
        if (self.data.count == 0) {
            UIView *view = [[UIView alloc] init];
            view.frame = CGRectMake(0,200, self.view.width, 60);
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"没找到啊,好桑心>_<, 换个词试试?";
            label.textColor = [UIColor grayColor];
            [view addSubview:label];
            [weakSelf.rightTableView addSubview:view];
        }
        [weakSelf.rightTableView reloadData];
        return;
    }
    
    [weakSelf.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (self.page == 1) {
                [weakSelf.dataArr removeAllObjects];
                [weakSelf.data removeAllObjects];
                [[NSFileManager defaultManager] createFileAtPath:[LZXHelper getFullPathWithFile:url] contents:responseObject attributes:nil];
            }
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSArray *users = dict[@"users"];
            for (NSDictionary *dict in users) {
                UserModel *model = [[UserModel alloc] init];
                model._id = dict[@"_id"];
                model.username = dict[@"username"];
                model.avatarUrl = dict[@"avatarUrl"];
                [weakSelf.data addObject:model];
            }
            [weakSelf.rightTableView reloadData];
            [weakSelf endRefreshing];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
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
        if (self.dataArr.count == 0) {
            UIView *view = [[UIView alloc] init];
            view.frame = CGRectMake(0,200, self.view.width, 60);
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 60)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"没找到啊,好桑心>_<, 换个词试试?";
            label.textColor = [UIColor grayColor];
            [view addSubview:label];
            [weakSelf.leftTableView addSubview:view];
        }
        [weakSelf.leftTableView reloadData];
        return;
    }
    
    [weakSelf.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            if (self.page == 1) {
                [weakSelf.dataArr removeAllObjects];
                [weakSelf.data removeAllObjects];
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
            [weakSelf.leftTableView reloadData];
            [weakSelf endRefreshing];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTableView) {
        return self.dataArr.count;
    } else {
        return self.data.count;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        static NSString *identifier = @"third";
        ThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"ThirdTableViewCell" owner:nil options:nil] lastObject];
        }
        Cources *model = self.dataArr[indexPath.row];
        [cell showDataWithModel:model];
        return cell;
    } else {
        static NSString *identifier = @"user";
        UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"UserTableViewCell" owner:nil options:nil] lastObject];
        }
        UserModel *model = self.data[indexPath.row];
        [cell showDataWithModel:model];
        return cell;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.leftTableView) {
        CourceVideoViewController *cource = [[CourceVideoViewController alloc] init];
        Cources *model = self.dataArr[indexPath.row];
        cource.model = model;
        [self.navigationController pushViewController:cource animated:YES];
    } else {
        SuperViewController *sup = [[SuperViewController alloc] init];
        UserModel *model = self.data[indexPath.row];
        sup.pid = model._id;
        [self.navigationController pushViewController:sup animated:YES];
    }
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.leftTableView) {
        return 100;
    } else {
        return 77;
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (self.ScrollView.contentOffset.x == 0) {
        [self.user setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.course setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [UIView animateWithDuration:0 animations:^{
            self.label.frame = CGRectMake(0, self.course.height, self.course.width, 2);
        }];
    } else {
        [self.user setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
        [self.course setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.1 animations:^{
            self.label.frame = CGRectMake(self.course.width, self.user.height, self.user.width, 2);
        }];
    }
    
}
- (IBAction)courseClick:(UIButton *)sender {
    [self firstDownload];
    [self createRefreshView];
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.user setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.ScrollView setContentOffset:CGPointZero animated:YES];
    [UIView animateWithDuration:0.1 animations:^{
        self.label.frame = CGRectMake(0, self.course.height, self.course.width, 2);
    }];
}

- (IBAction)userClick:(UIButton *)sender {
    
    //    [self firstDownload];
    //    [self createRefreshView];
    [sender setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.course setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.ScrollView setContentOffset:CGPointMake(self.view.width, 0) animated:YES];
    [UIView animateWithDuration:0.1 animations:^{
        self.label.frame = CGRectMake(self.course.width, self.user.height, self.user.width, 2);
    }];
    
}
@end
