//
//  ViewController.m
//  GNProgressBar
//
//  Created by seayu on 2017/5/23.
//  Copyright © 2017年 seayu. All rights reserved.
//

#import "ViewController.h"
#import "GNProgressBar.h"

@interface ViewController ()

@property (weak, nonatomic) GNProgressBar *bar;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    GNProgressBar *bar = [GNProgressBar getInstance];
    
    CGRect frame =  bar.frame;
    frame.origin = CGPointMake(0, 200);
    bar.frame = frame;
    [bar startShining];
    [self.view addSubview:bar];
    
    _bar = bar;
    
    
}

static CGFloat num = 10.0;

- (IBAction)removeAll:(id)sender {
    [_bar removeAllProgressView];
}


- (IBAction)add:(id)sender {
    [_bar addProgressView];
    num = 10;
}
- (IBAction)delete:(id)sender {
    [_bar deleteLastProgressView];
    num = 10;
}

- (IBAction)changeLast:(id)sender {

    [_bar setLastProgressViewToWidth:num];
    num +=5;
}
- (IBAction)changeRandomlenggth:(id)sender {
    [_bar setProgressViewAtIndex:2 toWidth:15.5];
}

static BOOL isHiddden = YES;
- (IBAction)hiddenArrow:(id)sender {
    _bar.hiddenTriangleIndicatorImageViews = isHiddden;
    isHiddden = !isHiddden;
}

@end
