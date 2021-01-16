unit stm32f378xx;
interface
{$PACKRECORDS C}
{$GOTO ON}
{$SCOPEDENUMS ON}

type
  TIRQn_Enum = (
    NonMaskableInt_IRQn = -14,        
    HardFault_IRQn = -13,             
    MemoryManagement_IRQn = -12,      
    BusFault_IRQn = -11,              
    UsageFault_IRQn = -10,            
    SVCall_IRQn = -5,                 
    DebugMonitor_IRQn = -4,           
    PendSV_IRQn = -2,                 
    SysTick_IRQn = -1,                
    WWDG_IRQn   = 0,                  
    TAMP_STAMP_IRQn = 2,              
    RTC_WKUP_IRQn = 3,                
    FLASH_IRQn  = 4,                  
    RCC_IRQn    = 5,                  
    EXTI0_IRQn  = 6,                  
    EXTI1_IRQn  = 7,                  
    EXTI2_TSC_IRQn = 8,               
    EXTI3_IRQn  = 9,                  
    EXTI4_IRQn  = 10,                 
    DMA1_Channel1_IRQn = 11,          
    DMA1_Channel2_IRQn = 12,          
    DMA1_Channel3_IRQn = 13,          
    DMA1_Channel4_IRQn = 14,          
    DMA1_Channel5_IRQn = 15,          
    DMA1_Channel6_IRQn = 16,          
    DMA1_Channel7_IRQn = 17,          
    ADC1_IRQn   = 18,                 
    CAN_TX_IRQn = 19,                 
    CAN_RX0_IRQn = 20,                
    CAN_RX1_IRQn = 21,                
    CAN_SCE_IRQn = 22,                
    EXTI9_5_IRQn = 23,                
    TIM15_IRQn  = 24,                 
    TIM16_IRQn  = 25,                 
    TIM17_IRQn  = 26,                 
    TIM18_DAC2_IRQn = 27,             
    TIM2_IRQn   = 28,                 
    TIM3_IRQn   = 29,                 
    TIM4_IRQn   = 30,                 
    I2C1_EV_IRQn = 31,                
    I2C1_ER_IRQn = 32,                
    I2C2_EV_IRQn = 33,                
    I2C2_ER_IRQn = 34,                
    SPI1_IRQn   = 35,                 
    SPI2_IRQn   = 36,                 
    USART1_IRQn = 37,                 
    USART2_IRQn = 38,                 
    USART3_IRQn = 39,                 
    EXTI15_10_IRQn = 40,              
    RTC_Alarm_IRQn = 41,              
    CEC_IRQn    = 42,                 
    TIM12_IRQn  = 43,                 
    TIM13_IRQn  = 44,                 
    TIM14_IRQn  = 45,                 
    TIM5_IRQn   = 50,                 
    SPI3_IRQn   = 51,                 
    TIM6_DAC1_IRQn = 54,              
    TIM7_IRQn   = 55,                 
    DMA2_Channel1_IRQn = 56,          
    DMA2_Channel2_IRQn = 57,          
    DMA2_Channel3_IRQn = 58,          
    DMA2_Channel4_IRQn = 59,          
    DMA2_Channel5_IRQn = 60,          
    SDADC1_IRQn = 61,                 
    SDADC2_IRQn = 62,                 
    SDADC3_IRQn = 63,                 
    COMP_IRQn   = 64,                 
    TIM19_IRQn  = 78,                 
    FPU_IRQn    = 81                  
  );

  TADC_Registers = record
    SR          : longword;
    CR1         : longword;
    CR2         : longword;
    SMPR1       : longword;
    SMPR2       : longword;
    JOFR1       : longword;
    JOFR2       : longword;
    JOFR3       : longword;
    JOFR4       : longword;
    HTR         : longword;
    LTR         : longword;
    SQR1        : longword;
    SQR2        : longword;
    SQR3        : longword;
    JSQR        : longword;
    JDR1        : longword;
    JDR2        : longword;
    JDR3        : longword;
    JDR4        : longword;
    DR          : longword;
  end;

  TADC_Common_Registers = record
    SR          : longword;
    CR1         : longword;
    CR2         : longword;
    RESERVED    : array[0..15] of longword;
    DR          : longword;
  end;

  TCAN_TxMailBox_Registers = record
    TIR         : longword;
    TDTR        : longword;
    TDLR        : longword;
    TDHR        : longword;
  end;

  TCAN_FIFOMailBox_Registers = record
    RIR         : longword;
    RDTR        : longword;
    RDLR        : longword;
    RDHR        : longword;
  end;

  TCAN_FilterRegister_Registers = record
    FR1         : longword;
    FR2         : longword;
  end;

  TCAN_Registers = record
    MCR         : longword;
    MSR         : longword;
    TSR         : longword;
    RF0R        : longword;
    RF1R        : longword;
    IER         : longword;
    ESR         : longword;
    BTR         : longword;
    RESERVED0   : array[0..87] of longword;
    sTxMailBox  : array[0..2] of TCAN_TxMailBox_Registers;
    sFIFOMailBox : array[0..1] of TCAN_FIFOMailBox_Registers;
    RESERVED1   : array[0..11] of longword;
    FMR         : longword;
    FM1R        : longword;
    RESERVED2   : longword;
    FS1R        : longword;
    RESERVED3   : longword;
    FFA1R       : longword;
    RESERVED4   : longword;
    FA1R        : longword;
    RESERVED5   : array[0..7] of longword;
    sFilterRegister : array[0..27] of TCAN_FilterRegister_Registers;
  end;

  TCEC_Registers = record
    CR          : longword;
    CFGR        : longword;
    TXDR        : longword;
    RXDR        : longword;
    ISR         : longword;
    IER         : longword;
  end;

  TCOMP_Registers = record
    CSR         : longword;
  end;

  TCOMP_Common_Registers = record
    CSR         : longword;
  end;

  TCOMP1_2_Registers = record
    CSR         : longword;
  end;

  TCRC_Registers = record
    DR          : longword;
    IDR         : byte;
    RESERVED0   : byte;
    RESERVED1   : word;
    CR          : longword;
    RESERVED2   : longword;
    INIT        : longword;
    POL         : longword;
  end;

  TDAC_Registers = record
    CR          : longword;
    SWTRIGR     : longword;
    DHR12R1     : longword;
    DHR12L1     : longword;
    DHR8R1      : longword;
    DHR12R2     : longword;
    DHR12L2     : longword;
    DHR8R2      : longword;
    DHR12RD     : longword;
    DHR12LD     : longword;
    DHR8RD      : longword;
    DOR1        : longword;
    DOR2        : longword;
    SR          : longword;
  end;

  TDBGMCU_Registers = record
    IDCODE      : longword;
    CR          : longword;
    APB1FZ      : longword;
    APB2FZ      : longword;
  end;

  TDMA_Channel_Registers = record
    CCR         : longword;
    CNDTR       : longword;
    CPAR        : longword;
    CMAR        : longword;
  end;

  TDMA_Registers = record
    ISR         : longword;
    IFCR        : longword;
  end;

  TEXTI_Registers = record
    IMR         : longword;
    EMR         : longword;
    RTSR        : longword;
    FTSR        : longword;
    SWIER       : longword;
    PR          : longword;
  end;

  TFLASH_Registers = record
    ACR         : longword;
    KEYR        : longword;
    OPTKEYR     : longword;
    SR          : longword;
    CR          : longword;
    AR          : longword;
    RESERVED    : longword;
    OBR         : longword;
    WRPR        : longword;
  end;

  TOB_Registers = record
    RDP         : word;
    USER        : word;
    Data0       : word;
    Data1       : word;
    WRP0        : word;
    WRP1        : word;
    WRP2        : word;
    WRP3        : word;
  end;

  TGPIO_Registers = record
    MODER       : longword;
    OTYPER      : longword;
    OSPEEDR     : longword;
    PUPDR       : longword;
    IDR         : longword;
    ODR         : longword;
    BSRR        : longword;
    LCKR        : longword;
    AFR         : array[0..1] of longword;
    BRR         : longword;
  end;

  TSYSCFG_Registers = record
    CFGR1       : longword;
    RESERVED    : longword;
    EXTICR      : array[0..3] of longword;
    CFGR2       : longword;
  end;

  TI2C_Registers = record
    CR1         : longword;
    CR2         : longword;
    OAR1        : longword;
    OAR2        : longword;
    TIMINGR     : longword;
    TIMEOUTR    : longword;
    ISR         : longword;
    ICR         : longword;
    PECR        : longword;
    RXDR        : longword;
    TXDR        : longword;
  end;

  TIWDG_Registers = record
    KR          : longword;
    PR          : longword;
    RLR         : longword;
    SR          : longword;
    WINR        : longword;
  end;

  TPWR_Registers = record
    CR          : longword;
    CSR         : longword;
  end;

  TRCC_Registers = record
    CR          : longword;
    CFGR        : longword;
    CIR         : longword;
    APB2RSTR    : longword;
    APB1RSTR    : longword;
    AHBENR      : longword;
    APB2ENR     : longword;
    APB1ENR     : longword;
    BDCR        : longword;
    CSR         : longword;
    AHBRSTR     : longword;
    CFGR2       : longword;
    CFGR3       : longword;
  end;

  TRTC_Registers = record
    TR          : longword;
    DR          : longword;
    CR          : longword;
    ISR         : longword;
    PRER        : longword;
    WUTR        : longword;
    RESERVED0   : longword;
    ALRMAR      : longword;
    ALRMBR      : longword;
    WPR         : longword;
    SSR         : longword;
    SHIFTR      : longword;
    TSTR        : longword;
    TSDR        : longword;
    TSSSR       : longword;
    CALR        : longword;
    TAFCR       : longword;
    ALRMASSR    : longword;
    ALRMBSSR    : longword;
    RESERVED7   : longword;
    BKP0R       : longword;
    BKP1R       : longword;
    BKP2R       : longword;
    BKP3R       : longword;
    BKP4R       : longword;
    BKP5R       : longword;
    BKP6R       : longword;
    BKP7R       : longword;
    BKP8R       : longword;
    BKP9R       : longword;
    BKP10R      : longword;
    BKP11R      : longword;
    BKP12R      : longword;
    BKP13R      : longword;
    BKP14R      : longword;
    BKP15R      : longword;
    BKP16R      : longword;
    BKP17R      : longword;
    BKP18R      : longword;
    BKP19R      : longword;
    BKP20R      : longword;
    BKP21R      : longword;
    BKP22R      : longword;
    BKP23R      : longword;
    BKP24R      : longword;
    BKP25R      : longword;
    BKP26R      : longword;
    BKP27R      : longword;
    BKP28R      : longword;
    BKP29R      : longword;
    BKP30R      : longword;
    BKP31R      : longword;
  end;

  TSDADC_Registers = record
    CR1         : longword;
    CR2         : longword;
    ISR         : longword;
    CLRISR      : longword;
    RESERVED0   : longword;
    JCHGR       : longword;
    RESERVED1   : longword;
    RESERVED2   : longword;
    CONF0R      : longword;
    CONF1R      : longword;
    CONF2R      : longword;
    RESERVED3   : array[0..4] of longword;
    CONFCHR1    : longword;
    CONFCHR2    : longword;
    RESERVED4   : array[0..5] of longword;
    JDATAR      : longword;
    RDATAR      : longword;
    RESERVED5   : array[0..1] of longword;
    JDATA12R    : longword;
    RDATA12R    : longword;
    JDATA13R    : longword;
    RDATA13R    : longword;
  end;

  TSPI_Registers = record
    CR1         : longword;
    CR2         : longword;
    SR          : longword;
    DR          : longword;
    CRCPR       : longword;
    RXCRCR      : longword;
    TXCRCR      : longword;
    I2SCFGR     : longword;
    I2SPR       : longword;
  end;

  TTIM_Registers = record
    CR1         : longword;
    CR2         : longword;
    SMCR        : longword;
    DIER        : longword;
    SR          : longword;
    EGR         : longword;
    CCMR1       : longword;
    CCMR2       : longword;
    CCER        : longword;
    CNT         : longword;
    PSC         : longword;
    ARR         : longword;
    RCR         : longword;
    CCR1        : longword;
    CCR2        : longword;
    CCR3        : longword;
    CCR4        : longword;
    BDTR        : longword;
    DCR         : longword;
    DMAR        : longword;
    &OR         : longword;
  end;

  TTSC_Registers = record
    CR          : longword;
    IER         : longword;
    ICR         : longword;
    ISR         : longword;
    IOHCR       : longword;
    RESERVED1   : longword;
    IOASCR      : longword;
    RESERVED2   : longword;
    IOSCR       : longword;
    RESERVED3   : longword;
    IOCCR       : longword;
    RESERVED4   : longword;
    IOGCSR      : longword;
    IOGXCR      : array[0..7] of longword;
  end;

  TUSART_Registers = record
    CR1         : longword;
    CR2         : longword;
    CR3         : longword;
    BRR         : longword;
    GTPR        : longword;
    RTOR        : longword;
    RQR         : longword;
    ISR         : longword;
    ICR         : longword;
    RDR         : word;
    RESERVED1   : word;
    TDR         : word;
    RESERVED2   : word;
  end;

  TWWDG_Registers = record
    CR          : longword;
    CFR         : longword;
    SR          : longword;
  end;

