//
//  DWCreatePurchaseBackgroundQueueItem.m
//  Mine
//

#import "DWCreatePurchaseBackgroundQueueItem.h"

#import "DWPurchase.h"
#import "DWProduct.h"
#import "DWAnalyticsManager.h"

@interface DWCreatePurchaseBackgroundQueueItem() {
    DWPurchase  *_purchase;
    DWProduct   *_product;
    
    BOOL    _shareToFB;
    BOOL    _shareToTW;
    BOOL    _shareToTB;
    
    DWPurchasesController   *_purchasesController;
}

/**
 * The template puchase with data about the purchase to be created.
 */
@property (nonatomic,strong) DWPurchase *purchase;

/**
 * Associated product to create the associated product with the new purchase.
 */
@property (nonatomic,strong) DWProduct *product;

/**
 * Status for sharing to facebook
 */
@property (nonatomic,assign) BOOL shareToFB;

/**
 * Status for sharing to twitter
 */
@property (nonatomic,assign) BOOL shareToTW;

/**
 * Status for sharing to tumblr
 */
@property (nonatomic,assign) BOOL shareToTB;

/**
 * Data controller for the purchases model.
 */
@property (nonatomic,strong) DWPurchasesController *purchasesController;

@end



//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
@implementation DWCreatePurchaseBackgroundQueueItem

@synthesize purchase            = _purchase;
@synthesize product             = _product;
@synthesize shareToFB           = _shareToFB;
@synthesize shareToTW           = _shareToTW;
@synthesize shareToTB           = _shareToTB;
@synthesize purchasesController = _purchasesController;


//----------------------------------------------------------------------------------------------------
- (id)initWithPurchase:(DWPurchase*)purchase 
               product:(DWProduct*)product 
             shareToFB:(BOOL)shareToFB
             shareToTW:(BOOL)sharetoTW
             shareToTB:(BOOL)sharetoTB {
    
	self = [super init];
	
	if(self) {
        
        self.purchase   = purchase;
        self.product    = product;
        
        self.shareToFB  = shareToFB;
        self.shareToTW  = sharetoTW;
        self.shareToTB  = sharetoTB;
        
        self.purchasesController            = [[DWPurchasesController alloc] init];
        self.purchasesController.delegate   = self;
	}
	
	return self;
}

//----------------------------------------------------------------------------------------------------
- (void)start {
    [super start];
    
    self.resourceID =  [self.purchasesController createPurchaseFromTemplate:self.purchase 
                                                                 andProduct:self.product
                                                              withShareToFB:self.shareToFB
                                                              withShareToTW:self.shareToTW
                                                              withShareToTB:self.shareToTB 
                                                             uploadDelegate:self];
}


//----------------------------------------------------------------------------------------------------
//----------------------------------------------------------------------------------------------------
#pragma mark -
#pragma mark DWPurchasesControllerDelegate

//----------------------------------------------------------------------------------------------------
- (void)purchaseCreated:(DWPurchase *)purchase 
         fromResourceID:(NSNumber *)resourceID {
    
    if(self.resourceID != [resourceID integerValue])
        return;
    
    [[DWAnalyticsManager sharedDWAnalyticsManager] track:@"Purchase Created"];
    
    [purchase destroy];
    
    [self processingFinished];
}

//----------------------------------------------------------------------------------------------------
- (void)purchaseCreateError:(NSString *)error 
             fromResourceID:(NSNumber *)resourceID {
    
    if(self.resourceID != [resourceID integerValue])
        return;
    
    [self processingError];
}


@end
