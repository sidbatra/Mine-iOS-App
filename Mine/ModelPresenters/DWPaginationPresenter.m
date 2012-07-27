//
//  DWPaginationPresenter.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWPaginationPresenter.h"

#import "DWPagination.h"
#import "DWPaginationCell.h"
#import "DWConstants.h"



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPaginationPresenter

//----------------------------------------------------------------------------------------------------
+ (UITableViewCell*)cellForObject:(id)object
                     withBaseCell:(id)base
               withCellIdentifier:(NSString*)identifier
                     withDelegate:(id)delegate
             andPresentationStyle:(NSInteger)style {
    
    DWPagination *pagination    = object;
    DWPaginationCell *cell      = base;
    
    if(!cell)
        cell = [[DWPaginationCell alloc] initWithStyle:UITableViewCellStyleDefault
                                       reuseIdentifier:identifier];
    
    if(!pagination.isTriggered && !pagination.isDisabled) {
        
        [[NSNotificationCenter defaultCenter] postNotificationName:kNPaginationCellReached
                                                            object:pagination.owner
                                                          userInfo:nil];
        
        pagination.isTriggered  = YES;
    }
    
    return cell;
}

//----------------------------------------------------------------------------------------------------
+ (CGFloat)heightForObject:(id)object 
     withPresentationStyle:(NSInteger)style {
    
    return kPaginationCellHeight;
}

//----------------------------------------------------------------------------------------------------
+ (void)updatePresentationForCell:(id)base 
                         ofObject:(id)object
            withPresentationStyle:(NSInteger)style
                  withObjectClass:(Class)objectClass
                     withObjectID:(NSInteger)objectID
                     andObjectKey:(NSString *)objectKey {    
}

//----------------------------------------------------------------------------------------------------
+ (void)cellClickedForObject:(id)object
                withBaseCell:(id)base
       withPresentationStyle:(NSInteger)style
                withDelegate:(id)delegate {
    
}

@end