const
  __NVIC_PRIO_BITS= 4;
  FLASH_BASE    = $08000000;
  SRAM_BASE     = $20000000;
  PERIPH_BASE   = $40000000;
  SRAM_BB_BASE  = $22000000;
  PERIPH_BB_BASE= $42000000;
  APB1PERIPH_BASE= PERIPH_BASE;
  APB2PERIPH_BASE= PERIPH_BASE + $00010000;
  AHB1PERIPH_BASE= PERIPH_BASE + $00020000;
  AHB2PERIPH_BASE= PERIPH_BASE + $08000000;
  TIM2_BASE     = APB1PERIPH_BASE + $00000000;
  TIM3_BASE     = APB1PERIPH_BASE + $00000400;
  TIM4_BASE     = APB1PERIPH_BASE + $00000800;
  TIM5_BASE     = APB1PERIPH_BASE + $00000C00;
  TIM6_BASE     = APB1PERIPH_BASE + $00001000;
  TIM7_BASE     = APB1PERIPH_BASE + $00001400;
  TIM12_BASE    = APB1PERIPH_BASE + $00001800;
  TIM13_BASE    = APB1PERIPH_BASE + $00001C00;
  TIM14_BASE    = APB1PERIPH_BASE + $00002000;
  RTC_BASE      = APB1PERIPH_BASE + $00002800;
  WWDG_BASE     = APB1PERIPH_BASE + $00002C00;
  IWDG_BASE     = APB1PERIPH_BASE + $00003000;
  SPI2_BASE     = APB1PERIPH_BASE + $00003800;
  SPI3_BASE     = APB1PERIPH_BASE + $00003C00;
  USART2_BASE   = APB1PERIPH_BASE + $00004400;
  USART3_BASE   = APB1PERIPH_BASE + $00004800;
  I2C1_BASE     = APB1PERIPH_BASE + $00005400;
  I2C2_BASE     = APB1PERIPH_BASE + $00005800;
  CAN_BASE      = APB1PERIPH_BASE + $00006400;
  PWR_BASE      = APB1PERIPH_BASE + $00007000;
  DAC1_BASE     = APB1PERIPH_BASE + $00007400;
  DAC2_BASE     = APB1PERIPH_BASE + $00009800;
  DAC_BASE      = DAC1_BASE;
  CEC_BASE      = APB1PERIPH_BASE + $00007800;
  TIM18_BASE    = APB1PERIPH_BASE + $00009C00;
  SYSCFG_BASE   = APB2PERIPH_BASE + $00000000;
  COMP_BASE     = APB2PERIPH_BASE + $0000001C;
  EXTI_BASE     = APB2PERIPH_BASE + $00000400;
  ADC1_BASE     = APB2PERIPH_BASE + $00002400;
  SPI1_BASE     = APB2PERIPH_BASE + $00003000;
  USART1_BASE   = APB2PERIPH_BASE + $00003800;
  TIM15_BASE    = APB2PERIPH_BASE + $00004000;
  TIM16_BASE    = APB2PERIPH_BASE + $00004400;
  TIM17_BASE    = APB2PERIPH_BASE + $00004800;
  TIM19_BASE    = APB2PERIPH_BASE + $00005C00;
  SDADC1_BASE   = APB2PERIPH_BASE + $00006000;
  SDADC2_BASE   = APB2PERIPH_BASE + $00006400;
  SDADC3_BASE   = APB2PERIPH_BASE + $00006800;
  DMA1_BASE     = AHB1PERIPH_BASE + $00000000;
  DMA1_Channel1_BASE= AHB1PERIPH_BASE + $00000008;
  DMA1_Channel2_BASE= AHB1PERIPH_BASE + $0000001C;
  DMA1_Channel3_BASE= AHB1PERIPH_BASE + $00000030;
  DMA1_Channel4_BASE= AHB1PERIPH_BASE + $00000044;
  DMA1_Channel5_BASE= AHB1PERIPH_BASE + $00000058;
  DMA1_Channel6_BASE= AHB1PERIPH_BASE + $0000006C;
  DMA1_Channel7_BASE= AHB1PERIPH_BASE + $00000080;
  DMA2_BASE     = AHB1PERIPH_BASE + $00000400;
  DMA2_Channel1_BASE= AHB1PERIPH_BASE + $00000408;
  DMA2_Channel2_BASE= AHB1PERIPH_BASE + $0000041C;
  DMA2_Channel3_BASE= AHB1PERIPH_BASE + $00000430;
  DMA2_Channel4_BASE= AHB1PERIPH_BASE + $00000444;
  DMA2_Channel5_BASE= AHB1PERIPH_BASE + $00000458;
  RCC_BASE      = AHB1PERIPH_BASE + $00001000;
  FLASH_R_BASE  = AHB1PERIPH_BASE + $00002000;
  OB_BASE       = $1FFFF800;
  FLASHSIZE_BASE= $1FFFF7CC;
  UID_BASE      = $1FFFF7AC;
  CRC_BASE      = AHB1PERIPH_BASE + $00003000;
  TSC_BASE      = AHB1PERIPH_BASE + $00004000;
  GPIOA_BASE    = AHB2PERIPH_BASE + $00000000;
  GPIOB_BASE    = AHB2PERIPH_BASE + $00000400;
  GPIOC_BASE    = AHB2PERIPH_BASE + $00000800;
  GPIOD_BASE    = AHB2PERIPH_BASE + $00000C00;
  GPIOE_BASE    = AHB2PERIPH_BASE + $00001000;
  GPIOF_BASE    = AHB2PERIPH_BASE + $00001400;
  DBGMCU_BASE   = $E0042000;

