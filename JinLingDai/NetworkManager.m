//
//  NetworkManager.m
//  CloudCast
//
//  Created by apple on 15/11/24.
//  Copyright © 2015年 fuLiang. All rights reserved.
//

#import "NetworkManager.h"
#import "AppDelegate.h"
//#import "UIDevice+Addition.h"
#import "AFHTTPSessionManager+AddNetKey.h"
#import "MBProgressHUD+NetWork.h"
#import <YYKit.h>
@implementation NetworkManager


#define TimeOut 5
#define NOT_RUNNING_NETWORK @"网络未连接，请设置网络"


#pragma mark - get 请求网络数据

+(void)startNetworkRequestDataFromRemoteServerByGetMethodWithURLString:(NSString *)urlString withParameters:(id)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
            [MBProgressHUD showNetworkIndicator];
            AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//            [manager.requestSerializer setValue:[self restEcName] forHTTPHeaderField:@"Restecname"];
            manager.requestSerializer.timeoutInterval = TimeOut;
            [manager GET:urlString parameters:parameters progress:^(NSProgress *progress){
                
            } success:^(NSURLSessionDataTask *task, id responseObject){
                [MBProgressHUD hideNetworkIndicator];
                success(task,responseObject);
                NSLog(@"调用接口_____%@   %@",urlString,parameters);
                NSLog(@"返回数据_____%@",responseObject);
            } failure:^(NSURLSessionDataTask *task, NSError * error){
                NSLog(@"调用接口_____%@   %@",urlString,parameters);
                [MBProgressHUD hideNetworkIndicator];
                failure(task,error);
            }];
        
}

#pragma mark - post 请求网络数据

+(void)startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:(NSString *)urlString withParameters:(NSDictionary *)parameters ShowHUD:(BOOL)show success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
//    UIWindow *window = [[[UIApplication sharedApplication]delegate] window];
 urlString = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSMutableDictionary *mdic = [NSMutableDictionary dictionaryWithDictionary:(NSDictionary *)parameters];
    MBProgressHUD *hud;
    if (show) {
        hud = [MBProgressHUD createHUD];
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud showAnimated:YES];
        });
    }
//    if (mdic[@"token"]) {
//        [mdic setObject:mdic[@"token"] forKey:@"uid"];
//        [mdic removeObjectForKey:@"token"];
//    }
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];


    [manager addNetKey];
    [manager POST:urlString parameters:mdic progress:^(NSProgress *progress){
    
    } success:^(NSURLSessionDataTask *task, id responseObject){
        
        NSError *err = nil;
        id obj = responseObject;
        if ([responseObject isKindOfClass:[NSData class]]) {
            obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:&err];
            if (!obj) {
                //如果不能解析成dictionary、array， 就按string来解析
                obj = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            }
        }
        
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"status"] integerValue] != 200) {
                if ([obj[@"status"] integerValue] == 101) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:UserLogout object:nil];
                    if (!show) {
                        [MBProgressHUD showError:obj[@"message"]];
                    }
                }
                
               if (show) {
                    hud.detailsLabel.text = obj[@"message"];
                    // 设置图片
                    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
                    // 再设置模式
                    hud.mode = MBProgressHUDModeCustomView;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud showAnimated:NO];
                        [hud hideAnimated:YES afterDelay:1.5f];
                    });
                }
                
            }else{
                if (show) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES];
                    });
                }
            }
        }else{
            obj = @{};
            if (show) {
                hud.label.text = @"后台数据错误";
                // 设置图片
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
                // 再设置模式
                hud.mode = MBProgressHUDModeCustomView;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud showAnimated:NO];
                    [hud hideAnimated:YES afterDelay:1.f];
                });
            }
        }
        success(task,obj);
    } failure:^(NSURLSessionDataTask *task, NSError * error){
        if (show) {
            hud.label.text = @"网络出小差了";
            // 设置图片
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
            // 再设置模式
            hud.mode = MBProgressHUDModeCustomView;
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud showAnimated:NO];
                [hud hideAnimated:YES afterDelay:1.f];
            });
        }
        
        failure(task,error);
    }];

}
//现用的上传
+ (void)updatePortraitImag:(UIImage *)img url:(NSString *)url mdic:(NSDictionary *)mdic name:(NSString *)name fileName:(NSString *)fileName success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure{
    
    MBProgressHUD *hud;
    hud = [MBProgressHUD createHUD];
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud showAnimated:YES];
    });
    
