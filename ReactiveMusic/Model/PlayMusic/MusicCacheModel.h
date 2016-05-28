//
//  MusicCacheModel.h
//  ReactiveMusic
//
//  Created by user on 16/5/19.
//  Copyright © 2016年 mredrock. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ORMSongHistoryModel.h"

@interface MusicCacheModel : NSObject
+ (NSArray *)musicTypeConfigFromBundle;

+ (NSArray *)musicHistory;
+ (NSArray *)musicHistoryAddWithSongInfo:(NSDictionary *)songInfo;
@end
