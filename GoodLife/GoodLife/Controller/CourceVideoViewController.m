//
//  CourceVideoViewController.m
//  GoodLife
//
//  Created by qianfeng on 15/10/5.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "CourceVideoViewController.h"

#import "VideoView.h"
#import <CoreMedia/CoreMedia.h>
#import "VideoModel.h"


@interface CourceVideoViewController ()
{
    VideoView *_videoView;
    AVPlayer *_player;
    UISlider *_slider;
    UILabel *_minLabel;
    UILabel *_maxLabel;
    AFHTTPRequestOperationManager *_manager;
}
@property (nonatomic,strong) AFHTTPRequestOperationManager *manager;

@property (nonatomic,strong) NSMutableArray *dataArr;

@property (nonatomic,strong) NSMutableArray *data;

@property (nonatomic,strong) NSMutableArray *videoArr;

@property (weak, nonatomic) IBOutlet UIView *VideoView;

@property (weak, nonatomic) IBOutlet UIScrollView *ScrollView;

@property (weak, nonatomic) IBOutlet UIButton *detailBtn;
@property (weak, nonatomic) IBOutlet UIButton *courceListBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;
@property (weak, nonatomic) IBOutlet UIButton *businessBtn;
- (IBAction)detailBtnClick:(UIButton *)sender;

- (IBAction)courceListBtnClick:(UIButton *)sender;

- (IBAction)commentBtnClick:(UIButton *)sender;

- (IBAction)businessBtnClick:(UIButton *)sender;

- (IBAction)JoinCourceBtnClick:(UIButton *)sender;

@end

@implementation CourceVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.dataArr = [[NSMutableArray alloc] init];
    self.data = [[NSMutableArray alloc] init];
    self.videoArr = [[NSMutableArray alloc] init];
