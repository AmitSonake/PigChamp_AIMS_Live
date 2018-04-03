
//
//  SearchListViewController.m
//  PigChamp
//
//  Created by Venturelabour on 02/11/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import "SearchListViewController.h"
#import "ServerManager.h"
#import "ControlSettings.h"
#import "CustomIOS7AlertView.h"
#import "HistorySummaryViewController.h"
#import "CoreDataHandler.h"

int recordsSearchList = 20;
NSInteger maxCountSearchList = 20;
BOOL canCallSearchList= NO;
BOOL isOpenList= NO;

@interface SearchListViewController ()
@end

@implementation SearchListViewController
@synthesize arrSearchList;
@synthesize strMatchfilterBoarSow;
@synthesize strIdentityText;

#pragma mark - view life cycle
- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        self.navigationController.navigationBar.translucent = NO;
        
        tlc = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(-20, 0, 22, 22);
        [button setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnBack_tapped) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
        [barButton setCustomView:button];
        self.navigationItem.leftBarButtonItem = barButton;

        //yogs do it

         strPlzWait = @"Please Wait...";
         strNoInternet = @"You must be online for the app to function.";
         strOk = @"OK";
         strIdentityMsg = @"There is no animal with the identity #, please enter a valid identity";
         strPigs = @"Primary # Pigs";
        strUnauthorised =@"Your session has been expired. Please login again.";
        strServerErr= @"Server Error.";
        strYes = @"Yes";
        strNo = @"No";
        strSignOff = @"Signing off.";

        NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:@"Please Wait...",@"You must be online for the app to function.",@"Ok",@"There is no animal with the identity #, please enter a valid identity",@"Primary # Pigs",@"Your session has been expired. Please login again.",@"Server Error.",@"Yes",@"No",@"Signing off.",nil]];
        
        NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
        
        if (resultArray1!=0) {
            for (int i=0; i<resultArray1.count; i++){
                [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
            }
            
            for (int i=0; i<10; i++){
                if (i==0) {
                    if ([dictMenu objectForKey:[@"Please Wait..." uppercaseString]] && ![[dictMenu objectForKey:[@"Please Wait..." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Please Wait..." uppercaseString]] length]>0) {
                            strPlzWait = [dictMenu objectForKey:[@"Please Wait..." uppercaseString]]?[dictMenu objectForKey:[@"Please Wait..." uppercaseString]]:@"";
                        }
                    }
                }else  if (i==1){
                    if ([dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]] && ![[dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]] length]>0) {
                            strNoInternet = [dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]]?[dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]]:@"";
                        }
                    }
                }else  if (i==2){
                    if ([dictMenu objectForKey:[@"Ok" uppercaseString]] && ![[dictMenu objectForKey:[@"Ok" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Ok" uppercaseString]] length]>0) {
                            strOk = [dictMenu objectForKey:[@"Ok" uppercaseString]]?[dictMenu objectForKey:[@"Ok" uppercaseString]]:@"";
                        }
                    }
                }else  if (i==3){
                    if ([dictMenu objectForKey:[@"There is no animal with the identity #, please enter a valid identity" uppercaseString]] && ![[dictMenu objectForKey:[@"There is no animal with the identity #, please enter a valid identity" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"There is no animal with the identity #, please enter a valid identity" uppercaseString]] length]>0) {
                            strIdentityMsg = [dictMenu objectForKey:[@"There is no animal with the identity #, please enter a valid identity" uppercaseString]]?[dictMenu objectForKey:[@"There is no animal with the identity #, please enter a valid identity" uppercaseString]]:@"";
                        }
                    }
                }else  if (i==4){
                    if ([dictMenu objectForKey:[@"Primary # Pigs" uppercaseString]] && ![[dictMenu objectForKey:[@"Primary # Pigs" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Primary # Pigs" uppercaseString]] length]>0) {
                            strPigs = [dictMenu objectForKey:[@"Primary # Pigs" uppercaseString]]?[dictMenu objectForKey:[@"Primary # Pigs" uppercaseString]]:@"";
                        }
                    }
                }else  if (i==5){
                    if ([dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] && ![[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] length]>0) {
                            strUnauthorised = [dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]]?[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]]:@"";
                        }
                    }
                }else  if (i==6){
                    if ([dictMenu objectForKey:[@"Server Error." uppercaseString]] && ![[dictMenu objectForKey:[@"Server Error." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Server Error." uppercaseString]] length]>0) {
                            strServerErr = [dictMenu objectForKey:[@"Server Error." uppercaseString]]?[dictMenu objectForKey:[@"Server Error." uppercaseString]]:@"";
                        }
                    }
                }else  if (i==7){
                    if ([dictMenu objectForKey:[@"Yes" uppercaseString]] && ![[dictMenu objectForKey:[@"Yes" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Yes" uppercaseString]] length]>0) {
                            strYes = [dictMenu objectForKey:[@"Yes" uppercaseString]]?[dictMenu objectForKey:[@"Yes" uppercaseString]]:@"";
                        }
                    }
                }else  if (i==8){
                    if ([dictMenu objectForKey:[@"No" uppercaseString]] && ![[dictMenu objectForKey:[@"No" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"No" uppercaseString]] length]>0) {
                            strNo = [dictMenu objectForKey:[@"No" uppercaseString]]?[dictMenu objectForKey:[@"No" uppercaseString]]:@"";
                        }
                    }
                }else  if (i==9){
                    if ([dictMenu objectForKey:[@"Signing off." uppercaseString]] && ![[dictMenu objectForKey:[@"Signing off." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Signing off." uppercaseString]] length]>0) {
                            strSignOff = [dictMenu objectForKey:[@"Signing off." uppercaseString]]?[dictMenu objectForKey:[@"Signing off." uppercaseString]]:@"";
                        }
                    }
                }
            }
        }
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [button1 setImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(updateMenuBarPositions) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
        self.navigationItem.rightBarButtonItem=rightBarButtonItem;
        
        SlideNavigationController *sld = [SlideNavigationController sharedInstance];
        sld.delegate = self;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in viewDidLoad=%@",exception.description);
    }
}

-(void)displayToastWithMessage:(NSString *)toastMessage {
    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
        UIWindow * keyWindow = [[UIApplication sharedApplication] keyWindow];
        UILabel *toastView = [[UILabel alloc] init];
        toastView.text = toastMessage;
        toastView.font = [UIFont systemFontOfSize:13];
        //toastView.textColor = [MYUIStyles getToastTextColor];
        NSLog(@"self.view.frame.size.height=%f",self.view.frame.size.height);
        toastView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:249.0/255.0 blue:248.0/255.0 alpha:1];
        toastView.textAlignment = NSTextAlignmentCenter;
        toastView.frame = CGRectMake(0.0, self.view.frame.size.height, keyWindow.frame.size.width,30);
        toastView.layer.cornerRadius = 10;
        toastView.layer.masksToBounds = YES;
        //toastView.center = keyWindow.center;
        
        [keyWindow addSubview:toastView];
        [UIView animateWithDuration: 2.0f
                              delay: 0.0
                            options: UIViewAnimationOptionCurveEaseOut
                         animations: ^{
                             toastView.alpha = 0.0;
                         }
                         completion: ^(BOOL finished) {
                             [toastView removeFromSuperview];
                         }
         ];
    }];
}

