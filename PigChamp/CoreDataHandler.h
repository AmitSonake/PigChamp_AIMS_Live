//
//  CoreDataHandler.h
//
//
//  Created by Mangesh Karekar.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.


#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

@interface CoreDataHandler : NSObject

+(CoreDataHandler*) sharedHandler;


#pragma mark Managed Object Functions

// this method return NSManagedObjectContext

// call this method as
// NSManagedObjectContext *moc = defaultManagedObjectContext();

-(NSManagedObjectContext*)defaultManagedObjectContext;


/// called to save / commit changes
// after every insert call this method...

-(BOOL)commitDefaultMOC;

/// to undo the changes...
-(void)rollbackDefaultMOC;

/// this method will remove all managed objects from persistentStorage

-(void)removeAllmanagedObject;

// call this method to delete the specified managed object from storage

-(void)deleteManagedObjectFromDefaultMOC:(NSManagedObject*)managedObject;



#pragma mark Insert Update Finctions

//// this method will insert all values in dictionary to managed object of type entityname.

// Method to INSERT data with entity name

/*
 
 
 this function inserts values to sqllite via core data
 
 Warning: this function assumes that the array passed to it is already validated for errors
 
 Requirements: 1. entityNames : table to be updated
 
 2. AttributeArray : array containing dictionaries which contain attributes as keys and data to be inserted as objects
 
 */


-(BOOL)insertManagedObjectsWithEntityName:(NSString*)entityName andAttributeArray:(NSArray*)attributeArray;

// Method to UPDATE data with entity name

/*
 this function updates sqllite entries via core data
 
 Warning: this function assumes that the array passed to it is already validated for errors
 
 Requirements: 1. entityName : table to be updated
 
 2. AttributeArray : array containing dictionaries which contain attributes as keys and data to be updated as objects
 
 */

-(BOOL)updateManagedObject:(NSString*)entityName andAttributeArray:(NSArray*)attributeArray;

//_LesionScoreArray; _LockArray _LeakageArray _QualityArray _StandingReflexArray _TestTypeArray

-(BOOL)insertBulkValuesWithCommonLookupArray:(NSArray*)commonLookupsArray andFarmsArray:(NSArray*)farmsArray andDataEntryArray:(NSArray*)dataEntryArray andGeneticsArray:(NSArray*)geneticsArray andUserParameters:(NSArray*)userParametersArray andLocations:(NSArray*)locationsArray andOperatorArray:(NSArray*)operatorArray andBreedingComapniesArray:(NSArray*)breedingCompaniesArray andCondistionsArray:(NSArray*)conditionsArray andFlagsArray:(NSArray*)flagsArray andTransportArray:(NSArray*)transportCompaniesArray andPackingPlantsArray:(NSArray*)packingPlantsArray andTreatmentsArray:(NSArray*)treatmentsArray andAdminRoutes:(NSArray*)adminRoutes andAiStuds:(NSArray*)aiStuds andHalothane:(NSArray*)halothane andPdResults:(NSArray*)pdresults andSex:(NSArray*)sex andTod:(NSArray*)tod andOrigin:(NSArray*)origin andDestination:(NSArray*)destination translated:(NSArray*)arrTrnaslated conditionScore:(NSArray*)conditionScore herdCategory:(NSArray*)herdCategory lesionScoreArray:(NSArray*)_LesionScoreArray lockArray:(NSArray*)lockArray leakageArray:(NSArray*)leakageArray qualityArray:(NSArray*)qualityArray standingReflexArray:(NSArray*)standingReflexArray testTypeArray:(NSArray*)testTypeArray;


#pragma mark Fetch Functions
-(NSArray*)getValuesToListWithEntityName:(NSString*)entityName andPredicate:(NSPredicate*)predicate andSortDescriptors:(NSArray*)sortDescriptors;

/// this method is used to get all Attributes of entity.

-(NSArray*)getAllAttributesForEntityName:(NSString*)entityName andManagedObjectContext:(NSManagedObjectContext*)moc;


//// this method will fetch all objects and returns count in NSinteger.


-(int)fetchCountForEntity:(NSString*)entityName;


#pragma mark Entity Delete functions

// this function will remove all entries from the specified entity name

-(void)RemoveEntriesFromEntities:(NSString*)entityName;

#pragma mark Validation Functions



// THIS FUNCTION WILL CHECK FOR ENTRIES IN EACH CORE DATA TABLE and return response

-(BOOL)checkCoreDataEntries;

// THIS FUNCTION WILL CHECK FOR ENTRIES IN PROVIDED ENTITY NAME and return response

-(BOOL)checkCoreDataEntriesInEntityAndPredicateForEntityName:(NSString*)entityName andPredicate:(NSPredicate*)predicate;

#pragma mark String functions

/// returns the String format for any type object

-(NSString*)returnStringValueWithString:(NSString*)valueString andEntity:(NSString*)entityName andKeyString:(id)keyString;

/// check if valueString is null or blank...
-(NSArray*)getTranslatedText:(NSMutableArray*)arrayOfIds;
-(NSString*)checkIfNull:(NSString*)stringToCheck;
//-(void)insertNewEntryForLanguage:(NSString*)english translated:(NSString*)translated;
-(void)deleteManagedObjectContexFromDefaultMOC:(NSString*)Context;
-(NSArray*)getValuesBarnRoomPen:(NSString*)entityName column:(NSString*)column andPredicate:(NSPredicate*)predicate andSortDescriptors:(NSArray*)sortDescriptors;
-(NSArray*)getTranslated:(NSMutableArray*)arrayOfIds;

@end
