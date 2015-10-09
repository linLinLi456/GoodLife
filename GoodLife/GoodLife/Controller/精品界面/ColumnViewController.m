//
//  ColumnViewController.m
//  GoodLife
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "ColumnViewController.h"
#import "BannersModel.h"
#import "ItemsModel.h"
#import "Cources.h"
#import "TopicsModel.h"
#import "MarksModel.h"
#import "MyAddView.h"
#import "SecondTableViewCell.h"
#import "ThirdTableViewCell.h"
#import "Cources.h"
#import "MarksModel.h"
#import "TopicsModel.h"
#import "BigModel.h"
#import "MoreColumnViewController.h"
#import "CourceVideoViewController.h"
#import "SearchViewController.h"
#import "SubjectViewController.h"
#import "SuperViewController.h"

@interface ColumnViewController ()<UITableViewDataSource,UITableViewDelegate,SecondCellDelegate,FirstCellDelegate>
{
    NSMutableArray *_dataArr;
    UITableView *_tableView;
}
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) NSMutableArray *ImageArr;
@property (nonatomic,strong) NSMutableArray *topicsArr;
@property (nonatomic,strong) NSMutableArray *first;
@property (nonatomic,strong) NSMutableArray *second;
@property (nonatomic,strong) NSMutableArray *third;
@property (nonatomic,strong) NSMutableArray *four;

@end

@implementation ColumnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initData];
    // Do any additional setup after loading the view.
    [self addTaskWithUrl:kBoutiqueUrl isRefresh:NO];
    [self createTableView];
}

-(void)initData {
    self.dataArr = [[NSMutableArray alloc] init];
    self.data = [[NSMutableArray alloc] init];
    self.ImageArr = [[NSMutableArray alloc] init];
    self.topicsArr = [[NSMutableArray alloc] init];
    self.first = [[NSMutableArray alloc] init];
    self.second = [[NSMutableArray alloc] init];
    self.third = [[NSMutableArray alloc] init];
}
-(void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-100) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
-(void)addTaskWithUrl:(NSString *)url isRefresh:(BOOL)isRefresh {
    __weak typeof(self) weakSelf = self;
    [weakSelf.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            BigModel *model = [[BigModel alloc]initWithData:responseObject error:nil];
            NSArray *items = model.items;
            for (ItemsModel *model in items) {
                [weakSelf.dataArr addObject:model];
            }
            
            ItemsModel *itemModel = weakSelf.dataArr[0];
            NSArray *banners = itemModel.banners;
            NSMutableArray *ary = [[NSMutableArray alloc] init];
            for (BannersModel *model in banners) {
                [weakSelf.ImageArr addObject:model.imageUrl];
                [ary addObject:model];
            }
            [weakSelf.first addObject:ary];
            
            [weakSelf.data addObject:weakSelf.first];
            
            itemModel = weakSelf.dataArr[1];
            NSMutableArray *ary3 = [[NSMutableArray alloc] init];
            NSArray *topics = itemModel.topics;
            for (TopicsModel *model in topics) {
                [weakSelf.topicsArr addObject:model];
                [ary3 addObject:model];
            }
            [weakSelf.second addObject:ary3];
            [ary removeAllObjects];
            [weakSelf.data addObject:weakSelf.second];
            
            
            for (NSInteger i = 2; i<weakSelf.dataArr.count; i++) {
                NSMutableArray *array = [[NSMutableArray alloc] init];
                itemModel = weakSelf.dataArr[i];
                NSArray *courses = itemModel.courses;
                for (Cources *model in courses) {
                    [array addObject:model];
                }
                if (itemModel.topics) {
                    NSMutableArray *ary1 = [[NSMutableArray alloc] init];
                    NSArray *topics = itemModel.topics;
                    for (TopicsModel *model in topics) {
                        [ary1 addObject:model];
                    }
                    [array addObject:ary1];
                }
                [weakSelf.data addObject:array];
            }
        }
        [weakSelf.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data[section] count];
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        static NSString *first = @"Identifer";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:first];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:first];
        }
        MyAddView *view = [MyAddView adScrollViewWithFrame:CGRectMake(0, 0, ScreenWidth, 160) imageLinkURL:self.ImageArr pageControlShowStyle:UIPageControlShowStyleRight];
        [cell.contentView addSubview:view];
        return cell;
    } else if (indexPath.section == 1) {
        static NSString *second = @"second";
        SecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:second];
        if (!cell) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"SecondTableViewCell" owner:nil options:nil] lastObject];
        }
        cell.firstDelegate = self;
        cell.secondDelegate = self;
        cell.backgroundColor = [UIColor whiteColor];
        [cell setDataArr:self.topicsArr];
        return cell;
    } else {
        ItemsModel *items = self.dataArr[indexPath.section];
        if (items.topics) {
            if (indexPath.row < [self.data[indexPath.section] count]-1) {
                static NSString *third = @"third";
                ThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:third];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"ThirdTableViewCell" owner:nil options:nil] lastObject];
                }
                Cources *model = self.data[indexPath.section][indexPath.row];
                [cell showDataWithModel:model];
                return cell;
            } else {
                static NSString *second = @"second";
                SecondTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:second];
                if (!cell) {
                    cell = [[[NSBundle mainBundle] loadNibNamed:@"SecondTableViewCell" owner:nil options:nil] lastObject];
                }
                NSArray *ary = [self.data[indexPath.section] lastObject];
                cell.firstDelegate = self;
                cell.secondDelegate = self;
                cell.backgroundColor = [UIColor whiteColor];
                [cell setDataArr:ary];
                return cell;
            }
        } else {
            static NSString *third = @"third";
            ThirdTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:third];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"ThirdTableViewCell" owner:nil options:nil] lastObject];
            }
            Cources *model = self.data[indexPath.section][indexPath.row];
            [cell showDataWithModel:model];
            return cell;
        }
    }
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if ((section == 0)||(section == 1)) {
        return nil;
    } else {
        ItemsModel *model = self.dataArr[section];
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
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if ((section == 0)||(section == 1)) {
        return 0;
    } else {
        return 30;
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    CourceVideoViewController *cource = [[CourceVideoViewController alloc] init];
    Cources *model = self.data[indexPath.section][indexPath.row];
    cource.model = model;
    [self.navigationController pushViewController:cource animated:YES];
}
-(void)secondTableViewCell:(SecondTableViewCell *)firstCell didSelectWithItem:(id)item {
    TopicsModel *model = (TopicsModel *)item;
    SuperViewController *talent = [[SuperViewController alloc] init];
    talent.pid = model.userId;
    [self.navigationController pushViewController:talent animated:YES];
}
-(void)secondCell:(SecondTableViewCell *)secondCell didSelectWithItem:(id)item {
    TopicsModel *model = (TopicsModel *)item;
    SubjectViewController *subject = [[SubjectViewController alloc] init];
    subject.infoId = model._id;
    subject.navTitle = model.title;
    [self.navigationController pushViewController:subject animated:YES];
}

-(void)toMore:(UIButton *)button {
    ItemsModel *model = self.dataArr[button.tag-201];
    MoreColumnViewController *moreColumn = [[MoreColumnViewController alloc] init];
    moreColumn.pid = model.columnId;
    moreColumn.navTitle = model.title;
    [self.navigationController pushViewController:moreColumn animated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 160;
    } else if (indexPath.section == 1) {
        return 90;
    } else {
        return 100;
    }
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