-(void)viewWillAppear:(BOOL)animated {
    @try {
        [super viewWillAppear:YES];
        isOpenList= NO;
        self.title = strIdentityText;
        NSLog(@"_strTitle=%@",strIdentityText);
        //self.lblSearchResultHint.text = self.strIdentity;
        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
        NSString *strIds = [pref valueForKey:@"deletedIndetity"];

        NSString *strFromHistory = [pref valueForKey:@"FromHistory"];
        if ([strFromHistory isEqualToString:@"0"]) {
             recordsSearchList = 20;
             maxCountSearchList = [[pref valueForKey:@"maxCount"] integerValue];
             canCallSearchList = NO;
             NSLog(@"arrSearchList=%@",arrSearchList);
            
            self.lblSearchResultHint.text = [strPigs stringByReplacingOccurrencesOfString:@"#" withString:[pref valueForKey:@"maxCount"]];

            if (arrSearchList.count==0) {
                UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                           message:[strIdentityMsg stringByReplacingOccurrencesOfString:@"#" withString:self.strIdentity]
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:strOk
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action)  {
                                         [self.navigationController popViewControllerAnimated:YES];
                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     }];
                
                [myAlertController addAction: ok];
                [self presentViewController:myAlertController animated:YES completion:nil];
            }
            else {
                [self.tblSearchList reloadData];
            }
            
            if ([[ControlSettings sharedSettings] isNetConnected]) {
//               arrSearchList =[[NSMutableArray alloc]init];
               // NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
//                [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
//                [dict setValue:self.strIdentity forKey:@"Identity"];
//                [dict setValue:self.strMatchfilter forKey:@"match"];
//                [dict setValue:strMatchfilterBoarSow forKey:@"SexType"];
//                [dict setValue:@"51" forKey:@"FromRec"];
//                [dict setValue:@"100" forKey:@"ToRec"];
//                [dict setValue:@"" forKey:@"sortFld"];
//                [dict setValue:@"0" forKey:@"sortOrd"];
//                
                //[self callService:nil];
            }
            else {
                UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                           message:strNoInternet
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:strOk
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     }];
                
                [myAlertController addAction:ok];
                [self presentViewController:myAlertController animated:YES completion:nil];
            }
            
        }else if (strIds.length>0){
            arrDeleted = [strIds componentsSeparatedByString:@","];
            
             int record=[[pref valueForKey:@"maxCount"] integerValue];
            self.lblSearchResultHint.text = [@"Primary # Pigs" stringByReplacingOccurrencesOfString:@"#" withString:[NSString stringWithFormat:@"%u",record - (arrDeleted.count-1)]];

            [self.tblSearchList reloadData];
        }
        
       // if (arrSearchList.count>0)
        {
           // [self.tblSearchList reloadData];
            //if (![strFromHistory isEqualToString:@"1"])
        }
        
