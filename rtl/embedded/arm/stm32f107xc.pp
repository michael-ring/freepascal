unit stm32f107xc;
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
    PVD_IRQn    = 1,                  
    TAMPER_IRQn = 2,                  
    RTC_IRQn    = 3,                  
    FLASH_IRQn  = 4,                  
    RCC_IRQn    = 5,                  
    EXTI0_IRQn  = 6,                  
    EXTI1_IRQn  = 7,                  
    EXTI2_IRQn  = 8,                  
    EXTI3_IRQn  = 9,                  
    EXTI4_IRQn  = 10,                 
    DMA1_Channel1_IRQn = 11,          
    DMA1_Channel2_IRQn = 12,          
    DMA1_Channel3_IRQn = 13,          
    DMA1_Channel4_IRQn = 14,          
    DMA1_Channel5_IRQn = 15,          
    DMA1_Channel6_IRQn = 16,          
    DMA1_Channel7_IRQn = 17,          
    ADC1_2_IRQn = 18,                 
    CAN1_TX_IRQn = 19,                
    CAN1_RX0_IRQn = 20,               
    CAN1_RX1_IRQn = 21,               
    CAN1_SCE_IRQn = 22,               
    EXTI9_5_IRQn = 23,                
    TIM1_BRK_IRQn = 24,               
    TIM1_UP_IRQn = 25,                
    TIM1_TRG_COM_IRQn = 26,           
    TIM1_CC_IRQn = 27,                
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
    OTG_FS_WKUP_IRQn = 42,            
    TIM5_IRQn   = 50,                 
    SPI3_IRQn   = 51,                 
    UART4_IRQn  = 52,                 
    UART5_IRQn  = 53,                 
    TIM6_IRQn   = 54,                 
    TIM7_IRQn   = 55,                 
    DMA2_Channel1_IRQn = 56,          
    DMA2_Channel2_IRQn = 57,          
    DMA2_Channel3_IRQn = 58,          
    DMA2_Channel4_IRQn = 59,          
    DMA2_Channel5_IRQn = 60,          
    ETH_IRQn    = 61,                 
    ETH_WKUP_IRQn = 62,               
    CAN2_TX_IRQn = 63,                
    CAN2_RX0_IRQn = 64,               
    CAN2_RX1_IRQn = 65,               
    CAN2_SCE_IRQn = 66,               
    OTG_FS_IRQn = 67                  
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

  TBKP_Registers = record
    RESERVED0   : longword;
    DR1         : longword;
    DR2         : longword;
    DR3         : longword;
    DR4         : longword;
    DR5         : longword;
    DR6         : longword;
    DR7         : longword;
    DR8         : longword;
    DR9         : longword;
    DR10        : longword;
    RTCCR       : longword;
    CR          : longword;
    CSR         : longword;
    RESERVED13  : array[0..1] of longword;
    DR11        : longword;
    DR12        : longword;
    DR13        : longword;
    DR14        : longword;
    DR15        : longword;
    DR16        : longword;
    DR17        : longword;
    DR18        : longword;
    DR19        : longword;
    DR20        : longword;
    DR21        : longword;
    DR22        : longword;
    DR23        : longword;
    DR24        : longword;
    DR25        : longword;
    DR26        : longword;
    DR27        : longword;
    DR28        : longword;
    DR29        : longword;
    DR30        : longword;
    DR31        : longword;
    DR32        : longword;
    DR33        : longword;
    DR34        : longword;
    DR35        : longword;
    DR36        : longword;
    DR37        : longword;
    DR38        : longword;
    DR39        : longword;
    DR40        : longword;
    DR41        : longword;
    DR42        : longword;
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

  TCRC_Registers = record
    DR          : longword;
    IDR         : byte;
    RESERVED0   : byte;
    RESERVED1   : word;
    CR          : longword;
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
  end;

  TDBGMCU_Registers = record
    IDCODE      : longword;
    CR          : longword;
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

  TETH_Registers = record
    MACCR       : longword;
    MACFFR      : longword;
    MACHTHR     : longword;
    MACHTLR     : longword;
    MACMIIAR    : longword;
    MACMIIDR    : longword;
    MACFCR      : longword;
    MACVLANTR   : longword;
    RESERVED0   : array[0..1] of longword;
    MACRWUFFR   : longword;
    MACPMTCSR   : longword;
    RESERVED1   : array[0..1] of longword;
    MACSR       : longword;
    MACIMR      : longword;
    MACA0HR     : longword;
    MACA0LR     : longword;
    MACA1HR     : longword;
    MACA1LR     : longword;
    MACA2HR     : longword;
    MACA2LR     : longword;
    MACA3HR     : longword;
    MACA3LR     : longword;
    RESERVED2   : array[0..39] of longword;
    MMCCR       : longword;
    MMCRIR      : longword;
    MMCTIR      : longword;
    MMCRIMR     : longword;
    MMCTIMR     : longword;
    RESERVED3   : array[0..13] of longword;
    MMCTGFSCCR  : longword;
    MMCTGFMSCCR : longword;
    RESERVED4   : array[0..4] of longword;
    MMCTGFCR    : longword;
    RESERVED5   : array[0..9] of longword;
    MMCRFCECR   : longword;
    MMCRFAECR   : longword;
    RESERVED6   : array[0..9] of longword;
    MMCRGUFCR   : longword;
    RESERVED7   : array[0..333] of longword;
    PTPTSCR     : longword;
    PTPSSIR     : longword;
    PTPTSHR     : longword;
    PTPTSLR     : longword;
    PTPTSHUR    : longword;
    PTPTSLUR    : longword;
    PTPTSAR     : longword;
    PTPTTHR     : longword;
    PTPTTLR     : longword;
    RESERVED8   : array[0..566] of longword;
    DMABMR      : longword;
    DMATPDR     : longword;
    DMARPDR     : longword;
    DMARDLAR    : longword;
    DMATDLAR    : longword;
    DMASR       : longword;
    DMAOMR      : longword;
    DMAIER      : longword;
    DMAMFBOCR   : longword;
    RESERVED9   : array[0..8] of longword;
    DMACHTDR    : longword;
    DMACHRDR    : longword;
    DMACHTBAR   : longword;
    DMACHRBAR   : longword;
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
    CRL         : longword;
    CRH         : longword;
    IDR         : longword;
    ODR         : longword;
    BSRR        : longword;
    BRR         : longword;
    LCKR        : longword;
  end;

  TAFIO_Registers = record
    EVCR        : longword;
    MAPR        : longword;
    EXTICR      : array[0..3] of longword;
    RESERVED0   : longword;
    MAPR2       : longword;
  end;

  TI2C_Registers = record
    CR1         : longword;
    CR2         : longword;
    OAR1        : longword;
    OAR2        : longword;
    DR          : longword;
    SR1         : longword;
    SR2         : longword;
    CCR         : longword;
    TRISE       : longword;
  end;

  TIWDG_Registers = record
    KR          : longword;
    PR          : longword;
    RLR         : longword;
    SR          : longword;
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
  end;

  TRTC_Registers = record
    CRH         : longword;
    CRL         : longword;
    PRLH        : longword;
    PRLL        : longword;
    DIVH        : longword;
    DIVL        : longword;
    CNTH        : longword;
    CNTL        : longword;
    ALRH        : longword;
    ALRL        : longword;
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

  TUSART_Registers = record
    SR          : longword;
    DR          : longword;
    BRR         : longword;
    CR1         : longword;
    CR2         : longword;
    CR3         : longword;
    GTPR        : longword;
  end;

  TUSB_OTG_Global_Registers = record
    GOTGCTL     : longword;
    GOTGINT     : longword;
    GAHBCFG     : longword;
    GUSBCFG     : longword;
    GRSTCTL     : longword;
    GINTSTS     : longword;
    GINTMSK     : longword;
    GRXSTSR     : longword;
    GRXSTSP     : longword;
    GRXFSIZ     : longword;
    DIEPTXF0_HNPTXFSIZ : longword;
    HNPTXSTS    : longword;
    Reserved30  : array[0..1] of longword;
    GCCFG       : longword;
    CID         : longword;
    Reserved40  : array[0..47] of longword;
    HPTXFSIZ    : longword;
    DIEPTXF     : array[0..14] of longword;
  end;

  TUSB_OTG_Device_Registers = record
    DCFG        : longword;
    DCTL        : longword;
    DSTS        : longword;
    Reserved0C  : longword;
    DIEPMSK     : longword;
    DOEPMSK     : longword;
    DAINT       : longword;
    DAINTMSK    : longword;
    Reserved20  : longword;
    Reserved9   : longword;
    DVBUSDIS    : longword;
    DVBUSPULSE  : longword;
    DTHRCTL     : longword;
    DIEPEMPMSK  : longword;
    DEACHINT    : longword;
    DEACHMSK    : longword;
    Reserved40  : longword;
    DINEP1MSK   : longword;
    Reserved44  : array[0..14] of longword;
    DOUTEP1MSK  : longword;
  end;

  TUSB_OTG_INEndpoint_Registers = record
    DIEPCTL     : longword;
    Reserved04  : longword;
    DIEPINT     : longword;
    Reserved0C  : longword;
    DIEPTSIZ    : longword;
    DIEPDMA     : longword;
    DTXFSTS     : longword;
    Reserved18  : longword;
  end;

  TUSB_OTG_OUTEndpoint_Registers = record
    DOEPCTL     : longword;
    Reserved04  : longword;
    DOEPINT     : longword;
    Reserved0C  : longword;
    DOEPTSIZ    : longword;
    DOEPDMA     : longword;
    Reserved18  : array[0..1] of longword;
  end;

  TUSB_OTG_Host_Registers = record
    HCFG        : longword;
    HFIR        : longword;
    HFNUM       : longword;
    Reserved40C : longword;
    HPTXSTS     : longword;
    HAINT       : longword;
    HAINTMSK    : longword;
  end;

  TUSB_OTG_HostChannel_Registers = record
    HCCHAR      : longword;
    HCSPLT      : longword;
    HCINT       : longword;
    HCINTMSK    : longword;
    HCTSIZ      : longword;
    HCDMA       : longword;
    Reserved    : array[0..1] of longword;
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
  AHBPERIPH_BASE= PERIPH_BASE + $00020000;
  TIM2_BASE     = APB1PERIPH_BASE + $00000000;
  TIM3_BASE     = APB1PERIPH_BASE + $00000400;
  TIM4_BASE     = APB1PERIPH_BASE + $00000800;
  TIM5_BASE     = APB1PERIPH_BASE + $00000C00;
  TIM6_BASE     = APB1PERIPH_BASE + $00001000;
  TIM7_BASE     = APB1PERIPH_BASE + $00001400;
  RTC_BASE      = APB1PERIPH_BASE + $00002800;
  WWDG_BASE     = APB1PERIPH_BASE + $00002C00;
  IWDG_BASE     = APB1PERIPH_BASE + $00003000;
  SPI2_BASE     = APB1PERIPH_BASE + $00003800;
  SPI3_BASE     = APB1PERIPH_BASE + $00003C00;
  USART2_BASE   = APB1PERIPH_BASE + $00004400;
  USART3_BASE   = APB1PERIPH_BASE + $00004800;
  UART4_BASE    = APB1PERIPH_BASE + $00004C00;
  UART5_BASE    = APB1PERIPH_BASE + $00005000;
  I2C1_BASE     = APB1PERIPH_BASE + $00005400;
  I2C2_BASE     = APB1PERIPH_BASE + $00005800;
  CAN1_BASE     = APB1PERIPH_BASE + $00006400;
  CAN2_BASE     = APB1PERIPH_BASE + $00006800;
  BKP_BASE      = APB1PERIPH_BASE + $00006C00;
  PWR_BASE      = APB1PERIPH_BASE + $00007000;
  DAC_BASE      = APB1PERIPH_BASE + $00007400;
  AFIO_BASE     = APB2PERIPH_BASE + $00000000;
  EXTI_BASE     = APB2PERIPH_BASE + $00000400;
  GPIOA_BASE    = APB2PERIPH_BASE + $00000800;
  GPIOB_BASE    = APB2PERIPH_BASE + $00000C00;
  GPIOC_BASE    = APB2PERIPH_BASE + $00001000;
  GPIOD_BASE    = APB2PERIPH_BASE + $00001400;
  GPIOE_BASE    = APB2PERIPH_BASE + $00001800;
  ADC1_BASE     = APB2PERIPH_BASE + $00002400;
  ADC2_BASE     = APB2PERIPH_BASE + $00002800;
  TIM1_BASE     = APB2PERIPH_BASE + $00002C00;
  SPI1_BASE     = APB2PERIPH_BASE + $00003000;
  USART1_BASE   = APB2PERIPH_BASE + $00003800;
  DMA1_BASE     = AHBPERIPH_BASE + $00000000;
  DMA1_Channel1_BASE= AHBPERIPH_BASE + $00000008;
  DMA1_Channel2_BASE= AHBPERIPH_BASE + $0000001C;
  DMA1_Channel3_BASE= AHBPERIPH_BASE + $00000030;
  DMA1_Channel4_BASE= AHBPERIPH_BASE + $00000044;
  DMA1_Channel5_BASE= AHBPERIPH_BASE + $00000058;
  DMA1_Channel6_BASE= AHBPERIPH_BASE + $0000006C;
  DMA1_Channel7_BASE= AHBPERIPH_BASE + $00000080;
  DMA2_BASE     = AHBPERIPH_BASE + $00000400;
  DMA2_Channel1_BASE= AHBPERIPH_BASE + $00000408;
  DMA2_Channel2_BASE= AHBPERIPH_BASE + $0000041C;
  DMA2_Channel3_BASE= AHBPERIPH_BASE + $00000430;
  DMA2_Channel4_BASE= AHBPERIPH_BASE + $00000444;
  DMA2_Channel5_BASE= AHBPERIPH_BASE + $00000458;
  RCC_BASE      = AHBPERIPH_BASE + $00001000;
  CRC_BASE      = AHBPERIPH_BASE + $00003000;
  FLASH_R_BASE  = AHBPERIPH_BASE + $00002000;
  FLASHSIZE_BASE= $1FFFF7E0;
  UID_BASE      = $1FFFF7E8;
  OB_BASE       = $1FFFF800;
  ETH_BASE      = AHBPERIPH_BASE + $00008000;
  ETH_MAC_BASE  = ETH_BASE;
  ETH_MMC_BASE  = ETH_BASE + $00000100;
  ETH_PTP_BASE  = ETH_BASE + $00000700;
  ETH_DMA_BASE  = ETH_BASE + $00001000;
  DBGMCU_BASE   = $E0042000;
  USB_OTG_FS_PERIPH_BASE= $50000000;
  USB_OTG_GLOBAL_BASE= $00000000;
  USB_OTG_DEVICE_BASE= $00000800;
  USB_OTG_IN_ENDPOINT_BASE= $00000900;
  USB_OTG_OUT_ENDPOINT_BASE= $00000B00;
  USB_OTG_HOST_BASE= $00000400;
  USB_OTG_HOST_PORT_BASE= $00000440;
  USB_OTG_HOST_CHANNEL_BASE= $00000500;
  USB_OTG_PCGCCTL_BASE= $00000E00;
  USB_OTG_FIFO_BASE= $00001000;

