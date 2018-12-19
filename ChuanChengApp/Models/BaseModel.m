//
//  BaseModel.m
//  ChuanChengApp
//
//  Created by liaoyu on 2018/11/23.
//  Copyright © 2018年 ChuanCheng. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    //todo
}
/* 根据数据字典返回model */
+ (id)modelWithDictionary:(NSDictionary *)dic {
    __strong Class model = [[[self class] alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
/* 根据json字符串返回model */
+ (id)modelwithJsonString:(NSString *)jsonStr{
    if(jsonStr==nil){
        return nil;
    }
    NSData *jsonData = [jsonStr dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic=[NSJSONSerialization JSONObjectWithData:jsonData
                                                     options:NSJSONReadingMutableContainers
                                                       error:&err];
    NSLog(@"解析结果：%@",dic);
    if(err)
    {
        NSLog(@"Json解析失败：%@",err);
        return  nil;
    }
    __strong Class model = [[[self class] alloc] init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}


@end