//        else if (arrSearchList.count==0)
//        {
//            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@""
//                                                                                       message:[strIdentityMsg stringByReplacingOccurrencesOfString:@"#" withString:self.strIdentity]
//                                                                                preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction* ok = [UIAlertAction
//                                 actionWithTitle:strOk
//                                 style:UIAlertActionStyleDefault
//                                 handler:^(UIAlertAction * action)
//                                 {
//                                     [self.navigationController popViewControllerAnimated:YES];
//                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
//                                 }];
//            
//            [myAlertController addAction: ok];
//            [self presentViewController:myAlertController animated:YES completion:nil];
//        }
 }
    @catch (NSException *exception) {
        NSLog(@"Exception in viewWillAppear = %@",exception.description);
    }
}

-(void)updateMenuBarPositions {
    @try {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeView:) name:@"CloseAlert" object:nil];

        UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
        
        if (!isOpenList) {
            self.vwOverlay.hidden = NO;
            [tlc.view setFrame:CGRectMake(-320, 0, self.view.frame.size.width-64, currentWindow.frame.size.height)];
            [currentWindow addSubview:tlc.view];
            
            [UIView animateWithDuration:0.3 animations:^{
                [tlc.view setFrame:CGRectMake(0, 0, self.view.frame.size.width-64, currentWindow.frame.size.height)];
            }];
        }else {
            self.vwOverlay.hidden = YES;
            [tlc.view removeFromSuperview];
        }
        
        isOpenList = !isOpenList;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in updateMenuBarPositions= %@",exception.description);
    }
}


