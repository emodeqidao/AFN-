//
//  ZWViewController.m
//  AFN演练
//
//  Created by jpkj on 14-3-26.
//  Copyright (c) 2014年 itcast. All rights reserved.
//

#import "ZWViewController.h"
#import "AFNetworking.h"
#import "SSZipArchive.h"

@interface ZWViewController ()

@end

@implementation ZWViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)downloadFiles:(UIButton *)sender
{
    //PS：这个地址下载可能会有点慢！！！！
    
    //1.指定下载地址
    NSString *urlString = @"https://github.com/NghiaTranUIT/FeSpinner/archive/master.zip";
    NSURL * url = [NSURL URLWithString:urlString];
    
    //2.指定文件保存路径
    NSArray * documents = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString * docDir = documents[0];

    //文件保存路径
    NSString * downloadPath = [docDir stringByAppendingPathComponent:@"Caches/order/order.zip"];
    
    //3.创建NSURLRequest
    NSURLRequest * request = [NSURLRequest requestWithURL:url];
    
    //4.创建AFURLConnectionOperation
    AFURLConnectionOperation * opertion = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    //5.设置操作的输出流（在网络中的数据是以流的方式传输的，告诉操作把文件保存在第2步设置的路径中）
    //下载输出流不需要追加
    [opertion setOutputStream:[NSOutputStream outputStreamToFileAtPath:downloadPath append:NO]];
    
    
    
    //6.设置下载进程处理块代码
    //6.1 bytesRead 读取的字节 -- 这一次下载的字节数
    //6.2 totalBytesRead 读取的总字节 -- 已经下载完的字节
    //6.3 totalBytesExpectedToRead 希望读取的总字节 -- 就是文件的总大小
    [opertion setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //下载进度
        NSLog(@"%f", (float)totalBytesRead / totalBytesExpectedToRead);
    }];

    //7.操作完成块代码
    [opertion setCompletionBlock:^{
        //我们可以去做解压缩的工作了，因为下载工作已经完成
        //1.知道文件保存路径
        
        //2.解压缩文件
        //第一个参数：压缩文件的路径
        //第二个参数：解压缩出来的文件所要存放的路径
        NSLog(@"%@",downloadPath);
        NSLog(@"%@",docDir);
        [SSZipArchive unzipFileAtPath:downloadPath toDestination:downloadPath];
        
        //3.删除压缩文件
        [[NSFileManager defaultManager] removeItemAtPath:downloadPath error:nil];
        
    }];
    
    //8.启动操作
    [opertion start];
    
    
}
@end
