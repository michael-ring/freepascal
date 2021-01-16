unit stm32f048xx;
interface
{$PACKRECORDS C}
{$GOTO ON}
{$SCOPEDENUMS ON}

type
  TIRQn_Enum = (
    NonMaskableInt_IRQn = -14,        
    HardFault_IRQn = -13,             
    SVC_IRQn    = -5,                 
    PendSV_IRQn = -2,                 
    SysTick_IRQn = -1,                
    WWDG_IRQn   = 0,                  
    VDDIO2_IRQn = 1,                  
    RTC_IRQn    = 2,                  
    FLASH_IRQn  = 3,                  
    RCC_CRS_IRQn = 4,                 
    EXTI0_1_IRQn = 5,                 
    EXTI2_3_IRQn = 6,                 
    EXTI4_15_IRQn = 7,                
    TSC_IRQn    = 8,                  
    DMA1_Channel1_IRQn = 9,           
    DMA1_Channel2_3_IRQn = 10,        
    DMA1_Channel4_5_IRQn = 11,        
    ADC1_IRQn   = 12,                 
    TIM1_BRK_UP_TRG_COM_IRQn = 13,    
    TIM1_CC_IRQn = 14,                
    TIM2_IRQn   = 15,                 
    TIM3_IRQn   = 16,                 
    TIM14_IRQn  = 19,                 
    TIM16_IRQn  = 21,                 
    TIM17_IRQn  = 22,                 
    I2C1_IRQn   = 23,                 
    SPI1_IRQn   = 25,                 
    SPI2_IRQn   = 26,                 
    USART1_IRQn = 27,                 
    USART2_IRQn = 28,                 
    CEC_CAN_IRQn = 30,                
    USB_IRQn    = 31                  
  );

  TADC_Registers = record
    ISR         : longword;
    IER         : longword;
    CR          : longword;
    CFGR1       : longword;
    CFGR2       : longword;
    SMPR        : longword;
    RESERVED1   : longword;
    RESERVED2   : longword;
    TR          : longword;
    RESERVED3   : longword;
    CHSELR      : longword;
    RESERVED4   : array[0..4] of longword;
    DR          : longword;
  end;

  TADC_Common_Registers = record
    CCR         : longword;
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

  TCRC_Registers = record
    DR          : longword;
    IDR         : byte;
    RESERVED0   : byte;
    RESERVED1   : word;
    CR          : longword;
    RESERVED2   : longword;
    INIT        : longword;
    RESERVED3   : longword;
  end;

  TCRS_Registers = record
    CR          : longword;
    CFGR        : longword;
    ISR         : longword;
    ICR         : longword;
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
    DATA0       : word;
    DATA1       : word;
    WRP0        : word;
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
    CR2         : longword;
  end;

  TRTC_Registers = record
    TR          : longword;
    DR          : longword;
    CR          : longword;
    ISR         : longword;
    PRER        : longword;
    RESERVED1   : longword;
    RESERVED2   : longword;
    ALRMAR      : longword;
    RESERVED3   : longword;
    WPR         : longword;
    SSR         : longword;
    SHIFTR      : longword;
    TSTR        : longword;
    TSDR        : longword;
    TSSSR       : longword;
    CALR        : longword;
    TAFCR       : longword;
    ALRMASSR    : longword;
    RESERVED4   : longword;
    RESERVED5   : longword;
    BKP0R       : longword;
    BKP1R       : longword;
    BKP2R       : longword;
    BKP3R       : longword;
    BKP4R       : longword;
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

  TUSB_Registers = record
    EP0R        : word;
    RESERVED0   : word;
    EP1R        : word;
    RESERVED1   : word;
    EP2R        : word;
    RESERVED2   : word;
    EP3R        : word;
    RESERVED3   : word;
    EP4R        : word;
    RESERVED4   : word;
    EP5R        : word;
    RESERVED5   : word;
    EP6R        : word;
    RESERVED6   : word;
    EP7R        : word;
    RESERVED7   : array[0..16] of word;
    CNTR        : word;
    RESERVED8   : word;
    ISTR        : word;
    RESERVED9   : word;
    FNR         : word;
    RESERVEDA   : word;
    DADDR       : word;
    RESERVEDB   : word;
    BTABLE      : word;
    RESERVEDC   : word;
    LPMCSR      : word;
    RESERVEDD   : word;
    BCDR        : word;
    RESERVEDE   : word;
  end;

  TWWDG_Registers = record
    CR          : longword;
    CFR         : longword;
    SR          : longword;
  end;