-(void)removeView:(NSNotification *) notification {
    @try {
        NSDictionary *userInfo = notification.object;
        NSString *responseData =(NSString*) userInfo;
        
        if ([responseData isEqualToString:@"\"User is not signed in or Session expired\""] || [responseData localizedCaseInsensitiveContainsString:@"\"Token not found\""])  {
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                       message:responseData
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:strOk
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)                                                              {
                                     [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [myAlertController addAction: ok];
            [self presentViewController:myAlertController animated:YES completion:nil];
        }else if (responseData.integerValue ==401) {
            
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                       message:strUnauthorised
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:strOk
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [myAlertController addAction: ok];
            [self presentViewController:myAlertController animated:YES completion:nil];
        }else if ([responseData isEqualToString:@""]){
            [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];
        }
//        else{
//            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
//                                                                                       message:strServerErr
//                                                                                preferredStyle:UIAlertControllerStyleAlert];
//            UIAlertAction* ok = [UIAlertAction
//                                 actionWithTitle:strOk
//                                 style:UIAlertActionStyleDefault
//                                 handler:^(UIAlertAction * action) {
//                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
//                                 }];
//            
//            [myAlertController addAction: ok];
//            [self presentViewController:myAlertController animated:YES completion:nil];
//        }

        [[NSNotificationCenter defaultCenter]removeObserver:self];
        self.vwOverlay.hidden = YES;
        isOpenList = !isOpenList;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in removeView=%@",exception.description);
    }
}

//- (BOOL)slideNavigationControllerShouldDisplayRightMenu{
//    return YES;
//}

-(void)pagging {
    @try {
        BOOL loading = '\0';
        
        if (!loading) {
            
            if (maxCountSearchList>arrSearchList.count && !canCallSearchList) {
               // if (endScrolling >= scrollView.contentSize.height && !canCallSearchList)
                {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                        if ([[ControlSettings sharedSettings] isNetConnected]) {
                            [self callService:nil];
                        }
                        else {
                            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                       message:strNoInternet
                                                                                                preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction *ok = [UIAlertAction
                                                 actionWithTitle:strOk
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action){
                                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                                 }];
                            
                            [myAlertController addAction:ok];
                            [self presentViewController:myAlertController animated:YES completion:nil];
                        }
                        
                        recordsSearchList+=20;
                    }];
                }
            }else{
                //no more reslut
            }
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception =%@",exception.description);
    }
}

#pragma UIScrollView Method:
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
//{
//
//    BOOL loading = '\0';
//    if (!loading) {
//        float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
//        
//       // NSLog(@"to rec=%d",recordsSearchList+50);
//      //  NSLog(@"maxcount from server=%ld",(long)maxCountSearchList);
//        
//        if (maxCountSearchList>recordsSearchList+50 && !canCallSearchList) {
//            if (endScrolling >= scrollView.contentSize.height && !canCallSearchList) {
//                
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
////                   // NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
////                    [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
////                    [dict setValue:self.strIdentity forKey:@"Identity"];
////                    [dict setValue:self.strMatchfilter forKey:@"match"];
////                    [dict setValue:strMatchfilterBoarSow forKey:@"SexType"];
////                    [dict setValue:@"" forKey:@"sortFld"];
////                    [dict setValue:@"0" forKey:@"sortOrd"];
//                    
////                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",recordsSearchList+1] forKey:@"FromRec"];
////                    [[NSUserDefaults standardUserDefaults] setObject:[NSString stringWithFormat:@"%d",recordsSearchList+50] forKey:@"ToRec"];
//
//                    
//                    //[dict setValue:[NSString stringWithFormat:@"%d",recordsSearchList+1] forKey:@"FromRec"];
//                    //[dict setValue:[NSString stringWithFormat:@"%d",recordsSearchList+50] forKey:@"ToRec"];
//                    
//                    if ([[ControlSettings sharedSettings] isNetConnected]) {
//                        [self callService:nil];
//                    }
//                    else {
//                        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
//                                                                                                   message:strNoInternet
//                                                                                            preferredStyle:UIAlertControllerStyleAlert];
//                        UIAlertAction *ok = [UIAlertAction
//                                             actionWithTitle:strOk
//                                             style:UIAlertActionStyleDefault
//                                             handler:^(UIAlertAction * action){
//                                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
//                                             }];
//                        
//                        [myAlertController addAction:ok];
//                        [self presentViewController:myAlertController animated:YES completion:nil];
//                    }
//                    
//                    recordsSearchList+=50;
//                }];
//            }
//        }else{
//            //no more reslut
//        }
//    }
//}

