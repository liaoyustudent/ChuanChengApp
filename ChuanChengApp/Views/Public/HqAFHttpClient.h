#import <Foundation/Foundation.h>
#import "AFNetworking.h"
#import <UIKit/UIKit.h>
typedef NS_ENUM(int,RequestMethod){
    Get =1,
    Post,
    Put,
    Delete
};
typedef void (^HqHttpRequestCompleteBlock) (NSHTTPURLResponse *response, id responseObject);
@interface HqAFHttpClient : NSObject


/**
 发起一个请求
 
 @param headers 头信息
 @param urlString api地址
 @param param 请求参数
 @param reqIsNeed 请求参数是否为json格式
 @param respIsNeed 返回参数是否为json格式
 @param method 请求方式
 @param block 请求结果Block
 */
+ (void)starRequestWithHeaders:(NSDictionary *)headers withURLString:(NSString *)urlString withParam:(NSDictionary *)param requestIsNeedJson:(BOOL)reqIsNeed responseIsNeedJson:(BOOL)respIsNeed method:(RequestMethod)method wihtCompleBlock:(HqHttpRequestCompleteBlock)block;

/**
 取消一个请求
 */
+ (void)cancelRequest;

@end

