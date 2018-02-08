                                                                                                                                                                                                                                                                         ;*****************************************************************
;* This stationery serves as the framework for a                 *
;* user application (single file, absolute assembly application) *
;* For a more comprehensive program that                         *
;* demonstrates the more advanced functionality of this          *
;* processor, please see the demonstration applications          *
;* located in the examples subdirectory of the                   *
;* Freescale CodeWarrior for the HC12 Program directory          *
;*****************************************************************

; export symbols
            XDEF Entry, _Startup            ; export 'Entry' symbol
            ABSENTRY Entry        ; for absolute assembly: mark this as application entry point



; Include derivative-specific definitions 
		INCLUDE 'derivative.inc' 

ROMStart    EQU  $4000  ; absolute address to place my code/constant data

; variable/data section

                                                                          
DATA                                                  EQU $2000           
COUNTER                                               EQU $3000           ;Basamak Sayisini Sayaci

COUNTER_BASE_NUMBER_FIRST_NUMBER_DECIMAL_PART         EQU $3001           ;1.sayinin decimal kisminin basamak sayisi
COUNTER_BASE_NUMBER_SECOND_NUMBER_DECIMAL_PART        EQU $3002           ;2.sayinin decimal kisminin basamak sayisi

COUNTER_BASE_NUMBER_FIRST_NUMBER_INTEGER_PART         EQU $3003           ;1.sayinin integer kisminin basamak sayisi
COUNTER_BASE_NUMBER_SECOND_NUMBER_INTEGER_PART        EQU $3004           ;2.sayinin integer kisminin basamak sayisi

EXTENDED_DECIMAL_PART_BASE_1_TO_BASE_2                EQU $3005           ;1 basamakli decimal kismi 2 basamaga cikarma
EXTENDED_DECIMAL_PART_BASE_1_TO_BASE_2_SUB            EQU $3006
                                                                          
FLAG_MINUS_1                                          EQU $3007           ; Integer kisimdan 1 cikarmak icin

RESULT_INTEGER_PART                                   EQU $1500           ;Sonucun integer kisminin yazylacagi adres
RESULT_DECIMAL_PART                                   EQU $1501           ;Sonucun integer kisminin yazylacagi adres




  ORG $1200                                          
                                                         ;ISLEM ONCESI VE SONRASINDAKI BOSLUKLAR IGNORE EDILMISTIR.
;******** TEST STRINGLER *****
                                                         
;STRING:    FCC "0.7 + 0.4="                             ;1.1             
;STRING:    FCC "3.4 + 9.65="                            ;13.05   
;STRING:    FCC "8.65   + 9.42="                         ;18.07
;STRING:    FCC "19.65 +      31.43="                    ;51.08
;STRING:    FCC "28.33 + 17.28"                          ;45.61
;STRING:    FCC "3.37     + 1.24="                       ;4.61 
;STRING:    FCC "21.7 + 22.4="                           ;44.1
;STRING:    FCC "72.7   +   20.45="                      ;93.15
;STRING:    FCC "60.7 + 60.47="                          ;121.17 
;STRING:    FCC "104.7          +         8.45="         ;113.15
;STRING:    FCC "0.2 + 125.8="                           ;126.0


;STRING:    FCC "3.4 - 0.7="                             ;2.7
;STRING:    FCC "23.3 - 5.7="                            ;17.6
;STRING:    FCC "88.69  -      35.23="                   ;53.46
;STRING:    FCC "45.59           - 17.27="               ;28.32
;STRING:    FCC "99.9 - 35.26="                          ;64.64
;STRING:    FCC "88.26    -     35.9="                   ;52.36
;STRING:    FCC "120.2 - 101.7="                         ;18.5
;STRING:    FCC "120.29 - 50.7="                         ;69.59
;STRING:    FCC "118.4 - 5.7="                           ;112.7 
;STRING:    FCC "118.46 - 115.34="                       ;3.12 
     
  ORG DATA
  
; FIRST NUMBER

INTEGER_PART_1_BASE:                     DS.B 1       ;Memory Address $2000     1. sayinin 1 basamakli integer degeri
INTEGER_PART_2_BASE:                     DS.B 1       ;Memory Address $2001     1. sayinin 2 basamakli integer degeri
INTEGER_PART_3_BASE                      DS.B 1       ;Memory Address $2002     1. sayinin 3 basamakli integer degeri

NEW_ARRAY_INTEGER:                       DS.B 5       ;                         Gecici Dizi integer degerler icin 

DECIMAL_PART_1_BASE:                     DS.B 1       ;Memory Address $2008     1. sayinin 1 basamakli decimal degeri
DECIMAL_PART_2_BASE:                     DS.B 1       ;Memory Address $2009     1. sayinin 2 basamakli decimal degeri

NEW_ARRAY_DECIMAL:                       DS.B 3       ;                         Gecici Dizi decimal degerler icin


; SECOND NUMBER

SECOND_NUM_INTEGER_PART_1_BASE:          DS.B 1       ;Memory Address $200D     2. sayinin 1 basamakli integer degeri
SECOND_NUM_INTEGER_PART_2_BASE:          DS.B 1       ;Memory Address $200E     2. sayinin 2 basamakli integer degeri
SECOND_NUM_INTEGER_PART_3_BASE           DS.B 1       ;Memory Address $200F     2. sayinin 3 basamakli integer degeri

SECOND_NUM_NEW_ARRAY_INTEGER:            DS.B 5       ;                         Gecici Dizi integer degerler icin 

SECOND_NUM_DECIMAL_PART_1_BASE:          DS.B 1       ;Memory Address $2015     2. sayinin 1 basamakli decimal degeri
SECOND_NUM_DECIMAL_PART_2_BASE:          DS.B 1       ;Memory Address $2016     2. sayinin 1 basamakli decimal degeri

SECOND_NUM_NEW_ARRAY_DECIMAL:            DS.B 3       ;                         Gecici Dizi integer degerler icin 

OPERATION_ADD_OR_SUB:                    DS.B 1
COUNTER_TEMP:                            DS.B 1
TEMP1:                                   DS.B 1
TEMP_FIRST_NUMBER:                       DS.B 1
TEMP_SECOND_NUMBER:                      DS.B 1



            ORG RAMStart
 ; Insert here your data definition.



