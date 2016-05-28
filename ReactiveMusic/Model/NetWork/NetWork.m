//
//  NetWork.m
//  OrangeFrame
//
//  Created by user on 15/7/16.
//  Copyright (c) 2015年 Orange-W. All rights reserved.
//


#import "NetWork.h"



@implementation NetWork




#pragma 监测网络的可链接性
+ (BOOL) netWorkReachability:(NSString *) strUrl
{
    __block BOOL isReachability = NO;
    
    NSURL *baseURL = [NSURL URLWithString:strUrl];
    

    return isReachability;
}


/***************************************
 在这做判断如果有dic里有errorCode
 调用errorBlock(dic)
 没有errorCode则调用block(dic
 ******************************/

#pragma --mark GET请求方式
+ (void) netRequestGETWithRequestURL: (NSString *) requestURLString
                       WithParameter: (NSDictionary *) parameter
                WithReturnValeuBlock: (SucessWithJson) successFunction
                 // WithErrorCodeBlock: (ErrorCode) errorBlock
                    WithFailureBlock: (FailureFunction) failureFunction
{
    
    
    AFHTTPSessionManager *manger= [AFHTTPSessionManager manager];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
    NSURLSessionDataTask *task = [manger GET:requestURLString parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if(successFunction){
            successFunction(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if(failureFunction){
            failureFunction(error);
        }
    }];
    [task resume];

}

#pragma --mark POST请求方式

+ (void) netRequestPOSTWithRequestURL: (NSString *) requestURLString
                        WithParameter: (NSDictionary *) parameter
                 WithReturnValeuBlock: (SucessWithJson) successFunction
                   //WithErrorCodeBlock: (ErrorCode) errorBlock
                     WithFailureBlock: (FailureFunction) failureFunction
{
    AFHTTPSessionManager *manger= [AFHTTPSessionManager manager];
    manger.requestSerializer = [AFHTTPRequestSerializer serializer];
   
    manger.responseSerializer.acceptableContentTypes=[manger.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    //NSLog(@"%@",manger.responseSerializer.acceptableContentTypes);
    
    NSURLSessionDataTask *task = [manger POST:requestURLString parameters:parameter progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success>>>>>");
        if(successFunction){
            successFunction(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"failure>>>>>");
        if(failureFunction){
            failureFunction(error);
        }
    }];
    [task resume];
}




@end
