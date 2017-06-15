# CreolePhotoSelection
It will help to select one or multiple photos from Gallery as well as Camera.

## Requirements

Objective C and  
iOS 10 and above

# Demo
<br>
<img height="356" src="https://dl.dropbox.com/s/r0qw2jycz2efgkn/photoselection.gif" />
</br>


# How to implement
You just need to drag folder "CreolePhotoCollection" your project and initialize the object

```ruby
    CreolePhotoSelection *objCreolePhotoSelection= [[CreolePhotoSelection alloc] initWithNibName:@"CreolePhotoSelection" bundle:nil];
    objCreolePhotoSelection.strTitle = YOUR_TITLE_FOR_PHOTO_VIEW;
    objCreolePhotoSelection.delegate = self; // It will help to retrive all selected photos from CreolePhotoSelection
    objCreolePhotoSelection.arySelectedPhoto = YOUR_CURRENT_ARRAY; // You need to pass same array which is holding selected image
    objCreolePhotoSelection.maxCount = YOUR_MAX_PHOTOS_LIMIT; // Eg. 5, 10 anythings...
     
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:objCreolePhotoSelection];
    [self.navigationController presentViewController:navController animated:YES completion:nil];

    // Delegate Method
    #pragma mark - Photo selected Delegate Method
    -(void)getSelectedPhoto:(NSMutableArray *)aryPhoto
    {
      // You will selected image array into aryPhoto object and you can use it
    }   

```

Also don't forgot to add Camera and Gallary permissions keys into your info.plist file

    1) Privacy - Camera Usage Description
    
    2) Privacy - Photo Library Usage Description


## Author

Nirmalsinh Rathod, 

nirmasinh@creolestudios.com

www.creolestudios.com

## License

CreolePhotoSelection is available under the MIT license. See the LICENSE file for more info.
