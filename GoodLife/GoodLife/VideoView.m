//
//  VideoView.m
//  GoodLife
//
//  Created by qianfeng on 15/10/7.
//  Copyright (c) 2015年 李琳琳. All rights reserved.
//

#import "VideoView.h"

@implementation VideoView
-(id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
    }
    return self;
}
+(Class)layerClass {
    return [AVPlayerLayer class];
}
-(void)setVideoViewWithPlayer:(AVPlayer *)player {
    AVPlayerLayer *layer = (AVPlayerLayer *)self.layer;
    [layer setPlayer:player];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