//    NSDictionary *mdic = @{@"token":[UserManager shareManager].userId};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    [manager addNetKey];
    [manager POST:url
       parameters:mdic
constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (img) {
          [formData appendPartWithFileData:UIImageJPEGRepresentation(img, 0.6) name:name fileName:fileName mimeType:@"image/png"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSError *err = nil;
        id obj = responseObject;
        if ([responseObject isKindOfClass:[NSData class]]) {
            obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:&err];
            if (!obj) {
                //如果不能解析成dictionary、array， 就按string来解析
                obj = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
            }
        }
        if ([obj isKindOfClass:[NSDictionary class]]) {
            if ([obj[@"status"] integerValue] == 101) {
                [[NSNotificationCenter defaultCenter] postNotificationName:UserLogout object:nil];
                [MBProgressHUD showError:obj[@"message"]];
            }else if ([obj[@"status"] integerValue] != 200) {
                hud.label.text = obj[@"message"];
                // 设置图片
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
                // 再设置模式
                hud.mode = MBProgressHUDModeCustomView;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud showAnimated:NO];
                    [hud hideAnimated:YES afterDelay:1.5f];
                });
            }else{
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud hideAnimated:YES];
                });
            }
            success(task,obj);
        }else{
            obj = @{};
            hud.label.text = @"网络故障，请稍后再试";
            // 设置图片
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
            // 再设置模式
            hud.mode = MBProgressHUDModeCustomView;
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud showAnimated:NO];
                [hud hideAnimated:YES afterDelay:1.5f];
            });
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        hud.label.text = @"提交失败，请稍后再试";
        // 设置图片
        hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud showAnimated:NO];
            [hud hideAnimated:YES afterDelay:1.5f];
        });
        failure(task,error);
    }];
}

+ (void)upLoadToUrlString:(NSString *)url parameters:(NSDictionary *)parameters fileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType response:(ResposeStyle)style progress:(void (^)(NSProgress *))progress success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure{
    //1.获取单例的网络管理对象
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    //2.根据style 的类型 去选择返回值得类型
    switch (style) {
        case JSON:
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        case XML:
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        case Data:
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        default:
            break;
    }
    
    //3.设置相应数据支持的类型
    [manager.responseSerializer setAcceptableContentTypes:[NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html",@"text/css",@"text/plain", @"application/javascript",@"application/json", @"application/x-www-form-urlencoded", nil]];
    
    [manager POST:url parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        [formData appendPartWithFileData:fileData name:name fileName:fileName mimeType:mimeType];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        if (success) {
            success(task,responseObject);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(task,error);
        }
    }];
}



#pragma mark - 上传文件

+ (NSURLSessionUploadTask*)uploadTaskServerURL:(NSString *)severURL parameters:(NSDictionary *)parameters WithImage:(UIImage *)image completion:(void (^)(NSURLResponse *, id, NSError *))completionBlock {
    
    MBProgressHUD *hud;
    hud = [MBProgressHUD createHUD];
    dispatch_async(dispatch_get_main_queue(), ^{
        [hud showAnimated:YES];
    });
    
    // 构造 NSURLRequest
    NSError* error = NULL;
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:severURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSData* imageData = UIImageJPEGRepresentation(image, 0.6);

        [formData appendPartWithFileData:imageData name:@"image" fileName:@"img.png" mimeType:@"image/png"];
    } error:&error];
    
    // 可在此处配置验证信息
    
    // 将 NSURLRequest 与 completionBlock 包装为 NSURLSessionUploadTask
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json",  @"text/javascript",@"text/html", nil];
    //加密
    NSString *uuid = [[NSUUID UUID] UUIDString];
    NSString *curTime = [NSString stringWithFormat:@"%@",@((long)[[NSDate date] timeIntervalSince1970])];
    NSString *CheckSum = [NSString stringWithFormat:@"8781eaf0d41e15a6cb128bd2834487bc%@%@",uuid,curTime];
    //    CheckSum sha1String
    [manager.requestSerializer setValue:@"89c3fac0f934" forHTTPHeaderField:@"APPKEY"];
    [manager.requestSerializer setValue:uuid  forHTTPHeaderField:@"MD5"];
    [manager.requestSerializer setValue:curTime forHTTPHeaderField:@"CURTIME"];
    [manager.requestSerializer setValue:[CheckSum sha1String] forHTTPHeaderField:@"ChECKSUM"];
    
    NSURLSessionUploadTask *uploadTask = [manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (error) {
            hud.label.text = @"提交失败，请稍后再试";
            // 设置图片
            hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
            // 再设置模式
            hud.mode = MBProgressHUDModeCustomView;
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud showAnimated:NO];
                [hud hideAnimated:YES afterDelay:1.5f];
            });
            completionBlock(response,@{},error);
        }else{
            NSError *err = nil;
            id obj = responseObject;
            if ([responseObject isKindOfClass:[NSData class]]) {
                obj = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableLeaves|NSJSONReadingMutableContainers error:&err];
                if (!obj) {
                    //如果不能解析成dictionary、array， 就按string来解析
                    obj = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
                }
            }
            if ([obj isKindOfClass:[NSDictionary class]]) {
                if ([obj[@"status"] integerValue] == 101) {
                    [[NSNotificationCenter defaultCenter] postNotificationName:UserLogout object:nil];
                    [MBProgressHUD showError:obj[@"message"]];
                }else if ([obj[@"status"] integerValue] != 200) {
                    hud.label.text = obj[@"message"];
                    // 设置图片
                    hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
                    // 再设置模式
                    hud.mode = MBProgressHUDModeCustomView;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud showAnimated:NO];
                        [hud hideAnimated:YES afterDelay:1.5f];
                    });
                }else{
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hideAnimated:YES];
                    });
                }
            }else{
                obj = @{};
                hud.label.text = @"网络故障，请稍后再试";
                // 设置图片
                hud.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"error"]];
                // 再设置模式
                hud.mode = MBProgressHUDModeCustomView;
                dispatch_async(dispatch_get_main_queue(), ^{
                    [hud showAnimated:NO];
                    [hud hideAnimated:YES afterDelay:1.5f];
                });
            }
            completionBlock(response,obj,error);
        }
    }];
    
    return uploadTask;
}

