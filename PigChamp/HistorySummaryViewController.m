//
//  HistorySummaryViewController.m
//  PigChamp
//
//  Created by Venturelabour on 19/11/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//

#import "HistorySummaryViewController.h"
#import "ServerManager.h"
#import "ControlSettings.h"
#import "CustomIOS7AlertView.h"
#import "DynamicFormViewController.h"
#import "CoreDataHandler.h"
#import "CustomCollectionViewLayout.h"

BOOL isSow = NO;

int recordsSummary = 0;
int toVal=0;
NSInteger maxCountSummary = 20;
BOOL canCallSummary= NO;
BOOL isOpenHistory= NO;
int sectionFirst = -1;
NSString *strEditTitle;

@interface HistorySummaryViewController ()
@property (weak, nonatomic) IBOutlet UIButton *btnHistry;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *btnHistoryWidthcon;
@property (weak, nonatomic) IBOutlet UIView *BtnHisrtyUndeline;

@end

@implementation HistorySummaryViewController
@synthesize strIdentityId;

#pragma maek - view life cycle
- (void)viewDidLoad {
    @try {
        [super viewDidLoad];
        arrhistory = [[NSMutableArray alloc]init];
        self.navigationController.navigationBar.translucent = NO;
        tlc = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
        
        UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
        [button1 setImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
        [button1 addTarget:self action:@selector(updateMenuBarPositions) forControlEvents:UIControlEventTouchUpInside];
        UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
        self.navigationItem.rightBarButtonItem=rightBarButtonItem;
        
        SlideNavigationController *sld = [SlideNavigationController sharedInstance];
        sld.delegate = self;

        _btnEdit.layer.shadowColor = [[UIColor grayColor] CGColor];
        _btnEdit.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
        _btnEdit.layer.shadowOpacity = 1.0f;
        _btnEdit.layer.shadowRadius = 3.0f;
        
        _btnDelete.layer.shadowColor = [[UIColor grayColor] CGColor];
        _btnDelete.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
        _btnDelete.layer.shadowOpacity = 1.0f;
        _btnDelete.layer.shadowRadius = 3.0f;
        
         selecteditem = @"";
//        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
//        [tracker set:kGAIScreenName value:@"History and summary"];
//        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(-20, 0, 22, 22);
        [button setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(btnBack_tapped) forControlEvents:UIControlEventTouchUpInside];
        
        UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
        [barButton setCustomView:button];
        self.navigationItem.leftBarButtonItem=barButton;
        
        //
        strCancel = @"CANCEL";
        strInternet = @"You must be online for the app to function.";
        strOk = @"OK";
        strWait = @"Please wait...";
        strSureDelete = @"Are you sure you want to delete this?";
        strSelectDelete = @"Select an event you want to delete.";
        strSelectEdit = @"Select an event you want to edit.";
        strUnauthorised =@"Your session has been expired. Please login again.";
        strServerErr= @"Server Error.";
        strLoading = @"Loading...";
        strYes = @"Yes";
        strNo = @"No";
        strSignOff = @"Signing off.";

        NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:@"Cancel",@"You must be online for the app to function.",@"Ok",@"EDIT",@"DELETE",@"HISTORY",@"SUMMARY",@"Please wait...",@"Your session has been expired. Please login again.",@"Server Error.",@"Select an event you want to delete."@"Select an event you want to edit.",@"Yes",@"No",@"Signing off.",nil]];
        
        NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
        if (resultArray1!=0) {
            for (int i=0; i<resultArray1.count; i++){
                [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
            }
            
            for (int i=0; i<16; i++) {
                if (i==0) {
                    if ([dictMenu objectForKey:[@"Cancel" uppercaseString]] && ![[dictMenu objectForKey:[@"Cancel" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Cancel" uppercaseString]] length]>0) {
                            strCancel = [dictMenu objectForKey:[@"Cancel" uppercaseString]]?[dictMenu objectForKey:[@"Cancel" uppercaseString]]:@"";
                        }
//                        else{
//                            strCancel = @"Cancel";
//                        }
                    }
//                    else{
//                        strCancel = @"Cancel";
//                    }
                }else  if (i==1){
                    if ([dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]] && ![[dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]] length]>0) {
                            strInternet = [dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]]?[dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]]:@"";
                        }
//                        else{
//                            strInternet = @"You must be online for the app to function";
//                        }
                    }
//                    else{
//                        strInternet = @"You must be online for the app to function";
//                    }
                }else  if (i==2){
                    if ([dictMenu objectForKey:[@"Ok" uppercaseString]] && ![[dictMenu objectForKey:[@"Ok" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Ok" uppercaseString]] length]>0) {
                            strOk = [dictMenu objectForKey:[@"Ok" uppercaseString]]?[dictMenu objectForKey:[@"Ok" uppercaseString]]:@"";
                        }
//                        else{
//                            strOk = @"Ok";
//                        }
                    }
//                    else{
//                        strOk = @"Ok";
//                    }
                }else  if (i==3){
                    if ([dictMenu objectForKey:[@"EDIT" uppercaseString]] && ![[dictMenu objectForKey:[@"EDIT" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"EDIT" uppercaseString]] length]>0) {
                            strEditTitle = [dictMenu objectForKey:[@"EDIT" uppercaseString]]?[dictMenu objectForKey:[@"EDIT" uppercaseString]]:@"";
                        }else{
                            strEditTitle = @"EDIT";
                        }
                    }
                    else{
                        strEditTitle = @"EDIT";
                    }
                    
                    [self.btnEdit setTitle:strEditTitle forState:UIControlStateNormal];
                }else  if (i==4){
                    NSString *strDeleteTitle;
                    
                    if ([dictMenu objectForKey:[@"DELETE" uppercaseString]] && ![[dictMenu objectForKey:[@"DELETE" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"DELETE" uppercaseString]] length]>0) {
                            strDeleteTitle = [dictMenu objectForKey:[@"DELETE" uppercaseString]]?[dictMenu objectForKey:[@"DELETE" uppercaseString]]:@"";
                        }else{
                            strDeleteTitle = @"DELETE";
                        }
                    }
                    else{
                        strDeleteTitle = @"DELETE";
                    }
                    
                    [self.btnDelete setTitle:strDeleteTitle forState:UIControlStateNormal];
                }else  if (i==5){
                    NSString *strHistoryTitle;
                    
                    if ([dictMenu objectForKey:[@"HISTORY" uppercaseString]] && ![[dictMenu objectForKey:[@"HISTORY" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"HISTORY" uppercaseString]] length]>0) {
                            strHistoryTitle = [dictMenu objectForKey:[@"Ok" uppercaseString]]?[dictMenu objectForKey:[@"HISTORY" uppercaseString]]:@"";
                        }else{
                            strHistoryTitle = @"HISTORY";
                        }
                    }
                    else{
                        strHistoryTitle = @"HISTORY";
                    }
                    
                    [self.btnHistory setTitle:strHistoryTitle forState:UIControlStateNormal];
                }else  if (i==6){
                    NSString *strSummaryTitle;
                    if ([dictMenu objectForKey:[@"SUMMARY" uppercaseString]] && ![[dictMenu objectForKey:[@"SUMMARY" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"SUMMARY" uppercaseString]] length]>0) {
                            strSummaryTitle = [dictMenu objectForKey:[@"SUMMARY" uppercaseString]]?[dictMenu objectForKey:[@"SUMMARY" uppercaseString]]:@"";
                        }else{
                            strSummaryTitle = @"SUMMARY";
                        }
                    }
                    else{
                        strSummaryTitle = @"SUMMARY";
                    }
                    
                    [self.btnSummary setTitle:strSummaryTitle forState:UIControlStateNormal];
                }else  if (i==7){
                    //NSString *strSummaryTitle;
                    if ([dictMenu objectForKey:[@"Please wait..." uppercaseString]] && ![[dictMenu objectForKey:[@"Please wait..." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Please wait..." uppercaseString]] length]>0) {
                            strWait = [dictMenu objectForKey:[@"Please wait..." uppercaseString]]?[dictMenu objectForKey:[@"Please wait..." uppercaseString]]:@"";
                        }
//                        else{
//                            strWait = @"Please wait...";
//                        }
                    }
//                    else{
//                        strWait = @"Please wait...";
//                    }
                }else  if (i==8){
                    if ([dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] && ![[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] length]>0) {
                            strUnauthorised = [dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]]?[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]]:@"";
                        }
                    }
                }else  if (i==9){
                    if ([dictMenu objectForKey:[@"Server Error." uppercaseString]] && ![[dictMenu objectForKey:[@"Server Error." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Server Error." uppercaseString]] length]>0) {
                            strServerErr = [dictMenu objectForKey:[@"Server Error." uppercaseString]]?[dictMenu objectForKey:[@"Server Error." uppercaseString]]:@"";
                        }
                    }
                }else  if (i==10){
                    if ([dictMenu objectForKey:[@"Select an event you want to delete." uppercaseString]] && ![[dictMenu objectForKey:[@"Select an event you want to delete." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Select an event you want to delete." uppercaseString]] length]>0) {
                            strSelectDelete = [dictMenu objectForKey:[@"Select an event you want to delete." uppercaseString]]?[dictMenu objectForKey:[@"Select an event you want to delete." uppercaseString]]:@"";
                        }
                    }
                }else  if (i==11){
                    if ([dictMenu objectForKey:[@"Select an event you want to edit." uppercaseString]] && ![[dictMenu objectForKey:[@"Select an event you want to edit." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Select an event you want to edit." uppercaseString]] length]>0) {
                            strSelectEdit = [dictMenu objectForKey:[@"Select an event you want to edit." uppercaseString]]?[dictMenu objectForKey:[@"Select an event you want to edit." uppercaseString]]:@"";
                        }
                    }
                } else  if (i==12){
                    if ([dictMenu objectForKey:[@"Loading..." uppercaseString]] && ![[dictMenu objectForKey:[@"Loading..." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Loading..." uppercaseString]] length]>0) {
                            strLoading = [dictMenu objectForKey:[@"Loading..." uppercaseString]]?[dictMenu objectForKey:[@"Loading..." uppercaseString]]:@"";
                        }
                    }
                }else  if (i==13){
                    if ([dictMenu objectForKey:[@"Yes" uppercaseString]] && ![[dictMenu objectForKey:[@"Yes" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Yes" uppercaseString]] length]>0) {
                            strYes = [dictMenu objectForKey:[@"Yes" uppercaseString]]?[dictMenu objectForKey:[@"Yes" uppercaseString]]:@"";
                        }
                    }
                }else  if (i==14){
                    if ([dictMenu objectForKey:[@"No" uppercaseString]] && ![[dictMenu objectForKey:[@"No" uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"No" uppercaseString]] length]>0) {
                            strNo = [dictMenu objectForKey:[@"No" uppercaseString]]?[dictMenu objectForKey:[@"No" uppercaseString]]:@"";
                        }
                    }
                }else  if (i==15){
                    if ([dictMenu objectForKey:[@"Signing off." uppercaseString]] && ![[dictMenu objectForKey:[@"Signing off." uppercaseString]] isKindOfClass:[NSNull class]]) {
                        if ([[dictMenu objectForKey:[@"Signing off." uppercaseString]] length]>0) {
                            strSignOff = [dictMenu objectForKey:[@"Signing off." uppercaseString]]?[dictMenu objectForKey:[@"Signing off." uppercaseString]]:@"";
                        }
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in viewDidLoad=%@",exception.description);
    }
}

-(void)viewWillAppear:(BOOL)animated {
    @try {
         NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
         isOpenHistory= NO;
        
//        NSString *strIds = [pref valueForKey:@"deletedIndetity"];
//        strIds = [[strIds stringByAppendingString:_strTitle] stringByAppendingString:@","];
//        [pref setValue:strIds forKey:@"deletedIndetity"];
//        [pref synchronize];
        
        [super viewWillAppear:YES];
        self.title = _strTitle;
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"FromHistory"];
         NSString *strFromDataEntry = [pref valueForKey:@"FromDataEntry"];
        
        //To do call edit service if from edit
       // if ([strFromDataEntry isEqualToString:@"0"])
        {
          [arrhistory removeAllObjects];
            [self.clHistory reloadData];

           selecteditem  = @"-1";
           recordsSummary = 0;
           maxCountSummary = 20;
          
            self.vwHistory.hidden = NO;
            self.tblSummary.hidden= YES;
            self.vwUndelineHistory.hidden = NO;
            self.vwUnderlineSummary.hidden = YES;
            
            if ([[ControlSettings sharedSettings] isNetConnected]) {
                sectionFirst =-1;
                [self callHistorySerivce:strWait];
                [self btnHistory_tapped:nil];
            }
            else {
                UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                           message:strInternet
                                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction* ok = [UIAlertAction
                                                     actionWithTitle:strOk
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action){
                                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                                     }];
                                
                                [myAlertController addAction: ok];
                                [self presentViewController:myAlertController animated:YES completion:nil];
              }
        }
        
//        else {
//            NSDictionary *dict = [[NSDictionary alloc]initWithObjectsAndKeys:@"Date",@"Date", @"Detail",@"2.00",@"tttt",@"Event",@"34",@"EventCode",@"1122753",@"EventKey",@"farm",@"Location",@"test",@"Operator",@"8",@"Parity",@"PigIdKey",@"PigIdKey",nil];
//
//            if (arrhistory.count>4) {
//                [arrhistory replaceObjectAtIndex:[selecteditem integerValue] withObject:dict];
//                [self.clHistory reloadData];
//            }
//            
//            NSLog(@"selecteditem=%@",selecteditem);
//        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in viewWillAppear=%@",exception.description);
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
}

-(void)updateMenuBarPositions {
    @try {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeView:) name:@"CloseAlert" object:nil];
        UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
        
        if (!isOpenHistory) {
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
        
        isOpenHistory = !isOpenHistory;
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
        isOpenHistory = !isOpenHistory;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in removeView=%@",exception.description);
    }
}

//- (BOOL)slideNavigationControllerShouldDisplayRightMenu
//{
//    return YES;
//}


#pragma mark - table methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try {
        return [arrSummary count];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in numberOfRowsInSection=%@",exception.description);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @try {
        UITableViewCell * cell;
        cell = [tableView dequeueReusableCellWithIdentifier:@"Summary"];
        
        if (cell ==nil){
            cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Summary"];
        }
        
        UILabel *lblName = (UILabel*)[cell viewWithTag:1];
        if (![[[arrSummary objectAtIndex:indexPath.row] valueForKey:@"propName"] isKindOfClass:[NSNull class]]){
            lblName.text = [[arrSummary objectAtIndex:indexPath.row] valueForKey:@"propName"]?[[arrSummary objectAtIndex:indexPath.row] valueForKey:@"propName"]:@"";
        }
        
        UILabel *lblValue = (UILabel*)[cell viewWithTag:2];
        if (![[[arrSummary objectAtIndex:indexPath.row] valueForKey:@"propValue"] isKindOfClass:[NSNull class]]){
           NSString *strValue  =[[arrSummary objectAtIndex:indexPath.row] valueForKey:@"propValue"]?[[arrSummary objectAtIndex:indexPath.row] valueForKey:@"propValue"]:@"";
            
            if (![[[arrSummary objectAtIndex:indexPath.row] valueForKey:@"propValue"] isKindOfClass:[NSNull class]]) {
                if (strValue.length==0) {
                   lblValue.text = @"-";
                }else
                    lblValue.text =strValue;
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
    return 6;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    @try {
        //return arrhistory.count;

        if (arrhistory.count>0){
            return arrhistory.count+1;
        }else{
            return arrhistory.count;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in numberOfSectionsInCollectionView=%@",exception.description);
    }
}

-(void)loadMore{
    @try {
        if (maxCountSummary>recordsSummary && !canCallSummary) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                recordsSummary+=20;
                if ([[ControlSettings sharedSettings] isNetConnected]) {
                    [self callHistorySerivce:@""];
                }
                else {
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:strInternet
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
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in reachedAtEnd=%@",exception.description);
    }

}

// 3
- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    @try {
       
        //NSLog(@"arrhistory=%d",arrhistory.count);

        if (indexPath.section==0){
            cell *cellobj= [cv dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
            
            if (isSow) {
                if (indexPath.row==0){
                    cellobj.lblHeader.text = @"Date";
                }
                else if (indexPath.row==1) {
                    cellobj.lblHeader.text = @"Parity";
                }
                else if (indexPath.row==2){
                    cellobj.lblHeader.text = @"Event";
                }
                else if (indexPath.row==3){
                    cellobj.lblHeader.text = @"Detail";
                }
                else if (indexPath.row==4){
                    cellobj.lblHeader.text =@"Location";
                }
                else{
                    cellobj.lblHeader.text =@"Operator";
                }
            }else{
                if (indexPath.row==0){
                    cellobj.lblHeader.text = @"Date";
                }
                else if (indexPath.row==1) {
                    cellobj.lblHeader.text = @"Event";
                }
                else if (indexPath.row==2){
                    cellobj.lblHeader.text = @"Detail";
                }
                else if (indexPath.row==3){
                    cellobj.lblHeader.text = @"Location";
                }
                else if (indexPath.row==4){
                    cellobj.lblHeader.text =@"Operator";
                }else{
                    cellobj.lblHeader.text  = @"";
                }
            }
            
         return cellobj;
        }
        else{
            
            contentCollectionViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"content" forIndexPath:indexPath];
            
            NSDictionary *dict  = [arrhistory objectAtIndex:indexPath.section-1];
            
            if (isSow) {
                if (indexPath.row==0)
                {
                    if (![[dict valueForKey:@"Date"] isKindOfClass:[NSNull class]])
                    {
                        if ([[dict valueForKey:@"Date"] length]>0){
                            cell.lblcontent.text = [dict valueForKey:@"Date"]?[dict valueForKey:@"Date"]:@"-";
                        }else{
                            cell.lblcontent.text = @"-";
                        }
                    }else
                    {
                        cell.lblcontent.text = @"-";
                    }
                }
                else if (indexPath.row==1)
                {
                    if (![[dict valueForKey:@"Parity"] isKindOfClass:[NSNull class]]){
                        
                        if ([[dict valueForKey:@"Parity"] length]>0){
                            cell.lblcontent.text = [dict valueForKey:@"Parity"]?[dict valueForKey:@"Parity"]:@"-";
                        }else{
                            cell.lblcontent.text = @"-";
                        }
                    }else{
                        cell.lblcontent.text = @"-";
                    }
                    
                }
                else if (indexPath.row==2)
                {
                    if (![[dict valueForKey:@"Event"] isKindOfClass:[NSNull class]]){
                        
                        if ([[dict valueForKey:@"Event"] length]>0){
                            cell.lblcontent.text = [dict valueForKey:@"Event"]?[dict valueForKey:@"Event"]:@"-";
                        }else{
                            cell.lblcontent.text = @"-";
                        }
                    }else{
                        cell.lblcontent.text = @"-";
                    }
                    
                }
                else if (indexPath.row==3) {
                    if (![[dict valueForKey:@"Detail"] isKindOfClass:[NSNull class]]) {
                        if ([[dict valueForKey:@"Detail"] length]>0){
                            cell.lblcontent.text = [dict valueForKey:@"Detail"]?[dict valueForKey:@"Detail"]:@"-";
                        }else {
                            cell.lblcontent.text = @"-";
                        }
                    }else {
                        cell.lblcontent.text = @"-";
                    }
                }
                else if (indexPath.row==4)
                {
                    if (![[dict valueForKey:@"Location"] isKindOfClass:[NSNull class]]) {
                        if ([[dict valueForKey:@"Location"] length]>0) {
                            cell.lblcontent.text = [dict valueForKey:@"Location"]?[dict valueForKey:@"Location"]:@"-";
                        }else  {
                            cell.lblcontent.text = @"-";
                        }
                    }else {
                        cell.lblcontent.text = @"-";
                    }
                }else if (indexPath.row==5) {
                    if (![[dict valueForKey:@"Operator"] isKindOfClass:[NSNull class]]) {
                        if ([[dict valueForKey:@"Operator"] length]>0) {
                            cell.lblcontent.text = [dict valueForKey:@"Operator"]?[dict valueForKey:@"Operator"]:@"-";
                        } else {
                            cell.lblcontent.text = @"-";
                        }
                    } else {
                        cell.lblcontent.text = @"-";
                    }
                }
            }else {
                if (indexPath.row==0) {
                    if (![[dict valueForKey:@"Date"] isKindOfClass:[NSNull class]]) {
                        if ([[dict valueForKey:@"Date"] length]>0) {
                            cell.lblcontent.text = [dict valueForKey:@"Date"]?[dict valueForKey:@"Date"]:@"-";
                        }else {
                            cell.lblcontent.text = @"-";
                        }
                    }else {
                        cell.lblcontent.text = @"-";
                    }
                }
                else if (indexPath.row==1) {
                    if (![[dict valueForKey:@"Event"] isKindOfClass:[NSNull class]]) {
                        
                        if ([[dict valueForKey:@"Event"] length]>0) {
                            cell.lblcontent.text = [dict valueForKey:@"Event"]?[dict valueForKey:@"Event"]:@"-";
                        }else {
                            cell.lblcontent.text = @"-";
                        }
                    }else {
                        cell.lblcontent.text = @"-";
                    }
                }
                else if (indexPath.row==2) {
                    if (![[dict valueForKey:@"Detail"] isKindOfClass:[NSNull class]]) {
                        if ([[dict valueForKey:@"Detail"] length]>0){
                            cell.lblcontent.text = [dict valueForKey:@"Detail"]?[dict valueForKey:@"Detail"]:@"-";
                        }else {
                            cell.lblcontent.text = @"-";
                        }
                    }else {
                        cell.lblcontent.text = @"-";
                    }
                }
                else if (indexPath.row==3)
                {
                    if (![[dict valueForKey:@"Location"] isKindOfClass:[NSNull class]]) {
                        if ([[dict valueForKey:@"Location"] length]>0){
                            cell.lblcontent.text = [dict valueForKey:@"Location"]?[dict valueForKey:@"Location"]:@"-";
                        }else {
                            cell.lblcontent.text = @"-";
                        }
                    }else{
                        cell.lblcontent.text = @"-";
                    }
                }
                else if (indexPath.row==4) {
                    if (![[dict valueForKey:@"Operator"] isKindOfClass:[NSNull class]]) {
                        if ([[dict valueForKey:@"Operator"] length]>0) {
                            cell.lblcontent.text = [dict valueForKey:@"Operator"]?[dict valueForKey:@"Operator"]:@"-";
                        } else
                        {
                            cell.lblcontent.text = @"-";
                        }
                    } else {
                        cell.lblcontent.text = @"-";
                    }
                }else{
                    cell.lblcontent.text =@"";
                }
            }
            
            if ([selecteditem integerValue]== indexPath.section-1)
                cell.backgroundColor = [UIColor colorWithRed:233.0/255.0 green:213.0/255.0 blue:211.0/255.0 alpha:1];
            else
                cell.backgroundColor = [UIColor clearColor];
            
            //
            if(indexPath.section==arrhistory.count-1){
                // NSLog(@"indexpathsection=%ld",(long)indexPath.section);
               //  NSLog(@"arrhistory=%ld",arrhistory.count);

                //[self reachedAtEnd:indexPath.section];
            }
            //
            
            return cell;
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception  in cell for row=%@",exception.description);
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section!=0){
    NSDictionary *dict  = [arrhistory objectAtIndex:indexPath.section-1];

    if ([[dict valueForKey:@"canEdit"] isEqualToString:@"True"]){
        [self.btnEdit setBackgroundColor:[UIColor colorWithRed:145.0/255.0 green:47.0/255.0 blue:43.0/255.0 alpha:1]];
        self.btnEdit.enabled = YES;
    }
    else {
        [self.btnEdit setBackgroundColor:[UIColor colorWithRed:233.0/255.0 green:213.0/255.0 blue:211.0/255.0 alpha:1]];
        self.btnEdit.enabled = NO;
    }
    
    if ([[dict valueForKey:@"canDelete"] isEqualToString:@"True"]) {
        [self.btnDelete setBackgroundColor:[UIColor colorWithRed:145.0/255.0 green:47.0/255.0 blue:43.0/255.0 alpha:1]];
        self.btnDelete.enabled = YES;
    }
    else {
        [self.btnDelete setBackgroundColor:[UIColor colorWithRed:233.0/255.0 green:213.0/255.0 blue:211.0/255.0 alpha:1]];
        self.btnDelete.enabled = NO;
    }
        
    selecteditem = [NSString stringWithFormat:@"%ld",indexPath.section-1];
    [self.clHistory reloadData];
  }
}

- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath NS_AVAILABLE_IOS(8_0){
    @try {
        if(self.tblSummary.hidden) {
            NSLog(@"indexPath.section=%ld",(long)indexPath.section);
        if (indexPath.section==arrhistory.count-1 && sectionFirst !=indexPath.section) {
            [self Pagging];
            sectionFirst = (int)indexPath.section;
         }
      }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in forRowAtIndexPath=%@",exception.description);
    }
}

-(void)Pagging {
    @try {
        @try {
            if (self.tblSummary.hidden) {
                
                //if (scrollOffset + scrollViewHeight == scrollContentSizeHeight)
                {
                    // NSLog(@"height end");
                    if (maxCountSummary>recordsSummary && !canCallSummary) {
                        [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                            recordsSummary+=20;
                            if ([[ControlSettings sharedSettings] isNetConnected]) {
                                if (arrhistory.count<maxCountSummary) {
                                    [self callHistorySerivce:strWait];
                                }
                            }
                            else {
                                UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                           message:strInternet
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
                }
            }
        }
        @catch (NSException *exception) {
            NSLog(@"Exception =%@",exception.description);
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception =%@",exception.description);
    }
}

-(void)reachedAtEnd:(int)section {
    NSLog(@"section yo=%d",section);
    
    @try {
        if (maxCountSummary>recordsSummary && !canCallSummary) {
            
            [[NSOperationQueue mainQueue] addOperationWithBlock:^ {
                recordsSummary+=20;
                if ([[ControlSettings sharedSettings] isNetConnected]) {
                    [self callHistorySerivce:@""];
                }
                else {
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:strInternet
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
   }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in reachedAtEnd=%@",exception.description);
    }
}

#pragma mark -other mehods
- (IBAction)btnHistory_tapped:(id)sender {
    @try {
        self.vwHistory.hidden = NO;
        self.tblSummary.hidden= YES;
        self.vwUndelineHistory.hidden = NO;
        self.vwUnderlineSummary.hidden = YES;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in btnHistory_tapped=%@",exception.description);
    }
}

-(void)displayToastWithMessage:(NSString *)toastMessage
{
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
        toastView.layer.cornerRadius = 5;
        toastView.layer.masksToBounds = YES;
        //toastView.center = keyWindow.center;
        
        [keyWindow addSubview:toastView];
        
        [UIView animateWithDuration: 5.0f
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

-(void)callHistorySerivceAfterDelet:(NSString*)message {
    @try {
        canCallSummary = YES;
        _customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
        [_customIOS7AlertView showLoaderWithMessage:message];
        
        [ServerManager sendRequest:[NSString stringWithFormat:@"token=%@&Identity=%@&FromRec=%@&ToRec=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],self.strIdentityId,[NSString stringWithFormat:@"%d",1],[NSString stringWithFormat:@"%d",toVal]]  idOfServiceUrl:12 headers:nil methodType:@"GET" onSucess:^(NSString *responseData) {
            
            [_customIOS7AlertView close];
            
            id response = [NSJSONSerialization JSONObjectWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
            NSLog(@"response=%@",response);
            
            if ([[response valueForKey:@"_PigEvents"] isKindOfClass:[NSArray class]]) {
                NSString *strRec = [[response objectForKey:@"_RecCount"] objectForKey:@"totRecs"];
                
                if ([strRec localizedCaseInsensitiveContainsString:@"Not connected"]) {//to do too
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
                                                     
                                                     [_customIOS7AlertView close];
                                                 }];
                                             }
                                             else {
                                                 UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                                            message:strInternet
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
                
                NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
                
                if (maxCountSummary == 20) {
                    [pref setValue:strRec forKey:@"totRecs"];
                    [pref synchronize];
                }
                
                maxCountSummary = [strRec integerValue];
                [pref setValue:strRec forKey:@"totRecs"];
                [pref synchronize];

                [arrhistory addObjectsFromArray:[response valueForKey:@"_PigEvents"]];
                 canCallSummary = NO;
                
                if (arrhistory.count==0) {
                NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
                NSString *strIds = [pref valueForKey:@"deletedIndetity"];
                strIds = [[strIds stringByAppendingString:_strTitle] stringByAppendingString:@","];
                [pref setValue:strIds forKey:@"deletedIndetity"];
                [pref synchronize];
                [arrhistory removeAllObjects];
                [self.clHistory reloadData];
                }
                
                if (arrhistory.count>0) {
                    if ([[[arrhistory objectAtIndex:0] valueForKey:@"SexId"] caseInsensitiveCompare:@"s"] == NSOrderedSame)
                    {
                        self.btnSummary.hidden = NO;
                        self.btnHistry.hidden = YES;
                        self.BtnHisrtyUndeline.hidden = YES;
                        self.btnHistory.hidden = NO;
                        self.vwUndelineHistory.hidden = NO;
                        isSow = YES;
                    }else {
                        self.btnSummary.hidden = YES;
                        self.btnHistory.hidden = YES;
                        self.vwUndelineHistory.hidden = YES;
                        self.btnHistry.hidden = NO;
                        self.BtnHisrtyUndeline.hidden = NO;
                        isSow = NO;
                    }
                }
                
                [self.clHistory reloadData];
            }
            else {
                UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                           message:[response valueForKey:@"Msg"]
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:strOk
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     }];
                
                [myAlertController addAction: ok];
                [self presentViewController:myAlertController animated:YES completion:nil];
            }
            
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
            }
        } onFailure:^(NSMutableDictionary *responseData, NSError *error) {
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
            [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateformate stringFromDate:[NSDate date]];
            
            NSString *strErr = [NSString stringWithFormat:@"User Name = %@,Farm Name = %@,error = %@,DateTime=%@,On History=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],[[NSUserDefaults standardUserDefaults] objectForKey:@"f_nm"],error.description,strDate, self.title];
            [tracker set:kGAIScreenName value:strErr];
            [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
            [_customIOS7AlertView close];
            
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
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in callHistorySerivce =%@",exception.description);
    }
}

-(void)callHistorySerivce:(NSString*)message {
    @try {
         canCallSummary = YES;
        _customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
        [_customIOS7AlertView showLoaderWithMessage:message];
        
        [ServerManager sendRequest:[NSString stringWithFormat:@"token=%@&Identity=%@&FromRec=%@&ToRec=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],self.strIdentityId,[NSString stringWithFormat:@"%d",recordsSummary+1],[NSString stringWithFormat:@"%d",recordsSummary+20]]  idOfServiceUrl:12 headers:nil methodType:@"GET" onSucess:^(NSString *responseData) {
            
            toVal = recordsSummary+20;
            
            [_customIOS7AlertView close];
            
            id response = [NSJSONSerialization JSONObjectWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                  NSLog(@"response=%@",response);
            
                  if ([[response valueForKey:@"_PigEvents"] isKindOfClass:[NSArray class]]) {
                  NSString *strRec = [[response objectForKey:@"_RecCount"] objectForKey:@"totRecs"];
                      
                      if ([strRec localizedCaseInsensitiveContainsString:@"Not connected"]) {//to do too
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
                                                           
                                                           [_customIOS7AlertView close];
                                                       }];
                                                   }
                                                   else {
                                                       UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                                                  message:strInternet
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
                      
                      NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];

                      if (maxCountSummary == 20) {
                          [pref setValue:strRec forKey:@"totRecs"];
                          [pref synchronize];
                      }
                      
                      maxCountSummary = [strRec integerValue];
                      NSString *preRec = [pref valueForKey:@"totRecs"];
                      
                      if (preRec.intValue !=[strRec integerValue] && preRec.integerValue !=0) {//Need to unit test
                          [self displayToastWithMessage:@"Cache has updated."];
                          [pref setValue:strRec forKey:@"totRecs"];
                          [pref synchronize];
                      }
                      
                       [arrhistory addObjectsFromArray:[response valueForKey:@"_PigEvents"]];
                       canCallSummary = NO;

                               if (arrhistory.count>0) {
                                   if ([[[arrhistory objectAtIndex:0] valueForKey:@"SexId"] caseInsensitiveCompare:@"s"] == NSOrderedSame)
                                   {
                                      self.btnSummary.hidden = NO;
                                       self.btnHistry.hidden = YES;
                                       self.BtnHisrtyUndeline.hidden = YES;
                                       self.btnHistory.hidden = NO;
                                       self.vwUndelineHistory.hidden = NO;
                                       isSow = YES;
                                   }else {
                                       self.btnSummary.hidden = YES;
                                       self.btnHistory.hidden = YES;
                                       self.vwUndelineHistory.hidden = YES;
                                       self.btnHistry.hidden = NO;
                                       self.BtnHisrtyUndeline.hidden = NO;
                                       isSow = NO;
                                   }
                               }
                      
                             [self.clHistory reloadData];
                            }
                            else {
                                UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                           message:[response valueForKey:@"Msg"]
                                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                                UIAlertAction* ok = [UIAlertAction
                                                     actionWithTitle:strOk
                                                     style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction * action){
                                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                                     }];
                                
                                [myAlertController addAction: ok];
                                [self presentViewController:myAlertController animated:YES completion:nil];
                            }
            
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
            }
        } onFailure:^(NSMutableDictionary *responseData, NSError *error) {
            id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
            NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
            [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
            NSString *strDate = [dateformate stringFromDate:[NSDate date]];
            
            NSString *strErr = [NSString stringWithFormat:@"User Name = %@,Farm Name = %@,error = %@,DateTime=%@,On History=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],[[NSUserDefaults standardUserDefaults] objectForKey:@"f_nm"],error.description,strDate, self.title];
            [tracker set:kGAIScreenName value:strErr];
            [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
            [_customIOS7AlertView close];

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
        }];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in callHistorySerivce =%@",exception.description);
    }
}

- (IBAction)btnSummary_tapped:(id)sender {
    @try {
        self.vwHistory.hidden = YES;
        self.tblSummary.hidden = NO;
        self.vwUndelineHistory.hidden = YES;
        self.vwUnderlineSummary.hidden = NO;
        arrSummary = [[NSMutableArray alloc]init];

        if ([[ControlSettings sharedSettings] isNetConnected ]) {
            _customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
            [_customIOS7AlertView showLoaderWithMessage:strWait];
            
            //http://192.168.20.40/PigchampWebZ
            
            //
            [ServerManager sendRequest:[NSString stringWithFormat:@"token=%@&Identity=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],self.strIdentityId]  idOfServiceUrl:28 headers:nil methodType:@"GET" onSucess:^(NSString *responseData) {
                
                [_customIOS7AlertView close];
               // id response = [NSJSONSerialization JSONObjectWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                
                NSArray *arrResponse  = [NSJSONSerialization JSONObjectWithData:[responseData dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableContainers error:nil];
                
                for (NSDictionary *dict in arrResponse) {
                    if (![[dict valueForKey:@"propName"]isKindOfClass:[NSNull class]]) {
                        [arrSummary addObject:dict];
                    }
                }
                
                [self.tblSummary reloadData];
                
            } onFailure:^(NSMutableDictionary *responseData, NSError *error) {
                
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
            }];
        }else {
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                       message:strInternet
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *ok = [UIAlertAction
                                 actionWithTitle:strOk
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [myAlertController addAction: ok];
            [self presentViewController:myAlertController animated:YES completion:nil];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in btnSummary_tapped =%@",exception.description);
    }
}

- (IBAction)btnDelete_tapped:(id)sender {
    @try {
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
        [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *strDate = [dateformate stringFromDate:[NSDate date]];
        
        NSString *strErr = [NSString stringWithFormat:@"User Name = %@,Farm Name = %@,error = %@,DateTime=%@,On Delete=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],[[NSUserDefaults standardUserDefaults] objectForKey:@"f_nm"],@"error",strDate, self.title];
        [tracker set:kGAIScreenName value:strErr];
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
        
        if (selecteditem.integerValue>=0){
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                       message:strSureDelete
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:strOk
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     if (selecteditem.integerValue>=0){
                                         NSDictionary *dict  =[arrhistory objectAtIndex:selecteditem.integerValue];
                                         
                                         if ([[ControlSettings sharedSettings] isNetConnected ]) {
                                             _customIOS7AlertView = [[CustomIOS7AlertView alloc] init];
                                             [_customIOS7AlertView showLoaderWithMessage:strWait];
                                             
                                             NSString *strPigIdKey;
                                             NSString *strEventKey;
                                             
                                             if (![[dict valueForKey:@"PigIdKey"] isKindOfClass:[NSNull class]]) {
                                                 strPigIdKey = [dict valueForKey:@"PigIdKey"]?[dict valueForKey:@"PigIdKey"]:@"";
                                             }
                                             
                                             if (![[dict valueForKey:@"EventKey"] isKindOfClass:[NSNull class]]){
                                                 strEventKey = [dict valueForKey:@"EventKey"]?[dict valueForKey:@"EventKey"]:@"";
                                             }
                                             
                                             //
                                             NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
                                             [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
                                             [dict setValue:strPigIdKey forKey:@"PigIdKey"];
                                             [dict setValue:strEventKey forKey:@"EventKey"];
                                             //
                                             
                                             [ServerManager sendRequest:[NSString stringWithFormat:@"token=%@&PigIdKey=%@&EventKey=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"token"],strPigIdKey,strEventKey] idOfServiceUrl:14  headers:dict methodType:@"POST" onSucess:^(NSString *responseData) {
                                                 [_customIOS7AlertView close];
                                                /*
                                                if (arrhistory.count==2 && ([[[arrhistory objectAtIndex:0] valueForKey:@"SexId"] caseInsensitiveCompare:@"s"] == NSOrderedSame) && ([[[arrhistory objectAtIndex:0] valueForKey:@"EventCode"] integerValue] == 19)){
                                                     NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
                                                     NSString *strIds = [pref valueForKey:@"deletedIndetity"];
                                                     strIds = [[strIds stringByAppendingString:_strTitle] stringByAppendingString:@","];
                                                     [pref setValue:strIds forKey:@"deletedIndetity"];
                                                     [pref synchronize];
                                                     [arrhistory removeAllObjects];
                                                     [self.clHistory reloadData];
                                                     
                                                     UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                                                message:responseData
                                                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                                     UIAlertAction* ok = [UIAlertAction
                                                                          actionWithTitle:strOk
                                                                          style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action) {
                                                                              
                                                                              [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                                                          }];
                                                     [myAlertController addAction: ok];
                                                     [self presentViewController:myAlertController animated:YES completion:nil];
                                                 }
                                                 else*/
                                                 if ([responseData isEqualToString:@"\"Event deleted successfully\""])                                               {
                                                     responseData = [responseData stringByReplacingOccurrencesOfString:@"\"" withString:@" "];
                                                     
//                                                     if (arrhistory.count==1)
//                                                     {
//                                                        NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
//                                                        NSString *strIds = [pref valueForKey:@"deletedIndetity"];
//                                                        strIds = [[strIds stringByAppendingString:_strTitle] stringByAppendingString:@","];
//                                                        [pref setValue:strIds forKey:@"deletedIndetity"];
//                                                        [pref synchronize];
//                                                        [arrhistory removeAllObjects];
//                                                        [self.clHistory reloadData];
//                                                     }else  if (arrhistory.count==2 && ([[[arrhistory objectAtIndex:0] valueForKey:@"SexId"] caseInsensitiveCompare:@"s"] == NSOrderedSame) && ([[[arrhistory objectAtIndex:0] valueForKey:@"EventCode"] integerValue] == 19)){
//                                                         NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
//                                                         NSString *strIds = [pref valueForKey:@"deletedIndetity"];
//                                                         strIds = [[strIds stringByAppendingString:_strTitle] stringByAppendingString:@","];
//                                                         [pref setValue:strIds forKey:@"deletedIndetity"];
//                                                         [pref synchronize];
//                                                         [arrhistory removeAllObjects];
//                                                         [self.clHistory reloadData];
//                                                     }
                                                     
//
//                                                         UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
//                                                                                                                                        message:responseData
//preferredStyle:UIAlertControllerStyleAlert];
//                                                             UIAlertAction* ok = [UIAlertAction
//                                                                                  actionWithTitle:strOk
//                                                                                  style:UIAlertActionStyleDefault
//                                                                                  handler:^(UIAlertAction * action) {
//                                                                                      
//                                                                                      [myAlertController dismissViewControllerAnimated:YES completion:nil];
//                                                                                  }];
//                                                             
//                                                             [myAlertController addAction: ok];
//                                                             [self presentViewController:myAlertController animated:YES completion:nil];
//                                                     }
//                                                     else
                                                     {
                                                         @try {
//                                                             [arrhistory removeObjectAtIndex:selecteditem.integerValue];
//                                                             [self.clHistory reloadData];

                                                             {
                                                                 UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                                                            message:responseData
                                                                                                                                     preferredStyle:UIAlertControllerStyleAlert];
                                                                 UIAlertAction* ok = [UIAlertAction
                                                                                      actionWithTitle:strOk
                                                                                      style:UIAlertActionStyleDefault
                                                                                      handler:^(UIAlertAction * action)  {
                                                                                          [arrhistory removeAllObjects];
                                                                                          [self.clHistory reloadData];
                                                                                         // recordsSummary = 0;
                                                                                          [self callHistorySerivceAfterDelet:strLoading];
                                                                                          [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                                                                      }];
                                                                 
                                                                 [myAlertController addAction: ok];
                                                                 [self presentViewController:myAlertController animated:YES completion:nil];
                                                             }
                                                          }
                                                         @catch (NSException *exception) {
                                                             NSLog(@"Exception on reload =%@",exception.description);
                                                         }
                                                     }
                                                     
                                                     selecteditem = @"-1";
                                                 }else if ([responseData isEqualToString:@"\"User is not signed in or Session expired\""] || [responseData localizedCaseInsensitiveContainsString:@"\"Token not found\""]) {
                                                     UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                                                message:responseData
                                                                                                                         preferredStyle:UIAlertControllerStyleAlert];
                                                     UIAlertAction* ok = [UIAlertAction
                                                                          actionWithTitle:strOk
                                                                          style:UIAlertActionStyleDefault
                                                                          handler:^(UIAlertAction * action)                                                                         {
                    [[SlideNavigationController sharedInstance]popToRootViewControllerAnimated:YES];                                                                              [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                                                          }];
                                                     
                                                     [myAlertController addAction: ok];
                                                     [self presentViewController:myAlertController animated:YES completion:nil];
                                                 }
                                             } onFailure:^(NSMutableDictionary *responseData, NSError *error) {
                                                 [_customIOS7AlertView close];

                                                 id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
                                                 NSDateFormatter *dateformate=[[NSDateFormatter alloc]init];
                                                 [dateformate setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
                                                 NSString *strDate = [dateformate stringFromDate:[NSDate date]];
                                                 
                                                 NSString *strErr = [NSString stringWithFormat:@"User Name = %@,Farm Name = %@,error = %@,DateTime=%@,On History=%@",[[NSUserDefaults standardUserDefaults] objectForKey:@"userName"],[[NSUserDefaults standardUserDefaults] objectForKey:@"f_nm"],error.description,strDate, self.title];
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
                                             }];
                                         }
                                         else
                                         {
                                             UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                                                        message:strInternet
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
                                     }
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            UIAlertAction* cancel = [UIAlertAction
                                     actionWithTitle:strCancel
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     }];
            [myAlertController addAction: cancel];
            [myAlertController addAction: ok];
            [self presentViewController:myAlertController animated:YES completion:nil];
        }else{
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                       message:strSelectDelete
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"ok"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action){
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [myAlertController addAction: ok];
            [self presentViewController:myAlertController animated:YES completion:nil];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in btnDelete_tapped=%@",exception.description);
    }
}

- (IBAction)btnEdit_tapped:(id)sender {
    @try {
      [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"FromDataEntry"];
        
        NSDictionary *dict;//  =[arrhistory objectAtIndex:[selecteditem integerValue]];
        if (selecteditem.integerValue>=0){
            dict  =[arrhistory objectAtIndex:[selecteditem integerValue]];
        }
        
        NSLog(@"selecteditem=%@",selecteditem);
        
        if (selecteditem.integerValue>=0) {
            DynamicFormViewController *newView = [self.storyboard instantiateViewControllerWithIdentifier:@"DynamicForm"];
            newView.strEventCode = [dict valueForKey:@"EventCode"]?[dict valueForKey:@"EventCode"]:@"";
            newView.strTitle = strEditTitle;
            newView.lblTitle = [dict valueForKey:@"Event"]?[dict valueForKey:@"Event"]:@"";
            newView.dict = dict;
            if (selecteditem.integerValue>=0)
                [self.navigationController pushViewController:newView animated:YES];
        }else{
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                       message:strSelectEdit
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"ok"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [myAlertController addAction: ok];
            [self presentViewController:myAlertController animated:YES completion:nil];
        }
    }
    @catch (NSException *exception){
        NSLog(@"Exception in btnEdit_tapped =%@",exception.description);
    }
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
