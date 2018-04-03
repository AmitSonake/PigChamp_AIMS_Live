
#import "ServerManager.h"
#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#import "CoreDataHandler.h"

static NSURLConnection *theConnection;
//NSString *baseUrl = NSLocalizedString(@"baseUrl" , @""); //@"http://192.168.20.40/PigchampWeb/"; //@"http://192.168.20.40/PigchampWeb/"; //@"http://rdstest.pigchamp.com/"; //192.168.33.20

@implementation ServerManager 
#pragma mark  -  requests

+(void)cancelSendRequest {
    [theConnection cancel];
}

//-----------------------------------------------------------------------------------------------------------------------------------------

+ (void)sendRequestForLogout:(void (^)(NSString *responseData))success onFailure:(void (^) (NSString *responseData, NSError *error))failure{
    @try{
        NSLog(@"token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]);
        NSString *serviceUrl = @"";
        serviceUrl = [[serviceUrl stringByAppendingString:NSLocalizedString(@"baseUrl" , @"")] stringByAppendingString:[NSString stringWithFormat:@"SrvAuthentication.svc/logout?token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]]];
        serviceUrl = [serviceUrl stringByRemovingPercentEncoding];
        
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
        NSURL *url = [NSURL URLWithString:serviceUrl];
        [request setURL:url];
        [request setHTTPMethod:@"GET"];
        NSData *requestBody = [@"" dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:requestBody];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            @try {
                NSString *myXMLResponse = [[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding:NSUTF8StringEncoding];
             
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                //failure([NSString stringWithFormat:@"%ld",(long)[httpResponse statusCode]], connectionError);
                long statusCodeResponse = (long)[httpResponse statusCode];

                NSString *strError = [NSString stringWithFormat:@"%@", [connectionError description]];
                if ([strError rangeOfString:@"Code=-1012"].location != NSNotFound) {
                    statusCodeResponse = 401;
                }

               //success(myXMLResponse);

                if(!connectionError) {
                    if (![myXMLResponse isEqualToString:@"\"Loged out\""] || [myXMLResponse isEqualToString:@""]){
                       [[NSNotificationCenter defaultCenter]postNotificationName:@"CloseAlert" object:myXMLResponse];
                    }
                    
                    success(myXMLResponse);
                }
                else {
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"CloseAlert" object:[NSString stringWithFormat:@"%ld",statusCodeResponse]];
                    failure([NSString stringWithFormat:@"%ld",statusCodeResponse], connectionError);
                }
            }
            @catch (NSException *exception) {
                failure(@"Error Occured", connectionError);
            }}];
    }
    @catch (NSException *exception) {
        
    }
}

//+ (void)sendRequestForLogin:(NSString*)selectedSiteId onSucess:(void (^)(NSString *responseData))success onFailure:(void (^) (NSString *responseData, NSError *error))failure
//{
//    @try
//    {
//        NSString *serviceUrl = @"";
//        serviceUrl = [[[serviceUrl stringByAppendingString:baseUrl] stringByAppendingString:@"SrvAuthentication.svc/setFarm/?"] stringByAppendingString:[NSString stringWithFormat:@"FarmId=%@&token=%@",selectedSiteId,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]]];
//        
//        serviceUrl = [serviceUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
//        serviceUrl = [serviceUrl stringByRemovingPercentEncoding];
//
//        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
//        NSURL *url = [NSURL URLWithString:serviceUrl];
//        [request setURL:url];
//        [request setHTTPMethod:@"GET"];
//        NSData *requestBody = [@"" dataUsingEncoding:NSUTF8StringEncoding];
//        [request setHTTPBody:requestBody];
//        
//        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
//            @try
//            {
//                NSString *myXMLResponse = [[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding:NSUTF8StringEncoding];
//                
//                if(!connectionError)
//                {
//                    success(myXMLResponse);
//                }
//                else
//                {
//                    failure(myXMLResponse, connectionError);
//                }
//            }
//            @catch (NSException *exception)
//            {
//                failure(@"Error Occured", connectionError);
//            }}];
//    }
//    @catch (NSException *exception)
//    {
//    }
//}

+ (void)sendRequestForSysLookup:(void (^)(NSString *responseData))success onFailure:(void (^) (NSString *responseData, NSError *error))failure
{
    @try{
        NSString *serviceUrl = @"";
        serviceUrl = [[serviceUrl stringByAppendingString:NSLocalizedString(@"baseUrl" , @"")] stringByAppendingString:[NSString stringWithFormat:@"SrvLookups.svc/getSysLookups?token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]]];
        
        serviceUrl = [serviceUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
        NSURL *url = [NSURL URLWithString:serviceUrl];
        [request setURL:url];
        [request setHTTPMethod:@"GET"];
        NSData *requestBody = [@"" dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:requestBody];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            @try {
                NSString *myXMLResponse = [[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding:NSUTF8StringEncoding];
                
                if(!connectionError) {
                    success(myXMLResponse);
                }
                else {
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                    long statusCodeResponse = (long)[httpResponse statusCode];
                    
                    NSString *strError = [NSString stringWithFormat:@"%@", [connectionError description]];
                    if ([strError rangeOfString:@"Code=-1012"].location != NSNotFound) {
                        statusCodeResponse = 401;
                    }
                    
                    failure([NSString stringWithFormat:@"%ld",(long)statusCodeResponse], connectionError);
                }
            }
            @catch (NSException *exception) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                long statusCodeResponse = (long)[httpResponse statusCode];
                
                NSString *strError = [NSString stringWithFormat:@"%@", [connectionError description]];
                if ([strError rangeOfString:@"Code=-1012"].location != NSNotFound) {
                    statusCodeResponse = 401;
                }
                
                failure([NSString stringWithFormat:@"%ld",(long)statusCodeResponse], connectionError);
            }}];
    }
    @catch (NSException *exception){
    }
}

+ (void)sendRequestForGetmasterData:(void (^)(NSString *responseData))success onFailure:(void (^) (NSString *responseData, NSError *error))failure
{
    @try {
        NSString *serviceUrl = @"";
        serviceUrl = [[serviceUrl stringByAppendingString:NSLocalizedString(@"baseUrl" , @"")] stringByAppendingString:[NSString stringWithFormat:@"SrvLookups.svc/getMasterData?token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]]];
        
        serviceUrl = [serviceUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
        NSURL *url = [NSURL URLWithString:serviceUrl];
        [request setURL:url];
        [request setHTTPMethod:@"GET"];
        NSData *requestBody = [@"" dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:requestBody];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            @try
            {
                NSString *myXMLResponse = [[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding:NSUTF8StringEncoding];
                
                if(!connectionError){
                    success(myXMLResponse);
                }
                else{
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                    long statusCodeResponse = (long)[httpResponse statusCode];
                    
                    NSString *strError = [NSString stringWithFormat:@"%@", [connectionError description]];
                    if ([strError rangeOfString:@"Code=-1012"].location != NSNotFound) {
                        statusCodeResponse = 401;
                    }
                    
                    failure([NSString stringWithFormat:@"%ld",(long)statusCodeResponse], connectionError);
                }
            }
            @catch (NSException *exception){
                failure(@"Error Occured", connectionError);
            }}];
    }
    @catch (NSException *exception){
    }
}

+ (void)sendRequestForLanguageList:(void (^)(NSString *responseData))success onFailure:(void (^) (NSString *responseData, NSError *error))failure {
    @try{
        NSString *serviceUrl = @"";
         serviceUrl = [[serviceUrl stringByAppendingString:NSLocalizedString(@"baseUrl" , @"")] stringByAppendingString:@"SrvLookups.svc/getLanguageslist"];
        
		serviceUrl = [serviceUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        //NSString *string = [NSString stringWithFormat:@"%@", serviceUrl];
        
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
        NSURL *url = [NSURL URLWithString:serviceUrl];
        [request setURL:url];
        [request setHTTPMethod:@"GET"];
        NSData *requestBody = [@"" dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:requestBody];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            @try {
                NSString *myXMLResponse = [[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding:NSUTF8StringEncoding];
               
                if(!connectionError) {
                    success(myXMLResponse);
                }
                else{
                    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                    long statusCodeResponse = (long)[httpResponse statusCode];
                    
                    NSString *strError = [NSString stringWithFormat:@"%@", [connectionError description]];
                    if ([strError rangeOfString:@"Code=-1012"].location != NSNotFound) {
                        statusCodeResponse = 401;
                    }
                    
                    failure([NSString stringWithFormat:@"%ld",(long)statusCodeResponse], connectionError);
                }
            }
            @catch (NSException *exception)
            {
                failure(@"Error Occured", connectionError);
            }}];
    }
    @catch (NSException *exception) {
        
    }
}

+ (void)sendRequestForLogin:(NSString*)userName password:(NSString*)password language:(NSString*)language  onSucess:(void (^)(NSString *responseData))success onFailure:(void (^) (NSMutableDictionary *responseData, NSError *error))failure
{
    @try{
        NSString *udid = [[[UIDevice currentDevice] identifierForVendor] UUIDString];
        NSString * appBuildString = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleVersion"];
        NSString *deviceType;
        struct utsname systemInfo;
        uname(&systemInfo);
        
        deviceType = [NSString stringWithCString:systemInfo.machine
                                        encoding:NSUTF8StringEncoding];
        NSLog(@"udid=%lu",(unsigned long)udid.length);
        //
        NSString *serviceUrl = @"";
        serviceUrl = [[[serviceUrl stringByAppendingString:NSLocalizedString(@"baseUrl" , @"")] stringByAppendingString:@"SrvAuthentication.svc/auth/?"] stringByAppendingString:[NSString stringWithFormat:@"lang=%@&uname=%@&pass=%@&mobileDeviceID=%@&mobileDeviceType=%@&mobileAppVersion=%@",language,userName,password,udid,deviceType,appBuildString]];
        
        serviceUrl = [serviceUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        NSURL *url = [NSURL URLWithString:serviceUrl];
        [request setURL:url];
        [request setHTTPMethod:@"GET"];
        NSData *requestBody = [@"" dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:requestBody];
        
        //        serviceUrl = [[serviceUrl stringByAppendingString:baseUrl] stringByAppendingString:@"SrvAuthentication.svc/auth/?"];
        //        NSString *post = [@"" stringByAppendingString:[NSString stringWithFormat:@"lang=%@&uname=%@&pass=%@&mobileDeviceID=%@&mobileDeviceType=%@&mobileAppVersion=%@",language,userName,password,udid,deviceType,appBuildString]];
        //        NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
        //        NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
        //
        //        [request setURL:[NSURL URLWithString:serviceUrl]];
        //        [request setHTTPMethod:@"GET"];
        //        [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
        //
        //        [request setValue:language forHTTPHeaderField:@"lang"];
        //        [request setValue:userName forHTTPHeaderField:@"uname"];
        //        [request setValue:password forHTTPHeaderField:@"pass"];
        //        [request setValue:udid forHTTPHeaderField:@"mobileDeviceID"];
        //        [request setValue:deviceType forHTTPHeaderField:@"mobileDeviceType"];
        //        [request setValue:appBuildString forHTTPHeaderField:@"mobileAppVersion"];
        //        [request setHTTPBody:postData];
        
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            @try {
                NSString *myXMLResponse = [[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding:NSUTF8StringEncoding];
                
                NSLog(@"loginresponse:%@",myXMLResponse);
                
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                long statusCodeResponse = (long)[httpResponse statusCode];
                
                if(statusCodeResponse==200){
                    success(myXMLResponse);
                }
                else {
                    NSString *strError = [NSString stringWithFormat:@"%@", [connectionError description]];
                    
                    NSString *strServerErr,*strTimeout;
                    strServerErr  = NSLocalizedString(@"ServerErr" , @"") ;
                    strTimeout = NSLocalizedString(@"Request Timeout error." , @"");
                    
                    NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"Request Timeout error." , @""),NSLocalizedString(@"ServerErr",@""),nil]];
                    
                    NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
                    
                    if (resultArray1.count!=0) {
                        for (int i=0; i<resultArray1.count; i++) {
                            [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                        }
                        
                        for (int i=0; i<2; i++) {
                            if (i==0){
                                if ([dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]] && ![[dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]] isKindOfClass:[NSNull class]]) {
                                    if ([[dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]] length]>0) {
                                        strTimeout = [dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]]?[dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]]:@"";
                                    }
                                }
                            }else  if (i==1){
                                if ([dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]] && ![[dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]] isKindOfClass:[NSNull class]]) {
                                    if ([[dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]] length]>0) {
                                        strServerErr = [dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]]?[dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]]:@"";
                                    }
                                }
                            }
                        }
                    }
                    
                    NSMutableDictionary *dict= [[NSMutableDictionary alloc]init];
                    
                        if (statusCodeResponse == 401) {
                            [dict setValue:@"401" forKey:@"code"];
                            failure(dict, connectionError);
                        }else if (statusCodeResponse == 408) {
                            
                            [dict setValue:strTimeout forKey:@"Error"];
                            [dict setValue:@"408" forKey:@"code"];
                            
                            failure(dict, connectionError);
                        }
