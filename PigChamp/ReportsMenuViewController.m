//
//  ReportsMenuViewController.m
//  PigChamp
//
//  Created by Venturelabour on 23/10/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import "ReportsMenuViewController.h"
#import "CoreDataHandler.h"
#import "ReportsInput.h"
#import "SowDetailsViewController.h"
#import "HerdSummaryViewController.h"

BOOL isOpenReport = NO;
BOOL isopenNavigationDrawerAfterBack = NO;

@interface ReportsMenuViewController ()
@end

@implementation ReportsMenuViewController

- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        self.navigationItem.hidesBackButton = YES;
        
        SlideNavigationController *sld = [SlideNavigationController sharedInstance];
        sld.delegate = self;
        self.navigationController.navigationBar.translucent = NO;
        
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        [tracker set:kGAIScreenName value:@"Reports"];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
        
        strOK = @"OK";
        strUnauthorised = @"Your session has been expired. Please login again.";
        strServerErr  = @"Server Error.";
        
        arrCode = [[NSMutableArray alloc]initWithObjects:@"1",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",nil];
        arrReportsMenu = [[NSMutableArray alloc]initWithObjects:@"Herd Summary",@"Animal Status",@"Sow Details",@"Active Animal List",@"Sows Due to Attention",@"Open Sow List",@"Gilt Pool",@"Sows Due to Farrow",@"Warning List(Not Served)",@"Warning List(Not Weaned)",@"Your session has been expired. Please login again.",@"Server Error.",@"OK", nil];
        
         self.title = @"Reports";
        
        NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:arrReportsMenu];
        NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
        
        if (resultArray1.count!=0) {
            for (int i=0; i<resultArray1.count; i++){
                [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
            }
        }
        
        [arrReportsMenu removeAllObjects];
        
        for (int i=0; i<13; i++){
            if (i==0) {
                if ([dictMenu objectForKey:[@"Herd Summary" uppercaseString]] && ![[dictMenu objectForKey:[@"Herd Summary" uppercaseString]] isKindOfClass:[NSNull class]]) {
                    [self addObject:[dictMenu objectForKey:[@"Herd Summary" uppercaseString]]?[dictMenu objectForKey:[@"Herd Summary" uppercaseString]]:@"" englishVersion:[@"Herd Summary" uppercaseString]];
                }
                else{
                    
                    [arrReportsMenu addObject:@"Herd Summary"];
                }
            }
//            else  if (i==1) {
//                if ([dictMenu objectForKey:[@"Production Summary" uppercaseString]] && ![[dictMenu objectForKey:[@"Production Summary" uppercaseString]] isKindOfClass:[NSNull class]]) {
//                    [self addObject:[dictMenu objectForKey:[@"Production Summary" uppercaseString]]?[dictMenu objectForKey:[@"Production Summary" uppercaseString]]:@"" englishVersion:@"Production Summary"];
//                }
//                else {
//                    [arrReportsMenu addObject:@"Production Summary"];
//                }
//            }
            else  if (i==2){
                if ([dictMenu objectForKey:[@"Animal Status" uppercaseString]] && ![[dictMenu objectForKey:[@"Animal Status" uppercaseString]] isKindOfClass:[NSNull class]]) {
                    [self addObject:[dictMenu objectForKey:[@"Animal Status" uppercaseString]]?[dictMenu objectForKey:[@"Animal Status" uppercaseString]]:@"" englishVersion:@"Animal Status"];
                }
                else {
                    [arrReportsMenu addObject:@"Animal Status"];
                }
            }else  if (i==3){
                if ([dictMenu objectForKey:[@"Sow Details" uppercaseString]] && ![[dictMenu objectForKey:[@"Sow Details" uppercaseString]] isKindOfClass:[NSNull class]]) {
                    [self addObject:[dictMenu objectForKey:[@"Sow Details" uppercaseString]]?[dictMenu objectForKey:[@"Sow Details" uppercaseString]]:@"" englishVersion:@"Sow Details"];
                }
                else{
                    [arrReportsMenu addObject:@"Sow Details"];
                }
            }else  if (i==4){
                if ([dictMenu objectForKey:[@"Active Animals List" uppercaseString]] && ![[dictMenu objectForKey:[@"Active Animals List" uppercaseString]] isKindOfClass:[NSNull class]]) {
                    [self addObject:[dictMenu objectForKey:[@"Active Animals List" uppercaseString]]?[dictMenu objectForKey:[@"Active Animals List" uppercaseString]]:@"" englishVersion:@"Active Animals List"];
                }
                else {
                    [arrReportsMenu addObject:@"Active Animals List"];
                }
            }else  if (i==5) {
                if ([dictMenu objectForKey:[@"Sows Due for Attention" uppercaseString]] && ![[dictMenu objectForKey:[@"Sows Due for Attention" uppercaseString]] isKindOfClass:[NSNull class]]) {
                    [self addObject:[dictMenu objectForKey:[@"Sows Due for Attention" uppercaseString]]?[dictMenu objectForKey:[@"Sows Due for Attention" uppercaseString]]:@"" englishVersion:@"Sows Due for Attention"];
                }
                else{
                    [arrReportsMenu addObject:@"Sows Due for Attention"];
                }
            }else  if (i==6) {
                if ([dictMenu objectForKey:[@"Open Sow List" uppercaseString]] && ![[dictMenu objectForKey:[@"Open Sow List" uppercaseString]] isKindOfClass:[NSNull class]]) {
                    [self addObject:[dictMenu objectForKey:[@"Open Sow List" uppercaseString]]?[dictMenu objectForKey:[@"Open Sow List" uppercaseString]]:@"" englishVersion:@"Open Sow List"];
                }
                else{
                    [arrReportsMenu addObject:@"Open Sow List"];
                }
            }else  if (i==7) {
                if ([dictMenu objectForKey:[@"Gilt Pool" uppercaseString]] && ![[dictMenu objectForKey:[@"Gilt Pool" uppercaseString]] isKindOfClass:[NSNull class]]) {
                    [self addObject:[dictMenu objectForKey:[@"Gilt Pool" uppercaseString]]?[dictMenu objectForKey:[@"Gilt Pool" uppercaseString]]:@"" englishVersion:@"Gilt Pool"];
                }
                else{
                    [arrReportsMenu addObject:@"Gilt Pool"];
                }
            }else  if (i==8) {
                if ([dictMenu objectForKey:[@"Sows Due to Farrow" uppercaseString]] && ![[dictMenu objectForKey:[@"Sows Due to Farrow" uppercaseString]] isKindOfClass:[NSNull class]]) {
                    [self addObject:[dictMenu objectForKey:[@"Sows Due to Farrow" uppercaseString]]?[dictMenu objectForKey:[@"Sows Due to Farrow" uppercaseString]]:@"" englishVersion:@"Sows Due to Farrow"];
                }
                else {
                    [arrReportsMenu addObject:@"Sows Due to Farrow"];
                }
            }else  if (i==9) {
                if ([dictMenu objectForKey:[@"Warning List-Not Served" uppercaseString]] && ![[dictMenu objectForKey:[@"Warning List-Not Served" uppercaseString]] isKindOfClass:[NSNull class]]) {
                    [self addObject:[dictMenu objectForKey:[@"Warning List-Not Served" uppercaseString]]?[dictMenu objectForKey:[@"Warning List-Not Served" uppercaseString]]:@"" englishVersion:[@"Warning List-Not Served" uppercaseString]];
                }
                else {
                    [arrReportsMenu addObject:@"Warning List-Not Served"];
                }
            }else  if (i==10) {
                if ([dictMenu objectForKey:[@"Warning List-Not Weaned" uppercaseString]] && ![[dictMenu objectForKey:[@"Warning List-Not Weaned" uppercaseString]] isKindOfClass:[NSNull class]]) {
                    [self addObject:[dictMenu objectForKey:[@"Warning List-Not Weaned" uppercaseString]]?[dictMenu objectForKey:[@"Warning List-Not Weaned" uppercaseString]]:@"" englishVersion:@"Warning List-Not Weaned"];
                }
                else {
                    [arrReportsMenu addObject:@"Warning List-Not Weaned"];
                }
            } else  if (i==11) {
                if ([dictMenu objectForKey:[@"Reports" uppercaseString]] && ![[dictMenu objectForKey:[@"Reports" uppercaseString]] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:[@"Reports" uppercaseString]] length]>0) {
                        self.title = [dictMenu objectForKey:[@"Reports" uppercaseString]]?[dictMenu objectForKey:[@"Reports" uppercaseString]]:@"";
                    }
                }
            }else  if (i==12){
                if ([dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] && ![[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] length]>0) {
                        strUnauthorised = [dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]]?[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]]:@"";
                    }
                }
            }else  if (i==13){
                if ([dictMenu objectForKey:[@"Server Error." uppercaseString]] && ![[dictMenu objectForKey:[@"Server Error." uppercaseString]] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:[@"Server Error." uppercaseString]] length]>0) {
                        strServerErr = [dictMenu objectForKey:[@"Server Error." uppercaseString]]?[dictMenu objectForKey:[@"Server Error." uppercaseString]]:@"";
                    }
                }
            }else if (i==14) {
                if ([dictMenu objectForKey:[@"OK" uppercaseString]] && ![[dictMenu objectForKey:[@"OK" uppercaseString]] isKindOfClass:[NSNull class]]){
                    if ([[dictMenu objectForKey:[@"OK" uppercaseString]] length]>0){
                        strOK = [dictMenu objectForKey:[@"OK" uppercaseString]]?[dictMenu objectForKey:[@"OK" uppercaseString]]:@"";
                    }
                }
            }
        }
        
        tlc = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [button1 setImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(updateMenuBarPositions) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
        self.navigationItem.rightBarButtonItem=rightBarButtonItem;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in viewDidLoad in DataEntry =%@",exception.description);
    }
}