; code section
            ORG   ROMStart


Entry:
_Startup:
            LDS   #RAMEnd+1       ; initialize the stack pointer

            CLI                   ; enable interrupts
mainLoop:
           
           
            LDAA #$FF             ;Overflow durumu icin
            STAA DDRB
          
           
            
            LDX #NEW_ARRAY_INTEGER                      ;Gecici dizinin baslangic adresi X registerinda                      
            LDY #STRING                                 ;String baslangic adresi Y registerinda
           

            CLRA                                        ; Counter = 0
            STAA COUNTER
                                                        ;1.sayinin integer degerini hesapla
            
                                                        ; Stringin ilk elemanini al
                LDAA 0,Y
            
            POINT_LOOP:                                 ; Nokta(.) gorunceye kadar elemanlari sirasiyla al
                CMPA #$2E
                BHI LABEL_STORE                         
                BRA LABEL_OP
          
            
            LABEL_STORE:                                ; Noktadan farkli olan elemanlari gecici diziye koy
                STAA 1,X+                               ; Basamak sayisini hesapla
                INC COUNTER
                INY
                LDAA 0,Y
                BRA POINT_LOOP
               
                
            LABEL_OP:
                  LDAA  COUNTER                         ;Basamak sayisi 4'den kucuk ise yerlestirilen hex degerleri
                  CMPA #4                               ;decimal degere donustur
                  LBLO ONE_TWO_THREE_BASE_OPERATION
                  LBHI ONE_BASE_OPERATION
                  
          
          
           ;SECOND PART OPERATION
           SECOND_PART:                                  ;1.sayinin decimal degerini hesaplama
            
            
            LDX #NEW_ARRAY_DECIMAL                       ; Basamak sayisini 0 yap
            CLR  COUNTER
            
            INY                                          ;Arrayin baslangic adresini 1 artir.Noktadan sonrasini gostersin.
            LDAA  0,Y
            
                                                         ; Bosluk gorunceye kadar elemanlari almaya devam et.
            SPACE_LOOP:
                CMPA #$20
                BHI LABEL_STORE_2
                BRA LABEL_OP_2
          
                                                         ; Bosluktan farkli olan elemanlari gecici diziye koy
            LABEL_STORE_2:                               ; Basamak sayisini hesapla
                STAA 1,X+       
                INC COUNTER
                INY
                LDAA 0,Y
                BRA SPACE_LOOP
               
                
            LABEL_OP_2:
                  LDAA  COUNTER                          ;Basamak sayisi 3'den kucuk ise yerlestirilen hex degerleri
                  CMPA #3                                ;decimal degere donustur
                  LBLO ONE_TWO_BASE_OPERATION_1
                  LBHI ONE_BASE_OPERATION_1
                  ;SWI
            
            THIRD_PART:
            
                                                         ;Alinan karakter bosluk oldugu surece sayi almaya devam et
            LOOP_SPACE_1:                                ;Alinan karekter bosluk degilse, hangi islemin yapilacagidir
                 LDAA 0,Y
                 CMPA #$20
                 BEQ GET_NEXT_NUMBER
                 BRA GET_SIGN
            
            
            GET_NEXT_NUMBER:
                 INY
                 BRA LOOP_SPACE_1
                 
            GET_SIGN:
                 STAA OPERATION_ADD_OR_SUB                
                 JMP FOURTH_PART             
            
           
           
           ; FOURT PART IS SECOND NUMBER OPERATION      
           FOURTH_PART:
           
                LDX #SECOND_NUM_NEW_ARRAY_INTEGER
                INY                                      ;YSARETTEN SONRASINI GOSTER

                CLR COUNTER
               
                LDAA 0,Y       
             
             
             
                LOOP_SPACE_2:                            ;Alinan karakter bosluk oldugu surece sayi almaya devam et
                 LDAA 0,Y                                ;Alinan karekter bosluk degilse,(.) isareti gelinceye 2.sayini
                 CMPA #$20                               ;integer kismini almaya basla
                 BEQ GET_NEXT_NUMBER_2
                 BRA POINT_LOOP_SECOND_NUM
            
            
            GET_NEXT_NUMBER_2:
                 INY
                 BRA LOOP_SPACE_2
                 
            
             
                 POINT_LOOP_SECOND_NUM:                  ;1.sayinin integer degerini hesaplama yöntemini tekrarla
                    CMPA #$2E                            ;Noktadan farkli oldugu surece 2.sayinin integer elemanlarini al,
                    BHI LABEL_STORE_3                    ;Gecici diziye koy
                    BRA LABEL_OP_3
              
                
                LABEL_STORE_3: 
                    STAA 1,X+       
                    INC COUNTER
                    INY
                    LDAA 0,Y
                    BRA POINT_LOOP_SECOND_NUM
                   
                    
                LABEL_OP_3:                             ;Basamak sayisi 4 den kucuk ise yerlestirilen hex degerleri,
                      LDAA COUNTER                      ;decimal degerleri donustur
                      CMPA #4
                      LBLO ONE_TWO_THREE_BASE_OPERATION_SECOND_NUM
                      LBHI ONE_BASE_OPERATION_SECOND_NUM
 
 
              ; FIFTH PART
              
               FIFTH_PART:

                      LDX #SECOND_NUM_NEW_ARRAY_DECIMAL ;2.sayinin decimal degerlerini (=) karekterinden farkli oldugu surece al
                      CLR COUNTER
                      
                      INY
                      LDAA  0,Y
                      
                
                      
                      EQUAL_LOOP:
                          CMPA #$3D
                          BLT LABEL_STORE_4
                          BRA LABEL_OP_4
                    
                      
                      LABEL_STORE_4:                   ;(=)'dan farkli olan elemanlari al ve gecici diziye koy
                          STAA 1,X+       
                          INC COUNTER                  ;basamak sayisini hesapla
                          INY
                          LDAA 0,Y
                          BRA EQUAL_LOOP
                         
                          
                      LABEL_OP_4:                         ;basamak sayisi 3 den kucukse yerlestirilen hex degerleri 
                            LDAA COUNTER                  ;decimal degere donustur
                            CMPA #3
                            LBLO ONE_TWO_BASE_OPERATION_2
                            LBHI ONE_BASE_OPERATION_2
                          
                                                     
 
                       ;ADDITION OR SUBTRACTION OPERATION
                       
                       ADD_OR_SUB_PART:                        ;Hangi islemin yapilacagini hesapla
                       
                               LDAA OPERATION_ADD_OR_SUB
                               
                               CMPA #$2C
                               LBLO  OPERATION_ADD  ;Long Branch if Lower      ;$2B TOPLAMA
                               LBHI  OPERATION_SUB  ;Long Branch if Higher     ;$2D CIKARMA
                               
                       
                       
                       OPERATION_ADD:
                       
                                ;Sayilarin decimal basamak degerleri toplami 3 ise
                                ;1 basamakli olan sayiyi 2 basamaga cikar
                                LDAA COUNTER_BASE_NUMBER_FIRST_NUMBER_DECIMAL_PART
                                ADDA COUNTER_BASE_NUMBER_SECOND_NUMBER_DECIMAL_PART 
                                CMPA #3
                                BEQ  MULTIPLY_10_BASE_1
                                BRA  BASE_1_OR_BASE_2_ADDITION
                                
                           MULTIPLY_10_BASE_1:
                                     ;1.sayinin decimal basamak degeri 1 ise 1.sayinin decimal degerini 10 ile carp.                                    
                                     LDAA COUNTER_BASE_NUMBER_FIRST_NUMBER_DECIMAL_PART
                                     CMPA #2
                                     BLT  FIRST_NUMBER_DECIMAL_PART_MULTIPLY_10
                                     BRA  SECOND_NUMBER_DECIMAL_PART_MULTIPLY_10
                              
                              
                               FIRST_NUMBER_DECIMAL_PART_MULTIPLY_10:
                                     LDAA #10
                                     LDAB DECIMAL_PART_1_BASE
                                     MUL
                                     STAB EXTENDED_DECIMAL_PART_BASE_1_TO_BASE_2    ;2 basamaga genisletilmis sayi
                                     
                                    
                                     LDAA SECOND_NUM_DECIMAL_PART_2_BASE            ;sayilarin decimal kisimlarini topla
                                     ABA
                                     
                                     CMPA #100                                      ;decimal toplam sonucu 100'den kucukse sonuc degerini koy,
                                     BLT PRINT_RESULT_DECIMAL_PART_BASE_1           ;100'den buyukse 2 basamakli olmasi icin 100 cikar.
                                     BRA SUB_100_THEN_PRINT_DECIMAL_PART_BASE_1
                                     
                                     PRINT_RESULT_DECIMAL_PART_BASE_1:
                                      STAA RESULT_DECIMAL_PART                      ;Sonucu $1501 adresine yaz.
                                      JMP  INTEGER_NUMBERS_OPERATION
                                     
                                     SUB_100_THEN_PRINT_DECIMAL_PART_BASE_1:
                                      SUBA #100
                                      STAA RESULT_DECIMAL_PART                       ;Sonucu $1501 adresine yaz.
                                      JMP  INTEGER_NUMBERS_OPERATION
                                    
                              
                               SECOND_NUMBER_DECIMAL_PART_MULTIPLY_10:              ;2.sayinin decimal basamak sayisini 2 basamaga cikarma
                                     LDAA #10                                       ;
                                     LDAB SECOND_NUM_DECIMAL_PART_1_BASE
                                     MUL
                                     STAB EXTENDED_DECIMAL_PART_BASE_1_TO_BASE_2
                           
                                     LDAA DECIMAL_PART_2_BASE
                                     ABA 
                                     
                                     CMPA #100
                                     BLT PRINT_RESULT_DECIMAL_PART
                                     BRA SUB_100_THEN_PRINT_DECIMAL_PART
                                     
                                     PRINT_RESULT_DECIMAL_PART:
                                      STAA RESULT_DECIMAL_PART
                                      JMP  INTEGER_NUMBERS_OPERATION
                                     
                                     SUB_100_THEN_PRINT_DECIMAL_PART:
                                      SUBA #100
                                      STAA RESULT_DECIMAL_PART
                                      JMP  INTEGER_NUMBERS_OPERATION

                              BASE_1_OR_BASE_2_ADDITION:                      ;1.ve 2.sayinin decimal basamak degerleri toplami 2 ise
                                                                              ;decimal 1 basamak degerlerini topla
                                                                              ;degilse decimal 2 basamak degerlerini topla
                                     LDAA COUNTER_BASE_NUMBER_FIRST_NUMBER_DECIMAL_PART
                                     ADDA COUNTER_BASE_NUMBER_SECOND_NUMBER_DECIMAL_PART 
                                     CMPA #2
                                     BEQ BASE_1_ADDITION
                                     BRA BASE_2_ADDITION

                              BASE_1_ADDITION:
                              
                                      LDAA  DECIMAL_PART_1_BASE                       ;Sayilarin 1 basamakli decimal kisimlarini topla
                                      ADDA  SECOND_NUM_DECIMAL_PART_1_BASE
 
                                      CMPA  #10                                       ;Toplam 10'dan kucukse toplam sonucunu koy
                                      BLT   PUT_RESULT_DECIMAL_1_BASE                 ;degilse 1 basamakli olmasi icin toplamdan 10 cikar
                                      BRA   SUB_10_FROM_DECIMAL_PART                  
                                      
                                      
                                      PUT_RESULT_DECIMAL_1_BASE:
                                        STAA RESULT_DECIMAL_PART
                                        JMP   INTEGER_NUMBERS_OPERATION
                                      
                                      SUB_10_FROM_DECIMAL_PART:
                                        SUBA #10
                                        STAA RESULT_DECIMAL_PART
                                        JMP  INTEGER_NUMBERS_OPERATION 
                                      
                                      
                              
                              BASE_2_ADDITION:

                                      LDAA  DECIMAL_PART_2_BASE                      ;Sayilarin 2 basamakli decimal kisimlarini topla
                                      ADDA  SECOND_NUM_DECIMAL_PART_2_BASE
                                      

                                      CMPA  #99                                      ;Toplam 100'dan kucukse toplam sonucunu koy
                                      LBLO  PUT_RESULT_DECIMAL_2_BASE                ;degilse 2 basamakli olmasi icin toplamdan 100 cikar
                                      LBHI  SUB_100_FROM_DECIMAL_PART
                                      
                                      
                                      PUT_RESULT_DECIMAL_2_BASE:
                                        STAA  RESULT_DECIMAL_PART
                                        JMP   INTEGER_NUMBERS_OPERATION
                                      
                                      SUB_100_FROM_DECIMAL_PART:
                                        SUBA #100
                                        STAA RESULT_DECIMAL_PART
                                        JMP  INTEGER_NUMBERS_OPERATION 
                               
                                 
                                
                          ;ADD INTEGER NUMBERS                                      ;Sayilarin integer kisimlarinin toplanmasi
                          INTEGER_NUMBERS_OPERATION:
                                
                               LDAA COUNTER_BASE_NUMBER_FIRST_NUMBER_INTEGER_PART   ;1.sayinin integer kisminin basamak degeri 1 ise
                               CMPA #1                                              ;1.sayinin 1 basamakli integer kismini al,diger sayiya gec
                               BEQ GET_INTEGER_PART_1_BASE                          ;1 degilse 2 basamakli kismini al,diger sayiya gec
                               BRA GET_INTEGER_PART_2_BASE
     
     
     
                          GET_INTEGER_PART_1_BASE:
                                LDAA INTEGER_PART_1_BASE
                                JMP  GET_NEXT_INTEGER_NUMBER
                                
                          GET_INTEGER_PART_2_BASE:
                                CMPA #2
                                BEQ PUT_INTEGER_PART_2_BASE                          ;1.sayinin integer kisminin basamak degeri 2 de degilse
                                BRA GET_INTEGER_PART_3_BASE                          ;3 basamakli kismini al, diger sayiya gec
                                
                          PUT_INTEGER_PART_2_BASE:
                                LDAA  INTEGER_PART_2_BASE     
                                JMP  GET_NEXT_INTEGER_NUMBER
                                
                          GET_INTEGER_PART_3_BASE:
                                LDAA  INTEGER_PART_3_BASE 
                                JMP  GET_NEXT_INTEGER_NUMBER
                                
                                
                          GET_NEXT_INTEGER_NUMBER:                    ;1.sayi integer kismin alinmasi icin yapilan adimlari tekrarla.
                                
                                LDAB COUNTER_BASE_NUMBER_SECOND_NUMBER_INTEGER_PART 
                                CMPB #1
                                BEQ GET_SECOND_NUM_INTEGER_PART_1_BASE
                                BRA GET_SECOND_NUM_INTEGER_PART_2_BASE
                          
                          
                          GET_SECOND_NUM_INTEGER_PART_1_BASE:
                                
                                LDAB SECOND_NUM_INTEGER_PART_1_BASE
                                JMP  ADD_INTEGER_NUMBERS
                           
                          GET_SECOND_NUM_INTEGER_PART_2_BASE:
                                CMPB #2
                                BEQ  PUT_SECOND_NUM_INTEGER_PART_2_BASE
                                BRA  GET_SECOND_NUM_INTEGER_PART_3_BASE
                              
                              
                          PUT_SECOND_NUM_INTEGER_PART_2_BASE:  
                                LDAB SECOND_NUM_INTEGER_PART_2_BASE
                                JMP  ADD_INTEGER_NUMBERS
                          
                          GET_SECOND_NUM_INTEGER_PART_3_BASE:
                                LDAB SECOND_NUM_INTEGER_PART_3_BASE
                                JMP  ADD_INTEGER_NUMBERS
                                
                          
                          ADD_INTEGER_NUMBERS:                            ;Sayilarin alinan integer degerlerini topla
                                ABA
                                STAA RESULT_INTEGER_PART                  ;Sonucu verilen adrese ($1500) yaz

                                LDAA DECIMAL_PART_2_BASE
                                ADDA SECOND_NUM_DECIMAL_PART_2_BASE
                                CMPA #100                                  ;Decimal kisimlarin toplam sonucu 100'den buyukse
                                LBLO EXITPROGRAM                           ;2 basamakli gostermek icin,toplamdan 100 cikar
                                LBHI ADD_ONE_TO_RESULT_INTEGER_PART        ;eldeki 1 degerini integer toplam sonucuna ekle
                                
                               
                                EXITPROGRAM:
                                 JMP END_PROGRAM

                                ADD_ONE_TO_RESULT_INTEGER_PART:
                                  INC RESULT_INTEGER_PART
                                  JMP END_PROGRAM
                          
