unit stm32f479xx;
interface
{$PACKRECORDS C}
{$GOTO ON}
{$SCOPEDENUMS ON}

type
  TIRQn_Enum = (
    NonMaskableInt_IRQn = -14,        
    MemoryManagement_IRQn = -12,      
    BusFault_IRQn = -11,              
    UsageFault_IRQn = -10,            
    SVCall_IRQn = -5,                 
    DebugMonitor_IRQn = -4,           
    PendSV_IRQn = -2,                 
    SysTick_IRQn = -1,                
    WWDG_IRQn   = 0,                  
    PVD_IRQn    = 1,                  
    TAMP_STAMP_IRQn = 2,              
    RTC_WKUP_IRQn = 3,                
    FLASH_IRQn  = 4,                  
    RCC_IRQn    = 5,                  
    EXTI0_IRQn  = 6,                  
    EXTI1_IRQn  = 7,                  
    EXTI2_IRQn  = 8,                  
    EXTI3_IRQn  = 9,                  
    EXTI4_IRQn  = 10,                 
    DMA1_Stream0_IRQn = 11,           
    DMA1_Stream1_IRQn = 12,           
    DMA1_Stream2_IRQn = 13,           
    DMA1_Stream3_IRQn = 14,           
    DMA1_Stream4_IRQn = 15,           
    DMA1_Stream5_IRQn = 16,           
    DMA1_Stream6_IRQn = 17,           
    ADC_IRQn    = 18,                 
    CAN1_TX_IRQn = 19,                
    CAN1_RX0_IRQn = 20,               
    CAN1_RX1_IRQn = 21,               
    CAN1_SCE_IRQn = 22,               
    EXTI9_5_IRQn = 23,                
    TIM1_BRK_TIM9_IRQn = 24,          
    TIM1_UP_TIM10_IRQn = 25,          
    TIM1_TRG_COM_TIM11_IRQn = 26,     
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
    TIM8_BRK_TIM12_IRQn = 43,         
    TIM8_UP_TIM13_IRQn = 44,          
    TIM8_TRG_COM_TIM14_IRQn = 45,     
    TIM8_CC_IRQn = 46,                
    DMA1_Stream7_IRQn = 47,           
    FMC_IRQn    = 48,                 
    SDIO_IRQn   = 49,                 
    TIM5_IRQn   = 50,                 
    SPI3_IRQn   = 51,                 
    UART4_IRQn  = 52,                 
    UART5_IRQn  = 53,                 
    TIM6_DAC_IRQn = 54,               
    TIM7_IRQn   = 55,                 
    DMA2_Stream0_IRQn = 56,           
    DMA2_Stream1_IRQn = 57,           
    DMA2_Stream2_IRQn = 58,           
    DMA2_Stream3_IRQn = 59,           
    DMA2_Stream4_IRQn = 60,           
    ETH_IRQn    = 61,                 
    ETH_WKUP_IRQn = 62,               
    CAN2_TX_IRQn = 63,                
    CAN2_RX0_IRQn = 64,               
    CAN2_RX1_IRQn = 65,               
    CAN2_SCE_IRQn = 66,               
    OTG_FS_IRQn = 67,                 
    DMA2_Stream5_IRQn = 68,           
    DMA2_Stream6_IRQn = 69,           
    DMA2_Stream7_IRQn = 70,           
    USART6_IRQn = 71,                 
    I2C3_EV_IRQn = 72,                
    I2C3_ER_IRQn = 73,                
    OTG_HS_EP1_OUT_IRQn = 74,         
    OTG_HS_EP1_IN_IRQn = 75,          
    OTG_HS_WKUP_IRQn = 76,            
    OTG_HS_IRQn = 77,                 
    DCMI_IRQn   = 78,                 
    CRYP_IRQn   = 79,                 
    HASH_RNG_IRQn = 80,               
    FPU_IRQn    = 81,                 
    UART7_IRQn  = 82,                 
    UART8_IRQn  = 83,                 
    SPI4_IRQn   = 84,                 
    SPI5_IRQn   = 85,                 
    SPI6_IRQn   = 86,                 
    SAI1_IRQn   = 87,                 
    LTDC_IRQn   = 88,                 
    LTDC_ER_IRQn = 89,                
    DMA2D_IRQn  = 90,                 
    QUADSPI_IRQn = 91,                
    DSI_IRQn    = 92                  
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
    CSR         : longword;
    CCR         : longword;
    CDR         : longword;
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
    SR          : longword;
  end;

  TDBGMCU_Registers = record
    IDCODE      : longword;
    CR          : longword;
    APB1FZ      : longword;
    APB2FZ      : longword;
  end;

  TDCMI_Registers = record
    CR          : longword;
    SR          : longword;
    RISR        : longword;
    IER         : longword;
    MISR        : longword;
    ICR         : longword;
    ESCR        : longword;
    ESUR        : longword;
    CWSTRTR     : longword;
    CWSIZER     : longword;
    DR          : longword;
  end;

  TDMA_Stream_Registers = record
    CR          : longword;
    NDTR        : longword;
    PAR         : longword;
    M0AR        : longword;
    M1AR        : longword;
    FCR         : longword;
  end;

  TDMA_Registers = record
    LISR        : longword;
    HISR        : longword;
    LIFCR       : longword;
    HIFCR       : longword;
  end;

  TDMA2D_Registers = record
    CR          : longword;
    ISR         : longword;
    IFCR        : longword;
    FGMAR       : longword;
    FGOR        : longword;
    BGMAR       : longword;
    BGOR        : longword;
    FGPFCCR     : longword;
    FGCOLR      : longword;
    BGPFCCR     : longword;
    BGCOLR      : longword;
    FGCMAR      : longword;
    BGCMAR      : longword;
    OPFCCR      : longword;
    OCOLR       : longword;
    OMAR        : longword;
    OOR         : longword;
    NLR         : longword;
    LWR         : longword;
    AMTCR       : longword;
    RESERVED    : array[0..235] of longword;
    FGCLUT      : array[0..255] of longword;
    BGCLUT      : array[0..255] of longword;
  end;

  TDSI_Registers = record
    VR          : longword;
    CR          : longword;
    CCR         : longword;
    LVCIDR      : longword;
    LCOLCR      : longword;
    LPCR        : longword;
    LPMCR       : longword;
    RESERVED0   : array[0..3] of longword;
    PCR         : longword;
    GVCIDR      : longword;
    MCR         : longword;
    VMCR        : longword;
    VPCR        : longword;
    VCCR        : longword;
    VNPCR       : longword;
    VHSACR      : longword;
    VHBPCR      : longword;
    VLCR        : longword;
    VVSACR      : longword;
    VVBPCR      : longword;
    VVFPCR      : longword;
    VVACR       : longword;
    LCCR        : longword;
    CMCR        : longword;
    GHCR        : longword;
    GPDR        : longword;
    GPSR        : longword;
    TCCR        : array[0..5] of longword;
    TDCR        : longword;
    CLCR        : longword;
    CLTCR       : longword;
    DLTCR       : longword;
    PCTLR       : longword;
    PCONFR      : longword;
    PUCR        : longword;
    PTTCR       : longword;
    PSR         : longword;
    RESERVED1   : array[0..1] of longword;
    ISR         : array[0..1] of longword;
    IER         : array[0..1] of longword;
    RESERVED2   : array[0..2] of longword;
    FIR         : array[0..1] of longword;
    RESERVED3   : array[0..7] of longword;
    VSCR        : longword;
    RESERVED4   : array[0..1] of longword;
    LCVCIDR     : longword;
    LCCCR       : longword;
    RESERVED5   : longword;
    LPMCCR      : longword;
    RESERVED6   : array[0..6] of longword;
    VMCCR       : longword;
    VPCCR       : longword;
    VCCCR       : longword;
    VNPCCR      : longword;
    VHSACCR     : longword;
    VHBPCCR     : longword;
    VLCCR       : longword;
    VVSACCR     : longword;
    VVBPCCR     : longword;
    VVFPCCR     : longword;
    VVACCR      : longword;
    RESERVED7   : array[0..10] of longword;
    TDCCR       : longword;
    RESERVED8   : array[0..154] of longword;
    WCFGR       : longword;
    WCR         : longword;
    WIER        : longword;
    WISR        : longword;
    WIFCR       : longword;
    RESERVED9   : longword;
    WPCR        : array[0..4] of longword;
    RESERVED10  : longword;
    WRPCR       : longword;
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
    RESERVED1   : longword;
    MACDBGR     : longword;
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
    RESERVED8   : longword;
    PTPTSSR     : longword;
    RESERVED9   : array[0..564] of longword;
    DMABMR      : longword;
    DMATPDR     : longword;
    DMARPDR     : longword;
    DMARDLAR    : longword;
    DMATDLAR    : longword;
    DMASR       : longword;
    DMAOMR      : longword;
    DMAIER      : longword;
    DMAMFBOCR   : longword;
    DMARSWTR    : longword;
    RESERVED10  : array[0..7] of longword;
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
    OPTCR       : longword;
    OPTCR1      : longword;
  end;

  TFMC_Bank1_Registers = record
    BTCR        : array[0..7] of longword;
  end;

  TFMC_Bank1E_Registers = record
    BWTR        : array[0..6] of longword;
  end;

  TFMC_Bank3_Registers = record
    PCR         : longword;
    SR          : longword;
    PMEM        : longword;
    PATT        : longword;
    RESERVED    : longword;
    ECCR        : longword;
  end;

  TFMC_Bank5_6_Registers = record
    SDCR        : array[0..1] of longword;
    SDTR        : array[0..1] of longword;
    SDCMR       : longword;
    SDRTR       : longword;
    SDSR        : longword;
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
  end;

  TSYSCFG_Registers = record
    MEMRMP      : longword;
    PMC         : longword;
    EXTICR      : array[0..3] of longword;
    RESERVED    : array[0..1] of longword;
    CMPCR       : longword;
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
    FLTR        : longword;
  end;

  TIWDG_Registers = record
    KR          : longword;
    PR          : longword;
    RLR         : longword;
    SR          : longword;
  end;

  TLTDC_Registers = record
    RESERVED0   : array[0..1] of longword;
    SSCR        : longword;
    BPCR        : longword;
    AWCR        : longword;
    TWCR        : longword;
    GCR         : longword;
    RESERVED1   : array[0..1] of longword;
    SRCR        : longword;
    RESERVED2   : longword;
    BCCR        : longword;
    RESERVED3   : longword;
    IER         : longword;
    ISR         : longword;
    ICR         : longword;
    LIPCR       : longword;
    CPSR        : longword;
    CDSR        : longword;
  end;

  TLTDC_Layer_Registers = record
    CR          : longword;
    WHPCR       : longword;
    WVPCR       : longword;
    CKCR        : longword;
    PFCR        : longword;
    CACR        : longword;
    DCCR        : longword;
    BFCR        : longword;
    RESERVED0   : array[0..1] of longword;
    CFBAR       : longword;
    CFBLR       : longword;
    CFBLNR      : longword;
    RESERVED1   : array[0..2] of longword;
    CLUTWR      : longword;
  end;

  TPWR_Registers = record
    CR          : longword;
    CSR         : longword;
  end;

  TRCC_Registers = record
    CR          : longword;
    PLLCFGR     : longword;
    CFGR        : longword;
    CIR         : longword;
    AHB1RSTR    : longword;
    AHB2RSTR    : longword;
    AHB3RSTR    : longword;
    RESERVED0   : longword;
    APB1RSTR    : longword;
    APB2RSTR    : longword;
    RESERVED1   : array[0..1] of longword;
    AHB1ENR     : longword;
    AHB2ENR     : longword;
    AHB3ENR     : longword;
    RESERVED2   : longword;
    APB1ENR     : longword;
    APB2ENR     : longword;
    RESERVED3   : array[0..1] of longword;
    AHB1LPENR   : longword;
    AHB2LPENR   : longword;
    AHB3LPENR   : longword;
    RESERVED4   : longword;
    APB1LPENR   : longword;
    APB2LPENR   : longword;
    RESERVED5   : array[0..1] of longword;
    BDCR        : longword;
    CSR         : longword;
    RESERVED6   : array[0..1] of longword;
    SSCGR       : longword;
    PLLI2SCFGR  : longword;
    PLLSAICFGR  : longword;
    DCKCFGR     : longword;
  end;

  TRTC_Registers = record
    TR          : longword;
    DR          : longword;
    CR          : longword;
    ISR         : longword;
    PRER        : longword;
    WUTR        : longword;
    CALIBR      : longword;
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
  end;

  TSAI_Registers = record
    GCR         : longword;
  end;

  TSAI_Block_Registers = record
    CR1         : longword;
    CR2         : longword;
    FRCR        : longword;
    SLOTR       : longword;
    IMR         : longword;
    SR          : longword;
    CLRFR       : longword;
    DR          : longword;
  end;

  TSDIO_Registers = record
    POWER       : longword;
    CLKCR       : longword;
    ARG         : longword;
    CMD         : longword;
    RESPCMD     : longword;
    RESP1       : longword;
    RESP2       : longword;
    RESP3       : longword;
    RESP4       : longword;
    DTIMER      : longword;
    DLEN        : longword;
    DCTRL       : longword;
    DCOUNT      : longword;
    STA         : longword;
    ICR         : longword;
    MASK        : longword;
    RESERVED0   : array[0..1] of longword;
    FIFOCNT     : longword;
    RESERVED1   : array[0..12] of longword;
    FIFO        : longword;
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

  TQUADSPI_Registers = record
    CR          : longword;
    DCR         : longword;
    SR          : longword;
    FCR         : longword;
    DLR         : longword;
    CCR         : longword;
    AR          : longword;
    ABR         : longword;
    DR          : longword;
    PSMKR       : longword;
    PSMAR       : longword;
    PIR         : longword;
    LPTR        : longword;
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

  TWWDG_Registers = record
    CR          : longword;
    CFR         : longword;
    SR          : longword;
  end;

  TCRYP_Registers = record
    CR          : longword;
    SR          : longword;
    DIN         : longword;
    DOUT        : longword;
    DMACR       : longword;
    IMSCR       : longword;
    RISR        : longword;
    MISR        : longword;
    K0LR        : longword;
    K0RR        : longword;
    K1LR        : longword;
    K1RR        : longword;
    K2LR        : longword;
    K2RR        : longword;
    K3LR        : longword;
    K3RR        : longword;
    IV0LR       : longword;
    IV0RR       : longword;
    IV1LR       : longword;
    IV1RR       : longword;
    CSGCMCCM0R  : longword;
    CSGCMCCM1R  : longword;
    CSGCMCCM2R  : longword;
    CSGCMCCM3R  : longword;
    CSGCMCCM4R  : longword;
    CSGCMCCM5R  : longword;
    CSGCMCCM6R  : longword;
    CSGCMCCM7R  : longword;
    CSGCM0R     : longword;
    CSGCM1R     : longword;
    CSGCM2R     : longword;
    CSGCM3R     : longword;
    CSGCM4R     : longword;
    CSGCM5R     : longword;
    CSGCM6R     : longword;
    CSGCM7R     : longword;
  end;

  THASH_Registers = record
    CR          : longword;
    DIN         : longword;
    STR         : longword;
    HR          : array[0..4] of longword;
    IMR         : longword;
    SR          : longword;
    RESERVED    : array[0..51] of longword;
    CSR         : array[0..53] of longword;
  end;

  THASH_DIGEST_Registers = record
    HR          : array[0..7] of longword;
  end;

  TRNG_Registers = record
    CR          : longword;
    SR          : longword;
    DR          : longword;
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
    Reserved5   : array[0..2] of longword;
    GHWCFG3     : longword;
    Reserved6   : longword;
    GLPMCFG     : longword;
    Reserved    : longword;
    GDFIFOCFG   : longword;
    Reserved43  : array[0..39] of longword;
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

const
  __NVIC_PRIO_BITS= 4;
  FLASH_BASE    = $08000000;
  CCMDATARAM_BASE= $10000000;
  SRAM1_BASE    = $20000000;
  SRAM2_BASE    = $20028000;
  SRAM3_BASE    = $20030000;
  PERIPH_BASE   = $40000000;
  BKPSRAM_BASE  = $40024000;
  FMC_R_BASE    = $A0000000;
  QSPI_R_BASE   = $A0001000;
  SRAM1_BB_BASE = $22000000;
  SRAM2_BB_BASE = $22500000;
  SRAM3_BB_BASE = $22600000;
  PERIPH_BB_BASE= $42000000;
  BKPSRAM_BB_BASE= $42480000;
  FLASH_OTP_BASE= $1FFF7800;
  SRAM_BASE     = SRAM1_BASE;
  SRAM_BB_BASE  = SRAM1_BB_BASE;
  APB1PERIPH_BASE= PERIPH_BASE;
  APB2PERIPH_BASE= PERIPH_BASE + $00010000;
  AHB1PERIPH_BASE= PERIPH_BASE + $00020000;
  AHB2PERIPH_BASE= PERIPH_BASE + $10000000;
  TIM2_BASE     = APB1PERIPH_BASE + $0000;
  TIM3_BASE     = APB1PERIPH_BASE + $0400;
  TIM4_BASE     = APB1PERIPH_BASE + $0800;
  TIM5_BASE     = APB1PERIPH_BASE + $0C00;
  TIM6_BASE     = APB1PERIPH_BASE + $1000;
  TIM7_BASE     = APB1PERIPH_BASE + $1400;
  TIM12_BASE    = APB1PERIPH_BASE + $1800;
  TIM13_BASE    = APB1PERIPH_BASE + $1C00;
  TIM14_BASE    = APB1PERIPH_BASE + $2000;
  RTC_BASE      = APB1PERIPH_BASE + $2800;
  WWDG_BASE     = APB1PERIPH_BASE + $2C00;
  IWDG_BASE     = APB1PERIPH_BASE + $3000;
  I2S2ext_BASE  = APB1PERIPH_BASE + $3400;
  SPI2_BASE     = APB1PERIPH_BASE + $3800;
  SPI3_BASE     = APB1PERIPH_BASE + $3C00;
  I2S3ext_BASE  = APB1PERIPH_BASE + $4000;
  USART2_BASE   = APB1PERIPH_BASE + $4400;
  USART3_BASE   = APB1PERIPH_BASE + $4800;
  UART4_BASE    = APB1PERIPH_BASE + $4C00;
  UART5_BASE    = APB1PERIPH_BASE + $5000;
  I2C1_BASE     = APB1PERIPH_BASE + $5400;
  I2C2_BASE     = APB1PERIPH_BASE + $5800;
  I2C3_BASE     = APB1PERIPH_BASE + $5C00;
  CAN1_BASE     = APB1PERIPH_BASE + $6400;
  CAN2_BASE     = APB1PERIPH_BASE + $6800;
  PWR_BASE      = APB1PERIPH_BASE + $7000;
  DAC_BASE      = APB1PERIPH_BASE + $7400;
  UART7_BASE    = APB1PERIPH_BASE + $7800;
  UART8_BASE    = APB1PERIPH_BASE + $7C00;
  TIM1_BASE     = APB2PERIPH_BASE + $0000;
  TIM8_BASE     = APB2PERIPH_BASE + $0400;
  USART1_BASE   = APB2PERIPH_BASE + $1000;
  USART6_BASE   = APB2PERIPH_BASE + $1400;
  ADC1_BASE     = APB2PERIPH_BASE + $2000;
  ADC2_BASE     = APB2PERIPH_BASE + $2100;
  ADC3_BASE     = APB2PERIPH_BASE + $2200;
  ADC123_COMMON_BASE= APB2PERIPH_BASE + $2300;
  ADC_BASE      = ADC123_COMMON_BASE;
  SDIO_BASE     = APB2PERIPH_BASE + $2C00;
  SPI1_BASE     = APB2PERIPH_BASE + $3000;
  SPI4_BASE     = APB2PERIPH_BASE + $3400;
  SYSCFG_BASE   = APB2PERIPH_BASE + $3800;
  EXTI_BASE     = APB2PERIPH_BASE + $3C00;
  TIM9_BASE     = APB2PERIPH_BASE + $4000;
  TIM10_BASE    = APB2PERIPH_BASE + $4400;
  TIM11_BASE    = APB2PERIPH_BASE + $4800;
  SPI5_BASE     = APB2PERIPH_BASE + $5000;
  SPI6_BASE     = APB2PERIPH_BASE + $5400;
  SAI1_BASE     = APB2PERIPH_BASE + $5800;
  SAI1_Block_A_BASE= SAI1_BASE + $004;
  SAI1_Block_B_BASE= SAI1_BASE + $024;
  LTDC_BASE     = APB2PERIPH_BASE + $6800;
  LTDC_Layer1_BASE= LTDC_BASE + $84;
  LTDC_Layer2_BASE= LTDC_BASE + $104;
  DSI_BASE      = APB2PERIPH_BASE + $6C00;
  GPIOA_BASE    = AHB1PERIPH_BASE + $0000;
  GPIOB_BASE    = AHB1PERIPH_BASE + $0400;
  GPIOC_BASE    = AHB1PERIPH_BASE + $0800;
  GPIOD_BASE    = AHB1PERIPH_BASE + $0C00;
  GPIOE_BASE    = AHB1PERIPH_BASE + $1000;
  GPIOF_BASE    = AHB1PERIPH_BASE + $1400;
  GPIOG_BASE    = AHB1PERIPH_BASE + $1800;
  GPIOH_BASE    = AHB1PERIPH_BASE + $1C00;
  GPIOI_BASE    = AHB1PERIPH_BASE + $2000;
  GPIOJ_BASE    = AHB1PERIPH_BASE + $2400;
  GPIOK_BASE    = AHB1PERIPH_BASE + $2800;
  CRC_BASE      = AHB1PERIPH_BASE + $3000;
  RCC_BASE      = AHB1PERIPH_BASE + $3800;
  FLASH_R_BASE  = AHB1PERIPH_BASE + $3C00;
  DMA1_BASE     = AHB1PERIPH_BASE + $6000;
  DMA1_Stream0_BASE= DMA1_BASE + $010;
  DMA1_Stream1_BASE= DMA1_BASE + $028;
  DMA1_Stream2_BASE= DMA1_BASE + $040;
  DMA1_Stream3_BASE= DMA1_BASE + $058;
  DMA1_Stream4_BASE= DMA1_BASE + $070;
  DMA1_Stream5_BASE= DMA1_BASE + $088;
  DMA1_Stream6_BASE= DMA1_BASE + $0A0;
  DMA1_Stream7_BASE= DMA1_BASE + $0B8;
  DMA2_BASE     = AHB1PERIPH_BASE + $6400;
  DMA2_Stream0_BASE= DMA2_BASE + $010;
  DMA2_Stream1_BASE= DMA2_BASE + $028;
  DMA2_Stream2_BASE= DMA2_BASE + $040;
  DMA2_Stream3_BASE= DMA2_BASE + $058;
  DMA2_Stream4_BASE= DMA2_BASE + $070;
  DMA2_Stream5_BASE= DMA2_BASE + $088;
  DMA2_Stream6_BASE= DMA2_BASE + $0A0;
  DMA2_Stream7_BASE= DMA2_BASE + $0B8;
  ETH_BASE      = AHB1PERIPH_BASE + $8000;
  ETH_MAC_BASE  = ETH_BASE;
  ETH_MMC_BASE  = ETH_BASE + $0100;
  ETH_PTP_BASE  = ETH_BASE + $0700;
  ETH_DMA_BASE  = ETH_BASE + $1000;
  DMA2D_BASE    = AHB1PERIPH_BASE + $B000;
  DCMI_BASE     = AHB2PERIPH_BASE + $50000;
  CRYP_BASE     = AHB2PERIPH_BASE + $60000;
  HASH_BASE     = AHB2PERIPH_BASE + $60400;
  HASH_DIGEST_BASE= AHB2PERIPH_BASE + $60710;
  RNG_BASE      = AHB2PERIPH_BASE + $60800;
  FMC_Bank1_R_BASE= FMC_R_BASE + $0000;
  FMC_Bank1E_R_BASE= FMC_R_BASE + $0104;
  FMC_Bank3_R_BASE= FMC_R_BASE + $0080;
  FMC_Bank5_6_R_BASE= FMC_R_BASE + $0140;
  DBGMCU_BASE   = $E0042000;
  USB_OTG_HS_PERIPH_BASE= $40040000;
  USB_OTG_FS_PERIPH_BASE= $50000000;
  USB_OTG_GLOBAL_BASE= $000;
  USB_OTG_DEVICE_BASE= $800;
  USB_OTG_IN_ENDPOINT_BASE= $900;
  USB_OTG_OUT_ENDPOINT_BASE= $B00;
  USB_OTG_HOST_BASE= $400;
  USB_OTG_HOST_PORT_BASE= $440;
  USB_OTG_HOST_CHANNEL_BASE= $500;
  USB_OTG_PCGCCTL_BASE= $E00;
  USB_OTG_FIFO_BASE= $1000;
  UID_BASE      = $1FFF7A10;
  FLASHSIZE_BASE= $1FFF7A22;
  PACKAGE_BASE  = $1FFF7BF0;

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
  I2S2ext       : TSPI_Registers absolute I2S2ext_BASE;
  SPI2          : TSPI_Registers absolute SPI2_BASE;
  SPI3          : TSPI_Registers absolute SPI3_BASE;
  I2S3ext       : TSPI_Registers absolute I2S3ext_BASE;
  USART2        : TUSART_Registers absolute USART2_BASE;
  USART3        : TUSART_Registers absolute USART3_BASE;
  UART4         : TUSART_Registers absolute UART4_BASE;
  UART5         : TUSART_Registers absolute UART5_BASE;
  I2C1          : TI2C_Registers absolute I2C1_BASE;
  I2C2          : TI2C_Registers absolute I2C2_BASE;
  I2C3          : TI2C_Registers absolute I2C3_BASE;
  CAN1          : TCAN_Registers absolute CAN1_BASE;
  CAN2          : TCAN_Registers absolute CAN2_BASE;
  PWR           : TPWR_Registers absolute PWR_BASE;
  DAC1          : TDAC_Registers absolute DAC_BASE;
  DAC           : TDAC_Registers absolute DAC_BASE;
  UART7         : TUSART_Registers absolute UART7_BASE;
  UART8         : TUSART_Registers absolute UART8_BASE;
  TIM1          : TTIM_Registers absolute TIM1_BASE;
  TIM8          : TTIM_Registers absolute TIM8_BASE;
  USART1        : TUSART_Registers absolute USART1_BASE;
  USART6        : TUSART_Registers absolute USART6_BASE;
  ADC1          : TADC_Registers absolute ADC1_BASE;
  ADC2          : TADC_Registers absolute ADC2_BASE;
  ADC3          : TADC_Registers absolute ADC3_BASE;
  ADC123_COMMON : TADC_Common_Registers absolute ADC123_COMMON_BASE;
  SDIO          : TSDIO_Registers absolute SDIO_BASE;
  SPI1          : TSPI_Registers absolute SPI1_BASE;
  SPI4          : TSPI_Registers absolute SPI4_BASE;
  SYSCFG        : TSYSCFG_Registers absolute SYSCFG_BASE;
  EXTI          : TEXTI_Registers absolute EXTI_BASE;
  TIM9          : TTIM_Registers absolute TIM9_BASE;
  TIM10         : TTIM_Registers absolute TIM10_BASE;
  TIM11         : TTIM_Registers absolute TIM11_BASE;
  SPI5          : TSPI_Registers absolute SPI5_BASE;
  SPI6          : TSPI_Registers absolute SPI6_BASE;
  SAI1          : TSAI_Registers absolute SAI1_BASE;
  SAI1_Block_A  : TSAI_Block_Registers absolute SAI1_Block_A_BASE;
  SAI1_Block_B  : TSAI_Block_Registers absolute SAI1_Block_B_BASE;
  LTDC          : TLTDC_Registers absolute LTDC_BASE;
  LTDC_Layer1   : TLTDC_Layer_Registers absolute LTDC_Layer1_BASE;
  LTDC_Layer2   : TLTDC_Layer_Registers absolute LTDC_Layer2_BASE;
  DSI           : TDSI_Registers absolute DSI_BASE;
  GPIOA         : TGPIO_Registers absolute GPIOA_BASE;
  GPIOB         : TGPIO_Registers absolute GPIOB_BASE;
  GPIOC         : TGPIO_Registers absolute GPIOC_BASE;
  GPIOD         : TGPIO_Registers absolute GPIOD_BASE;
  GPIOE         : TGPIO_Registers absolute GPIOE_BASE;
  GPIOF         : TGPIO_Registers absolute GPIOF_BASE;
  GPIOG         : TGPIO_Registers absolute GPIOG_BASE;
  GPIOH         : TGPIO_Registers absolute GPIOH_BASE;
  GPIOI         : TGPIO_Registers absolute GPIOI_BASE;
  GPIOJ         : TGPIO_Registers absolute GPIOJ_BASE;
  GPIOK         : TGPIO_Registers absolute GPIOK_BASE;
  CRC           : TCRC_Registers absolute CRC_BASE;
  RCC           : TRCC_Registers absolute RCC_BASE;
  FLASH         : TFLASH_Registers absolute FLASH_R_BASE;
  DMA1          : TDMA_Registers absolute DMA1_BASE;
  DMA1_Stream0  : TDMA_Stream_Registers absolute DMA1_Stream0_BASE;
  DMA1_Stream1  : TDMA_Stream_Registers absolute DMA1_Stream1_BASE;
  DMA1_Stream2  : TDMA_Stream_Registers absolute DMA1_Stream2_BASE;
  DMA1_Stream3  : TDMA_Stream_Registers absolute DMA1_Stream3_BASE;
  DMA1_Stream4  : TDMA_Stream_Registers absolute DMA1_Stream4_BASE;
  DMA1_Stream5  : TDMA_Stream_Registers absolute DMA1_Stream5_BASE;
  DMA1_Stream6  : TDMA_Stream_Registers absolute DMA1_Stream6_BASE;
  DMA1_Stream7  : TDMA_Stream_Registers absolute DMA1_Stream7_BASE;
  DMA2          : TDMA_Registers absolute DMA2_BASE;
  DMA2_Stream0  : TDMA_Stream_Registers absolute DMA2_Stream0_BASE;
  DMA2_Stream1  : TDMA_Stream_Registers absolute DMA2_Stream1_BASE;
  DMA2_Stream2  : TDMA_Stream_Registers absolute DMA2_Stream2_BASE;
  DMA2_Stream3  : TDMA_Stream_Registers absolute DMA2_Stream3_BASE;
  DMA2_Stream4  : TDMA_Stream_Registers absolute DMA2_Stream4_BASE;
  DMA2_Stream5  : TDMA_Stream_Registers absolute DMA2_Stream5_BASE;
  DMA2_Stream6  : TDMA_Stream_Registers absolute DMA2_Stream6_BASE;
  DMA2_Stream7  : TDMA_Stream_Registers absolute DMA2_Stream7_BASE;
  ETH           : TETH_Registers absolute ETH_BASE;
  DMA2D         : TDMA2D_Registers absolute DMA2D_BASE;
  DCMI          : TDCMI_Registers absolute DCMI_BASE;
  CRYP          : TCRYP_Registers absolute CRYP_BASE;
  HASH          : THASH_Registers absolute HASH_BASE;
  HASH_DIGEST   : THASH_DIGEST_Registers absolute HASH_DIGEST_BASE;
  RNG           : TRNG_Registers absolute RNG_BASE;
  FMC_Bank1     : TFMC_Bank1_Registers absolute FMC_Bank1_R_BASE;
  FMC_Bank1E    : TFMC_Bank1E_Registers absolute FMC_Bank1E_R_BASE;
  FMC_Bank3     : TFMC_Bank3_Registers absolute FMC_Bank3_R_BASE;
  FMC_Bank5_6   : TFMC_Bank5_6_Registers absolute FMC_Bank5_6_R_BASE;
  QUADSPI       : TQUADSPI_Registers absolute QSPI_R_BASE;
  DBGMCU        : TDBGMCU_Registers absolute DBGMCU_BASE;

implementation

procedure NonMaskableInt_Handler; external name 'NonMaskableInt_Handler';
procedure MemoryManagement_Handler; external name 'MemoryManagement_Handler';
procedure BusFault_Handler; external name 'BusFault_Handler';
procedure UsageFault_Handler; external name 'UsageFault_Handler';
procedure SVCall_Handler; external name 'SVCall_Handler';
procedure DebugMonitor_Handler; external name 'DebugMonitor_Handler';
procedure PendSV_Handler; external name 'PendSV_Handler';
procedure SysTick_Handler; external name 'SysTick_Handler';
procedure WWDG_IRQHandler; external name 'WWDG_IRQHandler';
procedure PVD_IRQHandler; external name 'PVD_IRQHandler';
procedure TAMP_STAMP_IRQHandler; external name 'TAMP_STAMP_IRQHandler';
procedure RTC_WKUP_IRQHandler; external name 'RTC_WKUP_IRQHandler';
procedure FLASH_IRQHandler; external name 'FLASH_IRQHandler';
procedure RCC_IRQHandler; external name 'RCC_IRQHandler';
procedure EXTI0_IRQHandler; external name 'EXTI0_IRQHandler';
procedure EXTI1_IRQHandler; external name 'EXTI1_IRQHandler';
procedure EXTI2_IRQHandler; external name 'EXTI2_IRQHandler';
procedure EXTI3_IRQHandler; external name 'EXTI3_IRQHandler';
procedure EXTI4_IRQHandler; external name 'EXTI4_IRQHandler';
procedure DMA1_Stream0_IRQHandler; external name 'DMA1_Stream0_IRQHandler';
procedure DMA1_Stream1_IRQHandler; external name 'DMA1_Stream1_IRQHandler';
procedure DMA1_Stream2_IRQHandler; external name 'DMA1_Stream2_IRQHandler';
procedure DMA1_Stream3_IRQHandler; external name 'DMA1_Stream3_IRQHandler';
procedure DMA1_Stream4_IRQHandler; external name 'DMA1_Stream4_IRQHandler';
procedure DMA1_Stream5_IRQHandler; external name 'DMA1_Stream5_IRQHandler';
procedure DMA1_Stream6_IRQHandler; external name 'DMA1_Stream6_IRQHandler';
procedure ADC_IRQHandler; external name 'ADC_IRQHandler';
procedure CAN1_TX_IRQHandler; external name 'CAN1_TX_IRQHandler';
procedure CAN1_RX0_IRQHandler; external name 'CAN1_RX0_IRQHandler';
procedure CAN1_RX1_IRQHandler; external name 'CAN1_RX1_IRQHandler';
procedure CAN1_SCE_IRQHandler; external name 'CAN1_SCE_IRQHandler';
procedure EXTI9_5_IRQHandler; external name 'EXTI9_5_IRQHandler';
procedure TIM1_BRK_TIM9_IRQHandler; external name 'TIM1_BRK_TIM9_IRQHandler';
procedure TIM1_UP_TIM10_IRQHandler; external name 'TIM1_UP_TIM10_IRQHandler';
procedure TIM1_TRG_COM_TIM11_IRQHandler; external name 'TIM1_TRG_COM_TIM11_IRQHandler';
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
procedure TIM8_BRK_TIM12_IRQHandler; external name 'TIM8_BRK_TIM12_IRQHandler';
procedure TIM8_UP_TIM13_IRQHandler; external name 'TIM8_UP_TIM13_IRQHandler';
procedure TIM8_TRG_COM_TIM14_IRQHandler; external name 'TIM8_TRG_COM_TIM14_IRQHandler';
procedure TIM8_CC_IRQHandler; external name 'TIM8_CC_IRQHandler';
procedure DMA1_Stream7_IRQHandler; external name 'DMA1_Stream7_IRQHandler';
procedure FMC_IRQHandler; external name 'FMC_IRQHandler';
procedure SDIO_IRQHandler; external name 'SDIO_IRQHandler';
procedure TIM5_IRQHandler; external name 'TIM5_IRQHandler';
procedure SPI3_IRQHandler; external name 'SPI3_IRQHandler';
procedure UART4_IRQHandler; external name 'UART4_IRQHandler';
procedure UART5_IRQHandler; external name 'UART5_IRQHandler';
procedure TIM6_DAC_IRQHandler; external name 'TIM6_DAC_IRQHandler';
procedure TIM7_IRQHandler; external name 'TIM7_IRQHandler';
procedure DMA2_Stream0_IRQHandler; external name 'DMA2_Stream0_IRQHandler';
procedure DMA2_Stream1_IRQHandler; external name 'DMA2_Stream1_IRQHandler';
procedure DMA2_Stream2_IRQHandler; external name 'DMA2_Stream2_IRQHandler';
procedure DMA2_Stream3_IRQHandler; external name 'DMA2_Stream3_IRQHandler';
procedure DMA2_Stream4_IRQHandler; external name 'DMA2_Stream4_IRQHandler';
procedure ETH_IRQHandler; external name 'ETH_IRQHandler';
procedure ETH_WKUP_IRQHandler; external name 'ETH_WKUP_IRQHandler';
procedure CAN2_TX_IRQHandler; external name 'CAN2_TX_IRQHandler';
procedure CAN2_RX0_IRQHandler; external name 'CAN2_RX0_IRQHandler';
procedure CAN2_RX1_IRQHandler; external name 'CAN2_RX1_IRQHandler';
procedure CAN2_SCE_IRQHandler; external name 'CAN2_SCE_IRQHandler';
procedure OTG_FS_IRQHandler; external name 'OTG_FS_IRQHandler';
procedure DMA2_Stream5_IRQHandler; external name 'DMA2_Stream5_IRQHandler';
procedure DMA2_Stream6_IRQHandler; external name 'DMA2_Stream6_IRQHandler';
procedure DMA2_Stream7_IRQHandler; external name 'DMA2_Stream7_IRQHandler';
procedure USART6_IRQHandler; external name 'USART6_IRQHandler';
procedure I2C3_EV_IRQHandler; external name 'I2C3_EV_IRQHandler';
procedure I2C3_ER_IRQHandler; external name 'I2C3_ER_IRQHandler';
procedure OTG_HS_EP1_OUT_IRQHandler; external name 'OTG_HS_EP1_OUT_IRQHandler';
procedure OTG_HS_EP1_IN_IRQHandler; external name 'OTG_HS_EP1_IN_IRQHandler';
procedure OTG_HS_WKUP_IRQHandler; external name 'OTG_HS_WKUP_IRQHandler';
procedure OTG_HS_IRQHandler; external name 'OTG_HS_IRQHandler';
procedure DCMI_IRQHandler; external name 'DCMI_IRQHandler';
procedure CRYP_IRQHandler; external name 'CRYP_IRQHandler';
procedure HASH_RNG_IRQHandler; external name 'HASH_RNG_IRQHandler';
procedure FPU_IRQHandler; external name 'FPU_IRQHandler';
procedure UART7_IRQHandler; external name 'UART7_IRQHandler';
procedure UART8_IRQHandler; external name 'UART8_IRQHandler';
procedure SPI4_IRQHandler; external name 'SPI4_IRQHandler';
procedure SPI5_IRQHandler; external name 'SPI5_IRQHandler';
procedure SPI6_IRQHandler; external name 'SPI6_IRQHandler';
procedure SAI1_IRQHandler; external name 'SAI1_IRQHandler';
procedure LTDC_IRQHandler; external name 'LTDC_IRQHandler';
procedure LTDC_ER_IRQHandler; external name 'LTDC_ER_IRQHandler';
procedure DMA2D_IRQHandler; external name 'DMA2D_IRQHandler';
procedure QUADSPI_IRQHandler; external name 'QUADSPI_IRQHandler';
procedure DSI_IRQHandler; external name 'DSI_IRQHandler';


{$i cortexm4f_start.inc}

procedure Vectors; assembler; nostackframe;
label interrupt_vectors;
asm
  .section ".init.interrupt_vectors"
  interrupt_vectors:
  .long _stack_top
  .long Startup
  .long NonMaskableInt_Handler
  .long 0
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
  .long TAMP_STAMP_IRQHandler
  .long RTC_WKUP_IRQHandler
  .long FLASH_IRQHandler
  .long RCC_IRQHandler
  .long EXTI0_IRQHandler
  .long EXTI1_IRQHandler
  .long EXTI2_IRQHandler
  .long EXTI3_IRQHandler
  .long EXTI4_IRQHandler
  .long DMA1_Stream0_IRQHandler
  .long DMA1_Stream1_IRQHandler
  .long DMA1_Stream2_IRQHandler
  .long DMA1_Stream3_IRQHandler
  .long DMA1_Stream4_IRQHandler
  .long DMA1_Stream5_IRQHandler
  .long DMA1_Stream6_IRQHandler
  .long ADC_IRQHandler
  .long CAN1_TX_IRQHandler
  .long CAN1_RX0_IRQHandler
  .long CAN1_RX1_IRQHandler
  .long CAN1_SCE_IRQHandler
  .long EXTI9_5_IRQHandler
  .long TIM1_BRK_TIM9_IRQHandler
  .long TIM1_UP_TIM10_IRQHandler
  .long TIM1_TRG_COM_TIM11_IRQHandler
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
  .long TIM8_BRK_TIM12_IRQHandler
  .long TIM8_UP_TIM13_IRQHandler
  .long TIM8_TRG_COM_TIM14_IRQHandler
  .long TIM8_CC_IRQHandler
  .long DMA1_Stream7_IRQHandler
  .long FMC_IRQHandler
  .long SDIO_IRQHandler
  .long TIM5_IRQHandler
  .long SPI3_IRQHandler
  .long UART4_IRQHandler
  .long UART5_IRQHandler
  .long TIM6_DAC_IRQHandler
  .long TIM7_IRQHandler
  .long DMA2_Stream0_IRQHandler
  .long DMA2_Stream1_IRQHandler
  .long DMA2_Stream2_IRQHandler
  .long DMA2_Stream3_IRQHandler
  .long DMA2_Stream4_IRQHandler
  .long ETH_IRQHandler
  .long ETH_WKUP_IRQHandler
  .long CAN2_TX_IRQHandler
  .long CAN2_RX0_IRQHandler
  .long CAN2_RX1_IRQHandler
  .long CAN2_SCE_IRQHandler
  .long OTG_FS_IRQHandler
  .long DMA2_Stream5_IRQHandler
  .long DMA2_Stream6_IRQHandler
  .long DMA2_Stream7_IRQHandler
  .long USART6_IRQHandler
  .long I2C3_EV_IRQHandler
  .long I2C3_ER_IRQHandler
  .long OTG_HS_EP1_OUT_IRQHandler
  .long OTG_HS_EP1_IN_IRQHandler
  .long OTG_HS_WKUP_IRQHandler
  .long OTG_HS_IRQHandler
  .long DCMI_IRQHandler
  .long CRYP_IRQHandler
  .long HASH_RNG_IRQHandler
  .long FPU_IRQHandler
  .long UART7_IRQHandler
  .long UART8_IRQHandler
  .long SPI4_IRQHandler
  .long SPI5_IRQHandler
  .long SPI6_IRQHandler
  .long SAI1_IRQHandler
  .long LTDC_IRQHandler
  .long LTDC_ER_IRQHandler
  .long DMA2D_IRQHandler
  .long QUADSPI_IRQHandler
  .long DSI_IRQHandler

  .weak NonMaskableInt_Handler
  .weak MemoryManagement_Handler
  .weak BusFault_Handler
  .weak UsageFault_Handler
  .weak SVCall_Handler
  .weak DebugMonitor_Handler
  .weak PendSV_Handler
  .weak SysTick_Handler
  .weak WWDG_IRQHandler
  .weak PVD_IRQHandler
  .weak TAMP_STAMP_IRQHandler
  .weak RTC_WKUP_IRQHandler
  .weak FLASH_IRQHandler
  .weak RCC_IRQHandler
  .weak EXTI0_IRQHandler
  .weak EXTI1_IRQHandler
  .weak EXTI2_IRQHandler
  .weak EXTI3_IRQHandler
  .weak EXTI4_IRQHandler
  .weak DMA1_Stream0_IRQHandler
  .weak DMA1_Stream1_IRQHandler
  .weak DMA1_Stream2_IRQHandler
  .weak DMA1_Stream3_IRQHandler
  .weak DMA1_Stream4_IRQHandler
  .weak DMA1_Stream5_IRQHandler
  .weak DMA1_Stream6_IRQHandler
  .weak ADC_IRQHandler
  .weak CAN1_TX_IRQHandler
  .weak CAN1_RX0_IRQHandler
  .weak CAN1_RX1_IRQHandler
  .weak CAN1_SCE_IRQHandler
  .weak EXTI9_5_IRQHandler
  .weak TIM1_BRK_TIM9_IRQHandler
  .weak TIM1_UP_TIM10_IRQHandler
  .weak TIM1_TRG_COM_TIM11_IRQHandler
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
  .weak TIM8_BRK_TIM12_IRQHandler
  .weak TIM8_UP_TIM13_IRQHandler
  .weak TIM8_TRG_COM_TIM14_IRQHandler
  .weak TIM8_CC_IRQHandler
  .weak DMA1_Stream7_IRQHandler
  .weak FMC_IRQHandler
  .weak SDIO_IRQHandler
  .weak TIM5_IRQHandler
  .weak SPI3_IRQHandler
  .weak UART4_IRQHandler
  .weak UART5_IRQHandler
  .weak TIM6_DAC_IRQHandler
  .weak TIM7_IRQHandler
  .weak DMA2_Stream0_IRQHandler
  .weak DMA2_Stream1_IRQHandler
  .weak DMA2_Stream2_IRQHandler
  .weak DMA2_Stream3_IRQHandler
  .weak DMA2_Stream4_IRQHandler
  .weak ETH_IRQHandler
  .weak ETH_WKUP_IRQHandler
  .weak CAN2_TX_IRQHandler
  .weak CAN2_RX0_IRQHandler
  .weak CAN2_RX1_IRQHandler
  .weak CAN2_SCE_IRQHandler
  .weak OTG_FS_IRQHandler
  .weak DMA2_Stream5_IRQHandler
  .weak DMA2_Stream6_IRQHandler
  .weak DMA2_Stream7_IRQHandler
  .weak USART6_IRQHandler
  .weak I2C3_EV_IRQHandler
  .weak I2C3_ER_IRQHandler
  .weak OTG_HS_EP1_OUT_IRQHandler
  .weak OTG_HS_EP1_IN_IRQHandler
  .weak OTG_HS_WKUP_IRQHandler
  .weak OTG_HS_IRQHandler
  .weak DCMI_IRQHandler
  .weak CRYP_IRQHandler
  .weak HASH_RNG_IRQHandler
  .weak FPU_IRQHandler
  .weak UART7_IRQHandler
  .weak UART8_IRQHandler
  .weak SPI4_IRQHandler
  .weak SPI5_IRQHandler
  .weak SPI6_IRQHandler
  .weak SAI1_IRQHandler
  .weak LTDC_IRQHandler
  .weak LTDC_ER_IRQHandler
  .weak DMA2D_IRQHandler
  .weak QUADSPI_IRQHandler
  .weak DSI_IRQHandler

  .set NonMaskableInt_Handler, _NonMaskableInt_Handler
  .set MemoryManagement_Handler, _MemoryManagement_Handler
  .set BusFault_Handler, _BusFault_Handler
  .set UsageFault_Handler, _UsageFault_Handler
  .set SVCall_Handler, _SVCall_Handler
  .set DebugMonitor_Handler, _DebugMonitor_Handler
  .set PendSV_Handler, _PendSV_Handler
  .set SysTick_Handler, _SysTick_Handler
  .set WWDG_IRQHandler, Haltproc
  .set PVD_IRQHandler, Haltproc
  .set TAMP_STAMP_IRQHandler, Haltproc
  .set RTC_WKUP_IRQHandler, Haltproc
  .set FLASH_IRQHandler, Haltproc
  .set RCC_IRQHandler, Haltproc
  .set EXTI0_IRQHandler, Haltproc
  .set EXTI1_IRQHandler, Haltproc
  .set EXTI2_IRQHandler, Haltproc
  .set EXTI3_IRQHandler, Haltproc
  .set EXTI4_IRQHandler, Haltproc
  .set DMA1_Stream0_IRQHandler, Haltproc
  .set DMA1_Stream1_IRQHandler, Haltproc
  .set DMA1_Stream2_IRQHandler, Haltproc
  .set DMA1_Stream3_IRQHandler, Haltproc
  .set DMA1_Stream4_IRQHandler, Haltproc
  .set DMA1_Stream5_IRQHandler, Haltproc
  .set DMA1_Stream6_IRQHandler, Haltproc
  .set ADC_IRQHandler, Haltproc
  .set CAN1_TX_IRQHandler, Haltproc
  .set CAN1_RX0_IRQHandler, Haltproc
  .set CAN1_RX1_IRQHandler, Haltproc
  .set CAN1_SCE_IRQHandler, Haltproc
  .set EXTI9_5_IRQHandler, Haltproc
  .set TIM1_BRK_TIM9_IRQHandler, Haltproc
  .set TIM1_UP_TIM10_IRQHandler, Haltproc
  .set TIM1_TRG_COM_TIM11_IRQHandler, Haltproc
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
  .set TIM8_BRK_TIM12_IRQHandler, Haltproc
  .set TIM8_UP_TIM13_IRQHandler, Haltproc
  .set TIM8_TRG_COM_TIM14_IRQHandler, Haltproc
  .set TIM8_CC_IRQHandler, Haltproc
  .set DMA1_Stream7_IRQHandler, Haltproc
  .set FMC_IRQHandler, Haltproc
  .set SDIO_IRQHandler, Haltproc
  .set TIM5_IRQHandler, Haltproc
  .set SPI3_IRQHandler, Haltproc
  .set UART4_IRQHandler, Haltproc
  .set UART5_IRQHandler, Haltproc
  .set TIM6_DAC_IRQHandler, Haltproc
  .set TIM7_IRQHandler, Haltproc
  .set DMA2_Stream0_IRQHandler, Haltproc
  .set DMA2_Stream1_IRQHandler, Haltproc
  .set DMA2_Stream2_IRQHandler, Haltproc
  .set DMA2_Stream3_IRQHandler, Haltproc
  .set DMA2_Stream4_IRQHandler, Haltproc
  .set ETH_IRQHandler, Haltproc
  .set ETH_WKUP_IRQHandler, Haltproc
  .set CAN2_TX_IRQHandler, Haltproc
  .set CAN2_RX0_IRQHandler, Haltproc
  .set CAN2_RX1_IRQHandler, Haltproc
  .set CAN2_SCE_IRQHandler, Haltproc
  .set OTG_FS_IRQHandler, Haltproc
  .set DMA2_Stream5_IRQHandler, Haltproc
  .set DMA2_Stream6_IRQHandler, Haltproc
  .set DMA2_Stream7_IRQHandler, Haltproc
  .set USART6_IRQHandler, Haltproc
  .set I2C3_EV_IRQHandler, Haltproc
  .set I2C3_ER_IRQHandler, Haltproc
  .set OTG_HS_EP1_OUT_IRQHandler, Haltproc
  .set OTG_HS_EP1_IN_IRQHandler, Haltproc
  .set OTG_HS_WKUP_IRQHandler, Haltproc
  .set OTG_HS_IRQHandler, Haltproc
  .set DCMI_IRQHandler, Haltproc
  .set CRYP_IRQHandler, Haltproc
  .set HASH_RNG_IRQHandler, Haltproc
  .set FPU_IRQHandler, Haltproc
  .set UART7_IRQHandler, Haltproc
  .set UART8_IRQHandler, Haltproc
  .set SPI4_IRQHandler, Haltproc
  .set SPI5_IRQHandler, Haltproc
  .set SPI6_IRQHandler, Haltproc
  .set SAI1_IRQHandler, Haltproc
  .set LTDC_IRQHandler, Haltproc
  .set LTDC_ER_IRQHandler, Haltproc
  .set DMA2D_IRQHandler, Haltproc
  .set QUADSPI_IRQHandler, Haltproc
  .set DSI_IRQHandler, Haltproc

  .text
  end;
end.
