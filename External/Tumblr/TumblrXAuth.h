// TwitterXAuth.h
//
// Created by Eric Johnson on 08/27/2010.
// Copyright 2010 Eric Johnson. All rights reserved.
//
// Permission is given to use this source code file, free of charge, in any
// project, commercial or otherwise, entirely at your risk, with the condition
// that any redistribution (in part or whole) of source code must retain
// this copyright and permission notice. Attribution in compiled projects is
// appreciated but not required.

#import <Foundation/Foundation.h>

@interface NSString (URLEncode)
- (NSString *) urlEncode;
@end

@class TumblrXAuth;

@protocol TumblrXAuthDelegate <NSObject>
@optional
- (void) tumblrXAuthAuthorizationDidFail:(TumblrXAuth *)twitterXAuth;
- (void) tumblrXAuthDidAuthorize:(TumblrXAuth *)twitterXAuth;
@end

typedef enum {
  TumblrXAuthStateDefault,
  TumblrXAuthStateAuthorize,
} TumblrXAuthState;

@interface TumblrXAuth : NSObject
{
  NSString * nonce;
  NSString * timestamp;
  NSString * consumerKey;
  NSString * password;
  NSString * username;
  NSString * consumerSecret;
  NSString * token;
  NSString * tokenSecret;
  NSMutableData * data;
  TumblrXAuthState state;
  id<TumblrXAuthDelegate> delegate;
  NSString * tweet;
  NSString * tumblrURL;
}
@property (nonatomic,copy) NSString * consumerKey;
@property (nonatomic,copy) NSString * password;
@property (nonatomic,copy) NSString * username;
@property (nonatomic,copy) NSString * consumerSecret;
@property (nonatomic,copy) NSString * token; //oauth_token
@property (nonatomic,copy) NSString * tokenSecret; //oauth_token_secret
@property (nonatomic,assign) id<TumblrXAuthDelegate> delegate;
- (void) authorize;
@end