;******************************** END ADDITION OPERATIONS *******************
                                
                                
                          OPERATION_SUB:                                            ;Toplama islemi icin yapilan adimlari kismen tekrarla
                                
                                LDAA COUNTER_BASE_NUMBER_FIRST_NUMBER_DECIMAL_PART       ;Decimal kisimlarin toplam basamak sayisi 3 ise
                                ADDA COUNTER_BASE_NUMBER_SECOND_NUMBER_DECIMAL_PART      ;1 basamakli olani 2 basamaga genislet
                                CMPA #3
                                BEQ  MULTIPLY_10_BASE_1_SUB
                                BRA  BASE_1_OR_BASE_2_SUB
                                
                           MULTIPLY_10_BASE_1_SUB:
                                     LDAA COUNTER_BASE_NUMBER_FIRST_NUMBER_DECIMAL_PART     ;1.sayinin decimal basamak degeri 1 ise genislet
                                     CMPA #2                                                ;degilse 2.sayinin decimal degerini genislet
                                     BLT  FIRST_NUMBER_DECIMAL_PART_MULTIPLY_10_SUB
                                     BRA  SECOND_NUMBER_DECIMAL_PART_MULTIPLY_10_SUB
                              
                              
                              FIRST_NUMBER_DECIMAL_PART_MULTIPLY_10_SUB:
                                     LDAA #10                                              ;1.sayinin genisletilen decimal degerini tut
                                     LDAB DECIMAL_PART_1_BASE
                                     MUL
                                     STAB EXTENDED_DECIMAL_PART_BASE_1_TO_BASE_2_SUB
                                     
                                    
                                     LDAA EXTENDED_DECIMAL_PART_BASE_1_TO_BASE_2_SUB       ;1.sayinin yeni decimal degerinden 2.sayinin decimal degerini cikar
                                     SUBA SECOND_NUM_DECIMAL_PART_2_BASE

                                     STAA RESULT_DECIMAL_PART                              ;Sonucu verilen adrese ($1501) koy
                                     JMP  INTEGER_NUMBERS_OPERATION_SUB                    ;Integer kisimlarini cikarma islemine git
                                    
                               
                              SECOND_NUMBER_DECIMAL_PART_MULTIPLY_10_SUB:
                              
                                     LDAA SECOND_NUM_DECIMAL_PART_1_BASE                   ;2.sayinin 1 basamakli decimal degeri
                                     CMPA DECIMAL_PART_2_BASE                              ;1.sayinin 2 basamakli degerinden kucukse geni?letme yap
                                     BLT  EXTEND_OPERATION                                 ;degilse yapma
                                     BRA  NO_EXTEND_OPERATION
                                     
                                     
                                     EXTEND_OPERATION:
                                       LDAA #10
                                       LDAB SECOND_NUM_DECIMAL_PART_1_BASE                  ;2.sayinin 1 basamakli decimal degerini 2 basamakli yap
                                       MUL
                                       STAB EXTENDED_DECIMAL_PART_BASE_1_TO_BASE_2_SUB
                           
                                       LDAA DECIMAL_PART_2_BASE                             ;1.sayinin 2 basamakli decimal degerine 100 ekle
                                       ADDA #100                                            ;2.sayinin geni?letilen decimal degerinden cikar
                                       SUBA EXTENDED_DECIMAL_PART_BASE_1_TO_BASE_2_SUB 
                                     
                                       MOVB #$FF,FLAG_MINUS_1                               ;integer kisim farklarindan 1 cikarilmasi için
                                       STAA RESULT_DECIMAL_PART                             ;flag'e (-1) koy
                                       JMP  INTEGER_NUMBERS_OPERATION_SUB
                                                                                            ;Integer kisim cikarma islemine git
                                     NO_EXTEND_OPERATION:
                                         JMP  INTEGER_NUMBERS_OPERATION_SUB
                                         

                              BASE_1_OR_BASE_2_SUB:
                       
                                                                                             ;1.ve 2.sayinin decimal basamak degeri toplami 2 ise
                                     LDAA COUNTER_BASE_NUMBER_FIRST_NUMBER_DECIMAL_PART      ;1 basamakli decimal degerleri cikarma islemi yap
                                     ADDA COUNTER_BASE_NUMBER_SECOND_NUMBER_DECIMAL_PART     ;degilse 2 basamakli decimal degerleri cikarma islemi yap
                                     CMPA #2
                                     BEQ BASE_1_SUB
                                     BRA BASE_2_SUB

                              BASE_1_SUB:
                                                                                            ;1.sayinin 1 basamakli decimal degeri
                                     LDAA  DECIMAL_PART_1_BASE                              ;2.sayinin 1 basamakli decimal degerinden kucukse sayiya 10 ekle
                                                                                            ;degilse 1 basamakli decimal degeri kullan
                                     

                                     CMPA  SECOND_NUM_DECIMAL_PART_1_BASE
                                     LBLO  ADD_10_DECIMAL_1_BASE_SUB 
                                     LBHI  PUT_RESULT_DECIMAL_1_BASE_SUB
                                      
                                      
                                     PUT_RESULT_DECIMAL_1_BASE_SUB:
                                        JMP   INTEGER_NUMBERS_OPERATION_SUB
                                      
                                     ADD_10_DECIMAL_1_BASE_SUB:
                                        LDAA DECIMAL_PART_1_BASE                            ;10 eklenen decimal degerden 2.sayinin 1 basamakli degerini cikar
                                        ADDA #10
                                        SUBA SECOND_NUM_DECIMAL_PART_1_BASE
                                      
                                        STAA RESULT_DECIMAL_PART                            ;Sonucu yaz
                                        
                                                                                             
                                        JMP  INTEGER_NUMBERS_OPERATION_SUB                  ;Integer kisimlari cikarmaya git
                                        
                              
                              BASE_2_SUB:

                                      LDAA  DECIMAL_PART_2_BASE                             ;1.sayinin 2 basamakli decimal degerinden
                                      SUBA  SECOND_NUM_DECIMAL_PART_2_BASE                  ;2.sayinin 2 basamakli decimal degerini cikar
                                      
                                      STAA RESULT_DECIMAL_PART                              ;Sonucu yaz
                                      JMP  INTEGER_NUMBERS_OPERATION_SUB                    ;Integer kisimlari cikarmaya git
                               
                                 
                                
                          ;SUB INTEGER NUMBERS   
                          INTEGER_NUMBERS_OPERATION_SUB:                                     ;Sayilarin integer kisimlarinin cikarilmasi
                                
                               LDAA COUNTER_BASE_NUMBER_FIRST_NUMBER_INTEGER_PART 
                               CMPA #1                                                       ;1.sayinin integer kisminin basamak sayisi 1 ise, 1 basamakli degeri al
                               BEQ GET_INTEGER_PART_1_BASE_SUB                               ;1.sayinin integer kisminin basamak sayisi 2 ise, 2 basamakli degeri al
                               BRA GET_INTEGER_PART_2_BASE_SUB                               ;1.sayinin integer kisminin basamak sayisi 3 ise, 3 basamakli degeri al
                                                                                             ;sonra diger sayiya gec
     
     
                          GET_INTEGER_PART_1_BASE_SUB:
                                LDAA INTEGER_PART_1_BASE
                                JMP  GET_NEXT_INTEGER_NUMBER_SUB
                                
                          GET_INTEGER_PART_2_BASE_SUB:
                                CMPA #2
                                BEQ PUT_INTEGER_PART_2_BASE_SUB
                                BRA GET_INTEGER_PART_3_BASE_SUB 
                                
                          PUT_INTEGER_PART_2_BASE_SUB:
                                LDAA  INTEGER_PART_2_BASE     
                                JMP   GET_NEXT_INTEGER_NUMBER_SUB
                                                                                                    
                          GET_INTEGER_PART_3_BASE_SUB:
                                LDAA  INTEGER_PART_3_BASE 
                                JMP   GET_NEXT_INTEGER_NUMBER_SUB
                                     
                                
                          GET_NEXT_INTEGER_NUMBER_SUB:                                     ;2.sayinin integer kisminin basamak sayisi 1 ise, 1 basamakli degeri al
                                                                                           ;2.sayinin integer kisminin basamak sayisi 2 ise, 2 basamakli degeri al
                                LDAB COUNTER_BASE_NUMBER_SECOND_NUMBER_INTEGER_PART        ;2.sayinin integer kisminin basamak sayisi 3 ise, 3 basamakli degeri al  
                                CMPB #1                                                    ;sonra integer kisimlar cikarma islemine git
                                BEQ GET_SECOND_NUM_INTEGER_PART_1_BASE_SUB
                                BRA GET_SECOND_NUM_INTEGER_PART_2_BASE_SUB
                          
                          
                          GET_SECOND_NUM_INTEGER_PART_1_BASE_SUB:
                                
                                LDAB SECOND_NUM_INTEGER_PART_1_BASE
                                JMP  SUB_INTEGER_NUMBERS
                           
                          GET_SECOND_NUM_INTEGER_PART_2_BASE_SUB:
                                CMPB #2
                                BEQ  PUT_SECOND_NUM_INTEGER_PART_2_BASE_SUB
                                BRA  GET_SECOND_NUM_INTEGER_PART_3_BASE_SUB
                              
                              
                          PUT_SECOND_NUM_INTEGER_PART_2_BASE_SUB:  
                                LDAB SECOND_NUM_INTEGER_PART_2_BASE
                                JMP  SUB_INTEGER_NUMBERS
                          
                          GET_SECOND_NUM_INTEGER_PART_3_BASE_SUB:
                                LDAB SECOND_NUM_INTEGER_PART_3_BASE
                                JMP  SUB_INTEGER_NUMBERS
                                
                          
                          ; SUBTRACTION OPERATIONS TO INTEGER PARTS
                          SUB_INTEGER_NUMBERS:
                          
                                STAA TEMP_FIRST_NUMBER  ;INTEGER 1                    ;Alinan integer degerleri tut
                                STAB TEMP_SECOND_NUMBER ;INTEGER 2
                                
                                
                                LDAA COUNTER_BASE_NUMBER_FIRST_NUMBER_DECIMAL_PART    ;Decimal basamak degerler toplami 3 ise
                                ADDA COUNTER_BASE_NUMBER_SECOND_NUMBER_DECIMAL_PART
                                CMPA #3
                                BEQ  DEC_1_SUB_SEC_DEC_2
                                BRA  OTHER_PARTS
                                
                                
                    
                                
                                DEC_1_SUB_SEC_DEC_2:
                                
                                LDAA EXTENDED_DECIMAL_PART_BASE_1_TO_BASE_2_SUB       ;Genisletilen basamak degeri 
                                CMPA DECIMAL_PART_2_BASE                              ;1.sayinin 2 basamakli decimal degerinden kucukse
                                BLT  SUB_1_FROM_INTEGER_PART                          
                                BRA  OTHER_NUMBER
                                
                                SUB_1_FROM_INTEGER_PART:                              ;1.sayidan genisletilen degeri cikar
                                  LDAA TEMP_FIRST_NUMBER
                                  SUBA EXTENDED_DECIMAL_PART_BASE_1_TO_BASE_2_SUB
                                  
                                  CMPA #0
                                  BLT  SUB_1_RESULT_INTEGER_PART                      ;sonuc 0'dan kucukse, integer kisim farkindan 1 cikar
                                  BRA  OTHER_NUMBER                                   
                                  
                                  
                                  SUB_1_RESULT_INTEGER_PART:
                                    LDAA TEMP_FIRST_NUMBER
                                    SUBA TEMP_SECOND_NUMBER 
                                    DECA
                                    STAA RESULT_INTEGER_PART
                                    JMP  END_PROGRAM
                                
                                
                                OTHER_NUMBER:                                         ;Flag -1 ise  integer kisim farkindan 1 cikar
                                                                                      ;degilse direkt sonuclari cikar
                                  LDAA FLAG_MINUS_1
                                  CMPA #$FF
                                  BEQ  SUB_1
                                  BRA  DEVAM
                                  
                                  SUB_1:
                                     LDAA TEMP_FIRST_NUMBER
                                     SUBA TEMP_SECOND_NUMBER
                                     DECA
                                     STAA RESULT_INTEGER_PART
                                     JMP END_PROGRAM
                                  
                                  DEVAM:  
                                    LDAA TEMP_FIRST_NUMBER
                                    SUBA TEMP_SECOND_NUMBER
                                    STAA RESULT_INTEGER_PART  
                                    JMP END_PROGRAM
                                
                
                                  
                                OTHER_PARTS:
                                     
                                LDAA COUNTER_BASE_NUMBER_FIRST_NUMBER_DECIMAL_PART             ;Decimal basamak degerler toplamy 2 ise
                                ADDA COUNTER_BASE_NUMBER_SECOND_NUMBER_DECIMAL_PART            ;1.basamakli decimal degerlerine bak,
                                CMPA #2                                                        ;degilse 4'tur. 2 basamakli decimal degerlere bak
                                BEQ BASE_1_SUBTRACTION  
                                BRA BASE_2_SUBTRACTION
                                
                                BASE_1_SUBTRACTION:                                            ;2.sayinin 1 basamakli decimal degeri
                                                                                               ;1.sayinin 1 basamakli decimal degerinden kucukse
                                  LDAA SECOND_NUM_DECIMAL_PART_1_BASE                          ;direkt integer kisim cikarmasi yap
                                  CMPA DECIMAL_PART_1_BASE                                     
                                  BLT  PRINT_RESULT                                            ;Integer kisim farkini yaz,
                                  BRA  SUB_1_FROM_INTEGER_PART_BASE_1                          ;degilse integer kisim farkindan 1 cikar
                                
                                 
                                  PRINT_RESULT:
                                        LDAA TEMP_FIRST_NUMBER
                                        SUBA TEMP_SECOND_NUMBER
                                        STAA RESULT_INTEGER_PART
                                        JMP END_PROGRAM

                                  SUB_1_FROM_INTEGER_PART_BASE_1:                              ;2.sayinin 1 basamakli decimal degeri
                                        LDAA TEMP_FIRST_NUMBER                                 ;1.sayinin 1 basamakli degerinden buyukse
                                        SUBA TEMP_SECOND_NUMBER                                ;integer kisimdan 1 cikar
                                        DECA
                                        STAA RESULT_INTEGER_PART
                                        JMP END_PROGRAM
                                  
                      
                                  BASE_2_SUBTRACTION:                                         ;2 basamakli decimal degerler icin direkt integer kisim cikarma
                                        LDAA TEMP_FIRST_NUMBER
                                        SUBA TEMP_SECOND_NUMBER
                                        STAA RESULT_INTEGER_PART
                                        JMP END_PROGRAM
                                
                                
                                
                                