- (void)viewWillAppear:(BOOL)animated {
    @try {
        [super viewWillAppear:animated];
        isOpenReport = NO;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in viewWillAppear=%@",exception.description);
    }
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

-(void)dismissOverlayView:(NSNotification*)not {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    isOpenReport = NO;
    self.vwOverlay.hidden = YES;
    isopenNavigationDrawerAfterBack = YES;
    [tlc.view removeFromSuperview];
}

-(void)updateMenuBarPositions {
    @try {
        if (isopenNavigationDrawerAfterBack) {
            isopenNavigationDrawerAfterBack = NO;
            NSLog(@"back");
        }else {
            isopenNavigationDrawerAfterBack = NO;

            NSLog(@"normal");
            [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissOverlayView:) name:@"CloseOverlay" object:nil];
            UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
            
            if (!isOpenReport) {
                self.vwOverlay.hidden = NO;
                [tlc.view setFrame:CGRectMake(-320, 0, self.view.frame.size.width-64, currentWindow.frame.size.height)];
                [currentWindow addSubview:tlc.view];
                //NSLog(@"add");

                [UIView animateWithDuration:0.3 animations:^{
                    [tlc.view setFrame:CGRectMake(0, 0, self.view.frame.size.width-64, currentWindow.frame.size.height)];
                }];
            }else {
                NSLog(@"remove");
                self.vwOverlay.hidden = YES;
                [tlc.view removeFromSuperview];
            }
            
            isOpenReport = !isOpenReport;
        }
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

        [[NSNotificationCenter defaultCenter]removeObserver:self];
        self.vwOverlay.hidden = YES;
        isOpenReport = !isOpenReport;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in removeView=%@",exception.description);
    }
}

