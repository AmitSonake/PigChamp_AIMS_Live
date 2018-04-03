//
//  HerdSummaryViewController.m
//  PigChamp
//
//  Created by Venturelabour on 16/03/16.
//  Copyright © 2016 Venturelabour. All rights reserved.
//

#import "HerdSummaryViewController.h"
#import "ServerManager.h"
#import "ControlSettings.h"
#import "CoreDataHandler.h"
#import <Google/Analytics.h>

BOOL isOpenHerdReport = NO;

@interface HerdSummaryViewController ()
@end

@implementation HerdSummaryViewController

#pragma mark - view life cycle
- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        tlc = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [button1 setImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(updateMenuBarPositions) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
        self.navigationItem.rightBarButtonItem=rightBarButtonItem;
        
        SlideNavigationController *sld = [SlideNavigationController sharedInstance];
        sld.delegate = self;

        
//        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//        [tracker set:kGAIScreenName value:@"Herd Summary Report"];
//        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
        self.navigationController.navigationBar.translucent = NO;

        {
            strOK =@"OK";
            strPlzWait = @"Please Wait...";
            strNoInternet = @"You must be online for the app to function.";
            strUnauthorised = @"Your session has been expired. Please login again.";
            strServerErr= @"Server Error.";
            strSignOff = @"Signing off.";

            NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:@"OK",@"Please Wait...",@"You must be online for the app to function.",@"Your session has been expired. Please login again.",@"Server Error.",@"Signing off.",nil]];
            
            NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
            
            if (resultArray1.count!=0){
                for (int i=0; i<resultArray1.count; i++){
                    [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                }
                
                for (int i=0; i<6; i++) {
                    if (i==0){
                        if ([dictMenu objectForKey:[@"OK" uppercaseString]] && ![[dictMenu objectForKey:[@"OK" uppercaseString]] isKindOfClass:[NSNull class]]){
                            if ([[dictMenu objectForKey:[@"OK" uppercaseString]] length]>0){
                                strOK = [dictMenu objectForKey:[@"OK" uppercaseString]]?[dictMenu objectForKey:[@"OK" uppercaseString]]:@"";
                            }
                        }
                    }else  if (i==1){
                        if ([dictMenu objectForKey:[@"Please Wait..." uppercaseString]] && ![[dictMenu objectForKey:[@"Please Wait..." uppercaseString]] isKindOfClass:[NSNull class]]) {
                            if ([[dictMenu objectForKey:[@"Please Wait..." uppercaseString]] length]>0) {
                                strPlzWait = [dictMenu objectForKey:[@"Please Wait..." uppercaseString]]?[dictMenu objectForKey:[@"Please Wait..." uppercaseString]]:@"";
                            }
                        }
                    }else  if (i==2){
                        if ([dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]] && ![[dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]] isKindOfClass:[NSNull class]]) {
                            if ([[dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]] length]>0) {
                                strNoInternet = [dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]]?[dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]]:@"";
                            }
                        }
                    }else  if (i==3){
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
                    }else  if (i==5){
                        if ([dictMenu objectForKey:[@"Signing off." uppercaseString]] && ![[dictMenu objectForKey:[@"Signing off." uppercaseString]] isKindOfClass:[NSNull class]]) {
                            if ([[dictMenu objectForKey:[@"Signing off." uppercaseString]] length]>0) {
                                strSignOff = [dictMenu objectForKey:[@"Signing off." uppercaseString]]?[dictMenu objectForKey:[@"Signing off." uppercaseString]]:@"";
                            }
                        }
                    }
                }
            }
        }

        self.title = @"Herd Summary";
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(-20, 0, 22, 22);
        [button setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnBack_tapped) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
        [barButton setCustomView:button];
        self.navigationItem.leftBarButtonItem=barButton;
        
        if ([[ControlSettings sharedSettings] isNetConnected]) {
            [self callWebService];
        }
        else {
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                       message:strNoInternet
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:strOK
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action){
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [myAlertController addAction:ok];
            [self presentViewController:myAlertController animated:YES completion:nil];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in viewDidLoad =%@",exception.description);
    }
}

-(void)updateMenuBarPositions {
    @try {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeView:) name:@"CloseAlert" object:nil];

        UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
        
        if (!isOpenHerdReport) {
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
        
        isOpenHerdReport = !isOpenHerdReport;
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
        isOpenHerdReport = !isOpenHerdReport;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in removeView=%@",exception.description);
    }
}

