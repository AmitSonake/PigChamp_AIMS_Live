//
//  ReportsInput.m
//  PigChamp
//
//  Created by Venturelabour on 05/02/16.
//  Copyright © 2016 Venturelabour. All rights reserved.
//

#import "ReportsInput.h"
#import "CoreDataHandler.h"
#import "ActiveAnimalListViewController.h"
#import "ProductionsummaryViewController.h"
#import <Google/Analytics.h>

BOOL isOpenReportInput = NO;
BOOL isThousandFormatReport = NO;

@interface ReportsInput ()
@end

@implementation ReportsInput

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //
    NSArray *arrUserParameter = [[CoreDataHandler sharedHandler] getValuesToListWithEntityName:@"User_Parameters" andPredicate:nil andSortDescriptors:nil];
    
    for (int count=0; count<arrUserParameter.count; count++){
        if ([[[arrUserParameter objectAtIndex:count] valueForKey:@"nm"]  isEqualToString:@"DateUsageFormat"]){
            _strDateFormat = [[arrUserParameter objectAtIndex:count] valueForKey:@"val"];
        }
    }
    
    if ([self.strDateFormat isEqualToString:@"1"]) {
        isThousandFormatReport = YES;
    }else {
        isThousandFormatReport = NO;
    }
    
    NSLog(@"_strDateFormat=%@",_strDateFormat);
    //
    
    NSUserDefaults *pref = [NSUserDefaults standardUserDefaults];
    [pref setValue:@"0" forKey:@"reload"];
    [pref synchronize];
    self.navigationController.navigationBar.translucent = NO;

    _btnRunReport.layer.shadowColor = [[UIColor grayColor] CGColor];
    _btnRunReport.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    _btnRunReport.layer.shadowOpacity = 1.0f;
    _btnRunReport.layer.shadowRadius = 3.0f;

    _btnCancel.layer.shadowColor = [[UIColor grayColor] CGColor];
    _btnCancel.layer.shadowOffset = CGSizeMake(1.0f, 1.0f);
    _btnCancel.layer.shadowOpacity = 1.0f;
    _btnCancel.layer.shadowRadius = 3.0f;

    
    _arrDynamicReport = [[NSMutableArray alloc]init];
    _arrDropDownReport = [[NSMutableArray alloc]init];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(-20, 0, 22, 22);
    [button setBackgroundImage:[UIImage imageNamed:@"back_arrow"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(btnBack_tapped) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton=[[UIBarButtonItem alloc] init];
    [barButton setCustomView:button];
    self.navigationItem.leftBarButtonItem=barButton;
    
    NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:[[NSMutableArray alloc] initWithObjects:@"CLEAr",@"SaVE",@"Yes",@"No",@"Ok",@"Cancel",@"Please Wait...",@"Your session has been expired. Please login again.",@"Server Error.",nil]];
    
    NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
    
    strYes = @"Yes";
    strNo = @"No";
    strOk = @"OK";
    strCancel = @"CANCEL";
    strWait = @"Please Wait...";
    strNoInternet = @"You must be online for the app to function.";
    strIdentity = @"You must enter a value for animal Identity.";
    strUnauthorised = @"Your session has been expired. Please login again.";
    strServerErr  = @"Server Error.";
    
    if (resultArray1.count!=0){
        for (int i=0; i<resultArray1.count; i++){
            [dictMenu setObject:[[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] uppercaseString] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
        }
        
        for (int i=0; i<11; i++) {
            if (i==0) {
                NSString *strSearchTitle;
                if ([dictMenu objectForKey:@"CLEAR"] && ![[dictMenu objectForKey:@"CLEAR"] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:@"CLEAR"] length]>0) {
                        strSearchTitle = [dictMenu objectForKey:@"CLEAR"]?[dictMenu objectForKey:@"CLEAR"]:@"";
                    }else{
                        strSearchTitle = @"CLEAR";
                    }
                }
                else{
                    strSearchTitle = @"CLEAR";
                }
                
                [self.btnClear setTitle:strSearchTitle forState:UIControlStateNormal];
            }else  if (i==1){
                NSString *strSearchTitle;
                if ([dictMenu objectForKey:@"SAVE"] && ![[dictMenu objectForKey:@"SAVE"] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:@"SAVE"] length]>0) {
                        strSearchTitle = [dictMenu objectForKey:@"SAVE"]?[dictMenu objectForKey:@"SAVE"]:@"";
                    }else{
                        strSearchTitle = @"SAVE";
                    }
                }
                else{
                    strSearchTitle = @"SAVE";
                }
                
                [self.btnSave setTitle:strSearchTitle forState:UIControlStateNormal];
            }else  if (i==2){
                if ([dictMenu objectForKey:[@"Yes" uppercaseString]] && ![[dictMenu objectForKey:[@"Yes" uppercaseString]] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:[@"Yes" uppercaseString]] length]>0) {
                        strYes = [dictMenu objectForKey:[@"Yes" uppercaseString]]?[dictMenu objectForKey:[@"Yes" uppercaseString]]:@"";
                    }
                }
            }else  if (i==3){
                if ([dictMenu objectForKey:[@"No" uppercaseString]] && ![[dictMenu objectForKey:[@"No" uppercaseString]] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:[@"No" uppercaseString]] length]>0) {
                        strNo = [dictMenu objectForKey:[@"No" uppercaseString]]?[dictMenu objectForKey:[@"No" uppercaseString]]:@"";
                    }
                }
            }else  if (i==4){
                if ([dictMenu objectForKey:[@"Ok" uppercaseString]] && ![[dictMenu objectForKey:[@"Ok" uppercaseString]] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:[@"Ok" uppercaseString]] length]>0) {
                        strOk = [dictMenu objectForKey:[@"Ok" uppercaseString]]?[dictMenu objectForKey:[@"Ok" uppercaseString]]:@"";
                    }
                }
            }else  if (i==5){
                if ([dictMenu objectForKey:[@"Cancel" uppercaseString]] && ![[dictMenu objectForKey:[@"Cancel" uppercaseString]] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:[@"Cancel" uppercaseString]] length]>0) {
                        strCancel = [dictMenu objectForKey:[@"Cancel" uppercaseString]]?[dictMenu objectForKey:[@"Cancel" uppercaseString]]:@"";
                    }
                }
            }else  if (i==6){
                if ([dictMenu objectForKey:[@"Please Wait..." uppercaseString]] && ![[dictMenu objectForKey:[@"Please Wait..." uppercaseString]] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:[@"Please Wait..." uppercaseString]] length]>0) {
                        strWait = [dictMenu objectForKey:[@"Please Wait..." uppercaseString]]?[dictMenu objectForKey:[@"Please Wait..." uppercaseString]]:@"";
                    }
                }
            }else  if (i==7){
                if ([dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]] && ![[dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]] length]>0) {
                        strNoInternet = [dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]]?[dictMenu objectForKey:[@"You must be online for the app to function." uppercaseString]]:@"";
                    }
                }
            }else  if (i==8){
                if ([dictMenu objectForKey:[@"You must enter a value for animal Identity." uppercaseString]] && ![[dictMenu objectForKey:[@"You must enter a value for animal Identity." uppercaseString]] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:[@"You must enter a value for animal Identity." uppercaseString]] length]>0) {
                        strNoInternet = [dictMenu objectForKey:[@"You must enter a value for animal Identity." uppercaseString]]?[dictMenu objectForKey:[@"You must enter a value for animal Identity." uppercaseString]]:@"";
                    }
                }
            }else  if (i==9){
                if ([dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] && ![[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]] length]>0) {
                        strUnauthorised = [dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]]?[dictMenu objectForKey:[@"Your session has been expired. Please login again." uppercaseString]]:@"";
                    }
                }
            }else  if (i==10){
                if ([dictMenu objectForKey:[@"Server Error." uppercaseString]] && ![[dictMenu objectForKey:[@"Server Error." uppercaseString]] isKindOfClass:[NSNull class]]) {
                    if ([[dictMenu objectForKey:[@"Server Error." uppercaseString]] length]>0) {
                        strServerErr = [dictMenu objectForKey:[@"Server Error." uppercaseString]]?[dictMenu objectForKey:[@"Server Error." uppercaseString]]:@"";
                    }
                }
            }
        }
    }
    
    [self createDynamicGUIWithDefaultValues];
    
    tlc = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuViewController"];
    
    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button1 setImage:[UIImage imageNamed:@"Menu"] forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(updateMenuBarPositions) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button1];
    self.navigationItem.rightBarButtonItem=rightBarButtonItem;
}

-(void)addObject:(NSString*)object englishVersion:(NSString*)englishVersion dataType:(NSString*)dataType defaultVal:(NSString*)defaultVal{
    @try {
        NSDictionary *dict = [[NSMutableDictionary alloc]init];
        [dict setValue:dataType?dataType:@"" forKey:@"dataType"];
        
        if (object.length!=0){
            [dict setValue:object?object:@"" forKey:@"visible"];
            [_arrDynamicReport addObject:dict];
        }
        else{
            [dict setValue:englishVersion?englishVersion:@"" forKey:@"visible"];
            [_arrDynamicReport addObject:dict];
            //[_dictDynamicReport setValue:defaultVal forKey:[dict valueForKey:@"visible"]];
        }
        
        [_dictDynamicReport setValue:defaultVal forKey:[dict valueForKey:@"visible"]];
        
        if ([dataType isEqualToString:@"Date"]) {
            [_dictJsonReport setValue:[self set1000Date:defaultVal] forKey:[dict valueForKey:@"visible"]];
        }
    }
    @catch (NSException *exception){
        
        NSLog(@"Exception ion addObject=%@",exception.description);
    }
}

