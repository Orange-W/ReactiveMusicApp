//
//  ORMSongHistoryModel.h
//  ReactiveMusic
//
//  Created by user on 16/5/19.
//  Copyright © 2016年 mredrock. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ORMSongHistoryModel : NSObject

@property (strong, nonatomic) NSMutableArray *songHistory;
@property (strong, nonatomic) NSMutableSet *songSet;

+ (instancetype)sharedInstance;
- (NSArray *)addSongWithSingInfo:(NSDictionary *)info;
@end