;******************** END SUBTRACTION OPERATIONS *******************    
                                
                                  
;*********************** FIRST PART ************************* 
                                                                                ;1.sayinin integer kisminin hesaplanmasi
ONE_TWO_THREE_BASE_OPERATION:                                                   ;Hexadecimal degerleri koyulan yerlerden al,
                                                                                ;decimal degerlere cevir
                 CMPA #1                                                        ;basamak sayisina gore basamak sayaclarina koy
                 BEQ ONE_BASE_OPERATION
                 BRA TWO_BASE_OPERATION
   
   
ONE_BASE_OPERATION:

                  LDAB $2003                                                     ;1 basamakli degerse, 
                  JSR HEX_TO_DECIMAL                                             ;Hexadecimal degeri decimal degere cevir
                  STAB INTEGER_PART_1_BASE                                       ;1.sayinin 1 basamakli integer degerini tut
                  MOVB #1,COUNTER_BASE_NUMBER_FIRST_NUMBER_INTEGER_PART          ;1.sayinin basamak degeri icin sayaca 1 koy
                  JMP SECOND_PART
                
 
TWO_BASE_OPERATION:
                                                                                 ;2 basamakli degerse ilk basamak degerini 10 ile carp,
                  CMPA #2                                                        ;diger basamak degerine ekle,
                  BEQ TWO_BASE_OPERATION_PUT_NUMBER                              
                  BRA THREE_BASE_OPERATION 
                  
