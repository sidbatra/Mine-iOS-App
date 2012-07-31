//
//  DWPurchase.m
//  Mine
//
//  Created by Siddharth Batra on 7/21/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPurchase.h"

#import "DWImageManager.h"
#import "DWUser.h"
#import "DWStore.h"
#import "DWLike.h"
#import "DWComment.h"
#import "DWConstants.h"

NSString* const kKeyGiantImageURL           = @"giant_url";
NSString* const kNImgPurchaseGiantLoaded    = @"NImgPurchaseGiantLoaded";
NSString* const kNImgPurchaseGiantLoadError = @"NImgPurchaseGiantLoadError";


static NSString* const kKeyTitle            = @"title";
static NSString* const kKeyEndorsement      = @"endorsement";
static NSString* const kKeySourceURL        = @"source_url";
static NSString* const kKeyFbObjectID       = @"fb_object_id";
static NSString* const kKeyCreatedAt        = @"created_at";
static NSString* const kKeyStore            = @"store";
static NSString* const kKeyLikes            = @"likes";
static NSString* const kKeyComments         = @"comments";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchase

@synthesize title           = _title;
@synthesize endorsement     = _endorsement;
@synthesize sourceURL       = _sourceURL;
@synthesize giantImageURL   = _giantImageURL;
@synthesize fbObjectID      = _fbObjectID;
@synthesize createdAt       = _createdAt;
@synthesize user            = _user;
@synthesize store           = _store;
@synthesize likes           = _likes;
@synthesize comments        = _comments;


//----------------------------------------------------------------------------------------------------
- (id)init {
	self = [super init];
	
	if(self) {  
        self.likes      = [NSMutableArray array];
        self.comments   = [NSMutableArray array];
    }
	
	return self;  
}

//----------------------------------------------------------------------------------------------------
-(void)dealloc{
	[self freeMemory];
    
    [self.user destroy];
    [self.store destroy];
    
    for(DWLike* like in self.likes)
        [like destroy];
    
    for(DWComment* comment in self.comments)
        [comment destroy];
        
	NSLog(@"Purchase released %d",self.databaseID);
}

//----------------------------------------------------------------------------------------------------
- (void)freeMemory {
    [[DWImageManager sharedDWImageManager] remove:self.giantImageURL];
}


//----------------------------------------------------------------------------------------------------
- (UIImage*)giantImage {
    return [[DWImageManager sharedDWImageManager] fetch:self.giantImageURL];
}

//----------------------------------------------------------------------------------------------------
- (void)update:(NSDictionary*)purchase {
    [super update:purchase];
	
    NSString *title         = [purchase objectForKey:kKeyTitle];
    NSString *endorsement   = [purchase objectForKey:kKeyEndorsement];
    NSString *sourceURL     = [purchase objectForKey:kKeySourceURL];
    NSString *giantImageURL = [purchase objectForKey:kKeyGiantImageURL];
    NSString *fbObjectID    = [purchase objectForKey:kKeyFbObjectID];
    
    NSString *createdAt     = [purchase objectForKey:kKeyCreatedAt];
    
    NSDictionary *user      = [purchase objectForKey:kKeyUser];
    NSDictionary *store     = [purchase objectForKey:kKeyStore];
    
    NSMutableArray *likes       = [purchase objectForKey:kKeyLikes];
    NSMutableArray *comments    = [purchase objectForKey:kKeyComments];
    
    
    if(title && ![self.title isEqualToString:title])
        self.title = title;
    
    if(endorsement  && ![endorsement isKindOfClass:[NSNull class]] && ![self.endorsement isEqualToString:endorsement])
        self.endorsement = endorsement;
    
    if(sourceURL && ![self.sourceURL isEqualToString:sourceURL])
        self.sourceURL = sourceURL;
    
    if(fbObjectID && ![fbObjectID isKindOfClass:[NSNull class]] && ![self.fbObjectID isEqualToString:fbObjectID])
        self.fbObjectID = fbObjectID;
    
    
    if(giantImageURL && ![self.giantImageURL isEqualToString:giantImageURL])
        self.giantImageURL = giantImageURL;
    
    if(createdAt) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:kRailsDateTimeFormat];

        self.createdAt = [format dateFromString:createdAt];
    }
    
    if(user) {
        if(self.user)
            [self.user update:user];
        else
            self.user = [DWUser create:user];
    }
    
    if(store) {
        if(self.store)
            [self.store update:store];
        else
            self.store = [DWStore create:store];
    }
    
    if(likes && [likes count]) {
        for(NSDictionary *response in likes) {
            DWLike *like = [DWLike fetch:[[response objectForKey:kKeyID] integerValue]];
            
            if(like)
                [like update:response];
            else {
                like = [DWLike create:response];
                [self.likes addObject:like];
            }
        }
    }
    
    if(comments && [comments count]) {
        for(NSDictionary *response in comments) {
            DWComment *comment = [DWComment fetch:[[response objectForKey:kKeyID] integerValue]];
            
            if(comment)
                [comment update:response];
            else {
                comment = [DWComment create:response];
                [self.comments addObject:comment];
            }
        }
    }
}


