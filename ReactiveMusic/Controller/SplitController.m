//
//  SplitController.m
//  ReactiveMusic
//
//  Created by user on 16/5/15.
//  Copyright © 2016年 mredrock. All rights reserved.
//

#import "SplitController.h"
#import "MusicListTableViewController.h"
@interface SplitController ()

@end

@implementation SplitController

static SplitController *splitVc;
+ (instancetype)sharedInstance{
    splitVc = [[SplitController alloc] init];
    return splitVc;
}

+ (id)allocWithZone:(struct _NSZone *) zone
{
    //NSLog(@"232");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSLog(@"new");
        splitVc = [super allocWithZone:zone];
    });
    return splitVc;
}

- (void)viewDidLoad {
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
