unit stm32g030xx;
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
    RTC_TAMP_IRQn = 2,                
    FLASH_IRQn  = 3,                  
    RCC_IRQn    = 4,                  
    EXTI0_1_IRQn = 5,                 
    EXTI2_3_IRQn = 6,                 
    EXTI4_15_IRQn = 7,                
    DMA1_Channel1_IRQn = 9,           
    DMA1_Channel2_3_IRQn = 10,        
    DMA1_Ch4_5_DMAMUX1_OVR_IRQn = 11, 
    ADC1_IRQn   = 12,                 
    TIM1_BRK_UP_TRG_COM_IRQn = 13,    
    TIM1_CC_IRQn = 14,                
    TIM3_IRQn   = 16,                 
    TIM14_IRQn  = 19,                 
    TIM16_IRQn  = 21,                 
    TIM17_IRQn  = 22,                 
    I2C1_IRQn   = 23,                 
    I2C2_IRQn   = 24,                 
    SPI1_IRQn   = 25,                 
    SPI2_IRQn   = 26,                 
    USART1_IRQn = 27,                 
    USART2_IRQn = 28                  
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
    TR1         : longword;
    TR2         : longword;
    CHSELR      : longword;
    TR3         : longword;
    RESERVED3   : array[0..3] of longword;
    DR          : longword;
    RESERVED4   : array[0..22] of longword;
    AWD2CR      : longword;
    AWD3CR      : longword;
    RESERVED5   : array[0..2] of longword;
    CALFACT     : longword;
  end;

  TADC_Common_Registers = record
    CCR         : longword;
  end;

  TCRC_Registers = record
    DR          : longword;
    IDR         : longword;
    CR          : longword;
    RESERVED1   : longword;
    INIT        : longword;
    POL         : longword;
  end;

  TDBG_Registers = record
    IDCODE      : longword;
    CR          : longword;
    APBFZ1      : longword;
    APBFZ2      : longword;
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

  TDMAMUX_Channel_Registers = record
    CCR         : longword;
  end;

  TDMAMUX_ChannelStatus_Registers = record
    CSR         : longword;
    CFR         : longword;
  end;

  TDMAMUX_RequestGen_Registers = record
    RGCR        : longword;
  end;

  TDMAMUX_RequestGenStatus_Registers = record
    RGSR        : longword;
    RGCFR       : longword;
  end;

  TEXTI_Registers = record
    RTSR1       : longword;
    FTSR1       : longword;
    SWIER1      : longword;
    RPR1        : longword;
    FPR1        : longword;
    RESERVED1   : array[0..2] of longword;
    RESERVED2   : array[0..4] of longword;
    RESERVED3   : array[0..10] of longword;
    EXTICR      : array[0..3] of longword;
    RESERVED4   : array[0..3] of longword;
    IMR1        : longword;
    EMR1        : longword;
  end;

  TFLASH_Registers = record
    ACR         : longword;
    RESERVED1   : longword;
    KEYR        : longword;
    OPTKEYR     : longword;
    SR          : longword;
    CR          : longword;
    ECCR        : longword;
    RESERVED2   : longword;
    OPTR        : longword;
    RESERVED3   : array[0..1] of longword;
    WRP1AR      : longword;
    WRP1BR      : longword;
    RESERVED4   : array[0..1] of longword;
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
    CR1         : longword;
    RESERVED0   : longword;
    CR3         : longword;
    CR4         : longword;
    SR1         : longword;
    SR2         : longword;
    SCR         : longword;
    RESERVED1   : longword;
    PUCRA       : longword;
    PDCRA       : longword;
    PUCRB       : longword;
    PDCRB       : longword;
    PUCRC       : longword;
    PDCRC       : longword;
    PUCRD       : longword;
    PDCRD       : longword;
    RESERVED2   : longword;
    RESERVED3   : longword;
    PUCRF       : longword;
    PDCRF       : longword;
  end;

  TRCC_Registers = record
    CR          : longword;
    ICSCR       : longword;
    CFGR        : longword;
    PLLCFGR     : longword;
    RESERVED0   : longword;
    RESERVED1   : longword;
    CIER        : longword;
    CIFR        : longword;
    CICR        : longword;
    IOPRSTR     : longword;
    AHBRSTR     : longword;
    APBRSTR1    : longword;
    APBRSTR2    : longword;
    IOPENR      : longword;
    AHBENR      : longword;
    APBENR1     : longword;
    APBENR2     : longword;
    IOPSMENR    : longword;
    AHBSMENR    : longword;
    APBSMENR1   : longword;
    APBSMENR2   : longword;
    CCIPR       : longword;
    RESERVED2   : longword;
    BDCR        : longword;
    CSR         : longword;
  end;

  TRTC_Registers = record
    TR          : longword;
    DR          : longword;
    SSR         : longword;
    ICSR        : longword;
    PRER        : longword;
    WUTR        : longword;
    CR          : longword;
    RESERVED0   : longword;
    RESERVED1   : longword;
    WPR         : longword;
    CALR        : longword;
    SHIFTR      : longword;
    TSTR        : longword;
    TSDR        : longword;
    TSSSR       : longword;
    RESERVED2   : longword;
    ALRMAR      : longword;
    ALRMASSR    : longword;
    ALRMBR      : longword;
    ALRMBSSR    : longword;
    SR          : longword;
    MISR        : longword;
    RESERVED3   : longword;
    SCR         : longword;
    &OR         : longword;
  end;

  TTAMP_Registers = record
    CR1         : longword;
    CR2         : longword;
    RESERVED0   : longword;
    FLTCR       : longword;
    RESERVED1   : array[0..6] of longword;
    IER         : longword;
    SR          : longword;
    MISR        : longword;
    RESERVED2   : longword;
    SCR         : longword;
    RESERVED3   : array[0..47] of longword;
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

  TSYSCFG_Registers = record
    CFGR1       : longword;
    RESERVED0   : array[0..4] of longword;
    CFGR2       : longword;
    RESERVED1   : array[0..24] of longword;
    IT_LINE_SR  : array[0..31] of longword;
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
    OR1         : longword;
    CCMR3       : longword;
    CCR5        : longword;
    CCR6        : longword;
    AF1         : longword;
    AF2         : longword;
    TISEL       : longword;
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
    RDR         : longword;
    TDR         : longword;
    PRESC       : longword;
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
  IOPORT_BASE   = $50000000;
  APBPERIPH_BASE= PERIPH_BASE;
  AHBPERIPH_BASE= PERIPH_BASE + $00020000;
  TIM3_BASE     = APBPERIPH_BASE + $00000400;
  TIM14_BASE    = APBPERIPH_BASE + $00002000;
  RTC_BASE      = APBPERIPH_BASE + $00002800;
  WWDG_BASE     = APBPERIPH_BASE + $00002C00;
  IWDG_BASE     = APBPERIPH_BASE + $00003000;
  SPI2_BASE     = APBPERIPH_BASE + $00003800;
  USART2_BASE   = APBPERIPH_BASE + $00004400;
  I2C1_BASE     = APBPERIPH_BASE + $00005400;
  I2C2_BASE     = APBPERIPH_BASE + $00005800;
  PWR_BASE      = APBPERIPH_BASE + $00007000;
  TAMP_BASE     = APBPERIPH_BASE + $0000B000;
  SYSCFG_BASE   = APBPERIPH_BASE + $00010000;
  ADC1_BASE     = APBPERIPH_BASE + $00012400;
  ADC1_COMMON_BASE= APBPERIPH_BASE + $00012708;
  ADC_BASE      = ADC1_COMMON_BASE;
  TIM1_BASE     = APBPERIPH_BASE + $00012C00;
  SPI1_BASE     = APBPERIPH_BASE + $00013000;
  USART1_BASE   = APBPERIPH_BASE + $00013800;
  TIM16_BASE    = APBPERIPH_BASE + $00014400;
  TIM17_BASE    = APBPERIPH_BASE + $00014800;
  DBG_BASE      = APBPERIPH_BASE + $00015800;
  DMA1_BASE     = AHBPERIPH_BASE;
  DMAMUX1_BASE  = AHBPERIPH_BASE + $00000800;
  RCC_BASE      = AHBPERIPH_BASE + $00001000;
  EXTI_BASE     = AHBPERIPH_BASE + $00001800;
  FLASH_R_BASE  = AHBPERIPH_BASE + $00002000;
  CRC_BASE      = AHBPERIPH_BASE + $00003000;
  DMA1_Channel1_BASE= DMA1_BASE + $00000008;
  DMA1_Channel2_BASE= DMA1_BASE + $0000001C;
  DMA1_Channel3_BASE= DMA1_BASE + $00000030;
  DMA1_Channel4_BASE= DMA1_BASE + $00000044;
  DMA1_Channel5_BASE= DMA1_BASE + $00000058;
  DMAMUX1_Channel0_BASE= DMAMUX1_BASE;
  DMAMUX1_Channel1_BASE= DMAMUX1_BASE + $00000004;
  DMAMUX1_Channel2_BASE= DMAMUX1_BASE + $00000008;
  DMAMUX1_Channel3_BASE= DMAMUX1_BASE + $0000000C;
  DMAMUX1_Channel4_BASE= DMAMUX1_BASE + $00000010;
  DMAMUX1_RequestGenerator0_BASE= DMAMUX1_BASE + $00000100;
  DMAMUX1_RequestGenerator1_BASE= DMAMUX1_BASE + $00000104;
  DMAMUX1_RequestGenerator2_BASE= DMAMUX1_BASE + $00000108;
  DMAMUX1_RequestGenerator3_BASE= DMAMUX1_BASE + $0000010C;
  DMAMUX1_ChannelStatus_BASE= DMAMUX1_BASE + $00000080;
  DMAMUX1_RequestGenStatus_BASE= DMAMUX1_BASE + $00000140;
  GPIOA_BASE    = IOPORT_BASE + $00000000;
  GPIOB_BASE    = IOPORT_BASE + $00000400;
  GPIOC_BASE    = IOPORT_BASE + $00000800;
  GPIOD_BASE    = IOPORT_BASE + $00000C00;
  GPIOF_BASE    = IOPORT_BASE + $00001400;
  PACKAGE_BASE  = $1FFF7500;
  UID_BASE      = $1FFF7590;
  FLASHSIZE_BASE= $1FFF75E0;

