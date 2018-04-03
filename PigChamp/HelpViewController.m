//
//  HelpViewController.m
//  PigChamp
//
//  Created by Venturelabour on 06/11/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import "HelpViewController.h"
#import "CoreDataHandler.h"
#import "CustomIOS7AlertView.h"
BOOL isOpenHelp = NO;

@interface HelpViewController ()
@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;

//    self.slidingViewController.navigationItem.rightBarButtonItem=nil;
//    self.slidingViewController.navigationItem.leftBarButtonItem=nil;
//    self.slidingViewController.navigationItem.hidesBackButton=YES;
    
    {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Help"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
        
        NSArray* resultArray = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"User_Parameters" andPredicate:nil andSortDescriptors:nil];
        
        NSString *strUrl;
        for (int count=0; count<resultArray.count; count++) {
            if ([[[resultArray objectAtIndex:count] valueForKey:@"nm"] isEqualToString:@"HelpUrl"]) {
                strUrl = [[resultArray objectAtIndex:count] valueForKey:@"val"];
            }
        }
        
        NSLog(@"strUrl=%@",strUrl);
        
        // strUrl = @"http://www.pigchamp.com";
        // http//www.pigchamp.com"
        
        NSURL *urlTermsAndConditions = [[NSURL alloc] initWithString:strUrl];
        NSURLRequest *urlRequest = [[NSURLRequest alloc] initWithURL:urlTermsAndConditions];
        [self.webHelp loadRequest:urlRequest];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(-20, 0, 22, 22);
        [button setBackgroundImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
       // [button addTarget:self action:@selector(btnMenu_tapped:) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
        [barButton setCustomView:button];
        
//        self.slidingViewController.navigationItem.leftBarButtonItem = barButton;
//        self.slidingViewController.title = @"Help";
//        self.slidingViewController.navigationItem.rightBarButtonItem = nil;
//        
        NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:@"Help",@"Please Wait...",@"OK",@"Your session has been expired. Please login again.",nil]];
        
        NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
        NSString *strWait;
        strWait = @"Please Wait...";
        strOK = @"OK";
        strUnauthorised = @"Your session has been expired. Please login again.";

        if (resultArray1.count!=0){
            for (int i=0; i<resultArray1.count; i++){
                [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
            }
            
            for (int i=0; i<4; i++) {
                if (i==0) {
                    if ([dictMenu objectForKey:[@"Help" uppercaseString]] && ![[dictMenu objectForKey:[@"Help" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Help" uppercaseString]] length]>0) {
                            //self.slidingViewController.title = [dictMenu objectForKey:[@"Help" uppercaseString]]?[dictMenu objectForKey:[@"Help" uppercaseString]]:@"";
                        }else{
                            //self.slidingViewController.title = @"Help";
                        }
                    }
                    else{
                        //self.slidingViewController.title = @"Help";
                    }
                }else  if (i==1){
                    if ([dictMenu objectForKey:[@"Please Wait..." uppercaseString]] && ![[dictMenu objectForKey:[@"Please Wait..." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Please Wait..." uppercaseString]] length]>0) {
                            strWait = [dictMenu objectForKey:[@"Please Wait..." uppercaseString]]?[dictMenu objectForKey:[@"Please Wait..." uppercaseString]]:@"";
                        }
                    }
                }else if (i==2){
                    if ([dictMenu objectForKey:[@"OK" uppercaseString]] && ![[dictMenu objectForKey:[@"OK" uppercaseString]] isKindOfClass:[NSNull class]]){
                        if ([[dictMenu objectForKey:[@"OK" uppercaseString]] length]>0){
                            strOK = [dictMenu objectForKey:[@"OK" uppercaseString]]?[dictMenu objectForKey:[@"OK" uppercaseString]]:@"";
                        }
                    }
                }else  if (i==3){
                    if ([dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] && ![[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] length]>0) {
                            strUnauthorised = [dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]]?[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]]:@"";
                        }
                    }
                }
            }
        }
        
        _alertwebload = [[CustomIOS7AlertView alloc] init];
        [_alertwebload showLoaderWithMessage:strWait];
        
//        if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
//            self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuView"];
//        }
    }
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button1 setImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(updateMenuBarPositions) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem=rightBarButtonItem;
    
    SlideNavigationController *sld = [SlideNavigationController sharedInstance];
    sld.delegate = self;
    
    self.navigationItem.hidesBackButton = YES;
    tlc = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];

}

-(void)viewDidAppear:(BOOL)animated {
    @try{
        [super viewDidAppear:animated];

        isOpenHelp = NO;
//        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
//        if ([[pref valueForKey:@"reloadWeb"]isEqualToString:@"0"]) {
//            [pref setValue:@"1" forKey:@"reloadWeb"];
//            [pref synchronize];
//        }else
//            self.webHelp.scrollView.contentInset = UIEdgeInsetsMake(0, 0, 64, 0);//bottom hidden
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in viewWillAppear =%@",exception.description);
    }
}