TWO_BASE_OPERATION_PUT_NUMBER:
                  
                  LDAB $2003
                  JSR  HEX_TO_DECIMAL
                  LDAA #10
                  MUL
                  STAB $2003
                  
                  LDAB $2004
                  JSR HEX_TO_DECIMAL
                  STAB $2004 

                  LDAA $2003
                  ADDA $2004
                                                                                
                  STAA INTEGER_PART_2_BASE                                      ;2.sayinin 2 basamakli integer degerini tut
                  MOVB #2,COUNTER_BASE_NUMBER_FIRST_NUMBER_INTEGER_PART         ;basamak sayacina 2 koy
                  JMP SECOND_PART                                               ;1.sayinin decimal kismina bakmaya git
                 
THREE_BASE_OPERATION:
                                                                                ;3 basamakli degerse 1. basamak degerini 100 ile carp 
                  LDAB $2003                                                    ;2.basamak degerini 10 ile carp
                  JSR  HEX_TO_DECIMAL                                           ;3. basamak degerine ekle
                  LDAA #100                                                     
                  MUL
                  STAB $2003
                  
                  LDAB $2004
                  JSR  HEX_TO_DECIMAL
                  LDAA #10
                  MUL
                  STAB $2004


                  LDAB $2005
                  JSR  HEX_TO_DECIMAL
                  STAB $2005
                  
                  LDAA $2003
                  ADDA $2004
                  ADDA $2005
                                                                                
                  STAA INTEGER_PART_3_BASE                                     ;1.sayinin 3 basamakli decimal degerini tut
                  MOVB #3,COUNTER_BASE_NUMBER_FIRST_NUMBER_INTEGER_PART        ;Basamak sayacina 3 koy
                  JMP  SECOND_PART
                                    
