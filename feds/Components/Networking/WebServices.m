//
//  WebServices.m
//  ADTenders
//
//  Created by TMC-4 on 2/1/16.
//  Copyright © 2016 The Apps Information Technology Company LLC. All rights reserved.
//


#import "WebServices.h"
#import <AFNetworking/AFNetworking.h>
#import "Feds-Swift.h"



@interface NSDictionary (BVJSONString)
-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint;
@end

@implementation NSDictionary (BVJSONString)

-(NSString*) bv_jsonStringWithPrettyPrint:(BOOL) prettyPrint {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions)    (prettyPrint ? NSJSONWritingPrettyPrinted : 0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"bv_jsonStringWithPrettyPrint: error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}
 @end



@implementation WebServices

+ (NSString *)baseUrl{
    return @"http://test.aramexnow.com";
}

+ (AFHTTPSessionManager *)manager {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"text/html" forHTTPHeaderField:@"Content-Type"];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    return manager;
}

+ (void)submitLoginData:(NSDictionary *)loginDict WithSuccess:(void (^)(id data))success
                failure:(void (^)(NSError *error))failure{
    
    
    NSString *urlComponent = @"/api/authenticate";
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",self.baseUrl,urlComponent];
    
    
    [[self manager] POST:urlString parameters:loginDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success! %@",responseObject);
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        //NSLog(@"error: %@", error);
        
        NSString* errResponse = [[NSString alloc] initWithData:(NSData *)error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:NSUTF8StringEncoding];
        NSLog(@"%@",errResponse);
        
        
        failure(error);
        
    }];
    
    
}

+ (void)requestCall:(NSDictionary *)requestCallDict WithSuccess:(void (^)(id data))success
            failure:(void (^)(NSError *error))failure {
    NSString *urlComponent = @"/api/requestcall";
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",self.baseUrl,urlComponent];
    
    NSLog(@"Register Dict : %@",requestCallDict);
    
    [[self manager] POST:urlString parameters:requestCallDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success! %@",responseObject);
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        
        
        
    }];

    
}


+ (void)submitRegisterData:(NSDictionary *)registerDict WithSuccess:(void (^)(id data))success
                   failure:(void (^)(NSError *error))failure {
    
    NSString *urlComponent = @"/api/register";
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",self.baseUrl,urlComponent];
    
    NSLog(@"Register Dict : %@",registerDict);
    
    [[self manager] POST:urlString parameters:registerDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success! %@",responseObject);
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        
    }];
    
}

+ (void)logout:(NSDictionary *)logoutDict WithSuccess:(void (^)(id data))success
       failure:(void (^)(NSError *error))failure{
    
    NSString *urlComponent = @"/api/logout";
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",self.baseUrl,urlComponent];
    
    NSLog(@"Logout Dict : %@",logoutDict);
    
    
    
    
    [[self manager] POST:urlString parameters:logoutDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success! %@",responseObject);
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        
        failure(error);
        
    }];
    
}


//

+(void)getDistance:(NSString *)source destination:(NSString *)destination WithSuccess:(void (^)(id data))success
            failure:(void (^)(NSError *error))failure{
    
    NSString *apiKey =  @"AIzaSyDS_2FBWDUP259-moM4etKEfJFe0jpd4fY";
    
    NSString *api = @"https://maps.googleapis.com/maps/api/distancematrix/json";
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@?origins=%@&destinations=%@&key=%@",api,source,destination,apiKey];
    
    NSLog(@"%@",urlString);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        success(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
    
}

+(void)getplaceName:(NSString *)latlong WithSuccess:(void (^)(id data))success
            failure:(void (^)(NSError *error))failure{
    
    NSString *apiKey =  @"AIzaSyAODUPrf6e6M9xflCqDUZdrW7RrWRx2Po0";
    
    NSString *api = @"https://maps.googleapis.com/maps/api/geocode/json";
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@?latlng=%@&key=%@&result_type=route",api,latlong,apiKey];
    
    NSLog(@"%@",urlString);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    
    
    
    
    manager.responseSerializer.acceptableContentTypes = [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    [manager GET:urlString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        
        success(responseObject);
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error.localizedDescription);
    }];
    
    
}

+(void)getPrice:(NSDictionary *)inputDict WithSuccess:(void (^)(id data))success
        failure:(void (^)(NSError *error))failure {
    
    NSString *urlComponent = @"/api/getprice";
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",self.baseUrl,urlComponent];
    
    NSLog(@"Logout Dict : %@",inputDict);
    
    
    
    
    [[self manager] POST:urlString parameters:inputDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success! %@",responseObject);
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        
        failure(error);
        
    }];
    
}

+(void)submitOrder:(NSDictionary *)inputDict WithSuccess:(void (^)(id data))success
           failure:(void (^)(NSError *error))failure {
    
    NSString *urlComponent = @"/api/requestorder";
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",self.baseUrl,urlComponent];
    
    NSLog(@"Input Dict : %@",inputDict);
    
    
    
    
    [[self manager] POST:urlString parameters:inputDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success! %@",responseObject);
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        
        failure(error);
        
    }];
    
}

+(void)getAllOrders:(NSDictionary *)inputDict WithSuccess:(void (^)(id data))success
            failure:(void (^)(NSError *error))failure{
    
    NSString *urlComponent = @"/api/getorders";
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@",self.baseUrl,urlComponent];
    
    NSLog(@"Input Dict : %@",inputDict);
    
    
    
    
    [[self manager] POST:urlString parameters:inputDict progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSLog(@"success! %@",responseObject);
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"error: %@", error);
        
        failure(error);
        
    }];
    
}

+(void)testService:(NSDictionary *)inputDict WithSuccess:(void (^)(id data))success
           failure:(void (^)(NSError *error))failure{
    
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //manager.requestSerializer = [AFJSONRequestSerializer serializerWithWritingOptions:0];
    
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager.responseSerializer.acceptableContentTypes setByAddingObject:@"text/html"];
    
    
    NSString *urlString = @"http://sandbox.aramexnow.com/api/requestorder?format=json";
    
    //NSString *urlString = @"http://localhost/json/json.php";
    
    NSDictionary *d1 = @{@"key1":@"value1",@"key2":@"value2"};
    NSArray *a1 = @[d1,d1,d1,d1];
    
    
    UIImage *img = [UIImage imageNamed:@"info"];
    NSData *imgData = UIImagePNGRepresentation(img);
    
    NSData* data = [ NSJSONSerialization dataWithJSONObject:a1 options:NSJSONWritingPrettyPrinted error:nil ];
    
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"%@",jsonString);
    
  
    

    NSDictionary *d2 = @{@"key3":jsonString};
    
    NSError *error = nil;
    
    data = [ NSJSONSerialization dataWithJSONObject:d2 options:0 error:nil ];
    jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                         options:NSJSONReadingAllowFragments
                                                           error:&error];
    

    
    [manager POST:urlString parameters:json constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        [formData appendPartWithFileData:imgData name:@"imagefile" fileName:@"info.png" mimeType:@"image/png"];
        
        
    } progress:nil success:^(NSURLSessionDataTask *task, id responseObject) {
        
        success(responseObject);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"Error: %@", error);
        failure(error);
    }];
    
    
}


@end
