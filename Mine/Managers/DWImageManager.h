//
//  DWImageManager.h
//  Mine
//
//  Created by Siddharth Batra on 7/21/12.
//  Copyright (c) 2012 Denwen, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Abstract functionaility for downloading and storing images.
 */
@interface DWImageManager : NSObject {
    NSMutableDictionary    *_imagePool;
}

/**
 * The sole shared instance of the class
 */
+ (DWImageManager *)sharedDWImageManager;

@end