const
  __NVIC_PRIO_BITS= 2;
  FLASH_BASE    = $08000000;
  SRAM_BASE     = $20000000;
  PERIPH_BASE   = $40000000;
  APBPERIPH_BASE= PERIPH_BASE;
  AHBPERIPH_BASE= PERIPH_BASE + $00020000;
  AHB2PERIPH_BASE= PERIPH_BASE + $08000000;
  TIM2_BASE     = APBPERIPH_BASE + $00000000;
  TIM3_BASE     = APBPERIPH_BASE + $00000400;
  TIM14_BASE    = APBPERIPH_BASE + $00002000;
  RTC_BASE      = APBPERIPH_BASE + $00002800;
  WWDG_BASE     = APBPERIPH_BASE + $00002C00;
  IWDG_BASE     = APBPERIPH_BASE + $00003000;
  SPI2_BASE     = APBPERIPH_BASE + $00003800;
  USART2_BASE   = APBPERIPH_BASE + $00004400;
  I2C1_BASE     = APBPERIPH_BASE + $00005400;
  USB_BASE      = APBPERIPH_BASE + $00005C00;
  CAN_BASE      = APBPERIPH_BASE + $00006400;
  CRS_BASE      = APBPERIPH_BASE + $00006C00;
  PWR_BASE      = APBPERIPH_BASE + $00007000;
  CEC_BASE      = APBPERIPH_BASE + $00007800;
  SYSCFG_BASE   = APBPERIPH_BASE + $00010000;
  EXTI_BASE     = APBPERIPH_BASE + $00010400;
  ADC1_BASE     = APBPERIPH_BASE + $00012400;
  ADC_BASE      = APBPERIPH_BASE + $00012708;
  TIM1_BASE     = APBPERIPH_BASE + $00012C00;
  SPI1_BASE     = APBPERIPH_BASE + $00013000;
  USART1_BASE   = APBPERIPH_BASE + $00013800;
  TIM16_BASE    = APBPERIPH_BASE + $00014400;
  TIM17_BASE    = APBPERIPH_BASE + $00014800;
  DBGMCU_BASE   = APBPERIPH_BASE + $00015800;
  DMA1_BASE     = AHBPERIPH_BASE + $00000000;
  DMA1_Channel1_BASE= DMA1_BASE + $00000008;
  DMA1_Channel2_BASE= DMA1_BASE + $0000001C;
  DMA1_Channel3_BASE= DMA1_BASE + $00000030;
  DMA1_Channel4_BASE= DMA1_BASE + $00000044;
  DMA1_Channel5_BASE= DMA1_BASE + $00000058;
  DMA1_Channel6_BASE= DMA1_BASE + $0000006C;
  DMA1_Channel7_BASE= DMA1_BASE + $00000080;
  RCC_BASE      = AHBPERIPH_BASE + $00001000;
  FLASH_R_BASE  = AHBPERIPH_BASE + $00002000;
  OB_BASE       = $1FFFF800;
  FLASHSIZE_BASE= $1FFFF7CC;
  UID_BASE      = $1FFFF7AC;
  CRC_BASE      = AHBPERIPH_BASE + $00003000;
  TSC_BASE      = AHBPERIPH_BASE + $00004000;
  GPIOA_BASE    = AHB2PERIPH_BASE + $00000000;
  GPIOB_BASE    = AHB2PERIPH_BASE + $00000400;
  GPIOC_BASE    = AHB2PERIPH_BASE + $00000800;
  GPIOF_BASE    = AHB2PERIPH_BASE + $00001400;