//                        else if (statusCodeResponse != 0) {
//                            [dict setValue:[NSString stringWithFormat:@"%ld",statusCodeResponse] forKey:@"code"];
//                            failure(dict, connectionError);
//                        }
                        else {
                            [dict setValue:strServerErr forKey:@"Error"];
                            failure(dict, connectionError);
                        }
                }
            }
            @catch (NSException *exception){
                failure(@"Error Occured", connectionError);
            }}];
    }
    @catch (NSException *exception) {
    }
}

+ (void)sendRequestForFarmSelection:(NSString*)siteId onSucess:(void (^)(NSString *responseData))success onFailure:(void (^) (NSString *responseData, NSError *error))failure
{
    @try {
        NSString *serviceUrl = @"";
        serviceUrl = [[[serviceUrl stringByAppendingString:NSLocalizedString(@"baseUrl" , @"")] stringByAppendingString:@"SrvAuthentication.svc/setFarm?"] stringByAppendingString:[NSString stringWithFormat:@"FarmId=%@&token=%@",siteId,[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]]];
        
        serviceUrl = [serviceUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        NSMutableURLRequest * request = [[NSMutableURLRequest alloc] init];
        NSURL *url = [NSURL URLWithString:serviceUrl];
        [request setURL:url];
        [request setHTTPMethod:@"GET"];
        NSData *requestBody = [@"" dataUsingEncoding:NSUTF8StringEncoding];
        [request setHTTPBody:requestBody];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            @try
            {
                NSString *myXMLResponse = [[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding:NSUTF8StringEncoding];
                
                if(!connectionError)
                {
                    success(myXMLResponse);
                }
                else {
                   // NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                   // long statusCodeResponse = (long)[httpResponse statusCode];
                    
                    NSString *strServerErr,*strTimeout;
                    strServerErr  = NSLocalizedString(@"Unexpected result from server, please try again." , @"") ;
                    strTimeout = NSLocalizedString(@"Request Timeout error." , @"");
                    
                    NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"Request Timeout error." , @""),NSLocalizedString(@"Unexpected result from server, please try again.",@""),nil]];
                    
                    NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
                    
                    if (resultArray1.count!=0){
                        for (int i=0; i<resultArray1.count; i++){
                            [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                        }
                        
                        for (int i=0; i<2; i++) {
                            if (i==0){
                                if ([dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]] && ![[dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]] isKindOfClass:[NSNull class]]) {
                                    if ([[dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]] length]>0) {
                                        strTimeout = [dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]]?[dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]]:@"";
                                    }
                                }
                            }else  if (i==1){
                                if ([dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]] && ![[dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]] isKindOfClass:[NSNull class]]) {
                                    if ([[dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]] length]>0) {
                                        strServerErr = [dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]]?[dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]]:@"";
                                    }
                                }
                            }
                        }
                    }
                    
                    
                    NSString *strError = [NSString stringWithFormat:@"%@", [connectionError description]];
                    if ([strError rangeOfString:@"Code=-1012"].location != NSNotFound) {
                        failure([NSString stringWithFormat:@"%d",401], connectionError);
                    }
                    else if ([strError rangeOfString:@"Code=-1001"].location != NSNotFound) {
                        failure(strTimeout, connectionError);
                    }else{
                        failure(strTimeout, connectionError);
                    }
                }
            }
            @catch (NSException *exception) {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                long statusCodeResponse = (long)[httpResponse statusCode];
                
                
                NSString *strServerErr,*strTimeout;
                strServerErr  = NSLocalizedString(@"ServerErr" , @"") ;
                strTimeout = NSLocalizedString(@"Request Timeout error." , @"");
                
                NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"Request Timeout error." , @""),NSLocalizedString(@"Unexpected result from server, please try again.",@""),nil]];
                
                NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
                
                if (resultArray1.count!=0){
                    for (int i=0; i<resultArray1.count; i++){
                        [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                    }
                    
                    for (int i=0; i<2; i++) {
                        if (i==0){
                            if ([dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]] && ![[dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]] isKindOfClass:[NSNull class]]) {
                                if ([[dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]] length]>0) {
                                    strTimeout = [dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]]?[dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]]:@"";
                                }
                            }
                        }else  if (i==1){
                            if ([dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]] && ![[dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]] isKindOfClass:[NSNull class]]) {
                                if ([[dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]] length]>0) {
                                    strServerErr = [dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]]?[dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]]:@"";
                                }
                            }
                        }
                    }
                }

                
                NSString *strError = [NSString stringWithFormat:@"%@", [connectionError description]];
                if ([strError rangeOfString:@"Code=-1012"].location != NSNotFound) {
                    statusCodeResponse = 401;
                }
                
                if (statusCodeResponse == 401) {
                    failure([NSString stringWithFormat:@"%ld",statusCodeResponse], connectionError);
                }else if (statusCodeResponse == 408) {
                    failure(strTimeout, connectionError);
                }else {
                    failure(strServerErr, connectionError);
                }

                //failure([NSString stringWithFormat:@"%ld",(long)statusCodeResponse], connectionError);
            }}];
    }
    @catch (NSException *exception){
        
    }
}

