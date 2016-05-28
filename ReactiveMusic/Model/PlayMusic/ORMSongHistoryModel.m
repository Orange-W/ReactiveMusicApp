//
//  ORMSongHistoryModel.m
//  ReactiveMusic
//
//  Created by user on 16/5/19.
//  Copyright © 2016年 mredrock. All rights reserved.
//
#define kSongHistoryPlist @"SongHistory.plist"
#import "ORMSongHistoryModel.h"

#define kORMSongHistoryModelSongId @"songid"
#define kORMSongHistoryModelSongName @"songname"

@implementation ORMSongHistoryModel

static ORMSongHistoryModel *songHistoryModel;

+ (instancetype)sharedInstance{
    return [[ORMSongHistoryModel alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone{

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        songHistoryModel = [super allocWithZone:zone];
        [songHistoryModel awakeFromPlist];
        NSLog(@"song history new");
    });
    return songHistoryModel;
}

- (NSString *)savePsth{
    
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask, YES);
    NSString *cachesDirectoryPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Caches"];
    NSString *regionListFile = [cachesDirectoryPath stringByAppendingPathComponent:kSongHistoryPlist];
    if (![[NSFileManager defaultManager] fileExistsAtPath:cachesDirectoryPath]) {
        [[NSFileManager defaultManager] createDirectoryAtPath:cachesDirectoryPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    
    return regionListFile;

}

- (void)awakeFromPlist{
    
    self.songSet = [NSMutableSet set];
    self.songHistory = [NSMutableArray array];
    NSMutableArray *songHistory = [NSKeyedUnarchiver unarchiveObjectWithFile:[self savePsth]];
    
    if (songHistory) {
        //NSLog(@"播放历史读取:%@",songHistory);
        songHistoryModel.songHistory = [songHistory mutableCopy];
        
    }
    
    for (NSDictionary *dic in songHistory) {
        [self.songSet addObject:[dic objectForKey:kORMSongHistoryModelSongId]];
    }
}

- (NSArray *)addSongWithSingInfo:(NSDictionary *)info{
    NSNumber *addSongId = [info objectForKey:kORMSongHistoryModelSongId];
    if ([self.songSet containsObject:addSongId]) {
        [self.songHistory enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            NSDictionary *songInfo = obj;
            NSNumber* songId=  [songInfo objectForKey:kORMSongHistoryModelSongId];
            
            if ([songId isEqual:addSongId]) {
                [self.songHistory removeObjectAtIndex:idx];
                [self.songHistory insertObject:info atIndex:0];
                *stop = YES;
            }
        }];
    }else{
        [self.songHistory insertObject:info atIndex:0];
        [self.songSet addObject:addSongId];
    }
    [self.songHistory enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        NSLog(@"歌曲%ld:%@",idx,[obj objectForKey:kORMSongHistoryModelSongId]);
    }];
    
    //[self.songHistory writeToFile:[self savePsth] atomically:NO];
    BOOL sucess = [NSKeyedArchiver archiveRootObject:self.songHistory toFile:[self savePsth]];
    NSLog(@"%d|music History:%@",sucess,[self savePsth]);
    
    return self.songHistory;
}

@end
