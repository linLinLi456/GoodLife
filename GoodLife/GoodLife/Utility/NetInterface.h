//
//  NetInterface.h
//  GoodLife
//
//  Created by qianfeng on 15/9/26.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#ifndef GoodLife_NetInterface_h
#define GoodLife_NetInterface_h
/*
 界面类型
 */
#define kBoutiqueType @"boutique"
#define kRankType @"rank"
#define kSubcategoriesType @"subcategories"

//精品
#define kBoutiqueUrl @"http://course.jaxus.cn/api/boutique?platform=1&channel=lenovo&version=4"

//精品中更多
#define kColumnUrl @"http://course.jaxus.cn/api/column/%@?platform=1&channel=lenovo&start=%ld&end=%ld&version=2"


//排行
#define kRankUrl @"http://course.jaxus.cn/api/rank?platform=1&channel=lenovo&version=2"
//排行中更多
#define kRankMoreUrl @"http://course.jaxus.cn/api/rank/%@?platform=1&channel=lenovo&start=%ld&end=%ld&version=2"

//分类
#define kSubcategoriesUrl @"http://course.jaxus.cn/api/category/subcategories?channel=lenovo&version=2"
//分类中头部滚动条
#define kHeaderUrl @"http://course.jaxus.cn/api/category/subcategories?categoryId=%@"
//分类中头部滚动条对应内容
#define kCourseUrl @"http://course.jaxus.cn/api/category/%@/courses?platform=1&sort=enrollNum&channel=lenovo&start=%ld&end=%ld&version=3"

//搜索
//热点
#define kHotUrl @"http://course.jaxus.cn/api/search/hot"
//搜索结果(用户)
#define kSearchCourceUrl @"http://course.jaxus.cn/api/search?platform=1&searchType=course&start=%ld&channel=lenovo&end=%ld&key=%@"
//课程
#define kSearchUserUrl @"http://course.jaxus.cn/api/search?platform=1&searchType=user&start=%ld&channel=lenovo&end=%ld&key=%@"



//课程详情
#define kCourceDetaileUrl @"http://course.jaxus.cn/api/course/%@?channel=lenovo&platform=1&version=2"
//视频列表
#define kCourceListUrl @"http://course.jaxus.cn/api/course/%@/sections?version=2"
//评论列表
#define kCommentListUrl @"http://course.jaxus.cn/api/course/%@/comment?start=%ld&end=%ld"
//商品列表
#define kBusinessListUrl @"http://course.jaxus.cn/api/business/%@?channel=lenovo&start=%ld&end=%ld"
//视频播放
#define kVideoUrl @"http://course.jaxus.cn/api/video/url?type=online&videoId=%@"


/*
 专题
 */
//专题头部信息
#define kHeaderInfoUrl @"http://course.jaxus.cn/api/topic/courses/%@/info"
//专题
#define kSubjectUrl @"http://course.jaxus.cn/api/topic/courses/%@?platform=1&channel=lenovo&start=%ld&end=20&version=%ld"

//达人
#define kUserInfo @"http://course.jaxus.cn/api/user/%@/userinfo"

#endif















