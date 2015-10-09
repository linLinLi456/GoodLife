//
//  WMPageController.m
//  WMPageController
//
//  Created by Mark on 15/6/11.
//  Copyright (c) 2015年 yq. All rights reserved.
//

#import "WMPageController.h"
#import "WMPageConst.h"
#import "SearchViewController.h"

#import "SXWeatherView.h"
#import "SXWeatherModel.h"
#import "UIView+Frame.h"
#import "SXHTTPManager.h"
#import "MJExtension.h"
#import "SXWeatherDetailM.h"
#import "SXWeatherDetailVC.h"
#import "SXWeatherBgM.h"
#import "LoginViewController.h"


@interface WMPageController () <WMMenuViewDelegate,UIScrollViewDelegate> {
    CGFloat viewHeight;
    CGFloat viewWidth;
    CGFloat targetX;
    BOOL    animate;
}

@property (nonatomic, strong, readwrite) UIViewController *currentViewController;

@property (nonatomic, weak) WMMenuView *menuView;

@property (nonatomic, weak) UIScrollView *scrollView;

// 用于记录子控制器view的frame，用于 scrollView 上的展示的位置
@property (nonatomic, strong) NSMutableArray *childViewFrames;

// 当前展示在屏幕上的控制器，方便在滚动的时候读取 (避免不必要计算)
@property (nonatomic, strong) NSMutableDictionary *displayVC;

// 用于记录销毁的viewController的位置 (如果它是某一种scrollView的Controller的话)
@property (nonatomic, strong) NSMutableDictionary *posRecords;

// 用于缓存加载过的控制器
@property (nonatomic, strong) NSCache *memCache;

// 收到内存警告的次数
@property (nonatomic, assign) int memoryWarningCount;

@property (nonatomic,strong) UIButton *letbtn;

@property(nonatomic,strong)SXWeatherModel *weatherModel;

@property(nonatomic,strong)SXWeatherView *weatherView;

@property(nonatomic,strong)UIImageView *tran;


@property(nonatomic,assign,getter=isWeatherShow)BOOL weatherShow;

@property (nonatomic,strong) NSLayoutConstraint *TopToTop;

@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;

@end

@implementation WMPageController

-(void)createNavagationBar {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showLeftBtn) name:@"SXAdvertisementKey" object:nil];
    
    UIButton *letbtn = [[UIButton alloc]init];
    self.letbtn = letbtn;
    UIWindow *win = [UIApplication sharedApplication].windows.firstObject;
    [win addSubview:letbtn];
    letbtn.y = 20;
    letbtn.width = 45;
    letbtn.height = 45;
    [letbtn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
    letbtn.x = [UIScreen mainScreen].bounds.size.width - letbtn.width;
    NSLog(@"%@",NSStringFromCGRect(letbtn.frame));
    [letbtn setImage:[UIImage imageNamed:@"top_navigation_square"] forState:UIControlStateNormal];
    
}
-(void)viewWillAppear:(BOOL)animated {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"top20"]){
        self.TopToTop.constant = 20;
        [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"top20"];
    }else{
        self.TopToTop.constant = 0;
    }
    self.navigationController.navigationBarHidden = NO;
    self.letbtn.hidden = NO;
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"letbtn"]) {
        self.letbtn.hidden = YES;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"letbtn"];
    }
    self.letbtn.alpha = 0;
    [UIView animateWithDuration:0.4 animations:^{
        self.letbtn.alpha = 1;
    }];
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.letbtn.hidden = YES;
    self.letbtn.transform = CGAffineTransformIdentity;
    [self.letbtn setImage:[UIImage imageNamed: @"top_navigation_square"] forState:UIControlStateNormal];
}
-(void)showLeftBtn {
    self.letbtn.hidden = NO;
}
-(void)createAFHttpRequest {
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}
- (void)addWeather{
    SXWeatherView *weatherView = [SXWeatherView view];
    weatherView.weatherModel = self.weatherModel;
    self.weatherView = weatherView;
    weatherView.alpha = 0.9;
    UIWindow *win = [UIApplication sharedApplication].windows.firstObject;
    [win addSubview:weatherView];
    
    weatherView.block = ^(NSInteger index){
        switch (index) {
            case 0: {
                SearchViewController *search = [[SearchViewController alloc] init];
                self.weatherView.hidden = YES;
                self.tran.hidden = YES;
                self.weatherShow = NO;
                [self.navigationController pushViewController:search animated:YES];
            }
                break;
            case 1: {
                LoginViewController *login = [[LoginViewController alloc] init];
                self.weatherView.hidden = YES;
                self.tran.hidden = YES;
                self.weatherShow = NO;
                [self.navigationController pushViewController:login animated:YES];
            }
                break;
            default:
                break;
        }
    };

    
    UIImageView *tran = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"224"]];
    self.tran = tran;
    tran.width = 7;
    tran.height = 7;
    tran.y = 57;
    tran.x = [UIScreen mainScreen].bounds.size.width - 33;
    [win addSubview:tran];
    
    weatherView.frame = [UIScreen mainScreen].bounds;
    weatherView.y = 64;
    weatherView.height -= 64;
    self.weatherView.hidden = YES;
    self.tran.hidden = YES;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pushWeatherDetail) name:@"pushWeatherDetail" object:nil];
}

