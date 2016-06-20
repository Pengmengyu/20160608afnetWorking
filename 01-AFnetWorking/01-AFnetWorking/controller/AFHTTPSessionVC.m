//
//  AFHTTPSessionVC.m
//  01-AFnetWorking
//
//  Created by qingyun on 16/6/8.
//  Copyright © 2016年 QingYun. All rights reserved.
//

#import "AFHTTPSessionVC.h"
#import "AFNetworking.h"
#define GETURL @"http://afnetworking.sinaapp.com/request_get.json"
@interface AFHTTPSessionVC ()
@property(nonatomic,strong)AFHTTPSessionManager *manager;
@end

@implementation AFHTTPSessionVC

-(void)Kalter:(NSString *)message{

    UIAlertController *alterCV=[UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action=[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    [alterCV addAction:action];
    [self presentViewController:alterCV animated:YES completion:nil];

}


-(void)handelNetState:(AFNetworkReachabilityStatus)state{
    switch (state) {
        case AFNetworkReachabilityStatusUnknown:{
            [self Kalter:@"未知网络"];
         }
        case AFNetworkReachabilityStatusNotReachable:
            [self Kalter:@"网络不可达"];
            break;
        case AFNetworkReachabilityStatusReachableViaWWAN:
            [self Kalter:@"蜂窝网络4G/3G"];
            break;
        case AFNetworkReachabilityStatusReachableViaWiFi:
            [self Kalter:@"WiFi"];
        default:
            break;
    }
}


-(AFHTTPSessionManager *)manager{
    if (_manager)return _manager;
   //1.创建Manager对象
    _manager=[AFHTTPSessionManager manager];
   //2.创建网络监听对象
    _manager.reachabilityManager=[AFNetworkReachabilityManager sharedManager];
   //3设置网络监听后回调的方法
    __weak AFHTTPSessionVC *vc=self;
   // __weak typeof(self) weakSelf =self;
    [_manager.reachabilityManager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
     //网络改变后回调
        [vc handelNetState:status];
    }];
    //5.启动网络监听
    [_manager.reachabilityManager startMonitoring];
    
    return _manager;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)getAction:(id)sender {
    //1.设置请求参数
   // NSDictionary *pars=@{@"foo":@"bar"};
    NSDictionary *pars=@{@"page":@"1"};
    //设置响应序列化 content_type  默认是Json序列化,字典或者一个数组
    //http响应序列化,返回是nsdata
    // self.manager.responseSerializer=[AFHTTPResponseSerializer serializer];
    
    //2设置响应接收的类型
    self.manager.responseSerializer.acceptableContentTypes=[NSSet setWithObjects:@"text/html",@"text/json",nil];
    
    [self.manager GET:@"http://www.zhihuiluanchuan.com/index.php?s=/Api/document/zxrd" parameters:pars progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
      //请求成功时候掉
        NSHTTPURLResponse *response=(NSHTTPURLResponse *)task.response;
        if (response.statusCode==200) {
            NSLog(@"======%@",responseObject);
            //NSString *string=[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
//            //手动解析Json
//            NSDictionary *rsdic=[NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//            
//            NSLog(@"=====%@",rsdic);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
      //请求失败调用
        NSLog(@"=====%@",error);
    }];
    
    
}
- (IBAction)postAction:(id)sender {
     //请求参数
    NSDictionary *pars=@{@"foo":@"bar"};
    //设置请求序列化  默认的请求序列化: http请求序列化 参数 "foo=bar"
    //设置json请求序列化, 参数格式"foo":"bar"
    self.manager.requestSerializer=[AFJSONRequestSerializer serializer];
    //开始请求
    [self.manager POST:@"http://afnetworking.sinaapp.com/request_post_body_json.json" parameters:pars progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"======%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"======%@",error);
    }];
}
- (IBAction)mutipartPostAction:(id)sender {
    [self.manager POST:@"http://afnetworking.sinaapp.com/upload2server.json" parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        //1.向body里边追加一个数据,第一张图片
        NSData *data1=[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"1" ofType:@"jpg"]];
        [formData appendPartWithFileData:data1 name:@"image" fileName:@"zhangsan.jpg" mimeType:@"image/jpeg"];
        //2.追加第二张图片
        NSData *data2=[NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"2" ofType:@"jpg"]];
        [formData appendPartWithFileData:data2 name:@"image" fileName:@"lisi.jpg" mimeType:@"image/jpeg"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        //监听进度条
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //请求成功后返回
        NSLog(@"========%@",responseObject);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
       //失败时候调用
        NSLog(@"=====%@",error);
    }];
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