//    [self.navigationController setNavigationBarHidden:YES];
    [self createAFHttpRequest];
    [self getNetData];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden = YES;
}
-(void)createAFHttpRequest {
    self.manager = [AFHTTPRequestOperationManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
}
-(void)getNetData {
    NSString *url = [NSString stringWithFormat:kCourceListUrl,self.model._id];
    __weak typeof(self) weakSelf = self;
    [weakSelf.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            VideoModel *model = [[VideoModel alloc] initWithData:responseObject error:nil];
            [weakSelf.dataArr addObject:model.totalLectures];
            NSArray *section = model.sections;
            for (SectionModel *model in section) {
                [self.dataArr addObject:model];
                NSArray *lecture = model.lectures;
                for (LectureModel *model in lecture) {
                    [self.data addObject:model.videoId];
                }
            }
        }
        [self getVideoUrl];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
-(void)getVideoUrl {
    NSString *url = [NSString stringWithFormat:kVideoUrl,self.data[0]];
    __weak typeof(self) weakSelf = self;
    [weakSelf.manager GET:url parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (responseObject) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSDictionary *quality = dict[@"url"];
            NSString *str = quality[@"quality_10"];
            NSLog(@"str:%@",str);
            [self.videoArr addObject:str];
        }
        [self showUI];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
}
//将不适合的图片设置成想要尺寸的图片
-(UIImage*)OriginImage:(UIImage *)image scaleToSize:(CGSize)size
{
    UIGraphicsBeginImageContext(size);  //size 为CGSize类型，即你所需要的图片尺寸
    
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;   //返回的就是已经改变的图片
}

-(void)showUI {
    _videoView = [[VideoView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.VideoView.height)];
    [self.VideoView addSubview:_videoView];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.VideoView.height)];
    NSLog(@"model:%@",self.model.iconUrl);
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.model.iconUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        UIImage *originImage = [self OriginImage:image scaleToSize:CGSizeMake(_videoView.width,_videoView.height)];
        _videoView.backgroundColor = [UIColor colorWithPatternImage:originImage];
    }];
    [self createView];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, self.VideoView.bottom-60, self.view.width, 40)];
    _slider = [[UISlider alloc] initWithFrame:CGRectMake(100, 0, self.view.width-200, 40)];
    _slider.maximumValue = 1.0;
    _slider.minimumValue = 0.0;
    _slider.minimumTrackTintColor = [UIColor redColor];
    _slider.maximumTrackTintColor = [UIColor grayColor];
    [_slider addTarget:self action:@selector(sliderClick:) forControlEvents:UIControlEventValueChanged];
    [view addSubview:_slider];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.5;
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 25)];
    [button setBackgroundImage:[UIImage imageNamed: @"暂停"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:button];
    UIButton *bigBtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-40, 10, 30, 25)];
    [bigBtn setBackgroundImage:[UIImage imageNamed: @"放大"] forState:UIControlStateNormal];
    [bigBtn addTarget:self action:@selector(bigBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [view addSubview:bigBtn];
    
    _minLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, 50, 40)];
    _minLabel.text = @"0:00";
    _minLabel.textColor = [UIColor whiteColor];
    _minLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:_minLabel];
    _maxLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width-100, 0, 50, 40)];
    _maxLabel.text = @"5:30";
    _maxLabel.textAlignment = NSTextAlignmentCenter;
    _maxLabel.textColor = [UIColor whiteColor];
    [view addSubview:_maxLabel];
    
    [_videoView addSubview:view];
}
-(void)createView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
    UIButton *back = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 30, 30)];
    [back setImage:[UIImage imageNamed: @"返回"] forState:UIControlStateNormal];
    [view addSubview:back];
    [back addTarget:self action:@selector(backClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton *share = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width-40, 10, 30, 30)];
    [share setImage:[UIImage imageNamed: @"分享"] forState:UIControlStateNormal];
    [view addSubview:share];
    view.backgroundColor = [UIColor blackColor];
    view.alpha = 0.3;
    [share addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    [_videoView addSubview:view];
}
-(void)sliderClick:(UISlider *)slider {
    if (_player) {
        [_player seekToTime:CMTimeMultiplyByFloat64(_player.currentItem.duration, slider.value)];
    }
}
-(void)btnClick:(UIButton *)button {
    if (_player) {
        [_player pause];
        return;
    }
    [self loadVideoFromPath:self.videoArr[0]];
}
-(void)loadVideoFromPath:(NSString *)path {
    if (path.length == 0) {
        NSLog(@"没有视频");
        return;
    }
    NSURL *url = [NSURL URLWithString:path];
    NSLog(@"%@",url);
    AVAsset *set = [AVAsset assetWithURL:url];
    [set loadValuesAsynchronouslyForKeys:@[@"tracks"] completionHandler:^{
        AVKeyValueStatus status = [set statusOfValueForKey:@"tracks" error:nil];
        if (status == AVKeyValueStatusLoaded) {
            AVPlayerItem *item = [AVPlayerItem playerItemWithAsset:set];
            _player = [[AVPlayer alloc] initWithPlayerItem:item];
            [_videoView setVideoViewWithPlayer:_player];
            [_player play];
            __weak AVPlayer *blockPlayer = _player;
            __weak UISlider *blockSlider = _slider;
            __weak UILabel *minLabel = _minLabel;
            __weak UILabel *maxLabel = _maxLabel;
            [_player addPeriodicTimeObserverForInterval:CMTimeMake(1.0, 1.0) queue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) usingBlock:^(CMTime time) {
                CMTime t1 = blockPlayer.currentTime;
                CMTime t2 = blockPlayer.currentItem.duration;
                float currentTime = CMTimeGetSeconds(t1);
                minLabel.text = [NSString stringWithFormat:@"%.2f",currentTime];
                float total = CMTimeGetSeconds(t2);
                maxLabel.text = [NSString stringWithFormat:@"%.2f",total];
                float progressCur = currentTime/total;
                dispatch_async(dispatch_get_main_queue(), ^{
                    blockSlider.value = progressCur;
                });
            }];
        }
    }];
}
-(void)bigBtnClick:(UIButton *)button {

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)detailBtnClick:(UIButton *)sender {
}

- (void)backClick:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareClick:(UIButton *)sender {
}

- (IBAction)courceListBtnClick:(UIButton *)sender {
}

- (IBAction)commentBtnClick:(UIButton *)sender {
}

- (IBAction)businessBtnClick:(UIButton *)sender {
}

- (IBAction)JoinCourceBtnClick:(UIButton *)sender {
}
@end
