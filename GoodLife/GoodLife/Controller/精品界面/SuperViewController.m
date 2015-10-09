//
//  SuperViewController.m
//  GoodLife
//
//  Created by qianfeng on 15/10/7.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "SuperViewController.h"
#import "SuperModel.h"
#import "UIImageView+LBBlurredImage.h"

@interface SuperViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UIImageView *bigImage;
    UIView *view;
}
@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) UITableView *tableView;
- (IBAction)chatBtnClick:(UIButton *)sender;

- (IBAction)guanzhuBtnClick:(UIButton *)sender;


@end

@implementation SuperViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    self.dataArr = [[NSMutableArray alloc] init];
    [self createTableView];
    [self createAFHttpRequest];
    [self getNetData];

}
-(void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height-100) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
    self.tableView.contentInset = UIEdgeInsetsMake(300, 0, 0, 0);
    [self.view addSubview:self.tableView];
}
- (void)createAFHttpRequest {
    self.manager = [AFHTTPRequestOperationManager manager];
    //返回二进制不解析
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}

-(void)getNetData {
    NSString *url = [NSString stringWithFormat:kUserInfo,self.pid];
    NSLog(@"url:%@",url);
    __weak typeof(self)weakSelf = self;
    [weakSelf.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            SuperModel *model = [[SuperModel alloc] initWithData:responseObject error:nil];
            NSLog(@"model:%@",model);
            [self.dataArr addObject:model];
            [self myOverView];
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)myOverView {
    view = [[UIView alloc] initWithFrame:CGRectMake(0, -300, self.view.width, 300)];
    view.backgroundColor = [UIColor clearColor];
    
    bigImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, -300, self.view.width, 300)];
    SuperModel *model = [self.dataArr lastObject];
    [bigImage sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl] placeholderImage:[UIImage imageNamed: @"beijing"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        [bigImage setImageToBlur:image completionBlock:^{
            
        }];
    }];
    [self.tableView addSubview:bigImage];
    
    
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width-100)/2, 50, 100, 100)];
    [imageView setContentMode:UIViewContentModeScaleToFill];
    [imageView setClipsToBounds:YES];
    [imageView sd_setImageWithURL:[NSURL URLWithString:model.avatarUrl]];
    [imageView.layer setBorderColor:[UIColor whiteColor].CGColor];
    [imageView.layer setBorderWidth:2.0];
    [imageView.layer setCornerRadius:imageView.frame.size.width/2.0];
    UILabel *labelTitle = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x-10,155, 120, 20)];
    labelTitle.text = model.username;
    [labelTitle setTextAlignment:NSTextAlignmentCenter];
    labelTitle.textColor = [UIColor whiteColor];
    labelTitle.font = [UIFont systemFontOfSize:16.f];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(view.center.x-120, 180, 240, 20)];
    label.text = [NSString stringWithFormat:@"关注 %ld | 粉丝 %ld",model.enrolledNo.integerValue,model.fans_amount.integerValue];
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont systemFontOfSize:14.f];
    [view addSubview:imageView];
    [view addSubview:labelTitle];
    [view addSubview:label];
    [self.tableView addSubview:view];
}
-(BOOL)prefersStatusBarHidden {
    return YES;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"Identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:identifier];
    }
    if (indexPath.row == 0) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 40, 40)];
        imageView.image = [UIImage imageNamed: @"地区"];
        [cell.contentView addSubview:imageView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 100, 40)];
        label.text = @"地区";
        [cell.contentView addSubview:label];
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(300, 5, 65, 40)];
        detail.text = @"未填写";
        detail.textColor = [UIColor grayColor];
        detail.textAlignment = NSTextAlignmentRight;
        detail.font = [UIFont systemFontOfSize:14.f];
        [cell.contentView addSubview:detail];
    } else if (indexPath.row == 1) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        imageView.image = [UIImage imageNamed: @"年龄"];
        [cell.contentView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 100, 40)];
        label.text = @"年龄";
        [cell.contentView addSubview:label];
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(300, 5, 65, 40)];
        detail.text = @"未填写";
        detail.textColor = [UIColor grayColor];
        detail.textAlignment = NSTextAlignmentRight;
        detail.font = [UIFont systemFontOfSize:14.f];
        [cell.contentView addSubview:detail];
        
    } else if (indexPath.row == 2) {
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 5, 100, 20)];
        label.text = @"个人介绍";
        [cell.contentView addSubview:label];
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(50, 25, 300, 100)];
        SuperModel *model = [self.dataArr lastObject];
        detail.text = model.signature;
        detail.numberOfLines = 0;
        detail.textColor = [UIColor grayColor];
        detail.textAlignment = NSTextAlignmentLeft;
        detail.font = [UIFont systemFontOfSize:14.f];
        [cell.contentView addSubview:detail];
        
        cell.detailTextLabel.textColor = [UIColor grayColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        imageView.image = [UIImage imageNamed: @"个人介绍"];
        [cell.contentView addSubview:imageView];
    } else {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        imageView.image = [UIImage imageNamed: @"发布"];
        [cell.contentView addSubview:imageView];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(50, 10, 100, 20)];
        label.text = @"他发布的";
        [cell.contentView addSubview:label];
        SuperModel *model = [self.dataArr lastObject];
        UILabel *detail = [[UILabel alloc] initWithFrame:CGRectMake(300, 5, 35, 30)];
        detail.text = [NSString stringWithFormat:@"%ld",model.publishedNo.integerValue];
        detail.textColor = [UIColor grayColor];
        detail.textAlignment = NSTextAlignmentRight;
        detail.font = [UIFont systemFontOfSize:14.f];
        [cell.contentView addSubview:detail];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 2) {
        return 120;
    } else {
        return 40;
    }
}
-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat yOffset  = scrollView.contentOffset.y;
    CGFloat xOffset = (yOffset + 300)/2;
    
    if (yOffset < -300) {
        
        CGRect rect = bigImage.frame;
        rect.origin.y = yOffset;
        rect.size.height =  -yOffset ;
        rect.origin.x = xOffset;
        rect.size.width = self.view.width + fabs(xOffset)*2;
        
        bigImage.frame = rect;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)chatBtnClick:(UIButton *)sender {
}

- (IBAction)guanzhuBtnClick:(UIButton *)sender {
}
@end