;*********************** FIRST PART *************************                        
                      
                      
                      
;*********************** SECOND PART *************************                 ;1.sayinin decimal kisminin hesaplanmasi

ONE_TWO_BASE_OPERATION_1:
                                                                               ;Hexadecimal degerleri koyulan yerlerden al,
                 CMPA #1                                                       ;decimal degerlere cevir
                 BEQ ONE_BASE_OPERATION_1                                      ;basamak sayisina gore basamak sayaclarina koy
                 BRA TWO_BASE_OPERATION_1
   
   
ONE_BASE_OPERATION_1:                                                          ;1 basamakli degerse,
                                                                               
                  LDAB $200A                                                   ;Hexadecimal degeri decimal degere cevir
                  JSR HEX_TO_DECIMAL
                  STAB DECIMAL_PART_1_BASE                                     ;1.sayinin 1 basamakli decimal degerini tut
                  MOVB #1,COUNTER_BASE_NUMBER_FIRST_NUMBER_DECIMAL_PART        ;1.sayinin basamak degeri icin sayaca 1 koy
                  JMP THIRD_PART
                
 
TWO_BASE_OPERATION_1:
                                                                               ;2 basamakli degerse ilk basamak degerini 10 ile carp,
                  CMPA #2                                                      ;diger basamak degerine ekle
                  BEQ TWO_BASE_OPERATION_PUT_NUMBER_1                          ;2.sayinin integer kismina bakmaya git
                  JMP THIRD_PART
                  