var
  TIM3          : TTIM_Registers absolute TIM3_BASE;
  TIM14         : TTIM_Registers absolute TIM14_BASE;
  RTC           : TRTC_Registers absolute RTC_BASE;
  TAMP          : TTAMP_Registers absolute TAMP_BASE;
  WWDG          : TWWDG_Registers absolute WWDG_BASE;
  IWDG          : TIWDG_Registers absolute IWDG_BASE;
  SPI2          : TSPI_Registers absolute SPI2_BASE;
  USART2        : TUSART_Registers absolute USART2_BASE;
  I2C1          : TI2C_Registers absolute I2C1_BASE;
  I2C2          : TI2C_Registers absolute I2C2_BASE;
  PWR           : TPWR_Registers absolute PWR_BASE;
  RCC           : TRCC_Registers absolute RCC_BASE;
  EXTI          : TEXTI_Registers absolute EXTI_BASE;
  SYSCFG        : TSYSCFG_Registers absolute SYSCFG_BASE;
  TIM1          : TTIM_Registers absolute TIM1_BASE;
  SPI1          : TSPI_Registers absolute SPI1_BASE;
  USART1        : TUSART_Registers absolute USART1_BASE;
  TIM16         : TTIM_Registers absolute TIM16_BASE;
  TIM17         : TTIM_Registers absolute TIM17_BASE;
  DMA1          : TDMA_Registers absolute DMA1_BASE;
  FLASH         : TFLASH_Registers absolute FLASH_R_BASE;
  CRC           : TCRC_Registers absolute CRC_BASE;
  GPIOA         : TGPIO_Registers absolute GPIOA_BASE;
  GPIOB         : TGPIO_Registers absolute GPIOB_BASE;
  GPIOC         : TGPIO_Registers absolute GPIOC_BASE;
  GPIOD         : TGPIO_Registers absolute GPIOD_BASE;
  GPIOF         : TGPIO_Registers absolute GPIOF_BASE;
  ADC1          : TADC_Registers absolute ADC1_BASE;
  ADC1_COMMON   : TADC_Common_Registers absolute ADC1_COMMON_BASE;
  DMA1_Channel1 : TDMA_Channel_Registers absolute DMA1_Channel1_BASE;
  DMA1_Channel2 : TDMA_Channel_Registers absolute DMA1_Channel2_BASE;
  DMA1_Channel3 : TDMA_Channel_Registers absolute DMA1_Channel3_BASE;
  DMA1_Channel4 : TDMA_Channel_Registers absolute DMA1_Channel4_BASE;
  DMA1_Channel5 : TDMA_Channel_Registers absolute DMA1_Channel5_BASE;
  DMAMUX1       : TDMAMUX_Channel_Registers absolute DMAMUX1_BASE;
  DMAMUX1_Channel0: TDMAMUX_Channel_Registers absolute DMAMUX1_Channel0_BASE;
  DMAMUX1_Channel1: TDMAMUX_Channel_Registers absolute DMAMUX1_Channel1_BASE;
  DMAMUX1_Channel2: TDMAMUX_Channel_Registers absolute DMAMUX1_Channel2_BASE;
  DMAMUX1_Channel3: TDMAMUX_Channel_Registers absolute DMAMUX1_Channel3_BASE;
  DMAMUX1_Channel4: TDMAMUX_Channel_Registers absolute DMAMUX1_Channel4_BASE;
  DMAMUX1_RequestGenerator0: TDMAMUX_RequestGen_Registers absolute DMAMUX1_RequestGenerator0_BASE;
  DMAMUX1_RequestGenerator1: TDMAMUX_RequestGen_Registers absolute DMAMUX1_RequestGenerator1_BASE;
  DMAMUX1_RequestGenerator2: TDMAMUX_RequestGen_Registers absolute DMAMUX1_RequestGenerator2_BASE;
  DMAMUX1_RequestGenerator3: TDMAMUX_RequestGen_Registers absolute DMAMUX1_RequestGenerator3_BASE;
  DMAMUX1_ChannelStatus: TDMAMUX_ChannelStatus_Registers absolute DMAMUX1_ChannelStatus_BASE;
  DMAMUX1_RequestGenStatus: TDMAMUX_RequestGenStatus_Registers absolute DMAMUX1_RequestGenStatus_BASE;
  DBG           : TDBG_Registers absolute DBG_BASE;

