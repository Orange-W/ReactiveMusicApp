//
//  DetailViewController.h
//  ReactiveMusic
//
//  Created by user on 16/5/15.
//  Copyright © 2016年 mredrock. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end

