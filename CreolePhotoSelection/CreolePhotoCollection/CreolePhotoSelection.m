//
//  CreolePhotoSelection.m
//  CreolePhotoSelection
//
//  Created by CreoleStuduios on 6/15/17.
//  Copyright © 2017 CreoleStudios. All rights reserved.
//

#import "CreolePhotoSelection.h"
#import "PhotoSelection.h"

@interface CreolePhotoSelection ()<UICollectionViewDataSource,UICollectionViewDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation CreolePhotoSelection

- (void)viewDidLoad {
    [super viewDidLoad];

    _viewBottom.hidden = TRUE;
    if(_arySelectedPhoto.count == 0)
        _arySelectedPhoto = [NSMutableArray new];
    
    [self setTitleToNAvBar:_strTitle andWithTarget:self]; //Set NavigationBar
    
    [self setGalleryBarItem]; //Set navigationItem Button
    
    //Initlize CollectionView
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    [_collectionView setBounces:YES];
    _collectionView.alwaysBounceVertical = YES;
    
    [self.collectionView registerClass:[PhotoSelection class] forCellWithReuseIdentifier:@"PhotoSelection"];
    
    UINib *cellNib = [UINib nibWithNibName:@"PhotoSelection" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"PhotoSelection"];
    
    //Request Authorization for Photo
    [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status)
     {
         switch (status) {
             case PHAuthorizationStatusAuthorized:
                 [self performSelectorOnMainThread:@selector(getAllPictures) withObject:nil waitUntilDone:NO];// Get photos from gallery
                 NSLog(@"PHAuthorizationStatusAuthorized");
                 break;
             case PHAuthorizationStatusRestricted:
                 NSLog(@"PHAuthorizationStatusRestricted");
                 break;
             case PHAuthorizationStatusDenied:
                 NSLog(@"PHAuthorizationStatusDenied");
                 break;
             default:
                 break;
         }
     }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - NavigationBar And NavigationController Methods
-(void)setTitleToNAvBar:(NSString *)titel andWithTarget:(UIViewController *)vc
{
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBarHidden = FALSE;
    
    UILabel *lblTitle = [[UILabel alloc] init];
    lblTitle.text = titel;
    lblTitle.backgroundColor = [UIColor clearColor];
    lblTitle.textColor = [UIColor whiteColor];
    lblTitle.font = [UIFont fontWithName:@"Avenir-Medium" size:20];
    [lblTitle sizeToFit];
    
    vc.navigationItem.titleView = lblTitle;
    [vc.navigationController.navigationBar setBarTintColor:[UIColor colorWithRed:20.0f/255.0f green:158.0f/255.0f blue:235.0f/255.0f alpha:1.0]];
    [vc.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

-(void)setGalleryBarItem
{
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera])
    {
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"photo_camera.png"] style:UIBarButtonItemStylePlain target:self action:@selector(openCamera)];
    }
    
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"cancel.png"] style:UIBarButtonItemStylePlain target:self action:@selector(goBack)];
}

//Camera open
-(void)openCamera
{
    UIImagePickerController *imagePickerController= [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
    imagePickerController.delegate = self;
    [self presentViewController:imagePickerController animated:YES completion:^{}];
}

-(void)goBack
{
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

#pragma mark - ImagePickerView Delegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    UIImage *img = [info valueForKey:UIImagePickerControllerOriginalImage];
    UIImage *img1 = [info valueForKey:UIImagePickerControllerOriginalImage];
    dic[@"image"] =img;
    dic[@"mainImage"] =img1;
    dic[@"selected"]=@"1";
    [_arrImage insertObject:dic atIndex:0];
    [_arySelectedPhoto addObject:dic];
    dic = nil;
    [_collectionView reloadData];
    [self setBottomViewCountLayout];
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImageWriteToSavedPhotosAlbum(img1, nil, nil, nil);
}

#pragma mark - UICollectionView DataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _arrImage.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PhotoSelection *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoSelection" forIndexPath:indexPath];
    
    cell.imageView.frame = cell.contentView.frame;
    cell.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIColor *color = [UIColor colorWithRed:20.0f/255.0f green:158.0f/255.0f blue:235.0f/255.0f alpha:0.6];;
    cell.viewGreen.backgroundColor = color;
    
    if (_arrImage[indexPath.row][@"assest"]) {
        
        PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
        requestOptions.synchronous = YES;
        
        PHImageManager *manager = [PHImageManager defaultManager];
        [manager requestImageForAsset:_arrImage[indexPath.row][@"assest"]
                           targetSize:CGSizeMake(self.view.frame.size.width/3, 200)
                          contentMode:PHImageContentModeDefault
                              options:requestOptions
                        resultHandler:^void(UIImage *image, NSDictionary *info) {
                            cell.imageView.image = image;
                        }];
        
    }
    else
    {
        cell.imageView.image = _arrImage[indexPath.row][@"image"];
        
    }
    if([_arrImage[indexPath.row][@"selected"] intValue] == 0)
    {
        cell.imgCheck.hidden = TRUE;
        cell.viewGreen.hidden = TRUE;
    }
    else
    {
        cell.imgCheck.hidden = FALSE;
        cell.viewGreen.hidden = FALSE;
    }
    
    return cell;
}