var
  TIM2          : TTIM_Registers absolute TIM2_BASE;
  TIM3          : TTIM_Registers absolute TIM3_BASE;
  TIM4          : TTIM_Registers absolute TIM4_BASE;
  TIM5          : TTIM_Registers absolute TIM5_BASE;
  TIM6          : TTIM_Registers absolute TIM6_BASE;
  TIM7          : TTIM_Registers absolute TIM7_BASE;
  RTC           : TRTC_Registers absolute RTC_BASE;
  WWDG          : TWWDG_Registers absolute WWDG_BASE;
  IWDG          : TIWDG_Registers absolute IWDG_BASE;
  SPI2          : TSPI_Registers absolute SPI2_BASE;
  SPI3          : TSPI_Registers absolute SPI3_BASE;
  USART2        : TUSART_Registers absolute USART2_BASE;
  USART3        : TUSART_Registers absolute USART3_BASE;
  UART4         : TUSART_Registers absolute UART4_BASE;
  UART5         : TUSART_Registers absolute UART5_BASE;
  I2C1          : TI2C_Registers absolute I2C1_BASE;
  I2C2          : TI2C_Registers absolute I2C2_BASE;
  CAN1          : TCAN_Registers absolute CAN1_BASE;
  CAN2          : TCAN_Registers absolute CAN2_BASE;
  BKP           : TBKP_Registers absolute BKP_BASE;
  PWR           : TPWR_Registers absolute PWR_BASE;
  DAC1          : TDAC_Registers absolute DAC_BASE;
  DAC           : TDAC_Registers absolute DAC_BASE;
  AFIO          : TAFIO_Registers absolute AFIO_BASE;
  EXTI          : TEXTI_Registers absolute EXTI_BASE;
  GPIOA         : TGPIO_Registers absolute GPIOA_BASE;
  GPIOB         : TGPIO_Registers absolute GPIOB_BASE;
  GPIOC         : TGPIO_Registers absolute GPIOC_BASE;
  GPIOD         : TGPIO_Registers absolute GPIOD_BASE;
  GPIOE         : TGPIO_Registers absolute GPIOE_BASE;
  ADC1          : TADC_Registers absolute ADC1_BASE;
  ADC2          : TADC_Registers absolute ADC2_BASE;
  ADC12_COMMON  : TADC_Common_Registers absolute ADC1_BASE;
  TIM1          : TTIM_Registers absolute TIM1_BASE;
  SPI1          : TSPI_Registers absolute SPI1_BASE;
  USART1        : TUSART_Registers absolute USART1_BASE;
  DMA1          : TDMA_Registers absolute DMA1_BASE;
  DMA2          : TDMA_Registers absolute DMA2_BASE;
  DMA1_Channel1 : TDMA_Channel_Registers absolute DMA1_Channel1_BASE;
  DMA1_Channel2 : TDMA_Channel_Registers absolute DMA1_Channel2_BASE;
  DMA1_Channel3 : TDMA_Channel_Registers absolute DMA1_Channel3_BASE;
  DMA1_Channel4 : TDMA_Channel_Registers absolute DMA1_Channel4_BASE;
  DMA1_Channel5 : TDMA_Channel_Registers absolute DMA1_Channel5_BASE;
  DMA1_Channel6 : TDMA_Channel_Registers absolute DMA1_Channel6_BASE;
  DMA1_Channel7 : TDMA_Channel_Registers absolute DMA1_Channel7_BASE;
  DMA2_Channel1 : TDMA_Channel_Registers absolute DMA2_Channel1_BASE;
  DMA2_Channel2 : TDMA_Channel_Registers absolute DMA2_Channel2_BASE;
  DMA2_Channel3 : TDMA_Channel_Registers absolute DMA2_Channel3_BASE;
  DMA2_Channel4 : TDMA_Channel_Registers absolute DMA2_Channel4_BASE;
  DMA2_Channel5 : TDMA_Channel_Registers absolute DMA2_Channel5_BASE;
  RCC           : TRCC_Registers absolute RCC_BASE;
  CRC           : TCRC_Registers absolute CRC_BASE;
  FLASH         : TFLASH_Registers absolute FLASH_R_BASE;
  OB            : TOB_Registers absolute OB_BASE;
  ETH           : TETH_Registers absolute ETH_BASE;
  DBGMCU        : TDBGMCU_Registers absolute DBGMCU_BASE;

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
procedure PVD_IRQHandler; external name 'PVD_IRQHandler';
procedure TAMPER_IRQHandler; external name 'TAMPER_IRQHandler';
procedure RTC_IRQHandler; external name 'RTC_IRQHandler';
procedure FLASH_IRQHandler; external name 'FLASH_IRQHandler';
procedure RCC_IRQHandler; external name 'RCC_IRQHandler';
procedure EXTI0_IRQHandler; external name 'EXTI0_IRQHandler';
procedure EXTI1_IRQHandler; external name 'EXTI1_IRQHandler';
procedure EXTI2_IRQHandler; external name 'EXTI2_IRQHandler';
procedure EXTI3_IRQHandler; external name 'EXTI3_IRQHandler';
procedure EXTI4_IRQHandler; external name 'EXTI4_IRQHandler';
procedure DMA1_Channel1_IRQHandler; external name 'DMA1_Channel1_IRQHandler';
procedure DMA1_Channel2_IRQHandler; external name 'DMA1_Channel2_IRQHandler';
procedure DMA1_Channel3_IRQHandler; external name 'DMA1_Channel3_IRQHandler';
procedure DMA1_Channel4_IRQHandler; external name 'DMA1_Channel4_IRQHandler';
procedure DMA1_Channel5_IRQHandler; external name 'DMA1_Channel5_IRQHandler';
procedure DMA1_Channel6_IRQHandler; external name 'DMA1_Channel6_IRQHandler';
procedure DMA1_Channel7_IRQHandler; external name 'DMA1_Channel7_IRQHandler';
procedure ADC1_2_IRQHandler; external name 'ADC1_2_IRQHandler';
procedure CAN1_TX_IRQHandler; external name 'CAN1_TX_IRQHandler';
procedure CAN1_RX0_IRQHandler; external name 'CAN1_RX0_IRQHandler';
procedure CAN1_RX1_IRQHandler; external name 'CAN1_RX1_IRQHandler';
procedure CAN1_SCE_IRQHandler; external name 'CAN1_SCE_IRQHandler';
procedure EXTI9_5_IRQHandler; external name 'EXTI9_5_IRQHandler';
procedure TIM1_BRK_IRQHandler; external name 'TIM1_BRK_IRQHandler';
procedure TIM1_UP_IRQHandler; external name 'TIM1_UP_IRQHandler';
procedure TIM1_TRG_COM_IRQHandler; external name 'TIM1_TRG_COM_IRQHandler';
procedure TIM1_CC_IRQHandler; external name 'TIM1_CC_IRQHandler';
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
procedure OTG_FS_WKUP_IRQHandler; external name 'OTG_FS_WKUP_IRQHandler';
procedure TIM5_IRQHandler; external name 'TIM5_IRQHandler';
procedure SPI3_IRQHandler; external name 'SPI3_IRQHandler';
procedure UART4_IRQHandler; external name 'UART4_IRQHandler';
procedure UART5_IRQHandler; external name 'UART5_IRQHandler';
procedure TIM6_IRQHandler; external name 'TIM6_IRQHandler';
procedure TIM7_IRQHandler; external name 'TIM7_IRQHandler';
procedure DMA2_Channel1_IRQHandler; external name 'DMA2_Channel1_IRQHandler';
procedure DMA2_Channel2_IRQHandler; external name 'DMA2_Channel2_IRQHandler';
procedure DMA2_Channel3_IRQHandler; external name 'DMA2_Channel3_IRQHandler';
procedure DMA2_Channel4_IRQHandler; external name 'DMA2_Channel4_IRQHandler';
procedure DMA2_Channel5_IRQHandler; external name 'DMA2_Channel5_IRQHandler';
procedure ETH_IRQHandler; external name 'ETH_IRQHandler';
procedure ETH_WKUP_IRQHandler; external name 'ETH_WKUP_IRQHandler';
procedure CAN2_TX_IRQHandler; external name 'CAN2_TX_IRQHandler';
procedure CAN2_RX0_IRQHandler; external name 'CAN2_RX0_IRQHandler';
procedure CAN2_RX1_IRQHandler; external name 'CAN2_RX1_IRQHandler';
procedure CAN2_SCE_IRQHandler; external name 'CAN2_SCE_IRQHandler';
procedure OTG_FS_IRQHandler; external name 'OTG_FS_IRQHandler';