TWO_BASE_OPERATION_PUT_NUMBER_1:
                  
                  LDAB $200A
                  JSR  HEX_TO_DECIMAL
                  LDAA #10
                  MUL
                  STAB $200A
                  
                  LDAB $200B
                  JSR HEX_TO_DECIMAL
                  STAB $200B 

                  LDAA $200A
                  ADDA $200B
                                                                              
                  STAA DECIMAL_PART_2_BASE                                    ;1.sayinin 2 basamakli decimal degerini tut
                  MOVB #2,COUNTER_BASE_NUMBER_FIRST_NUMBER_DECIMAL_PART       ;basamak sayacina 2 koy
                  JMP THIRD_PART                                              ;2.sayinin integer kismina bakmaya git

;*********************** SECOND PART ************************* 

                                      
 
 
;*********************** FOURTH PART *************************                


ONE_TWO_THREE_BASE_OPERATION_SECOND_NUM:                                     ;2.sayinin integer kisminin hesaplanmasi
                 CMPA #1                                                     
                 BEQ ONE_BASE_OPERATION_SECOND_NUM
                 BRA TWO_BASE_OPERATION_SECOND_NUM                           ;Yapilan adimlar 1.sayinin integer kisminin hesabi ile aynidir
   
   
ONE_BASE_OPERATION_SECOND_NUM:
                  LDAB $2010
                  JSR HEX_TO_DECIMAL
                  STAB SECOND_NUM_INTEGER_PART_1_BASE
                  MOVB #1,COUNTER_BASE_NUMBER_SECOND_NUMBER_INTEGER_PART  
                  JMP FIFTH_PART
                
 
