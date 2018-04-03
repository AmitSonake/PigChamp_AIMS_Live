//
//  ServerManager.h
//  QuicHotels
//
//  Created by Riyaz Lakhani on 27/11/14.
//  Copyright (c) 2014 Quicsolv Technologies Pvt. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerManager : NSObject<NSURLConnectionDataDelegate,NSXMLParserDelegate>
{
    NSMutableData *webData;
    NSXMLParser *xmlParser;
    NSString *currentElement;

}

+ (void)sendRequestForLanguageList:(void (^)(NSString *responseData))success onFailure:(void (^) (NSString *responseData, NSError *error))failure;
+ (void)sendRequestForLogin:(NSString*)userName password:(NSString*)password language:(NSString*)language  onSucess:(void (^)(NSString *responseData))success onFailure:(void (^) (NSMutableDictionary *responseData, NSError *error))failure;
+ (void)sendRequestForGetmasterData:(void (^)(NSString *responseData))success onFailure:(void (^) (NSString *responseData, NSError *error))failure;
+ (void)sendRequestForSysLookup:(void (^)(NSString *responseData))success onFailure:(void (^) (NSString *responseData, NSError *error))failure;
+ (void)sendRequestForFarmSelection:(NSString*)siteId onSucess:(void (^)(NSString *responseData))success onFailure:(void (^) (NSString *responseData, NSError *error))failure;
+ (void)sendRequestForLogout:(void (^)(NSString *responseData))success onFailure:(void (^) (NSString *responseData, NSError *error))failure;
+ (void)sendRequestEvent:(NSString*)url idOfServiceUrl:(NSData*)data methodType:(NSString*)methodType onSucess:(void (^)(NSString *responseData))success onFailure:(void (^) (NSString *responseData, NSError *error))failure;
+ (void)sendRequest:(NSString*)url idOfServiceUrl:(NSInteger)idOfServiceUrl headers:(NSMutableDictionary*)headers methodType:(NSString*)methodType onSucess:(void (^)(NSString *responseData))success onFailure:(void (^) (NSMutableDictionary *responseData, NSError *error))failure;


@end