var
  TIM2          : TTIM_Registers absolute TIM2_BASE;
  TIM3          : TTIM_Registers absolute TIM3_BASE;
  TIM14         : TTIM_Registers absolute TIM14_BASE;
  RTC           : TRTC_Registers absolute RTC_BASE;
  WWDG          : TWWDG_Registers absolute WWDG_BASE;
  IWDG          : TIWDG_Registers absolute IWDG_BASE;
  USART2        : TUSART_Registers absolute USART2_BASE;
  I2C1          : TI2C_Registers absolute I2C1_BASE;
  CAN           : TCAN_Registers absolute CAN_BASE;
  CRS           : TCRS_Registers absolute CRS_BASE;
  PWR           : TPWR_Registers absolute PWR_BASE;
  CEC           : TCEC_Registers absolute CEC_BASE;
  SYSCFG        : TSYSCFG_Registers absolute SYSCFG_BASE;
  EXTI          : TEXTI_Registers absolute EXTI_BASE;
  ADC1          : TADC_Registers absolute ADC1_BASE;
  ADC1_COMMON   : TADC_Common_Registers absolute ADC_BASE;
  ADC           : TADC_Common_Registers absolute ADC_BASE;
  TIM1          : TTIM_Registers absolute TIM1_BASE;
  SPI1          : TSPI_Registers absolute SPI1_BASE;
  SPI2          : TSPI_Registers absolute SPI2_BASE;
  USART1        : TUSART_Registers absolute USART1_BASE;
  TIM16         : TTIM_Registers absolute TIM16_BASE;
  TIM17         : TTIM_Registers absolute TIM17_BASE;
  DBGMCU        : TDBGMCU_Registers absolute DBGMCU_BASE;
  DMA1          : TDMA_Registers absolute DMA1_BASE;
  DMA1_Channel1 : TDMA_Channel_Registers absolute DMA1_Channel1_BASE;
  DMA1_Channel2 : TDMA_Channel_Registers absolute DMA1_Channel2_BASE;
  DMA1_Channel3 : TDMA_Channel_Registers absolute DMA1_Channel3_BASE;
  DMA1_Channel4 : TDMA_Channel_Registers absolute DMA1_Channel4_BASE;
  DMA1_Channel5 : TDMA_Channel_Registers absolute DMA1_Channel5_BASE;
  DMA1_Channel6 : TDMA_Channel_Registers absolute DMA1_Channel6_BASE;
  DMA1_Channel7 : TDMA_Channel_Registers absolute DMA1_Channel7_BASE;
  FLASH         : TFLASH_Registers absolute FLASH_R_BASE;
  OB            : TOB_Registers absolute OB_BASE;
  RCC           : TRCC_Registers absolute RCC_BASE;
  CRC           : TCRC_Registers absolute CRC_BASE;
  TSC           : TTSC_Registers absolute TSC_BASE;
  GPIOA         : TGPIO_Registers absolute GPIOA_BASE;
  GPIOB         : TGPIO_Registers absolute GPIOB_BASE;
  GPIOC         : TGPIO_Registers absolute GPIOC_BASE;
  GPIOF         : TGPIO_Registers absolute GPIOF_BASE;
  USB           : TUSB_Registers absolute USB_BASE;

implementation

procedure NonMaskableInt_Handler; external name 'NonMaskableInt_Handler';
procedure HardFault_Handler; external name 'HardFault_Handler';
procedure SVC_Handler; external name 'SVC_Handler';
procedure PendSV_Handler; external name 'PendSV_Handler';
procedure SysTick_Handler; external name 'SysTick_Handler';
procedure WWDG_IRQHandler; external name 'WWDG_IRQHandler';
procedure VDDIO2_IRQHandler; external name 'VDDIO2_IRQHandler';
procedure RTC_IRQHandler; external name 'RTC_IRQHandler';
procedure FLASH_IRQHandler; external name 'FLASH_IRQHandler';
procedure RCC_CRS_IRQHandler; external name 'RCC_CRS_IRQHandler';
procedure EXTI0_1_IRQHandler; external name 'EXTI0_1_IRQHandler';
procedure EXTI2_3_IRQHandler; external name 'EXTI2_3_IRQHandler';
procedure EXTI4_15_IRQHandler; external name 'EXTI4_15_IRQHandler';
procedure TSC_IRQHandler; external name 'TSC_IRQHandler';
procedure DMA1_Channel1_IRQHandler; external name 'DMA1_Channel1_IRQHandler';
procedure DMA1_Channel2_3_IRQHandler; external name 'DMA1_Channel2_3_IRQHandler';
procedure DMA1_Channel4_5_IRQHandler; external name 'DMA1_Channel4_5_IRQHandler';
procedure ADC1_IRQHandler; external name 'ADC1_IRQHandler';
procedure TIM1_BRK_UP_TRG_COM_IRQHandler; external name 'TIM1_BRK_UP_TRG_COM_IRQHandler';
procedure TIM1_CC_IRQHandler; external name 'TIM1_CC_IRQHandler';
procedure TIM2_IRQHandler; external name 'TIM2_IRQHandler';
procedure TIM3_IRQHandler; external name 'TIM3_IRQHandler';
procedure TIM14_IRQHandler; external name 'TIM14_IRQHandler';
procedure TIM16_IRQHandler; external name 'TIM16_IRQHandler';
procedure TIM17_IRQHandler; external name 'TIM17_IRQHandler';
procedure I2C1_IRQHandler; external name 'I2C1_IRQHandler';
procedure SPI1_IRQHandler; external name 'SPI1_IRQHandler';
procedure SPI2_IRQHandler; external name 'SPI2_IRQHandler';
procedure USART1_IRQHandler; external name 'USART1_IRQHandler';
procedure USART2_IRQHandler; external name 'USART2_IRQHandler';
procedure CEC_CAN_IRQHandler; external name 'CEC_CAN_IRQHandler';
procedure USB_IRQHandler; external name 'USB_IRQHandler';


{$i cortexm0_start.inc}

