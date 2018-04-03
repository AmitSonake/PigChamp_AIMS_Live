//
//  AboutViewController.m
//  PigChamp
//
//  Created by Venturelabour on 06/11/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import "AboutViewController.h"
#import "CoreDataHandler.h"
#import "SettingsViewController.h"

BOOL isOpenAbout = NO;

@interface AboutViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lblCopyright;
@property (weak, nonatomic) IBOutlet UILabel *lblVersion;
@property (weak, nonatomic) IBOutlet UILabel *lblAllicationSoftware;
@end

@implementation AboutViewController

- (void)viewDidLoad {
    
//    self.slidingViewController.navigationItem.rightBarButtonItem=nil;
//    self.slidingViewController.navigationItem.leftBarButtonItem=nil;
//    self.slidingViewController.navigationItem.hidesBackButton=YES;
    
    [super viewDidLoad];
    self.navigationController.navigationBar.translucent = NO;
    self.title = @"About";
    self.navigationItem.hidesBackButton = YES;
    tlc = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];

    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button1 setImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(updateMenuBarPositions) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem=rightBarButtonItem;
    
    SlideNavigationController *sld = [SlideNavigationController sharedInstance];
    sld.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    isOpenAbout = NO;
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"About"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    // self.slidingViewController.title = @"About";
    self.lblAllicationSoftware.text =@"iOS Mobile Application Software";
    self.lblCopyright.text = @"Copyright © PigCHAMP 2017";
    
//    NSDateFormatter *dateFormatterr = [[NSDateFormatter alloc]init] ;
//    [dateFormatterr setDateFormat:@"MM/dd/yyyy"];
//    NSString *strSelectedDate = [dateFormatterr stringFromDate:[NSDate date]];
//    [dateFormatterr setDateFormat:@"mmddyy"];
//    strSelectedDate = [dateFormatterr stringFromDate:[NSDate date]];
//    NSLog(@"strSelectedDate=%@",strSelectedDate);

    strOK = @"OK";
    strUnauthorised = @"Your session has been expired. Please login again.";
    strServerErr  = @"Server Error.";
    
    NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:@"About",@"iOS Mobile Application Software",@"Vesrion 1.0.0",@"Copyright © pigCHAMP 2017",@"OK",@"Your session has been expired. Please login again.",@"Server Error.",nil]];
    
    NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
    
    if (resultArray1.count!=0){
        for (int i=0; i<resultArray1.count; i++){
            [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
        }
        
        for (int i=0; i<7; i++) {
            if (i==0) {
                if ([dictMenu objectForKey:[@"About" uppercaseString]] && ![[dictMenu objectForKey:[@"About" uppercaseString]] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:[@"About" uppercaseString]] length]>0) {
                        self.title = [dictMenu objectForKey:[@"About" uppercaseString]]?[dictMenu objectForKey:[@"About" uppercaseString]]:@"";
                    }else{
                       self.title = @"About";
                    }
                }
                else{
                    self.title = @"About";
                }
            }else if (i==1){
                if ([dictMenu objectForKey:[@"iOS Mobile Application Software" uppercaseString]] && ![[dictMenu objectForKey:[@"iOS Mobile Application Software" uppercaseString]] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:[@"iOS Mobile Application Software" uppercaseString]] length]>0) {
                        self.lblAllicationSoftware.text = [dictMenu objectForKey:[@"iOS Mobile Application Software" uppercaseString]]?[dictMenu objectForKey:[@"iOS Mobile Application Software" uppercaseString]]:@"";
                    }
                }
            }else if (i==2){
                if ([dictMenu objectForKey:[@"Vesrion 1.0.0" uppercaseString]] && ![[dictMenu objectForKey:[@"Vesrion 1.0.0" uppercaseString]] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:[@"Vesrion 1.0.0" uppercaseString]] length]>0) {
                        self.lblVersion.text = [dictMenu objectForKey:[@"Vesrion 1.0.0" uppercaseString]]?[dictMenu objectForKey:[@"Vesrion 1.0.0" uppercaseString]]:@"";
                    }
                }
            }else if (i==3) {
                if ([dictMenu objectForKey:[@"Copyright © PigCHAMP 2016" uppercaseString]] && ![[dictMenu objectForKey:[@"Copyright © PigCHAMP 2016" uppercaseString]] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:[@"Copyright © PigCHAMP 2016" uppercaseString]] length]>0) {
                        self.lblCopyright.text = [dictMenu objectForKey:[@"Copyright © PigCHAMP 2016" uppercaseString]]?[dictMenu objectForKey:[@"Copyright © PigCHAMP 2016" uppercaseString]]:@"";
                    }
                }
            }else if (i==4) {
                if ([dictMenu objectForKey:[@"OK" uppercaseString]] && ![[dictMenu objectForKey:[@"OK" uppercaseString]] isKindOfClass:[NSNull class]]){
                    if ([[dictMenu objectForKey:[@"OK" uppercaseString]] length]>0){
                        strOK = [dictMenu objectForKey:[@"OK" uppercaseString]]?[dictMenu objectForKey:[@"OK" uppercaseString]]:@"";
                    }
                }
            }else  if (i==5) {
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
            }
        }
    }

 //

