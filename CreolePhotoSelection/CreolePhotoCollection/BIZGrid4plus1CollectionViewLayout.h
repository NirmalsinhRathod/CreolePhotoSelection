
#import <UIKit/UIKit.h>


@interface BIZGrid4plus1CollectionViewLayout : UICollectionViewLayout
@property (nonatomic) BOOL isLeft;
@property (nonatomic) CGFloat insetBetweenCells;
@property (nonatomic) NSInteger numberOfCellsInOneLineGroup;
@property (nonatomic) NSInteger numberOfCellsInTwoLineGroup;
//For subclasses
- (void)setup;
@end