+ (void)sendRequestEvent:(NSString*)url idOfServiceUrl:(NSData*)data methodType:(NSString*)methodType onSucess:(void (^)(NSString *responseData))success onFailure:(void (^) (NSString *responseData, NSError *error))failure
{
    @try
    {
        NSString *serviceUrl = [NSLocalizedString(@"baseUrl" , @"") stringByAppendingString:url?url:@""];
        serviceUrl = [serviceUrl stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding];
        
        NSMutableURLRequest *request =  [NSMutableURLRequest requestWithURL:[NSURL URLWithString:serviceUrl]];
        [request setHTTPMethod:methodType];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:data];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            @try{
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                long statusCodeResponse = (long)[httpResponse statusCode];
                
                NSString *strError = [NSString stringWithFormat:@"%@", [connectionError description]];
                
                if ([strError rangeOfString:@"Code=-1012"].location != NSNotFound) {
                    statusCodeResponse = 401;
                }else if ([strError rangeOfString:@"Code=-1001"].location != NSNotFound) {
                    statusCodeResponse = 408;
                }
                
                NSString *strServerErr,*strTimeout;
                strServerErr  = NSLocalizedString(@"ServerErr" , @"") ;
                strTimeout = NSLocalizedString(@"Request Timeout error." , @"");
                
                NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"Request Timeout error." , @""),NSLocalizedString(@"Unexpected result from server, please try again.",@""),nil]];
                
                NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
                
                if (resultArray1.count!=0){
                    for (int i=0; i<resultArray1.count; i++){
                        [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                    }
                    
                    for (int i=0; i<2; i++) {
                          if (i==0){
                            if ([dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]] && ![[dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]] isKindOfClass:[NSNull class]]) {
                                if ([[dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]] length]>0) {
                                    strTimeout = [dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]]?[dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]]:@"";
                                }
                            }
                        }else  if (i==1) {
                            if ([dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]] && ![[dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]] isKindOfClass:[NSNull class]]) {
                                if ([[dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]] length]>0) {
                                    strServerErr = [dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]]?[dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]]:@"";
                                }
                            }
                        }
                    }
                }
                
                NSString *myXMLResponse = [[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding:NSUTF8StringEncoding];
                
                if(statusCodeResponse==200){
                    success(myXMLResponse);
                }
                else {
                    if (statusCodeResponse == 401) {
                        failure([NSString stringWithFormat:@"%ld",statusCodeResponse], connectionError);
                    }else if (statusCodeResponse == 408) {
                        failure(strTimeout, connectionError);
                    }else {
                        failure(strServerErr, connectionError);
                    }
                }
            }
            @catch (NSException *exception) {
                failure(@"Error Occured", connectionError);
            }}];
    }
    @catch (NSException *exception) {
    }
}

