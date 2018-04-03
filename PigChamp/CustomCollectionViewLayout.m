//
//  CustomCollectionViewLayout.m
//  Brightec
//
//  Created by JOSE MARTINEZ on 03/09/2014.
//  Copyright (c) 2014 Brightec. All rights reserved.
//

#import "CustomCollectionViewLayout.h"

#define NUMBEROFCOLUMNS 6

@interface CustomCollectionViewLayout ()
@property (strong, nonatomic) NSMutableArray *itemAttributes;
@property (strong, nonatomic) NSMutableArray *itemsSize;
@property (nonatomic, assign) CGSize contentSize;
@end

@implementation CustomCollectionViewLayout

- (void)resetLayout {
    [self invalidateLayout];
}

- (void)prepareLayout {
    @try {
        [super prepareLayout];
       
        [self.itemAttributes removeAllObjects];
        [self.itemsSize removeAllObjects];
        
        if ([self.collectionView numberOfSections] == 0) {
            [self.itemAttributes removeAllObjects];
            [self.itemsSize removeAllObjects];

            return;
        }
        
        NSUInteger column = 0; // Current column inside row
        CGFloat xOffset = 0.0;
        CGFloat yOffset = 0.0;
        CGFloat contentWidth = 0.0; // To determine the contentSize
        CGFloat contentHeight = 0.0; // To determine the contentSize
        
        if (self.itemAttributes.count > 0) { // We don't enter in this if statement the first time, we enter the following times
            for (int section = 0; section < [self.collectionView numberOfSections]; section++) {
                
                NSLog(@"section=%d",section);
                
                NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
                for (NSUInteger index = 0; index < numberOfItems; index++) {
                    if (section != 0 && index != 0) { // This is a content cell that shouldn't be sticked
                        continue;
                    }
                    
                   // UICollectionViewLayoutAttributes *attributes = [self layoutAttributesForItemAtIndexPath:[NSIndexPath indexPathForItem:index inSection:section]];
                    
//                    if (section == 0) { // We stick the first row
//                        CGRect frame = attributes.frame;
//                        frame.origin.y = self.collectionView.contentOffset.y;
//                        attributes.frame = frame;
//                    }
                }
            }
            
            return;
        }
        
        // The following code is only executed the first time we prepare the layout
        self.itemAttributes = [@[] mutableCopy];
        self.itemsSize = [@[] mutableCopy];
        
        // Tip: If we don't know the number of columns we can call the following method and use the NSUInteger object instead of the NUMBEROFCOLUMNS macro
        // NSUInteger numberOfItems = [self.collectionView numberOfItemsInSection:section];
        
        // We calculate the item size of each column
        if (self.itemsSize.count != NUMBEROFCOLUMNS) {
            [self calculateItemsSize];
        }
        
        
        // We loop through all items
        for (int section = 0; section < [self.collectionView numberOfSections]; section++) {
           
            
            NSMutableArray *sectionAttributes = [@[] mutableCopy];
            for (NSUInteger index = 0; index < NUMBEROFCOLUMNS; index++) {
                CGSize itemSize = [self.itemsSize[index] CGSizeValue];
                
                // We create the UICollectionViewLayoutAttributes object for each item and add it to our array.
                // We will use this later in layoutAttributesForItemAtIndexPath:
                NSIndexPath *indexPath = [NSIndexPath indexPathForItem:index inSection:section];
                UICollectionViewLayoutAttributes *attributes = [UICollectionViewLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
                attributes.frame = CGRectIntegral(CGRectMake(xOffset, yOffset, itemSize.width, itemSize.height));
                
                if (section == 0 && index == 0) {
                    attributes.zIndex = 1024; // Set this value for the first item (Sec0Row0) in order to make it visible over first column and first row
                } else if (section == 0 || index == 0) {
                    attributes.zIndex = 1023; // Set this value for the first row or section in order to set visible over the rest of the items
                }
                
                if (section == 0) {
                    CGRect frame = attributes.frame;
                    frame.origin.y = self.collectionView.contentOffset.y;
                    attributes.frame = frame; // Stick to the top
                }
                
//                if (index == 0) {
//                    CGRect frame = attributes.frame;
//                    frame.origin.x = self.collectionView.contentOffset.x;
//                    attributes.frame = frame; // Stick to the left
//                }
                
                [sectionAttributes addObject:attributes];
                
                xOffset = xOffset+itemSize.width;
                column++;
                
                // Create a new row if this was the last column
                if (column == NUMBEROFCOLUMNS) {
                    if (xOffset > contentWidth) {
                        contentWidth = xOffset;
                    }
                    
                    // Reset values
                    column = 0;
                    xOffset = 0;
                    yOffset += itemSize.height;
                }
            }
            
            [self.itemAttributes addObject:sectionAttributes];
        }
        
        // Get the last item to calculate the total height of the content
        UICollectionViewLayoutAttributes *attributes = [[self.itemAttributes lastObject] lastObject];
        contentHeight = attributes.frame.origin.y+attributes.frame.size.height;
        self.contentSize = CGSizeMake(contentWidth, contentHeight);
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in prepareLayout =%@",exception.description);
    }
}

- (CGSize)collectionViewContentSize{
    @try {
        return self.contentSize;
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in collectionViewContentSize=%@",exception.description);
    }
}

- (UICollectionViewLayoutAttributes *)layoutAttributesForItemAtIndexPath:(NSIndexPath *)indexPath{
    @try {
       // [super layoutAttributesForItemAtIndexPath:indexPath];
        return self.itemAttributes[indexPath.section][indexPath.row];
    }
    @catch (NSException *exception) {
        NSLog(@"Exception in layoutAttributesForItemAtIndexPath=%@",exception.description);
    }
}

- (NSArray *)layoutAttributesForElementsInRect:(CGRect)rect{
    @try {
       // NSLog(@"self.collectionView.numberOfSections=%ld",self.collectionView.numberOfSections);
        //[super layoutAttributesForElementsInRect:rect];
        NSMutableArray* attributes = [NSMutableArray array];
        for(NSInteger i=0 ; i < self.collectionView.numberOfSections; i++) {
            for (NSInteger j=0 ; j < [self.collectionView numberOfItemsInSection:i]; j++) {
                NSIndexPath* indexPath = [NSIndexPath indexPathForItem:j inSection:i];
                [attributes addObject:[self layoutAttributesForItemAtIndexPath:indexPath]];
            }
        }
        
        return attributes;
    }
    @catch (NSException *exception){
        
        NSLog(@"Exception in layoutAttributesForElementsInRect=%@",exception.description);
    }
}

- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds{
    @try {
        return YES;
    }
    @catch (NSException *exception){
        
        NSLog(@"Exception in shouldInvalidateLayoutForBoundsChange=%@",exception.description);
    }
}

- (void)calculateItemsSize {
    @try {
        for (NSUInteger index = 0; index < NUMBEROFCOLUMNS; index++) {
            if (self.itemsSize.count <= index) {
                CGSize itemSize = CGSizeMake(150, 60);//[self sizeForItemWithColumnIndex:index];
                
                if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad){
                    itemSize = CGSizeMake(250, 60);
                }else{
                    itemSize = CGSizeMake(150, 60);
                }
                
                NSValue *itemSizeValue = [NSValue valueWithCGSize:itemSize];
                [self.itemsSize addObject:itemSizeValue];
            }
        }
    }
    @catch (NSException *exception) {
        
        NSLog(@"Exception in calculateItemsSize =%@",exception.description);
    }
}

@end
