This is a MIPS Encoder and Corrector  
-
#### *Notice : Sign-Extension Maybe have error.*   
#### Format of .asm file : 
```
addiu $R01, $R0, 1         
addiu $R02, $R0, 2         
addu  $R03, $R01, $R02     
subu  $R04, $R03, $R02     
sw    $R04, 0($R0)         
lw    $R05, 0($R0)         
ori   $R06, $R05, 0x0100   
addu  $R07, $R06, $R01
```  

#### Step 1 :  
##### Put three Python file into your testbench folder  
![image](https://github.com/user-attachments/assets/c83902fc-4596-4bdd-a384-f14d2f6570a9)  

#### Step 2 : 
##### Cd to the folder and execute the command and then your MIPS code will be encoder to Instruction Memory(IM.dat)  
```bash
cd .\testbench\  
python mips_assembler.py Part3.asm IM.dat  
```  

#### Step 3 : 
##### Go to ModelSim and Simulate your RTL Code  

#### Step 4 : 
##### Execute the command can help to check your answer  
```bash
python verify_mips.py Part3.asm RF.dat DM.dat RF.out DM.out
```  
##### If Correct  
![image](https://github.com/user-attachments/assets/f9471086-db70-40b7-9bbd-514af151521c)  
##### If Noncorrect  
![image](https://github.com/user-attachments/assets/d3a6c948-2e1a-44c5-ad4a-4da1cebf7b4e)  