{$i cortexm3_start.inc}

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
  .long PVD_IRQHandler
  .long TAMPER_IRQHandler
  .long RTC_IRQHandler
  .long FLASH_IRQHandler
  .long RCC_IRQHandler
  .long EXTI0_IRQHandler
  .long EXTI1_IRQHandler
  .long EXTI2_IRQHandler
  .long EXTI3_IRQHandler
  .long EXTI4_IRQHandler
  .long DMA1_Channel1_IRQHandler
  .long DMA1_Channel2_IRQHandler
  .long DMA1_Channel3_IRQHandler
  .long DMA1_Channel4_IRQHandler
  .long DMA1_Channel5_IRQHandler
  .long DMA1_Channel6_IRQHandler
  .long DMA1_Channel7_IRQHandler
  .long ADC1_2_IRQHandler
  .long CAN1_TX_IRQHandler
  .long CAN1_RX0_IRQHandler
  .long CAN1_RX1_IRQHandler
  .long CAN1_SCE_IRQHandler
  .long EXTI9_5_IRQHandler
  .long TIM1_BRK_IRQHandler
  .long TIM1_UP_IRQHandler
  .long TIM1_TRG_COM_IRQHandler
  .long TIM1_CC_IRQHandler
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
  .long OTG_FS_WKUP_IRQHandler
  .long 0
  .long 0
  .long 0
  .long 0
  .long 0
  .long 0
  .long 0
  .long TIM5_IRQHandler
  .long SPI3_IRQHandler
  .long UART4_IRQHandler
  .long UART5_IRQHandler
  .long TIM6_IRQHandler
  .long TIM7_IRQHandler
  .long DMA2_Channel1_IRQHandler
  .long DMA2_Channel2_IRQHandler
  .long DMA2_Channel3_IRQHandler
  .long DMA2_Channel4_IRQHandler
  .long DMA2_Channel5_IRQHandler
  .long ETH_IRQHandler
  .long ETH_WKUP_IRQHandler
  .long CAN2_TX_IRQHandler
  .long CAN2_RX0_IRQHandler
  .long CAN2_RX1_IRQHandler
  .long CAN2_SCE_IRQHandler
  .long OTG_FS_IRQHandler

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
  .weak PVD_IRQHandler
  .weak TAMPER_IRQHandler
  .weak RTC_IRQHandler
  .weak FLASH_IRQHandler
  .weak RCC_IRQHandler
  .weak EXTI0_IRQHandler
  .weak EXTI1_IRQHandler
  .weak EXTI2_IRQHandler
  .weak EXTI3_IRQHandler
  .weak EXTI4_IRQHandler
  .weak DMA1_Channel1_IRQHandler
  .weak DMA1_Channel2_IRQHandler
  .weak DMA1_Channel3_IRQHandler
  .weak DMA1_Channel4_IRQHandler
  .weak DMA1_Channel5_IRQHandler
  .weak DMA1_Channel6_IRQHandler
  .weak DMA1_Channel7_IRQHandler
  .weak ADC1_2_IRQHandler
  .weak CAN1_TX_IRQHandler
  .weak CAN1_RX0_IRQHandler
  .weak CAN1_RX1_IRQHandler
  .weak CAN1_SCE_IRQHandler
  .weak EXTI9_5_IRQHandler
  .weak TIM1_BRK_IRQHandler
  .weak TIM1_UP_IRQHandler
  .weak TIM1_TRG_COM_IRQHandler
  .weak TIM1_CC_IRQHandler
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
  .weak OTG_FS_WKUP_IRQHandler
  .weak TIM5_IRQHandler
  .weak SPI3_IRQHandler
  .weak UART4_IRQHandler
  .weak UART5_IRQHandler
  .weak TIM6_IRQHandler
  .weak TIM7_IRQHandler
  .weak DMA2_Channel1_IRQHandler
  .weak DMA2_Channel2_IRQHandler
  .weak DMA2_Channel3_IRQHandler
  .weak DMA2_Channel4_IRQHandler
  .weak DMA2_Channel5_IRQHandler
  .weak ETH_IRQHandler
  .weak ETH_WKUP_IRQHandler
  .weak CAN2_TX_IRQHandler
  .weak CAN2_RX0_IRQHandler
  .weak CAN2_RX1_IRQHandler
  .weak CAN2_SCE_IRQHandler
  .weak OTG_FS_IRQHandler

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
  .set PVD_IRQHandler, Haltproc
  .set TAMPER_IRQHandler, Haltproc
  .set RTC_IRQHandler, Haltproc
  .set FLASH_IRQHandler, Haltproc
  .set RCC_IRQHandler, Haltproc
  .set EXTI0_IRQHandler, Haltproc
  .set EXTI1_IRQHandler, Haltproc
  .set EXTI2_IRQHandler, Haltproc
  .set EXTI3_IRQHandler, Haltproc
  .set EXTI4_IRQHandler, Haltproc
  .set DMA1_Channel1_IRQHandler, Haltproc
  .set DMA1_Channel2_IRQHandler, Haltproc
  .set DMA1_Channel3_IRQHandler, Haltproc
  .set DMA1_Channel4_IRQHandler, Haltproc
  .set DMA1_Channel5_IRQHandler, Haltproc
  .set DMA1_Channel6_IRQHandler, Haltproc
  .set DMA1_Channel7_IRQHandler, Haltproc
  .set ADC1_2_IRQHandler, Haltproc
  .set CAN1_TX_IRQHandler, Haltproc
  .set CAN1_RX0_IRQHandler, Haltproc
  .set CAN1_RX1_IRQHandler, Haltproc
  .set CAN1_SCE_IRQHandler, Haltproc
  .set EXTI9_5_IRQHandler, Haltproc
  .set TIM1_BRK_IRQHandler, Haltproc
  .set TIM1_UP_IRQHandler, Haltproc
  .set TIM1_TRG_COM_IRQHandler, Haltproc
  .set TIM1_CC_IRQHandler, Haltproc
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
  .set OTG_FS_WKUP_IRQHandler, Haltproc
  .set TIM5_IRQHandler, Haltproc
  .set SPI3_IRQHandler, Haltproc
  .set UART4_IRQHandler, Haltproc
  .set UART5_IRQHandler, Haltproc
  .set TIM6_IRQHandler, Haltproc
  .set TIM7_IRQHandler, Haltproc
  .set DMA2_Channel1_IRQHandler, Haltproc
  .set DMA2_Channel2_IRQHandler, Haltproc
  .set DMA2_Channel3_IRQHandler, Haltproc
  .set DMA2_Channel4_IRQHandler, Haltproc
  .set DMA2_Channel5_IRQHandler, Haltproc
  .set ETH_IRQHandler, Haltproc
  .set ETH_WKUP_IRQHandler, Haltproc
  .set CAN2_TX_IRQHandler, Haltproc
  .set CAN2_RX0_IRQHandler, Haltproc
  .set CAN2_RX1_IRQHandler, Haltproc
  .set CAN2_SCE_IRQHandler, Haltproc
  .set OTG_FS_IRQHandler, Haltproc

  .text
  end;
end.
