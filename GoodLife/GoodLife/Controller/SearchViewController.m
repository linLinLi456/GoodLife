//
//  SearchViewController.m
//  GoodLife
//
//  Created by qianfeng on 15/10/4.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchModel.h"
#import "SearchResultViewController.h"

@interface SearchViewController ()<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>
{
    UITableView *_tableView;
    NSMutableArray *_data;
    AFHTTPRequestOperationManager *_manager;
    UISearchBar *_searchBar;
}
@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic,strong) NSArray *dataArr;

@property (nonatomic,strong) UITableView *tableView;

@property (nonatomic,strong) UISearchController *searchVC;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self createAFHttpRequest];
    [self createTableView];
    [self getNetData];
}
-(void)createAFHttpRequest {
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}
-(void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    _searchBar.delegate  =self;
    _searchBar.placeholder = @"搜索感兴趣的课程和用户";
    self.tableView.tableHeaderView = _searchBar;
    self.tableView.tableFooterView = [[UIView alloc] init];
}
-(void)getNetData {
    __weak typeof(self) weakSelf = self;
    [weakSelf.manager GET:kHotUrl parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            self.dataArr = [NSArray arrayWithArray:dict[@"data"]];
        }
        [weakSelf.tableView reloadData];
        NSLog(@"%ld",self.dataArr.count);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - UISearchBar
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}
-(BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    searchBar.text = @"";
    [searchBar resignFirstResponder];
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    NSString *text = searchBar.text;
    SearchResultViewController *result = [[SearchResultViewController alloc] init];
    result.name = text;
    [self.navigationController pushViewController:result animated:YES];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.textLabel.text = self.dataArr[indexPath.row];
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    SearchResultViewController *result = [[SearchResultViewController alloc] init];
    result.name = self.dataArr[indexPath.row];
    _searchBar.text = self.dataArr[indexPath.row];
    [self.navigationController pushViewController:result animated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.view.width, 44)];
    label.text = @"大家都在搜";
    label.textColor = [UIColor grayColor];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    [view addSubview:label];
    return view;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
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
