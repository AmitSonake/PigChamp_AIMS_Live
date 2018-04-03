//
//  SimpeNdetailedSowReportViewController.m
//  PigChamp
//
//  Created by Venturelabour on 28/03/16.
//  Copyright © 2016 Venturelabour. All rights reserved.
//

#import "SimpeNdetailedSowReportViewController.h"
#import "CoreDataHandler.h"
#import "ServerManager.h"
#import "ControlSettings.h"
#import "cell.h"
#import "contentCollectionViewCell.h"
#import <Google/Analytics.h>

BOOL isOpenDetailsSowReport =NO;
@interface SimpeNdetailedSowReportViewController ()
@end

@implementation SimpeNdetailedSowReportViewController
@synthesize strIdentity;

- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        self.navigationController.navigationBar.translucent = NO;

        tlc = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [button1 setImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(updateMenuBarPositions) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
        self.navigationItem.rightBarButtonItem=rightBarButtonItem;
        
        SlideNavigationController *sld = [SlideNavigationController sharedInstance];
        sld.delegate = self;

//        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//        [tracker set:kGAIScreenName value:@"Simple and Detailed Sow Report"];
//        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

        self.title = @"Sow Details";
        {
            strOK =@"OK";
            strPlzWait = @"Please Wait...";
            strNoInternet = @"You must be online for the app to function.";
            strUnauthorised =@"Your session has been expired. Please login again.";
            strServerErr= @"Server Error.";
            strSignOff = @"Signing off.";

            NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:@"OK",@"Please Wait...",@"You must be online for the app to function.",@"Sow Details",@"Your session has been expired. Please login again.",@"Server Error.",@"Signing off.",nil]];
            
            NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
            
            if (resultArray1.count!=0){
                for (int i=0; i<resultArray1.count; i++){
                    [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                }
                
                for (int i=0; i<7; i++) {
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
                        if ([dictMenu objectForKey:[@"Sow Details" uppercaseString]] && ![[dictMenu objectForKey:[@"Sow Details" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            if ([[dictMenu objectForKey:[@"Sow Details" uppercaseString]] length]>0) {
                                self.title = [dictMenu objectForKey:[@"Sow Details" uppercaseString]]?[dictMenu objectForKey:[@"Sow Details" uppercaseString]]:@"";
                            }
                        }
                    }else  if (i==4){
                        if ([dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] && ![[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] isKindOfClass:[NSNull class]]) {
                            if ([[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] length]>0) {
                                strUnauthorised = [dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]]?[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]]:@"";
                            }
                        }
                    }else  if (i==5){
                        if ([dictMenu objectForKey:[@"Server Error." uppercaseString]] && ![[dictMenu objectForKey:[@"Server Error." uppercaseString]] isKindOfClass:[NSNull class]]) {
                            if ([[dictMenu objectForKey:[@"Server Error." uppercaseString]] length]>0) {
                                strServerErr = [dictMenu objectForKey:[@"Server Error." uppercaseString]]?[dictMenu objectForKey:[@"Server Error." uppercaseString]]:@"";
                            }
                        }
                    }else  if (i==6){
                        if ([dictMenu objectForKey:[@"Signing off." uppercaseString]] && ![[dictMenu objectForKey:[@"Signing off." uppercaseString]] isKindOfClass:[NSNull class]]) {
                            if ([[dictMenu objectForKey:[@"Signing off." uppercaseString]] length]>0) {
                              strSignOff = [dictMenu objectForKey:[@"Signing off." uppercaseString]]?[dictMenu objectForKey:[@"Signing off." uppercaseString]]:@"";
                            }
                        }
                    }
                }
            }
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(-20, 0, 22, 22);
        [button setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnBack_tapped) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
        [barButton setCustomView:button];
        self.navigationItem.leftBarButtonItem = barButton;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in viewDidLoad =%@",exception.description);
    }
}

-(void)viewWillAppear:(BOOL)animated{
    @try {
        [super viewWillAppear:animated];
        isOpenDetailsSowReport = NO;
        
        if ([_strType isEqualToString:@"1"]) {
            [self btnSimple_tapped:nil];
        }else{
            [self btnDetailed_tapped:nil];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in viewWillAppear=%@",exception.description);
    }
}

-(void)updateMenuBarPositions {
    @try {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeView:) name:@"CloseAlert" object:nil];

        UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
        
        if (!isOpenDetailsSowReport) {
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
        
        isOpenDetailsSowReport = !isOpenDetailsSowReport;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception =%@",exception.description);
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
        isOpenDetailsSowReport = !isOpenDetailsSowReport;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in removeView=%@",exception.description);
    }
}