#pragma mark - UICollectionView Delegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    @try {
        NSMutableDictionary *dic = _arrImage[indexPath.row];
        
        PhotoSelection *cell = (PhotoSelection *)[collectionView cellForItemAtIndexPath:indexPath];
        if([dic[@"selected"] intValue] == 0)
        {
            int totalCount = [[_arrImage valueForKeyPath:@"@sum.selected"]intValue];
            if(totalCount >= _maxCount)
            {
                cell.contentView.transform = CGAffineTransformMakeTranslation(10, 10);
                [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.2 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
                    cell.contentView.transform = CGAffineTransformIdentity;
                } completion:nil];
                return;
            }
            dic[@"selected"] = @"1";
        }
        else
            dic[@"selected"] = @"0";
        
        if([dic[@"selected"] intValue] == 0)
        {
            [cell.imgCheck setHidden:true];
            [cell.viewGreen setHidden:true];
            
            NSArray *aryAssest = [_arySelectedPhoto valueForKeyPath:@"assest"];//Get value from array
            PHAsset *asset = _arrImage[indexPath.row][@"assest"];
            if([aryAssest containsObject:asset]) // check value
                [_arySelectedPhoto removeObjectAtIndex:[aryAssest indexOfObject:asset]]; // remove object
        }
        else
        {
            [_arySelectedPhoto addObject:dic];
            [cell.imgCheck setHidden:false];
            [cell.viewGreen setHidden:false];
        }
        [self setBottomViewCountLayout];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
}

#pragma mark Custom methods
-(void)getAllPictures
{
    @try
    {
        _arrImage = [[NSMutableArray alloc] init];
        NSArray *aryAssest = [_arySelectedPhoto valueForKey:@"assest"];
        if(_arrImage.count == 0)
        {
            _arrImage = [NSMutableArray array];
            BOOL isDataLoad;
            isDataLoad = FALSE;
            float widht, height;
            widht = self.view.frame.size.width/2;
            height = self.view.frame.size.height/2;
            
            //            NSLog(@"Started...");
            PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
            requestOptions.synchronous = YES;
            PHFetchOptions *allPhotosOptions = [PHFetchOptions new];
            allPhotosOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
            
            PHFetchResult *result = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:allPhotosOptions];
            for (PHAsset *asset in result) {
                
                NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
                
                if([aryAssest containsObject:asset])
                    [dic setValue:@"1" forKey:@"selected"];
                else
                    [dic setValue:@"0" forKey:@"selected"];
                [dic setValue:asset forKey:@"assest"];
                [_arrImage insertObject:dic atIndex:0];
                dic = nil;
            }
            //            NSLog(@"Completed...");
        }
        [self.collectionView reloadData];
        self.collectionView.hidden = FALSE;
        [self setBottomViewCountLayout];
        _viewBottom.hidden = FALSE;
    }
    @catch (NSException *exception)
    {
        NSLog(@"%@",exception.description);
    }
}

-(void)setBottomViewCountLayout
{
    int totalCount = [[_arrImage valueForKeyPath:@"@sum.selected"]intValue];
    if(totalCount<10)
        barButtonCamera.enabled = TRUE;
    else
        barButtonCamera.enabled = FALSE;
    
    NSString *str;
    if(totalCount>1)
        str = @"photos selected";
    else
        str = @"photo selected";
    
    _lblNumberOfPhotoSelected.text = [NSString stringWithFormat:@"%d %@",totalCount,str];
}

-(void)addingMainImageInSelectedList
{
    @try {
        PHImageRequestOptions *requestOptions = [[PHImageRequestOptions alloc] init];
        requestOptions.resizeMode   = PHImageRequestOptionsResizeModeFast;
        requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
        requestOptions.synchronous = true;
        for (NSMutableDictionary  *dic in _arySelectedPhoto)
        {
            // Do something with the asset
            PHAsset *asset = dic[@"assest"];
            if(asset != nil)
            {
                PHImageManager *manager = [PHImageManager defaultManager];
                [manager requestImageDataForAsset:asset
                                          options:requestOptions
                                    resultHandler:^(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info)
                 {
                     UIImage *image = [UIImage imageWithData:imageData];
                     
                     // Calculate new size given scale factor.
                     float scale;
                     
                     CGSize originalSize = image.size;
                     scale = 1000 / originalSize.width;
                     
                     CGSize newSize = CGSizeMake(originalSize.width * scale, originalSize.height * scale);
                     // Scale the original image to match the new size.
                     UIGraphicsBeginImageContext(newSize);
                     [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
                     UIImage* compressedImage = UIGraphicsGetImageFromCurrentImageContext();
                     UIGraphicsEndImageContext();
                     
                     dic[@"mainImage"] = compressedImage;
                 }];
            }
            else
            {
                NSMutableDictionary *dicc = [[NSMutableDictionary alloc] init];
                dicc = [dic mutableCopy];
                dic[@"mainImage"]  = dicc[@"image"];
                dicc = nil;
            }
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception.description);
    }
}

#pragma mark Action method
- (IBAction)btnPhotoDoneClicked:(id)sender
{
    NSMutableArray *finalSelectedArray = [NSMutableArray new];
    if (_arySelectedPhoto.count > 0) {
        [self addingMainImageInSelectedList];
        finalSelectedArray = [_arySelectedPhoto mutableCopy];
    }
    [_delegate getSelectedPhoto:finalSelectedArray];
    [self goBack];

}

@end