- (void)sendWeatherRequest
{
    NSString *url = @"http://c.3g.163.com/nc/weather/5YyX5LqsfOWMl%2BS6rA%3D%3D.html";
    [self.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSArray *detail = dict[@"北京|北京"];
//        NSLog(@"%@",detail);
        NSMutableArray *ary = [[NSMutableArray alloc] init];
        for (NSDictionary *dict in detail) {
            SXWeatherDetailM *model = [[SXWeatherDetailM alloc] init];
            [model setValuesForKeysWithDictionary:dict];
            [ary addObject:model];
        }
        SXWeatherModel *model = [[SXWeatherModel alloc] init];
        model.detailArray = [ary copy];
        SXWeatherBgM *bg = [[SXWeatherBgM alloc] init];
        NSDictionary *pm = dict[@"pm2d5"];
        bg.nbg1 = pm[@"nbg1"];
        bg.nbg2 = pm[@"nbg2"];
        bg.aqi = pm[@"aqi"];
        bg.pm2_5 = pm[@"pm2_5"];
        model.pm2d5 = bg;
        model.dt = dict[@"dt"];
        model.rt_temperature = [dict[@"rt_temperature"] intValue];
        self.weatherModel = model;
        [self addWeather];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}


-(void)btnClicked {
    if (self.isWeatherShow) {
        self.weatherView.hidden = YES;
        self.tran.hidden = YES;
        [UIView animateWithDuration:0.1 animations:^{
            self.letbtn.transform = CGAffineTransformRotate(self.letbtn.transform, M_1_PI * 5);
            
        } completion:^(BOOL finished) {
            [self.letbtn setImage:[UIImage imageNamed:@"top_navigation_square"] forState:UIControlStateNormal];
        }];
    }else{
        
        [self.letbtn setImage:[UIImage imageNamed: @"223"] forState:UIControlStateNormal];
        self.weatherView.hidden = NO;
        self.tran.hidden = NO;
        [self.weatherView addAnimate];
        [UIView animateWithDuration:0.2 animations:^{
            self.letbtn.transform = CGAffineTransformRotate(self.letbtn.transform, -M_1_PI * 6);
            
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:0.1 animations:^{
                self.letbtn.transform = CGAffineTransformRotate(self.letbtn.transform, M_1_PI );
            }];
        }];
    }
    self.weatherShow = !self.isWeatherShow;

}
- (void)pushWeatherDetail
{
    self.weatherShow = NO;
    SXWeatherDetailVC *weather = [[SXWeatherDetailVC alloc]init];
    weather.weatherModel = self.weatherModel;
    [self.navigationController pushViewController:weather animated:YES];
    [UIView animateWithDuration:0.1 animations:^{
        self.weatherView.alpha = 0;
    } completion:^(BOOL finished) {
        self.weatherView.alpha = 0.9;
        self.weatherView.hidden = YES;
        self.tran.hidden = YES;
    }];
}
#pragma mark - Lazy Loading
- (NSMutableDictionary *)posRecords {
    if (_posRecords == nil) {
        _posRecords = [[NSMutableDictionary alloc] init];
    }
    return _posRecords;
}

- (NSMutableDictionary *)displayVC {
    if (_displayVC == nil) {
        _displayVC = [[NSMutableDictionary alloc] init];
    }
    return _displayVC;
}