//+(void)uploadFileToServerURL:(NSString *)severURL withFilePath:(NSString *)filePath  withParameters:(NSDictionary *)parameters  progress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
//           completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
//{
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:@"POST" URLString:severURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
//        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"file" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
//    } error:nil];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    
//    NSURLSessionUploadTask *uploadTask;
//    uploadTask = [manager
//                  uploadTaskWithStreamedRequest:request
//                  progress:^(NSProgress * _Nonnull uploadProgress) {
//                    
//                      uploadProgressBlock(uploadProgress);
//                  }
//                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//                    
//                      completionHandler(response,responseObject,error);
//                      
//                  }];
//    
//    [uploadTask resume];
//}

//+(void)uploadLuYinFileToServerURL:(NSString *)severURL withFilePath:(NSString *)filePath withParameters:(NSDictionary *)parameters  progress:(void (^)(NSProgress *uploadProgress)) uploadProgressBlock
//           completionHandler:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionHandler
//{
//    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer]multipartFormRequestWithMethod:@"POST" URLString:severURL parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData> formData){
//        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:@"suffix" fileName:@"filename.jpg" mimeType:@"image/jpeg" error:nil];
//    } error:nil];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    
//    NSURLSessionUploadTask *uploadTask;
//    uploadTask = [manager
//                  uploadTaskWithStreamedRequest:request
//                  progress:^(NSProgress * _Nonnull uploadProgress) {
//                      
//                      uploadProgressBlock(uploadProgress);
//                  }
//                  completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//                      
//                      completionHandler(response,responseObject,error);
//                      
//                  }];
//    
//    [uploadTask resume];
//}


#pragma mark - 下载文件

+(void)downloadFileFromServerURL:(NSString *)serverURL progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;
{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //@"http://example.com/download.zip"
    NSURL *URL = [NSURL URLWithString:serverURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
   
    NSURLSessionDownloadTask *downloadTask = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress){
        
    } destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
        completionHandler(response,filePath,error);
    }];
    [downloadTask resume];
}


#pragma mark - 判断网络是否存在
+(void)isNetworkingRunningFinishedBlock:(void (^)(BOOL running))block
{
    [[AFNetworkReachabilityManager sharedManager]startMonitoring];
    [[AFNetworkReachabilityManager sharedManager]setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status){
        
        switch (status) {
            case AFNetworkReachabilityStatusNotReachable:
                block(NO);
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
                block(YES);
                break;
                
            case AFNetworkReachabilityStatusReachableViaWiFi:
                block(YES);
                break;
            default:
                break;
        }
        
    }];  
}


    
    
//+ (NSString *)restEcName{
//    //将 设备号+时间戳 放入请求头
//    NSMutableString *ecName = [NSMutableString string];
////    [ecName appendFormat:@"%@_%@", [[UIDevice currentDevice] uniqueDeviceGuid], [[UIDevice currentDevice] keyChainDeviceGuid]];
////    [ecName appendString:@","];
////    NSTimeInterval time = [[NSDate date] timeIntervalSince1970] * 100; //10毫秒级别
////    [ecName appendString:[NSString stringWithFormat:@"%.0f",time]];
////    NSData* plainData = [ecName dataUsingEncoding: NSUTF8StringEncoding];
////    NSData* encryptedData = [[Cipher shared] encrypt:plainData];
////    NSCharacterSet *charsToRemove = [NSCharacterSet characterSetWithCharactersInString:@" <>"];
////    NSString *hexRepresentation = [[encryptedData description] stringByTrimmingCharactersInSet:charsToRemove] ;
////    hexRepresentation = [hexRepresentation stringByReplacingOccurrencesOfString:@" " withString:@""];
////    return [hexRepresentation uppercaseString];
//    return ecName;
//}
@end
