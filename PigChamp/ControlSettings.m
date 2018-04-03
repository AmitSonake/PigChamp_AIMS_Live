//
//  ControlSettings.m
//  Classifields
//
//  Created by kishor Nimje on 25/11/14.
//  Copyright (c) 2014 VentureLabour. All rights reserved.
//

#import "ControlSettings.h"
static ControlSettings * settingsInstance = nil;


@implementation ControlSettings

+ (ControlSettings *) sharedSettings{
    
    @synchronized(self){
        
		if (settingsInstance == nil){
            
            settingsInstance = [[ControlSettings alloc] init];
            
		}
    }
    return settingsInstance;
}

#pragma mark Connectivity
// CHECK INTERNET CONNECTTION

-(BOOL)isNetConnected
{
    Reachability* reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
	NSParameterAssert([reachability isKindOfClass: [Reachability class]]);
    
	NetworkStatus netStatus = [reachability currentReachabilityStatus];
    if (netStatus == NotReachable)
    {
        return NO;
	}
    else
    {
        return YES;
    }

}

#pragma mark Dates


// get current date in MM/DD/YYYY

//-(NSString*)getDateinMMDDYY
//{
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setDateFormat:@"MM/dd/yyyy"];
//    
//    NSDate *now = [[NSDate alloc] init];
//    
//    NSString *dateString = [format stringFromDate:now];
//    
//    return dateString;
//    
//}

// get current date in DD/MM/YYYY


//-(NSString*)getDateinDDMMYY
//{
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    [format setDateFormat:@"dd/MM/yyyy"];
//    
//    NSDate *now = [[NSDate alloc] init];
//    
//    NSString *dateString = [format stringFromDate:now];
//    
//    return dateString;
//}


//-(NSString*)convertDateToSelectedFormat:(NSString*)dateToConvert
//{
//    NSString* convertedDate;
//    NSDateFormatter *format = [[NSDateFormatter alloc] init];
//    AppDelegate* appDelegate =  (AppDelegate*)[[UIApplication sharedApplication]delegate];
//    
//    if ([[appDelegate.preferences objectForKey:@"selectedDateFormat"] isEqualToString:@"DDMMYY"])
//    {
//        
//        [format setDateFormat:@"dd/MM/yyyy"];
//
//    }else
//    {
//        [format setDateFormat:@"MM/dd/yyyy"];
//
//    }
//    NSDate * date = [format dateFromString:dateToConvert];
//    convertedDate = [format stringFromDate:date];
//    
//    return convertedDate;
//}


#pragma mark Colors

- (UIColor *)colorWithHexString:(NSString *)stringToConvert
{
    NSString *noHashString = [stringToConvert stringByReplacingOccurrencesOfString:@"#" withString:@""]; // remove the #
    NSScanner *scanner = [NSScanner scannerWithString:noHashString];
    [scanner setCharactersToBeSkipped:[NSCharacterSet symbolCharacterSet]]; // remove + and $
    
    unsigned hex;
    if (![scanner scanHexInt:&hex]) return nil;
    int r = (hex >> 16) & 0xFF;
    int g = (hex >> 8) & 0xFF;
    int b = (hex) & 0xFF;
    
    return [UIColor colorWithRed:r / 255.0f green:g / 255.0f blue:b / 255.0f alpha:1.0f];
}

//-(void)showCheckInternetAlert
//{
//    //[self showAlertViewWithMessage:@"Please check your internet connection" andTitle:@"PigCHAMP"];
//}

#pragma mark Timer session

//the length of time before your application "times out". This number represents seconds, so we'll have to multiple it by 60
#define kApplicationTimeoutInMinutes 60
#define kApplicationDidTimeoutNotification @"sessionTimeOut"

// Session timer
//
-(void)resetTimer
{
    if (idleTimer)
    {
        [idleTimer invalidate];
    }
    //convert the wait period into minutes rather than seconds
    int timeout = kApplicationTimeoutInMinutes * 60;
    idleTimer = [NSTimer scheduledTimerWithTimeInterval:timeout target:self selector:@selector(idleTimerExceeded) userInfo:nil repeats:NO];

}

//
-(void)idleTimerExceeded
{
    [[NSNotificationCenter defaultCenter] postNotificationName:kApplicationDidTimeoutNotification object:nil];
}

@end
