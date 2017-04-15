//
//  ViewController.m
//  Tetris
//
//  Created by berk on 4/6/17.
//  Copyright © 2017 berk. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSInteger width = [_gameView frame].size.width/16;
    NSInteger height = [_gameView frame].size.height/32;
    _cells = [[NSMutableArray alloc] init];
    for(int i=0; i < 32; i++){
        for(int j=0; j < 16; j++){
            Cell *cell;
            if( i == 0 && j==0)
                cell = [[Cell alloc] initWithFrame:CGRectMake(j * width + width/2, i * height + height/2 , width, height)];
            else if(i==0)
                cell = [[Cell alloc] initWithFrame:CGRectMake((j * (width+2)) + width/2, i * height + height/2 , width, height)];
            else if(j==0)
                cell = [[Cell alloc] initWithFrame:CGRectMake(j * width + width/2, (i * (height+2)) + height/2, width, height)];
            else
               cell = [[Cell alloc] initWithFrame:CGRectMake((j * (width+2)) + width/2, (i * (height+2)) + height/2, width, height)];
            //NSLog(@"X:%ld Y:%ld W:%ld H:%ld",j*width,i*height,(long)width,(long)height);
            cell.xIndex = j;
            cell.yIndex = i;
            [cell setBackgroundColor:[UIColor blueColor]];
            [_cells addObject:cell];
            [_gameView addSubview:cell];
        }
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)upwards:(id)sender {
}
- (IBAction)rightwards:(id)sender {
}
- (IBAction)leftwards:(id)sender {
}
- (IBAction)downwards:(id)sender {
}
- (IBAction)goLeft:(id)sender {
}
- (IBAction)goRight:(id)sender {
}

@end