var
  TIM2          : TTIM_Registers absolute TIM2_BASE;
  TIM3          : TTIM_Registers absolute TIM3_BASE;
  TIM4          : TTIM_Registers absolute TIM4_BASE;
  TIM5          : TTIM_Registers absolute TIM5_BASE;
  TIM6          : TTIM_Registers absolute TIM6_BASE;
  TIM7          : TTIM_Registers absolute TIM7_BASE;
  TIM12         : TTIM_Registers absolute TIM12_BASE;
  TIM13         : TTIM_Registers absolute TIM13_BASE;
  TIM14         : TTIM_Registers absolute TIM14_BASE;
  RTC           : TRTC_Registers absolute RTC_BASE;
  WWDG          : TWWDG_Registers absolute WWDG_BASE;
  IWDG          : TIWDG_Registers absolute IWDG_BASE;
  SPI2          : TSPI_Registers absolute SPI2_BASE;
  SPI3          : TSPI_Registers absolute SPI3_BASE;
  USART2        : TUSART_Registers absolute USART2_BASE;
  USART3        : TUSART_Registers absolute USART3_BASE;
  I2C1          : TI2C_Registers absolute I2C1_BASE;
  I2C2          : TI2C_Registers absolute I2C2_BASE;
  CAN           : TCAN_Registers absolute CAN_BASE;
  PWR           : TPWR_Registers absolute PWR_BASE;
  DAC           : TDAC_Registers absolute DAC_BASE;
  DAC1          : TDAC_Registers absolute DAC1_BASE;
  DAC2          : TDAC_Registers absolute DAC2_BASE;
  CEC           : TCEC_Registers absolute CEC_BASE;
  COMP1         : TCOMP_Registers absolute COMP_BASE;
  COMP2         : TCOMP_Registers absolute (COMP_BASE + $00000002);
  COMP12_COMMON : TCOMP_Common_Registers absolute COMP_BASE;
  COMP          : TCOMP1_2_Registers absolute COMP_BASE;
  TIM18         : TTIM_Registers absolute TIM18_BASE;
  SYSCFG        : TSYSCFG_Registers absolute SYSCFG_BASE;
  EXTI          : TEXTI_Registers absolute EXTI_BASE;
  SPI1          : TSPI_Registers absolute SPI1_BASE;
  USART1        : TUSART_Registers absolute USART1_BASE;
  TIM15         : TTIM_Registers absolute TIM15_BASE;
  TIM16         : TTIM_Registers absolute TIM16_BASE;
  TIM17         : TTIM_Registers absolute TIM17_BASE;
  TIM19         : TTIM_Registers absolute TIM19_BASE;
  DBGMCU        : TDBGMCU_Registers absolute DBGMCU_BASE;
  SDADC1        : TSDADC_Registers absolute SDADC1_BASE;
  SDADC2        : TSDADC_Registers absolute SDADC2_BASE;
  SDADC3        : TSDADC_Registers absolute SDADC3_BASE;
  DMA1          : TDMA_Registers absolute DMA1_BASE;
  DMA1_Channel1 : TDMA_Channel_Registers absolute DMA1_Channel1_BASE;
  DMA1_Channel2 : TDMA_Channel_Registers absolute DMA1_Channel2_BASE;
  DMA1_Channel3 : TDMA_Channel_Registers absolute DMA1_Channel3_BASE;
  DMA1_Channel4 : TDMA_Channel_Registers absolute DMA1_Channel4_BASE;
  DMA1_Channel5 : TDMA_Channel_Registers absolute DMA1_Channel5_BASE;
  DMA1_Channel6 : TDMA_Channel_Registers absolute DMA1_Channel6_BASE;
  DMA1_Channel7 : TDMA_Channel_Registers absolute DMA1_Channel7_BASE;
  DMA2          : TDMA_Registers absolute DMA2_BASE;
  DMA2_Channel1 : TDMA_Channel_Registers absolute DMA2_Channel1_BASE;
  DMA2_Channel2 : TDMA_Channel_Registers absolute DMA2_Channel2_BASE;
  DMA2_Channel3 : TDMA_Channel_Registers absolute DMA2_Channel3_BASE;
  DMA2_Channel4 : TDMA_Channel_Registers absolute DMA2_Channel4_BASE;
  DMA2_Channel5 : TDMA_Channel_Registers absolute DMA2_Channel5_BASE;
  RCC           : TRCC_Registers absolute RCC_BASE;
  FLASH         : TFLASH_Registers absolute FLASH_R_BASE;
  OB            : TOB_Registers absolute OB_BASE;
  CRC           : TCRC_Registers absolute CRC_BASE;
  TSC           : TTSC_Registers absolute TSC_BASE;
  GPIOA         : TGPIO_Registers absolute GPIOA_BASE;
  GPIOB         : TGPIO_Registers absolute GPIOB_BASE;
  GPIOC         : TGPIO_Registers absolute GPIOC_BASE;
  GPIOD         : TGPIO_Registers absolute GPIOD_BASE;
  GPIOE         : TGPIO_Registers absolute GPIOE_BASE;
  GPIOF         : TGPIO_Registers absolute GPIOF_BASE;
  ADC1          : TADC_Registers absolute ADC1_BASE;
  ADC1_COMMON   : TADC_Common_Registers absolute ADC1_BASE;

