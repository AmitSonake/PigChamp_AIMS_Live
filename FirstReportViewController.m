
//
//  FirstReportViewController.m
//  PigChamp
//
//  Created by Venturelabour on 04/03/16.
//  Copyright © 2016 Venturelabour. All rights reserved.
//

#import "FirstReportViewController.h"
#import "ServerManager.h"

int records = 20;
int idOFUrl = 0;
NSInteger maxCount = 20;
BOOL canCall= NO;
BOOL isOpenFisrReport = NO;

@interface FirstReportViewController ()
@end

@implementation FirstReportViewController
@synthesize dictHeaders;
@synthesize strEvnt;
@synthesize strPlzWait,strNoInternet,strOk;
@synthesize strTitle;
@synthesize strActiveAnimalreportType;
@synthesize arrReports;

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
        
        self.title = strTitle;
        self.navigationController.navigationBar.translucent = NO;

       strPlzWait = @"Please Wait...";
       strNoInternet = @"You must be online for the app to function.";
       strOk = @"OK";
       strNodataFound = @"No report data to display.";
        strUnauthorised =@"Your session has been expired. Please login again.";
        strServerErr= @"Server Error.";
        strSignOff = @"Signing off";

        //
        NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:@"Please Wait...",@"You must be online for the app to function.",@"Ok",@"No report data to display.",@"Your session has been expired. Please login again.",@"Server Error.",@"Signing off.",nil]];
        
        NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
        
        if (resultArray1!=0) {
            for (int i=0; i<resultArray1.count; i++){
                [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
            }
            
            for (int i=0; i<7; i++) {
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
                }else  if (i==2) {
                    if ([dictMenu objectForKey:[@"Ok" uppercaseString]] && ![[dictMenu objectForKey:[@"Ok" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Ok" uppercaseString]] length]>0) {
                            strOk = [dictMenu objectForKey:[@"Ok" uppercaseString]]?[dictMenu objectForKey:[@"Ok" uppercaseString]]:@"";
                        }
                    }
                }else  if (i==3) {
                    if ([dictMenu objectForKey:[@"No report data to display." uppercaseString]] && ![[dictMenu objectForKey:[@"No report data to display." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"No report data to display." uppercaseString]] length]>0) {
                           strNodataFound = [dictMenu objectForKey:[@"No report data to display." uppercaseString]]?[dictMenu objectForKey:[@"No report data to display." uppercaseString]]:@"";
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
        
        //
        
        NSDate *date = [NSDate date];
        NSLog(@"date=%@",date);
        
        //id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        if ([strEvnt isEqualToString:@"5"]) {
           // [tracker set:kGAIScreenName value:@"Active Animals List Report"];
            idOFUrl = 16;
        }else if ([strEvnt isEqualToString:@"7"]) {
            //[tracker set:kGAIScreenName value:@"Open Sow List Report"];
            idOFUrl = 17;
        }else if ([strEvnt isEqualToString:@"8"]) {
            //[tracker set:kGAIScreenName value:@"Gilt Pool Report"];
            idOFUrl = 18;
        }else if ([strEvnt isEqualToString:@"10"]) {
           // [tracker set:kGAIScreenName value:@"Warning List-Not Serrved Report"];
            idOFUrl = 19;
        }else if ([strEvnt isEqualToString:@"11"]) {
           /// [tracker set:kGAIScreenName value:@"Warning List-Not Weaned Report"];
            idOFUrl = 20;
        }else if ([strEvnt isEqualToString:@"9"]) {
          //  [tracker set:kGAIScreenName value:@"Sows Due to Farrow Report"];
            idOFUrl = 21;
        }else if ([strEvnt isEqualToString:@"6"]) {
           // [tracker set:kGAIScreenName value:@"Sows Due for Attention Report"];
             idOFUrl = 22;
        }
        
       // [tracker send:[[GAIDictionaryBuilder createScreenView] build]];

        arrReports = [[NSMutableArray alloc]init];
        
        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
        [pref setValue:@"" forKey:@"selectedSortType"];
        [pref synchronize];
        
        if ([[ControlSettings sharedSettings] isNetConnected]) {
            [self loadDataDelayed:@"1" toRec:@"20" reportType:@"" sortFld:@"" sortOrd:@"0"];
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
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in viewDidLoad=%@",exception.description);
    }
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

-(void)viewWillAppear:(BOOL)animated{
    @try {
        
        [super viewWillAppear:animated];

        records = 20;
        maxCount = 20;
        canCall = NO;
        
        if ([strEvnt isEqualToString:@"5"]) {
            //strActiveAnimalreportType = [dictHeaders valueForKey:@"reportType"];
        }
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(-20, 0, 22, 22);
        [button setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnBack_tapped) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barButton = [[UIBarButtonItem alloc] init];
        [barButton setCustomView:button];
        self.navigationItem.leftBarButtonItem = barButton;
        //
        
        if ([strEvnt isEqualToString:@"5"]) {
            _arrSortType = [[NSMutableArray alloc]initWithObjects:@"identity (Ascending)", @"Identity (Descending)", @"Sex (Ascending)", @"Sex (Descending)", @"Parity (Ascending)", @"Parity (Descending)", @"Genetics (Ascending)", @"Genetics (Descending)", @"Location (Ascending)", @"Location (Descending)", @"Status (Ascending)", @"Status (Descending)",nil];//active animal
        }else if ([strEvnt isEqualToString:@"7"]) {
            _arrSortType = [[NSMutableArray alloc]initWithObjects:@"identity (Ascending)", @"Identity (Descending)", @"Days (Ascending)", @"Days (Descending)", @"Parity (Ascending)", @"Parity (Descending)", @"Type (Ascending)", @"Type (Descending)", @"Location (Ascending)", @"Location (Descending)",nil];//open sow list
        }else if ([strEvnt isEqualToString:@"8"]) {
            _arrSortType = [[NSMutableArray alloc]initWithObjects:@"identity (Ascending)", @"Identity (Descending)", @"Age In Days (Ascending)", @"Age In Days (Descending)", @"Days In Herd (Ascending)", @"Days In Herd (Descending)", @"Location (Ascending)", @"Location (Descending)", @"No Of Heat Checks (Ascending)", @"No Of Heat Checks (Descending)", @"Status (Ascending)", @"Status (Descending)",nil];//Gilt pool
        }else if ([strEvnt isEqualToString:@"10"]) {
            _arrSortType = [[NSMutableArray alloc]initWithObjects:@"identity (Ascending)", @"Identity (Descending)", @"Days (Ascending)", @"Days (Descending)", @"Parity (Ascending)", @"Parity (Descending)", @"Date (Ascending)", @"Date (Descending)", @"Location (Ascending)", @"Location (Descending)",nil];//warning not weaned/served
            
        }else if ([strEvnt isEqualToString:@"11"]) {
            _arrSortType = [[NSMutableArray alloc]initWithObjects:@"identity (Ascending)", @"Identity (Descending)", @"Days (Ascending)", @"Days (Descending)", @"Parity (Ascending)", @"Parity (Descending)", @"Date (Ascending)", @"Date (Descending)", @"Location (Ascending)", @"Location (Descending)",nil];//warning not weaned/served
        }else if ([strEvnt isEqualToString:@"9"]) {
            _arrSortType = [[NSMutableArray alloc]initWithObjects:@"identity (Ascending)", @"Identity (Descending)", @"Date (Ascending)", @"Date (Descending)",@"Parity (Ascending)", @"Parity (Descending)", @"Barn-Room-Pen (Ascending)", @"Barn-Room-Pen (Descending)",nil];//warning not weaned/served

        }else if ([strEvnt isEqualToString:@"6"]) {
            _arrSortType = [[NSMutableArray alloc]initWithObjects:@"identity (Ascending)", @"Identity (Descending)", @"Date (Ascending)", @"Date (Descending)",@"Parity (Ascending)", @"Parity (Descending)", @"Barn-Room-Pen (Ascending)", @"Barn-Room-Pen (Descending)",nil];//warning not weaned/served
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
        
        if (!isOpenFisrReport) {
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
        
        isOpenFisrReport = !isOpenFisrReport;
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
        isOpenFisrReport = !isOpenFisrReport;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in removeView=%@",exception.description);
    }
}

//- (BOOL)slideNavigationControllerShouldDisplayRightMenu{
//    return YES;
//}

#pragma mark - table methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        if ([strEvnt isEqualToString:@"5"]) {
            return 160;
        }else if ([strEvnt isEqualToString:@"7"]) {
            return 135;
        }else if ([strEvnt isEqualToString:@"8"]) {
            return 190;
        }else if ([strEvnt isEqualToString:@"11"] || [strEvnt isEqualToString:@"10"]) {
            return 135;
        }else if ([strEvnt isEqualToString:@"9"]) {
            return 108;
        }else if ([strEvnt isEqualToString:@"6"]) {
            return 135;
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in heightForRowAtIndexPath=%@",exception.description);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrReports count];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        if (indexPath.row==arrReports.count-1) {
            //NSLog(@"indespath=%ld",(long)indexPath.row);
            [self Pagging];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in forRowAtIndexPath=%@",exception.description);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        UITableViewCell *cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"SecondReportCell"];
        
        if (cell ==nil) {
            cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SecondReportCell"];
        }
        cell.backgroundColor = [UIColor clearColor];

        NSDictionary *dict = [arrReports objectAtIndex:indexPath.row];
        UILabel *identity = (UILabel*)[cell viewWithTag:1];
        UILabel *Sex = (UILabel*)[cell viewWithTag:2];
        UILabel *genetics = (UILabel*)[cell viewWithTag:3];
        UILabel *location = (UILabel*)[cell viewWithTag:4];
        UILabel *status = (UILabel*)[cell viewWithTag:5];
        UILabel *extrStatus = (UILabel*)[cell viewWithTag:6];
        UILabel *Parity = (UILabel*)[cell viewWithTag:7];
        UILabel *lblextrStatus = (UILabel*)[cell viewWithTag:15];
        UILabel *lblParity = (UILabel*)[cell viewWithTag:17];
        
        extrStatus.hidden = NO;
        lblextrStatus.hidden = NO;
    
        if ([strEvnt isEqualToString:@"5"]) {
            identity.text = [dict valueForKey:@"Identity"]?[dict valueForKey:@"Identity"]:@"";
            Sex.text = [dict valueForKey:@"Sex"]?[dict valueForKey:@"Sex"]:@"";
            genetics.text = [dict valueForKey:@"genetics"]?[dict valueForKey:@"genetics"]:@"";
            location.text = [dict valueForKey:@"location"]?[dict valueForKey:@"location"]:@"";
            status.text = [dict valueForKey:@"status"]?[dict valueForKey:@"status"]:@"";
            Parity.text = [dict valueForKey:@"Parity"]?[dict valueForKey:@"Parity"]:@"";
            
            UILabel *extrStatus = (UILabel*)[cell viewWithTag:6];
        
            extrStatus.hidden = YES;
            lblextrStatus.hidden = YES;
        }else if ([strEvnt isEqualToString:@"7"]) {
            identity.text = [dict valueForKey:@"Identity"] ? [dict valueForKey:@"Identity"]:@"";
            Sex.text = [dict valueForKey:@"Days"] ? [dict valueForKey:@"Days"]:@"";
            genetics.text = [dict valueForKey:@"Type"] ? [dict valueForKey:@"Type"]:@"";
            location.text = [dict valueForKey:@"location"] ? [dict valueForKey:@"location"]:@"";
            Parity.text = [dict valueForKey:@"Parity"] ? [dict valueForKey:@"Parity"]:@"";
            
            UILabel *status = (UILabel*)[cell viewWithTag:14];
           // UILabel *extrStatus = (UILabel*)[cell viewWithTag:15];
            
            UILabel *lbDays = (UILabel*)[cell viewWithTag:11];
            lbDays.text = @"Days";
            UILabel *lblSex = (UILabel*)[cell viewWithTag:12];
            lblSex.text = @"Type";
            UILabel *lblgenetics = (UILabel*)[cell viewWithTag:13];
            lblgenetics.text = @"Location";
            
            status.hidden = YES;
            extrStatus.hidden = YES;
            lblextrStatus.hidden = YES;
        }else if ([strEvnt isEqualToString:@"8"]) {
            identity.text = [dict valueForKey:@"Identity"]?[dict valueForKey:@"Identity"]:@"";
            Sex.text = [dict valueForKey:@"AgeInDays"]?[dict valueForKey:@"AgeInDays"]:@"";
            genetics.text = [dict valueForKey:@"DAYS_IN_HERD"]?[dict valueForKey:@"DAYS_IN_HERD"]:@"";
            location.text = [dict valueForKey:@"Location"]?[dict valueForKey:@"Location"]:@"";
            Parity.text = [dict valueForKey:@"Parity"]?[dict valueForKey:@"Parity"]:@"";
            status.text = [dict valueForKey:@"NoOfHeatChecks"]?[dict valueForKey:@"NoOfHeatChecks"]:@"";
            extrStatus.text = [dict valueForKey:@"Status"]?[dict valueForKey:@"Status"]:@"";

            Parity.hidden = YES;
            lblParity.hidden = YES;
            
            UILabel *lblSex = (UILabel*)[cell viewWithTag:11];
            lblSex.text = @"Age in Days";
            UILabel *lblgenetics = (UILabel*)[cell viewWithTag:12];
            lblgenetics.text = @"Days in Herd";

            UILabel *lblHeatChecks = (UILabel*)[cell viewWithTag:14];
            lblHeatChecks.text = @"No of Heat Checks";
        } else if ([strEvnt isEqualToString:@"11"] || [strEvnt isEqualToString:@"10"]) {
            identity.text = [dict valueForKey:@"Identity"]?[dict valueForKey:@"Identity"]:@"";
            Sex.text = [dict valueForKey:@"Days"]?[dict valueForKey:@"Days"]:@"";
            genetics.text = [dict valueForKey:@"Date"]?[dict valueForKey:@"Date"]:@"";
            location.text = [dict valueForKey:@"location"]?[dict valueForKey:@"location"]:@"";
            Parity.text = [dict valueForKey:@"Parity"]?[dict valueForKey:@"Parity"]:@"";
            
            UILabel *lblSex = (UILabel*)[cell viewWithTag:11];
            lblSex.text = @"Days";
            UILabel *lblgenetics = (UILabel*)[cell viewWithTag:12];
            lblgenetics.text = @"Date";
            
            UILabel *lblHeatChecks = (UILabel*)[cell viewWithTag:14];
            lblHeatChecks.hidden = YES;
            
            status.hidden = YES;
            extrStatus.hidden = YES;
            lblextrStatus.hidden = YES;
       } else if ([strEvnt isEqualToString:@"9"]) {
            identity.text = [dict valueForKey:@"Identity"]?[dict valueForKey:@"Identity"]:@"";
            Sex.text = [dict valueForKey:@"Date"]?[dict valueForKey:@"Date"]:@"";
            genetics.text = [dict valueForKey:@"BarnRoomPen"]?[dict valueForKey:@"BarnRoomPen"]:@"";
            //location.text = [dict valueForKey:@"BarnRoomPen"]?[dict valueForKey:@"BarnRoomPen"]:@"";
             Parity.text = [dict valueForKey:@"Parity"]?[dict valueForKey:@"Parity"]:@"";
            
            UILabel *lblSex = (UILabel*)[cell viewWithTag:11];
            lblSex.text = @"Date";
            UILabel *lblgenetics = (UILabel*)[cell viewWithTag:12];
            lblgenetics.text = @"Barn-Room-Pen";
            
            UILabel *lblHeatChecks = (UILabel*)[cell viewWithTag:14];
            UILabel *lblLocation = (UILabel*)[cell viewWithTag:13];
            
            lblLocation.hidden = YES;
            lblHeatChecks.hidden = YES;
            status.hidden = YES;
            extrStatus.hidden = YES;
            lblextrStatus.hidden = YES;
        }else if ([strEvnt isEqualToString:@"6"]) {
            identity.text = [dict valueForKey:@"Date"]?[dict valueForKey:@"Date"]:@"";
            Sex.text = [dict valueForKey:@"Identity"]?[dict valueForKey:@"Identity"]:@"";
            genetics.text = [dict valueForKey:@"Genetics"]?[dict valueForKey:@"Genetics"]:@"";
            location.text = [dict valueForKey:@"BarnRoomPen"]?[dict valueForKey:@"BarnRoomPen"]:@"";
            Parity.text = [dict valueForKey:@"Parity"]?[dict valueForKey:@"Parity"]:@"";
            
            UILabel *lblIdentity = (UILabel*)[cell viewWithTag:100];
            lblIdentity.text = @"Date";
            
            UILabel *lblSex = (UILabel*)[cell viewWithTag:11];
            lblSex.text = @"Identity";
            
//            UILabel *lblgenetics = (UILabel*)[cell viewWithTag:12];
//            lblgenetics.text = @"Date";
            
            UILabel *lblLocation = (UILabel*)[cell viewWithTag:13];
            lblLocation.text = @"Barn-Room-Pen";

            UILabel *lblHeatChecks = (UILabel*)[cell viewWithTag:14];
            lblHeatChecks.hidden = YES;
            
            status.hidden = YES;
            extrStatus.hidden = YES;
            lblextrStatus.hidden = YES;
        }

        return cell;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in cellForRowAtIndexPath=%@",exception.description);
    }
}

#pragma mark - view life cycle
- (IBAction)btnSortType_tapped:(id)sender {
    @try {
        self.pickerSortType = [[UIPickerView alloc] initWithFrame:CGRectMake(15, 0, 270, 150.0)];
        [self.pickerSortType setDelegate:self];
        self.pickerSortType.showsSelectionIndicator = YES;
        
        _alertForSortType = [[CustomIOS7AlertView alloc] init];
        [_alertForSortType setMyDelegate:self];
        [_alertForSortType setUseMotionEffects:true];
        [_alertForSortType setButtonTitles:[NSMutableArray arrayWithObjects:@"OK",@"Cancel", nil]];
       
        __weak typeof(self) weakSelf = self;
        [_alertForSortType setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
            
            if(buttonIndex == 0 && weakSelf.pickerSortType>0) {
                NSInteger row = [weakSelf.pickerSortType selectedRowInComponent:0];
                records = 20;
                maxCount = 20;
                
                NSString *strSortOrd = @"0";
                NSString *strSortType = [weakSelf.arrSortType objectAtIndex:row];
                
                NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
                [pref setValue:strSortType forKey:@"selectedSortType"];
                [pref synchronize];
                
                strSortType = [strSortType stringByReplacingOccurrencesOfString:@" " withString:@""];
                strSortType = [strSortType stringByReplacingOccurrencesOfString:@")" withString:@""];
                
                NSArray *arrSort = [strSortType componentsSeparatedByString:@"("];
                if (arrSort.count == 2) {
                    
                    if ([[arrSort objectAtIndex:0] isEqualToString:@"Barn-Room-Pen"]) {
                        [weakSelf.dictHeaders setValue:@"barnroompen" forKey:@"sortFld"];
                    }else {
                        [weakSelf.dictHeaders setValue:[arrSort objectAtIndex:0] forKey:@"sortFld"];
                    }
                    
                    if ([[arrSort objectAtIndex:1]  isEqualToString:@"Descending"]) {
                        strSortOrd = @"1";
                    }
                }
                
                [weakSelf.dictHeaders setValue:@"1" forKey:@"FromRec"];
                [weakSelf.dictHeaders setValue:@"20" forKey:@"ToRec"];
                [weakSelf.dictHeaders setValue:strSortOrd forKey:@"sortOrd"];
                [weakSelf.arrReports removeAllObjects];
                
                if ([[ControlSettings sharedSettings] isNetConnected]) {
                    [weakSelf loadDataDelayed:@"1" toRec:@"20" reportType:@"" sortFld:@"" sortOrd:@"0"];
                }
                else {
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:weakSelf.strNoInternet
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:weakSelf.strOk
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    
                    [myAlertController addAction:ok];
                    [weakSelf presentViewController:myAlertController animated:YES completion:nil];
                }
            }
            
            [weakSelf.alertForSortType close];
        }];
        
        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
        NSString *strPrevSelectedValue = [pref valueForKey:@"selectedSortType"];
        
        for (int count=0;count<_arrSortType.count;count++) {
            if (strPrevSelectedValue.length>0){
                if( [strPrevSelectedValue caseInsensitiveCompare:[_arrSortType objectAtIndex:count]] == NSOrderedSame){
                    [self.pickerSortType selectRow:count inComponent:0 animated:NO];
                }
            }
        }
        
        [weakSelf.alertForSortType showCustomwithView:self.pickerSortType title:@"Select Sort Type"];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in btnSortType_tapped =%@",exception.description);
    }
}

-(void)Pagging{
    @try {
        
        BOOL loading = '\0';
        if (!loading) {
           // float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
            
            if (maxCount>records) {
                //if (endScrolling >= scrollView.contentSize.height && !canCall)
                {
                    [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                        [dictHeaders setValue:[NSString stringWithFormat:@"%d",records+1] forKey:@"FromRec"];
                        [dictHeaders setValue:[NSString stringWithFormat:@"%d",records+20] forKey:@"ToRec"];
                        //[dictHeaders setValue:@"" forKey:@"sortFld"];
                        //[dictHeaders setValue:@"0" forKey:@"sortOrd"];
                        records+=20;
                        
                        if ([[ControlSettings sharedSettings] isNetConnected]) {
                            [self loadDataDelayed:@"1" toRec:@"20" reportType:@"" sortFld:@"" sortOrd:@"0"];
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
                    }];
                }
            }else {
                //no more reslut
            }
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception =%@",exception.description);
    }
}

#pragma UIScrollView Method:
//- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
//    
//    BOOL loading = '\0';
//    if (!loading) {
//        float endScrolling = scrollView.contentOffset.y + scrollView.frame.size.height;
//        
//        NSLog(@"maxcount=%d",records+50);
//        NSLog(@"maxcount=%ld",(long)maxCount);
//
//        if (maxCount>records) {
//            if (endScrolling >= scrollView.contentSize.height && !canCall) {
//                
//                [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
//                    [dictHeaders setValue:[NSString stringWithFormat:@"%d",records+1] forKey:@"FromRec"];
//                    [dictHeaders setValue:[NSString stringWithFormat:@"%d",records+50] forKey:@"ToRec"];
//                    //[dictHeaders setValue:@"" forKey:@"sortFld"];
//                    //[dictHeaders setValue:@"0" forKey:@"sortOrd"];
//                    records+=50;
//                    
//                    if ([[ControlSettings sharedSettings] isNetConnected]) {
//                        [self loadDataDelayed:@"1" toRec:@"50" reportType:@"" sortFld:@"" sortOrd:@"0"];
//                    }
//                    else {
//                        UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
//                                                                                                   message:strNoInternet
//                                                                                            preferredStyle:UIAlertControllerStyleAlert];
//                        UIAlertAction* ok = [UIAlertAction
//                                             actionWithTitle:strOk
//                                             style:UIAlertActionStyleDefault
//                                             handler:^(UIAlertAction * action){
//                                                 [myAlertController dismissViewControllerAnimated:YES completion:nil];
//                                             }];
//                        
//                        [myAlertController addAction:ok];
//                        [self presentViewController:myAlertController animated:YES completion:nil];
//                    }
//                }];
//            }
//        }else {
//            //no more reslut
//        }
//    }
//}

-(NSString*)displayDate:(NSString*)strSelectedDate{
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd/yyyy"];
    if([_strDateFormat isEqualToString:@"1"]){
        NSString *strBaseDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZD"];

        [formatter setDateFormat:@"MM/dd/yyyy"];
        NSDate *dtselectedDate = [formatter dateFromString:strSelectedDate];
        [formatter setDateFormat:@"yyyyMMdd"];
        NSDate *BaseDate = [formatter dateFromString:strBaseDate];
        int days = [dtselectedDate timeIntervalSinceDate:BaseDate]/24/60/60;
        
        NSString *strDate = [NSString stringWithFormat:@"%05d",days];
        NSString *calFormat,*strFromString;
        
        if (strDate.length>=2) {
            calFormat = [strDate substringToIndex:2];
        }else {
            calFormat = strDate;
        }
        
        if (strDate.length>=3) {
            strFromString = [strDate substringFromIndex:2];
        }
        
        calFormat = [[calFormat stringByAppendingString:@"-"] stringByAppendingString:strFromString?strFromString:@""];
        [formatter setDateFormat:@"EEE,dd-MMM-yyyy"];
        
        NSString *strSelectedDate100 = [[calFormat stringByAppendingString:@" "] stringByAppendingString:[formatter stringFromDate:dtselectedDate]];
        return strSelectedDate100;
    }else if([_strDateFormat isEqualToString:@"6"]){
        [formatter setDateFormat:@"MM/dd/yyyy"];
        [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
        NSDate *dtselectedDate = [formatter dateFromString:strSelectedDate];
        NSDate *Firstdate= [self getFirstDateOfCurrentYear:dtselectedDate];
        
        NSInteger days=[self daysBetweenDate:Firstdate andDate:dtselectedDate];
        NSLog(@"days:%ld",days);
        
        NSString *strDate = [NSString stringWithFormat:@"%03li",days];
        [formatter setDateFormat:@"yy"];
        
        NSString *strSelectedDateyearformat = [[[formatter stringFromDate:dtselectedDate] stringByAppendingString:@"-"] stringByAppendingString:strDate];
        
        [formatter setDateFormat:@"EEE,dd-MMM-yyyy"];
        NSString *strSelectedDateDayOfyear = [[strSelectedDateyearformat stringByAppendingString:@" "] stringByAppendingString:[formatter stringFromDate:dtselectedDate]];
        return strSelectedDateDayOfyear;
    }else{
        return strSelectedDate;
    }
}
-(NSDate *)getFirstDateOfCurrentYear:(NSDate*)selecteddate
{
    //Get current year
    //NSDate *currentYear=[[NSDate alloc]init];
    // currentYear=selecteddate
    
    NSDateFormatter *formatter1 = [[NSDateFormatter alloc] init];
    [formatter1 setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
    
    [formatter1 setDateFormat:@"yyyy"];
    NSString *currentYearString = [formatter1 stringFromDate:selecteddate];
    [formatter1 setTimeZone:[NSTimeZone defaultTimeZone]];
    //Get first date of current year
    NSString *firstDateString=[NSString stringWithFormat:@"10 01-01-%@",currentYearString];
    NSDateFormatter *formatter2 = [[NSDateFormatter alloc] init];
    [formatter2 setDateFormat:@"hh dd-MM-yyyy"];
    
    NSDate *firstDate = [[NSDate alloc]init];
    firstDate = [formatter2 dateFromString:firstDateString];
    
    NSLog(@"firstDate=%@",firstDate);
    
    return firstDate;
}
-(NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime
{
    @try{
        NSDate *fromDate;
        NSDate *toDate;
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        
        [calendar rangeOfUnit:NSCalendarUnitDay startDate:&fromDate
                     interval:NULL forDate:fromDateTime];
        [calendar rangeOfUnit:NSCalendarUnitDay startDate:&toDate
                     interval:NULL forDate:toDateTime];
        
        NSDateComponents *difference = [calendar components:NSCalendarUnitDay
                                                   fromDate:fromDate toDate:toDate options:0];
        
        return [difference day]+1;
    } @catch (NSException *exception) {
        NSLog(@"Exception in fillDefaultValuesForMandatoryFields=%@",exception.description);
    }
}

-(void)loadDataDelayed:(NSString*)strFromRec toRec:(NSString*)toRec reportType:(NSString*)reportType sortFld:(NSString*)sortFld sortOrd:(NSString*)sortOrd {
    @try {

        NSLog(@"records=%d",records);
        _customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
        [_customIOS7AlertView showLoaderWithMessage:strPlzWait];//strPlzWait
        canCall = YES;
       
        //
        NSString *strUrl = @"";
        for (NSString *strKey in [dictHeaders allKeys]) {
            strUrl = [[[[strUrl stringByAppendingString:strKey] stringByAppendingString:@"="] stringByAppendingString:[dictHeaders valueForKey:strKey]] stringByAppendingString:@"&"];
        }
        
        if (strUrl.length>0) {
            strUrl = [strUrl substringToIndex:[strUrl length]-1];
        }
        
        // NSLog(@"strUrl=%@",strUrl);
        
        [ServerManager sendRequest:strUrl idOfServiceUrl:idOFUrl headers:dictHeaders methodType:@"GET" onSucess:^(NSString *responseData) {
            canCall = NO;
            
            [_customIOS7AlertView close];
            
            id dictResponse = [NSJSONSerialization JSONObjectWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            
            @try {
                if ([dictResponse isKindOfClass:[NSDictionary class]]) {
                     NSString *strRec = [[dictResponse objectForKey:@"_RecCount"] objectForKey:@"totRecs"];
                    
                     if (![[dictResponse valueForKey:@"ErrorMsg"] isKindOfClass:[NSNull class]]) {
                        if ([[dictResponse valueForKey:@"ErrorMsg"] localizedCaseInsensitiveContainsString:@"Not connected"])
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
                     }else {
                         maxCount = [strRec integerValue];
                         
                         if ([strEvnt isEqualToString:@"5"]) {
                             [arrReports addObjectsFromArray:[dictResponse objectForKey:@"_Pig"]];
                             self.lblHeader.text = [[[strRec stringByAppendingString:@" pig(s) ("] stringByAppendingString:strActiveAnimalreportType] stringByAppendingString:@")"];//
                         }else if ([strEvnt isEqualToString:@"7"]) {
                             [arrReports addObjectsFromArray:[dictResponse objectForKey:@"_OpenSow"]];
                             self.lblHeader.text = [strRec stringByAppendingString:@" open gilt(s)/sow(s) in herd"];
                         }else if ([strEvnt isEqualToString:@"8"]) {
                             [arrReports addObjectsFromArray:[dictResponse objectForKey:@"_GiltPool"]];
                             NSDateFormatter *dateFormatterr = [[NSDateFormatter alloc]init] ;
                             [dateFormatterr setDateFormat:@"MM/dd/yyyy"];
                             NSString *strToday = [dateFormatterr stringFromDate:[NSDate date]];
                             strToday = [self displayDate:strToday];
                             self.lblHeader.text = [[strRec stringByAppendingString:@" gilt(s) in herd on "] stringByAppendingString:strToday];
                         }else if ([strEvnt isEqualToString:@"10"]) {
                             [arrReports addObjectsFromArray:[dictResponse objectForKey:@"_WarningPig"]];
                             self.lblHeader.text = [[[strRec stringByAppendingString:@" weaned sow(s) not served by "] stringByAppendingString:[dictHeaders valueForKey:@"DaysSinceWean"]] stringByAppendingString:@" days"];//21
                         }else if ([strEvnt isEqualToString:@"11"]) {
                             [arrReports addObjectsFromArray:[dictResponse objectForKey:@"_WarningPig"]];
                             self.lblHeader.text = [[[strRec stringByAppendingString:@" lactating sow(s) not weaned by "] stringByAppendingString:[dictHeaders valueForKey:@"DaysSinceFarrow"]] stringByAppendingString:@" days"];//21
                         }else if ([strEvnt isEqualToString:@"9"]) {
                             [arrReports addObjectsFromArray:[dictResponse objectForKey:@"_SowDueToFarrow"]];
                             
                             //
                             NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                             [formatter setDateFormat:@"YYYYMMdd"];
                             NSDate *dt2 = [formatter dateFromString:[dictHeaders valueForKey:@"DueToStartDate"]];
                             NSDate *dt3 = [formatter dateFromString:[dictHeaders valueForKey:@"DueToEndDate"]];
                             
                             [formatter setDateFormat:@"MM/dd/yyyy"];
                             NSString *strStart = [formatter stringFromDate:dt2];
                             NSString *strEnd = [formatter stringFromDate:dt3];
                             strStart = [self displayDate:strStart];
                             strEnd = [self displayDate:strEnd];
                             self.lblHeader.text = [[[[strRec stringByAppendingString:@" sow(s) due between "] stringByAppendingString:strStart] stringByAppendingString:@" and "] stringByAppendingString:strEnd];
                         }else if ([strEvnt isEqualToString:@"6"]) {
                             [arrReports addObjectsFromArray:[dictResponse objectForKey:@"_SowDueForAttention"]];
                             //
                             NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                             [formatter setDateFormat:@"YYYYMMdd"];
                             NSDate *dt2 = [formatter dateFromString:[dictHeaders valueForKey:@"StartDate"]];
                             NSDate *dt3 = [formatter dateFromString:[dictHeaders valueForKey:@"EndDate"]];
                             
                             [formatter setDateFormat:@"MM/dd/yyyy"];
                             NSString *strStart = [formatter stringFromDate:dt2];
                             NSString *strEnd = [formatter stringFromDate:dt3];
                             
                            strStart = [self displayDate:strStart];
                             strEnd = [self displayDate:strEnd];

                             self.lblHeader.text = [[[[strRec stringByAppendingString:@" sow(s) due between "] stringByAppendingString:strStart] stringByAppendingString:@" and "] stringByAppendingString:strEnd];
                         }
                         
                         if (arrReports.count>0) {
                             [self.tblFirst reloadData];
                         }else {
                             UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                        message:strNodataFound
                                                                                                 preferredStyle:UIAlertControllerStyleAlert];
                             UIAlertAction* ok = [UIAlertAction
                                                  actionWithTitle:strOk
                                                  style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction * action){
                                                      [self.navigationController popViewControllerAnimated:YES];
                                                      //[myAlertController dismissViewControllerAnimated:YES completion:nil];
                                                  }];
                             
                             [myAlertController addAction:ok];
                             [self presentViewController:myAlertController animated:YES completion:nil];
                         }
                     }
                 }
                
                if ([[dictHeaders valueForKey:@"ToRec"] isEqualToString:@"20"]) {
                    NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound inSection:0];
                    [_tblFirst scrollToRowAtIndexPath:top atScrollPosition:UITableViewScrollPositionTop animated:YES];
                }
            }
            @catch (NSException *exception) {
                
                NSLog(@"Exception =%@",exception.description);
            }
            
            NSLog(@"response=%@",dictResponse);
        }onFailure:^(NSMutableDictionary *responseData, NSError *error) {
            [_customIOS7AlertView close];
            
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
            [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateformate stringFromDate:[NSDate date]];
            
            NSString *strErr = [NSString stringWithFormat:@"User Name = %@,Farm Name = %@,error = %@,DateTime=%@,Event =%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],[[NSUserDefaults standardUserDefaults] objectForKey:@"f_nm"],error.description,strDate,strTitle];
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
                }else{
                    
                    NSString *path = [[NSBundle mainBundle] pathForResource:@"filename" ofType:@"plist"];
                    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:path];
                    
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:[responseData valueForKey:[dict valueForKey:@"code"]]
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOk
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             [self.navigationController popViewControllerAnimated:YES];
                                         }];
                    
                    [myAlertController addAction: ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
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

        }];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in loadDataDelayed=%@",exception.description);
    }
}

#pragma mark - picker methods
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    @try {
        if (pickerView==self.pickerSortType) {
            return [_arrSortType count];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in numberOfRowsInComponent- %@",[exception description]);
    }
}

//----------------------------------------------------------------------------------------------------------------------------------

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    @try{
        [[self.pickerSortType.subviews objectAtIndex:1] setBackgroundColor:[UIColor darkGrayColor]];
        [[self.pickerSortType.subviews objectAtIndex:2] setBackgroundColor:[UIColor darkGrayColor]];
        if (pickerView==self.pickerSortType) {
            return [_arrSortType objectAtIndex:row];
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception in titleForRow- %@",[exception description]);
    }
}

//----------------------------------------------------------------------------------------------------------------------------------

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    @try {
        [[self.pickerSortType.subviews objectAtIndex:1] setBackgroundColor:[UIColor darkGrayColor]];
        [[self.pickerSortType.subviews objectAtIndex:2] setBackgroundColor:[UIColor darkGrayColor]];
        UILabel *lblSortText = (id)view;
        
        if (!lblSortText)
        {
            lblSortText= [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, [pickerView rowSizeForComponent:component].width-15, [pickerView rowSizeForComponent:component].height)];
        }
        
        lblSortText.font = [UIFont systemFontOfSize:13];
        lblSortText.textColor = [UIColor darkGrayColor];
        lblSortText.textAlignment = NSTextAlignmentCenter;
        lblSortText.tintColor = [UIColor clearColor];

        if (pickerView==self.pickerSortType) {
            lblSortText.text = [_arrSortType objectAtIndex:row] ;
            return lblSortText;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in viewForRow- %@",[exception description]);
    }
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
