//
//  CategoryViewController.m
//  GoodLife
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "CategoryViewController.h"
#import "CategoryTableViewCell.h"
#import "SubModel.h"
#import "WMPageController.h"
#import "MyTableViewController.h"
#import "SearchViewController.h"

@interface CategoryViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *_tableView;
    AFHTTPRequestOperationManager *_manager;
}
@property (nonatomic, strong)AFHTTPRequestOperationManager *manager;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) NSMutableArray *data;
@property (nonatomic,strong) NSMutableArray *titles;
@property (nonatomic,strong) NSMutableArray *categoryIdArr;
@property (nonatomic,strong) NSString *titleName;

@end

@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.dataArr = [[NSMutableArray alloc] init];
    [self createAFHttpRequest];
    [self createTableView];
    [self getNetData];
    
}

//创建上导航左侧按钮(以view作模板)
- (void)createNavigationLeftButton:(id)view {
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.leftBarButtonItem = leftItem;
}
//创建上导航右侧按钮(以view作模板)
- (void)createNavigationRightButton:(id)view {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    self.navigationItem.rightBarButtonItem = rightItem;
}

- (void)createAFHttpRequest {
    self.manager = [AFHTTPRequestOperationManager manager];
    //返回二进制不解析
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-100) style:UITableViewStylePlain];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
}
-(void)getNetData {
    __weak typeof(self)weakSelf = self;
    [weakSelf.manager GET:kSubcategoriesUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            SubModel *model = [[SubModel alloc] initWithData:responseObject error:nil];
            NSArray *ary = model.subcategories;
            for (CategoryModel *model in ary) {
                [weakSelf.dataArr addObject:model];
            }
        }
        [weakSelf.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"category";
    CategoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"CategoryTableViewCell" owner:nil options:nil] lastObject];
    }
    CategoryModel *model = self.dataArr[indexPath.row];
    
    [cell showDataWithModel:model];
    cell.block = ^(NSString *_id,CategoryModel *model){
        self.categoryIdArr = [[NSMutableArray alloc] init];
        [self.categoryIdArr addObject:model._id];
        NSString *url = [NSString stringWithFormat:kHeaderUrl,model._id];
        [self getTopNetDataWithUrl:url];
        self.titleName = model.name;
    };
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 122;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
-(void)getTopNetDataWithUrl:(NSString *)url {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    self.data = [[NSMutableArray alloc] init];
    __weak typeof(self) weakSelf = self;
    [manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict =[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *subArr = dict[@"subcategories"];
        for (NSDictionary *dict in subArr) {
            SubcategoriesModel *model = [[SubcategoriesModel alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [weakSelf.data addObject:model];
        }
        [self createScrollView];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)createScrollView {
    self.titles = [[NSMutableArray alloc] init];
    
    [self.titles addObject:@"全部"];
    for (NSInteger i = 0 ; i<self.data.count; i++) {
        SubcategoriesModel *model = self.data[i];
        [self.titles addObject:model.name];
        [self.categoryIdArr addObject:model._id];
    }
    WMPageController *pageController = [self createController];
    pageController.navTitle = self.titleName;
    [self.navigationController pushViewController:pageController animated:YES];
}
-(WMPageController *)createController {
    NSMutableArray *viewControllers = [[NSMutableArray alloc] init];
    NSMutableArray *titles = [[NSMutableArray alloc] init];
    for (int i = 0; i<self.titles.count; i++) {
        Class vcClass = [MyTableViewController class];
        NSString *title = self.titles[i];
        [viewControllers addObject:vcClass];
        [titles addObject:title];
    }
    WMPageController *pageVC = [[WMPageController alloc] initWithViewControllerClasses:viewControllers andTheirTitles:titles withIds:self.categoryIdArr];
    pageVC.pageAnimatable = YES;
    pageVC.menuItemWidth = 85;
    pageVC.postNotification = YES;
    return pageVC;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