implementation

procedure NonMaskableInt_Handler; external name 'NonMaskableInt_Handler';
procedure HardFault_Handler; external name 'HardFault_Handler';
procedure MemoryManagement_Handler; external name 'MemoryManagement_Handler';
procedure BusFault_Handler; external name 'BusFault_Handler';
procedure UsageFault_Handler; external name 'UsageFault_Handler';
procedure SVCall_Handler; external name 'SVCall_Handler';
procedure DebugMonitor_Handler; external name 'DebugMonitor_Handler';
procedure PendSV_Handler; external name 'PendSV_Handler';
procedure SysTick_Handler; external name 'SysTick_Handler';
procedure WWDG_IRQHandler; external name 'WWDG_IRQHandler';
procedure TAMP_STAMP_IRQHandler; external name 'TAMP_STAMP_IRQHandler';
procedure RTC_WKUP_IRQHandler; external name 'RTC_WKUP_IRQHandler';
procedure FLASH_IRQHandler; external name 'FLASH_IRQHandler';
procedure RCC_IRQHandler; external name 'RCC_IRQHandler';
procedure EXTI0_IRQHandler; external name 'EXTI0_IRQHandler';
procedure EXTI1_IRQHandler; external name 'EXTI1_IRQHandler';
procedure EXTI2_TSC_IRQHandler; external name 'EXTI2_TSC_IRQHandler';
procedure EXTI3_IRQHandler; external name 'EXTI3_IRQHandler';
procedure EXTI4_IRQHandler; external name 'EXTI4_IRQHandler';
procedure DMA1_Channel1_IRQHandler; external name 'DMA1_Channel1_IRQHandler';
procedure DMA1_Channel2_IRQHandler; external name 'DMA1_Channel2_IRQHandler';
procedure DMA1_Channel3_IRQHandler; external name 'DMA1_Channel3_IRQHandler';
procedure DMA1_Channel4_IRQHandler; external name 'DMA1_Channel4_IRQHandler';
procedure DMA1_Channel5_IRQHandler; external name 'DMA1_Channel5_IRQHandler';
procedure DMA1_Channel6_IRQHandler; external name 'DMA1_Channel6_IRQHandler';
procedure DMA1_Channel7_IRQHandler; external name 'DMA1_Channel7_IRQHandler';
procedure ADC1_IRQHandler; external name 'ADC1_IRQHandler';
procedure CAN_TX_IRQHandler; external name 'CAN_TX_IRQHandler';
procedure CAN_RX0_IRQHandler; external name 'CAN_RX0_IRQHandler';
procedure CAN_RX1_IRQHandler; external name 'CAN_RX1_IRQHandler';
procedure CAN_SCE_IRQHandler; external name 'CAN_SCE_IRQHandler';
procedure EXTI9_5_IRQHandler; external name 'EXTI9_5_IRQHandler';
procedure TIM15_IRQHandler; external name 'TIM15_IRQHandler';
procedure TIM16_IRQHandler; external name 'TIM16_IRQHandler';
procedure TIM17_IRQHandler; external name 'TIM17_IRQHandler';
procedure TIM18_DAC2_IRQHandler; external name 'TIM18_DAC2_IRQHandler';
procedure TIM2_IRQHandler; external name 'TIM2_IRQHandler';
procedure TIM3_IRQHandler; external name 'TIM3_IRQHandler';
procedure TIM4_IRQHandler; external name 'TIM4_IRQHandler';
procedure I2C1_EV_IRQHandler; external name 'I2C1_EV_IRQHandler';
procedure I2C1_ER_IRQHandler; external name 'I2C1_ER_IRQHandler';
procedure I2C2_EV_IRQHandler; external name 'I2C2_EV_IRQHandler';
procedure I2C2_ER_IRQHandler; external name 'I2C2_ER_IRQHandler';
procedure SPI1_IRQHandler; external name 'SPI1_IRQHandler';
procedure SPI2_IRQHandler; external name 'SPI2_IRQHandler';
procedure USART1_IRQHandler; external name 'USART1_IRQHandler';
procedure USART2_IRQHandler; external name 'USART2_IRQHandler';
procedure USART3_IRQHandler; external name 'USART3_IRQHandler';
procedure EXTI15_10_IRQHandler; external name 'EXTI15_10_IRQHandler';
procedure RTC_Alarm_IRQHandler; external name 'RTC_Alarm_IRQHandler';
procedure CEC_IRQHandler; external name 'CEC_IRQHandler';
procedure TIM12_IRQHandler; external name 'TIM12_IRQHandler';
procedure TIM13_IRQHandler; external name 'TIM13_IRQHandler';
procedure TIM14_IRQHandler; external name 'TIM14_IRQHandler';
procedure TIM5_IRQHandler; external name 'TIM5_IRQHandler';
procedure SPI3_IRQHandler; external name 'SPI3_IRQHandler';
procedure TIM6_DAC1_IRQHandler; external name 'TIM6_DAC1_IRQHandler';
procedure TIM7_IRQHandler; external name 'TIM7_IRQHandler';
procedure DMA2_Channel1_IRQHandler; external name 'DMA2_Channel1_IRQHandler';
procedure DMA2_Channel2_IRQHandler; external name 'DMA2_Channel2_IRQHandler';
procedure DMA2_Channel3_IRQHandler; external name 'DMA2_Channel3_IRQHandler';
procedure DMA2_Channel4_IRQHandler; external name 'DMA2_Channel4_IRQHandler';
procedure DMA2_Channel5_IRQHandler; external name 'DMA2_Channel5_IRQHandler';
procedure SDADC1_IRQHandler; external name 'SDADC1_IRQHandler';
procedure SDADC2_IRQHandler; external name 'SDADC2_IRQHandler';
procedure SDADC3_IRQHandler; external name 'SDADC3_IRQHandler';
procedure COMP_IRQHandler; external name 'COMP_IRQHandler';
procedure TIM19_IRQHandler; external name 'TIM19_IRQHandler';
procedure FPU_IRQHandler; external name 'FPU_IRQHandler';


