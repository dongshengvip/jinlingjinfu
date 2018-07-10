//
//  NetworkManager.h
//  CloudCast
//
//  Created by apple on 15/11/24.
//  Copyright © 2015年 fuLiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>
//#import "MBProgressHUD+JY.h"
typedef NS_ENUM(NSUInteger, ResposeStyle) {
    JSON,
    XML,
    Data,
};

typedef NS_ENUM(NSUInteger, RequestStyle) {
    RequestJSON,
    RequestString,
    RequestDefault
};
typedef void(^CompleteBlock) (NSDictionary *requestDictionary);
typedef void(^FailBlock) (NSError *error);
typedef void (^uploadcompletionBlock)(NSURLResponse *response, id responseObject, NSError *error);
@interface NetworkManager : NSObject


/**
 *   启动网络操作以Get方式从远程服务器请求数据
 *
 *  @param urlString  远程服务器的地址
 *  @param parameters 接口参数集合（以键值对形式存储）
 *  @param success    服务器成功返回数据后的回调block
 *  @param failure    服务器响应失败后的回调block
 */
+(void)startNetworkRequestDataFromRemoteServerByGetMethodWithURLString:(NSString *)urlString withParameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *task, id responseObject))success
                                                               failure:(void (^)(NSURLSessionDataTask *task, NSError *error))failure;


/**
 *  启动网络操作以Post方式从远程服务器请求数据
 *
 *  @param urlString  远程服务器的地址
 *  @param parameters 接口参数集合（以键值对形式存储）
 *  @param success    服务器成功返回数据后的回调block
 *  @param failure    服务器响应失败后的回调block
 */
+(void)startNetworkRequestDataFromRemoteServerByPostMethodWithURLString:(NSString *)urlString withParameters:(NSDictionary *)parameters ShowHUD:(BOOL)show success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;
//上传图片
+ (void)updatePortraitImag:(UIImage *)img url:(NSString *)url mdic:(NSDictionary *)mdic name:(NSString *)name fileName:(NSString *)fileName success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

/**
 上传文件

 @param severURL 远程服务器的地址
 @param image 需要上传的数据
 @param completionBlock 返回数据后的回调block
 @return UploadTask
 */
+ (NSURLSessionUploadTask *)uploadTaskServerURL:(NSString *)severURL parameters:(NSDictionary *)parameters WithImage:(UIImage*)image completion:(void (^)(NSURLResponse *response, id responseObject, NSError *error))completionBlock;

/**
 上传文件

 @param url 远程服务器的地址
 @param parameters 接口参数集合（以键值对形式存储）
 @param fileData 需要上传的数据
 @param name 数据名
 @param fileName 文件名
 @param mimeType 类型
 @param style 格式
 @param progress 进度
 @param success 服务器成功返回数据后的回调block
 @param failure 服务器响应失败后的回调block
 */
+ (void)upLoadToUrlString:(NSString *)url parameters:(NSDictionary *)parameters fileData:(NSData *)fileData name:(NSString *)name fileName:(NSString *)fileName mimeType:(NSString *)mimeType response:(ResposeStyle)style progress:(void (^)(NSProgress *))progress success:(void (^)(NSURLSessionDataTask *task, id responseObject))success failure:(void (^)(NSURLSessionDataTask * task, NSError *error))failure;

/**
 *  下载文件
 *
 *  @param serverURL             文件的服务器路径
 *  @param downloadProgressBlock 下载进度block
 *  @param destination           文件在本地的路径
 *  @param completionHandler     下载完成时block
 */
+(void)downloadFileFromServerURL:(NSString *)serverURL progress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock destination:(NSURL * (^)(NSURL *targetPath, NSURLResponse *response))destination completionHandler:(void (^)(NSURLResponse *response, NSURL *filePath, NSError *error))completionHandler;

/**
 *  判断网络是否存在
 *
 *  @param block 判断结束后的回调block
 */
+(void)isNetworkingRunningFinishedBlock:(void (^)(BOOL running))block;

//+(void)uploadImageDataByPostMethodWithURLString:(NSString *)urlString withParameters:(NSDictionary *)parameters success:(void (^)(NSURLSessionDataTask *, id))success failure:(void (^)(NSURLSessionDataTask *, NSError *))failure;
@end