#pragma mark - Public Methods
- (instancetype)initWithViewControllerClasses:(NSArray *)classes andTheirTitles:(NSArray *)titles withIds:(NSArray *)Ids{
    if (self = [super init]) {
        NSAssert(classes.count == titles.count, @"classes.count != titles.count");
        _viewControllerClasses = [NSArray arrayWithArray:classes];
        _titles = [NSArray arrayWithArray:titles];
        _IdArr = [NSArray arrayWithArray:Ids];
        [self setup];
    }
    return self;
}
- (instancetype)initWithViewControllerClasses:(NSArray *)classes andTheirTitles:(NSArray *)titles {
    if (self = [super init]) {
        NSAssert(classes.count == titles.count, @"classes.count != titles.count");
        _viewControllerClasses = [NSArray arrayWithArray:classes];
        _titles = [NSArray arrayWithArray:titles];
        [self setup];
    }
    return self;

}
- (instancetype)init {
    if (self = [super init]) {
        [self setup];
    }
    return self;
}

- (void)setCachePolicy:(WMPageControllerCachePolicy)cachePolicy {
    _cachePolicy = cachePolicy;
    self.memCache.countLimit = _cachePolicy;
}

- (void)setItemsWidths:(NSArray *)itemsWidths {
    NSAssert(itemsWidths.count == self.titles.count, @"itemsWidths.count != self.titles.count");
    _itemsWidths = [itemsWidths copy];
}

- (void)setSelectIndex:(int)selectIndex {
    _selectIndex = selectIndex;
    if (self.menuView) {
        [self.menuView selectItemAtIndex:selectIndex];
    }
}

#pragma mark - Private Methods

// 当子控制器init完成时发送通知
- (void)postAddToSuperViewNotificationWithIndex:(int)index {
    if (!self.postNotification) return;
    NSDictionary *info = @{ @"index":@(index), @"title":self.titles[index]};
    if (self.IdArr) {
        NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.IdArr[index],@"id", nil];
        [[NSNotificationCenter defaultCenter] postNotificationName:WMControllerDidAddToSuperViewNotification object:info userInfo:dict];
    } else {
        [[NSNotificationCenter defaultCenter] postNotificationName:WMControllerDidAddToSuperViewNotification object:info];
    }
}

// 当子控制器完全展示在user面前时发送通知
- (void)postFullyDisplayedNotificationWithCurrentIndex:(int)index {
    if (!self.postNotification) return;
    NSDictionary *info = @{ @"index":@(index), @"title":self.titles[index]};
    if (self.IdArr) {
         NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:self.IdArr[index],@"id", nil];
         [[NSNotificationCenter defaultCenter] postNotificationName:WMControllerDidFullyDisplayedNotification object:info userInfo:dict];
    } else {
         [[NSNotificationCenter defaultCenter] postNotificationName:WMControllerDidFullyDisplayedNotification object:info];
    }
}

// 初始化一些参数，在init中调用
- (void)setup {
    _titleSizeSelected  = WMTitleSizeSelected;
    _titleColorSelected = WMTitleColorSelected;
    _titleSizeNormal    = WMTitleSizeNormal;
    _titleColorNormal   = WMTitleColorNormal;
    
    _menuBGColor   = WMMenuBGColor;
    _menuHeight    = WMMenuHeight;
    _menuItemWidth = WMMenuItemWidth;
    
    _memCache = [[NSCache alloc] init];
    
    
}

// 包括宽高，子控制器视图 frame
- (void)calculateSize {
    viewHeight = self.view.frame.size.height - self.menuHeight;
    viewWidth = self.view.frame.size.width;
    // 重新计算各个控制器视图的宽高
    _childViewFrames = [NSMutableArray array];
    for (int i = 0; i < self.viewControllerClasses.count; i++) {
        CGRect frame = CGRectMake(i*viewWidth, 0, viewWidth, viewHeight);
        [_childViewFrames addObject:[NSValue valueWithCGRect:frame]];
    }
}

- (void)addScrollView {
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    
    scrollView.pagingEnabled = YES;
    scrollView.backgroundColor = [UIColor whiteColor];
    scrollView.delegate = self;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.bounces = NO;
    
    [self.view addSubview:scrollView];
    self.scrollView = scrollView;
}

- (void)addMenuView {
    CGRect frame = CGRectMake(0, 0, self.view.frame.size.width, self.menuHeight);
    WMMenuView *menuView = [[WMMenuView alloc] initWithFrame:frame buttonItems:self.titles backgroundColor:self.menuBGColor norSize:self.titleSizeNormal selSize:self.titleSizeSelected norColor:self.titleColorNormal selColor:self.titleColorSelected];
    menuView.delegate = self;
    menuView.style = self.menuViewStyle;
    if (self.titleFontName) {
        menuView.fontName = self.titleFontName;
    }
    if (self.progressColor) {
        menuView.lineColor = self.progressColor;
    }
    [self.view addSubview:menuView];
    self.menuView = menuView;
    // 如果设置了初始选择的序号，那么选中该item
    if (self.selectIndex != 0) {
        [self.menuView selectItemAtIndex:self.selectIndex];
    }
}

