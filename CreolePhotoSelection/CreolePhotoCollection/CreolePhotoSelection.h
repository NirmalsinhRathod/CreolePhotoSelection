//
//  CreolePhotoSelection.h
//  CreolePhotoSelection
//
//  Created by CreoleStuduios on 6/15/17.
//  Copyright © 2017 CreoleStudios. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreolePhotoSelectionDelegate <NSObject>
@optional
-(void)getSelectedPhoto:(NSMutableArray *)aryPhoto;
@end

@import Photos;

@interface CreolePhotoSelection : UIViewController
{
    UIBarButtonItem *barButtonCamera;
}
@property (strong, nonatomic) id <CreolePhotoSelectionDelegate> delegate;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) IBOutlet UIButton *btnDone;
@property (strong, nonatomic) IBOutlet UILabel *lblNumberOfPhotoSelected;
@property (strong, nonatomic) NSString *strTitle;
@property (strong, nonatomic) IBOutlet UIView *viewBottom;

- (IBAction)btnPhotoDoneClicked:(id)sender;


@property(strong,nonatomic) NSMutableArray *arySelectedPhoto;
@property (strong,nonatomic) NSMutableArray *arrImage;
@property (readwrite) int maxCount;
@end
