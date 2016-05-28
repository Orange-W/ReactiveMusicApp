//
//  MusicCacheModel.m
//  ReactiveMusic
//
//  Created by user on 16/5/19.
//  Copyright © 2016年 mredrock. All rights reserved.
//
#define kMusicCacheHistoryPlist @".plist"


#import "MusicCacheModel.h"
#import "ORMSongHistoryModel.h"

@implementation MusicCacheModel
+ (NSArray *)musicTypeConfigFromBundle{
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"MusicTypeConfig" ofType:@"plist"];
    return [NSArray arrayWithContentsOfFile:filePath];
}

+ (NSArray *)musicHistory{
    
    ORMSongHistoryModel *songHistory = [ORMSongHistoryModel sharedInstance];
    
    return songHistory.songHistory;
}

+ (NSArray *)musicHistoryAddWithSongInfo:(NSDictionary *)songInfo{
    ORMSongHistoryModel *songHistory = [ORMSongHistoryModel sharedInstance];
    return [songHistory addSongWithSingInfo:songInfo];
}
@end
