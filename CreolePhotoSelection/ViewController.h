//
//  ViewController.h
//  CreolePhotoSelection
//
//  Created by Nidhi on 6/14/17.
//  Copyright © 2017 CreoleStudios. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrImageDisplay;
- (IBAction)btnSelectImageClick:(id)sender;
@property (strong,nonatomic) NSMutableArray *arrImage;
@property (strong,nonatomic) UIImageView *imgAddNewPhoto;

@end