-(void)addObject:(NSString*)object englishVersion:(NSString*)englishVersion {
    @try {
        if (object.length!=0) {
            [arrReportsMenu addObject:object];
        }
        else{
            [arrReportsMenu addObject:englishVersion];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in addObject=%@",exception.description);
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    @try {
        return [arrReportsMenu count];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in numberOfRowsInSection=%@",exception.description);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        UITableViewCell * cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"Report"];
        
        if (cell ==nil) {
            cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Report"];
        }
        
        UILabel *lblDetails = (UILabel*)[cell viewWithTag:2];
        lblDetails.text =[arrReportsMenu objectAtIndex:indexPath.row];
        
        return cell;
    }
    @catch (NSException *exception){
        
        NSLog(@"Exception in cellForRowAtIndexPath=%@",exception.description);
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        if (indexPath.row==0) {
            HerdSummaryViewController *herdSummaryViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"HerdReport"];
            [self.navigationController pushViewController:herdSummaryViewController animated:YES];
        }
        else if (indexPath.row==2) {
            SowDetailsViewController *sowDetailsViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"SowReport"];
            [self.navigationController pushViewController:sowDetailsViewController animated:YES];
        }
        else {
        ReportsInput *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"Reports"];
        newView.strEvent = [arrCode objectAtIndex:indexPath.row];
        newView.strSubMenu = [arrReportsMenu objectAtIndex:indexPath.row];
        [self.navigationController pushViewController:newView animated:YES];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in didSelectRowAtIndexPath =%@",exception.description);
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
            cell.backgroundColor = [UIColor clearColor];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in forRowAtIndexPath=%@",exception.description);
    }
}

//

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