- (void)layoutChildViewControllers {
    int currentPage = (int)self.scrollView.contentOffset.x / viewWidth;
    int start,end;
    if (currentPage == 0) {
        start = currentPage;
        end = currentPage + 1;
    } else if (currentPage + 1 == self.viewControllerClasses.count){
        start = currentPage - 1;
        end = currentPage;
    } else {
        start = currentPage - 1;
        end = currentPage + 1;
    }
    for (int i = start; i <= end; i++) {
        CGRect frame = [self.childViewFrames[i] CGRectValue];
        UIViewController *vc = [self.displayVC objectForKey:@(i)];
        if ([self isInScreen:frame]) {
            if (vc == nil) {
                // 先从 cache 中取
                vc = [self.memCache objectForKey:@(i)];
                if (vc) {
                    // cache 中存在，添加到 scrollView 上，并放入display
                    [self addCachedViewController:vc atIndex:i];
                } else {
                    // cache 中也不存在，创建并添加到display
                    [self addViewControllerAtIndex:i];
                }
                [self postAddToSuperViewNotificationWithIndex:i];
            }
        } else {
            if (vc) {
                // vc不在视野中且存在，移除他
                [self removeViewController:vc atIndex:i];
            }
        }
    }
}

- (void)addCachedViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    [self addChildViewController:viewController];
    viewController.view.frame = [self.childViewFrames[index] CGRectValue];
    [viewController didMoveToParentViewController:self];
    [self.scrollView addSubview:viewController.view];
    [self.displayVC setObject:viewController forKey:@(index)];
}

// 添加子控制器
- (void)addViewControllerAtIndex:(int)index {
    Class vcClass = self.viewControllerClasses[index];
    UIViewController *viewController = [[vcClass alloc] init];
    [self addChildViewController:viewController];
    viewController.view.frame = [self.childViewFrames[index] CGRectValue];
    [viewController didMoveToParentViewController:self];
    [self.scrollView addSubview:viewController.view];
    [self.displayVC setObject:viewController forKey:@(index)];
    
    [self backToPositionIfNeeded:viewController atIndex:index];
}

// 移除控制器，且从display中移除
- (void)removeViewController:(UIViewController *)viewController atIndex:(NSInteger)index {
    [self rememberPositionIfNeeded:viewController atIndex:index];
    [viewController.view removeFromSuperview];
    [viewController willMoveToParentViewController:nil];
    [viewController removeFromParentViewController];
    [self.displayVC removeObjectForKey:@(index)];
    
    // 放入缓存
    if (![self.memCache objectForKey:@(index)]) {
        [self.memCache setObject:viewController forKey:@(index)];
    }
}

- (void)backToPositionIfNeeded:(UIViewController *)controller atIndex:(NSInteger)index {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if (!self.rememberLocation) return;
#pragma clang diagnostic pop
    if ([self.memCache objectForKey:@(index)]) return;
    UIScrollView *scrollView = [self isKindOfScrollViewController:controller];
    if (scrollView) {
        NSValue *pointValue = self.posRecords[@(index)];
        if (pointValue) {
            CGPoint pos = [pointValue CGPointValue];
            // 奇怪的现象，我发现 collectionView 的 contentSize 是 {0, 0};
            [scrollView setContentOffset:pos];
        }
    }
}

- (void)rememberPositionIfNeeded:(UIViewController *)controller atIndex:(NSInteger)index {
#pragma clang diagnostic push
#pragma clang diagnostic ignored"-Wdeprecated-declarations"
    if (!self.rememberLocation) return;
#pragma clang diagnostic pop
    UIScrollView *scrollView = [self isKindOfScrollViewController:controller];
    if (scrollView) {
        CGPoint pos = scrollView.contentOffset;
        self.posRecords[@(index)] = [NSValue valueWithCGPoint:pos];
    }
}

- (UIScrollView *)isKindOfScrollViewController:(UIViewController *)controller {
    UIScrollView *scrollView = nil;
    if ([controller.view isKindOfClass:[UIScrollView class]]) {
        // Controller的view是scrollView的子类(UITableViewController/UIViewController替换view为scrollView)
        scrollView = (UIScrollView *)controller.view;
    } else if (controller.view.subviews.count >= 1) {
        // Controller的view的subViews[0]存在且是scrollView的子类，并且frame等与view得frame(UICollectionViewController/UIViewController添加UIScrollView)
        UIView *view = controller.view.subviews[0];
        if ([view isKindOfClass:[UIScrollView class]]) {
            scrollView = (UIScrollView *)view;
        }
    }
    return scrollView;
}

