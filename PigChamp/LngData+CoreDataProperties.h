//
//  LngData+CoreDataProperties.h
//  PigChamp
//
//  Created by Venturelabour on 26/10/15.
//  Copyright © 2015 Venturelabour. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "LngData.h"

NS_ASSUME_NONNULL_BEGIN

@interface LngData (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *englishText;
@property (nullable, nonatomic, retain) NSString *translatedText;

@end

NS_ASSUME_NONNULL_END