-(void)viewWillAppear:(BOOL)animated {
    @try {
        [super viewWillAppear:animated];
        SlideNavigationController *sld = [SlideNavigationController sharedInstance];
        sld.delegate = self;
        isOpenReportInput = NO;
        id<GAITracker> tracker = [[GAI sharedInstance] defaultTracker];
        if ([_strEvent isEqualToString:@"5"]) {
            [tracker set:kGAIScreenName value:@"Active Animals List Input Screen"];
        }else if ([_strEvent isEqualToString:@"7"]) {
            [tracker set:kGAIScreenName value:@"Open Sow List Input Screen"];
        }else if ([_strEvent isEqualToString:@"8"]) {
            [tracker set:kGAIScreenName value:@"Gilt Pool Input Screen"];
        }else if ([_strEvent isEqualToString:@"10"]) {
            [tracker set:kGAIScreenName value:@"Warning List-Not Serrved Input Screen"];
        }else if ([_strEvent isEqualToString:@"11"]) {
            [tracker set:kGAIScreenName value:@"Warning List-Not Weaned Input Screen"];
        }else if ([_strEvent isEqualToString:@"9"]) {
            [tracker set:kGAIScreenName value:@"Sows Due to Farrow Input Screen"];
        }else if ([_strEvent isEqualToString:@"6"]) {
            [tracker set:kGAIScreenName value:@"Sows Due for Attention Input Screen"];
        }
        
        [tracker send:[[GAIDictionaryBuilder createScreenView] build]];
    }
    @catch (NSException *exception){
        NSLog(@"Exception in viewWillAppear in sub data menu data entry  = %@",exception.description);
    }
}

-(void)updateMenuBarPositions {
    @try {
        [self.activeTextField resignFirstResponder];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(removeView:) name:@"CloseAlert" object:nil];

        UIWindow *currentWindow = [UIApplication sharedApplication].keyWindow;
        
        if (!isOpenReportInput) {
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
        
        isOpenReportInput = !isOpenReportInput;
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
        isOpenReportInput = !isOpenReportInput;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in removeView=%@",exception.description);
    }
}

//- (BOOL)slideNavigationControllerShouldDisplayRightMenu{
//    return YES;
//}

#pragma mark - Table view methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _arrDynamicReport.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    @try {
        return 45;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in heightForFooterInSection=%@",exception.description);
    }
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    @try {
        return _vwFooter;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in viewForFooterInSection = %@",exception.description);
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    @try {
        //NSLog(@"indexPath.row=%d",indexPath.row);
        
        UITableViewCell *cell;
        NSMutableDictionary *dict = [_arrDynamicReport objectAtIndex:indexPath.row];
        NSString *strDataType = [dict valueForKey:@"dataType"];
     
        if ([strDataType isEqualToString:@"IR"]) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"TextWihScanner" forIndexPath:indexPath];
            
            if (cell ==nil){
                cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextWihScanner"];
            }
            
            cell.backgroundColor = [UIColor clearColor];
            UILabel *lblDetails = (UILabel*)[cell viewWithTag:1];
            lblDetails.text = [dict valueForKey:@"visible"]?[dict valueForKey:@"visible"]:@"";
            
            if ([_strEvent isEqualToString:@"3"] || [_strEvent isEqualToString:@"5"]){
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                    lblDetails.font = [UIFont boldSystemFontOfSize:17];
                }else{
                    lblDetails.font = [UIFont boldSystemFontOfSize:13];
                }
            }else{
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                    lblDetails.font = [UIFont systemFontOfSize:17];
                }else{
                    lblDetails.font = [UIFont systemFontOfSize:13];
                }
            }
            
            UITextField *txtDynamic = (UITextField*)[cell viewWithTag:2];
            UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 20, txtDynamic.frame.size.height)];
            leftView.backgroundColor = [UIColor clearColor];
            txtDynamic.rightViewMode = UITextFieldViewModeAlways;
            txtDynamic.rightView = leftView;
            
            txtDynamic.text = [_dictDynamicReport valueForKey:[dict valueForKey:@"visible"]];
           //[txtDynamic setKeyboardType:UIKeyboardTypeNumberPad];
        }
        else if ([strDataType isEqualToString:@"Date"]) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"DateReport" forIndexPath:indexPath];
            
            if (cell ==nil){
                cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DateReport"];
            }
            
            UILabel *lblDetails = (UILabel*)[cell viewWithTag:1];
            lblDetails.text = [dict valueForKey:@"visible"];
            
            if ([_strEvent isEqualToString:@"3"] || [_strEvent isEqualToString:@"5"]){
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                    lblDetails.font = [UIFont boldSystemFontOfSize:17];
                }else{
                    lblDetails.font = [UIFont boldSystemFontOfSize:13];
                }
            }else{
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                    lblDetails.font = [UIFont systemFontOfSize:17];
                }else{
                    lblDetails.font = [UIFont systemFontOfSize:13];
                }
            }
            
            UIButton *btn = (UIButton*)[cell viewWithTag:2];
            btn.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;//UILineBreakModeWordWrap
            btn.titleLabel.textAlignment = NSTextAlignmentCenter;//UITextAlignmentCenter
            btn.layer.borderColor =[[UIColor colorWithRed:206.0/255.0 green:208.0/255.0 blue:206.0/255.0 alpha:1] CGColor];
           [btn setTitle:[_dictJsonReport valueForKey:[dict valueForKey:@"visible"]] forState:UIControlStateNormal];
            
            //
            NSDateFormatter *dateFormatterr = [[NSDateFormatter alloc]init];
            [dateFormatterr setDateFormat:@"MM/dd/yyyy"];//
            
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init] ;
            [dateFormatter setDateFormat:@"yyyy-MM-dd'T'00:00:00"];
            NSString *currentDate;
            
            if(currentDate == nil){
                currentDate = [dateFormatter stringFromDate:[NSDate date]];
            }
            
            NSDate *todayDate;
            todayDate =[dateFormatter dateFromString:currentDate];
            
            NSDateFormatter *dateFormatterr1 = [[NSDateFormatter alloc]init] ;
            [dateFormatterr1 setDateFormat:@"MM/dd/yyyy"];//
            NSDate *dtCheckIn = [dateFormatterr1 dateFromString:[_dictDynamicReport valueForKey:[dict valueForKey:@"visible"]]];
            
            int days = [dtCheckIn timeIntervalSinceDate:todayDate]/24/60/60;
            
            if (days==0){
                [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }else if (days==1){
                [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
            }else{
                [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
        }
         else if ([strDataType isEqualToString:@"DropDown"]) {
             cell = [tableView dequeueReusableCellWithIdentifier:@"DropDownReport"];
             
             if (cell ==nil) {
                 cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DropDownReport"];
             }
             
             UILabel *lblDetails = (UILabel*)[cell viewWithTag:1];
             lblDetails.text = [dict valueForKey:@"visible"];
             
             if ([_strEvent isEqualToString:@"3"] || [_strEvent isEqualToString:@"5"]) {
                 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                     lblDetails.font = [UIFont boldSystemFontOfSize:17];
                 }else {
                     lblDetails.font = [UIFont boldSystemFontOfSize:13];
                 }
             }else{
                 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
                     lblDetails.font = [UIFont systemFontOfSize:17];
                 }else {
                     lblDetails.font = [UIFont systemFontOfSize:13];
                 }
             }
             
             UIButton *btn = (UIButton*)[cell viewWithTag:2];
             btn.layer.borderColor =[[UIColor colorWithRed:206.0/255.0 green:208.0/255.0 blue:206.0/255.0 alpha:1] CGColor];
            [btn setTitle:[_dictDynamicReport valueForKey:[dict valueForKey:@"visible"]] forState:UIControlStateNormal];
         }else if ([strDataType isEqualToString:@"Text"]){
            cell = [tableView dequeueReusableCellWithIdentifier:@"TextReport"];
            
            if (cell ==nil){
                cell  = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"TextReport"];
            }
            
            UILabel *lblDetails = (UILabel*)[cell viewWithTag:1];
            lblDetails.text = [dict valueForKey:@"visible"];
            
             if ([_strEvent isEqualToString:@"3"] || [_strEvent isEqualToString:@"5"]){
                 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                     lblDetails.font = [UIFont boldSystemFontOfSize:17];
                 }else{
                     lblDetails.font = [UIFont boldSystemFontOfSize:13];
                 }
             }else{
                 if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                     lblDetails.font = [UIFont systemFontOfSize:17];
                 }else{
                     lblDetails.font = [UIFont systemFontOfSize:13];
                 }
             }
            
            UITextField *txtDynamic = (UITextField*)[cell viewWithTag:2];
            txtDynamic.text = [_dictDynamicReport valueForKey:[dict valueForKey:@"visible"]];
            [txtDynamic setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
        }
        
        return cell;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in cellForRowAtIndexPath =%@",exception.description);
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

//----------------------------------------------------------------------------------------------------------------------------------

#pragma mark - picker methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    @try {
        return  1;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in numberOfRowsInComponent=%@",exception.description);
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;{
    @try{
        if (pickerView==self.pickerDropDownReport){
            return [_arrDropDownReport count];
        }
    }
    @catch (NSException *exception){
        NSLog(@"Exception in numberOfRowsInComponent- %@",[exception description]);
    }
}

//----------------------------------------------------------------------------------------------------------------------------------

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    @try{
        [[self.pickerDropDownReport.subviews objectAtIndex:1] setBackgroundColor:[UIColor darkGrayColor]];
        [[self.pickerDropDownReport.subviews objectAtIndex:2] setBackgroundColor:[UIColor darkGrayColor]];
        if (pickerView==self.pickerDropDownReport){
            return [[_arrDropDownReport objectAtIndex:row] valueForKey:@"visible"];
        }
    }
    @catch (NSException *exception){
        NSLog(@"Exception in titleForRow- %@",[exception description]);
    }
}