- (BOOL)isInScreen:(CGRect)frame {
    CGFloat x = frame.origin.x;
    
//    CGFloat ScreenWidth = self.scrollView.frame.size.width;
    
    CGFloat contentOffsetX = self.scrollView.contentOffset.x;
    if (CGRectGetMaxX(frame) > contentOffsetX && x-contentOffsetX < ScreenWidth) {
        return YES;
    } else {
        return NO;
    }
}

- (void)resetMenuView {
    WMMenuView *oldMenuView = self.menuView;
    [self addMenuView];
    [oldMenuView removeFromSuperview];
}

- (void)growCachePolicyAfterMemoryWarning {
    self.cachePolicy = WMPageControllerCachePolicyBalanced;
    [self performSelector:@selector(growCachePolicyToHigh) withObject:nil afterDelay:2.0 inModes:@[NSRunLoopCommonModes]];
}

- (void)growCachePolicyToHigh {
    self.cachePolicy = WMPageControllerCachePolicyHigh;
}

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createAFHttpRequest];
    [self sendWeatherRequest];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    [self createNavagationBar];
    [self addScrollView];
    [self addMenuView];
    
    [self addViewControllerAtIndex:self.selectIndex];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    // 计算宽高及子控制器的视图frame
    [self calculateSize];
    CGRect scrollFrame = CGRectMake(0, self.menuHeight, viewWidth, viewHeight);
    self.scrollView.frame = scrollFrame;
    self.scrollView.contentSize = CGSizeMake(self.titles.count*viewWidth, viewHeight);
    [self.scrollView setContentOffset:CGPointMake(self.selectIndex*viewWidth, 0)];

    self.currentViewController.view.frame = [self.childViewFrames[self.selectIndex] CGRectValue];
    
    [self resetMenuView];

    [self.view layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    self.memoryWarningCount++;
    self.cachePolicy = WMPageControllerCachePolicyLowMemory;
    // 取消正在增长的 cache 操作
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(growCachePolicyAfterMemoryWarning) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(growCachePolicyToHigh) object:nil];
    
    [self.memCache removeAllObjects];
    [self.posRecords removeAllObjects];
    self.posRecords = nil;
    
    // 如果收到内存警告次数小于 3，一段时间后切换到模式 Balanced
    if (self.memoryWarningCount < 3) {
        [self performSelector:@selector(growCachePolicyAfterMemoryWarning) withObject:nil afterDelay:3.0 inModes:@[NSRunLoopCommonModes]];
    }
}

#pragma mark - UIScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self layoutChildViewControllers];
    if (animate) {
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        CGFloat rate = contentOffsetX / viewWidth;
        [self.menuView slideMenuAtProgress:rate];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    animate = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _selectIndex = (int)scrollView.contentOffset.x / viewWidth;
    self.currentViewController = self.displayVC[@(self.selectIndex)];
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self postFullyDisplayedNotificationWithCurrentIndex:self.selectIndex];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        CGFloat rate = targetX / viewWidth;
        [self.menuView slideMenuAtProgress:rate];
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    targetX = targetContentOffset->x;
}

#pragma mark - WMMenuView Delegate
- (void)menuView:(WMMenuView *)menu didSelesctedIndex:(NSInteger)index currentIndex:(NSInteger)currentIndex {
    NSInteger gap = (NSInteger)labs(index - currentIndex);
    animate = NO;
    CGPoint targetP = CGPointMake(viewWidth*index, 0);
    
    [self.scrollView setContentOffset:targetP animated:gap > 1?NO:self.pageAnimatable];
    if (gap > 1 || !self.pageAnimatable) {
        [self postFullyDisplayedNotificationWithCurrentIndex:(int)index];
        // 由于不触发 -scrollViewDidScroll: 手动清除控制器..
        UIViewController *vc = [self.displayVC objectForKey:@(currentIndex)];
        if (vc) {
            [self removeViewController:vc atIndex:currentIndex];
        }
    }
    _selectIndex = (int)index;
    self.currentViewController = self.displayVC[@(self.selectIndex)];
}

- (CGFloat)menuView:(WMMenuView *)menu widthForItemAtIndex:(NSInteger)index {
    if (self.itemsWidths) {
        return [self.itemsWidths[index] floatValue];
    }
    return self.menuItemWidth;
}

@end
