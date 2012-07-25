//
//  DWTabBar.m
//  Copyright 2011 Denwen. All rights reserved.
//

#import "DWTabBar.h"
#import "DWConstants.h"

static NSString* const kImgHighlight        = @"new_item_triangle.png";
static NSInteger const kHighlightViewTag    = 3;


typedef enum {
    kTabBarButtonTagNormal  = 0,
    kTabBarButtonTagSpecial = -1
}kTabBarButtonTag;


/**
 * Private method and property declarations
 */
@interface DWTabBar() {
    NSMutableArray	*_buttons;
}

/**
 * Array of tab bar buttons
 */
@property (nonatomic) NSMutableArray *buttons;


/**
 * Switch UI to make the given button selected and returns its index.
 */
- (NSInteger)selectButton:(UIButton*)selectedButton;

/**
 * Fire delegate event when a button is pressed.
 */
- (void)buttonPressed:(UIButton*)button 
        withResetType:(NSInteger)resetType
           isExternal:(BOOL)isExternal;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWTabBar

@synthesize buttons			= _buttons;
@synthesize selectedIndex	= _selectedIndex;
@synthesize delegate        = _delegate;

//----------------------------------------------------------------------------------------------------
- (id)init {
	
    self = [super init];
    
	if (self) {		
		self.buttons = [NSMutableArray array];
        
        /*
        [[NSNotificationCenter defaultCenter] addObserver:self 
                                                 selector:@selector(requestTabBarIndexChange:) 
                                                     name:kNRequestTabBarIndexChange
                                                   object:nil];
         */
    }
	
    return self;
}

//----------------------------------------------------------------------------------------------------
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

//----------------------------------------------------------------------------------------------------
- (NSInteger)selectButton:(UIButton*)selectedButton {
	
	NSInteger index = 0;
	NSInteger i		= 0;
	
	if(selectedButton.tag != kTabBarButtonTagSpecial) {
		
		for (UIButton* button in self.buttons) {
			
			if(button == selectedButton) {
				button.selected = YES;
				index = i;
			}
			else {
				button.selected = NO;
			}
			
			
			button.highlighted = NO;
			i++;
		}
	}
	else {
		index = [self.buttons indexOfObject:selectedButton];
	}
	
	return index;
}

//----------------------------------------------------------------------------------------------------
- (void)buttonPressed:(UIButton*)button 
        withResetType:(NSInteger)resetType
           isExternal:(BOOL)isExternal {
    
	NSInteger oldIndex	= _selectedIndex;
	_selectedIndex		= [self selectButton:button];
	
	[_delegate selectedTabWithSpecialTab:button.tag == kTabBarButtonTagSpecial
							modifiedFrom:oldIndex
									  to:_selectedIndex
                           withResetType:isExternal ? resetType : (_selectedIndex == oldIndex ? 
                                                                    kTabBarResetTypeSoft : 
                                                                    kTabBarResetTypeNone)];

	
	if(button.tag == kTabBarButtonTagSpecial)
		_selectedIndex = oldIndex;
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Public interface

//----------------------------------------------------------------------------------------------------
- (void)addTabWithWidth:(NSInteger)width 
        normalImageName:(NSString*)normalImageName
      selectedImageName:(NSString*)selectImageName 
   highlightedImageName:(NSString*)highlightedImageName
   isMappedToController:(BOOL)controllerMapping
             isSelected:(BOOL)isSelected {
    
    
    NSInteger buttonX = 0;
    
    for(UIButton *button in self.buttons) {
        buttonX += button.frame.size.width;
    }
    
    
    UIButton *button		= [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame			= CGRectMake(buttonX,0,width,self.frame.size.height);
    button.tag				= controllerMapping ? kTabBarButtonTagNormal : kTabBarButtonTagSpecial;
    
    
    [button setBackgroundImage:[UIImage imageNamed:normalImageName]
                      forState:UIControlStateNormal];
    
    [button setBackgroundImage:[UIImage imageNamed:selectImageName]
                      forState:UIControlStateSelected];
    
    if(highlightedImageName)
        [button setBackgroundImage:[UIImage imageNamed:highlightedImageName]
                          forState:UIControlStateHighlighted];
    
    
    [button addTarget:self 
               action:@selector(didTouchDownOnButton:) 
     forControlEvents:UIControlEventTouchDown];
    
    [button addTarget:self
               action:@selector(didTouchUpInsideButton:) 
     forControlEvents:UIControlEventTouchUpInside];
    
    [button addTarget:self
               action:@selector(didOtherTouchesToButton:) 
     forControlEvents:UIControlEventTouchUpOutside];
    
    [button addTarget:self
               action:@selector(didOtherTouchesToButton:) 
     forControlEvents:UIControlEventTouchDragOutside];
    
    [button addTarget:self
               action:@selector(didOtherTouchesToButton:)
     forControlEvents:UIControlEventTouchDragInside];
    
    
    if(isSelected) {
        button.selected = YES;
        _selectedIndex	= self.buttons.count;
    }
    
    [self.buttons	addObject:button];
    [self			addSubview:button];
}

/*
 //----------------------------------------------------------------------------------------------------
 - (void)highlightTabAtIndex:(NSInteger)index {
 UIButton *button                    = (UIButton*)[self.buttons objectAtIndex:index];
 
 for (UIView *view in [button subviews]) 
 if (view.tag == kHighlightViewTag)
 return;
 
 UIImageView *imageView              = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kImgHighlight]];
 imageView.tag                       = kHighlightViewTag;
 imageView.frame                     = CGRectMake(50,40,15,9);
 imageView.userInteractionEnabled    = NO;
 
 [button addSubview:imageView];
 }
 
 //----------------------------------------------------------------------------------------------------
 - (void)dimTabAtIndex:(NSInteger)index {
 UIButton *button                    = (UIButton*)[self.buttons objectAtIndex:index];
 
 for (UIView *view in [button subviews]) 
 if (view.tag == kHighlightViewTag) {
 [view removeFromSuperview];
 break;
 }
 }
 */


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Event handlers for tab bar buttons

//----------------------------------------------------------------------------------------------------
- (void)didTouchDownOnButton:(UIButton*)button {
    [self buttonPressed:button 
          withResetType:kTabBarResetTypeNone
             isExternal:NO];
}

//----------------------------------------------------------------------------------------------------
- (void)didTouchUpInsideButton:(UIButton*)button {
	[self selectButton:button];
}

//----------------------------------------------------------------------------------------------------
- (void)didOtherTouchesToButton:(UIButton*)button {
	[self selectButton:button];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark Notifications

/*
//----------------------------------------------------------------------------------------------------
- (void)requestTabBarIndexChange:(NSNotification*)notification {
    
    NSDictionary    *userInfo   =   [notification userInfo];
    NSInteger       newIndex    =   [[userInfo objectForKey:kKeyTabIndex] integerValue];
    NSInteger       resetType   =   [[userInfo objectForKey:kKeyResetType] integerValue];
    
    [self buttonPressed:[self.buttons objectAtIndex:newIndex]
          withResetType:resetType
             isExternal:YES];
}
 */


@end
