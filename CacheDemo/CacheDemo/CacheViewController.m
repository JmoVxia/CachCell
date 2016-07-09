//
//  CacheViewController.m
//  CacheDemo
//
//  Created by sks on 16/7/9.
//  Copyright © 2016年 CL. All rights reserved.
//

#import "CacheViewController.h"
#import "CLCacheCell.h"
#import "UIImageView+WebCache.h"
@interface CacheViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView *tableView;

@end

@implementation CacheViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    _tableView.contentInset = UIEdgeInsetsMake(50, 0, 0, 0);
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UIAccessibilityTraitNone;
    [self.view addSubview:_tableView];
    
    [_tableView registerClass:[CLCacheCell class] forCellReuseIdentifier:@"CLCacheCell"];
    [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];

    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 30;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //这里需要注意，清除缓存的Cell是一个特殊的Cell，需要单独标记，不然复用会出现问题
    if (indexPath.row==0)
    {
        CLCacheCell *canchecell = [tableView dequeueReusableCellWithIdentifier:@"CLCacheCell"];
        return canchecell;
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    cell.textLabel.text = [NSString stringWithFormat:@"%ld",indexPath.row];
    return cell;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // 取消选中
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.row==0)
    {
        // 取到对应Cell清除缓存
        CLCacheCell *cell = (CLCacheCell *)[tableView cellForRowAtIndexPath:indexPath];
        [cell clearCache];
    }
    else
    {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
}



@end