//----------------------------------------------------------------------------------------------------------------------------------

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    @try
    {
        [[self.pickerDropDownReport.subviews objectAtIndex:1] setBackgroundColor:[UIColor darkGrayColor]];
        [[self.pickerDropDownReport.subviews objectAtIndex:2] setBackgroundColor:[UIColor darkGrayColor]];
        UILabel *lblSortText = (id)view;
        
        if (!lblSortText)
        {
            lblSortText= [[UILabel alloc] initWithFrame:CGRectMake(10.0f, 0.0f, [pickerView rowSizeForComponent:component].width-15, [pickerView rowSizeForComponent:component].height)];
        }
        
        lblSortText.font = [UIFont systemFontOfSize:13];
        lblSortText.textColor = [UIColor blackColor];
        lblSortText.textAlignment = NSTextAlignmentCenter;
        lblSortText.tintColor = [UIColor clearColor];

        if (pickerView==self.pickerDropDownReport) {
            lblSortText.text = [[_arrDropDownReport objectAtIndex:row] valueForKey:@"visible"];
            return lblSortText;
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception in viewForRow- %@",[exception description]);
    }
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    @try
    {
        [textField resignFirstResponder];
        
        return YES;
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception in textFieldShouldReturn in ViewController- %@",[exception description]);
    }
}

#pragma mark - Textfield methods
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    self.activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    self.activeTextField = nil;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    @try {
        UITableViewCell* cell = (UITableViewCell*)[[textField superview] superview];
        
        if (textField.tag==12){
            cell = [(UITableViewCell*)[[textField superview] superview] superview];
        }
        else if (textField.tag==13 || (textField.tag==14)){
            cell = [[(UITableViewCell*)[[textField superview] superview] superview] superview];
        }
        
        NSIndexPath *indexPath = [self.tblReportsDynamic indexPathForCell:cell];
        NSDictionary *dict = [self.arrDynamicReport objectAtIndex:indexPath.row];
        NSString *newString = [[textField.text stringByReplacingCharactersInRange:range withString:string] uppercaseString];

        if([string isEqualToString:@""]) {
            [self.dictDynamicReport setValue:newString forKey:[dict valueForKey:@"visible"]];
            return YES;
        }
        
        if ([_strEvent isEqualToString:@"10"] || [_strEvent isEqualToString:@"11"]) {
            NSCharacterSet *characterSet = nil;
            characterSet = [NSCharacterSet characterSetWithCharactersInString:@"01234567890"];
            NSRange location = [string rangeOfCharacterFromSet:characterSet];
            if ((location.location != NSNotFound) && (newString.length < 3)){
                [self.dictDynamicReport setValue:newString forKey:[dict valueForKey:@"visible"]];
                return ((location.location != NSNotFound) && (newString.length < 4));
            }
            else {
                return NO;
            }
        }else if ([_strEvent isEqualToString:@"9"] || [_strEvent isEqualToString:@"8"] || [_strEvent isEqualToString:@"6"]) {
            NSCharacterSet *characterSet = nil;
            characterSet = [NSCharacterSet characterSetWithCharactersInString:@"01234567890"];
            NSRange location = [string rangeOfCharacterFromSet:characterSet];
            if ((location.location != NSNotFound) && (newString.length < 4)){
                [self.dictDynamicReport setValue:newString forKey:[dict valueForKey:@"visible"]];
                return ((location.location != NSNotFound) && (newString.length < 4));
            }
            else {
                return NO;
            }
        }else if ([_strEvent isEqualToString:@"3"]){
                @try{
                    if (textField.text.length>14) {
                        return NO;
                    }
                    else{
                    [_dictDynamicReport setValue:newString forKey:[dict valueForKey:@"visible"]];
                        return YES;
                    }
                }
                @catch (NSException *exception){
                    NSLog(@"Exception in shouldChangeCharactersInRange- %@",[exception description]);
                }
        }
        else {
            [self.dictDynamicReport setValue:newString forKey:[dict valueForKey:@"visible"]];
        }
        
        return YES;
    }
    @catch (NSException *exception)
    {
        NSLog(@"Exception in shouldChangeCharactersInRange- %@",[exception description]);
    }
}

#pragma mark - other methods
-(void)btnBack_tapped {
    @try {
        [self.navigationController popViewControllerAnimated:YES];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in btnBack_tapped=%@",exception.description);
    }
}

