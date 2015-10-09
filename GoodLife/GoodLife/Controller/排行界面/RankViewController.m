//
//  RankViewController.m
//  GoodLife
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "RankViewController.h"
#import "ObjModel.h"
#import "ThirdTableViewCell.h"
#import "Cources.h"
#import "MoreViewController.h"
#import "CourceVideoViewController.h"
#import "SearchViewController.h"

@interface RankViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
}
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *data;

@end

@implementation RankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    self.dataArr = [[NSMutableArray alloc] init];
    self.data = [[NSMutableArray alloc] init];
    [self getNetData];
    [self createTableView];
   
}
-(void)getNetData {
    __weak typeof(self) weakSelf = self;
    [weakSelf.manager GET:kRankUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
           
            ObjModel *model = [[ObjModel alloc] initWithData:responseObject error:nil];
            NSArray *ranks = model.ranks;
            for (RanksModel *rank in ranks) {
                NSMutableArray *ary = [[NSMutableArray alloc] init];
                [weakSelf.data addObject:rank];
                NSArray *cources = rank.courses;
                for (Cources *cource in cources) {
                    [ary addObject:cource];
                }
                [weakSelf.dataArr addObject:ary];
            }
        }
        [weakSelf.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-100) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return self.dataArr.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.dataArr objectAtIndex:section] count];
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"third";
    ThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ThirdTableViewCell" owner:nil options:nil] lastObject];
    }
    Cources *model = self.dataArr[indexPath.section][indexPath.row];
    [cell showDataWithModel:model];
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    RanksModel *model = self.data[section];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 20)];
    label.text = model.title;
    label.font = [UIFont systemFontOfSize:14.f];
    label.textColor = [UIColor grayColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    view.backgroundColor = [UIColor whiteColor];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 30)];
    button.tag = 201+section;
    [button addTarget:self action:@selector(toMore:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [button setImage:[UIImage imageNamed: @"sidebar_cell_access"] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:14.f];
    UILabel *MoreLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-80, 5, 60, 20)];
    MoreLabel.text = @"更多";
    MoreLabel.textColor = [UIColor grayColor];
    MoreLabel.font = [UIFont systemFontOfSize:14.f];
    MoreLabel.textAlignment = NSTextAlignmentRight;
    [button addSubview:MoreLabel];
    
    [view addSubview:button];
    [view addSubview:label];
    return view;
}
-(void)toMore:(UIButton *)button {
    RanksModel *model = self.data[button.tag-201];
    MoreViewController *more = [[MoreViewController alloc] init];
    more.pid = model._id;
    more.navTitle = model.title;
    [self.navigationController pushViewController:more animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 30;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CourceVideoViewController *cource = [[CourceVideoViewController alloc] init];
    Cources *model = self.dataArr[indexPath.section][indexPath.row];
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
