//
//  DWCreatePurchaseBackgroundQueueItem.h
//  Mine
//

#import "DWBackgroundQueueItem.h"

#import "DWPurchasesController.h"

@class DWPurchase;
@class DWProduct;


@interface DWCreatePurchaseBackgroundQueueItem : DWBackgroundQueueItem<DWPurchasesControllerDelegate> {
}

/**
 * Init with params needed to create a new purchase.
 */
- (id)initWithPurchase:(DWPurchase*)purchase 
               product:(DWProduct*)product 
             shareToFB:(BOOL)shareToFB
             shareToTW:(BOOL)sharetoTW
             shareToTB:(BOOL)sharetoTB;
@end
