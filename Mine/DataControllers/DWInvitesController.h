//
//  DWInvitesController.h
//  Mine
//
//  Created by Deepak Rao on 7/26/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol DWInvitesControllerDelegate;


/**
 * Interface to the invites service on the app server
 */
@interface DWInvitesController : NSObject {
    __weak id <DWInvitesControllerDelegate,NSObject> _delegate;
}

/**
 * Delegate recieves events based on the DWInvitesControllerDelegate protocol
 */
@property (nonatomic,weak) id<DWInvitesControllerDelegate,NSObject> delegate;

/**
 * Create invites from the contacts user has selected
 */
- (void)createInvitesFrom:(NSArray*)contacts;

@end


/**
 * Protocol for the InvitesController delegate. Fires 
 * messages about the success and failure of requests
 */
@protocol DWInvitesControllerDelegate

/**
 * Fired when invites are created
 */
- (void)invitesCreated;

/**
 * Error message while creating invites
 */
- (void)invitesCreationError:(NSString*)error;

@end