//- (BOOL)slideNavigationControllerShouldDisplayRightMenu{
//    return YES;
//}


#pragma mark - table methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try {
        return [arrSimpleNdetailed count];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in numberOfRowsInSection=%@",exception.description);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        UITableViewCell * cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"Summary"];
        
        if (cell ==nil){
            cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Summary"];
        }
        
        NSLog(@"arrSimpleNdetailed=%@",arrSimpleNdetailed);
        UILabel *lblName = (UILabel*)[cell viewWithTag:1];
        if (![[[arrSimpleNdetailed objectAtIndex:indexPath.row] valueForKey:@"prop"] isKindOfClass:[NSNull class]]){
            lblName.text = [[arrSimpleNdetailed objectAtIndex:indexPath.row] valueForKey:@"prop"]?[[arrSimpleNdetailed objectAtIndex:indexPath.row] valueForKey:@"prop"]:@"";
        }
        
        UILabel *lblValue = (UILabel*)[cell viewWithTag:2];
        if (![[[arrSimpleNdetailed objectAtIndex:indexPath.row] valueForKey:@"val"] isKindOfClass:[NSNull class]]){
            NSString *strValue  =[[arrSimpleNdetailed objectAtIndex:indexPath.row] valueForKey:@"val"]?[[arrSimpleNdetailed objectAtIndex:indexPath.row] valueForKey:@"val"]:@"";
            
            if (![[[arrSimpleNdetailed objectAtIndex:indexPath.row] valueForKey:@"val"] isKindOfClass:[NSNull class]]) {
                if (strValue.length==0) {
                    lblValue.text = @"-";
                }else {
                    lblValue.text =strValue;
                }
            }
        }
        
        return cell;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in cellForRowAtIndexPath=%@",exception.description);
    }
}

#pragma mark - collection view methods
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return 4;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    @try {
        if (arrSimpleNdetailed.count>0) {
            return arrSimpleNdetailed.count+1;
        }else {
            return arrSimpleNdetailed.count;
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in numberOfSectionsInCollectionView=%@",exception.description);
    }
}

// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section==0){
        cell *cellobj= [cv dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        
        if (indexPath.row==0) {
            cellobj.lblHeader.text = @"";
        }
        else if (indexPath.row==1) {
            cellobj.lblHeader.text = @"Current";
        }
        else if (indexPath.row==2) {
            cellobj.lblHeader.text = @"Last Parity";
        }
        else if (indexPath.row==3) {
            cellobj.lblHeader.text = @"Life Time";
        }
        else if (indexPath.row==4) {
            cellobj.lblHeader.text =@"";
        }
        
        return cellobj;
    }
    else {
        contentCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"content" forIndexPath:indexPath];
        NSDictionary *dict  = [arrSimpleNdetailed objectAtIndex:indexPath.section-1];
        {
            if (indexPath.row==0)  {
                if (![[dict valueForKey:@"Prop"] isKindOfClass:[NSNull class]])
                {
                    if ([[dict valueForKey:@"Prop"] length]>0) {
                        cell.lblcontent.text = [dict valueForKey:@"Prop"]?[dict valueForKey:@"Prop"]:@"";
                    }else {
                        cell.lblcontent.text = @"";
                    }
                }else {
                    cell.lblcontent.text = @"";
                }
            }
            else if (indexPath.row==1)
            {
                if (![[dict valueForKey:@"Current"] isKindOfClass:[NSNull class]]){
                    
                    if ([[dict valueForKey:@"Current"] length]>0){
                        cell.lblcontent.text = [dict valueForKey:@"Current"]?[dict valueForKey:@"Current"]:@"";
                    }else{
                        cell.lblcontent.text = @"";
                    }
                }else{
                    cell.lblcontent.text = @"";
                }
            }
            else if (indexPath.row==2) {
                if (![[dict valueForKey:@"LastParity"] isKindOfClass:[NSNull class]]){
                    
                    if ([[dict valueForKey:@"LastParity"] length]>0){
                        cell.lblcontent.text = [dict valueForKey:@"LastParity"]?[dict valueForKey:@"LastParity"]:@"";
                    }else{
                        cell.lblcontent.text = @"";
                    }
                }else{
                    cell.lblcontent.text = @"";
                }
            }
            else if (indexPath.row==3) {
                if (![[dict valueForKey:@"LifeTime"] isKindOfClass:[NSNull class]]){
                    if ([[dict valueForKey:@"LifeTime"] length]>0){
                        cell.lblcontent.text = [dict valueForKey:@"LifeTime"]?[dict valueForKey:@"LifeTime"]:@"";
                    }else{
                        cell.lblcontent.text = @"";
                    }
                }else{
                    cell.lblcontent.text = @"";
                }
            }
        }
        
        //        if (selecteditem == indexPath.section)
        //            cell.backgroundColor = [UIColor yellowColor];
        //        else
        //            cell.backgroundColor = [UIColor clearColor];
        
        return cell;
    }
    
    // cell.lbl.text = @"Data";
}

