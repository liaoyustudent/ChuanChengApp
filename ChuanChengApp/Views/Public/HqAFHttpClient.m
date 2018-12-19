#import "HqAFHttpClient.h"
#import "Constant.h"
@implementation HqAFHttpClient

+(AFHTTPSessionManager *)shareOperationManager
{
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
    });
    return manager;
}
+ (void)starRequestWithHeaders:(NSDictionary *)headers
                 withURLString:(NSString *)urlString
                     withParam:(NSDictionary *)param
             requestIsNeedJson:(BOOL)reqIsNeed
            responseIsNeedJson:(BOOL)respIsNeed
                        method:(RequestMethod)method
               wihtCompleBlock:(HqHttpRequestCompleteBlock)block
{
    AFHTTPSessionManager  *manager = [self initMangerWithHeaders:headers requestIsNeedJson:reqIsNeed responseIsNeedJson:respIsNeed];
    
    NSString *url = [NSString stringWithFormat:@"%@%@",SERVSER_URL,urlString];
    
    if ([urlString hasPrefix:@"http"]) {
        url = urlString;
    }
    
    switch (method) {
        case Get:
        {
            NSLog(@"Get");
            [manager GET:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                [self requestSueccesResult:response withResponseObject:responseObject wihtCompleBlock:block];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                NSLog(@"error = %@",error);
                
                [self requestFailResult:response wihtCompleBlock:block];
                
            }];
        }
            break;
            
        case Post:
        {
            NSLog(@"Post");
            
            [manager POST:url parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                [self requestSueccesResult:response withResponseObject:responseObject wihtCompleBlock:block];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error = %@",error);
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                [self requestFailResult:response wihtCompleBlock:block];
            }];
        }
            break;
        case Put:
        {
            NSLog(@"Put");
            
            [manager PUT:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                [self requestSueccesResult:response withResponseObject:responseObject wihtCompleBlock:block];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                [self requestFailResult:response wihtCompleBlock:block];
            }];
        }
            break;
            
        case Delete:
        {
            NSLog(@"delete");
            [manager DELETE:url parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                [self requestSueccesResult:response withResponseObject:responseObject wihtCompleBlock:block];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"error = %@",error);
                NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                [self requestFailResult:response wihtCompleBlock:block];
                
            }];
        }
            break;
            
            
        default:
            break;
    }
    NSLog(@"url==%@",url);
}
+ (AFHTTPSessionManager *)initMangerWithHeaders:(NSDictionary *)headers
                              requestIsNeedJson:(BOOL)reqIsNeed
                             responseIsNeedJson:(BOOL)respIsNeed
{
    AFHTTPSessionManager *manager = [self shareOperationManager];
    if (reqIsNeed)
    {
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
    }
    else
    {
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    }
    
    
    if (respIsNeed)
    {
        manager.responseSerializer = [AFJSONResponseSerializer serializer];
    }
    else
    {
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    }
    if (headers)
    {
        [headers enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            [manager.requestSerializer setValue:obj forHTTPHeaderField:key];
        }];
    }
    
    /*NSString *token = GetUserDefault(kToken);
    if (token.length > 0) {
        [manager.requestSerializer setValue:token forHTTPHeaderField:@"x-access-token"];
    }*/
    NSLog(@"responseSerializer =%@",manager.requestSerializer.class);
    
    //    NSLog(@"header =%@",manager.requestSerializer.HTTPRequestHeaders);
    return manager;
}
+ (void)cancelRequest
{
    [[self shareOperationManager].operationQueue cancelAllOperations];
}
+ (void)requestSueccesResult:(NSHTTPURLResponse *)response
          withResponseObject:(id)responseObject
             wihtCompleBlock:(HqHttpRequestCompleteBlock)block
{
    NSLog(@"http-statusCode == %d",(int)response.statusCode);
    if ([responseObject isKindOfClass:[NSDictionary class]])
    {
        block(response,responseObject);
    }
    else
    {
        //返回的是二进制数据
        if ([response isKindOfClass:[NSData class]])
        {
            id resp = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            block(response,resp);
        }
        else
        {
            block(response,responseObject);
        }
    }
    
}
+ (void)requestFailResult:(NSHTTPURLResponse *)response
          wihtCompleBlock:(HqHttpRequestCompleteBlock)block
{
    NSLog(@"http-statusCode == %d",(int)response.statusCode);
    
    block(response,nil);
}

@end