+ (void)sendRequest:(NSString*)url idOfServiceUrl:(NSInteger)idOfServiceUrl headers:(NSMutableDictionary*)headers methodType:(NSString*)methodType onSucess:(void (^)(NSString *responseData))success onFailure:(void (^) (NSMutableDictionary *responseData, NSError *error))failure{
    @try {
        NSString *strServiceUrl = @"";
        switch (idOfServiceUrl){
            case 10:
                strServiceUrl = @"SrvPigHistory.svc/GetPigs?";
                break;
            case 11:
                strServiceUrl = @"SrvPigHistory.svc/GetPigSummary?";
                break;
            case 12:
                strServiceUrl = @"SrvPigHistory.svc/getPigEvents?";
                break;
            case 13:
                strServiceUrl = @"SrvPigHistory.svc/GetEventDataItems?";
                break;
            case 14:
                strServiceUrl = @"SrvPigHistory.svc/DeleteEvent?";
                break;
            case 15:
                strServiceUrl = @"SrvEVTArival.svc/GetVisIdentityByTransponder?";
                break;
            case 16:
                strServiceUrl = @"SrvReports.svc/GetActiveAnimalsReport?";
                break;
            case 17:
                strServiceUrl = @"SrvReports.svc/GetOpenSowListReport?";
                break;
            case 18:
                strServiceUrl = @"SrvReports.svc/GetGiltPoolReport?";
                break;
            case 19:
                strServiceUrl = @"SrvReports_2.svc/GetWarningListNotServedReport?";
                break;
            case 20:
                strServiceUrl = @"SrvReports_2.svc/GetWarningListNotWeanedReport?";
                break;
            case 21:
                strServiceUrl = @"SrvReports.svc/GetSowsDueToFarrowReport?";
                break;
            case 22:
                strServiceUrl = @"SrvReports.svc/GetSowsDueforAttentionReport?";
                break;
            case 23:
                strServiceUrl = @"SrvReports.svc/GetHerdSummaryReport?";
                break;
            case 24:
                strServiceUrl = @"SrvReports.svc/GetAnimalStatusReport?";
                break;
            case 25:
                strServiceUrl = @"SrvReports.svc/GetSowSimpleReport?";
                break;
            case 26:
                strServiceUrl = @"SrvReports.svc/GetSowDetailsReport?";
                break;
            case 27:
                strServiceUrl = @"SrvReports.svc/GetProdSummaryReport?";
                break;
            case 28:
                strServiceUrl = @"SrvPigHistory.svc/GetPigSummary?";
                break;
            default:
                break;
        }
       
        NSString *serviceUrl = @"";
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];

      if ([methodType isEqualToString:@"POST"]) {
            serviceUrl = [[serviceUrl stringByAppendingString:NSLocalizedString(@"baseUrl" , @"")] stringByAppendingString:strServiceUrl];
            NSString *post = url;
            NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:NO];
            NSString *postLength = [NSString stringWithFormat:@"%lu", (unsigned long)[postData length]];
            
            [request setURL:[NSURL URLWithString:serviceUrl]];
            [request setHTTPMethod:methodType];
            [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
            
            for (NSString *strKey in [headers allKeys]) {
                [request setValue:[headers valueForKey:strKey] forHTTPHeaderField:strKey];
            }
            
            [request setHTTPBody:postData];
        } else {
            serviceUrl = [[[serviceUrl stringByAppendingString:NSLocalizedString(@"baseUrl" , @"")] stringByAppendingString:strServiceUrl] stringByAppendingString:url];
            serviceUrl = [serviceUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSLog(@"serviceUrl=%@",serviceUrl);
         
            NSURL *url = [NSURL URLWithString:serviceUrl];
            [request setURL:url];
            [request setHTTPMethod:methodType];
            NSData *requestBody = [@"" dataUsingEncoding:NSUTF8StringEncoding];
            [request setHTTPBody:requestBody];
        }

        //
        [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError){
            @try {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
                long statusCodeResponse = (long)[httpResponse statusCode];

                //NSLog(@"response status code: %ld", (long)[httpResponse statusCode]);

                id myXMLResponse = [[NSString alloc] initWithBytes: [data bytes] length:[data length] encoding:NSUTF8StringEncoding];
                
                NSString *strError = [NSString stringWithFormat:@"%@", [connectionError description]];
                
                if ([strError rangeOfString:@"Code=-1012"].location != NSNotFound) {
                    statusCodeResponse = 401;
                }else if ([strError rangeOfString:@"Code=-1001"].location != NSNotFound) {
                    statusCodeResponse = 408;
                }
                
                //
                NSString *strServerErr,*strTimeout;
                //strUnauthorised = NSLocalizedString(@"Your session has been expired. Please login again.", @"");
                strServerErr  = NSLocalizedString(@"ServerErr" , @"") ;
                strTimeout = NSLocalizedString(@"Request Timeout error." , @"");
                //strConnectTimeout=NSLocalizedString(@"Network Connect Timeout Error.",@"");
                //strReadTimeout =NSLocalizedString(@"network read timeout error", @"") ;
                //strGatewaytimeout = NSLocalizedString(@"Gateway Timeout.",@"");
                
                NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:NSLocalizedString(@"Request Timeout error." , @""),NSLocalizedString(@"Unexpected result from server, please try again.",@""),nil]];
                
                NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
                
                if (resultArray1.count!=0){
                    for (int i=0; i<resultArray1.count; i++){
                        [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                    }
                    
                    for (int i=0; i<6; i++) {
                        if (i==0) {
                            if ([dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]] && ![[dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]] isKindOfClass:[NSNull class]]) {
                                if ([[dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]] length]>0) {
                                    strServerErr = [dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]]?[dictMenu objectForKey:[@"Unexpected result from server, please try again." uppercaseString]]:@"";
                                }
                            }
                        }else if (i==1){
                            if ([dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]] && ![[dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]] isKindOfClass:[NSNull class]]) {
                                if ([[dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]] length]>0) {
                                    strTimeout = [dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]]?[dictMenu objectForKey:[NSLocalizedString(@"Request Timeout error." , @"") uppercaseString]]:@"";
                                }
                            }
                        }
                    }
                }
                //
                
                NSLog(@"response=%@", myXMLResponse);
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                
              //  success(myXMLResponse);
                
                if(statusCodeResponse==200) {
                    success(myXMLResponse);
                }
                else {
                    if (statusCodeResponse == 401) {
                        [dict setValue:@"401" forKey:@"code"];
                        failure(dict, connectionError);
                    }else if (statusCodeResponse == 408) {
                        
                        [dict setValue:strTimeout forKey:@"Error"];
                        [dict setValue:@"408" forKey:@"code"];
                        
                        failure(dict, connectionError);
                    }else if (statusCodeResponse != 0) {
                        [dict setValue:[NSString stringWithFormat:@"%ld",statusCodeResponse] forKey:@"code"];
                        failure(dict, connectionError);
                    }
                    else {
                        [dict setValue:strServerErr forKey:@"Error"];
                        failure(dict, connectionError);
                    }
                }
            }
            @catch (NSException *exception) {
                NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
                [dict setValue:@"Error Occured" forKey:@"Error"];
                failure(dict, connectionError);
            }}];
    }
    @catch (NSException *exception) {
    }
}