//- (BOOL)slideNavigationControllerShouldDisplayRightMenu{
//    return YES;
//}

#pragma mark - table view methods
//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    @try {
//        return 2;
//    }
//    @catch (NSException *exception) {
//        NSLog(@"Exception in numberOfSectionsInTableView=%@",exception.description);
//    }
//}

//- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
//    @try {
//        if (section==0) {
//            return @"Herd size";
//        } else if (section==1) {
//            return @"Boars";
//        }
//    }
//    @catch (NSException *exception) {
//        
//        NSLog(@"Exception in titleForHeaderInSection=%@",exception.description);
//    }
//}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    @try {
            return 13;
        }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in numberOfRowsInSection=%@",exception.description);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        UITableViewCell * cell;
        
        if (indexPath.row==0 || indexPath.row==12) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"herdCellSectionHeader" forIndexPath:indexPath];
            
            if (cell ==nil) {
                cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"herdCellSectionHeader"];
            }
        }
        else  if (indexPath.row==1 || indexPath.row==5) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"herdCellSectionHeaderTitle" forIndexPath:indexPath];
            
            if (cell ==nil) {
                cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"herdCellSectionHeaderTitle"];
            }
        }else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"herdCell" forIndexPath:indexPath];
            
            if (cell ==nil) {
                cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"herdCell"];
            }
        }
        
        cell.backgroundColor = [UIColor clearColor];
        UILabel *lblDetails = (UILabel*)[cell viewWithTag:3];
        UILabel *lblTitle = (UILabel*)[cell viewWithTag:2];

        if (indexPath.row==0 || indexPath.row==12) {
            if (indexPath.row==0) {
            lblDetails.text = [dict valueForKey:@"Herd Size"];
                NSLog(@"lblDetails.text=%@",[dict valueForKey:@"Herd Size"]);
            lblTitle.text = @"Herd size";
            }else {
            lblDetails.text = [dict valueForKey:@"Boars"];
            lblTitle.text = @"Boars";
            }
        }else  if (indexPath.row==1 || indexPath.row==5){
            if (indexPath.row==1) {
                lblDetails.text = [dict valueForKey:@"Gilts"];
                 lblTitle.text = @"Gilts";
            }else {
                lblDetails.text = [dict valueForKey:@"Sows"];
                 lblTitle.text = @"Sows";
            }
        }else {
            if (indexPath.row==2) {
                lblDetails.text = [dict valueForKey:@"Retained"];
                lblTitle.text = @"Retained";
            }else if (indexPath.row==3){
                lblDetails.text = [dict valueForKey:@"Available"];
                lblTitle.text = @"Available";
            }else if (indexPath.row==4){
                lblDetails.text = [dict valueForKey:@"Served"];
                lblTitle.text = @"Served";
            }else if (indexPath.row==6){
                lblDetails.text = [dict valueForKey:@"Dry (Weaned)"];
                lblTitle.text = @"Dry (Weaned)";
            }else if (indexPath.row==7){
                lblDetails.text = [dict valueForKey:@"Assumed In-Pig"];
                lblTitle.text = @"Assumed In-Pig";
            }else if (indexPath.row==8){
                lblDetails.text = [dict valueForKey:@"Not In-Pig"];
                lblTitle.text = @"Not In-Pig";
            }else if (indexPath.row==9){
                lblDetails.text = [dict valueForKey:@"Aborted"];
                lblTitle.text = @"Aborted";
            }else if (indexPath.row==10){
                lblDetails.text = [dict valueForKey:@"Lactating"];
                lblTitle.text = @"Lactating";
            }else if (indexPath.row==11){
                lblDetails.text = [dict valueForKey:@"Nurse Sows"];
                lblTitle.text = @"Nurse Sows";
            }
        }
        
        return cell;
    }
    @catch (NSException *exception){
        
        NSLog(@"Exception in cellForRowAtIndexPath =%@",exception.description);
    }
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    @try {
//        return 45;
//    }
//    @catch (NSException *exception) {
//        
//        NSLog(@"Exception in heightForFooterInSection=%@",exception.description);
//    }
//}


//- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section //
//{
//    @try {
//        static NSString *CellIdentifier = @"herdCellSectionHeaderTitle";
//        UITableViewCell *headerView = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//        if (headerView == nil){
//            [NSException raise:@"headerView == nil.." format:@"No cells with matching CellIdentifier loaded from your storyboard"];
//        }
//        
//        return headerView;
//    }
//    @catch (NSException *exception) {
//        
//        NSLog(@"Exception in viewForFooterInSection = %@",exception.description);
//    }
//}

#pragma mark - Other methods
-(void)btnBack_tapped{
    @try {
        [self.navigationController popViewControllerAnimated:YES];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in btnBack_tapped=%@",exception.description);
    }
}

-(void)callWebService {
    @try {
        _customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
        [_customIOS7AlertView showLoaderWithMessage:strPlzWait];
        
        [ServerManager sendRequest:[NSString stringWithFormat:@"token=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"]] idOfServiceUrl:23 headers:nil methodType:@"GET" onSucess:^(NSString *responseData) {
            
            [_customIOS7AlertView close];
            id response = [NSJSONSerialization JSONObjectWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
           
            if ([responseData isEqualToString:@"\"User is not signed in or Session expired\""] || [responseData localizedCaseInsensitiveContainsString:@"\"Token not found\""]) {
                UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                           message:responseData
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:strOK
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         [self.navigationController popToRootViewControllerAnimated:YES];
                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     }];
                
                [myAlertController addAction:ok];
                [self presentViewController:myAlertController animated:YES completion:nil];
            } else if ([response isKindOfClass:[NSDictionary class]]) {
               NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                
                NSArray *arrHerd = [dictResponse valueForKey:@"_HerdSummary"];
                if (![[dictResponse valueForKey:@"ErrorMsg"] isKindOfClass:[NSNull class]]) {
                    if ([[dictResponse valueForKey:@"ErrorMsg"] localizedCaseInsensitiveContainsString:@"Not connected"])
                    {//to do too
                        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                   message:NSLocalizedString(@"connection_lost", @"")
                                                                                            preferredStyle:UIAlertControllerStyleAlert];
                        UIAlertAction* ok = [UIAlertAction
                                             actionWithTitle:strOK
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
                                                                          actionWithTitle:strOK
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
                }
                
                dict = [[NSMutableDictionary alloc]init];
                
                for (NSDictionary *dictRp in arrHerd ) {
                    if (![[dictRp valueForKey:@"prop"] isKindOfClass:[NSNull class]]) {
                        [dict setValue:[dictRp valueForKey:@"val"] forKey:[dictRp valueForKey:@"prop"]];
                    }
                }
                
                [self.tblHerdReport reloadData];
                NSLog(@"arrHerd=%@",arrHerd);
            }
            
            NSLog(@"response=%@",response);
        }onFailure:^(NSMutableDictionary *responseData, NSError *error) {
            [_customIOS7AlertView close];
            
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
            [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateformate stringFromDate:[NSDate date]];
            
            NSString *strErr = [NSString stringWithFormat:@"User Name = %@,Farm Name = %@,error = %@,DateTime=%@,Event =%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],[[NSUserDefaults standardUserDefaults] objectForKey:@"f_nm"],error.description,strDate, self.title];
            [tracker set:kGAIScreenName value:strErr];
            [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

            if ([responseData.allKeys containsObject:@"code"]) {
                if ([[responseData valueForKey:@"code"]integerValue] ==401) {
                    
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:strUnauthorised
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOK
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
                                         actionWithTitle:strOK
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
                                     actionWithTitle:strOK
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action) {
                                         //[self.navigationController popToRootViewControllerAnimated:YES];
                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     }];
                
                [myAlertController addAction: ok];
                [self presentViewController:myAlertController animated:YES completion:nil];
            }
        }];
    }
    @catch (NSException *exception) {
        [_customIOS7AlertView close];
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
        [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [dateformate stringFromDate:[NSDate date]];
        
        NSString *strErr = [NSString stringWithFormat:@"User Name = %@,Farm Name = %@,error = %@,DateTime=%@,Event =%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],[[NSUserDefaults standardUserDefaults] objectForKey:@"farm_name"],exception.description,strDate, self.title];
        [tracker set:kGAIScreenName value:strErr];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    
        NSLog(@"Exception in callWebService=%@",exception.description);
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
