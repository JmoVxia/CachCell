//
//  ViewController.m
//  CacheDemo
//
//  Created by sks on 16/7/9.
//  Copyright © 2016年 CL. All rights reserved.
//

#import "ViewController.h"
#import "CacheViewController.h"
@interface ViewController ()


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(99, 99, 99, 99)];
    button.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:button];
    [button addTarget:self action:@selector(Push) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)Push
{
    CacheViewController *cc = [[CacheViewController alloc]init];
    
    
    
    [self presentViewController:cc animated:YES completion:nil];
    
}



@end