- (IBAction)btnDate_tapped:(id)sender {
    @try {
      [self.activeTextField resignFirstResponder];
        UITableViewCell* cell = (UITableViewCell*)[[sender superview] superview];
        NSIndexPath* indexPath = [self.tblReportsDynamic indexPathForCell:cell];
        NSDictionary *dict = [_arrDynamicReport objectAtIndex:indexPath.row];
        NSString *strPrevSelectedValue = [_dictDynamicReport valueForKey:[dict valueForKey:@"visible"]];
        __block NSString *strTitle=[dict valueForKey:@"visible"]?[dict valueForKey:@"visible"]:@"";

        NSDateFormatter *dateFormatterr = [[NSDateFormatter alloc]init] ;
        [dateFormatterr setDateFormat:@"MM/dd/yyyy"]; //MMMM dd
        
        NSDate *dt2 = [dateFormatterr dateFromString:strPrevSelectedValue];
        
        self.dtPickerReport= [[UIDatePicker alloc] init];
        self.dtPickerReport.frame=CGRectMake(15, 14, 260, 150.0);
        self.dtPickerReport.datePickerMode = UIDatePickerModeDate;
        
        if (strPrevSelectedValue.length>0) {
            [self.dtPickerReport setDate:dt2];
        }
        else{
            [self.dtPickerReport setDate:[NSDate date]];
        }
        
        //
        NSDateFormatter *dateFormatterrr = [[NSDateFormatter alloc]init];
        [dateFormatterrr setDateFormat:@"MM/dd/yyyy"];
        NSDate *date = [dateFormatterrr dateFromString:@"1/1/1900"];
        self.dtPickerReport.minimumDate=date;
        
        _alertForPickUpDateReport = [[CustomIOS7AlertView alloc] init];
        [_alertForPickUpDateReport setMyDelegate:self];
        [_alertForPickUpDateReport setButtonTitles:[NSMutableArray arrayWithObjects:strOk,strCancel, nil]];
        [_alertForPickUpDateReport showCustomwithView:self.dtPickerReport title:strTitle];
        __weak typeof(self) weakSelf = self;
        
        [_alertForPickUpDateReport setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
            if(buttonIndex == 0) {
                
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MM/dd/yyyy"];
                
                NSString *strSelectedDate = [formatter stringFromDate:weakSelf.dtPickerReport.date];
                [weakSelf.dictDynamicReport setValue:strSelectedDate forKey:[dict valueForKey:@"visible"]];
                
                //
                NSString *strBaseDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZD"];
                if (isThousandFormatReport) {
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
                    
                    NSString *strSelectedDate100 = [[calFormat stringByAppendingString:@"\n"] stringByAppendingString:[formatter stringFromDate:dtselectedDate]];
                    
                    [weakSelf.dictJsonReport setValue:strSelectedDate100 forKey:[dict valueForKey:@"visible"]];
                }else if([weakSelf.strDateFormat isEqualToString:@"6"]){
                    	                    [formatter setDateFormat:@"MM/dd/yyyy"];
                    	                    [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
                    	                    NSDate *dtselectedDate = [formatter dateFromString:strSelectedDate];
                    	                    NSDate *Firstdate= [weakSelf getFirstDateOfCurrentYear:dtselectedDate];
                   
                   	                    NSInteger days=[weakSelf daysBetweenDate:Firstdate andDate:dtselectedDate];
                    	                    NSLog(@"days:%ld",days);
                    
                    	                    NSString *strDate = [NSString stringWithFormat:@"%03li",days];
                    	                    [formatter setDateFormat:@"yy"];
                    
                   	                    NSString *strSelectedDateyearformat = [[[formatter stringFromDate:dtselectedDate] stringByAppendingString:@"-"] stringByAppendingString:strDate];
                    
                                    //[weakSelf.dictJsonReport setValue:strSelectedDateyearformat forKey:[dict valueForKey:@"visible"]];
                    
                /**********below code added by amit*********************************************/
                                        [formatter setDateFormat:@"EEE,dd-MMM-yyyy"];
                                         NSString *strSelectedDateDayOfyear = [[strSelectedDateyearformat stringByAppendingString:@"\n"] stringByAppendingString:[formatter stringFromDate:dtselectedDate]];
                    
                                    [weakSelf.dictJsonReport setValue:strSelectedDateDayOfyear forKey:[dict valueForKey:@"visible"]];
                /********************************************************************************/
                } else {
                    [weakSelf.dictJsonReport setValue:strSelectedDate forKey:[dict valueForKey:@"visible"]];
                }
                //
                
              }
            
            [weakSelf.tblReportsDynamic reloadData];
            [alertView close];
        }];
        
        [weakSelf.alertForPickUpDateReport setUseMotionEffects:true];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in btnDate_tapped =%@",exception.description);
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

- (IBAction)btnRunReport_tapped:(id)sender {
    @try {
        NSLog(@"event id=%@",_strEvent);
        if ([_strEvent isEqualToString:@"3"]) {
            
            if ([[_dictDynamicReport valueForKey:@"Identity"] length]==0) {
                UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                           message:strIdentity
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:strOk
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action){
                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     }];
                
                [myAlertController addAction:ok];
                [self presentViewController:myAlertController animated:YES completion:nil];
            }else {
                ActiveAnimalListViewController *activeAnimalListViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"ActiveReport"];
                activeAnimalListViewController.strIdentity = [_dictDynamicReport valueForKey:@"Identity"];
                [self.navigationController pushViewController:activeAnimalListViewController animated:YES];
            }
        }else if([_strEvent isEqualToString:@"2"]) {
            ProductionsummaryViewController *productionsummaryViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"ProductSummary"];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
            
            [formatter setDateFormat:@"MM/dd/yyyy"];
            NSDate *dt2 = [formatter dateFromString:[_dictDynamicReport valueForKey:@"Date From"]];
            NSDate *dt3 = [formatter dateFromString:[_dictDynamicReport valueForKey:@"Date To"]];
            
            [formatter setDateFormat:@"yyyyMMdd"];
            NSString *strStart = [formatter stringFromDate:dt2];
            NSString *strEnd = [formatter stringFromDate:dt3];

            [dict setValue:strStart forKey:@"Date From"];
            [dict setValue:strEnd forKey:@"Date To"];
            
            //
            NSCalendar *gregorian = [[NSCalendar alloc]
                                     initWithCalendarIdentifier:NSGregorianCalendar];
            
            NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
            
            NSDateComponents *components = [gregorian components:unitFlags
                                                        fromDate:dt2
                                                          toDate:dt3 options:0];
            NSInteger months = [components month];

            NSComparisonResult result = [dt2 compare:dt3];
            
            if (result== NSOrderedDescending) {
            
            UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                       message:@"Date From should be smaller than To Date."
                                                                                preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:strOk
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action) {
                                     [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                 }];
            
            [myAlertController addAction:ok];
            [self presentViewController:myAlertController animated:YES completion:nil];
            return;
        } else if (months<6) {
                [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
                productionsummaryViewController.dictHeaders = dict;
                [self.navigationController pushViewController:productionsummaryViewController animated:YES];
            } else {
                UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                           message:@"Date range should be within 6 months."
                                                                                    preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* ok = [UIAlertAction
                                     actionWithTitle:strOk
                                     style:UIAlertActionStyleDefault
                                     handler:^(UIAlertAction * action) {
                                         [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                     }];
                
                [myAlertController addAction:ok];
                [self presentViewController:myAlertController animated:YES completion:nil];
                return;
            }
        }
        else {
            FirstReportViewController *firstReportViewController =[self.storyboard instantiateViewControllerWithIdentifier:@"Report"];
            
            NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
            [dict setValue:[[NSUserDefaults standardUserDefaults] objectForKey:@"token"] forKey:@"token"];
            [dict setValue:@"1" forKey:@"FromRec"];
            [dict setValue:@"20" forKey:@"ToRec"];
            [dict setValue:@"" forKey:@"sortFld"];
            [dict setValue:@"0" forKey:@"sortOrd"];
            
            if ([_strEvent isEqualToString:@"5"]) {
                [dict setValue:_strActiveAnimalReportType forKey:@"reportType"];
            }else if ([_strEvent isEqualToString:@"7"]) {
                [dict setValue:[_dictDynamicReport valueForKey:@"Gilts"] forKey:@"gilts"];
                [dict setValue:[_dictDynamicReport valueForKey:@"Weaned Sows"] forKey:@"Weaned"];
                [dict setValue:[_dictDynamicReport valueForKey:@"Aborted Sows"] forKey:@"aborted"];
                [dict setValue:[_dictDynamicReport valueForKey:@"Pregnancy Check Negative/Open"] forKey:@"prcCheck"];
            }else if ([_strEvent isEqualToString:@"8"]) {
                [dict setValue:[_dictDynamicReport valueForKey:@"Include Retained Gilts"] forKey:@"IncludeRetainedGilts"];
                [dict setValue:[_dictDynamicReport valueForKey:@"Acclimatization Period"] forKey:@"AcclimPeriod"];
                [dict setValue:[_dictDynamicReport valueForKey:@"Overdue for Service"] forKey:@"OverdueForService"];
            }else if ([_strEvent isEqualToString:@"10"]) {
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MM/dd/yyyy"];
                NSDate *dt2 = [formatter dateFromString:[_dictDynamicReport valueForKey:@"Due to be Served"]];
                [formatter setDateFormat:@"yyyyMMdd"];
                NSString *strDate = [formatter stringFromDate:dt2];
                
                NSString *strDays =[_dictDynamicReport valueForKey:@"Days since Weaned"];
                
                if (strDays.length==0) {
                    strDays = @"0";
                }
                
                [dict setValue:strDays forKey:@"DaysSinceWean"];
                [dict setValue:strDate forKey:@"DueToBeServed"];
            }else if ([_strEvent isEqualToString:@"11"]) {
                NSString *strDays =[_dictDynamicReport valueForKey:@"Days since Farrowed"];
                
                if (strDays.length==0) {
                    strDays = @"0";
                }
                
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MM/dd/yyyy"];
                NSDate *dt2 = [formatter dateFromString:[_dictDynamicReport valueForKey:@"Due to be Served"]];
                [formatter setDateFormat:@"yyyyMMdd"];
                NSString *strDate = [formatter stringFromDate:dt2];
                [dict setValue:strDays forKey:@"DaysSinceFarrow"];
                [dict setValue:strDate forKey:@"DueToBeWeaned"];
            }else if ([_strEvent isEqualToString:@"9"]) {
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MM/dd/yyyy"];
                NSDate *dt2 = [formatter dateFromString:[_dictDynamicReport valueForKey:@"Due to Farrow Start"]];
                NSDate *dt3 = [formatter dateFromString:[_dictDynamicReport valueForKey:@"Due to Farrow End"]];
                
                //
                NSComparisonResult result = [dt2 compare:dt3];
              
                if (result!= NSOrderedAscending && result!= NSOrderedSame) {
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:@"Please select Due to Farrow End Date greater than or equal to Due to Farrow Start Date."
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOk
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    
                    [myAlertController addAction:ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                    return;
                }
                
                [formatter setDateFormat:@"yyyyMMdd"];
                NSString *strStart = [formatter stringFromDate:dt2];
                NSString *strEnd = [formatter stringFromDate:dt3];
                
                [dict setValue:strStart forKey:@"DueToStartDate"];
                [dict setValue:strEnd forKey:@"DueToEndDate"];
                
                NSString *strDaysSinceServed = [_dictDynamicReport valueForKey:@"Days Since Served"];
                if ([strDaysSinceServed length]==0) {
                    [dict setValue:@"0" forKey:@"DaysSinceServed"];
                }else{
                    [dict setValue:[_dictDynamicReport valueForKey:@"Days Since Served"] forKey:@"DaysSinceServed"];
                }
                
                [dict setValue:[_dictDynamicReport valueForKey:@"Incl. Aborted"] forKey:@"IncAborted"];
                [dict setValue:[_dictDynamicReport valueForKey:@"Incl. Preg Test Neg/Open"] forKey:@"IncPregTest"];
            }else if ([_strEvent isEqualToString:@"6"]) {
                NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
                [formatter setDateFormat:@"MM/dd/yyyy"];
                NSDate *dt2 = [formatter dateFromString:[_dictDynamicReport valueForKey:@"Start Date"]];
                NSDate *dt3 =[NSDate date];
                
                NSDate *dt4 = [formatter dateFromString:[_dictDynamicReport valueForKey:@"End Date"]];
                
                //6 month validation as sandip told
                NSCalendar *gregorian = [[NSCalendar alloc]
                                         initWithCalendarIdentifier:NSGregorianCalendar];
                
                NSUInteger unitFlags = NSMonthCalendarUnit | NSDayCalendarUnit;
                
                NSDateComponents *components = [gregorian components:unitFlags
                                                            fromDate:dt2
                                                              toDate:dt4 options:0];
                NSInteger months = [components month];
                //
                
                //
                NSComparisonResult result = [dt2 compare:dt3];
                NSComparisonResult result2 = [dt2 compare:dt4];

                if (result!= NSOrderedAscending) {
                    
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:@"Please select Start Date less than or equal to current date."
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOk
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action){
                                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    
                    [myAlertController addAction:ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                    return;
                }
                
                if (result2!= NSOrderedAscending && result2!= NSOrderedSame) {
                    
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:@"Please select End Date greater than or equal Start Date."
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOk
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action){
                                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    
                    [myAlertController addAction:ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                    return;
                }
                
                if (months>5)
                {
                    UIAlertController *myAlertController = [UIAlertController alertControllerWithTitle:@"PigCHAMP"
                                                                                               message:@"Date range should be within 6 months."
                                                                                        preferredStyle:UIAlertControllerStyleAlert];
                    UIAlertAction* ok = [UIAlertAction
                                         actionWithTitle:strOk
                                         style:UIAlertActionStyleDefault
                                         handler:^(UIAlertAction * action) {
                                             [myAlertController dismissViewControllerAnimated:YES completion:nil];
                                         }];
                    
                    [myAlertController addAction:ok];
                    [self presentViewController:myAlertController animated:YES completion:nil];
                    return;
                }
                //
                
                [formatter setDateFormat:@"yyyyMMdd"];
                NSString *strStart = [formatter stringFromDate:dt2];
                NSString *strEnd = [formatter stringFromDate:dt4];
                
                [dict setValue:strStart forKey:@"StartDate"];
                [dict setValue:strEnd forKey:@"EndDate"];
                [dict setValue:[_dictDynamicReport valueForKey:@"Days After"] forKey:@"DaysAfter"];
                [dict setValue:[_dictDynamicReport valueForKey:@""] forKey:@"evtType"];
                
                //
                if ([[_dictDynamicReport valueForKey:@""] isEqualToString:@"Arrived"]) {
                    [dict setValue:[_dictDynamicReport valueForKey:@"Still Un-Served"] forKey:@"stillLact"];
                }else if ([[_dictDynamicReport valueForKey:@""] isEqualToString:@"Served"]) {
                    [dict setValue:[_dictDynamicReport valueForKey:@"Still In-Pig"] forKey:@"stillLact"];
                }else if ([[_dictDynamicReport valueForKey:@""] isEqualToString:@"Farrowed"]) {
                    [dict setValue:[_dictDynamicReport valueForKey:@"Still Lactating"] forKey:@"stillLact"];
                }else if ([[_dictDynamicReport valueForKey:@""] isEqualToString:@"Weaned"]) {
                    [dict setValue:[_dictDynamicReport valueForKey:@"Still Un-Served"] forKey:@"stillLact"];
                }
                //
                
               // [dict setValue:[_dictDynamicReport valueForKey:@"Still Lactating"] forKey:@"stillLact"];
            }
            
            //FirstReportViewController *firstReportViewController = [segue destinationViewController];
            firstReportViewController.dictHeaders = dict;
            firstReportViewController.strEvnt = _strEvent;
            firstReportViewController.strTitle = self.title;
            /******added by amit*******/
            firstReportViewController.strDateFormat=self.strDateFormat;
            /***************************/
            firstReportViewController.strActiveAnimalreportType = [_dictDynamicReport valueForKey:@"Status"];
            [self.navigationController pushViewController:firstReportViewController animated:YES];
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in btnRunReport_tapped=%@",exception.description);
    }
}

- (IBAction)btnDropDown_tapped:(id)sender {
    @try {
        [self.activeTextField resignFirstResponder];
        NSInteger prevSelectedIndex = 0;

        UITableViewCell* cell = (UITableViewCell*)[[sender superview] superview];
        NSIndexPath *indexPath = [self.tblReportsDynamic indexPathForCell:cell];
        NSDictionary *dict = [_arrDynamicReport objectAtIndex:indexPath.row];
        [_arrDropDownReport removeAllObjects];
        
        NSString *strPrevSelectedValue= [NSString stringWithFormat:@"%@",[_dictDynamicReport valueForKey:[dict valueForKey:@"visible"]]?[_dictDynamicReport valueForKey:[dict valueForKey:@"visible"]]:@""];

        if ([_strEvent isEqualToString:@"5"]) {

            NSArray *arr = [[NSArray alloc]initWithObjects:@"Any Active Status",@"Retained Gilt",@"Gilt Made Available",@"Maiden Gilt",@"Served (In-Pig)",@"Pregnancy Check Negative/Open",@"Aborted",@"Lactating",@"Lactating (Nurse)",@"Weaned/Dry",@"Working Boar",@"Unworked Boar", nil];
            
            for (int i =0; i<arr.count; i++) {
                NSDictionary *dict11 = [[NSMutableDictionary alloc]init];
                [dict11 setValue:[arr objectAtIndex:i] forKey:@"visible"];
                  [_arrDropDownReport addObject:dict11];
                
                if (strPrevSelectedValue.length>0) {
                    if ([strPrevSelectedValue isEqualToString:[arr objectAtIndex:i]]){
                        prevSelectedIndex = i;
                    }
                }
            }
        }else if ([_strEvent isEqualToString:@"6"] && indexPath.row==3){
            NSArray *arr = [[NSArray alloc]initWithObjects:@"Arrived",@"Served",@"Farrowed",@"Weaned", nil];
            for (int i =0; i<arr.count; i++) {
                NSDictionary *dict11 = [[NSMutableDictionary alloc]init];
                [dict11 setValue:[arr objectAtIndex:i] forKey:@"visible"];
                [_arrDropDownReport addObject:dict11];
                
                if (strPrevSelectedValue.length>0){
                    if ([strPrevSelectedValue isEqualToString:[arr objectAtIndex:i]]){
                        prevSelectedIndex = i;
                    }
                }
            }
        }
        else {
            NSDictionary *dict1 = [[NSMutableDictionary alloc]init];
            [dict1 setValue:strNo forKey:@"visible"];
            [_arrDropDownReport addObject:dict1];
            
            if (strPrevSelectedValue.length>0){
                if ([strPrevSelectedValue isEqualToString:strNo]){
                    prevSelectedIndex = 0;
                }
            }
            
            NSDictionary *dict11 = [[NSMutableDictionary alloc]init];
            [dict11 setValue:strYes forKey:@"visible"];
            [_arrDropDownReport addObject:dict11];
            if (strPrevSelectedValue.length>0){
                if ([strPrevSelectedValue isEqualToString:strYes]){
                    prevSelectedIndex = 1;
                }
            }
        }
        
        NSLog(@"_arrDropDownReport=%@",_arrDropDownReport);
        
        self.pickerDropDownReport = [[UIPickerView alloc] initWithFrame:CGRectMake(15, 10, 270, 150.0)];
        [self.pickerDropDownReport setDelegate:self];
       // self.pickerDropDownReport.showsSelectionIndicator = YES;
        [self.pickerDropDownReport setShowsSelectionIndicator:YES];

        _alertForDropDown = [[CustomIOS7AlertView alloc] init];
        [_alertForDropDown setMyDelegate:self];
        [_alertForDropDown setUseMotionEffects:true];
        [_alertForDropDown setButtonTitles:[NSMutableArray arrayWithObjects:strOk,strCancel, nil]];
        
        __weak typeof(self) weakSelf = self;
        [_alertForDropDown setOnButtonTouchUpInside:^(CustomIOS7AlertView *alertView, int buttonIndex) {
            
            if(buttonIndex == 0 && weakSelf.pickerDropDownReport>0){
                NSInteger row = [weakSelf.pickerDropDownReport selectedRowInComponent:0];
                NSDictionary *dict = [weakSelf.arrDynamicReport objectAtIndex:indexPath.row];
                [weakSelf.dictDynamicReport setValue:[[weakSelf.arrDropDownReport objectAtIndex:row] valueForKey:@"visible"] forKey:[dict valueForKey:@"visible"]];

                if ([_strEvent isEqualToString:@"6"] && indexPath.row==3) {
                    //NSLog(@"row=%d",row);
                    
                    NSDictionary *dict = [weakSelf.arrDynamicReport objectAtIndex:indexPath.row+1];
                    //NSLog(@"_dictDynamicReport=%@",weakSelf.dictDynamicReport);
                    
                    NSString *pre = [weakSelf.dictDynamicReport valueForKey:[dict valueForKey:@"visible"]];
                    
                    if (row==0) {
                        [dict setValue:@"Still Un-Served" forKey:@"visible"];
                    }else if (row==1) {
                        [dict setValue:@"Still In-Pig" forKey:@"visible"];
                    }else if (row==2) {
                        [dict setValue:@"Still Lactating" forKey:@"visible"];
                    }else if (row==3) {
                        [dict setValue:@"Still Un-Served" forKey:@"visible"];
                    }
                    
                    [weakSelf.dictDynamicReport setValue:pre forKey:[dict valueForKey:@"visible"]];
                }else if ([_strEvent isEqualToString:@"5"] ) {
                    
                    NSArray *arrConstant = [[NSArray alloc]initWithObjects:@"",@"stRetainedGilt",@"stAvailableGilt",@"stMaidenGilt",@"stInPig",@"stPregCheckNeg",@"stAborted",@"stLactating",@"stLactatingNurse",@"stDry",@"stWorkingBoar",@"stUnworkedBoar", nil];
                    _strActiveAnimalReportType = [arrConstant objectAtIndex:row];
                }
                
                [weakSelf.tblReportsDynamic reloadData];
            }
            
            [weakSelf.alertForPickUpDateReport close];
        }];
        
        if (_arrDropDownReport.count>0) {
            [weakSelf.alertForDropDown showCustomwithView:self.pickerDropDownReport title:[dict valueForKey:@"visible"]?[dict valueForKey:@"visible"]:@""];
        }
        else {
            NSLog(@"no data");
        }
        
      [weakSelf.pickerDropDownReport selectRow:prevSelectedIndex inComponent:0 animated:NO];
        [self.pickerDropDownReport setShowsSelectionIndicator:YES];

    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in btnDropDown_tapped =%@",exception.description);
    }
}

#pragma mark -Textfield custom methods
- (void)registerForKeyboardNotifications
{
    @try {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWasShown:)
                                                     name:UIKeyboardDidShowNotification
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(keyboardWillHide:)
                                                     name:UIKeyboardWillHideNotification
                                                   object:nil];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in registerForKeyboardNotifications = %@",exception.description);
    }
}

- (void)keyboardWasShown:(NSNotification*)aNotification{
    @try {
        NSDictionary *info = [aNotification userInfo];
        CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
        
        UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
        self.tblReportsDynamic.contentInset = contentInsets;
        _tblReportsDynamic.scrollIndicatorInsets = contentInsets;
        
        CGRect aRect = self.view.frame;
        aRect.size.height -= kbSize.height;
        
        if (!CGRectContainsPoint(aRect, self.activeTextField.frame.origin) ) {
            [self.tblReportsDynamic scrollRectToVisible:CGRectMake(self.activeTextField.frame.origin.x, self.activeTextField.frame.origin.y, self.activeTextField.frame.size.width, self.activeTextField.frame.size.height) animated:YES];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in keyboardWasShown in ViewController =%@",exception.description);
    }
}

- (void) keyboardWillHide:(NSNotification *)notification {
    @try {
        UIEdgeInsets contentInsets = UIEdgeInsetsZero;
        self.tblReportsDynamic.contentInset = contentInsets;
        self.tblReportsDynamic.scrollIndicatorInsets = contentInsets;
    }
    @catch (NSException *exception) {
        NSLog(@"Exception  in keyboardWillHide in ViewController =%@",exception.description);
    }
}

-(void)createDynamicGUIWithDefaultValues {
    @try {
        _dictDynamicReport = [[NSMutableDictionary alloc]init];
        _dictJsonReport= [[NSMutableDictionary alloc]init];

        NSMutableDictionary *dictMenu = [[NSMutableDictionary alloc]init];
        NSDictionary *dict;// = [[NSMutableDictionary alloc]init];
        
        NSMutableArray *arrTemp =[[NSMutableArray alloc]init];//3,5
        self.title = _strSubMenu;
        
        if ([_strEvent isEqualToString:@"2"]) {
            
            NSDateFormatter *dateFormatterr = [[NSDateFormatter alloc]init] ;
            [dateFormatterr setDateFormat:@"MM/dd/yyyy"];
            NSString *strSelectedDate = [dateFormatterr stringFromDate:[NSDate date]];
        
            [arrTemp addObject:@"Date From"];
            [arrTemp addObject:@"Date To"];
            
            NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:arrTemp];
            
            //if (resultArray1.count!=0)
            {
                for (int i=0; i<resultArray1.count; i++){
                    [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                }
                
                [_arrDynamicReport removeAllObjects];
                
                for (int i=0; i<2; i++){
                    dict = [[NSMutableDictionary alloc]init];
                    if (i==0) {
                        if ([dictMenu objectForKey:[@"Date From" uppercaseString]] && ![[dictMenu objectForKey:[@"Date From" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Date From" uppercaseString]]?[dictMenu objectForKey:[@"Date From" uppercaseString]]:@"" englishVersion:@"Date From" dataType:@"Date" defaultVal:strSelectedDate];
                        }
                        else{
                            [dict setValue:@"Date" forKey:@"dataType"];
                            [dict setValue:@"Date From" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:strSelectedDate forKey:@"Date From"];
                            [_dictJsonReport setValue:[self set1000Date:strSelectedDate] forKey:@"Date From"];
                        }
                    }else  if (i==1){
                        if ([dictMenu objectForKey:[@"Date To" uppercaseString]] && ![[dictMenu objectForKey:[@"Date To" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Date To" uppercaseString]]?[dictMenu objectForKey:[@"Date To"uppercaseString]]:@"" englishVersion:@"Date To" dataType:@"Date" defaultVal:strSelectedDate];
                        }
                        else {
                            [dict setValue:@"Date" forKey:@"dataType"];
                            [dict setValue:@"Date To" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:strSelectedDate forKey:@"Date To"];
                            [_dictJsonReport setValue:[self set1000Date:strSelectedDate] forKey:@"Date To"];
                        }
                    }
                }
            }
        }else if ([_strEvent isEqualToString:@"3"]) {
            [arrTemp addObject:@"Identity"];
            
            NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:arrTemp];
            
            //if (resultArray1.count!=0)
            {
                for (int i=0; i<resultArray1.count; i++){
                    [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                }
                
                [_arrDynamicReport removeAllObjects];
                
                for (int i=0; i<1; i++){
                    dict = [[NSMutableDictionary alloc]init];
                    if (i==0) {
                        if ([dictMenu objectForKey:[@"Identity" uppercaseString]] && ![[dictMenu objectForKey:[@"Identity" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Identity" uppercaseString]]?[dictMenu objectForKey:[@"Identity" uppercaseString]]:@"" englishVersion:@"Identity"  dataType:@"IR" defaultVal:@""];
                        }
                        else{
                            [dict setValue:@"IR" forKey:@"dataType"];
                            [dict setValue:@"Identity" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:@"" forKey:@"Identity"];
                        }
                    }
                }
            }
        }else if ([_strEvent isEqualToString:@"5"]){
            [arrTemp addObject:@"Status"];
            
            NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:arrTemp];
            //if (resultArray1.count!=0)
            {
                for (int i=0; i<resultArray1.count; i++){
                    [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                }
                
                [_arrDynamicReport removeAllObjects];
                
                for (int i=0; i<1; i++){
                    dict = [[NSMutableDictionary alloc]init];
                    if (i==0) {
                        if ([dictMenu objectForKey:[@"Status" uppercaseString]] && ![[dictMenu objectForKey:[@"Status" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Status" uppercaseString]]?[dictMenu objectForKey:[@"Status" uppercaseString]]:@"" englishVersion:@"Status" dataType:@"DropDown" defaultVal:@"Any Active Status"];
                        }
                        else{
                            [dict setValue:@"DropDown" forKey:@"dataType"];
                            [dict setValue:@"Status" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:@"Any Active Status" forKey:@"Status"];
                        }
                    }
                }
            }
        }else if ([_strEvent isEqualToString:@"6"]){
            //
            NSDateFormatter *dateFormatterr = [[NSDateFormatter alloc]init] ;
            [dateFormatterr setDateFormat:@"MM/dd/yyyy"];
            NSString *strSelectedDate = [dateFormatterr stringFromDate:[NSDate date]];
            
            [arrTemp removeAllObjects];
            [arrTemp addObject:@"Start Date"];
            [arrTemp addObject:@"End Date"];
            [arrTemp addObject:@"Days After"];
            [arrTemp addObject:@""];
            [arrTemp addObject:@"Still Lactating"];
            
            NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:arrTemp];
            //if (resultArray1.count!=0)
            {
                for (int i=0; i<resultArray1.count; i++){
                    [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                }
                
                [_arrDynamicReport removeAllObjects];
                
                for (int i=0; i<5; i++) {
                    dict = [[NSMutableDictionary alloc]init];
                    
                    if (i==0) {
                        if ([dictMenu objectForKey:[@"Start Date" uppercaseString]] && ![[dictMenu objectForKey:[@"Start Date" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Start Date" uppercaseString]]?[dictMenu objectForKey:[@"Start Date" uppercaseString]]:@"" englishVersion:@"Start Date" dataType:@"Date" defaultVal:strSelectedDate];
                        }
                        else{
                            [dict setValue:@"Date" forKey:@"dataType"];
                            [dict setValue:@"Start Date" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:strSelectedDate forKey:@"Start Date"];
                            [_dictJsonReport setValue:[self set1000Date:strSelectedDate] forKey:@"Start Date"];
                        }
                    }else  if (i==1){
                        if ([dictMenu objectForKey:[@"End Date" uppercaseString]] && ![[dictMenu objectForKey:[@"End Date" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"End Date" uppercaseString]]?[dictMenu objectForKey:[@"End Date" uppercaseString]]:@"" englishVersion:@"End Date" dataType:@"Date" defaultVal:strSelectedDate];
                        }
                        else{
                            [dict setValue:@"Date" forKey:@"dataType"];
                            [dict setValue:@"End Date" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:strSelectedDate forKey:@"End Date"];
                            [_dictJsonReport setValue:[self set1000Date:strSelectedDate] forKey:@"End Date"];
                        }
                    }else  if (i==2){
                        if ([dictMenu objectForKey:[@"Days After" uppercaseString]] && ![[dictMenu objectForKey:[@"Days After" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Days After" uppercaseString]]?[dictMenu objectForKey:[@"Days After" uppercaseString]]:@"" englishVersion:@"Days After" dataType:@"Text" defaultVal:@"7"];
                        }
                        else{
                            [dict setValue:@"Text" forKey:@"dataType"];
                            [dict setValue:@"Days After" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:@"7" forKey:@"Days After"];
                        }
                    }else  if (i==3){
                        if ([dictMenu objectForKey:[@"" uppercaseString]] && ![[dictMenu objectForKey:[@"" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"" uppercaseString]] englishVersion:@"" dataType:@"DropDown" defaultVal:@"Farrowed"];
                        }
                        else{
                            [dict setValue:@"DropDown" forKey:@"dataType"];
                            [dict setValue:@"" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:@"Farrowed" forKey:@""];
                            
                        }
                    }else  if (i==4){
                        if ([dictMenu objectForKey:[@"Still Lactating" uppercaseString]] && ![[dictMenu objectForKey:[@"Still Lactating" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Still Lactating" uppercaseString]]?[dictMenu objectForKey:[@"Still Lactating" uppercaseString]]:@"" englishVersion:@"Still Lactating" dataType:@"DropDown" defaultVal:@"No"];
                        }
                        else{
                            [dict setValue:@"DropDown" forKey:@"dataType"];
                            [dict setValue:@"Still Lactating" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:@"No" forKey:@"Still Lactating"];
                        }
                    }
                }
            }
        }else if ([_strEvent isEqualToString:@"7"]){
            
            [arrTemp removeAllObjects];
            [arrTemp addObject:@"Gilts"];
            [arrTemp addObject:@"Weaned Sows"];
            [arrTemp addObject:@"Aborted Sows"];
            [arrTemp addObject:@"Pregnancy Check Negative/Open"];
            
            //
            NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:arrTemp];
            
            //if (resultArray1.count!=0)
            {
                for (int i=0; i<resultArray1.count; i++){
                    [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                }
                
                [_arrDynamicReport removeAllObjects];
                
                for (int i=0; i<5; i++) {
                    
                    dict = [[NSMutableDictionary alloc]init];
                    if (i==0) {
                        if ([dictMenu objectForKey:[@"Gilts" uppercaseString]] && ![[dictMenu objectForKey:[@"Gilts" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Gilts" uppercaseString]]?[dictMenu objectForKey:[@"Gilts" uppercaseString]]:@"" englishVersion:@"Gilts" dataType:@"DropDown" defaultVal:@"Yes"];
                        }
                        else{
                            [dict setValue:@"DropDown" forKey:@"dataType"];
                            [dict setValue:@"Gilts" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:@"Yes" forKey:@"Gilts"];
                        }
                    }else  if (i==1){
                        if ([dictMenu objectForKey:[@"Weaned Sows" uppercaseString]] && ![[dictMenu objectForKey:[@"Weaned Sows" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Weaned Sows" uppercaseString]]?[dictMenu objectForKey:[@"Weaned Sows" uppercaseString]]:@"" englishVersion:@"Weaned Sows" dataType:@"DropDown" defaultVal:@"Yes"];
                        }
                        else{
                            [dict setValue:@"DropDown" forKey:@"dataType"];
                            [dict setValue:@"Weaned Sows" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:@"Yes" forKey:@"Weaned Sows"];
                        }
                    }else  if (i==2){
                        if ([dictMenu objectForKey:[@"Aborted Sows" uppercaseString]] && ![[dictMenu objectForKey:[@"Aborted Sows" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Aborted Sows" uppercaseString]]?[dictMenu objectForKey:[@"Aborted Sows" uppercaseString]]:@"" englishVersion:@"Aborted Sows" dataType:@"DropDown" defaultVal:@"Yes"];
                        }
                        else{
                            [dict setValue:@"DropDown" forKey:@"dataType"];
                            [dict setValue:@"Aborted Sows" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:@"Yes" forKey:@"Aborted Sows"];
                        }
                    }else  if (i==3) {
                        if ([dictMenu objectForKey:[@"Pregnancy Check Negative/Open" uppercaseString]] && ![[dictMenu objectForKey:[@"Pregnancy Check Negative/Open" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Pregnancy Check Negative/Open" uppercaseString]]?[dictMenu objectForKey:[@"Pregnancy Check Negative/Open" uppercaseString]]:@"" englishVersion:@"Pregnancy Check Negative/Open" dataType:@"DropDown" defaultVal:@"Yes"];
                        }
                        else{
                            [dict setValue:@"DropDown" forKey:@"dataType"];
                            [dict setValue:@"Pregnancy Check Negative/Open" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:@"Yes" forKey:@"Pregnancy Check Negative/Open"];
                        }
                    }
                }
            }
        }else if ([_strEvent isEqualToString:@"8"]){
            [arrTemp removeAllObjects];
            [arrTemp addObject:@"Include Retained Gilts"];
            [arrTemp addObject:@"Acclimatization Period"];
            [arrTemp addObject:@"Overdue for Service"];
            
            NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:arrTemp];
            //if (resultArray1.count!=0)
            {
                
                for (int i=0; i<resultArray1.count; i++){
                    [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                }
                [_arrDynamicReport removeAllObjects];
                
                for (int i=0; i<3; i++) {
                    dict = [[NSMutableDictionary alloc]init];
                    
                    if (i==0) {
                        if ([dictMenu objectForKey:[@"Include Retained Gilts" uppercaseString]] && ![[dictMenu objectForKey:[@"Include Retained Gilts" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Include Retained Gilts" uppercaseString]]?[dictMenu objectForKey:[@"Include Retained Gilts" uppercaseString]]:@"" englishVersion:@"Include Retained Gilts" dataType:@"DropDown" defaultVal:@"Yes"];
                        }
                        else{
                            [dict setValue:@"DropDown" forKey:@"dataType"];
                            [dict setValue:@"Include Retained Gilts" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:@"Yes" forKey:@"Include Retained Gilts"];
                        }
                    }else  if (i==1){
                        if ([dictMenu objectForKey:[@"Acclimatization Period" uppercaseString]] && ![[dictMenu objectForKey:[@"Acclimatization Period" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:@"Acclimatization Period"]?[dictMenu objectForKey:@"Acclimatization Period"]:@"" englishVersion:@"Acclimatization Period" dataType:@"Text" defaultVal:@"21"];
                        }
                        else {
                            [dict setValue:@"Text" forKey:@"dataType"];
                            [dict setValue:@"Acclimatization Period" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:@"21" forKey:@"Acclimatization Period"];
                        }
                    }else  if (i==2) {
                        if ([dictMenu objectForKey:[@"Overdue for Service" uppercaseString]] && ![[dictMenu objectForKey:[@"Overdue for Service" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Overdue for Service" uppercaseString]]?[dictMenu objectForKey:[@"Overdue for Service" uppercaseString]]:@"" englishVersion:@"Overdue for Service" dataType:@"Text" defaultVal:@"60"];
                        }
                        else {
                            [dict setValue:@"Text" forKey:@"dataType"];
                            [dict setValue:@"Overdue for Service" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:@"60" forKey:@"Overdue for Service"];
                        }
                    }
                }
            }
        }else if ([_strEvent isEqualToString:@"9"]){
            NSDateFormatter *dateFormatterr = [[NSDateFormatter alloc]init] ;
            [dateFormatterr setDateFormat:@"MM/dd/yyyy"];
            NSString *strSelectedDate = [dateFormatterr stringFromDate:[NSDate date]];
            
            NSDate *now = [NSDate date];
            int daysToAdd = 6;
            NSDate *newDate1 = [now dateByAddingTimeInterval:60*60*24*daysToAdd];
            NSString *strEndDate = [dateFormatterr stringFromDate:newDate1];
            
            [arrTemp removeAllObjects];
            [arrTemp addObject:@"Due to Farrow Start"];
            [arrTemp addObject:@"Due to Farrow End"];
            [arrTemp addObject:@"Days Since Served"];
            [arrTemp addObject:@"Incl. Aborted"];
            [arrTemp addObject:@"Incl. Preg Test Neg/Open"];
            
            NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:arrTemp];
            //if (resultArray1.count!=0)
            {
                for (int i=0; i<resultArray1.count; i++) {
                    [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                }
                
                [_arrDynamicReport removeAllObjects];
                
                for (int i=0; i<5; i++) {
                    dict = [[NSMutableDictionary alloc]init];
                    
                    if (i==0) {
                        if ([dictMenu objectForKey:[@"Due to Farrow Start" uppercaseString]] && ![[dictMenu objectForKey:[@"Due to Farrow Start" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Due to Farrow Start" uppercaseString]]?[dictMenu objectForKey:[@"Due to Farrow Start" uppercaseString]]:@"" englishVersion:@"Due to Farrow Start" dataType:@"Date" defaultVal:strSelectedDate];
                        }
                        else {
                            [dict setValue:@"Date" forKey:@"dataType"];
                            [dict setValue:@"Due to Farrow Start" forKey:@"visible"];

                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:strSelectedDate forKey:@"Due to Farrow Start"];
                            [_dictJsonReport setValue:[self set1000Date:strSelectedDate] forKey:@"Due to Farrow Start"];
                        }
                    }else  if (i==1) {
                        if ([dictMenu objectForKey:[@"Due to Farrow End" uppercaseString]] && ![[dictMenu objectForKey:[@"Due to Farrow End" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Due to Farrow End" uppercaseString]]?[dictMenu objectForKey:[@"Due to Farrow End" uppercaseString]]:@"" englishVersion:@"Due to Farrow End"dataType:@"Date" defaultVal:strSelectedDate];
                        }
                        else {
                            [dict setValue:@"Date" forKey:@"dataType"];
                            [dict setValue:@"Due to Farrow End" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:strEndDate forKey:@"Due to Farrow End"];
                            [_dictJsonReport setValue:[self set1000Date:strEndDate] forKey:@"Due to Farrow End"];
                        }
                    }else  if (i==2) {
                        if ([dictMenu objectForKey:[@"Days Since Served" uppercaseString]] && ![[dictMenu objectForKey:[@"Days Since Served" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Days Since Served" uppercaseString]]?[dictMenu objectForKey:[@"Days Since Served" uppercaseString]]:@"" englishVersion:@"Days Since Served" dataType:@"Text" defaultVal:@"115"];
                        }
                        else {
                            [dict setValue:@"Text" forKey:@"dataType"];
                            [dict setValue:@"Days Since Served" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:@"115" forKey:@"Days Since Served"];
                        }
                    }else  if (i==3) {
                        if ([dictMenu objectForKey:[@"Incl. Aborted" uppercaseString]] && ![[dictMenu objectForKey:[@"Incl. Aborted" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Incl. Aborted" uppercaseString]]?[dictMenu objectForKey:[@"Incl. Aborted" uppercaseString]]:@"" englishVersion:@"Incl. Aborted" dataType:@"DropDown" defaultVal:@"Yes"];
                        }
                        else {
                            [dict setValue:@"DropDown" forKey:@"dataType"];
                            [dict setValue:@"Incl. Aborted" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:@"Yes" forKey:@"Incl. Aborted"];
                        }
                    }else  if (i==4){
                        if ([dictMenu objectForKey:[@"Incl. Preg Test Neg/Open" uppercaseString]] && ![[dictMenu objectForKey:[@"Incl. Preg Test Neg/Open" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Incl. Preg Test Neg/Open" uppercaseString]]?[dictMenu objectForKey:[@"Incl. Preg Test Neg/Open" uppercaseString]]:@"" englishVersion:@"Incl. Preg Test Neg/Open" dataType:@"DropDown" defaultVal:@"Yes"];
                        }
                        else {
                            [dict setValue:@"DropDown" forKey:@"dataType"];
                            [dict setValue:@"Incl. Preg Test Neg/Open" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:@"Yes" forKey:@"Incl. Preg Test Neg/Open"];
                        }
                    }
                }
            }
        }else if ([_strEvent isEqualToString:@"10"]) {
            NSDateFormatter *dateFormatterr = [[NSDateFormatter alloc]init] ;
            [dateFormatterr setDateFormat:@"MM/dd/yyyy"];
            NSString *strSelectedDate = [dateFormatterr stringFromDate:[NSDate date]];
            
            dict = [[NSMutableDictionary alloc]init];
            [arrTemp removeAllObjects];
            [arrTemp addObject:@"Due to be Served"];
            [arrTemp addObject:@"Days since Weaned"];
            
            NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:arrTemp];
            //if (resultArray1.count!=0)
            {
                for (int i=0; i<resultArray1.count; i++) {
                    [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                }
                
                [_arrDynamicReport removeAllObjects];
                
                for (int i=0; i<2; i++) {
                    dict = [[NSMutableDictionary alloc]init];
                    
                    if (i==0) {
                        if ([dictMenu objectForKey:[@"Due to be Served" uppercaseString]] && ![[dictMenu objectForKey:[@"Due to be Served" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Due to be Served" uppercaseString]]?[dictMenu objectForKey:[@"Due to be Served" uppercaseString]]:@"" englishVersion:@"Due to be Served" dataType:@"Date" defaultVal:strSelectedDate];
                        }
                        else {
                            [dict setValue:@"Date" forKey:@"dataType"];
                            [dict setValue:@"Due to be Served" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:strSelectedDate forKey:@"Due to be Served"];
                            [_dictJsonReport setValue:[self set1000Date:strSelectedDate] forKey:@"Due to be Served"];
                        }
                    }else  if (i==1) {
                        if ([dictMenu objectForKey:[@"Days since Weaned" uppercaseString]] && ![[dictMenu objectForKey:[@"Days since Weaned" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Days since Weaned" uppercaseString]]?[dictMenu objectForKey:[@"Days since Weaned" uppercaseString]]:@"" englishVersion:@"Days since Weaned" dataType:@"Text" defaultVal:@"5"];
                        }
                        else {
                            [dict setValue:@"Text" forKey:@"dataType"];
                            [dict setValue:@"Days since Weaned" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:@"5" forKey:@"Days since Weaned"];
                        }
                    }
                }
            }
        }else if ([_strEvent isEqualToString:@"11"]) {
            NSDateFormatter *dateFormatterr = [[NSDateFormatter alloc]init] ;
            [dateFormatterr setDateFormat:@"MM/dd/yyyy"];
            NSString *strSelectedDate = [dateFormatterr stringFromDate:[NSDate date]];
            
            //
            //            {
            //                [dateFormatterr setDateFormat:@"YYYYMMdd"];
            //                NSString *strSelectedDatee = [dateFormatterr stringFromDate:[NSDate date]];
            //                [dictJson setValue:strSelectedDatee forKey:[dict valueForKey:@"data_item_key"]];
            //            }
            //
            
            
            dict = [[NSMutableDictionary alloc]init];
            [arrTemp removeAllObjects];
            [arrTemp addObject:@"Due to be Weaned"];
            [arrTemp addObject:@"Days since Farrowed"];
            
            NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:arrTemp];
            // if (resultArray1.count!=0)
            {
                for (int i=0; i<resultArray1.count; i++){
                    [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                }
                
                [_arrDynamicReport removeAllObjects];
                
                for (int i=0; i<2; i++) {
                    dict = [[NSMutableDictionary alloc]init];
                    
                    if (i==0) {
                        if ([dictMenu objectForKey:[@"Due to be Served" uppercaseString]] && ![[dictMenu objectForKey:[@"Due to be Served" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Due to be Served" uppercaseString]]?[dictMenu objectForKey:[@"Due to be Served" uppercaseString]]:@"" englishVersion:@"Due to be Served" dataType:@"Date" defaultVal:strSelectedDate];
                        }
                        else{
                            [dict setValue:@"Date" forKey:@"dataType"];
                            [dict setValue:@"Due to be Served" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:strSelectedDate forKey:@"Due to be Served"];
                            [_dictJsonReport setValue:[self set1000Date:strSelectedDate] forKey:@"Due to be Served"];
                        }
                    }else  if (i==1){
                        if ([dictMenu objectForKey:[@"Days since Farrowed" uppercaseString]] && ![[dictMenu objectForKey:[@"Days since Farrowed" uppercaseString]] isKindOfClass:[NSNull class]]) {
                            [self addObject:[dictMenu objectForKey:[@"Days since Farrowed" uppercaseString]]?[dictMenu objectForKey:[@"Days since Farrowed" uppercaseString]]:@"" englishVersion:@"Days since Farrowed" dataType:@"Text" defaultVal:@"21"];
                        }
                        else{
                            [dict setValue:@"Text" forKey:@"dataType"];
                            [dict setValue:@"Days since Farrowed" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                            [_dictDynamicReport setValue:@"21" forKey:@"Days since Farrowed"];
                        }
                    }
                }
            }
        }else if ([_strEvent isEqualToString:@"12"]) {
            dict = [[NSMutableDictionary alloc]init];
            [arrTemp removeAllObjects];
            [arrTemp addObject:@"Due to Farrow"];
            [arrTemp addObject:@"Days Since Served"];
            
            NSArray* resultArray1 = [[CoreDataHandler sharedHandler] getTranslatedText:arrTemp];
            // if (resultArray1.count!=0)
            {
                for (int i=0; i<resultArray1.count; i++){
                    [dictMenu setObject:[[resultArray1 objectAtIndex:i]valueForKey:@"translatedText"] forKey:[[[resultArray1 objectAtIndex:i]valueForKey:@"englishText"] uppercaseString]];
                }
                
                [_arrDynamicReport removeAllObjects];
                
                for (int i=0; i<2; i++) {
                    dict = [[NSMutableDictionary alloc]init];
                    
                    if (i==0) {
                        if ([dictMenu objectForKey:[@"Due to Farrow" uppercaseString]] && ![[dictMenu objectForKey:[@"Due to Farrow" uppercaseString]] isKindOfClass:[NSNull class]]){
                            [self addObject:[dictMenu objectForKey:[@"Due to Farrow" uppercaseString]]?[dictMenu objectForKey:[@"Due to Farrow" uppercaseString]]:@"" englishVersion:@"Due to Farrow" dataType:@"Date" defaultVal:@""];
                        }
                        else{
                            [dict setValue:@"Date" forKey:@"dataType"];
                            [dict setValue:@"Due to Farrow" forKey:@"visible"];
                            
                            [_arrDynamicReport addObject:dict];
                        }
                    }else  if (i==1){
                        if ([dictMenu objectForKey:[@"Days Since Served" uppercaseString]] && ![[dictMenu objectForKey:[@"Days Since Served" uppercaseString]] isKindOfClass:[NSNull class]]){
                            [self addObject:[dictMenu objectForKey:[@"Days Since Served" uppercaseString]]?[dictMenu objectForKey:[@"Days Since Served" uppercaseString]]:@"" englishVersion:@"Days Since Served" dataType:@"Text" defaultVal:@""];
                        }
                        else{
                            [dict setValue:@"Text" forKey:@"dataType"];
                            [dict setValue:@"Days Since Served" forKey:@"visible"];
                            [_arrDynamicReport addObject:dict];
                        }
                    }
                }
            }
        }
        
        //
        //        for (NSMutableDictionary *dict  in _arrDynamicReport){
        //            [_dictDynamicReport setValue:@"" forKey:[dict valueForKey:@"visible"]];
        //        }
        NSLog(@"_dictDynamicReport=%@",_dictDynamicReport);
        //
        
        [self.tblReportsDynamic reloadData];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in createDynamicGUIWithDefaultValues=%@",exception.description);
    }
}

- (IBAction)btnSnner_tapped:(id)sender {
    @try {
        barcodeScannerViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"segueBarcode"];
        barcodeScannerViewController.delegate = self;
        [self.navigationController pushViewController:barcodeScannerViewController animated:NO];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in btnSnnerType_tapped=%@",exception.description);
    }
}

-(void)scannedBarcode:(NSString *)barcode{
    @try {
        //self.txtIdentity.text =  barcode;
         [self.dictDynamicReport setValue:barcode forKey:@"Identity"];
        [self.tblReportsDynamic reloadData];
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in scannedBarcode=%@",exception.description);
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


-(NSString*)set1000Date:(NSString*)strSelectedDate{
    @try {
        NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
        [formatter setDateFormat:@"MM/dd/yyyy"];
        
        NSString *strBaseDate = [[NSUserDefaults standardUserDefaults] objectForKey:@"ZD"];
        if (isThousandFormatReport) {
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
            
            NSString *strSelectedDate100 = [[calFormat stringByAppendingString:@"\n"] stringByAppendingString:[formatter stringFromDate:dtselectedDate]];
            
            return strSelectedDate100;
        }else if([self.strDateFormat isEqualToString:@"6"]){
            	            [formatter setDateFormat:@"MM/dd/yyyy"];
            	            [formatter setTimeZone:[NSTimeZone timeZoneWithName:@"GMT"]];
            	            NSDate *dtselectedDate = [formatter dateFromString:strSelectedDate];
            	            NSDate *Firstdate= [self getFirstDateOfCurrentYear:dtselectedDate];
            
            	            // NSDate *BaseDate = [formatter dateFromString:strBaseDate];
            	            //int days = [dtselectedDate timeIntervalSinceDate:Firstdate]/24/60/60;
            	            // NSLog(@"days:%d",days);
            	            NSInteger days=[self daysBetweenDate:Firstdate andDate:dtselectedDate];
            	            NSLog(@"days:%ld",days);
            
            	            NSString *strDate = [NSString stringWithFormat:@"%03li",days];
            	            [formatter setDateFormat:@"yy"];
            
            	            NSString *strSelectedDateyearformat = [[[formatter stringFromDate:dtselectedDate] stringByAppendingString:@"-"] stringByAppendingString:strDate];
            
            /**********below code added by amit*********************************************/
            [formatter setDateFormat:@"EEE,dd-MMM-yyyy"];
            NSString *strSelectedDateDayOfyear = [[strSelectedDateyearformat stringByAppendingString:@"\n"] stringByAppendingString:[formatter stringFromDate:dtselectedDate]];
            
            return strSelectedDateDayOfyear;

            /********************************************************************************/
           // return strSelectedDateyearformat;
            
        }
        else {
            return strSelectedDate;
        }
        //
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception =%@",exception.description);
    }
}

@end