{$i cortexm4f_start.inc}

procedure Vectors; assembler; nostackframe;
label interrupt_vectors;
asm
  .section ".init.interrupt_vectors"
  interrupt_vectors:
  .long _stack_top
  .long Startup
  .long NonMaskableInt_Handler
  .long HardFault_Handler
  .long MemoryManagement_Handler
  .long BusFault_Handler
  .long UsageFault_Handler
  .long 0
  .long 0
  .long 0
  .long 0
  .long SVCall_Handler
  .long DebugMonitor_Handler
  .long 0
  .long PendSV_Handler
  .long SysTick_Handler
  .long WWDG_IRQHandler
  .long 0
  .long TAMP_STAMP_IRQHandler
  .long RTC_WKUP_IRQHandler
  .long FLASH_IRQHandler
  .long RCC_IRQHandler
  .long EXTI0_IRQHandler
  .long EXTI1_IRQHandler
  .long EXTI2_TSC_IRQHandler
  .long EXTI3_IRQHandler
  .long EXTI4_IRQHandler
  .long DMA1_Channel1_IRQHandler
  .long DMA1_Channel2_IRQHandler
  .long DMA1_Channel3_IRQHandler
  .long DMA1_Channel4_IRQHandler
  .long DMA1_Channel5_IRQHandler
  .long DMA1_Channel6_IRQHandler
  .long DMA1_Channel7_IRQHandler
  .long ADC1_IRQHandler
  .long CAN_TX_IRQHandler
  .long CAN_RX0_IRQHandler
  .long CAN_RX1_IRQHandler
  .long CAN_SCE_IRQHandler
  .long EXTI9_5_IRQHandler
  .long TIM15_IRQHandler
  .long TIM16_IRQHandler
  .long TIM17_IRQHandler
  .long TIM18_DAC2_IRQHandler
  .long TIM2_IRQHandler
  .long TIM3_IRQHandler
  .long TIM4_IRQHandler
  .long I2C1_EV_IRQHandler
  .long I2C1_ER_IRQHandler
  .long I2C2_EV_IRQHandler
  .long I2C2_ER_IRQHandler
  .long SPI1_IRQHandler
  .long SPI2_IRQHandler
  .long USART1_IRQHandler
  .long USART2_IRQHandler
  .long USART3_IRQHandler
  .long EXTI15_10_IRQHandler
  .long RTC_Alarm_IRQHandler
  .long CEC_IRQHandler
  .long TIM12_IRQHandler
  .long TIM13_IRQHandler
  .long TIM14_IRQHandler
  .long 0
  .long 0
  .long 0
  .long 0
  .long TIM5_IRQHandler
  .long SPI3_IRQHandler
  .long 0
  .long 0
  .long TIM6_DAC1_IRQHandler
  .long TIM7_IRQHandler
  .long DMA2_Channel1_IRQHandler
  .long DMA2_Channel2_IRQHandler
  .long DMA2_Channel3_IRQHandler
  .long DMA2_Channel4_IRQHandler
  .long DMA2_Channel5_IRQHandler
  .long SDADC1_IRQHandler
  .long SDADC2_IRQHandler
  .long SDADC3_IRQHandler
  .long COMP_IRQHandler
  .long 0
  .long 0
  .long 0
  .long 0
  .long 0
  .long 0
  .long 0
  .long 0
  .long 0
  .long 0
  .long 0
  .long 0
  .long 0
  .long TIM19_IRQHandler
  .long 0
  .long 0
  .long FPU_IRQHandler

  .weak NonMaskableInt_Handler
  .weak HardFault_Handler
  .weak MemoryManagement_Handler
  .weak BusFault_Handler
  .weak UsageFault_Handler
  .weak SVCall_Handler
  .weak DebugMonitor_Handler
  .weak PendSV_Handler
  .weak SysTick_Handler
  .weak WWDG_IRQHandler
  .weak TAMP_STAMP_IRQHandler
  .weak RTC_WKUP_IRQHandler
  .weak FLASH_IRQHandler
  .weak RCC_IRQHandler
  .weak EXTI0_IRQHandler
  .weak EXTI1_IRQHandler
  .weak EXTI2_TSC_IRQHandler
  .weak EXTI3_IRQHandler
  .weak EXTI4_IRQHandler
  .weak DMA1_Channel1_IRQHandler
  .weak DMA1_Channel2_IRQHandler
  .weak DMA1_Channel3_IRQHandler
  .weak DMA1_Channel4_IRQHandler
  .weak DMA1_Channel5_IRQHandler
  .weak DMA1_Channel6_IRQHandler
  .weak DMA1_Channel7_IRQHandler
  .weak ADC1_IRQHandler
  .weak CAN_TX_IRQHandler
  .weak CAN_RX0_IRQHandler
  .weak CAN_RX1_IRQHandler
  .weak CAN_SCE_IRQHandler
  .weak EXTI9_5_IRQHandler
  .weak TIM15_IRQHandler
  .weak TIM16_IRQHandler
  .weak TIM17_IRQHandler
  .weak TIM18_DAC2_IRQHandler
  .weak TIM2_IRQHandler
  .weak TIM3_IRQHandler
  .weak TIM4_IRQHandler
  .weak I2C1_EV_IRQHandler
  .weak I2C1_ER_IRQHandler
  .weak I2C2_EV_IRQHandler
  .weak I2C2_ER_IRQHandler
  .weak SPI1_IRQHandler
  .weak SPI2_IRQHandler
  .weak USART1_IRQHandler
  .weak USART2_IRQHandler
  .weak USART3_IRQHandler
  .weak EXTI15_10_IRQHandler
  .weak RTC_Alarm_IRQHandler
  .weak CEC_IRQHandler
  .weak TIM12_IRQHandler
  .weak TIM13_IRQHandler
  .weak TIM14_IRQHandler
  .weak TIM5_IRQHandler
  .weak SPI3_IRQHandler
  .weak TIM6_DAC1_IRQHandler
  .weak TIM7_IRQHandler
  .weak DMA2_Channel1_IRQHandler
  .weak DMA2_Channel2_IRQHandler
  .weak DMA2_Channel3_IRQHandler
  .weak DMA2_Channel4_IRQHandler
  .weak DMA2_Channel5_IRQHandler
  .weak SDADC1_IRQHandler
  .weak SDADC2_IRQHandler
  .weak SDADC3_IRQHandler
  .weak COMP_IRQHandler
  .weak TIM19_IRQHandler
  .weak FPU_IRQHandler

  .set NonMaskableInt_Handler, _NonMaskableInt_Handler
  .set HardFault_Handler, _HardFault_Handler
  .set MemoryManagement_Handler, _MemoryManagement_Handler
  .set BusFault_Handler, _BusFault_Handler
  .set UsageFault_Handler, _UsageFault_Handler
  .set SVCall_Handler, _SVCall_Handler
  .set DebugMonitor_Handler, _DebugMonitor_Handler
  .set PendSV_Handler, _PendSV_Handler
  .set SysTick_Handler, _SysTick_Handler
  .set WWDG_IRQHandler, Haltproc
  .set TAMP_STAMP_IRQHandler, Haltproc
  .set RTC_WKUP_IRQHandler, Haltproc
  .set FLASH_IRQHandler, Haltproc
  .set RCC_IRQHandler, Haltproc
  .set EXTI0_IRQHandler, Haltproc
  .set EXTI1_IRQHandler, Haltproc
  .set EXTI2_TSC_IRQHandler, Haltproc
  .set EXTI3_IRQHandler, Haltproc
  .set EXTI4_IRQHandler, Haltproc
  .set DMA1_Channel1_IRQHandler, Haltproc
  .set DMA1_Channel2_IRQHandler, Haltproc
  .set DMA1_Channel3_IRQHandler, Haltproc
  .set DMA1_Channel4_IRQHandler, Haltproc
  .set DMA1_Channel5_IRQHandler, Haltproc
  .set DMA1_Channel6_IRQHandler, Haltproc
  .set DMA1_Channel7_IRQHandler, Haltproc
  .set ADC1_IRQHandler, Haltproc
  .set CAN_TX_IRQHandler, Haltproc
  .set CAN_RX0_IRQHandler, Haltproc
  .set CAN_RX1_IRQHandler, Haltproc
  .set CAN_SCE_IRQHandler, Haltproc
  .set EXTI9_5_IRQHandler, Haltproc
  .set TIM15_IRQHandler, Haltproc
  .set TIM16_IRQHandler, Haltproc
  .set TIM17_IRQHandler, Haltproc
  .set TIM18_DAC2_IRQHandler, Haltproc
  .set TIM2_IRQHandler, Haltproc
  .set TIM3_IRQHandler, Haltproc
  .set TIM4_IRQHandler, Haltproc
  .set I2C1_EV_IRQHandler, Haltproc
  .set I2C1_ER_IRQHandler, Haltproc
  .set I2C2_EV_IRQHandler, Haltproc
  .set I2C2_ER_IRQHandler, Haltproc
  .set SPI1_IRQHandler, Haltproc
  .set SPI2_IRQHandler, Haltproc
  .set USART1_IRQHandler, Haltproc
  .set USART2_IRQHandler, Haltproc
  .set USART3_IRQHandler, Haltproc
  .set EXTI15_10_IRQHandler, Haltproc
  .set RTC_Alarm_IRQHandler, Haltproc
  .set CEC_IRQHandler, Haltproc
  .set TIM12_IRQHandler, Haltproc
  .set TIM13_IRQHandler, Haltproc
  .set TIM14_IRQHandler, Haltproc
  .set TIM5_IRQHandler, Haltproc
  .set SPI3_IRQHandler, Haltproc
  .set TIM6_DAC1_IRQHandler, Haltproc
  .set TIM7_IRQHandler, Haltproc
  .set DMA2_Channel1_IRQHandler, Haltproc
  .set DMA2_Channel2_IRQHandler, Haltproc
  .set DMA2_Channel3_IRQHandler, Haltproc
  .set DMA2_Channel4_IRQHandler, Haltproc
  .set DMA2_Channel5_IRQHandler, Haltproc
  .set SDADC1_IRQHandler, Haltproc
  .set SDADC2_IRQHandler, Haltproc
  .set SDADC3_IRQHandler, Haltproc
  .set COMP_IRQHandler, Haltproc
  .set TIM19_IRQHandler, Haltproc
  .set FPU_IRQHandler, Haltproc

  .text
  end;
end.
