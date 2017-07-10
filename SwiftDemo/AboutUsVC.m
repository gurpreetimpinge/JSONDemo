//
//  AboutUsVC.m
//  Tranzgrid
//
//  Created by MacUser on 2/10/16.
//  Copyright (c) 2016 Tranzgrid. All rights reserved.
//

#import "AboutUsVC.h"

@interface AboutUsVC ()
{
    IBOutlet UILabel *lbl_Title;
}

@end

@implementation AboutUsVC
@synthesize str_Title;

- (void)viewDidLoad {
    [super viewDidLoad];
        
    lbl_Title.text = str_Title;
    
    // Do any additional setup after loading the view.
}

-(void)viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