TWO_BASE_OPERATION_SECOND_NUM:
                 
                  CMPA #2
                  BEQ TWO_BASE_OPERATION_PUT_NUMBER_SECOND_NUM
                  BRA THREE_BASE_OPERATION_SECOND_NUM 
                  
TWO_BASE_OPERATION_PUT_NUMBER_SECOND_NUM:
                  
                  LDAB $2010
                  JSR  HEX_TO_DECIMAL
                  LDAA #10
                  MUL
                  STAB $2010
                  
                  LDAB $2011
                  JSR HEX_TO_DECIMAL
                  STAB $2011 

                  LDAA $2010
                  ADDA $2011
            
                  STAA SECOND_NUM_INTEGER_PART_2_BASE
                  MOVB #2,COUNTER_BASE_NUMBER_SECOND_NUMBER_INTEGER_PART  
                  JMP FIFTH_PART
                 
THREE_BASE_OPERATION_SECOND_NUM:

                  LDAB $2010
                  JSR  HEX_TO_DECIMAL
                  LDAA #100
                  MUL
                  STAB $2010
                  
                  LDAB $2011
                  JSR  HEX_TO_DECIMAL
                  LDAA #10
                  MUL
                  STAB $2011


                  LDAB $2012
                  JSR  HEX_TO_DECIMAL
                  STAB $2012
                  
                  LDAA $2010
                  ADDA $2011
                  ADDA $2012
             
                  STAA SECOND_NUM_INTEGER_PART_3_BASE
                  MOVB #3,COUNTER_BASE_NUMBER_SECOND_NUMBER_INTEGER_PART  
                  JMP FIFTH_PART


;*********************** FOURTH PART *************************    
 
           

;*********************** FIFTH PART *************************   
  
ONE_TWO_BASE_OPERATION_2:                                                   ;2.sayinin decimal kisminin hesaplanmasi

                 CMPA #2                                                    ;Yapilan adimlar 1.sayinin decimal kisminin hesabi ile aynidir
                 BLT ONE_BASE_OPERATION_2
                 BRA TWO_BASE_OPERATION_2
   
   
ONE_BASE_OPERATION_2:

                  LDAB $2017
                  JSR HEX_TO_DECIMAL
                  STAB SECOND_NUM_DECIMAL_PART_1_BASE 
                  MOVB #1,COUNTER_BASE_NUMBER_SECOND_NUMBER_DECIMAL_PART
                  JMP ADD_OR_SUB_PART
                
 
TWO_BASE_OPERATION_2:
                 
                  CMPA #2
                  BEQ TWO_BASE_OPERATION_PUT_NUMBER_2
                  JMP ADD_OR_SUB_PART
                  
TWO_BASE_OPERATION_PUT_NUMBER_2:
                  
                  LDAB $2017
                  JSR  HEX_TO_DECIMAL
                  LDAA #10
                  MUL
                  STAB $2017
                  
                  LDAB $2018
                  JSR HEX_TO_DECIMAL
                  STAB $2018

                  LDAA $2017
                  ADDA $2018
            
                  STAA SECOND_NUM_DECIMAL_PART_2_BASE 
                  MOVB #2,COUNTER_BASE_NUMBER_SECOND_NUMBER_DECIMAL_PART 
                  JMP ADD_OR_SUB_PART

;*********************** FIFTH PART *************************   


;********* SUBROUTINE CONVERT HEXADECIMAL TO DECIMAL ********               
                                                                           
HEX_TO_DECIMAL:          
                                                                           ;Subroutine
            CMPB #$31
            BLT  MOVE_0                                                    ;Hexadecimal degerlerin decimal degerlere donusturulmesi
            BRA  MOVE_1
                       
MOVE_0:
            MOVB #0,TEMP1
            JMP EXIT 
            
MOVE_1:
            CMPB #$32
            BLT MOVE_1_PUT
            BRA MOVE_2
MOVE_1_PUT:
            MOVB #1,TEMP1
            JMP EXIT                                   
MOVE_2:                 
            CMPB #$33
            BLT MOVE_2_PUT
            BRA MOVE_3           
MOVE_2_PUT:
            MOVB #2,TEMP1
            JMP EXIT                                   
MOVE_3:                      
            CMPB #$34
            BLT MOVE_3_PUT
            BRA MOVE_4
MOVE_3_PUT:
            MOVB #3,TEMP1
            JMP EXIT                                          
MOVE_4:                
            CMPB #$35
            BLT MOVE_4_PUT
            BRA MOVE_5            
MOVE_4_PUT:
            MOVB #4,TEMP1
            JMP EXIT            
MOVE_5:                      
            CMPB #$36
            BLT MOVE_5_PUT
            BRA MOVE_6             
MOVE_5_PUT:
            MOVB #5,TEMP1
            JMP EXIT            
MOVE_6:                  
            CMPB #$37
            BLT MOVE_6_PUT
            BRA MOVE_7
MOVE_6_PUT:
            MOVB #6,TEMP1
            JMP EXIT                        
MOVE_7:                 
            CMPB #$38
            BLT MOVE_7_PUT
            BRA MOVE_8
MOVE_7_PUT:
            MOVB #7,TEMP1
            JMP EXIT                                                
MOVE_8:                
            CMPB #$39
            BLT MOVE_8_PUT
            BRA MOVE_9_PUT 
MOVE_8_PUT:
            MOVB #8,TEMP1
            JMP EXIT                                    
MOVE_9_PUT:                 
            MOVB #9,TEMP1                          
EXIT:
            LDAB TEMP1
            RTS      

;********* SUBROUTINE CONVERT HEXADECIMAL TO DECIMAL ********   

END_PROGRAM:
            SWI
  
               
                                            
;**************************************************************
;*                 Interrupt Vectors                          *
;**************************************************************
            ORG   $FFFE
            DC.W  Entry           ; Reset Vector