implementation

procedure NonMaskableInt_Handler; external name 'NonMaskableInt_Handler';
procedure HardFault_Handler; external name 'HardFault_Handler';
procedure SVC_Handler; external name 'SVC_Handler';
procedure PendSV_Handler; external name 'PendSV_Handler';
procedure SysTick_Handler; external name 'SysTick_Handler';
procedure WWDG_IRQHandler; external name 'WWDG_IRQHandler';
procedure RTC_TAMP_IRQHandler; external name 'RTC_TAMP_IRQHandler';
procedure FLASH_IRQHandler; external name 'FLASH_IRQHandler';
procedure RCC_IRQHandler; external name 'RCC_IRQHandler';
procedure EXTI0_1_IRQHandler; external name 'EXTI0_1_IRQHandler';
procedure EXTI2_3_IRQHandler; external name 'EXTI2_3_IRQHandler';
procedure EXTI4_15_IRQHandler; external name 'EXTI4_15_IRQHandler';
procedure DMA1_Channel1_IRQHandler; external name 'DMA1_Channel1_IRQHandler';
procedure DMA1_Channel2_3_IRQHandler; external name 'DMA1_Channel2_3_IRQHandler';
procedure DMA1_Ch4_5_DMAMUX1_OVR_IRQHandler; external name 'DMA1_Ch4_5_DMAMUX1_OVR_IRQHandler';
procedure ADC1_IRQHandler; external name 'ADC1_IRQHandler';
procedure TIM1_BRK_UP_TRG_COM_IRQHandler; external name 'TIM1_BRK_UP_TRG_COM_IRQHandler';
procedure TIM1_CC_IRQHandler; external name 'TIM1_CC_IRQHandler';
procedure TIM3_IRQHandler; external name 'TIM3_IRQHandler';
procedure TIM14_IRQHandler; external name 'TIM14_IRQHandler';
procedure TIM16_IRQHandler; external name 'TIM16_IRQHandler';
procedure TIM17_IRQHandler; external name 'TIM17_IRQHandler';
procedure I2C1_IRQHandler; external name 'I2C1_IRQHandler';
procedure I2C2_IRQHandler; external name 'I2C2_IRQHandler';
procedure SPI1_IRQHandler; external name 'SPI1_IRQHandler';
procedure SPI2_IRQHandler; external name 'SPI2_IRQHandler';
procedure USART1_IRQHandler; external name 'USART1_IRQHandler';
procedure USART2_IRQHandler; external name 'USART2_IRQHandler';


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
  .long 0
  .long RTC_TAMP_IRQHandler
  .long FLASH_IRQHandler
  .long RCC_IRQHandler
  .long EXTI0_1_IRQHandler
  .long EXTI2_3_IRQHandler
  .long EXTI4_15_IRQHandler
  .long 0
  .long DMA1_Channel1_IRQHandler
  .long DMA1_Channel2_3_IRQHandler
  .long DMA1_Ch4_5_DMAMUX1_OVR_IRQHandler
  .long ADC1_IRQHandler
  .long TIM1_BRK_UP_TRG_COM_IRQHandler
  .long TIM1_CC_IRQHandler
  .long 0
  .long TIM3_IRQHandler
  .long 0
  .long 0
  .long TIM14_IRQHandler
  .long 0
  .long TIM16_IRQHandler
  .long TIM17_IRQHandler
  .long I2C1_IRQHandler
  .long I2C2_IRQHandler
  .long SPI1_IRQHandler
  .long SPI2_IRQHandler
  .long USART1_IRQHandler
  .long USART2_IRQHandler

  .weak NonMaskableInt_Handler
  .weak HardFault_Handler
  .weak SVC_Handler
  .weak PendSV_Handler
  .weak SysTick_Handler
  .weak WWDG_IRQHandler
  .weak RTC_TAMP_IRQHandler
  .weak FLASH_IRQHandler
  .weak RCC_IRQHandler
  .weak EXTI0_1_IRQHandler
  .weak EXTI2_3_IRQHandler
  .weak EXTI4_15_IRQHandler
  .weak DMA1_Channel1_IRQHandler
  .weak DMA1_Channel2_3_IRQHandler
  .weak DMA1_Ch4_5_DMAMUX1_OVR_IRQHandler
  .weak ADC1_IRQHandler
  .weak TIM1_BRK_UP_TRG_COM_IRQHandler
  .weak TIM1_CC_IRQHandler
  .weak TIM3_IRQHandler
  .weak TIM14_IRQHandler
  .weak TIM16_IRQHandler
  .weak TIM17_IRQHandler
  .weak I2C1_IRQHandler
  .weak I2C2_IRQHandler
  .weak SPI1_IRQHandler
  .weak SPI2_IRQHandler
  .weak USART1_IRQHandler
  .weak USART2_IRQHandler

  .set NonMaskableInt_Handler, _NonMaskableInt_Handler
  .set HardFault_Handler, _HardFault_Handler
  .set SVC_Handler, _SVC_Handler
  .set PendSV_Handler, _PendSV_Handler
  .set SysTick_Handler, _SysTick_Handler
  .set WWDG_IRQHandler, Haltproc
  .set RTC_TAMP_IRQHandler, Haltproc
  .set FLASH_IRQHandler, Haltproc
  .set RCC_IRQHandler, Haltproc
  .set EXTI0_1_IRQHandler, Haltproc
  .set EXTI2_3_IRQHandler, Haltproc
  .set EXTI4_15_IRQHandler, Haltproc
  .set DMA1_Channel1_IRQHandler, Haltproc
  .set DMA1_Channel2_3_IRQHandler, Haltproc
  .set DMA1_Ch4_5_DMAMUX1_OVR_IRQHandler, Haltproc
  .set ADC1_IRQHandler, Haltproc
  .set TIM1_BRK_UP_TRG_COM_IRQHandler, Haltproc
  .set TIM1_CC_IRQHandler, Haltproc
  .set TIM3_IRQHandler, Haltproc
  .set TIM14_IRQHandler, Haltproc
  .set TIM16_IRQHandler, Haltproc
  .set TIM17_IRQHandler, Haltproc
  .set I2C1_IRQHandler, Haltproc
  .set I2C2_IRQHandler, Haltproc
  .set SPI1_IRQHandler, Haltproc
  .set SPI2_IRQHandler, Haltproc
  .set USART1_IRQHandler, Haltproc
  .set USART2_IRQHandler, Haltproc

  .text
  end;
end.