//------------------------------------------------------------------------------------------------------------------

#pragma mark - Connection Delegate Methods
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    @try {
        [webData setLength: 0];
    }
    @catch (NSException *exception) {
        //[self hideActivityIndicatorWithException];
        //NSLog(@"exception in didReceiveResponse:%@,%@",[exception name],[exception debugDescription]);
    }
}

//------------------------------------------------------------------------------------------------------------------

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    @try{
        [webData appendData:data];
    }
    @catch (NSException *exception)
    {
        //[self hideActivityIndicatorWithException];
        //NSLog(@"exception in didReceiveData:%@",[exception description]);
    }
}

//------------------------------------------------------------------------------------------------------------------

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    @try{
       [theConnection cancel];
        theConnection = nil;
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"getDataNotification" object:@"Error"];
    }
    @catch (NSException *exception){
       // [self hideActivityIndicatorWithException];
        //NSLog(@"exception in didFailWithError:%@",[exception description]);
    }
}

//------------------------------------------------------------------------------------------------------------------

-(void)connectionDidFinishLoading:(NSURLConnection *)connection{
    @try{
        NSString *theXML = [[NSString alloc] initWithBytes: [webData mutableBytes] length:[webData length] encoding:NSUTF8StringEncoding];
        theXML = [theXML stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
        theXML = [theXML stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    }
    @catch (NSException *exception){
        //[self hideActivityIndicatorWithException];
        //NSLog(@"exception at connectionDidFinishLoading:%@",[exception name]);
    }
}

//------------------------------------------------------------------------------------------------------------------

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection *)connection{
    @try{
        if(connection == theConnection){
            return YES;
        }
        else{
            return NO;
        }
    }
    @catch (NSException *exception){
        //NSLog(@"Exception in connectionShouldUseCredentialStorage- %@",[exception description]);
    }
}

//------------------------------------------------------------------------------------------------------------------
- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    @try{
        if(connection == theConnection){
            if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
                [challenge.sender useCredential:[NSURLCredential credentialForTrust: challenge.protectionSpace.serverTrust] forAuthenticationChallenge: challenge];
            }
        }
    }
    @catch (NSException *exception) {
        //NSLog(@"Exception in willSendRequestForAuthenticationChallenge - %@",[exception description]);
    }
}
//------------------------------------------------------------------------------------------------------------------

@end