#pragma mark - Other methods
-(void)btnBack_tapped {
    @try {
        [self.navigationController popViewControllerAnimated:YES];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in btnBack_tapped=%@",exception.description);
    }
}

-(void)callWebService {
    @try {
        arrSimpleNdetailed = [[NSMutableArray alloc]init];
        NSLog(@"strIdentity=%@",strIdentity);
        
        _customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
        [_customIOS7AlertView showLoaderWithMessage:strPlzWait];
         //strIdentity=@"0028";
        [ServerManager sendRequest:[NSString stringWithFormat:@"token=%@&Identity=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],strIdentity] idOfServiceUrl:25 headers:nil methodType:@"GET" onSucess:^(NSString *responseData) {
            @try {
                [_customIOS7AlertView close];
                
                id response = [NSJSONSerialization JSONObjectWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                
                //
                NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                
                if (![[dictResponse valueForKey:@"ErrorMsg"] isKindOfClass:[NSNull class]] && [[dictResponse allKeys]containsObject:@"ErrorMsg"]) {
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
                //
                
                if ([responseData isEqualToString:@"\"User is not signed in or Session expired\""] || [responseData localizedCaseInsensitiveContainsString:@"\"Token not found\""]) {
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:responseData
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOK
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action){
                                             [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    
                    [myAlertController addAction: ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                } else if ([response isKindOfClass:[NSDictionary class]]) {
                    //NSArray *arrPropVal = [NSJSONSerialization JSONObjectWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding] options:
                    //                    NSJSONReadingMutableContainers error:nil];
                    NSArray *arrPropVal = [dictResponse valueForKey:@"_ReportData"];
                    
                    NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                    
                    if (![[dictResponse valueForKey:@"ErrorMsg"] isKindOfClass:[NSNull class]]) // to do yo
                    {
                        if ([[dictResponse valueForKey:@"ErrorMsg"] localizedCaseInsensitiveContainsString:@"Not connected"]) {
                            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                       message:NSLocalizedString(@"connection_lost", @"")
                                                                                                preferredStyle:UIAlertControllerStyleAlert];
                            UIAlertAction* ok = [UIAlertAction
                                                 actionWithTitle:strOK
                                                 style:UIAlertActionStyleDefault
                                                 handler:^(UIAlertAction * action) {
                                                     if ([[ControlSettings sharedSettings] isNetConnected ]) {
                                                         _customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
                                                         [_customIOS7AlertView showLoaderWithMessage:strSignOff];
                                                         
                                                         [ServerManager sendRequestForLogout:^(NSString *responseData) {
                                                             //NSLog(@"%@",responseData);
                                                             [_customIOS7AlertView close];
                                                             
                                                             if ([responseData isEqualToString:@"\"User is not signed in or Session expired\""] || [responseData localizedCaseInsensitiveContainsString:@"\"Token not found\""])  {
                                                             }else if ([responseData isEqualToString:@"\"Loged out\""] || [responseData isEqualToString:@""]) {
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
                    }else{
                        for (NSDictionary *dict in arrPropVal) {
                            if (![[dict valueForKey:@"prop"] isKindOfClass:[NSNull class]] && ![[dict valueForKey:@"val"] isKindOfClass:[NSNull class]]) {
                                [arrSimpleNdetailed addObject:dict];
                            }
                        }
                    }
                }
                
                if (arrSimpleNdetailed.count>0) {
                    [self.tblSimple reloadData];
                }else {
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:@"Female Identity does not exists."
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOK
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }];
                    [myAlertController addAction:ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                }
                NSLog(@"response=%@",response);
            }
            @catch (NSException *exception) {
                
                NSLog(@"Exception =%@",exception.description);
            }
            
            
        }onFailure:^(NSMutableDictionary *responseData, NSError *error) {
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
            [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateformate stringFromDate:[NSDate date]];
            
            NSString *strErr = [NSString stringWithFormat:@"User Name = %@,Farm Name = %@,error = %@,DateTime=%@,Event=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],[[NSUserDefaults standardUserDefaults] objectForKey:@"f_nm"],error.description,strDate,@"Simple Report"];
            [tracker set:kGAIScreenName value:strErr];
            [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
            [_customIOS7AlertView close];
            
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
        
        NSLog(@"Exception in callWebService=%@",exception.description);
    }
}

- (IBAction)btnDetailed_tapped:(id)sender {
    @try {
        self.vwHistory.hidden = NO;
        self.tblSimple.hidden= YES;
        self.vwUndelineHistory.hidden = YES;
        self.vwUnderlineSummary.hidden = NO;
        
        if ([[ControlSettings sharedSettings] isNetConnected ]) {
            [self callWebServiceDetailed];
        }
        else{
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                       message:strNoInternet
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:strOK
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action){
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [myAlertController addAction: ok];
            [self presentViewController:myAlertController animated:YES completion:nil];
        }    }
    @catch (NSException *exception) {
        NSLog(@"Exception in btnSummary_tapped =%@",exception.description);
    }
}

- (IBAction)btnSimple_tapped:(id)sender {
    @try {
        self.vwHistory.hidden = YES;
        self.tblSimple.hidden = NO;
        self.vwUndelineHistory.hidden = NO;
        self.vwUnderlineSummary.hidden = YES;
        
        if ([[ControlSettings sharedSettings] isNetConnected ]) {
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
            
            [myAlertController addAction: ok];
            [self presentViewController:myAlertController animated:YES completion:nil];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in btnSimple_tapped=%@",exception.description);
    }
}

-(void)callWebServiceDetailed {
    @try {
        arrSimpleNdetailed = [[NSMutableArray alloc]init];
        NSLog(@"strIdentity=%@",strIdentity);
        
        _customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
        [_customIOS7AlertView showLoaderWithMessage:strPlzWait];
        [ServerManager sendRequest:[NSString stringWithFormat:@"token=%@&Identity=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],strIdentity] idOfServiceUrl:26 headers:nil methodType:@"GET" onSucess:^(NSString *responseData) {
            
            [_customIOS7AlertView close];
            
            //id response = [NSJSONSerialization JSONObjectWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            
            NSDictionary *dictResponse = [NSJSONSerialization JSONObjectWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            
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
         
            if ([responseData isEqualToString:@"\"User is not signed in or Session expired\""] || [responseData localizedCaseInsensitiveContainsString:@"\"Token not found\""]) {
                UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                           message:responseData
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:strOK
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action) {
              [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     }];
                
                [myAlertController addAction:ok];
                [self presentViewController:myAlertController animated:YES completion:nil];
            } else if ([dictResponse isKindOfClass:[NSDictionary class]]) {
                arrSimpleNdetailed = [dictResponse valueForKey:@"_SowDetailsData"];
                
                if (arrSimpleNdetailed.count>0) {
                    [self.clHistory reloadData];
                }else {
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:@"Female Identity does not exists."
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOK
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action){
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }];
                    
                    [myAlertController addAction:ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                }
            }
           
            //[self.clHistory reloadData];
            NSLog(@"response=%@",dictResponse);
        }onFailure:^(NSMutableDictionary *responseData, NSError *error) {
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
            [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateformate stringFromDate:[NSDate date]];
            
            NSString *strErr = [NSString stringWithFormat:@"User Name = %@,Farm Name = %@,error = %@,DateTime=%@,Event=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],[[NSUserDefaults standardUserDefaults] objectForKey:@"f_nm"],error.description,strDate,@"Detailed Report"];
            [tracker set:kGAIScreenName value:strErr];
            [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
            [_customIOS7AlertView close];
            
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
