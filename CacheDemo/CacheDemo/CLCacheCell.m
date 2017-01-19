//
//  CLCacheCell.m
//  CacheDemo
//
//  Created by sks on 16/7/9.
//  Copyright © 2016年 CL. All rights reserved.
//

#import "CLCacheCell.h"
#import "NSString+Extension.h"
#import "SVProgressHUD.h"
#import "SDImageCache.h"
@implementation CLCacheCell

/** 缓存路径 */
#define CLCacheFile [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"缓存"]

static NSString * const CLDefaultText = @"清除缓存";


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.textLabel.text = CLDefaultText;
        
        // 禁止点击事件
        self.userInteractionEnabled = NO;
        // 右边显示圈圈
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [loadingView startAnimating];
        self.accessoryView = loadingView;
        //弱引用是为了让Cell销毁，不会被Block拉住
        __weak __typeof(self) weakSelf = self;
        //子线程
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            __typeof(&*weakSelf) strongSelf = weakSelf;
            // 计算缓存大小
            NSInteger size = CLCacheFile.fileSize;
            //加上SDWebImage的缓存
            size += [SDImageCache sharedImageCache].getSize;
            //Cell销毁后就不执行下面操作
            if (strongSelf == nil) return;
            //缓存路径
            NSLog(@"%@",CLCacheFile);
            NSString *sizeText = nil;
            if (size >= pow(10, 9)) { // >= 1GB
                sizeText = [NSString stringWithFormat:@"%.2fGB", size / pow(10, 9)];
            } else if (size >= pow(10, 6)) { // >= 1MB
                sizeText = [NSString stringWithFormat:@"%.2fMB", size /pow(10, 6)];
            } else if (size >= pow(10, 3)) { // >= 1KB
                sizeText = [NSString stringWithFormat:@"%.2fKB", size / pow(10, 3)];
            } else { // >= 0B
                sizeText = [NSString stringWithFormat:@"%zdB", size];
            }
            NSString *text = [NSString stringWithFormat:@"%@(%@)", CLDefaultText, sizeText];
            //回到主线程刷新UI
            dispatch_async(dispatch_get_main_queue(), ^{
                strongSelf.textLabel.text = text;
                strongSelf.accessoryType  = UITableViewCellAccessoryDisclosureIndicator;
                strongSelf.accessoryView  = nil;
                // 允许点击事件
                strongSelf.userInteractionEnabled = YES;
            });
        });
    }
    return self;
}

//清理缓存
- (void)clearCache
{
    [SVProgressHUD showWithStatus:@"正在清除缓存"];
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeBlack];
    [[SDImageCache sharedImageCache] clearDiskOnCompletion:^{
        //子线程
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            //删除
            [[NSFileManager defaultManager] removeItemAtPath:CLCacheFile error:nil];
            //创建文件夹
            [[NSFileManager defaultManager] createDirectoryAtPath:CLCacheFile withIntermediateDirectories:YES attributes:nil error:nil];
            dispatch_async(dispatch_get_main_queue(), ^{
                [SVProgressHUD showSuccessWithStatus:@"清除成功"];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [SVProgressHUD dismiss];
                });
                    self.textLabel.text = @"清除缓存(0B)";
                    // 禁止点击事件
                    self.userInteractionEnabled = NO;
                });
        });
    }];
}

//当Cell重写显示的时候，调用下面方法
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.accessoryView == nil) return;
    // 让圈圈继续旋转
    UIActivityIndicatorView *loadingView = (UIActivityIndicatorView *)self.accessoryView;
    [loadingView startAnimating];
    self.textLabel.text = @"正在计算缓存大小...";
}

@end
