//
//  PlayerViewController.m
//  ReactiveMusic
//
//  Created by user on 16/5/15.
//  Copyright © 2016年 mredrock. All rights reserved.
//

#import "PlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "ReactiveCocoa.h"
#import "MusicCacheModel.h"
#import "UIImageView+WebCache.h"


typedef NS_ENUM(NSUInteger, ORMPlayerControlButtonType) {
    ORMPlayerControlButtonTypePlay = 0,
    ORMPlayerControlButtonTypeNext,
    ORMPlayerControlButtonTypeLast,
};

@interface PlayerViewController ()
@property (strong, nonatomic) AVPlayer *player;
@property (weak, nonatomic) IBOutlet UIImageView *musicImage;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *playerControlButtons;
@property (weak, nonatomic) IBOutlet UILabel *remanTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *playTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *showLyricsButton;
@property (weak, nonatomic) IBOutlet UIProgressView *musicProcess;
@property (strong, nonatomic) NSTimer *playTimer;
@property (weak, nonatomic) IBOutlet UISlider *playTimeSlider;
@end

@implementation PlayerViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.tabBarItem.title = @"播放";
//    self.tabBarItem.image = [UIImage imageNamed:@"music.png"];
    [self.navigationController setNavigationBarHidden:YES];
    //[MusicCacheModel musicHistory];
    
    //RAC
    {
        //__weak typeof(self)  self = self;
        @weakify(self);
        //播放
        UIButton *playButtton = self.playerControlButtons[ORMPlayerControlButtonTypePlay];
        
        
        [[playButtton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            [self clickPlayButton];
        }];
        //下一首
        UIButton *playNextButton = self.playerControlButtons[ORMPlayerControlButtonTypeNext];
        [[playNextButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
        }];
        //上一首
        UIButton *playLastButton = self.playerControlButtons[ORMPlayerControlButtonTypeLast];
        [[playLastButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            
        }];
        
        //展开歌词
        [[self.showLyricsButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
            @strongify(self);
            [UIView animateWithDuration:1 delay:0 options:UIViewAnimationOptionAutoreverse animations:^{
                UIImageView *imageView = self.showLyricsButton.imageView;
                self.showLyricsButton.userInteractionEnabled = NO;
                imageView.transform = CGAffineTransformMakeScale(2, 2);
                } completion:^(BOOL finished) {
                //finished判断动画是否完成
                if (finished) {
                    UIImageView *imageView = self.showLyricsButton.imageView;
                    imageView.transform = CGAffineTransformMakeScale(1, 1);
                    self.showLyricsButton.userInteractionEnabled = YES;
                    //NSLog(@"finished");
                }
            }];
        }];
    }

}

- (AVPlayer *)player{
    if (_player == nil) {
        _player = [[AVPlayer alloc] init];
    }
    return _player;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated{

}

#pragma mark -
#pragma mark  播放歌曲函数及监听

- (void)playMusicWithSongInfo:(NSDictionary *)info{
    
    NSURL *videoUrl = [NSURL URLWithString:info[@"url"]];
   UIImageView *placeholderImageView =  [[UIImageView alloc] init];
    [placeholderImageView sd_setImageWithURL:[NSURL URLWithString:info[@"albumpic_small"]]];
    [self.musicImage sd_setImageWithURL:[NSURL URLWithString:info[@"albumpic_big"]]
                       placeholderImage:placeholderImageView.image];
    //媒体管理 item
    AVPlayerItem *playItem = [AVPlayerItem playerItemWithURL:videoUrl];
    [self.player replaceCurrentItemWithPlayerItem:playItem];
    @weakify(playItem);
    @weakify(self);
    
    //监听流媒体状态
    [[self.player.currentItem rac_valuesForKeyPath:@"status" observer:playItem] subscribeNext:^(id x) {
        AVPlayerStatus status = [x integerValue];
        if (status == AVPlayerStatusReadyToPlay) {
            @strongify(playItem);
            @strongify(self);
            CMTime duration = playItem.duration;
            if (duration.timescale != 0) {
                CGFloat time = duration.value/duration.timescale;
                NSString *timeString = [self convertTime:time];
                self.remanTimeLabel.text = timeString;
                //NSLog(@"TIME>> %@",timeString);
            }
        }else{
        
        }
            
    }];
    
    //监听缓冲情况
    [[self.player.currentItem rac_valuesForKeyPath:@"loadedTimeRanges" observer:playItem] subscribeNext:^(id x) {
        @strongify(playItem);
        NSTimeInterval timeInterval = [self availableDuration];// 计算缓冲进度
        //NSLog(@"Time Interval:%f",timeInterval);
        CMTime duration = playItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        [self.musicProcess setProgress:timeInterval / totalDuration animated:YES];
        //NSLog(@"loadTime:%f",timeInterval / totalDuration);
        
    }];
    
    
    [self.musicProcess setProgress:0.0 animated:YES];//进度条置零
    
    //跟新进度条
    self.playTimer = [NSTimer scheduledTimerWithTimeInterval:0.25f target:self selector:@selector(updateTime) userInfo:nil repeats:YES];
    [[NSRunLoop mainRunLoop] addTimer:self.playTimer forMode:NSDefaultRunLoopMode];
    [self.playTimer fire];
    
    //添加歌曲播放历史
    [MusicCacheModel musicHistoryAddWithSongInfo:info];
    
    [self playMusic];
}

- (NSTimeInterval)availableDuration {
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];// 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;// 计算缓冲总进度
    return result;
}

- (NSString *)convertTime:(CGFloat)second{
    NSDate *d = [NSDate dateWithTimeIntervalSince1970:second];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    if (second/3600 >= 1) {
        [formatter setDateFormat:@"HH:mm:ss"];
    } else {
        [formatter setDateFormat:@"mm:ss"];
    }
    NSString *showtimeNew = [formatter stringFromDate:d];
    return showtimeNew;
}

- (void)updateTime{
    
    CMTime nowCMTime = [[self.player currentItem] currentTime];
    CMTime endCMTime = [[self.player currentItem] duration];
    UInt64 nowTime = CMTimeGetSeconds(nowCMTime);
    UInt64 endTime = CMTimeGetSeconds(endCMTime);

    NSString *descTimeString = [self convertTime:endTime-nowTime];
    NSString *nowTimeString = [self convertTime:nowTime];
    self.playTimeLabel.text = nowTimeString;
    self.remanTimeLabel.text = descTimeString;
    self.playTimeSlider.value = (CGFloat)nowTime/endTime;
    
    //NSLog(@"现在时间:%llu",nowTime);
}

#pragma mark -
#pragma mark   播放/暂停
static BOOL isPlaying = NO;
- (void)clickPlayButton{
    if (isPlaying) {
        [self pauseMusic];
    }else{
        [self playMusic];
    }
}


- (void)playMusic{
    UIButton *playButtton = self.playerControlButtons[ORMPlayerControlButtonTypePlay];
    [playButtton setSelected:YES];
    isPlaying = YES;
    [self.player play];
    
}


- (void)pauseMusic{
    UIButton *playButtton = self.playerControlButtons[ORMPlayerControlButtonTypePlay];
    [playButtton setSelected:NO];
    isPlaying = NO;
    [self.player pause];
}




@end
