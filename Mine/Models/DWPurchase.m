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


NSString* const kKeyTitle            	= @"title";
NSString* const kKeyEndorsement         = @"endorsement";
NSString* const kKeySourceURL           = @"source_url";
NSString* const kKeyFbObjectID          = @"fb_object_id";
NSString* const kKeyCreatedAt           = @"created_at";
NSString* const kKeyStore               = @"store";
NSString* const kKeyLikes               = @"likes";
NSString* const kKeyComments            = @"comments";
NSString* const kKeyOrigThumbURL        = @"orig_thumb_url";
NSString* const kKeyOrigImageURL        = @"orig_image_url";
NSString* const kKeyQuery               = @"query";
NSString* const kKeySuggestionID        = @"suggestion_id";
NSString* const kKeyStoreName           = @"store_name";
NSString* const kKeyIsStoreUnknown      = @"is_store_unknown";
NSString* const kKeyShareToFB           = @"share_to_facebook";
NSString* const kKeyShareToTW           = @"share_to_twitter";
NSString* const kKeyShareToTB           = @"share_to_tumblr";
NSString* const kKeyProduct             = @"product";



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWPurchase

@synthesize title           = _title;
@synthesize endorsement     = _endorsement;
@synthesize sourceURL       = _sourceURL;
@synthesize giantImageURL   = _giantImageURL;
@synthesize fbObjectID      = _fbObjectID;
@synthesize origThumbURL    = _origThumbURL;
@synthesize origImageURL    = _origImageURL;
@synthesize query           = _query;
@synthesize createdAt       = _createdAt;
@synthesize suggestionID    = _suggestionID;
@synthesize user            = _user;
@synthesize store           = _store;
@synthesize likes           = _likes;
@synthesize comments        = _comments;
@synthesize isDestroying    = _isDestroying;


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
        
	DWDebug(@"Purchase released %d",self.databaseID);
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
    NSString *origThumbURL  = [purchase objectForKey:kKeyOrigThumbURL];
    NSString *origImageURL  = [purchase objectForKey:kKeyOrigImageURL];
    NSString *query         = [purchase objectForKey:kKeyQuery];
    
    NSString *createdAt     = [purchase objectForKey:kKeyCreatedAt];
    NSString *suggestionID  = [purchase objectForKey:kKeySuggestionID];
    
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
    
    if(origThumbURL && ![origThumbURL isKindOfClass:[NSNull class]] && ![self.origThumbURL isEqualToString:origThumbURL])
        self.origThumbURL = origThumbURL;
    
    if(origImageURL && ![origImageURL isKindOfClass:[NSNull class]] && ![self.origImageURL isEqualToString:origImageURL])
        self.origImageURL = origImageURL;
    
    if(query && ![self.query isEqualToString:query])
        self.query = query;
    
    
    if(giantImageURL && ![self.giantImageURL isEqualToString:giantImageURL])
        self.giantImageURL = giantImageURL;
    
    if(createdAt) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:kRailsDateTimeFormat];

        self.createdAt = [format dateFromString:createdAt];
    }
    
    if(suggestionID)
        self.suggestionID = [suggestionID integerValue];
    
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
    DWDebug(@"%@ %@ %@ %@ %@ %@",self.title,self.endorsement,self.sourceURL,self.giantImageURL,self.fbObjectID,self.createdAt);
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
- (BOOL)removeTempCommentWithMessage:(NSString*)message {
    
    BOOL found = NO;
    
    for(DWComment *comment in [self.comments reverseObjectEnumerator]) {
        if([comment isUnmounted] && [comment.message isEqualToString:message]) {
            [self.comments removeObject:comment];
            found = YES;
            break;
        }
    }
    
    return found;
}

//----------------------------------------------------------------------------------------------------
- (void)replaceTempCommentWithMountedComment:(DWComment*)newComment {
    
    if([self removeTempCommentWithMessage:newComment.message])
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
- (BOOL)removeTempLike {
    
    BOOL found = NO;
    
    for(DWLike *like in [self.likes reverseObjectEnumerator]) {
        if([like isUnmounted]) {
            [self.likes removeObject:like];
            found = YES;
            break;
        }
    }
    
    return found;
}

//----------------------------------------------------------------------------------------------------
- (void)replaceTempLikeWithMountedLike:(DWLike*)newLike {
    
    if([self removeTempLike])
        [self.likes addObject:newLike];
}

@end
