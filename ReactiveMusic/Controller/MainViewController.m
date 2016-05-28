//
//  MainViewController.m
//  ReactiveMusic
//
//  Created by user on 16/5/15.
//  Copyright © 2016年 mredrock. All rights reserved.
//

#import "MainViewController.h"
#import "MusicListTableViewController.h"
#import "MusicCacheModel.h"

@interface MainViewController ()
@property (strong, nonatomic) IBOutlet UITableView *musicList;
@property (strong, nonatomic) NSArray *musicTypeConfigArray;
@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    self.tabBarItem.title = @"歌曲列表";
//    self.tabBarItem.image = [UIImage imageNamed:@"more.png"];
    {
        
        [self.musicList registerNib:nil forCellReuseIdentifier:@"cell"];
        self.musicList.dataSource = self;
        self.musicList.delegate = self;
    }
    self.musicTypeConfigArray = [MusicCacheModel musicTypeConfigFromBundle];
    //NSLog(@"%@",self.musicTypeConfigArray);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [self.musicList dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    NSDictionary *info = [self.musicTypeConfigArray objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Georgia" size:25];
    cell.textLabel.text = [info objectForKey:@"type"];
    [cell.textLabel sizeToFit];
    cell.tag = [[info objectForKey:@"topid"] integerValue];

    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{return 1;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.musicTypeConfigArray.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *storybord = [UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    MusicListTableViewController *vc = [storybord instantiateViewControllerWithIdentifier:@"MusicList"];
    vc.topid = [tableView cellForRowAtIndexPath:indexPath].tag;
    vc.title = [tableView cellForRowAtIndexPath:indexPath].textLabel.text;
    [self.navigationController pushViewController:vc animated:YES];
    
    
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