// self.lblVersion.text = [@"Vesrion 1.0." stringByAppendingString:strSelectedDate];

//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(-20, 0, 22, 22);
//    [button setBackgroundImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(btnMenu_tapped:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIButton *buttonRight = [UIButton buttonWithType:UIButtonTypeCustom];
//    buttonRight.frame = CGRectMake(0, 0, 22, 22);
//    [buttonRight setBackgroundImage:[UIImage imageNamed:@"settings"] forState:UIControlStateNormal];
//    [buttonRight addTarget:self action:@selector(btnSettings_tapped) forControlEvents:UIControlEventTouchUpInside];
//    
//    UIBarButtonItem *barButtonRight=[[UIBarButtonItem alloc] init];
//    [barButtonRight setCustomView:buttonRight];
//    self.navigationItem.rightBarButtonItem=barButtonRight;
//    
//    UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
//    [barButton setCustomView:button];
   // self.slidingViewController.navigationItem.leftBarButtonItem = barButton;
//    
//    if (![self.slidingViewController.underLeftViewController isKindOfClass:[MenuViewController class]]) {
//        self.slidingViewController.underLeftViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuView"];
//    }
    
    // [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

//- (IBAction)btnMenu_tapped:(id)sender {
//    
//    if (self.slidingViewController.currentTopViewPosition == ECSlidingViewControllerTopViewPositionAnchoredRight) {
//        self.vwOverlay.hidden = YES;
//        [self.slidingViewController resetTopViewAnimated:YES];
//         self.slidingViewController.title = @"About";
//        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//        button.frame = CGRectMake(-20, 0, 22, 22);
//        [button setBackgroundImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
//        [button addTarget:self action:@selector(btnMenu_tapped:) forControlEvents:UIControlEventTouchUpInside];
//        UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
//        [barButton setCustomView:button];
//        self.slidingViewController.navigationItem.leftBarButtonItem=barButton;
//        self.slidingViewController.navigationItem.rightBarButtonItem=nil;
//        self.slidingViewController.navigationItem.hidesBackButton=YES;
//
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
//         self.slidingViewController.title = @"PigCHAMP";
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
//{
//    return YES;
//}

-(void)updateMenuBarPositions {
    @try {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeView:) name:@"CloseAlert" object:nil];
        UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
        
        if (!isOpenAbout) {
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
        
        isOpenAbout = !isOpenAbout;
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
                                 handler:^(UIAlertAction *action) {
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
            
        }else if ([responseData isEqualToString:@""]){
            [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];
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
        isOpenAbout = !isOpenAbout;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in removeView=%@",exception.description);
    }
}

-(void)btnSettings_tapped
{
    @try {
        settingsViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"Settings"];
        [self presentViewController:settingsViewController animated:NO completion:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in btnSettings_tapped =%@",exception.description);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