-(void)updateMenuBarPositions {
    @try {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeView:) name:@"CloseAlert" object:nil];
        UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
        
        if (!isOpenHelp) {
            self.vwOverlay.hidden = NO;
            [tlc.view setFrame:CGRectMake(-320, 0, self.view.frame.size.width-64, currentWindow.frame.size.height)];
            [currentWindow addSubview:tlc.view];
            
            [UIView animateWithDuration:0.3 animations:^{
                [tlc.view setFrame:CGRectMake(0, 0, self.view.frame.size.width-64, currentWindow.frame.size.height)];
            }];
        }else{
            self.vwOverlay.hidden = YES;
            [tlc.view removeFromSuperview];
        }
        
        isOpenHelp = !isOpenHelp;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception =%@",exception.description);
    }
}

-(void)removeView:(NSNotification *) notification{
    @try {
        NSDictionary *userInfo = notification.object;
        NSString *responseData =(NSString*) userInfo;
        
        if ([responseData isEqualToString:@"\"User is not signed in or Session expired\""] || [responseData localizedCaseInsensitiveContainsString:@"\"Token not found\""])  {
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                       message:responseData
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:strOK
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
                                 actionWithTitle:strOK
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [myAlertController addAction: ok];
            [self presentViewController:myAlertController animated:YES completion:nil];
            
        }
        //        else{
        //            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
        //                                                                                       message:strServerErr
        //                                                                                preferredStyle:UIAlertControllerStyleAlert];
        //            UIAlertAction* ok = [UIAlertAction
        //                                 actionWithTitle:strOK
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
        isOpenHelp = !isOpenHelp;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in removeView=%@",exception.description);
    }
}

//- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
//{
//    return YES;
//}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [_alertwebload close];
    NSLog(@"loaded");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [_alertwebload close];
    NSLog(@"error");
}

//- (IBAction)btnMenu_tapped:(id)sender {
//    
//    if (self.slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionAnchoredRight){
//        self.vwOverlay.hidden = YES;
//        [self.slidingViewController resetTopViewAnimated:YES];
//        self.slidingViewController.title = @"Help";
//
//        
//        NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:@"Help",nil]];
//        if (resultArray1.count>0) {
//            if (![[[resultArray1 objectAtIndex:0]valueForKey:@"translatedText"] isKindOfClass:[NSNull class]]){
//                if ([[[resultArray1 objectAtIndex:0]valueForKey:@"translatedText"] length]>0){
//                    self.slidingViewController.title = [[resultArray1 objectAtIndex:0]valueForKey:@"translatedText"]?[[resultArray1 objectAtIndex:0]valueForKey:@"translatedText"]:@"";
//                }
//            }
//        }
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(-20, 0, 22, 22);
//        [button setBackgroundImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(btnMenu_tapped:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
//        [barButton setCustomView:button];
//        self.slidingViewController.navigationItem.leftBarButtonItem=barButton;
//        self.slidingViewController.navigationItem.rightBarButtonItem=nil;
//        self.slidingViewController.navigationItem.hidesBackButton=YES;
//    }
//    else {
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(-20, 0, 22, 22);
//        [button setBackgroundImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(btnMenu_tapped:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
//        [barButton setCustomView:button];
//        self.slidingViewController.navigationItem.rightBarButtonItem=barButton;
//        self.slidingViewController.navigationItem.leftBarButtonItem=nil;
//        self.slidingViewController.navigationItem.hidesBackButton=YES;
//
//        self.slidingViewController.title = @"PigCHAMP";
//        NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:@"PigCHAMP",nil]];
//        if (resultArray1.count>0) {
//            if (![[[resultArray1 objectAtIndex:0]valueForKey:@"translatedText"] isKindOfClass:[NSNull class]]){
//                if ([[[resultArray1 objectAtIndex:0]valueForKey:@"translatedText"] length]>0){
//                    self.slidingViewController.title = [[resultArray1 objectAtIndex:0]valueForKey:@"translatedText"]?[[resultArray1 objectAtIndex:0]valueForKey:@"translatedText"]:@"";
//                }
//            }
//        }
//        
//        self.vwOverlay.hidden = NO;
//        [self.slidingViewController anchorTopViewToRightAnimated:YES];
//    }
//    
//    [(MenuViewController *)self.slidingViewController.underLeftViewController setDelegate:self];
//}
//
//- (void)menuViewControllerDidFinishWithCategoryId:(NSInteger)categoryId
//{
//    [self.slidingViewController resetTopViewAnimated:YES];
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
