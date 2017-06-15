//
//  ViewController.m
//  CreolePhotoSelection
//
//  Created by CreoleStuduios on 6/14/17.
//  Copyright © 2017 CreoleStudios. All rights reserved.
//

#import "ViewController.h"
#import "CreolePhotoSelection.h"

@interface ViewController ()<CreolePhotoSelectionDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20.0f/255.0f green:158.0f/255.0f blue:235.0f/255.0f alpha:1.0]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Action Method
- (IBAction)btnSelectImageClick:(id)sender
{
    CreolePhotoSelection *objPhotoViewController= [[CreolePhotoSelection alloc] initWithNibName:@"CreolePhotoSelection" bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:objPhotoViewController];
    objPhotoViewController.strTitle = @"Choose Photo";
    objPhotoViewController.delegate = self;
    objPhotoViewController.arySelectedPhoto = _arrImage;
    objPhotoViewController.maxCount = 5;
    [self.navigationController presentViewController:navController animated:YES completion:nil];
}

#pragma mark - Photo selected Delegate Method
-(void)getSelectedPhoto:(NSMutableArray *)aryPhoto
{
    //Initlize array
    _arrImage = nil;
    _arrImage = [NSMutableArray new];
    _arrImage = [aryPhoto mutableCopy]; //mainImage, Asset, selected
    [self setImageToScrollview:_arrImage];
}

#pragma mark - Display Image to ScrollView
-(void)setImageToScrollview:(NSMutableArray *)arrSetImage
{
    // Remove all images from ScrollView and then add new one
    for(id sender in _scrImageDisplay.subviews)
        [sender removeFromSuperview];
    
    _scrImageDisplay.pagingEnabled = FALSE;
    CGFloat height_width = CGRectGetHeight(_scrImageDisplay.frame);
    
    NSInteger numberOfImages = arrSetImage.count;
    
    CGFloat xOrigin = 0;
    for (int i = 0 ; i < numberOfImages ; i++)
    {
        xOrigin += 3;
        CGRect rect =  CGRectMake(xOrigin, 0,height_width,height_width);
        UIImageView *image = [[UIImageView alloc] initWithFrame:rect];
        image.image = [[arrSetImage objectAtIndex:i] valueForKey:@"mainImage"];
        image.contentMode = UIViewContentModeScaleAspectFill;
        image.clipsToBounds = YES;
        [_scrImageDisplay addSubview:image];
        xOrigin += height_width;
    }
    
    _scrImageDisplay.contentSize = CGSizeMake(xOrigin, height_width);
}
@end
