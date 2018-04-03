//
//  SowDetailsViewController.m
//  PigChamp
//
//  Created by Venturelabour on 11/03/16.
//  Copyright © 2016 Venturelabour. All rights reserved.
//

#import "SowDetailsViewController.h"
#import "SimpeNdetailedSowReportViewController.h"
#import "CoreDataHandler.h"
#import <Google/Analytics.h>

BOOL isOpenSowDetailReport = NO;

@interface SowDetailsViewController ()
@end

@implementation SowDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setValue:@"0" forKey:@"reload"];
    [pref synchronize];
    
    tlc = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button1 setImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(updateMenuBarPositions) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem=rightBarButtonItem;
    
    SlideNavigationController *sld = [SlideNavigationController sharedInstance];
    sld.delegate = self;

    
    _btnRunReport.layer.shadowColor = [[UIColor grayColor] CGColor];
    _btnRunReport.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    _btnRunReport.layer.shadowOpacity = 1.0f;
    _btnRunReport.layer.shadowRadius = 3.0f;

    _btnCancel.layer.shadowColor = [[UIColor grayColor] CGColor];
    _btnCancel.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    _btnCancel.layer.shadowOpacity = 1.0f;
    _btnCancel.layer.shadowRadius = 3.0f;
    
    id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
    [tracker set:kGAIScreenName value:@"Simple and Detailed Sow Report input screen"];
    [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(-20, 0, 22, 22);
    [button setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnBack_tapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
    [barButton setCustomView:button];
    self.navigationItem.leftBarButtonItem=barButton;
    
    self.title = @"Sow Details";

    strRptType = @"1";
    [self.btnSimple setBackgroundImage:[UIImage imageNamed:@"tickmark"] forState:UIControlStateNormal];
    [self.btnDetailed setBackgroundImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
    
    strValidationMsg = @"Please enter Sow Identity.";
    strOK = @"OK";
    strUnauthorised = @"Your session has been expired. Please login again.";
    strServerErr  = @"Server Error.";
    
    NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:@"Please enter Sow Identity.",@"OK",@"Sow Details",@"Your session has been expired. Please login again.",@"Server Error.",nil]];
    
    NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
    
    if (resultArray1.count!=0){
        for (int i=0; i<resultArray1.count; i++){
            [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
        }
        
        for (int i=0; i<5; i++) {
            if (i==0) {
                if ([dictMenu objectForKey:[@"Please enter Sow Identity." uppercaseString]] && ![[dictMenu objectForKey:[@"Please enter Sow Identity." uppercaseString]] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:[@"Please enter Sow Identity." uppercaseString]] length]>0) {
                        strValidationMsg = [dictMenu objectForKey:[@"Please enter Sow Identity." uppercaseString]]?[dictMenu objectForKey:[@"Please enter Sow Identity." uppercaseString]]:@"";
                    }
                }
            }else  if (i==1) {
                if ([dictMenu objectForKey:[@"OK" uppercaseString]] && ![[dictMenu objectForKey:[@"OK" uppercaseString]] isKindOfClass:[NSNull class]]){
                    if ([[dictMenu objectForKey:[@"OK" uppercaseString]] length]>0){
                        strOK = [dictMenu objectForKey:[@"OK" uppercaseString]]?[dictMenu objectForKey:[@"OK" uppercaseString]]:@"";
                    }
                }
            }else  if (i==2) {
                if ([dictMenu objectForKey:[@"Sow Details" uppercaseString]] && ![[dictMenu objectForKey:[@"Sow Details" uppercaseString]] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:[@"Sow Details" uppercaseString]] length]>0) {
                        self.title = [dictMenu objectForKey:[@"Sow Details" uppercaseString]]?[dictMenu objectForKey:[@"Sow Details" uppercaseString]]:@"";
                    }
                }
            }else  if (i==3) {
                if ([dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] && ![[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] length]>0) {
                        strUnauthorised = [dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]]?[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]]:@"";
                    }
                }
            }else  if (i==4){
                if ([dictMenu objectForKey:[@"Server Error." uppercaseString]] && ![[dictMenu objectForKey:[@"Server Error." uppercaseString]] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:[@"Server Error." uppercaseString]] length]>0) {
                        strServerErr = [dictMenu objectForKey:[@"Server Error." uppercaseString]]?[dictMenu objectForKey:[@"Server Error." uppercaseString]]:@"";
                    }
                }
            }
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    @try {
        
        [super viewWillAppear:animated];
        isOpenSowDetailReport = NO;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception =%@",exception.description);
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

-(void)viewDidLayoutSubviews {
    @try {
        [super viewDidLayoutSubviews];
        [self.scrSowBg setContentSize:CGSizeMake([[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height)];
    }
    @catch (NSException *exception){
        NSLog(@"Exception in viewDidLayoutSubviews in ViewController=%@",exception.description);
    }
}

-(void)updateMenuBarPositions {
    @try {
        [self.txtIdentity resignFirstResponder];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeView:) name:@"CloseAlert" object:nil];

        UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
        
        if (!isOpenSowDetailReport) {
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
        
        isOpenSowDetailReport = !isOpenSowDetailReport;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception = %@",exception.description);
    }
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    @try {
        if([string isEqualToString:@""])
            return YES;
        
        if (textField.text.length>14) {
            return NO;
        }
        
        return YES;
    }
    @catch (NSException *exception){
        NSLog(@"Exception in shouldChangeCharactersInRange- %@",[exception description]);
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
        isOpenSowDetailReport = !isOpenSowDetailReport;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in removeView=%@",exception.description);
    }
}
//- (BOOL)slideNavigationControllerShouldDisplayRightMenu{
//    return YES;
//}

- (IBAction)btnSnner_tapped:(id)sender {
    @try {
        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
        //NSString *strRFID = [pref valueForKey:@"isRFID"];
        NSString *strBar = [pref valueForKey:@"isBarcode"];
        
        if ([strBar isEqualToString:@"1"]){
            barcodeScannerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"segueBarcode"];
            barcodeScannerViewController.delegate = self;
            [self.navigationController pushViewController:barcodeScannerViewController animated:NO];
        }else{
            
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in btnSnnerType_tapped=%@",exception.description);
    }
}

-(void)scannedBarcode:(NSString *)barcode{
    @try {
        self.txtIdentity.text =  barcode;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in scannedBarcode=%@",exception.description);
    }
}

- (IBAction)btnRunReport_tapped:(id)sender {
    @try {
        if ([self.txtIdentity.text isEqualToString:@""] || [self.txtIdentity.text isEqual:nil] || self.txtIdentity.text == nil) {
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                       message:strValidationMsg
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:strOK
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction *action) {
                                     [self.txtIdentity becomeFirstResponder];
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [myAlertController addAction: ok];
            [self presentViewController:myAlertController animated:YES completion:nil];
        }else {
            [self performSegueWithIdentifier:@"segueSowReport" sender:self];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in btnRunReport_tapped=%@",exception.description);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    @try {
        [textField resignFirstResponder];
        return YES;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in textFieldShouldReturn in ViewController- %@",[exception description]);
    }
}

- (IBAction)btnCancel_tapped:(id)sender {
    @try {
        [self.navigationController popViewControllerAnimated:YES];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in btnCancel_tapped=%@",exception.description);
    }
}

- (IBAction)btnSimpleNDetailed_tapped:(id)sender {
    @try {
        UIButton *btn = (UIButton*)sender;
        [self.btnSimple setBackgroundImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
        [self.btnDetailed setBackgroundImage:[UIImage imageNamed:@"Unchecked"] forState:UIControlStateNormal];
        
        if (btn.tag==1){
            strRptType = @"1";
            [self.btnSimple setBackgroundImage:[UIImage imageNamed:@"tickmark"] forState:UIControlStateNormal];
        }
        else{
            strRptType = @"2";
            [self.btnDetailed setBackgroundImage:[UIImage imageNamed:@"tickmark"] forState:UIControlStateNormal];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in btnExactNPartialMatch_tapped =%@",exception.description);
    }
}

-(void)btnBack_tapped {
    @try {
        [self.navigationController popViewControllerAnimated:YES];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in btnBack_tapped=%@",exception.description);
    }
}

#pragma mark - Navigation
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    @try {
        SimpeNdetailedSowReportViewController *simpeNdetailedSowReportViewController = segue.destinationViewController;
        simpeNdetailedSowReportViewController.strType = strRptType;
            simpeNdetailedSowReportViewController.strIdentity = self.txtIdentity.text;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in prepareForSegue =%@",exception.description);
    }
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

@end
