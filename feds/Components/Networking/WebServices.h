//
//  WebServices.h
//  ADTenders
//
//  Created by TMC-4 on 2/1/16.
//  Copyright © 2016 The Apps Information Technology Company LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DeliveryAddress;

@class UserInfo;




@interface WebServices : NSObject



+ (void)submitLoginData:(NSDictionary *)loginDict WithSuccess:(void (^)(id data))success
               failure:(void (^)(NSError *error))failure;

+ (void)submitRegisterData:(NSDictionary *)loginDict WithSuccess:(void (^)(id data))success
                   failure:(void (^)(NSError *error))failure;

+ (void)logout:(NSDictionary *)logoutDict WithSuccess:(void (^)(id data))success
       failure:(void (^)(NSError *error))failure;

+ (void)requestCall:(NSDictionary *)requestCallDict WithSuccess:(void (^)(id data))success
       failure:(void (^)(NSError *error))failure;

+(void)getDistance:(NSString *)source destination:(NSString *)destination WithSuccess:(void (^)(id data))success
           failure:(void (^)(NSError *error))failure;

+(void)getplaceName:(NSString *)latlong WithSuccess:(void (^)(id data))success
            failure:(void (^)(NSError *error))failure;

+(void)getPrice:(NSDictionary *)inputDict WithSuccess:(void (^)(id data))success
            failure:(void (^)(NSError *error))failure;

+(void)submitOrder:(NSDictionary *)inputDict WithSuccess:(void (^)(id data))success
           failure:(void (^)(NSError *error))failure;

+(void)getAllOrders:(NSDictionary *)inputDict WithSuccess:(void (^)(id data))success
           failure:(void (^)(NSError *error))failure;

+(void)testService:(NSDictionary *)inputDict WithSuccess:(void (^)(id data))success
            failure:(void (^)(NSError *error))failure;

@end