-(void)callService:(NSMutableDictionary*)dict {
    @try {
        NSDateFormatter *dateformatez=[[NSDateFormatter alloc]init];
        [dateformatez setDateFormat:@"HH:mm:ss.SSS"];
       // NSString *strDatezs = [dateformatez stringFromDate:[NSDate date]];
        
        _customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
        [_customIOS7AlertView showLoaderWithMessage:strPlzWait];
        canCallSearchList = YES;
        
        NSString *srvUrl;
        srvUrl = [NSString stringWithFormat:@"token=%@&Identity=%@&match=%@&SexType=%@&FromRec=%@&ToRec=%@&sortFld=%@&sortOrd=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],self.strIdentity,self.strMatchfilter,strMatchfilterBoarSow,[NSString stringWithFormat:@"%d",recordsSearchList+1],[NSString stringWithFormat:@"%d",recordsSearchList+20],@"",@"0"];

        [ServerManager sendRequest:srvUrl idOfServiceUrl:10 headers:nil methodType:@"GET" onSucess:^(NSString *responseData) {//dict
            
            canCallSearchList = NO;
            [_customIOS7AlertView close];
            
            id response = [NSJSONSerialization JSONObjectWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            //NSLog(@"response=%@",response);
            
            if ([responseData isEqualToString:@"\"User is not signed in or Session expired\""] || [responseData localizedCaseInsensitiveContainsString:@"\"Token not found\""]) {
                UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                           message:responseData
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:strOk
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action) {
              [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     }];
                
                [myAlertController addAction: ok];
                [self presentViewController:myAlertController animated:YES completion:nil];
            }else if ([[response objectForKey:@"_Pig"] isKindOfClass:[NSArray class]]){
                NSString *strRec = [[response objectForKey:@"_RecCount"] objectForKey:@"totRecs"];
                
                if ([strRec localizedCaseInsensitiveContainsString:@"Not connected"])
                {//to do too
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:NSLocalizedString(@"connection_lost", @"")
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOk
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             if ([[ControlSettings sharedSettings] isNetConnected ]){
                                                 _customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
                                                 [_customIOS7AlertView showLoaderWithMessage:strSignOff];
                                                 
                                                 [ServerManager sendRequestForLogout:^(NSString *responseData) {
                                                     NSLog(@"%@",responseData);
                                                     [_customIOS7AlertView close];
                                                     
                                                     if ([responseData isEqualToString:@"\"User is not signed in or Session expired\""] || [responseData localizedCaseInsensitiveContainsString:@"\"Token not found\""])  {
                                                     }else if ([responseData isEqualToString:@"\"Loged out\""] || [responseData isEqualToString:@""]){
                                                         [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];
                                                     }
                                                 } onFailure:^(NSString *responseData, NSError *error) {
                                                     id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                                                     NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
                                                     [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                                     NSString *strDate = [dateformate stringFromDate:[NSDate date]];
                                                     
                                                     NSString *strErr = [NSString stringWithFormat:@"User Name = %@,Farm Name = %@,error = %@,DateTime=%@,On log out=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],[[NSUserDefaults standardUserDefaults] objectForKey:@"f_nm"],error.description,strDate, self.title];
                                                     [tracker set:kGAIScreenName value:strErr];
                                                     [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
                                                     
                                                     // [[NSNotificationCenter defaultCenter]postNotificationName:@"CloseAlert" object:responseData];
                                                     
                                                     [_customIOS7AlertView close];
                                                 }];
                                             }
                                             else {
                                                 UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                                            message:strNoInternet
                                                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                                 UIAlertAction* ok = [UIAlertAction
                                                                      actionWithTitle:strOk
                                                                      style:UIAlertActionStyleDefault
                                                                      handler:^(UIAlertAction * action)
                                                                      {
                                                                          [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                                                      }];
                                                 
                                                 [myAlertController addAction: ok];
                                                 [self presentViewController:myAlertController animated:YES completion:nil];
                                             }
                                             
                                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    
                    [myAlertController addAction: ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                }
                
                maxCountSearchList = [strRec integerValue];
                [arrSearchList addObjectsFromArray:[response objectForKey:@"_Pig"]];
                
                //
                NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
                NSString *preRec = [pref valueForKey:@"totRec"];
                
                if (preRec.intValue !=[strRec integerValue]) {//Need to unit test
                    [self displayToastWithMessage:@"Cache has updated."];
//                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
//                                                                                               message:@"Cache has updated,,do u want to refresh list?"
//                                                                                        preferredStyle:UIAlertControllerStyleAlert];
//                    UIAlertAction* ok = [UIAlertAction
//                                         actionWithTitle:strYes
//                                         style:UIAlertActionStyleDefault
//                                         handler:^(UIAlertAction * action){
//                                             recordsSearchList = 50;
//                                             maxCountSearchList = 50;
//                                             canCallSearchList= NO;
//                                             
//                                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
//                                         }];
//                    
//                    [myAlertController addAction: ok];
//                    
//                    UIAlertAction *cancel = [UIAlertAction
//                                             actionWithTitle:strNo
//                                             style:UIAlertActionStyleDefault
//                                             handler:^(UIAlertAction * action){
//                                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
//                                             }];
//                    
//                    [myAlertController addAction: cancel];
//                    [self presentViewController:myAlertController animated:YES completion:nil];
                }

                //
                
                NSLog(@"arrSearchList=%lu",(unsigned long)arrSearchList.count);
                
                self.lblSearchResultHint.text = [strPigs stringByReplacingOccurrencesOfString:@"#" withString:strRec];
                
                if (arrSearchList.count==0) {
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:[strIdentityMsg stringByReplacingOccurrencesOfString:@"#" withString:self.strIdentity]
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOk
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action)  {
                                             [self.navigationController popViewControllerAnimated:YES];
                                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    
                    [myAlertController addAction: ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                }
                
                [self.tblSearchList reloadData];
            }
            else {
            }
        } onFailure:^(NSMutableDictionary *responseData, NSError *error) {
            NSLog(@"responseData failure=%@",responseData);
           
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
            [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateformate stringFromDate:[NSDate date]];
            
            NSString *strErr = [NSString stringWithFormat:@"User Name = %@,Farm Name = %@,error = %@,DateTime=%@,Event=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],[[NSUserDefaults standardUserDefaults] objectForKey:@"f_nm"],error.description,strDate, @"Search List"];
            [tracker set:kGAIScreenName value:strErr];
            [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
            
            if ([responseData.allKeys containsObject:@"code"]) {
                if ([[responseData valueForKey:@"code"]integerValue] ==401) {
                    
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:strUnauthorised
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOk
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    
                    [myAlertController addAction: ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                    
                    // [self.navigationController popToRootViewControllerAnimated:YES];
                }else if ([[responseData valueForKey:@"code"]integerValue] ==408) {
                    
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:[responseData valueForKey:@"Error"]
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOk
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }];
                    
                    [myAlertController addAction: ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                    
                    // [self.navigationController popToRootViewControllerAnimated:YES];
                }
            }
            else{
                UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                           message:[responseData valueForKey:@"Error"]
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:strOk
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action) {
                                         //[self.navigationController popToRootViewControllerAnimated:YES];
                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     }];
                
                [myAlertController addAction: ok];
                [self presentViewController:myAlertController animated:YES completion:nil];
            }
            
            [_customIOS7AlertView close];
        }];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception =%@",exception.description);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        if ([arrDeleted containsObject:[[arrSearchList objectAtIndex:indexPath.row] valueForKey:@"Identity"]]) {
            return 0;
        }else {
            return 60;
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in heightForRowAtIndexPath =%@",exception.description);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrSearchList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        UITableViewCell * cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"searchList"];
        
        if (cell ==nil)
        {
            cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"searchList"];
        }
        
        UILabel *lblDetails = (UILabel*)[cell viewWithTag:2];
        lblDetails.text = [[arrSearchList objectAtIndex:indexPath.row] valueForKey:@"Identity"];
        
        return cell;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in cellForRowAtIndexPath=%@",exception.description);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"FromDataEntry"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"totRecs"];

        selectedRow = indexPath.row;
        [self performSegueWithIdentifier:@"segueHistorySummary" sender:self];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in didSelectRowAtIndexPath=%@",exception.description);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            cell.backgroundColor = [UIColor clearColor];
        }
        
        if (indexPath.row==arrSearchList.count-1) {
            NSLog(@"indespath=%ld",(long)indexPath.row);
            [self pagging];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in forRowAtIndexPath=%@",exception.description);
    }
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    HistorySummaryViewController *historySummaryViewController = [segue destinationViewController];
    historySummaryViewController.strIdentityId = [[arrSearchList objectAtIndex:selectedRow] valueForKey:@"id"];
    historySummaryViewController.strTitle = [[arrSearchList objectAtIndex:selectedRow] valueForKey:@"Identity"];
}

-(void)btnBack_tapped
{
    @try {
        [self.navigationController popViewControllerAnimated:YES];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in btnBack_tapped=%@",exception.description);
    }
}

@end
