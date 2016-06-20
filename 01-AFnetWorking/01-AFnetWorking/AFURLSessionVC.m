//
//  AFURLSessionVC.m
//  01-AFnetWorking
//
//  Created by qingyun on 16/6/8.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "AFURLSessionVC.h"
#import "AFNetworking.h"

#define KURL @"http://afnetworking.sinaapp.com/upload2server.json"


@interface AFURLSessionVC ()
@property (weak, nonatomic) IBOutlet UIProgressView *upLoadProgressView;
@property (weak, nonatomic) IBOutlet UIProgressView *downProgressView;

@end

@implementation AFURLSessionVC
- (IBAction)touchDownAction:(id)sender {
    //1.创建URl
    NSURL *url=[NSURL URLWithString:@"http://ww4.sinaimg.cn/large/4dfb56ecjw1e2901l2vj1j.jpg"];
    //2.创建Request请求
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    //3.AFURLSessionManager对象
    AFURLSessionManager *manager=[[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    //4.创建下载任务
    __weak UIProgressView *progressView=_downProgressView;
    NSURLSessionDownloadTask *task=[manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        //监听下载进度条,刷新UI 需要通过主线程进行刷新
        dispatch_async(dispatch_get_main_queue(), ^{
            progressView.progress=downloadProgress.fractionCompleted;
        });
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
      //文件下载后所保存路径
        return [NSURL fileURLWithPath:[NSString stringWithFormat:@"/Users/qingyun/Desktop/%@",response.suggestedFilename]];
    }completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
      //下载完成后调用
      //filePath 文件存储的路径
        if (error) {
            NSLog(@"=======%@",error);
        }
        NSLog(@"========%@",filePath);
    }];
    
    //4.开始任务
    [task resume];
    
    
}

- (IBAction)touchUpLoadAction:(id)sender {
    //1AFURLSessionManager对象
    AFURLSessionManager *manager=[[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    //2.创建request请求
    NSMutableURLRequest *requst=[[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:@"http://afnetworking.sinaapp.com/upload2server.json" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //追加数据 放到body
        NSURL *url=[[NSBundle mainBundle]URLForResource:@"2" withExtension:@"jpg"];
        
        [formData appendPartWithFileURL:[[NSBundle mainBundle]URLForResource:@"2" withExtension:@"jpg"] name:@"image" fileName:@"16031.jpg" mimeType:@"image/jpeg" error:nil];
        //追加第二条数据
        //[formData appendPartWithFileURL:[[NSBundle mainBundle] URLForResource:@"2" withExtension:@"jpg"] name:@"image" fileName:@"16032.jpg" mimeType:@"image/jpeg" error:nil];
    } error:nil];
    //3创建上传任务
    __weak UIProgressView *progressView=_upLoadProgressView;
    NSURLSessionUploadTask *task=[manager uploadTaskWithStreamedRequest:requst progress:^(NSProgress * _Nonnull uploadProgress) {
       //监听上传的进度,更新进度条,用主线程
        dispatch_async(dispatch_get_main_queue(), ^{
            progressView.progress=uploadProgress.fractionCompleted;
        });
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        //完成后的调用
        NSHTTPURLResponse *httpResponse=(NSHTTPURLResponse *)response;
        if (httpResponse.statusCode==200) {
            NSLog(@"====%@",responseObject);
        }
    }];
    //4.启动任务
    [task resume];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