//----------------------------------------------------------------------------------------------------
- (void)downloadGiantImage {
    if(!self.giantImageURL)
        return;
    
    [[DWImageManager sharedDWImageManager] downloadImageAtURL:self.giantImageURL
                                               withResourceID:self.databaseID
                                          successNotification:kNImgPurchaseGiantLoaded
                                            errorNotification:kNImgPurchaseGiantLoadError]; 
}

//----------------------------------------------------------------------------------------------------
- (void)debug {
    NSLog(@"%@ %@ %@ %@ %@ %@",self.title,self.endorsement,self.sourceURL,self.giantImageURL,self.fbObjectID,self.createdAt);
    [self.user debug];
    [self.store debug];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Comment helpers

//----------------------------------------------------------------------------------------------------
- (void)addTempCommentByUser:(DWUser*)user
                 withMessage:(NSString*)message{
    
    DWComment *comment = [[DWComment alloc] init];
    
    comment.message = message;
    comment.user    = user;
    
    [comment.user incrementPointerCount];
    
    [self.comments addObject:comment];
}

//----------------------------------------------------------------------------------------------------
- (void)removeTempCommentWithMessage:(NSString*)message {
    for(DWComment *comment in [self.comments reverseObjectEnumerator]) {
        if([comment isUnmounted] && [comment.message isEqualToString:message]) {
            [self.comments removeObject:comment];
            break;
        }
    }    
}

//----------------------------------------------------------------------------------------------------
- (void)replaceTempCommentWithMountedComment:(DWComment*)newComment {
    [self removeTempCommentWithMessage:newComment.message];
    [self.comments addObject:newComment];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Like helpers

//----------------------------------------------------------------------------------------------------
- (BOOL)isLikedByUserID:(NSInteger)userID {
    BOOL liked = NO;
    
    for(DWLike *like in self.likes) {
        if(like.user.databaseID == userID) {
            liked = YES;
            break;
        }
    }
    
    return liked;
}

//----------------------------------------------------------------------------------------------------
- (void)addTempLikeByUser:(DWUser*)user {
    DWLike *like = [[DWLike alloc] init];
    
    like.user = user;
    [like.user incrementPointerCount];
    
    [self.likes addObject:like];
}

//----------------------------------------------------------------------------------------------------
- (void)removeTempLike {
    for(DWLike *like in [self.likes reverseObjectEnumerator]) {
        if([like isUnmounted]) {
            [self.likes removeObject:like];
            break;
        }
    }    
}

//----------------------------------------------------------------------------------------------------
- (void)replaceTempLikeWithMountedLike:(DWLike*)newLike {
    [self removeTempLike];
    [self.likes addObject:newLike];
}

@end
