//
//  DWSetting.h
//  Mine
//
//  Created by Siddharth Batra on 8/7/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import "DWPoolObject.h"


@interface DWSetting : DWPoolObject<NSCoding> {
    BOOL    _shareToFacebook;
    BOOL    _shareToTwitter;
    BOOL    _shareToTumblr;
    
    BOOL    _fbPublishActions;
}

/**
 * User preference for sharing to Facebook.
 */
@property (nonatomic,assign) BOOL shareToFacebook;

/**
 * User preference for sharing to Twitter.
 */
@property (nonatomic,assign) BOOL shareToTwitter;

/**
 * User preference for sharing to Tumblr.
 */
@property (nonatomic,assign) BOOL shareToTumblr;

/**
 * Facebook permission for publishing actions.
 */
@property (nonatomic,assign) BOOL fbPublishActions;


/**
 * Print debug info onto the console.
 */ 
- (void)debug;

@end
