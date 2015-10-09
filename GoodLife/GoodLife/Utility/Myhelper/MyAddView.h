//
//  MyAddView.h
//  GoodLife
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, UIPageControlShowStyle)
{
    /**
     *  @author
     *
     *  不显示PageControl
     */
    UIPageControlShowStyleNone,//default
    UIPageControlShowStyleLeft,
    UIPageControlShowStyleCenter,
    UIPageControlShowStyleRight,
};

typedef NS_ENUM(NSUInteger, AdTitleShowStyle)
{
    /**
     *  @author
     *
     *  不显示标题
     */
    AdTitleShowStyleNone,
    AdTitleShowStyleLeft,
    AdTitleShowStyleCenter,
    AdTitleShowStyleRight,
};

@interface MyAddView : UIView<UIScrollViewDelegate>
{
    UILabel * _centerAdLabel;
    CGFloat _adMoveTime;
}

/**
 *  @author
 *
 *  @brief  这个计时器需要特殊处理,否则会照成内存泄露
 */
@property (assign, nonatomic) NSTimer *moveTimer;
@property (retain,nonatomic,readonly) UIScrollView * adScrollView;
@property (retain,nonatomic,readonly) UIPageControl * pageControl;
@property (retain,nonatomic,readonly) NSArray * imageLinkURL;
@property (retain,nonatomic,readonly) NSArray * adTitleArray;
/**
 *  @author
 *
 *  设置page显示位置
 */
@property (assign,nonatomic) UIPageControlShowStyle  PageControlShowStyle;
/**
 *  @author
 *
 *  设置标题对应的位置
 */
@property (assign,nonatomic,readonly) AdTitleShowStyle  adTitleStyle;

/**
 *  @author
 *
 *  设置占位图片
 */
@property (nonatomic,strong) UIImage * placeHoldImage;

/**
 *  @author
 *
 *  是否需要定时循环滚动
 */
@property (nonatomic,assign) BOOL isNeedCycleRoll;



/**
 *  @author
 *
 *  @brief  图片移动计时器
 */
@property (nonatomic,assign) CGFloat  adMoveTime;
/**
 *  @author
 *
 *  @brief  在这里修改Label的一些属性
 */
@property (nonatomic,strong,readonly) UILabel * centerAdLabel;

/**
 *  @author
 *
 *  @brief  给图片创建点击后的回调方法
 */
@property (nonatomic,strong) void (^callBack)(NSInteger index,NSString * imageURL);

/**
 *  @author
 *
 *  @brief  设置每个图片下方的标题
 *
 *  @param adTitleArray 标题数组
 *  @param adTitleStyle 标题显示风格
 */
- (void)setAdTitleArray:(NSArray *)adTitleArray withShowStyle:(AdTitleShowStyle)adTitleStyle;

/**
 *  @author
 *
 *  @brief  创建AdView对象
 *
 *  @param frame                设置Frame
 *  @param imageLinkURL         图片链接地址数组,数组的每一项均为字符串
 *  @param PageControlShowStyle PageControl显示位置
 *  @param object 控件在那个类文件中
 *  @return 广告视图
 */
+ (id)adScrollViewWithFrame:(CGRect)frame imageLinkURL:(NSArray *)imageLinkURL pageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle;

+ (id)adScrollViewWithFrame:(CGRect)frame imageLinkURL:(NSArray *)imageLinkURL placeHoderImageName:(NSString *)imageName pageControlShowStyle:(UIPageControlShowStyle)PageControlShowStyle;



@end