procedure Vectors; assembler; nostackframe;
label interrupt_vectors;
asm
  .section ".init.interrupt_vectors"
  interrupt_vectors:
  .long _stack_top
  .long Startup
  .long NonMaskableInt_Handler
  .long HardFault_Handler
  .long 0
  .long 0
  .long 0
  .long 0
  .long 0
  .long 0
  .long 0
  .long SVC_Handler
  .long 0
  .long 0
  .long PendSV_Handler
  .long SysTick_Handler
  .long WWDG_IRQHandler
  .long VDDIO2_IRQHandler
  .long RTC_IRQHandler
  .long FLASH_IRQHandler
  .long RCC_CRS_IRQHandler
  .long EXTI0_1_IRQHandler
  .long EXTI2_3_IRQHandler
  .long EXTI4_15_IRQHandler
  .long TSC_IRQHandler
  .long DMA1_Channel1_IRQHandler
  .long DMA1_Channel2_3_IRQHandler
  .long DMA1_Channel4_5_IRQHandler
  .long ADC1_IRQHandler
  .long TIM1_BRK_UP_TRG_COM_IRQHandler
  .long TIM1_CC_IRQHandler
  .long TIM2_IRQHandler
  .long TIM3_IRQHandler
  .long 0
  .long 0
  .long TIM14_IRQHandler
  .long 0
  .long TIM16_IRQHandler
  .long TIM17_IRQHandler
  .long I2C1_IRQHandler
  .long 0
  .long SPI1_IRQHandler
  .long SPI2_IRQHandler
  .long USART1_IRQHandler
  .long USART2_IRQHandler
  .long 0
  .long CEC_CAN_IRQHandler
  .long USB_IRQHandler

  .weak NonMaskableInt_Handler
  .weak HardFault_Handler
  .weak SVC_Handler
  .weak PendSV_Handler
  .weak SysTick_Handler
  .weak WWDG_IRQHandler
  .weak VDDIO2_IRQHandler
  .weak RTC_IRQHandler
  .weak FLASH_IRQHandler
  .weak RCC_CRS_IRQHandler
  .weak EXTI0_1_IRQHandler
  .weak EXTI2_3_IRQHandler
  .weak EXTI4_15_IRQHandler
  .weak TSC_IRQHandler
  .weak DMA1_Channel1_IRQHandler
  .weak DMA1_Channel2_3_IRQHandler
  .weak DMA1_Channel4_5_IRQHandler
  .weak ADC1_IRQHandler
  .weak TIM1_BRK_UP_TRG_COM_IRQHandler
  .weak TIM1_CC_IRQHandler
  .weak TIM2_IRQHandler
  .weak TIM3_IRQHandler
  .weak TIM14_IRQHandler
  .weak TIM16_IRQHandler
  .weak TIM17_IRQHandler
  .weak I2C1_IRQHandler
  .weak SPI1_IRQHandler
  .weak SPI2_IRQHandler
  .weak USART1_IRQHandler
  .weak USART2_IRQHandler
  .weak CEC_CAN_IRQHandler
  .weak USB_IRQHandler

  .set NonMaskableInt_Handler, _NonMaskableInt_Handler
  .set HardFault_Handler, _HardFault_Handler
  .set SVC_Handler, _SVC_Handler
  .set PendSV_Handler, _PendSV_Handler
  .set SysTick_Handler, _SysTick_Handler
  .set WWDG_IRQHandler, Haltproc
  .set VDDIO2_IRQHandler, Haltproc
  .set RTC_IRQHandler, Haltproc
  .set FLASH_IRQHandler, Haltproc
  .set RCC_CRS_IRQHandler, Haltproc
  .set EXTI0_1_IRQHandler, Haltproc
  .set EXTI2_3_IRQHandler, Haltproc
  .set EXTI4_15_IRQHandler, Haltproc
  .set TSC_IRQHandler, Haltproc
  .set DMA1_Channel1_IRQHandler, Haltproc
  .set DMA1_Channel2_3_IRQHandler, Haltproc
  .set DMA1_Channel4_5_IRQHandler, Haltproc
  .set ADC1_IRQHandler, Haltproc
  .set TIM1_BRK_UP_TRG_COM_IRQHandler, Haltproc
  .set TIM1_CC_IRQHandler, Haltproc
  .set TIM2_IRQHandler, Haltproc
  .set TIM3_IRQHandler, Haltproc
  .set TIM14_IRQHandler, Haltproc
  .set TIM16_IRQHandler, Haltproc
  .set TIM17_IRQHandler, Haltproc
  .set I2C1_IRQHandler, Haltproc
  .set SPI1_IRQHandler, Haltproc
  .set SPI2_IRQHandler, Haltproc
  .set USART1_IRQHandler, Haltproc
  .set USART2_IRQHandler, Haltproc
  .set CEC_CAN_IRQHandler, Haltproc
  .set USB_IRQHandler, Haltproc

  .text
  end;
end.
