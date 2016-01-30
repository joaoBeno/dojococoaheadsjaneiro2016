//
//  newPersonViewController.m
//  dojosabado
//
//  Created by Jose Lino Neto on 1/30/16.
//  Copyright © 2016 Construtor. All rights reserved.
//

#import "newPersonViewController.h"
#import "Person.h"
#import <MBProgressHUD.h>

@interface newPersonViewController ()

@property (strong, nonatomic) IBOutlet UITextField *idText;
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UITextField *emailText;
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation newPersonViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if (self.personEditar){
        self.idText.text = self.personEditar.Id.Id;
        self.nameText.text = self.personEditar.Nome;
        self.emailText.text = self.personEditar.Email;
    }
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
- (IBAction)salvarAction:(id)sender {
    self.hud = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
    self.hud.mode = MBProgressHUDAnimationFade;
    self.hud.labelText = @"Salvando...";
    
    if (self.personEditar)
    {
        self.personEditar.Nome = self.nameText.text;
        self.personEditar.Email = self.emailText.text;
        
        [Person createPerson:self.personEditar sucesso:^(NSURLSessionDataTask *resposta, NSArray *objetoDeResposta) {
            [self.hud hide:YES];
            [self alertarUsuarioAlterar:@"Alterado com sucesso"];
            
        } falha:^(NSURLSessionDataTask *resposta, NSError *erro) {
            [self.hud hide:YES];
            [self alertarUsuarioAlterar:@"Não foi possível alterar"];
        }];
    }
    else{
        Person *p = [Person new];
        
        p.Nome = self.nameText.text;
        p.Email = self.emailText.text;
        
        [Person createPerson:p sucesso:^(NSURLSessionDataTask *resposta, NSArray *objetoDeResposta) {
            [self.hud hide:YES];
            [self alertarUsuarioAlterar:@"Salvo com sucesso"];
        } falha:^(NSURLSessionDataTask *resposta, NSError *erro) {
            NSLog(@"%@", erro.localizedDescription);
            [self.hud hide:YES];
            [self alertarUsuarioAlterar:@"Não foi possível Salvar"];
        }];
    }
}

-(void)alertarUsuarioAlterar:(NSString *)mensagem{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Produto"
                                                                   message:mensagem
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *salvarAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault
                                                         handler:^(UIAlertAction * action) {
                                                         }];
    [alert addAction:salvarAction];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
