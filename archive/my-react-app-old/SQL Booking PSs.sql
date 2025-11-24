USE [ACCOUNTS]
GO

/****** Object:  StoredProcedure [dbo].[TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS]    Script Date: 23/11/2025 17:20:48 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO





ALTER   PROC [dbo].[TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS]
/* 
==========================================================================================
V1: Amit Patel 17/09/2012 - Created to insert, update or delete the Bookings - 4.6.00
V1.1: Dean Napper 19/09/2015 - Increased the size of the BKG_DETAIL field to 4000 characters
V2: Nikhil Bhavani 09/03/2023 - Add TSSWD PRIMARY as parameter for pass into TSSP_INSERT_UPDATE_DELETE_TS_BOOKING_RESOURCES
V3: Nikhil Bhavani 31/07/2025 - Update error message
v3.1: Andy Smith 04/09/2025 - Fixed issue with not finding Global Lookup values in ts_lookup
v3.2 Andy Smith 21/11/2025 - Fixed issue with hourly bookings setting bkg_qty =0.5
==========================================================================================
*/
   @Type      TINYINT   = 1  /* 0 = Validate Only, 1= Validate and Post */
 , @ACTION     TINYINT   = NULL /* Null = MixMode, 0 = Insert, 1 = Update, 2 = Delete */  
 , @BKG_PRIMARY       FLOAT   = 0  /* Primary key for the booking record */
 , @BKG_TYPE     VARCHAR(20)    /* The type of the booking record */
 , @BKG_USER     VARCHAR(4)        /* The id of the user who creates/updated the booking */
 , @BKG_STATUS    TINYINT         = NULL /* The booking status: 0(Pending),1(Submitted),2(Approved),3(Rejected),4(Cancelled),5(Confirmed),6(Completed),7(Invoiced) */
 , @BKG_DESCRIPTION   VARCHAR(50)     = NULL /* The description of the booking record */
 , @BKG_LOCATION    VARCHAR(50)     = NULL /* The location of the booking record */
 , @BKG_DETAIL    VARCHAR(4000)    = NULL /* The detail description of the booking record */
 , @BKG_RESOURCE    VARCHAR(16)     = NULL /* The resource for the booking */
 , @BKG_PROJECT    VARCHAR(10)     = NULL /* The project for the booking record */
 , @BKG_COSTCENTRE   VARCHAR(20)     = NULL /* The cost centre for the booking record */
 , @BKG_START    DATETIME    /* The start date of the booking record */
 , @BKG_START_TIME   VARCHAR(5)  = NULL  /* The start time of the booking record when @BKG_ALL_DAY = 0 */
 , @BKG_END     DATETIME       /* The end date of the booking record */
 , @BKG_END_TIME    VARCHAR(5)  = NULL  /* The end time of the booking record when @BKG_ALL_DAY = 0 */
 , @BKG_NOTES    VARCHAR(1000)   = NULL /* The notes for the booking record */
 , @BKG_REJECTED_REASON  VARCHAR(500)    = NULL /* The reason for which the booking is rejected */
 , @BKG_CUCODE    VARCHAR(50)     = NULL /* The booking record customer code */
 , @BKG_ADDRESS    VARCHAR(500)    = NULL /* The address for the booking record */
 , @BKG_PHONE    VARCHAR(20)     = NULL /* The phone number for the booking record */
 , @BKG_EMAIL    VARCHAR(128)    = NULL /* The email address for the booking record */
 , @BKG_RATE     FLOAT           = NULL /* The booking record rates */
 , @BKG_ROLE     VARCHAR(20)  = NULL /* The role for the booking record */
 , @BKG_COLOUR    FLOAT           = NULL /* The colour of the booking record */
 , @BKG_PO_NO    VARCHAR(50)     = NULL /* The PO No for the booking record */
 , @BKG_USER1    VARCHAR(50)     = NULL /* The User1 for the booking record */
 , @BKG_COMMENTS    VARCHAR(100)    = NULL /* The booking record comments */
 , @BKG_COLOUR_OVERRIDE  TINYINT         = NULL /* The override colour for the booking record */
 , @BKG_ALL_DAY    TINYINT         = NULL /* 1 = All Day booking, 0 = Not all day booking */
 , @BKG_CONTACT    VARCHAR(30)     = NULL /* The booking record contact */
 , @BKG_COST_PRICE   FLOAT           = NULL /* The cost price for the booking record */
 , @BKG_INVOICED    TINYINT         = NULL /* 1= Invoiced, 0 = Not Invoiced */
 , @BKG_DISCOUNT    FLOAT           = NULL /* The discount amount of the booking record */
 , @BKG_PRODUCT    VARCHAR(100)    = NULL /* The product of the booking record */
 , @BKG_OFFSITE    TINYINT         = NULL /* 1 = Booking is offsite, 0 = booking is not offsite */
 , @BGK_INV_ADDR    FLOAT           = NULL /* Invoice address primary for the booking record */ 
 , @BGK_COURSE_CODE   VARCHAR(10)     = NULL /* The booking course code */
 , @BGK_USER_CHAR1   VARCHAR(30)     = NULL /* The USER CHAR1 data for the booking record */
 , @BGK_USER_CHAR2   VARCHAR(30)     = NULL /* The USER CHAR1 data for the booking record */
 , @BGK_USER_CHAR3   VARCHAR(30)     = NULL /* The USER CHAR1 data for the booking record */
 , @BGK_USER_CHAR4   VARCHAR(30)     = NULL /* The USER CHAR1 data for the booking record */
 , @BGK_USER_CHAR5   VARCHAR(30)     = NULL /* The USER CHAR1 data for the booking record */
 , @BGK_USER_CHAR6   VARCHAR(30)     = NULL /* The USER CHAR1 data for the booking record */
 , @BGK_USER_CHAR7   VARCHAR(30)     = NULL /* The USER CHAR1 data for the booking record */
 , @BGK_USER_CHAR8   VARCHAR(30)     = NULL /* The USER CHAR1 data for the booking record */
 , @BGK_USER_CHAR9   VARCHAR(30)     = NULL /* The USER CHAR1 data for the booking record */
 , @BGK_USER_CHAR10   VARCHAR(30)     = NULL /* The USER CHAR1 data for the booking record */
 , @BGK_USER_NUM1   FLOAT           = NULL /* The USER NUM1 data for the booking record */
 , @BGK_USER_NUM2   FLOAT           = NULL /* The USER NUM2 data for the booking record */
 , @BGK_USER_NUM3   FLOAT           = NULL /* The USER NUM3 data for the booking record */
 , @BGK_USER_NUM4   FLOAT           = NULL /* The USER NUM4 data for the booking record */
 , @BGK_USER_NUM5   FLOAT           = NULL /* The USER NUM5 data for the booking record */
 , @BGK_USER_NUM6   FLOAT           = NULL /* The USER NUM6 data for the booking record */
 , @BGK_USER_NUM7   FLOAT           = NULL /* The USER NUM7 data for the booking record */
 , @BGK_USER_NUM8   FLOAT           = NULL /* The USER NUM8 data for the booking record */
 , @BGK_USER_NUM9   FLOAT           = NULL /* The USER NUM9 data for the booking record */
 , @BGK_USER_NUM10   FLOAT           = NULL /* The USER NUM10 data for the booking record */
 , @BGK_USER_FLAG1   TINYINT         = NULL /* The USER FLAG1 data for the booking record */
 , @BGK_USER_FLAG2   TINYINT         = NULL /* The USER FLAG2 data for the booking record */
 , @BGK_USER_FLAG3   TINYINT         = NULL /* The USER FLAG3 data for the booking record */
 , @BGK_USER_FLAG4   TINYINT         = NULL /* The USER FLAG4 data for the booking record */
 , @BGK_USER_FLAG5   TINYINT         = NULL /* The USER FLAG5 data for the booking record */
 , @BGK_USER_FLAG6   TINYINT         = NULL /* The USER FLAG6 data for the booking record */
 , @BGK_USER_FLAG7   TINYINT         = NULL /* The USER FLAG7 data for the booking record */
 , @BGK_USER_FLAG8   TINYINT         = NULL /* The USER FLAG8 data for the booking record */
 , @BGK_USER_FLAG9   TINYINT         = NULL /* The USER FLAG9 data for the booking record */
 , @BGK_USER_FLAG10   TINYINT         = NULL /* The USER FLAG10 data for the booking record */
 , @BGK_USER_DATE1   DATETIME  = NULL /* The USER DATE1 data for the booking record */
 , @BGK_USER_DATE2   DATETIME  = NULL /* The USER DATE2 data for the booking record */
 , @BGK_USER_DATE3   DATETIME  = NULL /* The USER DATE3 data for the booking record */
 , @BGK_USER_DATE4   DATETIME  = NULL /* The USER DATE4 data for the booking record */
 , @BGK_USER_DATE5   DATETIME  = NULL /* The USER DATE5 data for the booking record */
 , @BGK_USER_DATE6   DATETIME  = NULL /* The USER DATE6 data for the booking record */
 , @BGK_USER_DATE7   DATETIME  = NULL /* The USER DATE7 data for the booking record */
 , @BGK_USER_DATE8   DATETIME  = NULL /* The USER DATE8 data for the booking record */
 , @BGK_USER_DATE9   DATETIME  = NULL /* The USER DATE9 data for the booking record */
 , @BGK_USER_DATE10   DATETIME  = NULL /* The USER DATE10 data for the booking record */
 , @BGK_USER_NOTES1   VARCHAR(MAX)    = NULL /* The USER NOTES1 data for the booking record */
 , @BGK_USER_NOTES2   VARCHAR(MAX)    = NULL /* The USER NOTES2 data for the booking record */
 , @BGK_USER_NOTES3   VARCHAR(MAX)    = NULL /* The USER NOTES3 data for the booking record */
 , @BGK_USER_NOTES4   VARCHAR(MAX)    = NULL /* The USER NOTES4 data for the booking record */
 , @BGK_USER_NOTES5   VARCHAR(MAX)    = NULL /* The USER NOTES5 data for the booking record */
 , @BGK_USER_TIME1   DATETIME  = NULL /* The USER TIME1 data for the booking record */
 , @BGK_USER_TIME2   DATETIME  = NULL /* The USER TIME2 data for the booking record */
 , @BGK_USER_TIME3   DATETIME  = NULL /* The USER TIME3 data for the booking record */
 , @BGK_USER_TIME4   DATETIME  = NULL /* The USER TIME4 data for the booking record */
 , @BGK_USER_TIME5   DATETIME  = NULL /* The USER TIME5 data for the booking record */
 , @BGK_REF     VARCHAR(30)     = NULL /* The link booking reference */
 , @BGK_REF_LINK    VARCHAR(30)     = NULL /* The referece booking link for the booking record */
 , @BKG_DATASET    VARCHAR(30)     = NULL /* The dataset for the booking record */
 , @BKG_CURRENCY    VARCHAR(4)      = NULL /* The currency data for the booking record */
 , @BGK_USER_CHAR11   VARCHAR(30)     = NULL /* The USER CHAR11 data for the booking record */
 , @BGK_USER_CHAR12   VARCHAR(30)     = NULL /* The USER CHAR12 data for the booking record */
 , @BGK_USER_CHAR13   VARCHAR(30)     = NULL /* The USER CHAR13 data for the booking record */
 , @BGK_USER_CHAR14   VARCHAR(30)     = NULL /* The USER CHAR14 data for the booking record */
 , @BGK_USER_CHAR15   VARCHAR(30)     = NULL /* The USER CHAR15 data for the booking record */
 , @BGK_USER_CHAR16   VARCHAR(30)     = NULL /* The USER CHAR16 data for the booking record */
 , @BGK_USER_CHAR17   VARCHAR(30)     = NULL /* The USER CHAR17 data for the booking record */
 , @BGK_USER_CHAR18   VARCHAR(30)     = NULL /* The USER CHAR18 data for the booking record */
 , @BGK_USER_CHAR19   VARCHAR(30)     = NULL /* The USER CHAR19 data for the booking record */
 , @BGK_USER_CHAR20   VARCHAR(30)     = NULL /* The USER CHAR20 data for the booking record */
 , @BKG_SOW     VARCHAR(20)     = NULL /* The SOW reference for the booking record */
 , @BKG_SHADOW_DB   VARCHAR(50)     = NULL /* The Shadow DB information for the booking record */
 , @BKG_SHADOW_KEY   FLOAT           = NULL /* The shadow key for the booking record */
 , @BKG_SPLIT_PRIMARY  FLOAT           = NULL /* The primary of the split booking record */
 , @BKG_PREDECESSOR   FLOAT           = NULL /* The precesessor of the booking record */
 , @BKG_HAS_SUCCESSORS  TINYINT         = NULL /* 1 = booking has successors, 0 = no booking successors */
 , @BKG_LINK_TYPE   TINYINT         = NULL /* Link type for the booking record */
 , @BKG_SME_CALLTRAN   FLOAT           = NULL /* The SME call transaction detail for the booking record */
 , @BKRE_TSSWD_PRIMARY FLOAT   = 0  /* Primary key for the PROJECT SOW DETAIL */
 , @BKG_HALF_DAY tinyint = NULL
AS

DECLARE @ErrorStr VARCHAR(1000)
   , @Return_Value INT
   , @TSBK_PRIMARY FLOAT
   , @BKRE_END_DATE DATETIME; -- Booking resource end date

DECLARE @OriginalStatus TINYINT,
    @OriginalDescription VARCHAR(50),
    @OriginalStart DATETIME,
	@OriginalEnd DATETIME,
	@OriginalRole VARCHAR(20),
    @OriginalDetail VARCHAR(4000),
    @OriginalLocation VARCHAR(50),
	@OriginalOffsite TINYINT,
	@OriginalSOW VARCHAR(20), 
	@Original_PO_NO VARCHAR(50),
	@OriginalPRODUCT VARCHAR(100),
	@OriginalCONTACT VARCHAR(30),
	@OriginalEMAIL VARCHAR(128),
	@OriginalNotes  VARCHAR(1000);

 SELECT @OriginalStatus = BKG_STATUS,
		@OriginalDescription = BKG_DESCRIPTION,
		@OriginalStart = BKG_START,
		@OriginalEnd = BKG_END,
		@OriginalRole = BKG_Role,
		@OriginalDetail = BKG_DETAIL,
		@OriginalLocation = BKG_LOCATION,
		@OriginalOffsite = BKG_OFFSITE,
		@OriginalSOW = BKG_SOW,
		@OriginalPRODUCT =  BKG_PRODUCT,
		@OriginalCONTACT = BKG_CONTACT,
		@OriginalEMAIL = BKG_EMAIL,
		@OriginalNotes = BKG_NOTES
FROM TS_BOOKINGS WHERE BKG_PRIMARY = @BKG_PRIMARY

SELECT @TSBK_PRIMARY = TSBK_PRIMARY
FROM TS_BOOKING_TYPES
WHERE TSBK_CODE = @BKG_TYPE 

/* Validate @BKG_PRIMARY for update */  
IF ISNULL(@BKG_PRIMARY,0) = 0  AND ISNULL(@ACTION,0) = 1  
BEGIN    
    SELECT @ErrorStr = 'Please provide @BKG_PRIMARY value for update'     
 RAISERROR(@ErrorStr,16,1)     
 RETURN -1    
END 

/* Validate @BKG_START */  
IF ISNULL(@BKG_START,'') = ''   
BEGIN    
    SELECT @ErrorStr = 'Please provide @BKG_START value'     
 RAISERROR(@ErrorStr,16,1)     
 RETURN -1    
END  

/* Validate @BKG_ALL_DAY */  
IF (SELECT TSBKD_SHOW       
 FROM TS_BOOKING_TYPES_SETUP_DETAIL       
 WHERE TSBKD_FIELD_NAME = 'BKG_ALL_DAY'      
   AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0  
BEGIN   
 /* Check if @BKG_ALL_DAY is compulsary */   
 IF ISNULL(@BKG_ALL_DAY,0) = 0   
 BEGIN    
  IF EXISTS(SELECT TSBKD_COMPULSARY        
      FROM TS_BOOKING_TYPES_SETUP_DETAIL        
      WHERE TSBKD_FIELD_NAME = 'BKG_ALL_DAY'       
        AND TSBKD_COMPULSARY = 1       
        AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)    
  BEGIN     
   SELECT @ErrorStr = 'Please provide @BKG_ALL_DAY value as it is marked as a compulsory field in FP Admin'     
   RAISERROR(@ErrorStr,16,1)     
   RETURN -1    
  END   
 END  
END

/* Validate @BKG_END */  
IF ISNULL(@BKG_END,'') = ''   
BEGIN  
 SELECT @ErrorStr = 'Please supply @BKG_END parameter'
 RAISERROR(@ErrorStr,16,1)
 RETURN -1
END 

IF CAST(CONVERT(VARCHAR,@BKG_START,106) AS DATETIME) <> CAST(CONVERT(VARCHAR,@BKG_END,106) AS DATETIME) 
AND ISNULL(@BKG_ALL_DAY,0) = 0
BEGIN
 --SELECT @ErrorStr = '@BKG_ALL_DAY value can not be 0 when @BKG_START and @BKG_END are different'
 SELECT @ErrorStr = 'You cannot use hourly bookings that are split into 2 or more days. Please create as separate bookings if somebody is working overnight.'
 RAISERROR(@ErrorStr,16,1)     
 RETURN -1  
END

IF ISNULL(@BKG_ALL_DAY,0) = 0  
BEGIN
 SET @BKG_START = CAST((CONVERT(VARCHAR,@BKG_START,106) + ' ' + @BKG_START_TIME ) AS DATETIME)
 SET @BKG_END = CAST((CONVERT(VARCHAR,@BKG_END,106) + ' ' + @BKG_END_TIME ) AS DATETIME) 
END

/* Check if @BKG_END is not less than BKG_START */
IF @BKG_END < @BKG_START
BEGIN
 SELECT @ErrorStr = '@BKG_END date can not be less than @@BKG_START'
 RAISERROR(@ErrorStr,16,1)
 RETURN -1
END

SET @BKRE_END_DATE = @BKG_END
IF ISNULL(@BKG_ALL_DAY,0) <> 0  
BEGIN
 SET @BKG_START = CAST(CONVERT(VARCHAR,@BKG_START,106) AS DATETIME) 
 SET @BKG_END = CAST(CONVERT(VARCHAR,DATEADD(dd,1,@BKG_END),106) AS DATETIME) 
END


/* Validate @BKG_TYPE */  
/* Check if @BKG_TYPE is compulsary */   
IF ISNULL(@BKG_TYPE,'') = ''   
BEGIN    
    SELECT @ErrorStr = 'Please provide @BKG_TYPE value as it is marked as a compulsory field in FP Admin'     
 RAISERROR(@ErrorStr,16,1)     
 RETURN -1    
END  
ELSE BEGIN
 /* Check if the booking type exists in TS_BOOKING_TYPES */
 IF NOT EXISTS(SELECT TSBK_CODE
      FROM TS_BOOKING_TYPES 
      WHERE TSBK_CODE = @BKG_TYPE) 
 BEGIN
  SELECT @ErrorStr = 'The BKG_TYPE '''+ @BKG_TYPE + ''' supplied does not exist in TS_BOOKING_TYPES.'
  RAISERROR(@ErrorStr, 16, 1)
  RETURN -1
 END
END

/* Validate @BKG_CUCODE */  
IF (SELECT TSBKD_SHOW       
 FROM TS_BOOKING_TYPES_SETUP_DETAIL       
 WHERE TSBKD_FIELD_NAME = 'BKG_CUCODE'      
 AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0  
BEGIN   
 /* Check if @BKG_CUCODE is compulsary */   
 IF ISNULL(@BKG_CUCODE,'') = ''   
 BEGIN    
  IF EXISTS(SELECT TSBKD_COMPULSARY        
      FROM TS_BOOKING_TYPES_SETUP_DETAIL        
      WHERE TSBKD_FIELD_NAME = 'BKG_CUCODE'       
     AND TSBKD_COMPULSARY = 1       
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)    
  BEGIN     
   SELECT @ErrorStr = 'Please provide @BKG_CUCODE value as it is marked as a compulsory field in FP Admin'     
   RAISERROR(@ErrorStr,16,1)     
   RETURN -1    
  END   
 END  
END

/* Check if the customer code exist in SL_ACCOUNTS */
IF ISNULL(@BKG_CUCODE,'') <> ''   
BEGIN
 IF NOT EXISTS(SELECT CUCODE
      FROM SL_ACCOUNTS
      WHERE CUCODE = @BKG_CUCODE) 
 BEGIN
  SELECT @ErrorStr = 'The @BKG_CUCODE '''+ @BKG_CUCODE + ''' supplied does not exist in SL_ACCOUNTS.'
  RAISERROR(@ErrorStr, 16, 1)
  RETURN -1
 END
END

/* Validate @BKG_PROJECT */  
IF (SELECT TSBKD_SHOW       
 FROM TS_BOOKING_TYPES_SETUP_DETAIL       
 WHERE TSBKD_FIELD_NAME = 'BKG_PROJECT'      
   AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0  
BEGIN   
    /* Check if @BKG_PROJECT is compulsary */   
    IF ISNULL(@BKG_PROJECT,'') = ''   
    BEGIN    
     IF EXISTS(SELECT TSBKD_COMPULSARY        
      FROM TS_BOOKING_TYPES_SETUP_DETAIL        
      WHERE TSBKD_FIELD_NAME = 'BKG_PROJECT'       
     AND TSBKD_COMPULSARY = 1       
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)    
  BEGIN     
   SELECT @ErrorStr = 'Please provide @BKG_PROJECT value as it is marked as a compulsory field in FP Admin'     
   RAISERROR(@ErrorStr,16,1)     
   RETURN -1    
  END   
 END 
END

/* Check if the project code exist in CST_COSTHEADER */
IF ISNULL(@BKG_PROJECT,'') <> ''   
BEGIN
 IF NOT EXISTS(SELECT CH_CODE
      FROM CST_COSTHEADER 
       LEFT JOIN CST_COSTHEADER2 
        ON CH_PRIMARY_2 = CH_PRIMARY
       LEFT JOIN SL_ACCOUNTS 
        ON CH_ACCOUNT = CUCODE 
        AND LEN(CH_ACCOUNT) > 0
      WHERE CH_CODE = @BKG_PROJECT) 
 BEGIN
  SELECT @ErrorStr = 'The BKG_PROJECT '''+ @BKG_PROJECT + ''' supplied does not exist in CST_COSTHEADER.'
  RAISERROR(@ErrorStr, 16, 1)
  RETURN -1
 END
END

/* Validate @BKG_COSTCENTRE */  
IF (SELECT TSBKD_SHOW       
 FROM TS_BOOKING_TYPES_SETUP_DETAIL       
 WHERE TSBKD_FIELD_NAME = 'BKG_COSTCENTRE'      
   AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0  
BEGIN   
 /* Check if @BKG_COSTCENTRE is compulsary */   
 IF ISNULL(@BKG_COSTCENTRE,'') = ''   
 BEGIN    
  IF EXISTS(SELECT TSBKD_COMPULSARY        
      FROM TS_BOOKING_TYPES_SETUP_DETAIL        
      WHERE TSBKD_FIELD_NAME = 'BKG_COSTCENTRE'       
        AND TSBKD_COMPULSARY = 1       
        AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)    
  BEGIN     
   SELECT @ErrorStr = 'Please provide @BKG_COSTCENTRE value as it is marked as a compulsory field in FP Admin'     
   RAISERROR(@ErrorStr,16,1)     
   RETURN -1    
  END   
 END 
END

IF ISNULL(@BKG_PROJECT,'') <> '' AND ISNULL(@BKG_COSTCENTRE,'') <> '' 
BEGIN
 /* Check if the costcentre code exist in CST_COSTCENTRE */
 IF NOT EXISTS(SELECT CC_CODE
      FROM CST_COSTCENTRE 
      WHERE CC_COPYHEADER = @BKG_PROJECT 
     AND CC_CODE = @BKG_COSTCENTRE) 
 BEGIN
  SELECT @ErrorStr = 'The BKG_COSTCENTRE '''+ @BKG_COSTCENTRE + ''' supplied does not exist in CST_COSTCENTRE.'
  RAISERROR(@ErrorStr, 16, 1)
  RETURN -1
 END
END

/* Validate @BKG_STATUS */  
/* Check if @BKG_STATUS is compulsary */   
IF ISNULL(@BKG_STATUS,0) NOT BETWEEN 0 AND 7
BEGIN
 SELECT @ErrorStr = 'The @BKG_STATUS supplied must be of following : 0(Pending),1(Submitted),2(Approved),3(Rejected),4(Cancelled),5(Confirmed),6(Completed),7(Invoiced)'
 RAISERROR(@ErrorStr, 16, 1)
 RETURN -1
END

/* Validate @BKG_RESOURCE */  
IF (SELECT TSBKD_SHOW       
 FROM TS_BOOKING_TYPES_SETUP_DETAIL       
 WHERE TSBKD_FIELD_NAME = 'BKG_RESOURCE'      
   AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0  
BEGIN   
    /* Check if @BKG_RESOURCE is compulsary */   
    IF ISNULL(@BKG_RESOURCE,'') = ''   
    BEGIN    
     IF EXISTS(SELECT TSBKD_COMPULSARY        
      FROM TS_BOOKING_TYPES_SETUP_DETAIL        
      WHERE TSBKD_FIELD_NAME = 'BKG_RESOURCE'       
     AND TSBKD_COMPULSARY = 1       
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)    
  BEGIN     
   SELECT @ErrorStr = 'Please provide @BKG_RESOURCE value as it is marked as a compulsory field in FP Admin'     
   RAISERROR(@ErrorStr,16,1)     
   RETURN -1    
  END   
 END  
END

/* Check if BKG_RESOURCE exists in PRC_PRICE_RECS */
IF ISNULL(@BKG_RESOURCE,'') <> ''
BEGIN   
 IF NOT EXISTS (SELECT PRCODE 
       FROM PRC_PRICE_RECS 
       WHERE PRC_PRICE_RECS.PR_TYPE = 'R'
      AND PRCODE = @BKG_RESOURCE)
 BEGIN
  SELECT @ErrorStr = 'The @BKG_RESOURCE supplied does not exist in the PRC_PRICE_RECS'
  RAISERROR(@ErrorStr,16,1)
  RETURN -1
 END
END

/* Validate @BKG_ROLE */  
IF (SELECT TSBKD_SHOW       
 FROM TS_BOOKING_TYPES_SETUP_DETAIL       
 WHERE TSBKD_FIELD_NAME = 'BKG_ROLE'      
   AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0  
BEGIN   
    /* Check if @BKG_ROLE is compulsary */   
    IF ISNULL(@BKG_ROLE,'') = ''   
    BEGIN    
     IF EXISTS(SELECT TSBKD_COMPULSARY        
      FROM TS_BOOKING_TYPES_SETUP_DETAIL        
      WHERE TSBKD_FIELD_NAME = 'BKG_ROLE'       
        AND TSBKD_COMPULSARY = 1       
        AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)    
  BEGIN     
   SELECT @ErrorStr = 'Please provide @BKG_ROLE value as it is marked as a compulsory field in FP Admin'     
   RAISERROR(@ErrorStr,16,1)     
   RETURN -1    
  END   
 END  
END

/* Get the default role */
IF ISNULL(@BKG_ROLE,'')=''
BEGIN
 SELECT @BKG_ROLE = ISNULL(TSU_DEFAULT_ROLE ,'')
 FROM TS_USERS
  INNER JOIN PRC_PRICE_RECS
   ON PRC_PRICE_RECS.PRCODE = TS_USERS.TSU_RESOURCE_LINK
 WHERE PRCODE = @BKG_RESOURCE
  
 IF ISNULL(@BKG_ROLE,'')=''
 BEGIN
  IF @BKG_RATE IS NULL
  BEGIN
   SET @BKG_RATE = 0
  END
  
  IF @BKG_COST_PRICE IS NULL
  BEGIN
   SET @BKG_COST_PRICE = 0
  END
  
 END
END

IF ISNULL(@BKG_ROLE,'')<>''
BEGIN
 IF NOT EXISTS (SELECT TSR_CODE 
       FROM TS_ROLES 
       WHERE TSR_CODE = @BKG_ROLE
      AND TSR_USE_ON_RES_PLAN_AND_JC = 1 
      AND TSR_INACTIVE = 0)
 BEGIN
  SELECT @ErrorStr = 'The supplied @BKG_ROLE (' + @BKG_ROLE + ') does not exist in TS_ROLES.'
  RAISERROR(@ErrorStr, 16, 1)
  RETURN -1
 END 
 ELSE IF (@BKG_RATE IS NULL OR @BKG_COST_PRICE IS NULL)
 BEGIN
  DECLARE @USEHOURLYRATES TINYINT
     , @DAILYRATE FLOAT
     , @HOURLYRATE FLOAT
     , @TSO_JC_DATE_SENS_CON_RATES TINYINT
     , @HOURLYCOST FLOAT
     , @DAILYCOST FLOAT
                 
  SELECT @TSO_JC_DATE_SENS_CON_RATES = TSO_JC_DATE_SENS_CON_RATES 
  FROM TS_OPTIONS2
  
  SELECT @USEHOURLYRATES = TSBK_HOURLY_RATES
  FROM TS_BOOKING_TYPES
  WHERE TSBK_CODE = @BKG_TYPE
  
  IF (SELECT TSBK_OVERRIDE_RATE
   FROM TS_BOOKING_TYPES
   WHERE TSBK_CODE = @BKG_TYPE) = 1
  BEGIN
   SELECT @BKG_RATE = ISNULL(TSBK_RATE,0)
   FROM TS_BOOKING_TYPES
   WHERE TSBK_CODE = @BKG_TYPE
   
   SET @BKG_COST_PRICE = 0
  END
  ELSE BEGIN
   SELECT @DAILYRATE = TSR_SELL_PRICE_DAILY
     , @HOURLYRATE = TSR_SELL_PRICE
     , @DAILYCOST = TSR_COST_PRICE_DAILY
     , @HOURLYCOST = TSR_COST_PRICE  
   FROM TS_ROLES 
   WHERE TSR_CODE = @BKG_ROLE
   
   IF @USEHOURLYRATES = 1
   BEGIN
    SET @BKG_RATE = @HOURLYRATE
    SET @BKG_COST_PRICE = @HOURLYCOST
   END
   ELSE BEGIN
    SET @BKG_RATE = @DAILYRATE
    SET @BKG_COST_PRICE = @DAILYCOST
   END
  END
 END
END

/* Validate @BKG_PRODUCT */  
IF (SELECT TSBKD_SHOW       
 FROM TS_BOOKING_TYPES_SETUP_DETAIL      
 WHERE TSBKD_FIELD_NAME = 'BKG_PRODUCT'      
   AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0  
BEGIN   
    /* Check if @BKG_PRODUCT is compulsary */   
    IF ISNULL(@BKG_PRODUCT,'') = ''   
    BEGIN    
     IF EXISTS(SELECT TSBKD_COMPULSARY        
      FROM TS_BOOKING_TYPES_SETUP_DETAIL        
      WHERE TSBKD_FIELD_NAME = 'BKG_PRODUCT'       
        AND TSBKD_COMPULSARY = 1       
        AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)    
  BEGIN     
   SELECT @ErrorStr = 'Please provide @BKG_PRODUCT value as it is marked as a compulsory field in FP Admin'     
   RAISERROR(@ErrorStr,16,1)     
   RETURN -1    
  END    
 END 
 ELSE BEGIN
  /* Check if @BKG_PRODUCT exists in TS_BOOKING_PRODUCTS */
  IF NOT EXISTS(SELECT Product 
       FROM TS_BOOKING_PRODUCTS 
       WHERE (Project IS NULL OR Project = @BKG_PROJECT) 
      AND (Customer IS NULL OR Customer = @BKG_CUCODE)
      AND Product = @BKG_PRODUCT) 
  BEGIN
   SELECT @ErrorStr = 'The @BKG_PRODUCT '''+ @BKG_PRODUCT + ''' supplied does not exist in TS_BOOKING_PRODUCTS.'
   RAISERROR(@ErrorStr, 16, 1)
   RETURN -1
  END  
 END  
END

/* Validate @BKG_COLOUR_OVERRIDE */  
IF (SELECT TSBKD_SHOW       
 FROM TS_BOOKING_TYPES_SETUP_DETAIL       
 WHERE TSBKD_FIELD_NAME = 'BKG_COLOUR_OVERRIDE'      
   AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0  
BEGIN   
 /* Check if @BKG_COLOUR_OVERRIDE is compulsary */   
 IF ISNULL(@BKG_COLOUR_OVERRIDE,0) = 0   
 BEGIN    
  IF EXISTS(SELECT TSBKD_COMPULSARY        
      FROM TS_BOOKING_TYPES_SETUP_DETAIL        
      WHERE TSBKD_FIELD_NAME = 'BKG_COLOUR_OVERRIDE'       
        AND TSBKD_COMPULSARY = 1       
        AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)    
  BEGIN     
   SELECT @ErrorStr = 'Please provide @BKG_COLOUR_OVERRIDE value as it is marked as a compulsory field in FP Admin'     
   RAISERROR(@ErrorStr,16,1)     
   RETURN -1    
  END   
 END  
END

/* Validate @BKG_COST_PRICE */  
IF (SELECT TSBKD_SHOW       
 FROM TS_BOOKING_TYPES_SETUP_DETAIL       
 WHERE TSBKD_FIELD_NAME = 'BKG_COST_PRICE'      
   AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0  
BEGIN   
 /* Check if @BKG_COST_PRICE is compulsary */   
 IF ISNULL(@BKG_COST_PRICE,0) = 0   
 BEGIN    
  IF EXISTS(SELECT TSBKD_COMPULSARY        
      FROM TS_BOOKING_TYPES_SETUP_DETAIL        
      WHERE TSBKD_FIELD_NAME = 'BKG_COST_PRICE'       
      AND TSBKD_COMPULSARY = 1       
      AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)    
  BEGIN     
   SELECT @ErrorStr = 'Please provide @BKG_COST_PRICE value as it is marked as a compulsory field in FP Admin'     
   RAISERROR(@ErrorStr,16,1)     
   RETURN -1    
  END   
 END  
END

/* Validate @BKG_CURRENCY */  
IF (SELECT TSBKD_SHOW       
 FROM TS_BOOKING_TYPES_SETUP_DETAIL       
 WHERE TSBKD_FIELD_NAME = 'BKG_CURRENCY'      
   AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0  
BEGIN   
 /* Check if @BKG_CURRENCY is compulsary */   
 IF ISNULL(@BKG_CURRENCY,'') = ''   
 BEGIN    
  IF EXISTS(SELECT TSBKD_COMPULSARY        
      FROM TS_BOOKING_TYPES_SETUP_DETAIL        
      WHERE TSBKD_FIELD_NAME = 'BKG_CURRENCY'       
     AND TSBKD_COMPULSARY = 1       
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)    
  BEGIN     
   SELECT @ErrorStr = 'Please provide @BKG_CURRENCY value as it is marked as a compulsory field in FP Admin'     
   RAISERROR(@ErrorStr,16,1)     
   RETURN -1    
  END   
 END  
 ELSE IF NOT EXISTS(SELECT CURR_CODE 
        FROM SYS_CURRENCY 
        WHERE CURR_CODE = @BKG_CURRENCY)
 BEGIN
  SELECT @ErrorStr = 'Unable to find supplied @BKG_CURRENCY currency in SYS_CURRENCY'     
  RAISERROR(@ErrorStr,16,1)     
  RETURN -1   
 END
END

/* Validate @BKG_DESCRIPTION */  
IF (SELECT TSBKD_SHOW       
 FROM TS_BOOKING_TYPES_SETUP_DETAIL       
 WHERE TSBKD_FIELD_NAME = 'BKG_DESCRIPTION'      
   AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0  
BEGIN   
 /* Check if @BKG_DESCRIPTION is compulsary */   
 IF ISNULL(@BKG_DESCRIPTION,'') = ''   
 BEGIN    
  IF EXISTS(SELECT TSBKD_COMPULSARY        
      FROM TS_BOOKING_TYPES_SETUP_DETAIL        
      WHERE TSBKD_FIELD_NAME = 'BKG_DESCRIPTION'       
     AND TSBKD_COMPULSARY = 1       
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)    
  BEGIN     
   SELECT @ErrorStr = 'Please provide @BKG_DESCRIPTION value as it is marked as a compulsory field in FP Admin'     
   RAISERROR(@ErrorStr,16,1)     
   RETURN -1    
  END   
 END  
END

/* Validate @BKG_DETAIL */  
IF (SELECT TSBKD_SHOW       
 FROM TS_BOOKING_TYPES_SETUP_DETAIL       
 WHERE TSBKD_FIELD_NAME = 'BKG_DETAIL'      
   AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0  
BEGIN   
 /* Check if @BKG_DETAIL is compulsary */   
 IF ISNULL(@BKG_DETAIL,'') = ''   
 BEGIN    
  IF EXISTS(SELECT TSBKD_COMPULSARY        
      FROM TS_BOOKING_TYPES_SETUP_DETAIL        
      WHERE TSBKD_FIELD_NAME = 'BKG_DETAIL'       
     AND TSBKD_COMPULSARY = 1       
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)    
  BEGIN     
   SELECT @ErrorStr = 'Please provide @BKG_DETAIL value as it is marked as a compulsory field in FP Admin'     
   RAISERROR(@ErrorStr,16,1)     
   RETURN -1    
  END   
 END  
END

/* Validate @BKG_DISCOUNT */  
IF (SELECT TSBKD_SHOW       
 FROM TS_BOOKING_TYPES_SETUP_DETAIL       
 WHERE TSBKD_FIELD_NAME = 'BKG_DISCOUNT'      
   AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0  
BEGIN   
 /* Check if @BKG_DISCOUNT is compulsary */   
 IF ISNULL(@BKG_DISCOUNT,0) = 0   
 BEGIN    
  IF EXISTS(SELECT TSBKD_COMPULSARY        
      FROM TS_BOOKING_TYPES_SETUP_DETAIL        
      WHERE TSBKD_FIELD_NAME = 'BKG_DISCOUNT'       
     AND TSBKD_COMPULSARY = 1       
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)    
  BEGIN     
   SELECT @ErrorStr = 'Please provide @BKG_DISCOUNT value as it is marked as a compulsory field in FP Admin'     
   RAISERROR(@ErrorStr,16,1)     
   RETURN -1    
  END   
 END  
END

/* Validate @BKG_LOCATION */  
IF (SELECT TSBKD_SHOW       
 FROM TS_BOOKING_TYPES_SETUP_DETAIL       
 WHERE TSBKD_FIELD_NAME = 'BKG_LOCATION'      
   AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0  
BEGIN   
 /* Check if @BKG_LOCATION is compulsary */   
 IF ISNULL(@BKG_LOCATION,'') = ''   
 BEGIN    
  IF EXISTS(SELECT TSBKD_COMPULSARY        
      FROM TS_BOOKING_TYPES_SETUP_DETAIL        
      WHERE TSBKD_FIELD_NAME = 'BKG_LOCATION'       
        AND TSBKD_COMPULSARY = 1       
        AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)    
  BEGIN     
   SELECT @ErrorStr = 'Please provide @BKG_LOCATION value as it is marked as a compulsory field in FP Admin'     
   RAISERROR(@ErrorStr,16,1)     
   RETURN -1    
  END   
 END  
END

/* Validate @BKG_OFFSITE */  
IF (SELECT TSBKD_SHOW       
 FROM TS_BOOKING_TYPES_SETUP_DETAIL       
 WHERE TSBKD_FIELD_NAME = 'BKG_OFFSITE'      
   AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0  
BEGIN   
 /* Check if @BKG_OFFSITE is compulsary */   
 IF ISNULL(@BKG_OFFSITE,'') = ''   
 BEGIN    
  IF EXISTS(SELECT TSBKD_COMPULSARY        
      FROM TS_BOOKING_TYPES_SETUP_DETAIL        
      WHERE TSBKD_FIELD_NAME = 'BKG_OFFSITE'       
     AND TSBKD_COMPULSARY = 1       
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)    
  BEGIN     
   SELECT @ErrorStr = 'Please provide @BKG_OFFSITE value as it is marked as a compulsory field in FP Admin'     
   RAISERROR(@ErrorStr,16,1)     
   RETURN -1    
  END   
 END  
END

/* Validate @BKG_RATE */  
IF (SELECT TSBKD_SHOW       
 FROM TS_BOOKING_TYPES_SETUP_DETAIL      
 WHERE TSBKD_FIELD_NAME = 'BKG_RATE'      
   AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0  
BEGIN   
    /* Check if @BKG_RATE is compulsary */   
    IF ISNULL(@BKG_RATE,0) = 0   
    BEGIN    
     IF EXISTS(SELECT TSBKD_COMPULSARY        
      FROM TS_BOOKING_TYPES_SETUP_DETAIL        
      WHERE TSBKD_FIELD_NAME = 'BKG_RATE'       
     AND TSBKD_COMPULSARY = 1       
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)    
  BEGIN     
   SELECT @ErrorStr = 'Please provide @BKG_RATE value as it is marked as a compulsory field in FP Admin'     
   RAISERROR(@ErrorStr,16,1)     
   RETURN -1    
  END   
 END  
END

/* Validate @BKG_SOW */  
IF (SELECT TSBKD_SHOW       
 FROM TS_BOOKING_TYPES_SETUP_DETAIL       
 WHERE TSBKD_FIELD_NAME = 'BKG_SOW'      
   AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0  
BEGIN   
    /* Check if @BKG_SOW is compulsary */   
    IF ISNULL(@BKG_SOW,0) = 0   
    BEGIN    
     IF EXISTS(SELECT TSBKD_COMPULSARY        
      FROM TS_BOOKING_TYPES_SETUP_DETAIL       
      WHERE TSBKD_FIELD_NAME = 'BKG_SOW'       
        AND TSBKD_COMPULSARY = 1       
        AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)    
  BEGIN     
   SELECT @ErrorStr = 'Please provide @BKG_SOW value as it is marked as a compulsory field in FP Admin'     
   RAISERROR(@ErrorStr,16,1)     
   RETURN -1    
  END   
 END  
END

/* Validate @BKG_USER */  
/* Check if @BKG_USER is compulsary */   
IF ISNULL(@BKG_USER,'') = ''   
BEGIN    
    SELECT @ErrorStr = 'Please provide @BKG_USER value'     
 RAISERROR(@ErrorStr,16,1)     
 RETURN -1      
END  
ELSE BEGIN   
 /* Check if BKG_USER exists in TS_USERS */
 IF NOT EXISTS (SELECT TSU_USERID 
       FROM TS_USERS 
       WHERE TSU_USERID = @BKG_USER)
 BEGIN
  SELECT @ErrorStr = 'The @BKG_USER supplied does not exist in the TS_USERS'
  RAISERROR(@ErrorStr,16,1)
  RETURN -1
 END
END

/* Validate @BKG_USER1 */  
IF (SELECT TSBKD_SHOW       
 FROM TS_BOOKING_TYPES_SETUP_DETAIL       
 WHERE TSBKD_FIELD_NAME = 'BKG_USER1'      
   AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0  
BEGIN   
 /* Check if @BKG_USER1 is compulsary */   
 IF ISNULL(@BKG_USER1,'') = ''   
 BEGIN    
  IF EXISTS(SELECT TSBKD_COMPULSARY        
      FROM TS_BOOKING_TYPES_SETUP_DETAIL        
      WHERE TSBKD_FIELD_NAME = 'BKG_USER1'       
     AND TSBKD_COMPULSARY = 1       
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)   
  BEGIN     
   SELECT @ErrorStr = 'Please provide @BKG_USER1 value as it is marked as a compulsory field in FP Admin'     
   RAISERROR(@ErrorStr,16,1)     
   RETURN -1    
  END   
 END  
END

/* Validate @BGK_COURSE_CODE */  
IF (SELECT TSBKD_SHOW       
 FROM TS_BOOKING_TYPES_SETUP_DETAIL       
 WHERE TSBKD_FIELD_NAME = 'BGK_COURSE_CODE'      
   AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0  
BEGIN   
 /* Check if @BGK_COURSE_CODE is compulsary */   
 IF ISNULL(@BGK_COURSE_CODE,'') = ''   
 BEGIN    
  IF EXISTS(SELECT TSBKD_COMPULSARY        
      FROM TS_BOOKING_TYPES_SETUP_DETAIL        
      WHERE TSBKD_FIELD_NAME = 'BGK_COURSE_CODE'       
        AND TSBKD_COMPULSARY = 1       
        AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)    
  BEGIN     
   SELECT @ErrorStr = 'Please provide @BGK_COURSE_CODE value as it is marked as a compulsory field in FP Admin'     
   RAISERROR(@ErrorStr,16,1)     
   RETURN -1    
  END   
 END  
END

/* Check if @BGK_COURSE_CODE exists in TS_RESOURCE_COURSES */
IF ISNULL(@BGK_COURSE_CODE,'') <> ''
BEGIN   
 IF NOT EXISTS (SELECT RSCO_TITLE 
       FROM TS_RESOURCE_COURSES 
       WHERE RSCO_CODE = @BGK_COURSE_CODE)
 BEGIN
  SELECT @ErrorStr = 'The @BGK_COURSE_CODE supplied does not exist in the TS_USERS'
  RAISERROR(@ErrorStr,16,1)
  RETURN -1
 END
END

/* Validate @BGK_REF */  
IF (SELECT TSBKD_SHOW       
 FROM TS_BOOKING_TYPES_SETUP_DETAIL       
 WHERE TSBKD_FIELD_NAME = 'BGK_REF'      
   AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0  
BEGIN   
 /* Check if @BGK_REF is compulsary */   
 IF ISNULL(@BGK_REF,'') = ''   
 BEGIN    
  IF EXISTS(SELECT TSBKD_COMPULSARY        
      FROM TS_BOOKING_TYPES_SETUP_DETAIL        
      WHERE TSBKD_FIELD_NAME = 'BGK_REF'       
     AND TSBKD_COMPULSARY = 1       
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)    
  BEGIN     
   SELECT @ErrorStr = 'Please provide @BGK_REF value as it is marked as a compulsory field in FP Admin'     
   RAISERROR(@ErrorStr,16,1)     
   RETURN -1    
  END   
 END  
END

/* Validate @BGK_REF_LINK */  
IF (SELECT TSBKD_SHOW       
 FROM TS_BOOKING_TYPES_SETUP_DETAIL       
 WHERE TSBKD_FIELD_NAME = 'BGK_REF_LINK'      
   AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0  
BEGIN   
 /* Check if @BGK_REF_LINK is compulsary */   
 IF ISNULL(@BGK_REF_LINK,'') = ''   
 BEGIN    
  IF EXISTS(SELECT TSBKD_COMPULSARY        
      FROM TS_BOOKING_TYPES_SETUP_DETAIL        
      WHERE TSBKD_FIELD_NAME = 'BGK_REF_LINK'       
        AND TSBKD_COMPULSARY = 1       
        AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)    
  BEGIN     
   SELECT @ErrorStr = 'Please provide BGK_REF_LINK value as it is marked as a compulsory field in FP Admin'     
   RAISERROR(@ErrorStr,16,1)     
   RETURN -1    
  END   
 END  
END

/* Validate @BKG_SHADOW_DB */
IF ISNULL(@BKG_SHADOW_DB,'') <> ''
BEGIN
 IF NOT EXISTS(SELECT name 
      FROM master..sysdatabases
      WHERE name = @BKG_SHADOW_DB)
 BEGIN
  SELECT @ErrorStr = 'Unable to find the database ' + @BKG_SHADOW_DB  
  RAISERROR(@ErrorStr,16,1)     
  RETURN -1    
 END    
END

IF ISNULL(@BKG_SHADOW_KEY,'') <> ''
BEGIN
 IF ISNULL(@BKG_SHADOW_DB,'') = ''
 BEGIN
  SELECT @ErrorStr = 'Please provide @BKG_SHADOW_DB value'
  RAISERROR(@ErrorStr,16,1)     
  RETURN -1    
 END
 ELSE
 BEGIN
  DECLARE @SQL NVARCHAR(1000)
     , @RECCOUNT FLOAT
  
  SET @RECCOUNT = 0
  
  SELECT @SQL = 'SELECT @RECCOUNT = ISNULL(COUNT(BKG_PRIMARY),0)
      FROM ' + @BKG_SHADOW_DB + '..TS_BOOKINGS
      WHERE BKG_PRIMARY = @BKG_SHADOW_KEY'
  
  EXEC sp_executesql @SQL, 
     N'@BKG_SHADOW_KEY VARCHAR(20), @RECCOUNT FLOAT OUTPUT', 
     @BKG_SHADOW_KEY = @BKG_SHADOW_KEY,
     @RECCOUNT = @RECCOUNT OUTPUT
  
  IF @RECCOUNT = 0
  BEGIN
   SELECT @ErrorStr = 'Unable to find the @BKG_SHADOW_KEY in shadow db ' + @BKG_SHADOW_DB
   RAISERROR(@ErrorStr,16,1)     
   RETURN -1  
  END
 END
END

/* If update get the existing BKG_SOW for the booking if BKG_SOW not supplied */
IF @ACTION = 1 AND @BKG_SOW IS NULL
BEGIN
 SELECT @BKG_SOW = BKG_SOW
 FROM TS_BOOKINGS
 WHERE BKG_PRIMARY = @BKG_PRIMARY
END

/* Validate @BKG_SOW */
IF ISNULL(@BKG_SOW,'') <> ''
BEGIN
 IF NOT EXISTS(SELECT TSSW_SOW_CODE
      FROM TS_PROJECT_SOW_HEADER
      WHERE TSSW_SOW_CODE = @BKG_SOW
     AND TSSW_PROJECTCODE = @BKG_PROJECT)
 BEGIN
  --SELECT @ErrorStr = 'Unable to find the @BKG_SOW code ' + @BKG_SOW  + ' in TS_PROJECT_SOW_HEADER'
  SELECT @ErrorStr = 'Unable to find the @BKG_SOW ' + @BKG_SOW  + ' for this project'
  RAISERROR(@ErrorStr,16,1)     
  RETURN -1    
 END    
END

/* Validate @BKG_SPLIT_PRIMARY */
IF ISNULL(@BKG_SPLIT_PRIMARY,'') <> ''
BEGIN
 IF NOT EXISTS(SELECT BKG_PRIMARY
      FROM TS_BOOKINGS
      WHERE BKG_PRIMARY = @BKG_SPLIT_PRIMARY)
 BEGIN
  SELECT @ErrorStr = 'Unable to find the @BKG_SPLIT_PRIMARY code ' + @BKG_SPLIT_PRIMARY  + ' in TS_BOOKINGS'
  RAISERROR(@ErrorStr,16,1)     
  RETURN -1    
 END    
END

/* Validate @BKG_PREDECESSOR */
IF ISNULL(@BKG_PREDECESSOR,'') <> ''
BEGIN
 IF NOT EXISTS(SELECT BKG_PRIMARY
      FROM TS_BOOKINGS
      WHERE BKG_PRIMARY = @BKG_PREDECESSOR)
 BEGIN
  SELECT @ErrorStr = 'Unable to find the @BKG_PREDECESSOR code ' + @BKG_PREDECESSOR  + ' in TS_BOOKINGS'
  RAISERROR(@ErrorStr,16,1)     
  RETURN -1    
 END    
END

/* Validate USER CHAR Fields */
/* @BGK_USER_CHAR1 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR1'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_CHAR1 is compulsary */
 IF ISNULL(@BGK_USER_CHAR1,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR1'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_CHAR1 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END

 /* Check if @BGK_USER_CHAR1 is fixed entry */
 IF LEN(ISNULL(@BGK_USER_CHAR1,'')) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_FIXED
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR1'
     AND TSBKD_FIXED = 1
     AND TSBKD_LOOKUP_TYPE = 0
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   IF NOT EXISTS(SELECT LOK_VALUE3
        FROM TS_LOOKUP
         INNER JOIN TS_BOOKING_TYPES
          ON TS_BOOKING_TYPES.TSBK_PRIMARY = TS_LOOKUP.LOK_VALUE1
         AND LOK_TYPE = 'BKGTYPE'
         AND LOK_VALUE2 = 'BGK_USER_CHAR1'
        WHERE LOK_VALUE3 = @BGK_USER_CHAR1
       AND TS_BOOKING_TYPES.TSBK_PRIMARY = @TSBK_PRIMARY
        
       union    ---Also check for Global values in lookups   
       
       SELECT LOK_VALUE3
        FROM TS_LOOKUP
        where LOK_TYPE = 'BKGTYPE'
        AND LOK_VALUE2 = 'BGK_USER_CHAR1'
        and LOK_VALUE3 = @BGK_USER_CHAR1
        and lok_value1=0

       )
   BEGIN
    SELECT @ErrorStr = '@BGK_USER_CHAR1 value is marked as a fixed entry field in FP Admin. Unable to find ' + @BGK_USER_CHAR1 + ' in TS_LOOKUP.'
    RAISERROR(@ErrorStr,16,1)
    RETURN -1
   END
  END
 END
END

/* @BGK_USER_CHAR2 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR2'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_CHAR2 is compulsary */
 IF ISNULL(@BGK_USER_CHAR2,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR2'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY
     )
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_CHAR2 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END

 /* Check if @BGK_USER_CHAR2 is fixed entry */
 IF LEN(ISNULL(@BGK_USER_CHAR2,'')) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_FIXED
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR2'
     AND TSBKD_FIXED = 1
     AND TSBKD_LOOKUP_TYPE = 0
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   IF NOT EXISTS(SELECT LOK_VALUE3
        FROM TS_LOOKUP
         INNER JOIN TS_BOOKING_TYPES
          ON TS_BOOKING_TYPES.TSBK_PRIMARY = TS_LOOKUP.LOK_VALUE1
         AND LOK_TYPE = 'BKGTYPE'
         AND LOK_VALUE2 = 'BGK_USER_CHAR2'
        WHERE LOK_VALUE3 = @BGK_USER_CHAR2
       AND TS_BOOKING_TYPES.TSBK_PRIMARY = @TSBK_PRIMARY
       
       union    ---Also check for Global values in lookups   
       SELECT LOK_VALUE3
        FROM TS_LOOKUP
        where LOK_TYPE = 'BKGTYPE'
        AND LOK_VALUE2 = 'BGK_USER_CHAR2'
        and LOK_VALUE3 = @BGK_USER_CHAR2
        and lok_value1=0
       
       )
   BEGIN
    SELECT @ErrorStr = '@BGK_USER_CHAR2 value is marked as a fixed entry field in FP Admin. Unable to find ' + @BGK_USER_CHAR2 + ' in TS_LOOKUP.'
    RAISERROR(@ErrorStr,16,1)
    RETURN -1
   END
  END
 END
END

/* @BGK_USER_CHAR3 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR3'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_CHAR3 is compulsary */
 IF ISNULL(@BGK_USER_CHAR3,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR3'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_CHAR3 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END

 /* Check if @BGK_USER_CHAR3 is fixed entry */
 IF LEN(ISNULL(@BGK_USER_CHAR3,'')) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_FIXED
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR3'
     AND TSBKD_FIXED = 1
     AND TSBKD_LOOKUP_TYPE = 0
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   IF NOT EXISTS(SELECT LOK_VALUE3
        FROM TS_LOOKUP
         INNER JOIN TS_BOOKING_TYPES
          ON TS_BOOKING_TYPES.TSBK_PRIMARY = TS_LOOKUP.LOK_VALUE1
         AND LOK_TYPE = 'BKGTYPE'
         AND LOK_VALUE2 = 'BGK_USER_CHAR3'
        WHERE LOK_VALUE3 = @BGK_USER_CHAR3
       AND TS_BOOKING_TYPES.TSBK_PRIMARY = @TSBK_PRIMARY
       
       union    ---Also check for Global values in lookups   
       SELECT LOK_VALUE3
       FROM TS_LOOKUP
       where LOK_TYPE = 'BKGTYPE'
       AND LOK_VALUE2 = 'BGK_USER_CHAR3'
       and LOK_VALUE3 = @BGK_USER_CHAR3
       and lok_value1=0
       
       )
   BEGIN
    SELECT @ErrorStr = '@BGK_USER_CHAR3 value is marked as a fixed entry field in FP Admin. Unable to find ' + @BGK_USER_CHAR3 + ' in TS_LOOKUP.'
    RAISERROR(@ErrorStr,16,1)
    RETURN -1
   END
  END
 END
END

/* @BGK_USER_CHAR4 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR4'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_CHAR4 is compulsary */
 IF ISNULL(@BGK_USER_CHAR4,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR4'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_CHAR4 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END

 /* Check if @BGK_USER_CHAR4 is fixed entry */
 IF LEN(ISNULL(@BGK_USER_CHAR4,'')) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_FIXED
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR4'
     AND TSBKD_FIXED = 1
     AND TSBKD_LOOKUP_TYPE = 0
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   IF NOT EXISTS(SELECT LOK_VALUE3
        FROM TS_LOOKUP
         INNER JOIN TS_BOOKING_TYPES
          ON TS_BOOKING_TYPES.TSBK_PRIMARY = TS_LOOKUP.LOK_VALUE1
         AND LOK_TYPE = 'BKGTYPE'
         AND LOK_VALUE2 = 'BGK_USER_CHAR4'
        WHERE LOK_VALUE3 = @BGK_USER_CHAR4
       AND TS_BOOKING_TYPES.TSBK_PRIMARY = @TSBK_PRIMARY
       
       union    ---Also check for Global values in lookups   
       SELECT LOK_VALUE3
        FROM TS_LOOKUP
        where LOK_TYPE = 'BKGTYPE'
        AND LOK_VALUE2 = 'BGK_USER_CHAR4'
        and LOK_VALUE3 = @BGK_USER_CHAR4
        and lok_value1=0
       
       )
   BEGIN
    SELECT @ErrorStr = '@BGK_USER_CHAR4 value is marked as a fixed entry field in FP Admin. Unable to find ' + @BGK_USER_CHAR4 + ' in TS_LOOKUP.'
    RAISERROR(@ErrorStr,16,1)
    RETURN -1
   END
  END
 END
END

/* @BGK_USER_CHAR5 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR5'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_CHAR5 is compulsary */
 IF ISNULL(@BGK_USER_CHAR5,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR5'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY
     )
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_CHAR5 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END

 /* Check if @BGK_USER_CHAR5 is fixed entry */
 IF LEN(ISNULL(@BGK_USER_CHAR5,'')) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_FIXED
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR5'
     AND TSBKD_FIXED = 1
     AND TSBKD_LOOKUP_TYPE = 0
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   IF NOT EXISTS(SELECT LOK_VALUE3
        FROM TS_LOOKUP
         INNER JOIN TS_BOOKING_TYPES
          ON TS_BOOKING_TYPES.TSBK_PRIMARY = TS_LOOKUP.LOK_VALUE1
         AND LOK_TYPE = 'BKGTYPE'
         AND LOK_VALUE2 = 'BGK_USER_CHAR5'
        WHERE LOK_VALUE3 = @BGK_USER_CHAR1
       AND TS_BOOKING_TYPES.TSBK_PRIMARY = @TSBK_PRIMARY
       
        
     union    ---Also check for Global values in lookups   
       SELECT LOK_VALUE3
        FROM TS_LOOKUP
        where LOK_TYPE = 'BKGTYPE'
        AND LOK_VALUE2 = 'BGK_USER_CHAR5'
        and LOK_VALUE3 = @BGK_USER_CHAR5
        and lok_value1=0
     
       
       )
   BEGIN
    SELECT @ErrorStr = '@BGK_USER_CHAR5 value is marked as a fixed entry field in FP Admin. Unable to find ' + @BGK_USER_CHAR5 + ' in TS_LOOKUP.'
    RAISERROR(@ErrorStr,16,1)
    RETURN -1
   END
  END
 END
END

/* @BGK_USER_CHAR6 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR6'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_CHAR6 is compulsary */
 IF ISNULL(@BGK_USER_CHAR6,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR6'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_CHAR6 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END

 /* Check if @BGK_USER_CHAR6 is fixed entry */
 IF LEN(ISNULL(@BGK_USER_CHAR6,'')) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_FIXED
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR6'
     AND TSBKD_FIXED = 1
     AND TSBKD_LOOKUP_TYPE = 0
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   IF NOT EXISTS(SELECT LOK_VALUE3
        FROM TS_LOOKUP
         INNER JOIN TS_BOOKING_TYPES
          ON TS_BOOKING_TYPES.TSBK_PRIMARY = TS_LOOKUP.LOK_VALUE1
         AND LOK_TYPE = 'BKGTYPE'
         AND LOK_VALUE2 = 'BGK_USER_CHAR6'
        WHERE LOK_VALUE3 = @BGK_USER_CHAR1
       AND TS_BOOKING_TYPES.TSBK_PRIMARY = @TSBK_PRIMARY
       
        
     union    ---Also check for Global values in lookups   
       SELECT LOK_VALUE3
        FROM TS_LOOKUP
        where LOK_TYPE = 'BKGTYPE'
        AND LOK_VALUE2 = 'BGK_USER_CHAR6'
        and LOK_VALUE3 = @BGK_USER_CHAR6
        and lok_value1=0
     
       
       )
   BEGIN
    SELECT @ErrorStr = '@BGK_USER_CHAR6 value is marked as a fixed entry field in FP Admin. Unable to find ' + @BGK_USER_CHAR6 + ' in TS_LOOKUP.'
    RAISERROR(@ErrorStr,16,1)
    RETURN -1
   END
  END
 END
END

/* @BGK_USER_CHAR7 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR7'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_CHAR7 is compulsary */
 IF ISNULL(@BGK_USER_CHAR7,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR7'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_CHAR7 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END

 /* Check if @BGK_USER_CHAR7 is fixed entry */
 IF LEN(ISNULL(@BGK_USER_CHAR7,'')) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_FIXED
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR7'
     AND TSBKD_FIXED = 1
     AND TSBKD_LOOKUP_TYPE = 0
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   IF NOT EXISTS(SELECT LOK_VALUE3
        FROM TS_LOOKUP
         INNER JOIN TS_BOOKING_TYPES
          ON TS_BOOKING_TYPES.TSBK_PRIMARY = TS_LOOKUP.LOK_VALUE1
         AND LOK_TYPE = 'BKGTYPE'
         AND LOK_VALUE2 = 'BGK_USER_CHAR7'
        WHERE LOK_VALUE3 = @BGK_USER_CHAR1
       AND TS_BOOKING_TYPES.TSBK_PRIMARY = @TSBK_PRIMARY
        
     union    ---Also check for Global values in lookups   
       SELECT LOK_VALUE3
        FROM TS_LOOKUP
        where LOK_TYPE = 'BKGTYPE'
        AND LOK_VALUE2 = 'BGK_USER_CHAR7'
        and LOK_VALUE3 = @BGK_USER_CHAR7
        and lok_value1=0
         
       )
   BEGIN
    SELECT @ErrorStr = '@BGK_USER_CHAR7 value is marked as a fixed entry field in FP Admin. Unable to find ' + @BGK_USER_CHAR7 + ' in TS_LOOKUP.'
    RAISERROR(@ErrorStr,16,1)
    RETURN -1
   END
  END
 END
END

/* @BGK_USER_CHAR8 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR8'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_CHAR8 is compulsary */
 IF ISNULL(@BGK_USER_CHAR8,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR8'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_CHAR8 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END

 /* Check if @BGK_USER_CHAR8 is fixed entry */
 IF LEN(ISNULL(@BGK_USER_CHAR8,'')) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_FIXED
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR8'
     AND TSBKD_FIXED = 1
     AND TSBKD_LOOKUP_TYPE = 0
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   IF NOT EXISTS(SELECT LOK_VALUE3
        FROM TS_LOOKUP
         INNER JOIN TS_BOOKING_TYPES
          ON TS_BOOKING_TYPES.TSBK_PRIMARY = TS_LOOKUP.LOK_VALUE1
         AND LOK_TYPE = 'BKGTYPE'
         AND LOK_VALUE2 = 'BGK_USER_CHAR8'
        WHERE LOK_VALUE3 = @BGK_USER_CHAR1
       AND TS_BOOKING_TYPES.TSBK_PRIMARY = @TSBK_PRIMARY
       
        
     union    ---Also check for Global values in lookups   
       SELECT LOK_VALUE3
        FROM TS_LOOKUP
        where LOK_TYPE = 'BKGTYPE'
        AND LOK_VALUE2 = 'BGK_USER_CHAR8'
        and LOK_VALUE3 = @BGK_USER_CHAR8
        and lok_value1=0
       
       )
   BEGIN
    SELECT @ErrorStr = '@BGK_USER_CHAR8 value is marked as a fixed entry field in FP Admin. Unable to find ' + @BGK_USER_CHAR8 + ' in TS_LOOKUP.'
    RAISERROR(@ErrorStr,16,1)
    RETURN -1
   END
  END
 END
END

/* @BGK_USER_CHAR9 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR9'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_CHAR9 is compulsary */
 IF ISNULL(@BGK_USER_CHAR9,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR9'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_CHAR9 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END

 /* Check if @BGK_USER_CHAR9 is fixed entry */
 IF LEN(ISNULL(@BGK_USER_CHAR9,'')) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_FIXED
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR9'
     AND TSBKD_FIXED = 1
     AND TSBKD_LOOKUP_TYPE = 0
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   IF NOT EXISTS(SELECT LOK_VALUE3
        FROM TS_LOOKUP
         INNER JOIN TS_BOOKING_TYPES
          ON TS_BOOKING_TYPES.TSBK_PRIMARY = TS_LOOKUP.LOK_VALUE1
         AND LOK_TYPE = 'BKGTYPE'
         AND LOK_VALUE2 = 'BGK_USER_CHAR9'
        WHERE LOK_VALUE3 = @BGK_USER_CHAR1
       AND TS_BOOKING_TYPES.TSBK_PRIMARY = @TSBK_PRIMARY
       
     union    ---Also check for Global values in lookups   
       SELECT LOK_VALUE3
        FROM TS_LOOKUP
        where LOK_TYPE = 'BKGTYPE'
        AND LOK_VALUE2 = 'BGK_USER_CHAR9'
        and LOK_VALUE3 = @BGK_USER_CHAR9
        and lok_value1=0
       
       )
   BEGIN
    SELECT @ErrorStr = '@BGK_USER_CHAR9 value is marked as a fixed entry field in FP Admin. Unable to find ' + @BGK_USER_CHAR9 + ' in TS_LOOKUP.'
    RAISERROR(@ErrorStr,16,1)
    RETURN -1
   END
  END
 END
END

/* @BGK_USER_CHAR10 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR10'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_CHAR10 is compulsary */
 IF ISNULL(@BGK_USER_CHAR10,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR10'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_CHAR10 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END

 /* Check if @BGK_USER_CHAR10 is fixed entry */
 IF LEN(ISNULL(@BGK_USER_CHAR10,'')) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_FIXED
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR10'
     AND TSBKD_FIXED = 1
     AND TSBKD_LOOKUP_TYPE = 0
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   IF NOT EXISTS(SELECT LOK_VALUE3
        FROM TS_LOOKUP
         INNER JOIN TS_BOOKING_TYPES
          ON TS_BOOKING_TYPES.TSBK_PRIMARY = TS_LOOKUP.LOK_VALUE1
         AND LOK_TYPE = 'BKGTYPE'
         AND LOK_VALUE2 = 'BGK_USER_CHAR10'
        WHERE LOK_VALUE3 = @BGK_USER_CHAR1
       AND TS_BOOKING_TYPES.TSBK_PRIMARY = @TSBK_PRIMARY
        
     union    ---Also check for Global values in lookups   
       SELECT LOK_VALUE3
        FROM TS_LOOKUP
        where LOK_TYPE = 'BKGTYPE'
        AND LOK_VALUE2 = 'BGK_USER_CHAR10'
        and LOK_VALUE3 = @BGK_USER_CHAR10
        and lok_value1=0
       )
   BEGIN
    SELECT @ErrorStr = '@BGK_USER_CHAR10 value is marked as a fixed entry field in FP Admin. Unable to find ' + @BGK_USER_CHAR10 + ' in TS_LOOKUP.'
    RAISERROR(@ErrorStr,16,1)
    RETURN -1
   END
  END
 END
END

/* @BGK_USER_CHAR11 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR11'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_CHAR11 is compulsary */
 IF ISNULL(@BGK_USER_CHAR11,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR11'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_CHAR11 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END

 /* Check if @BGK_USER_CHAR11 is fixed entry */
 IF LEN(ISNULL(@BGK_USER_CHAR11,'')) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_FIXED
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR11'
     AND TSBKD_FIXED = 1
     AND TSBKD_LOOKUP_TYPE = 0
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   IF NOT EXISTS(SELECT LOK_VALUE3
        FROM TS_LOOKUP
         INNER JOIN TS_BOOKING_TYPES
          ON TS_BOOKING_TYPES.TSBK_PRIMARY = TS_LOOKUP.LOK_VALUE1
         AND LOK_TYPE = 'BKGTYPE'
         AND LOK_VALUE2 = 'BGK_USER_CHAR11'
        WHERE LOK_VALUE3 = @BGK_USER_CHAR1
       AND TS_BOOKING_TYPES.TSBK_PRIMARY = @TSBK_PRIMARY
        
     union    ---Also check for Global values in lookups   
       SELECT LOK_VALUE3
        FROM TS_LOOKUP
        where LOK_TYPE = 'BKGTYPE'
        AND LOK_VALUE2 = 'BGK_USER_CHAR11'
        and LOK_VALUE3 = @BGK_USER_CHAR11
        and lok_value1=0
     
       )
   BEGIN
    SELECT @ErrorStr = '@BGK_USER_CHAR11 value is marked as a fixed entry field in FP Admin. Unable to find ' + @BGK_USER_CHAR11 + ' in TS_LOOKUP.'
    RAISERROR(@ErrorStr,16,1)
    RETURN -1
   END
  END
 END
END

/* @BGK_USER_CHAR12 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR12'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_CHAR12 is compulsary */
 IF ISNULL(@BGK_USER_CHAR12,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR12'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_CHAR12 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END

 /* Check if @BGK_USER_CHAR12 is fixed entry */
 IF LEN(ISNULL(@BGK_USER_CHAR12,'')) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_FIXED
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR12'
     AND TSBKD_FIXED = 1
     AND TSBKD_LOOKUP_TYPE = 0
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   IF NOT EXISTS(SELECT LOK_VALUE3
        FROM TS_LOOKUP
         INNER JOIN TS_BOOKING_TYPES
          ON TS_BOOKING_TYPES.TSBK_PRIMARY = TS_LOOKUP.LOK_VALUE1
         AND LOK_TYPE = 'BKGTYPE'
         AND LOK_VALUE2 = 'BGK_USER_CHAR12'
        WHERE LOK_VALUE3 = @BGK_USER_CHAR1
       AND TS_BOOKING_TYPES.TSBK_PRIMARY = @TSBK_PRIMARY
       
       union    ---Also check for Global values in lookups   
       SELECT LOK_VALUE3
        FROM TS_LOOKUP
        where LOK_TYPE = 'BKGTYPE'
        AND LOK_VALUE2 = 'BGK_USER_CHAR12'
        and LOK_VALUE3 = @BGK_USER_CHAR12
        and lok_value1=0
     
       )
   BEGIN
    SELECT @ErrorStr = '@BGK_USER_CHAR12 value is marked as a fixed entry field in FP Admin. Unable to find ' + @BGK_USER_CHAR12 + ' in TS_LOOKUP.'
    RAISERROR(@ErrorStr,16,1)
    RETURN -1
   END
  END
 END
END

/* @BGK_USER_CHAR13 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR13'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_CHAR13 is compulsary */
 IF ISNULL(@BGK_USER_CHAR13,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR13'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_CHAR13 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END

 /* Check if @BGK_USER_CHAR13 is fixed entry */
 IF LEN(ISNULL(@BGK_USER_CHAR13,'')) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_FIXED
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR13'
     AND TSBKD_FIXED = 1
     AND TSBKD_LOOKUP_TYPE = 0
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   IF NOT EXISTS(SELECT LOK_VALUE3
        FROM TS_LOOKUP
         INNER JOIN TS_BOOKING_TYPES
          ON TS_BOOKING_TYPES.TSBK_PRIMARY = TS_LOOKUP.LOK_VALUE1
         AND LOK_TYPE = 'BKGTYPE'
         AND LOK_VALUE2 = 'BGK_USER_CHAR13'
        WHERE LOK_VALUE3 = @BGK_USER_CHAR1
       AND TS_BOOKING_TYPES.TSBK_PRIMARY = @TSBK_PRIMARY
       
       union    ---Also check for Global values in lookups   
       SELECT LOK_VALUE3
        FROM TS_LOOKUP
        where LOK_TYPE = 'BKGTYPE'
        AND LOK_VALUE2 = 'BGK_USER_CHAR13'
        and LOK_VALUE3 = @BGK_USER_CHAR13
        and lok_value1=0
     )
   BEGIN
    SELECT @ErrorStr = '@BGK_USER_CHAR13 value is marked as a fixed entry field in FP Admin. Unable to find ' + @BGK_USER_CHAR13 + ' in TS_LOOKUP.'
    RAISERROR(@ErrorStr,16,1)
    RETURN -1
   END
  END
 END
END

/* @BGK_USER_CHAR14 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR14'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_CHAR14 is compulsary */
 IF ISNULL(@BGK_USER_CHAR4,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR14'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_CHAR14 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END

 /* Check if @BGK_USER_CHAR14 is fixed entry */
 IF LEN(ISNULL(@BGK_USER_CHAR14,'')) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_FIXED
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR14'
     AND TSBKD_FIXED = 1
     AND TSBKD_LOOKUP_TYPE = 0
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   IF NOT EXISTS(SELECT LOK_VALUE3
        FROM TS_LOOKUP
         INNER JOIN TS_BOOKING_TYPES
          ON TS_BOOKING_TYPES.TSBK_PRIMARY = TS_LOOKUP.LOK_VALUE1
         AND LOK_TYPE = 'BKGTYPE'
         AND LOK_VALUE2 = 'BGK_USER_CHAR14'
        WHERE LOK_VALUE3 = @BGK_USER_CHAR1
       AND TS_BOOKING_TYPES.TSBK_PRIMARY = @TSBK_PRIMARY
       
       union    ---Also check for Global values in lookups   
       SELECT LOK_VALUE3
        FROM TS_LOOKUP
        where LOK_TYPE = 'BKGTYPE'
        AND LOK_VALUE2 = 'BGK_USER_CHAR14'
        and LOK_VALUE3 = @BGK_USER_CHAR14
        and lok_value1=0
     
       )
   BEGIN
    SELECT @ErrorStr = '@BGK_USER_CHAR14 value is marked as a fixed entry field in FP Admin. Unable to find ' + @BGK_USER_CHAR14 + ' in TS_LOOKUP.'
    RAISERROR(@ErrorStr,16,1)
    RETURN -1
   END
  END
 END
END

/* @BGK_USER_CHAR15 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR15'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_CHAR15 is compulsary */
 IF ISNULL(@BGK_USER_CHAR15,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR15'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_CHAR15 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END

 /* Check if @BGK_USER_CHAR15 is fixed entry */
 IF LEN(ISNULL(@BGK_USER_CHAR15,'')) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_FIXED
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR15'
     AND TSBKD_FIXED = 1
     AND TSBKD_LOOKUP_TYPE = 0
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   IF NOT EXISTS(SELECT LOK_VALUE3
        FROM TS_LOOKUP
         INNER JOIN TS_BOOKING_TYPES
          ON TS_BOOKING_TYPES.TSBK_PRIMARY = TS_LOOKUP.LOK_VALUE1
         AND LOK_TYPE = 'BKGTYPE'
         AND LOK_VALUE2 = 'BGK_USER_CHAR15'
        WHERE LOK_VALUE3 = @BGK_USER_CHAR1
       AND TS_BOOKING_TYPES.TSBK_PRIMARY = @TSBK_PRIMARY
       
       union    ---Also check for Global values in lookups   
       SELECT LOK_VALUE3
        FROM TS_LOOKUP
        where LOK_TYPE = 'BKGTYPE'
        AND LOK_VALUE2 = 'BGK_USER_CHAR15'
        and LOK_VALUE3 = @BGK_USER_CHAR15
        and lok_value1=0
     
       )
   BEGIN
    SELECT @ErrorStr = '@BGK_USER_CHAR15 value is marked as a fixed entry field in FP Admin. Unable to find ' + @BGK_USER_CHAR15 + ' in TS_LOOKUP.'
    RAISERROR(@ErrorStr,16,1)
    RETURN -1
   END
  END
 END
END

/* @BGK_USER_CHAR16 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR16'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_CHAR16 is compulsary */
 IF ISNULL(@BGK_USER_CHAR16,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR16'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_CHAR16 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END

 /* Check if @BGK_USER_CHAR16 is fixed entry */
 IF LEN(ISNULL(@BGK_USER_CHAR16,'')) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_FIXED
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR16'
     AND TSBKD_FIXED = 1
     AND TSBKD_LOOKUP_TYPE = 0
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   IF NOT EXISTS(SELECT LOK_VALUE3
        FROM TS_LOOKUP
         INNER JOIN TS_BOOKING_TYPES
          ON TS_BOOKING_TYPES.TSBK_PRIMARY = TS_LOOKUP.LOK_VALUE1
         AND LOK_TYPE = 'BKGTYPE'
         AND LOK_VALUE2 = 'BGK_USER_CHAR16'
        WHERE LOK_VALUE3 = @BGK_USER_CHAR1
       AND TS_BOOKING_TYPES.TSBK_PRIMARY = @TSBK_PRIMARY
       
       union    ---Also check for Global values in lookups   
       SELECT LOK_VALUE3
        FROM TS_LOOKUP
        where LOK_TYPE = 'BKGTYPE'
        AND LOK_VALUE2 = 'BGK_USER_CHAR16'
        and LOK_VALUE3 = @BGK_USER_CHAR16
        and lok_value1=0
     
       )
   BEGIN
    SELECT @ErrorStr = '@BGK_USER_CHAR16 value is marked as a fixed entry field in FP Admin. Unable to find ' + @BGK_USER_CHAR16 + ' in TS_LOOKUP.'
    RAISERROR(@ErrorStr,16,1)
    RETURN -1
   END
  END
 END
END

/* @BGK_USER_CHAR17 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR17'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_CHAR17 is compulsary */
 IF ISNULL(@BGK_USER_CHAR17,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR17'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY
     )
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_CHAR17 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END

 /* Check if @BGK_USER_CHAR17 is fixed entry */
 IF LEN(ISNULL(@BGK_USER_CHAR17,'')) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_FIXED
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR17'
     AND TSBKD_FIXED = 1
     AND TSBKD_LOOKUP_TYPE = 0
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   IF NOT EXISTS(SELECT LOK_VALUE3
        FROM TS_LOOKUP
         INNER JOIN TS_BOOKING_TYPES
          ON TS_BOOKING_TYPES.TSBK_PRIMARY = TS_LOOKUP.LOK_VALUE1
         AND LOK_TYPE = 'BKGTYPE'
         AND LOK_VALUE2 = 'BGK_USER_CHAR1'
        WHERE LOK_VALUE3 = @BGK_USER_CHAR1
       AND TS_BOOKING_TYPES.TSBK_PRIMARY = @TSBK_PRIMARY
       
       union    ---Also check for Global values in lookups   
       SELECT LOK_VALUE3
        FROM TS_LOOKUP
        where LOK_TYPE = 'BKGTYPE'
        AND LOK_VALUE2 = 'BGK_USER_CHAR17'
        and LOK_VALUE3 = @BGK_USER_CHAR17
        and lok_value1=0
       
       )
   BEGIN
    SELECT @ErrorStr = '@BGK_USER_CHAR17 value is marked as a fixed entry field in FP Admin. Unable to find ' + @BGK_USER_CHAR17 + ' in TS_LOOKUP.'
    RAISERROR(@ErrorStr,16,1)
    RETURN -1
   END
  END
 END
END

/* @BGK_USER_CHAR18 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR18'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_CHAR18 is compulsary */
 IF ISNULL(@BGK_USER_CHAR18,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR18'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_CHAR18 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END

 /* Check if @BGK_USER_CHAR18 is fixed entry */
 IF LEN(ISNULL(@BGK_USER_CHAR18,'')) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_FIXED
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR18'
     AND TSBKD_FIXED = 1
     AND TSBKD_LOOKUP_TYPE = 0
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   IF NOT EXISTS(SELECT LOK_VALUE3
        FROM TS_LOOKUP
         INNER JOIN TS_BOOKING_TYPES
          ON TS_BOOKING_TYPES.TSBK_PRIMARY = TS_LOOKUP.LOK_VALUE1
         AND LOK_TYPE = 'BKGTYPE'
         AND LOK_VALUE2 = 'BGK_USER_CHAR18'
        WHERE LOK_VALUE3 = @BGK_USER_CHAR1
       AND TS_BOOKING_TYPES.TSBK_PRIMARY = @TSBK_PRIMARY
       
       union    ---Also check for Global values in lookups   
       SELECT LOK_VALUE3
        FROM TS_LOOKUP
        where LOK_TYPE = 'BKGTYPE'
        AND LOK_VALUE2 = 'BGK_USER_CHAR18'
        and LOK_VALUE3 = @BGK_USER_CHAR18
        and lok_value1=0
     )
   BEGIN
    SELECT @ErrorStr = '@BGK_USER_CHAR18 value is marked as a fixed entry field in FP Admin. Unable to find ' + @BGK_USER_CHAR18 + ' in TS_LOOKUP.'
    RAISERROR(@ErrorStr,16,1)
    RETURN -1
   END
  END
 END
END

/* @BGK_USER_CHAR19 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR19'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_CHAR19 is compulsary */
 IF ISNULL(@BGK_USER_CHAR19,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR19'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_CHAR19 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END

 /* Check if @BGK_USER_CHAR19 is fixed entry */
 IF LEN(ISNULL(@BGK_USER_CHAR19,'')) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_FIXED
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR19'
     AND TSBKD_FIXED = 1
     AND TSBKD_LOOKUP_TYPE = 0
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   IF NOT EXISTS(SELECT LOK_VALUE3
        FROM TS_LOOKUP
         INNER JOIN TS_BOOKING_TYPES
          ON TS_BOOKING_TYPES.TSBK_PRIMARY = TS_LOOKUP.LOK_VALUE1
         AND LOK_TYPE = 'BKGTYPE'
         AND LOK_VALUE2 = 'BGK_USER_CHAR19'
        WHERE LOK_VALUE3 = @BGK_USER_CHAR1
       AND TS_BOOKING_TYPES.TSBK_PRIMARY = @TSBK_PRIMARY
       
       union    ---Also check for Global values in lookups   
       SELECT LOK_VALUE3
        FROM TS_LOOKUP
        where LOK_TYPE = 'BKGTYPE'
        AND LOK_VALUE2 = 'BGK_USER_CHAR19'
        and LOK_VALUE3 = @BGK_USER_CHAR19
        and lok_value1=0
     
         
       )
   BEGIN
    SELECT @ErrorStr = '@BGK_USER_CHAR19 value is marked as a fixed entry field in FP Admin. Unable to find ' + @BGK_USER_CHAR19 + ' in TS_LOOKUP.'
    RAISERROR(@ErrorStr,16,1)
    RETURN -1
   END
  END
 END
END

/* @BGK_USER_CHAR20 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR20'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_CHAR20 is compulsary */
 IF ISNULL(@BGK_USER_CHAR20,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR20'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_CHAR20 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END

 /* Check if @BGK_USER_CHAR20 is fixed entry */
 IF LEN(ISNULL(@BGK_USER_CHAR20,'')) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_FIXED
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_CHAR20'
     AND TSBKD_FIXED = 1
     AND TSBKD_LOOKUP_TYPE = 0
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   IF NOT EXISTS(SELECT LOK_VALUE3
        FROM TS_LOOKUP
         INNER JOIN TS_BOOKING_TYPES
          ON TS_BOOKING_TYPES.TSBK_PRIMARY = TS_LOOKUP.LOK_VALUE1
         AND LOK_TYPE = 'BKGTYPE'
         AND LOK_VALUE2 = 'BGK_USER_CHAR20'
        WHERE LOK_VALUE3 = @BGK_USER_CHAR1
       AND TS_BOOKING_TYPES.TSBK_PRIMARY = @TSBK_PRIMARY
       
       union    ---Also check for Global values in lookups   
       SELECT LOK_VALUE3
        FROM TS_LOOKUP
        where LOK_TYPE = 'BKGTYPE'
        AND LOK_VALUE2 = 'BGK_USER_CHAR20'
        and LOK_VALUE3 = @BGK_USER_CHAR20
        and lok_value1=0
     
       )
   BEGIN
    SELECT @ErrorStr = '@BGK_USER_CHAR20 value is marked as a fixed entry field in FP Admin. Unable to find ' + @BGK_USER_CHAR20 + ' in TS_LOOKUP.'
    RAISERROR(@ErrorStr,16,1)
    RETURN -1
   END
  END
 END
END

/* Validate user defined number fields */
/* @BGK_USER_NUM1 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_NUM1'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_NUM1 is compulsary */
 IF NOT ISNULL(@BGK_USER_NUM1,0) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_NUM1'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_NUM1 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_NUM2 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_NUM2'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_NUM2 is compulsary */
 IF NOT ISNULL(@BGK_USER_NUM2,0) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_NUM2'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_NUM2 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_NUM3 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_NUM3'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_NUM3 is compulsary */
 IF NOT ISNULL(@BGK_USER_NUM3,0) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_NUM3'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_NUM3 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_NUM4 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_NUM4'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_NUM4 is compulsary */
 IF NOT ISNULL(@BGK_USER_NUM4,0) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_NUM4'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_NUM4 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_NUM5 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_NUM5'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_NUM5 is compulsary */
 IF NOT ISNULL(@BGK_USER_NUM5,0) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_NUM5'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_NUM5 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_NUM6 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_NUM6'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_NUM6 is compulsary */
 IF NOT ISNULL(@BGK_USER_NUM6,0) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_NUM6'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @@BGK_USER_NUM6 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_NUM7 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_NUM7'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_NUM7 is compulsary */
 IF NOT ISNULL(@BGK_USER_NUM7,0) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_NUM7'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @@BGK_USER_NUM7 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_NUM8 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_NUM8'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_NUM8 is compulsary */
 IF NOT ISNULL(@BGK_USER_NUM8,0) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_NUM8'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @@BGK_USER_NUM8 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_NUM9 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_NUM9'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_NUM9 is compulsary */
 IF NOT ISNULL(@BGK_USER_NUM9,0) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_NUM9'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @@BGK_USER_NUM9 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_NUM10 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_NUM10'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_NUM10 is compulsary */
 IF NOT ISNULL(@BGK_USER_NUM10,0) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_NUM10'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @@BGK_USER_NUM10 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* Validate user defined flag fields */
/* @BGK_USER_FLAG1 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_FLAG1'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_FLAG1 is compulsary */
 IF NOT ISNULL(@BGK_USER_FLAG1,0) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_FLAG1'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_FLAG1 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_FLAG2 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_FLAG2'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_FLAG2 is compulsary */
 IF NOT ISNULL(@BGK_USER_FLAG2,0) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_FLAG2'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_FLAG2 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_FLAG3 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_FLAG3'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_FLAG3 is compulsary */
 IF NOT ISNULL(@BGK_USER_FLAG3,0) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_FLAG3'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_FLAG3 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_FLAG4 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_FLAG4'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_FLAG4 is compulsary */
 IF NOT ISNULL(@BGK_USER_FLAG4,0) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_FLAG4'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_FLAG4 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_FLAG5 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_FLAG5'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_FLAG5 is compulsary */
 IF NOT ISNULL(@BGK_USER_FLAG5,0) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_FLAG5'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_FLAG5 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_FLAG6 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_FLAG6'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_FLAG6 is compulsary */
 IF NOT ISNULL(@BGK_USER_FLAG6,0) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_FLAG6'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @@BGK_USER_FLAG6 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_FLAG7 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_FLAG7'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_FLAG7 is compulsary */
 IF NOT ISNULL(@BGK_USER_FLAG7,0) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_FLAG7'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @@BGK_USER_FLAG7 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_FLAG8 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_FLAG8'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_FLAG8 is compulsary */
 IF NOT ISNULL(@BGK_USER_FLAG8,0) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_FLAG8'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @@BGK_USER_FLAG8 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_FLAG9 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_FLAG9'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_FLAG9 is compulsary */
 IF NOT ISNULL(@BGK_USER_FLAG9,0) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_FLAG9'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @@BGK_USER_FLAG9 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_FLAG10 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_FLAG10'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_FLAG10 is compulsary */
 IF NOT ISNULL(@BGK_USER_FLAG10,0) > 0
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_FLAG10'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @@BGK_USER_FLAG10 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* Validate user defined date fields */
/* @BGK_USER_DATE1 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_DATE1'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_DATE1 is compulsary */
 IF ISNULL(@BGK_USER_DATE1,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_DATE1'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_DATE1 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_DATE2 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_DATE2'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_DATE2 is compulsary */
 IF ISNULL(@BGK_USER_DATE2,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_DATE2'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_DATE2 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_DATE3 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_DATE3'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_DATE3 is compulsary */
 IF ISNULL(@BGK_USER_DATE3,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_DATE3'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_DATE3 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_DATE4 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_DATE4'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_DATE4 is compulsary */
 IF ISNULL(@BGK_USER_DATE4,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_DATE4'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_DATE4 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_DATE5 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_DATE5'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_DATE5 is compulsary */
 IF ISNULL(@BGK_USER_DATE5,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_DATE5'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_DATE5 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_DATE6 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_DATE6'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_DATE6 is compulsary */
 IF ISNULL(@BGK_USER_DATE6,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_DATE6'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @@BGK_USER_DATE6 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_DATE7 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_DATE7'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_DATE7 is compulsary */
 IF ISNULL(@BGK_USER_DATE7,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_DATE7'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @@BGK_USER_DATE7 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_DATE8 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_DATE8'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_DATE8 is compulsary */
 IF ISNULL(@BGK_USER_DATE8,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_DATE8'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @@BGK_USER_DATE8 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_DATE9 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_DATE9'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_DATE9 is compulsary */
 IF ISNULL(@BGK_USER_DATE9,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_DATE9'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @@BGK_USER_DATE9 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_DATE10 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_DATE10'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_DATE10 is compulsary */
 IF ISNULL(@BGK_USER_DATE10,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_DATE10'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @@BGK_USER_DATE10 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* Validate user defined note fields */
/* @BGK_USER_NOTES1 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_NOTES1'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_NOTES1 is compulsary */
 IF ISNULL(@BGK_USER_NOTES1,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_NOTES1'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_NOTES1 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_NOTES2 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_NOTES2'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_NOTES2 is compulsary */
 IF ISNULL(@BGK_USER_NOTES2,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_NOTES2'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_NOTES2 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_NOTES3 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_NOTES3'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_NOTES3 is compulsary */
 IF ISNULL(@BGK_USER_NOTES3,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_NOTES3'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_NOTES3 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_NOTES4 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_NOTES4'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_NOTES4 is compulsary */
 IF ISNULL(@BGK_USER_NOTES4,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_NOTES4'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_NOTES4 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_NOTES5 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_NOTES5'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_NOTES5 is compulsary */
 IF ISNULL(@BGK_USER_NOTES5,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_NOTES5'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_NOTES5 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_TIME1 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_TIME1'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_TIME1 is compulsary */
 IF ISNULL(@BGK_USER_TIME1,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_TIME1'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_TIME1 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_TIME2 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_TIME2'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_TIME2 is compulsary */
 IF ISNULL(@BGK_USER_TIME2,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_TIME2'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_TIME2 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_TIME3 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_TIME3'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_TIME3 is compulsary */
 IF ISNULL(@BGK_USER_TIME3,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_TIME3'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_TIME3 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_TIME4 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_TIME4'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_TIME4 is compulsary */
 IF ISNULL(@BGK_USER_TIME4,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_TIME4'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_TIME4 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* @BGK_USER_TIME5 */
IF (SELECT TSBKD_SHOW
     FROM TS_BOOKING_TYPES_SETUP_DETAIL
     WHERE TSBKD_FIELD_NAME = 'BGK_USER_TIME5'
    AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)> 0
BEGIN
 /* Check if @BGK_USER_TIME5 is compulsary */
 IF ISNULL(@BGK_USER_TIME5,'') = ''
 BEGIN
  IF EXISTS(SELECT TSBKD_COMPULSARY
      FROM TS_BOOKING_TYPES_SETUP_DETAIL
      WHERE TSBKD_FIELD_NAME = 'BGK_USER_TIME5'
     AND TSBKD_COMPULSARY = 1
     AND TSBKD_TSBK_PRIMARY = @TSBK_PRIMARY)
  BEGIN
   SELECT @ErrorStr = 'Please provide @BGK_USER_TIME5 value as it is marked as a compulsory field in FP Admin'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
 END
END

/* MIXED MODE - FIND OUT IF IT IS AN INSERT OR UPDATE */
IF @ACTION IS NULL
BEGIN
 /* If @ACTION is passed in as NULL and no COURSES row found then its insert else its update */
 IF ISNULL(@BKG_PRIMARY,0) > 0
 BEGIN
  IF EXISTS(SELECT BKG_PRIMARY
       FROM TS_BOOKINGS
       WHERE BKG_PRIMARY = @BKG_PRIMARY)
  BEGIN
   SET @ACTION = 1 /* Update as it exists */
  END
  ELSE BEGIN
   SET @ACTION = 0 /* Insert as it doesnt exists */
  END
 END
 ELSE BEGIN
  SET @ACTION = 0 /* Insert as it doesnt exists */
 END 
END

IF @ACTION = 0
BEGIN
 
 IF @Type = 1
 BEGIN
  BEGIN TRANSACTION TSBK_Create
  
  EXEC @Return_Value = TSSP_GET_SEQUENCE 'BKNG', @BKG_PRIMARY OUT
     
  IF @Return_Value <> 0 
  BEGIN
   SELECT @ErrorStr = 'Falied to get the next sequence number for TS_BOOKINGS'
   RAISERROR(@ErrorStr,16,1)
   ROLLBACK TRANSACTION TSBK_Create
   RETURN -1
  END
  
  INSERT INTO TS_BOOKINGS
         ( BKG_PRIMARY
         , BKG_TYPE
         , BKG_DESCRIPTION
         , BKG_LOCATION
         , BKG_DETAIL
         , BKG_STATUS
         , BKG_RESOURCE
         , BKG_PROJECT
         , BKG_COSTCENTRE
         , BKG_START
         , BKG_END
         , BKG_DAYS
         , BKG_NOTES
         , BKG_AUTHORISED_BY
         , BKG_REJECTED_REASON
         , BKG_CUCODE
         , BKG_ADDRESS
         , BKG_PHONE
         , BKG_EMAIL
         , BKG_RATE
         , BKG_ANALYSIS
         , BKG_ROLE
         , BKG_COLOUR
         , BKG_EDITED_DATE
         , BKG_EDITED_BY
         , BKG_PO_NO
         , BKG_USER1
         , BKG_COMMENTS
         , BKG_COLOUR_OVERRIDE
         , BKG_ALL_DAY
         , BKG_CONTACT
         , BKG_COST_PRICE
         , BKG_BRING_FWD
         , BKG_INVOICED
         , BKG_DISCOUNT
         , BKG_PRODUCT
         , BKG_OFFSITE
         , BGK_INV_ADDR
         , BGK_COURSE_CODE
         , BGK_USER_CHAR1
         , BGK_USER_CHAR2
         , BGK_USER_CHAR3
         , BGK_USER_CHAR4
         , BGK_USER_CHAR5
         , BGK_USER_CHAR6
         , BGK_USER_CHAR7
         , BGK_USER_CHAR8
         , BGK_USER_CHAR9
         , BGK_USER_CHAR10
         , BGK_USER_NUM1
         , BGK_USER_NUM2
         , BGK_USER_NUM3
         , BGK_USER_NUM4
         , BGK_USER_NUM5
         , BGK_USER_NUM6
         , BGK_USER_NUM7
         , BGK_USER_NUM8
         , BGK_USER_NUM9
         , BGK_USER_NUM10
         , BGK_USER_FLAG1
         , BGK_USER_FLAG2
         , BGK_USER_FLAG3
         , BGK_USER_FLAG4
         , BGK_USER_FLAG5
         , BGK_USER_FLAG6
         , BGK_USER_FLAG7
         , BGK_USER_FLAG8
         , BGK_USER_FLAG9
         , BGK_USER_FLAG10
         , BGK_USER_DATE1
         , BGK_USER_DATE2
         , BGK_USER_DATE3
         , BGK_USER_DATE4
         , BGK_USER_DATE5
         , BGK_USER_DATE6
         , BGK_USER_DATE7
         , BGK_USER_DATE8
         , BGK_USER_DATE9
         , BGK_USER_DATE10
         , BGK_USER_NOTES1
         , BGK_USER_NOTES2
         , BGK_USER_NOTES3
         , BGK_USER_NOTES4
         , BGK_USER_NOTES5
         , BGK_USER_TIME1
         , BGK_USER_TIME2
         , BGK_USER_TIME3
         , BGK_USER_TIME4
         , BGK_USER_TIME5
         , BGK_REF
         , BGK_REF_LINK
         , BKG_DATASET
         , BKG_CURRENCY
         , BGK_USER_CHAR11
         , BGK_USER_CHAR12
         , BGK_USER_CHAR13
         , BGK_USER_CHAR14
         , BGK_USER_CHAR15
         , BGK_USER_CHAR16
         , BGK_USER_CHAR17
         , BGK_USER_CHAR18
         , BGK_USER_CHAR19
         , BGK_USER_CHAR20
         , BKG_SOW
         , BKG_DATE_PUTIN
         , BKG_USER_PUTIN
         , BKG_CANCELLED_BY
         , BKG_SHADOW_DB
         , BKG_SHADOW_KEY
         , BKG_SPLIT_PRIMARY
         , BKG_PREDECESSOR
         , BKG_HAS_SUCCESSORS
         , BKG_LINK_TYPE
         , BKG_SME_CALLTRAN
		 , BKG_HALF_DAY )
     VALUES
        (@BKG_PRIMARY --<BKG_PRIMARY, float,>
       , @BKG_TYPE --<BKG_TYPE, varchar(20),>
       , ISNULL(@BKG_DESCRIPTION, '') --<BKG_DESCRIPTION, varchar(50),>
       , ISNULL(@BKG_LOCATION, '') --<BKG_LOCATION, varchar(50),>
       , ISNULL(@BKG_DETAIL, '') --<BKG_DETAIL, varchar(500),>
       , ISNULL(@BKG_STATUS, 0) --<BKG_STATUS, tinyint,>
       , ISNULL(@BKG_RESOURCE, '') --<BKG_RESOURCE, varchar(16),>
       , ISNULL(@BKG_PROJECT, '') --<BKG_PROJECT, varchar(10),>
       , ISNULL(@BKG_COSTCENTRE, '') --<BKG_COSTCENTRE, varchar(20),>
       , CASE 
			WHEN ISNULL(@BKG_ALL_DAY, 0) = 0 THEN  @BKG_START
			ELSE CAST(CONVERT(VARCHAR,@BKG_START,106) AS DATETIME) 
		 END --<BKG_START, datetime,>
       , CASE 
			WHEN ISNULL(@BKG_ALL_DAY, 0) = 0 THEN  @BKG_END  
			ELSE CAST(CONVERT(VARCHAR,@BKG_END,106) AS DATETIME) 
		 END --<BKG_END, datetime,>
       , CASE 
			WHEN ISNULL(@BKG_ALL_DAY, 0) = 0 
                and @BKG_HALF_DAY=1 THEN 0.5   --Updated by Andy smith 21 November 2025, as hourly bookings were showing as 0.5
			ELSE DATEDIFF(DD, @BKG_START, @BKG_END)
		 END --<BKG_DAYS, float,>
       , ISNULL(@BKG_NOTES, '') --<BKG_NOTES, varchar(1000),>
       , '' --<BKG_AUTHORISED_BY, varchar(4),>
       , ISNULL(@BKG_REJECTED_REASON, '') --<BKG_REJECTED_REASON, varchar(500),>
       , ISNULL(@BKG_CUCODE, '') --<BKG_CUCODE, varchar(50),>
       , ISNULL(@BKG_ADDRESS, '') --<BKG_ADDRESS, varchar(500),>
       , ISNULL(@BKG_PHONE, '') --<BKG_PHONE, varchar(20),>
       , ISNULL(@BKG_EMAIL, '') --<BKG_EMAIL, varchar(128),>
       , ISNULL(@BKG_RATE, 0) --<BKG_RATE, float,>
       , '' --<BKG_ANALYSIS, varchar(25),>
       , ISNULL(@BKG_ROLE, '') --<BKG_ROLE, varchar(20),>
       , ISNULL(@BKG_COLOUR, 0) --<BKG_COLOUR, float,>
       , GETDATE() --<BKG_EDITED_DATE, datetime,>
       , ISNULL(@BKG_USER, '') --<BKG_EDITED_BY, varchar(4),>
       , ISNULL(@BKG_PO_NO, '') --<BKG_PO_NO, varchar(50),>
       , ISNULL(@BKG_USER1, '') --<BKG_USER1, varchar(50),>
       , ISNULL(@BKG_COMMENTS, '') --<BKG_COMMENTS, varchar(100),>
       , ISNULL(@BKG_COLOUR_OVERRIDE, 0) --<BKG_COLOUR_OVERRIDE, tinyint,>
       , ISNULL(@BKG_ALL_DAY, 1) --<BKG_ALL_DAY, tinyint,>
       , ISNULL(@BKG_CONTACT, '') --<BKG_CONTACT, varchar(30),>
       , ISNULL(@BKG_COST_PRICE, 0) --<BKG_COST_PRICE, float,>
       , 0 --<BKG_BRING_FWD, tinyint,>
       , ISNULL(@BKG_INVOICED, 0) --<BKG_INVOICED, tinyint,>
       , ISNULL(@BKG_DISCOUNT, 0) --<BKG_DISCOUNT, float,>
       , ISNULL(@BKG_PRODUCT, '') --<BKG_PRODUCT, varchar(100),>
       , ISNULL(@BKG_OFFSITE, 0) --<BKG_OFFSITE, tinyint,>
       , ISNULL(@BGK_INV_ADDR, 0) --<BGK_INV_ADDR, float,>
       , ISNULL(@BGK_COURSE_CODE, '') --<BGK_COURSE_CODE, varchar(10),>
       , ISNULL(@BGK_USER_CHAR1, '') --<BGK_USER_CHAR1, varchar(30),>
       , ISNULL(@BGK_USER_CHAR2, '') --<BGK_USER_CHAR2, varchar(30),>
       , ISNULL(@BGK_USER_CHAR3, '') --<BGK_USER_CHAR3, varchar(30),>
       , ISNULL(@BGK_USER_CHAR4, '') --<BGK_USER_CHAR4, varchar(30),>
       , ISNULL(@BGK_USER_CHAR5, '') --<BGK_USER_CHAR5, varchar(30),>
       , ISNULL(@BGK_USER_CHAR6, '') --<BGK_USER_CHAR6, varchar(30),>
       , ISNULL(@BGK_USER_CHAR7, '') --<BGK_USER_CHAR7, varchar(30),>
       , ISNULL(@BGK_USER_CHAR8, '') --<BGK_USER_CHAR8, varchar(30),>
       , ISNULL(@BGK_USER_CHAR9, '') --<BGK_USER_CHAR9, varchar(30),>
       , ISNULL(@BGK_USER_CHAR10, '') --<BGK_USER_CHAR10, varchar(30),>
       , ISNULL(@BGK_USER_NUM1,0) --<BGK_USER_NUM1, float,>
       , ISNULL(@BGK_USER_NUM2,0) --<BGK_USER_NUM2, float,>
       , ISNULL(@BGK_USER_NUM3,0) --<BGK_USER_NUM3, float,>
       , ISNULL(@BGK_USER_NUM4,0) --<BGK_USER_NUM4, float,>
       , ISNULL(@BGK_USER_NUM5,0) --<BGK_USER_NUM5, float,>
       , ISNULL(@BGK_USER_NUM6,0) --<BGK_USER_NUM6, float,>
       , ISNULL(@BGK_USER_NUM7,0) --<BGK_USER_NUM7, float,>
       , ISNULL(@BGK_USER_NUM8,0) --<BGK_USER_NUM8, float,>
       , ISNULL(@BGK_USER_NUM9,0) --<BGK_USER_NUM9, float,>
       , ISNULL(@BGK_USER_NUM10,0) --<BGK_USER_NUM10, float,>
       , ISNULL(@BGK_USER_FLAG1,0) --<BGK_USER_FLAG1, tinyint,>
       , ISNULL(@BGK_USER_FLAG2,0) --<BGK_USER_FLAG2, tinyint,>
       , ISNULL(@BGK_USER_FLAG3,0) --<BGK_USER_FLAG3, tinyint,>
       , ISNULL(@BGK_USER_FLAG4,0) --<BGK_USER_FLAG4, tinyint,>
       , ISNULL(@BGK_USER_FLAG5,0) --<BGK_USER_FLAG5, tinyint,>
       , ISNULL(@BGK_USER_FLAG6,0) --<BGK_USER_FLAG6, tinyint,>
       , ISNULL(@BGK_USER_FLAG7,0) --<BGK_USER_FLAG7, tinyint,>
       , ISNULL(@BGK_USER_FLAG8,0) --<BGK_USER_FLAG8, tinyint,>
       , ISNULL(@BGK_USER_FLAG9,0) --<BGK_USER_FLAG9, tinyint,>
       , ISNULL(@BGK_USER_FLAG10,0) --<BGK_USER_FLAG10, tinyint,>
       , @BGK_USER_DATE1 --<BGK_USER_DATE1, datetime,>
       , @BGK_USER_DATE2 --<BGK_USER_DATE2, datetime,>
       , @BGK_USER_DATE3 --<BGK_USER_DATE3, datetime,>
       , @BGK_USER_DATE4 --<BGK_USER_DATE4, datetime,>
       , @BGK_USER_DATE5 --<BGK_USER_DATE5, datetime,>
       , @BGK_USER_DATE6 --<BGK_USER_DATE6, datetime,>
       , @BGK_USER_DATE7 --<BGK_USER_DATE7, datetime,>
       , @BGK_USER_DATE8 --<BGK_USER_DATE8, datetime,>
       , @BGK_USER_DATE9 --<BGK_USER_DATE9, datetime,>
       , @BGK_USER_DATE10 --<BGK_USER_DATE10, datetime,>
       , ISNULL(@BGK_USER_NOTES1,'') --<BGK_USER_NOTES1, varchar,>
       , ISNULL(@BGK_USER_NOTES2,'') --<BGK_USER_NOTES2, varchar,>
       , ISNULL(@BGK_USER_NOTES3,'') --<BGK_USER_NOTES3, varchar,>
       , ISNULL(@BGK_USER_NOTES4,'') --<BGK_USER_NOTES4, varchar,>
       , ISNULL(@BGK_USER_NOTES5,'') --<BGK_USER_NOTES5, varchar,>
       , @BGK_USER_TIME1 --<BGK_USER_TIME1, datetime,>
       , @BGK_USER_TIME2 --<BGK_USER_TIME2, datetime,>
       , @BGK_USER_TIME3 --<BGK_USER_TIME3, datetime,>
       , @BGK_USER_TIME4 --<BGK_USER_TIME4, datetime,>
       , @BGK_USER_TIME5 --<BGK_USER_TIME5, datetime,>
       , ISNULL(@BGK_REF, '') --<BGK_REF, varchar(30),>
       , ISNULL(@BGK_REF_LINK, '') --<BGK_REF_LINK, varchar(30),>
       , ISNULL(@BKG_DATASET, '') --<BKG_DATASET, varchar(30),>
       , ISNULL(@BKG_CURRENCY, '')--<BKG_CURRENCY, varchar(4),>
       , ISNULL(@BGK_USER_CHAR11, '') --<BGK_USER_CHAR11, varchar(30),>
       , ISNULL(@BGK_USER_CHAR12, '') --<BGK_USER_CHAR12, varchar(30),>
       , ISNULL(@BGK_USER_CHAR13, '') --<BGK_USER_CHAR13, varchar(30),>
       , ISNULL(@BGK_USER_CHAR14, '') --<BGK_USER_CHAR14, varchar(30),>
       , ISNULL(@BGK_USER_CHAR15, '') --<BGK_USER_CHAR15, varchar(30),>
       , ISNULL(@BGK_USER_CHAR16, '') --<BGK_USER_CHAR16, varchar(30),>
       , ISNULL(@BGK_USER_CHAR17, '') --<BGK_USER_CHAR17, varchar(30),>
       , ISNULL(@BGK_USER_CHAR18, '') --<BGK_USER_CHAR18, varchar(30),>
       , ISNULL(@BGK_USER_CHAR19, '') --<BGK_USER_CHAR19, varchar(30),>
       , ISNULL(@BGK_USER_CHAR20, '') --<BGK_USER_CHAR20, varchar(30),>
       , ISNULL(@BKG_SOW, '') --<BKG_SOW, varchar(20),>
       , GETDATE() --<BKG_DATE_PUTIN, datetime,>
       , ISNULL(@BKG_USER, '') --<BKG_USER_PUTIN, varchar(4),>
       , CASE 
    WHEN @BKG_STATUS = 4 THEN ISNULL(@BKG_USER, '')
    ELSE ''
   END --<BKG_CANCELLED_BY, varchar(4),>
       , ISNULL(@BKG_SHADOW_DB, '') --<BKG_SHADOW_DB, varchar(50),>
       , ISNULL(@BKG_SHADOW_KEY, 0) --<BKG_SHADOW_KEY, float,>
       , ISNULL(@BKG_SPLIT_PRIMARY ,0) --<BKG_SPLIT_PRIMARY, float,>
       , ISNULL(@BKG_SPLIT_PRIMARY, 0) --<BKG_PREDECESSOR, float,>
       , ISNULL(@BKG_HAS_SUCCESSORS, 0) --<BKG_HAS_SUCCESSORS, tinyint,>
       , ISNULL(@BKG_LINK_TYPE, 0) --<BKG_LINK_TYPE, tinyint,>
       , ISNULL(@BKG_SME_CALLTRAN, 0) --<BKG_SME_CALLTRAN, float,>)
	   , @BKG_HALF_DAY)
	
  IF @@ERROR <> 0
  BEGIN
   SELECT @ErrorStr = 'Falied to insert into TS_BOOKINGS'
   RAISERROR(@ErrorStr,16,1)
   ROLLBACK TRANSACTION TSBK_Create
   RETURN -1
  END
  
  IF ISNULL(@BKG_RESOURCE,'') <> ''
  BEGIN	
   EXECUTE @Return_Value = [TSSP_INSERT_UPDATE_DELETE_TS_BOOKING_RESOURCES] 
        @Type = 1
      , @Action = 0
      , @BKRE_BKG_PRIMARY = @BKG_PRIMARY
      , @BKRE_RESOURCE = @BKG_RESOURCE
      , @BKRE_DATE_START = @BKG_START
      , @BKRE_DATE_END =  @BKRE_END_DATE
      , @BKRE_ROLE = @BKG_ROLE
      , @BKRE_RATE = @BKG_RATE 
      , @BKRE_DISCOUNT = @BKG_DISCOUNT
      , @BKRE_COST_PRICE = @BKG_COST_PRICE
      , @ONLY_UPDATE_FOR_DATES = 0
	  , @BKRE_TSSWD_PRIMARY = @BKRE_TSSWD_PRIMARY
   
   IF @Return_Value <> 0 
   BEGIN
    SELECT @ErrorStr = 'Falied to add TS_BOOKING_RESOURCES records for resource: ' + @BKG_RESOURCE
    RAISERROR(@ErrorStr,16,1)
    ROLLBACK TRANSACTION TSBK_Create
    RETURN -1
   END
  END
  
  COMMIT TRANSACTION
 END
END

ELSE IF @ACTION = 1
BEGIN
 /* Update the record */
 IF NOT EXISTS(SELECT BKG_PRIMARY
     FROM TS_BOOKINGS
     WHERE BKG_PRIMARY = @BKG_PRIMARY)
 BEGIN
  SELECT @ErrorStr = 'Unable to find a booking with the reference number: ' + CAST(@BKG_PRIMARY AS VARCHAR(10))
  RAISERROR(@ErrorStr,16,1)
  RETURN -1
 END
 
IF @Type = 1
 BEGIN  
  BEGIN TRANSACTION TSBK_Update
  
  UPDATE TS_BOOKINGS
     SET    BKG_TYPE = @BKG_TYPE --<BKG_TYPE, varchar(20),>
    , BKG_DESCRIPTION = COALESCE(@BKG_DESCRIPTION, BKG_DESCRIPTION) --<BKG_DESCRIPTION, varchar(50),>
    , BKG_LOCATION = COALESCE(@BKG_LOCATION, BKG_LOCATION) --<BKG_LOCATION, varchar(50),>
    , BKG_DETAIL = COALESCE(@BKG_DETAIL, BKG_DETAIL) --<BKG_DETAIL, varchar(500),>
    , BKG_STATUS = COALESCE(@BKG_STATUS, BKG_STATUS) --<BKG_STATUS, tinyint,>
    , BKG_RESOURCE = COALESCE(@BKG_RESOURCE, BKG_RESOURCE) --<BKG_RESOURCE, varchar(16),>
    , BKG_PROJECT = COALESCE(@BKG_PROJECT, BKG_PROJECT) --<BKG_PROJECT, varchar(10),>
    , BKG_COSTCENTRE = COALESCE(@BKG_COSTCENTRE, BKG_COSTCENTRE) --<BKG_COSTCENTRE, varchar(20),>
    , BKG_START = CASE 
          WHEN ISNULL(@BKG_ALL_DAY, 0) = 0 THEN  @BKG_START  
          ELSE CAST(CONVERT(VARCHAR,@BKG_START,106) AS DATETIME) 
         END--<BKG_START, datetime,>
    , BKG_END = CASE 
          WHEN ISNULL(@BKG_ALL_DAY, 0) = 0 THEN  @BKG_END  
          ELSE CAST(CONVERT(VARCHAR,@BKG_END,106) AS DATETIME) 
         END--<BKG_END, datetime,>
    , BKG_DAYS = CASE 
         WHEN ISNULL(@BKG_ALL_DAY, 0) = 0 
          and @BKG_HALF_DAY=1 THEN 0.5
         ELSE DATEDIFF(DD,@BKG_START,@BKG_END)
        END  --<BKG_DAYS, float,>
    , BKG_NOTES = COALESCE(@BKG_NOTES, BKG_NOTES) --<BKG_NOTES, varchar(1000),>
    , BKG_REJECTED_REASON = COALESCE(@BKG_REJECTED_REASON, BKG_REJECTED_REASON) --<BKG_REJECTED_REASON, varchar(500),>
    , BKG_CUCODE = COALESCE(@BKG_CUCODE, BKG_CUCODE) --<BKG_CUCODE, varchar(50),>
    , BKG_ADDRESS = COALESCE(@BKG_ADDRESS, BKG_ADDRESS) --<BKG_ADDRESS, varchar(500),>
    , BKG_PHONE = COALESCE(@BKG_PHONE, BKG_PHONE) --<BKG_PHONE, varchar(20),>
    , BKG_EMAIL = COALESCE(@BKG_EMAIL, BKG_EMAIL) --<BKG_EMAIL, varchar(128),>
    , BKG_RATE = COALESCE(@BKG_RATE, BKG_RATE) --<BKG_RATE, float,>
    , BKG_ROLE = COALESCE(@BKG_ROLE, BKG_ROLE) --<BKG_ROLE, varchar(20),>
    , BKG_COLOUR = COALESCE(@BKG_COLOUR, BKG_COLOUR) --<BKG_COLOUR, float,>
    , BKG_EDITED_DATE = GETDATE() --<BKG_EDITED_DATE, datetime,>
    , BKG_EDITED_BY = COALESCE(@BKG_USER, BKG_EDITED_BY) --<BKG_EDITED_BY, varchar(4),>
    , BKG_PO_NO = COALESCE(@BKG_PO_NO, BKG_PO_NO) --<BKG_PO_NO, varchar(50),>
    , BKG_USER1 = COALESCE(@BKG_USER1, BKG_USER1) --<BKG_USER1, varchar(50),>
    , BKG_COMMENTS = COALESCE(@BKG_COMMENTS, BKG_COMMENTS) --<BKG_COMMENTS, varchar(100),>
    , BKG_COLOUR_OVERRIDE = COALESCE(@BKG_COLOUR_OVERRIDE, BKG_COLOUR_OVERRIDE) --<BKG_COLOUR_OVERRIDE, tinyint,>
    , BKG_ALL_DAY = ISNULL(@BKG_ALL_DAY, 0) --<BKG_ALL_DAY, tinyint,>
    , BKG_CONTACT = COALESCE(@BKG_CONTACT, BKG_CONTACT) --<BKG_CONTACT, varchar(30),>
    , BKG_COST_PRICE = COALESCE(@BKG_COST_PRICE, BKG_COST_PRICE) --<BKG_COST_PRICE, float,>
    , BKG_INVOICED = COALESCE(@BKG_INVOICED, BKG_INVOICED) --<BKG_INVOICED, tinyint,>
    , BKG_DISCOUNT = COALESCE(@BKG_DISCOUNT, BKG_DISCOUNT) --<BKG_DISCOUNT, float,>
    , BKG_PRODUCT = COALESCE(@BKG_PRODUCT, BKG_PRODUCT) --<BKG_PRODUCT, varchar(100),>
    , BKG_OFFSITE = COALESCE(@BKG_OFFSITE, BKG_OFFSITE) --<BKG_OFFSITE, tinyint,>
    , BGK_INV_ADDR = COALESCE(@BGK_INV_ADDR, BGK_INV_ADDR) --<BGK_INV_ADDR, float,>
    , BGK_COURSE_CODE = COALESCE(@BGK_COURSE_CODE, BGK_COURSE_CODE) --<BGK_COURSE_CODE, varchar(10),>
    , BGK_USER_CHAR1 = COALESCE(@BGK_USER_CHAR1, BGK_USER_CHAR1) --<BGK_USER_CHAR1, varchar(30),>
    , BGK_USER_CHAR2 = COALESCE(@BGK_USER_CHAR2, BGK_USER_CHAR2) --<BGK_USER_CHAR2, varchar(30),>
    , BGK_USER_CHAR3 = COALESCE(@BGK_USER_CHAR3, BGK_USER_CHAR3) --<BGK_USER_CHAR3, varchar(30),>
    , BGK_USER_CHAR4 = COALESCE(@BGK_USER_CHAR4, BGK_USER_CHAR4) --<BGK_USER_CHAR4, varchar(30),>
    , BGK_USER_CHAR5 = COALESCE(@BGK_USER_CHAR5, BGK_USER_CHAR5) --<BGK_USER_CHAR5, varchar(30),>
    , BGK_USER_CHAR6 = COALESCE(@BGK_USER_CHAR6, BGK_USER_CHAR6) --<BGK_USER_CHAR6, varchar(30),>
    , BGK_USER_CHAR7 = COALESCE(@BGK_USER_CHAR7, BGK_USER_CHAR7) --<BGK_USER_CHAR7, varchar(30),>
    , BGK_USER_CHAR8 = COALESCE(@BGK_USER_CHAR8, BGK_USER_CHAR8) --<BGK_USER_CHAR8, varchar(30),>
    , BGK_USER_CHAR9 = COALESCE(@BGK_USER_CHAR9, BGK_USER_CHAR9) --<BGK_USER_CHAR9, varchar(30),>
    , BGK_USER_CHAR10 = COALESCE(@BGK_USER_CHAR10, BGK_USER_CHAR10) --<BGK_USER_CHAR10, varchar(30),>
    , BGK_USER_NUM1 = COALESCE(@BGK_USER_NUM1, BGK_USER_NUM1) --<BGK_USER_NUM1, float,>
    , BGK_USER_NUM2 = COALESCE(@BGK_USER_NUM2, BGK_USER_NUM2) --<BGK_USER_NUM2, float,>
    , BGK_USER_NUM3 = COALESCE(@BGK_USER_NUM3, BGK_USER_NUM3) --<BGK_USER_NUM3, float,>
    , BGK_USER_NUM4 = COALESCE(@BGK_USER_NUM4, BGK_USER_NUM4) --<BGK_USER_NUM4, float,>
    , BGK_USER_NUM5 = COALESCE(@BGK_USER_NUM5, BGK_USER_NUM5) --<BGK_USER_NUM5, float,>
    , BGK_USER_NUM6 = COALESCE(@BGK_USER_NUM6, BGK_USER_NUM6) --<BGK_USER_NUM6, float,>
    , BGK_USER_NUM7 = COALESCE(@BGK_USER_NUM7, BGK_USER_NUM7) --<BGK_USER_NUM7, float,>
    , BGK_USER_NUM8 = COALESCE(@BGK_USER_NUM8, BGK_USER_NUM8) --<BGK_USER_NUM8, float,>
    , BGK_USER_NUM9 = COALESCE(@BGK_USER_NUM9, BGK_USER_NUM9) --<BGK_USER_NUM9, float,>
    , BGK_USER_NUM10 = COALESCE(@BGK_USER_NUM10, BGK_USER_NUM10) --<BGK_USER_NUM10, float,>
    , BGK_USER_FLAG1 = COALESCE(@BGK_USER_FLAG1, BGK_USER_FLAG1) --<BGK_USER_FLAG1, tinyint,>
    , BGK_USER_FLAG2 = COALESCE(@BGK_USER_FLAG2, BGK_USER_FLAG2) --<BGK_USER_FLAG2, tinyint,>
    , BGK_USER_FLAG3 = COALESCE(@BGK_USER_FLAG3, BGK_USER_FLAG3) --<BGK_USER_FLAG3, tinyint,>
    , BGK_USER_FLAG4 = COALESCE(@BGK_USER_FLAG4, BGK_USER_FLAG4) --<BGK_USER_FLAG4, tinyint,>
    , BGK_USER_FLAG5 = COALESCE(@BGK_USER_FLAG5, BGK_USER_FLAG5) --<BGK_USER_FLAG5, tinyint,>
    , BGK_USER_FLAG6 = COALESCE(@BGK_USER_FLAG6, BGK_USER_FLAG6) --<BGK_USER_FLAG6, tinyint,>
    , BGK_USER_FLAG7 = COALESCE(@BGK_USER_FLAG7, BGK_USER_FLAG7) --<BGK_USER_FLAG7, tinyint,>
    , BGK_USER_FLAG8 = COALESCE(@BGK_USER_FLAG8, BGK_USER_FLAG8) --<BGK_USER_FLAG8, tinyint,>
    , BGK_USER_FLAG9 = COALESCE(@BGK_USER_FLAG9, BGK_USER_FLAG9) --<BGK_USER_FLAG9, tinyint,>
    , BGK_USER_FLAG10= COALESCE(@BGK_USER_FLAG10, BGK_USER_FLAG10) --<BGK_USER_FLAG10, tinyint,>
    , BGK_USER_DATE1 = COALESCE(@BGK_USER_DATE1, BGK_USER_DATE1) --<BGK_USER_DATE1, datetime,>
    , BGK_USER_DATE2 = COALESCE(@BGK_USER_DATE2, BGK_USER_DATE2) --<BGK_USER_DATE2, datetime,>
    , BGK_USER_DATE3 = COALESCE(@BGK_USER_DATE3, BGK_USER_DATE3) --<BGK_USER_DATE3, datetime,>
    , BGK_USER_DATE4 = COALESCE(@BGK_USER_DATE4, BGK_USER_DATE4) --<BGK_USER_DATE4, datetime,>
    , BGK_USER_DATE5 = COALESCE(@BGK_USER_DATE5, BGK_USER_DATE5) --<BGK_USER_DATE5, datetime,>
    , BGK_USER_DATE6 = COALESCE(@BGK_USER_DATE6, BGK_USER_DATE6) --<BGK_USER_DATE6, datetime,>
    , BGK_USER_DATE7 = COALESCE(@BGK_USER_DATE7, BGK_USER_DATE7) --<BGK_USER_DATE7, datetime,>
    , BGK_USER_DATE8 = COALESCE(@BGK_USER_DATE8, BGK_USER_DATE8) --<BGK_USER_DATE8, datetime,>
    , BGK_USER_DATE9 = COALESCE(@BGK_USER_DATE9, BGK_USER_DATE9) --<BGK_USER_DATE9, datetime,>
    , BGK_USER_DATE10 = COALESCE(@BGK_USER_DATE10, BGK_USER_DATE10) --<BGK_USER_DATE10, datetime,>
    , BGK_USER_NOTES1 = COALESCE(@BGK_USER_NOTES1, BGK_USER_NOTES1) --<BGK_USER_NOTES1, varchar,>
    , BGK_USER_NOTES2 = COALESCE(@BGK_USER_NOTES2, BGK_USER_NOTES2) --<BGK_USER_NOTES2, varchar,>
    , BGK_USER_NOTES3 = COALESCE(@BGK_USER_NOTES3, BGK_USER_NOTES3) --<BGK_USER_NOTES3, varchar,>
    , BGK_USER_NOTES4 = COALESCE(@BGK_USER_NOTES4, BGK_USER_NOTES4) --<BGK_USER_NOTES4, varchar,>
    , BGK_USER_NOTES5 = COALESCE(@BGK_USER_NOTES5, BGK_USER_NOTES5) --<BGK_USER_NOTES5, varchar,>
    , BGK_USER_TIME1 = COALESCE(@BGK_USER_TIME1, BGK_USER_TIME1) --<BGK_USER_TIME1, datetime,>
    , BGK_USER_TIME2 = COALESCE(@BGK_USER_TIME2, BGK_USER_TIME2) --<BGK_USER_TIME2, datetime,>
    , BGK_USER_TIME3 = COALESCE(@BGK_USER_TIME3, BGK_USER_TIME3) --<BGK_USER_TIME3, datetime,>
    , BGK_USER_TIME4 = COALESCE(@BGK_USER_TIME4, BGK_USER_TIME4) --<BGK_USER_TIME4, datetime,>
    , BGK_USER_TIME5 = COALESCE(@BGK_USER_TIME5, BGK_USER_TIME5) --<BGK_USER_TIME5, datetime,>
    , BGK_REF = COALESCE(@BGK_REF, BGK_REF) --<BGK_REF, varchar(30),>
    , BGK_REF_LINK = COALESCE(@BGK_REF_LINK, BGK_REF_LINK) --<BGK_REF_LINK, varchar(30),>
    , BKG_DATASET = COALESCE(@BKG_DATASET, BKG_DATASET) --<BKG_DATASET, varchar(30),>
    , BKG_CURRENCY = COALESCE(@BKG_CURRENCY, BKG_CURRENCY) --<BKG_CURRENCY, varchar(4),>
    , BGK_USER_CHAR11 = COALESCE(@BGK_USER_CHAR11, BGK_USER_CHAR11) --<BGK_USER_CHAR11, varchar(30),>
    , BGK_USER_CHAR12 = COALESCE(@BGK_USER_CHAR12, BGK_USER_CHAR12) --<BGK_USER_CHAR12, varchar(30),>
    , BGK_USER_CHAR13 = COALESCE(@BGK_USER_CHAR13, BGK_USER_CHAR13) --<BGK_USER_CHAR13, varchar(30),>
    , BGK_USER_CHAR14 = COALESCE(@BGK_USER_CHAR14, BGK_USER_CHAR14) --<BGK_USER_CHAR14, varchar(30),>
    , BGK_USER_CHAR15 = COALESCE(@BGK_USER_CHAR15, BGK_USER_CHAR15) --<BGK_USER_CHAR15, varchar(30),>
    , BGK_USER_CHAR16 = COALESCE(@BGK_USER_CHAR16, BGK_USER_CHAR16) --<BGK_USER_CHAR16, varchar(30),>
    , BGK_USER_CHAR17 = COALESCE(@BGK_USER_CHAR17, BGK_USER_CHAR17) --<BGK_USER_CHAR17, varchar(30),>
    , BGK_USER_CHAR18 = COALESCE(@BGK_USER_CHAR18, BGK_USER_CHAR18) --<BGK_USER_CHAR18, varchar(30),>
    , BGK_USER_CHAR19 = COALESCE(@BGK_USER_CHAR19, BGK_USER_CHAR19) --<BGK_USER_CHAR19, varchar(30),>
    , BGK_USER_CHAR20 = COALESCE(@BGK_USER_CHAR20, BGK_USER_CHAR20) --<BGK_USER_CHAR20, varchar(30),>
    , BKG_SOW = COALESCE(@BKG_SOW, BKG_SOW) --<BKG_SOW, varchar(20),>
    , BKG_CANCELLED_BY = CASE 
            WHEN @BKG_STATUS = 4 THEN ISNULL(@BKG_USER,'')
            ELSE ''
           END --<BKG_CANCELLED_BY, varchar(4),>
    , BKG_SHADOW_DB = COALESCE(@BKG_SHADOW_DB, BKG_SHADOW_DB) --<BKG_SHADOW_DB, varchar(50),>
    , BKG_SHADOW_KEY = COALESCE(@BKG_SHADOW_KEY, BKG_SHADOW_KEY) --<BKG_SHADOW_KEY, float,>
    , BKG_SPLIT_PRIMARY = COALESCE(@BKG_SPLIT_PRIMARY, BKG_SPLIT_PRIMARY) --<BKG_SPLIT_PRIMARY, float,>
    , BKG_PREDECESSOR = COALESCE(@BKG_PREDECESSOR, BKG_PREDECESSOR) --<BKG_PREDECESSOR, float,>
    , BKG_HAS_SUCCESSORS = COALESCE(@BKG_HAS_SUCCESSORS, BKG_HAS_SUCCESSORS) --<BKG_HAS_SUCCESSORS, tinyint,>
    , BKG_LINK_TYPE = COALESCE(@BKG_LINK_TYPE, BKG_LINK_TYPE) --<BKG_LINK_TYPE, tinyint,>
    , BKG_SME_CALLTRAN = COALESCE(@BKG_SME_CALLTRAN, BKG_SME_CALLTRAN) --<BKG_SME_CALLTRAN, float,>
	, BKG_HALF_DAY = COALESCE(@BKG_HALF_DAY, BKG_HALF_DAY)
    WHERE BKG_PRIMARY = @BKG_PRIMARY
  
  IF @@ERROR <> 0
  BEGIN
   SELECT @ErrorStr = 'Falied to update TS_BOOKINGS'
   RAISERROR(@ErrorStr,16,1)
   ROLLBACK TRANSACTION TSBK_Update
   RETURN -1
  END
  
  DECLARE @BKRE_RESOURCE VARCHAR(16)
     , @BKRE_ROLE VARCHAR(16)
     , @BKRE_RATE FLOAT
     , @BKRE_DISCOUNT FLOAT
     , @BKRE_COST_PRICE FLOAT
  
  DECLARE BookingResource CURSOR STATIC FORWARD_ONLY FOR 
    SELECT BKRE_RESOURCE
      , BKRE_ROLE
      , BKRE_RATE
      , BKRE_DISCOUNT
      , BKRE_COST_PRICE 
       FROM TS_BOOKING_RESOURCES
       WHERE BKRE_BKG_PRIMARY = @BKG_PRIMARY
  
  OPEN BookingResource

  FETCH NEXT FROM BookingResource INTO 
   @BKRE_RESOURCE
    , @BKRE_ROLE
    , @BKRE_RATE
    , @BKRE_DISCOUNT
    , @BKRE_COST_PRICE

  WHILE @@FETCH_STATUS > -1
  BEGIN	
   EXECUTE @Return_Value = TSSP_INSERT_UPDATE_DELETE_TS_BOOKING_RESOURCES
        @Type = 1
      , @Action = 0
      , @BKRE_BKG_PRIMARY = @BKG_PRIMARY
      , @BKRE_RESOURCE = @BKRE_RESOURCE
      , @BKRE_DATE_START = @BKG_START
      , @BKRE_DATE_END = @BKRE_END_DATE
      , @BKRE_ROLE = @BKRE_ROLE
      , @BKRE_RATE = @BKRE_RATE
      , @BKRE_DISCOUNT = @BKRE_DISCOUNT
      , @BKRE_COST_PRICE = @BKRE_COST_PRICE
      , @ONLY_UPDATE_FOR_DATES = 0
	  , @BKRE_TSSWD_PRIMARY = @BKRE_TSSWD_PRIMARY
	  
   IF @Return_Value <> 0 
   BEGIN
    SELECT @ErrorStr = 'Falied to update TS_BOOKING_RESOURCES records for resource: ' + @BKG_RESOURCE
    RAISERROR(@ErrorStr,16,1)
	CLOSE BookingResource
	DEALLOCATE BookingResource
    ROLLBACK TRANSACTION TSBK_Update
    Return -1
   END
   
   FETCH NEXT FROM BookingResource INTO 
    @BKRE_RESOURCE
     , @BKRE_ROLE
     , @BKRE_RATE
     , @BKRE_DISCOUNT
     , @BKRE_COST_PRICE
  END 
  CLOSE BookingResource
  DEALLOCATE BookingResource
  
  COMMIT TRANSACTION
 
 END
END

ELSE IF @ACTION = 2
BEGIN
 /* Delete the record */
 IF @Type = 1
 BEGIN 
  BEGIN TRANSACTION TSBK_DELETE
  
  DELETE FROM TS_BOOKING_RESOURCES
  WHERE BKRE_BKG_PRIMARY = @BKG_PRIMARY
  
  IF @@ERROR <> 0
  BEGIN
   SELECT @ErrorStr = 'Falied to delete from TS_BOOKING_RESOURCES'
   RAISERROR(@ErrorStr,16,1)
   ROLLBACK TRANSACTION TSBK_DELETE
   RETURN -1
  END
  
  DELETE FROM TS_BOOKINGS
  WHERE BKG_PRIMARY = @BKG_PRIMARY
  
  IF @@ERROR <> 0
  BEGIN
   SELECT @ErrorStr = 'Falied to delete from TS_BOOKINGS'
   RAISERROR(@ErrorStr,16,1)
   ROLLBACK TRANSACTION TSBK_DELETE
   RETURN -1
  END
  
  COMMIT TRANSACTION
 END
END


--Manage History of Updation of Booking
IF @ACTION = 1

 BEGIN  
  BEGIN TRANSACTION TS_BOOKING_HISTORY_Insert

	DECLARE @BOOKING_HISTORY_PRIMARY FLOAT = 0,
			@History VARCHAR(MAX),
			@UserEmail VARCHAR(500),
		    @FullName VARCHAR(101);

	SELECT @UserEmail = TSU_EMAIL_ADDRESS 
    FROM TS_USERS 
    WHERE TSU_USERID = @BKG_USER

	IF @@ERROR <> 0
	BEGIN
	   SELECT @ErrorStr = 'Falied to retrieve user from TS_USERS'
	   RAISERROR(@ErrorStr,16,1)
	   ROLLBACK TRANSACTION TS_BOOKING_HISTORY_Insert
	   RETURN -1
	END

	SET @FullName = 
	CASE 
		WHEN CHARINDEX('.', @UserEmail) > 0 AND CHARINDEX('.', @UserEmail) < CHARINDEX('@', @UserEmail)
			THEN LEFT(@UserEmail, CHARINDEX('.', @UserEmail) - 1) 
				 + ' ' + 
				 SUBSTRING(
					 @UserEmail,
					 CHARINDEX('.', @UserEmail) + 1,
					 CHARINDEX('@', @UserEmail) - CHARINDEX('.', @UserEmail) - 1
				 )
		ELSE LEFT(@UserEmail, CHARINDEX('@', @UserEmail) - 1)
	END

	SET @History = '<table style="width:100%; line-height: 24px" cellspacing="4"> <tr><td>From Excel booking updater by: ' + @FullName + '</td></tr> <tr><td> <b>Changed on:  </b> ' +  CONVERT(VARCHAR, GETDATE(), 120) + '</td></tr> '
	
	IF @BKG_STATUS IS NOT NULL AND @OriginalStatus <> @BKG_STATUS
		BEGIN

		DECLARE @StatusComputed VARCHAR(20)
		DECLARE @OriginalStatusComputed VARCHAR(20)

		SET @StatusComputed = 
			CASE @BKG_STATUS
				WHEN 0 THEN 'Pending'
				WHEN 1 THEN 'Submitted'
				WHEN 2 THEN 'Approved'
				WHEN 3 THEN 'Rejected'
				WHEN 4 THEN 'Cancelled'
				WHEN 5 THEN 'Confirmed'
				WHEN 6 THEN 'Completed'
				WHEN 7 THEN 'Invoiced'
				ELSE 'Unknown'
			END

		SET @OriginalStatusComputed = 
			CASE @OriginalStatus
				WHEN 0 THEN 'Pending'
				WHEN 1 THEN 'Submitted'
				WHEN 2 THEN 'Approved'
				WHEN 3 THEN 'Rejected'
				WHEN 4 THEN 'Cancelled'
				WHEN 5 THEN 'Confirmed'
				WHEN 6 THEN 'Completed'
				WHEN 7 THEN 'Invoiced'
				ELSE 'Unknown'
			END

			SET @History = @History + '<tr><td> <b>Field: </b> Status &nbsp;&nbsp;<b>Original:</b>' + @OriginalStatusComputed + '&nbsp;&nbsp;<b>New: </b> ' + @StatusComputed + '&nbsp;&nbsp;</td></tr>'
	END

	IF @BKG_DESCRIPTION IS NOT NULL AND @OriginalDescription <> @BKG_DESCRIPTION
	BEGIN
		SET @History = @History + '<tr><td> <b>Field: </b> Description ' +
		 (CASE WHEN ISNULL(@OriginalDescription, '') <> ''
				 THEN '&nbsp;&nbsp;<b>Original:</b> ' + @OriginalDescription
				 ELSE ''
			END) + 
			'&nbsp;&nbsp;<b>New: </b> ' + @BKG_DESCRIPTION + '&nbsp;&nbsp;</td></tr>'
	END

	IF @BKG_START IS NOT NULL AND @OriginalStart <> @BKG_START
	BEGIN
		SET @History = @History + '<tr><td> <b>Field: </b> Start ' +
		 (CASE WHEN ISNULL(@OriginalStart, '') <> ''
				 THEN '&nbsp;&nbsp;<b>Original:</b> ' + CONVERT(VARCHAR, @OriginalStart, 120)
				 ELSE ''
			END) +
			'&nbsp;&nbsp;<b>New: </b> ' + CONVERT(VARCHAR, @BKG_START, 120) + '&nbsp;&nbsp;</td></tr>'
	END

	IF @BKG_END IS NOT NULL AND @OriginalEnd <> @BKG_END
	BEGIN
		SET @History = @History + '<tr><td> <b>Field: </b> End ' +
		(CASE WHEN ISNULL(@OriginalEnd, '') <> ''
				 THEN '&nbsp;&nbsp;<b>Original:</b> ' + CONVERT(VARCHAR, @OriginalEnd, 120)
				 ELSE ''
			END) +
			 '&nbsp;&nbsp;<b>New: </b> ' + CONVERT(VARCHAR, @BKG_END, 120) + '&nbsp;&nbsp;</td></tr>'
	END

	IF @BKG_Role IS NOT NULL AND @OriginalRole <> @BKG_Role
	BEGIN
		SET @History = @History + '<tr><td> <b>Field: </b> Role ' +
		 (CASE WHEN ISNULL(@OriginalRole, '') <> ''
				 THEN '&nbsp;&nbsp;<b>Original:</b> ' + @OriginalRole
				 ELSE ''
			END) + 
			'&nbsp;&nbsp;<b>New: </b> ' + @BKG_Role + '&nbsp;&nbsp;</td></tr>'
	END

	IF @BKG_DETAIL IS NOT NULL AND @OriginalDetail <> @BKG_DETAIL
	BEGIN
		SET @History = @History + '<tr><td> <b>Field: </b> Detail ' +
		 (CASE WHEN ISNULL(@OriginalDetail, '') <> ''
				 THEN '&nbsp;&nbsp;<b>Original:</b> ' + @OriginalDetail
				 ELSE ''
			END) +  
			'&nbsp;&nbsp;<b>New: </b> ' + @BKG_DETAIL + '&nbsp;&nbsp;</td></tr>'
	END

	IF @BKG_LOCATION IS NOT NULL AND @OriginalLocation <> @BKG_LOCATION
	BEGIN
		SET @History = @History + '<tr><td> <b>Field: </b> Location ' +
		 (CASE WHEN ISNULL(@OriginalLocation, '') <> ''
				 THEN '&nbsp;&nbsp;<b>Original:</b> ' + @OriginalLocation
				 ELSE ''
			END) +  
			'&nbsp;&nbsp;<b>New: </b> ' + @BKG_LOCATION + '&nbsp;&nbsp;</td></tr>'
	END

	IF @BKG_OFFSITE IS NOT NULL AND @OriginalOffsite <> @BKG_OFFSITE
	BEGIN
		SET @History = @History + '<tr><td> <b>Field: </b> Offsite ' +
		 (CASE WHEN ISNULL(@OriginalOffsite, '') <> ''
				 THEN '&nbsp;&nbsp;<b>Original:</b> ' + @OriginalOffsite
				 ELSE ''
			END) +  
			'&nbsp;&nbsp;<b>New: </b> ' + @BKG_OFFSITE + '&nbsp;&nbsp;</td></tr>'
	END

	IF @BKG_SOW IS NOT NULL AND @OriginalSOW <> @BKG_SOW
	BEGIN
		SET @History = @History + '<tr><td> <b>Field: </b> SOW ' +
		 (CASE WHEN ISNULL(@OriginalSOW, '') <> ''
				 THEN '&nbsp;&nbsp;<b>Original:</b> ' + @OriginalSOW
				 ELSE ''
			END) +  
			'&nbsp;&nbsp;<b>New: </b> ' + @BKG_SOW + '&nbsp;&nbsp;</td></tr>'
	END

	IF @BKG_PRODUCT IS NOT NULL AND @OriginalPRODUCT <> @BKG_PRODUCT
	BEGIN
		SET @History = @History + '<tr><td> <b>Field: </b> Product ' +
		 (CASE WHEN ISNULL(@OriginalPRODUCT, '') <> ''
				 THEN '&nbsp;&nbsp;<b>Original:</b> ' + @OriginalPRODUCT
				 ELSE ''
			END) +  
			'&nbsp;&nbsp;<b>New: </b> ' + @BKG_PRODUCT + '&nbsp;&nbsp;</td></tr>'
	END

	IF @BKG_CONTACT IS NOT NULL AND @OriginalCONTACT <> @BKG_CONTACT
	BEGIN
		SET @History = @History + '<tr><td> <b>Field: </b> Contact ' +
		 (CASE WHEN ISNULL(@OriginalCONTACT, '') <> ''
				 THEN '&nbsp;&nbsp;<b>Original:</b> ' + @OriginalCONTACT
				 ELSE ''
			END) +  
			'&nbsp;&nbsp;<b>New: </b> ' + @BKG_CONTACT + '&nbsp;&nbsp;</td></tr>'
	END

	IF @BKG_EMAIL IS NOT NULL AND @OriginalEMAIL <> @BKG_EMAIL
	BEGIN
		SET @History = @History + '<tr><td> <b>Field: </b> Email ' +
		 (CASE WHEN ISNULL(@OriginalEMAIL, '') <> ''
				 THEN '&nbsp;&nbsp;<b>Original:</b> ' + @OriginalEMAIL
				 ELSE ''
			END) +  
			'&nbsp;&nbsp;<b>New: </b> ' + @BKG_EMAIL + '&nbsp;&nbsp;</td></tr>'
	END

	IF @BKG_NOTES IS NOT NULL AND @OriginalNotes <> @BKG_NOTES
	BEGIN
		SET @History = @History + '<tr><td> <b>Field: </b> Notes ' +
		 (CASE WHEN ISNULL(@OriginalNotes, '') <> ''
				 THEN '&nbsp;&nbsp;<b>Original:</b> ' + @OriginalNotes
				 ELSE ''
			END) +  
			'&nbsp;&nbsp;<b>New: </b> ' + @BKG_NOTES + '&nbsp;&nbsp;</td></tr>'
	END

	SET @History = @History + '</table>'

	-- Get the highest primary key
	EXEC [dbo].[tssp_get_sequence] 
			@ParTableCode = 'TS_BOOKING_HISTORY',  
			@ParSequence = @BOOKING_HISTORY_PRIMARY OUTPUT, 
			@ParIncrement = 1; 

	IF @@ERROR <> 0
	  BEGIN
	   SELECT @ErrorStr = 'Failed to execute [tssp_get_sequence] stored procedure'
	   RAISERROR(@ErrorStr,16,1)
	   ROLLBACK TRANSACTION TS_BOOKING_HISTORY_Insert
	   RETURN -1
	END

	INSERT INTO TS_BOOKING_HISTORY (TSBKH_PRIMARY, TSBKH_BKG_PRIMARY, TSBKH_USER_ID, TSBKH_USER_NOTES, TSBKH_INSERTED_DATE)
	VALUES (@BOOKING_HISTORY_PRIMARY, @BKG_PRIMARY, @BKG_USER, @History, getdate())
	
	IF @@ERROR <> 0
	  BEGIN
	   SELECT @ErrorStr = 'Failed to insert into TS_BOOKING_HISTORY'
	   RAISERROR(@ErrorStr,16,1)
	   ROLLBACK TRANSACTION TS_BOOKING_HISTORY_Insert
	   RETURN -1
	END

  COMMIT TRANSACTION
 END
GO


USE [ACCOUNTS]
GO

/****** Object:  StoredProcedure [dbo].[TSSP_INSERT_UPDATE_DELETE_TS_BOOKING_RESOURCES]    Script Date: 23/11/2025 17:21:14 ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

ALTER   PROC [dbo].[TSSP_INSERT_UPDATE_DELETE_TS_BOOKING_RESOURCES]
/* 
==========================================================================================
V1: Amit Patel 17/09/2012 - Created to insert, update or delete the Booking Resource- 4.6.00
V2: Nikhil Bhavani 09/03/2023 - Add TSSWD PRIMARY as parameter for update into TS_BOOKING_RESOURCES
==========================================================================================
*/
   @Type      TINYINT   = 1  /* 0 = Validate Only, 1= Validate and Post */
 , @ACTION     TINYINT   = NULL /* Null = MixMode, 0 = Insert, 1 = Delete */  
 , @BKRE_BKG_PRIMARY   FLOAT     /* Primary for the booking resource row */
 , @BKRE_RESOURCE   VARCHAR(16)    /* Booking resource code */
 , @BKRE_DATE_START   DATETIME    /* The start date of the booking resource */
 , @BKRE_DATE_END   DATETIME    /* The end date of the booking resource */
 , @BKRE_ROLE    VARCHAR(20)  = '' /* The role of the booking resource record */
 , @BKRE_RATE    FLOAT   = 0  /* The rate for the booking resource record */
 , @BKRE_DISCOUNT   FLOAT   = 0  /* The discount for the booking resource record */
 , @BKRE_COST_PRICE   FLOAT   = 0  /* The cost price of the booking resource record */
 , @ONLY_UPDATE_FOR_DATES    TINYINT   = 0  /* 0 = Re-Create resource for selected dates, 1 = Update resource for selected dates*/
 , @BKRE_TSSWD_PRIMARY    FLOAT   = 0   /* Primary key for the PROJECT SOW DETAIL */
AS

DECLARE @ErrorStr VARCHAR(1000)
   , @Return_Value INT
   , @BKRE_PRIMARY FLOAT
   , @BKRE_DATE DATETIME 
   , @BKG_RECORD_COUNT INT 
   , @BKG_START DATETIME
   , @BKG_END DATETIME 
   , @BKG_PROJECT VARCHAR(10) 
   , @WORKING_DAYS_PROFILE VARCHAR(7)
   , @TSU_USERID VARCHAR(4)
   , @RESOURCE_START_DATE DATETIME
   , @RESOURCE_END_DATE DATETIME 

SET DATEFIRST 1

SET @BKRE_PRIMARY = 0

/* Validate BKRE_DATE_START */
IF ISNULL(@BKRE_DATE_START,'') = ''
BEGIN
 SELECT @ErrorStr = 'Please supply @BKRE_DATE_START parameter'
 RAISERROR(@ErrorStr,16,1)
 Return -1
END

/* Validate BKRE_DATE_END */
IF ISNULL(@BKRE_DATE_END,'') = ''
BEGIN
 SELECT @ErrorStr = 'Please supply @BKRE_DATE_END parameter'
 RAISERROR(@ErrorStr,16,1)
 Return -1
END

SELECT @BKG_START = CAST(CONVERT(VARCHAR,BKG_START,106) AS DATETIME)
   , @BKG_END = CAST(CONVERT(VARCHAR,BKG_END,106) AS DATETIME)
  , @BKG_PROJECT = BKG_PROJECT
FROM TS_BOOKINGS
WHERE BKG_PRIMARY = @BKRE_BKG_PRIMARY

/* Validate BKRE_DATE_START and BKRE_DATE_END dates */
IF @BKRE_DATE_END < @BKRE_DATE_START
BEGIN
 SELECT @ErrorStr = '@BKRE_DATE_END date can not be less than @BKRE_DATE_START'
 RAISERROR(@ErrorStr,16,1)
 Return -1
END

IF CAST(CONVERT(VARCHAR,@BKRE_DATE_START,106) AS DATETIME) < @BKG_START OR CAST(CONVERT(VARCHAR,@BKRE_DATE_END,106) AS DATETIME) > @BKG_END
BEGIN
 SELECT @ErrorStr = '@BKRE_DATE_START date and @BKRE_DATE_END date must fall between @BKG_START and @BKG_END of the booking resoure'
 RAISERROR(@ErrorStr,16,1)
 Return -1
END

/* Check if @BKRE_RESOURCE is null or empty string */
IF ISNULL(@BKRE_RESOURCE,'') = ''
BEGIN
 SELECT @ErrorStr = 'Please supply @BKRE_RESOURCE parameter'
 RAISERROR(@ErrorStr,16,1)
 Return -1
END

/* Validate @BKRE_RESOURCE */
IF NOT EXISTS (SELECT PRCODE 
      FROM PRC_PRICE_RECS 
      WHERE PRC_PRICE_RECS.PR_TYPE = 'R'
     AND PRCODE = @BKRE_RESOURCE)
BEGIN
 SELECT @ErrorStr = 'The @BKRE_RESOURCE supplied does not exist in the PRC_PRICE_RECS'
 RAISERROR(@ErrorStr,16,1)
 Return -1
END

/* Validate dates with users working day profile and bankholidays */
SELECT @TSU_USERID = TSU_USERID
  , @WORKING_DAYS_PROFILE = TSU_WORKING_DAYS_PROFILE
FROM TS_USERS 
 INNER JOIN PRC_PRICE_RECS
  ON PRCODE = TSU_RESOURCE_LINK
WHERE PRCODE = @BKRE_RESOURCE

IF ISNULL(@WORKING_DAYS_PROFILE,'') = ''
BEGIN
 SELECT @WORKING_DAYS_PROFILE = TSO_WORKING_DAYS_PROFILE 
 FROM TS_OPTIONS
END

IF (SELECT TSBK_OBEY_WP 
 FROM TS_BOOKING_TYPES
  INNER JOIN TS_BOOKINGS
   ON TS_BOOKING_TYPES.TSBK_CODE = TS_BOOKINGS.BKG_TYPE
 WHERE BKG_PRIMARY = @BKRE_BKG_PRIMARY) = 1
BEGIN
 SET @BKRE_DATE = @BKRE_DATE_START
 WHILE (@BKRE_DATE <= @BKRE_DATE_END)
 BEGIN  
  IF EXISTS (SELECT TNWD_DATE 
       FROM TS_NON_WORK_DAYS 
       WHERE TNWD_DATE = @BKRE_DATE
      AND TNWD_USER_ID = @TSU_USERID)
  BEGIN
   SELECT @ErrorStr = CONVERT(VARCHAR,@BKRE_DATE,103)+ ' is a Bank/Company Holiday'
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
  
  IF (SUBSTRING(@WORKING_DAYS_PROFILE,DATEPART(dw,@BKRE_DATE),1) = 0)
  BEGIN
   SELECT @ErrorStr = CONVERT(VARCHAR,@BKRE_DATE,103) + ' is a Non Working Day for ' + @TSU_USERID
   RAISERROR(@ErrorStr,16,1)
   RETURN -1
  END
  
  SET @BKRE_DATE = DATEADD(dd,1,@BKRE_DATE)
 END
END

/* Validate start and end times for hired resources*/
SELECT @RESOURCE_START_DATE = _STARTDATE
  , @RESOURCE_START_DATE = _ENDDATE  
FROM TS_RESOURCE_DATES 
WHERE __CODE = @BKRE_RESOURCE

IF ISNULL(@RESOURCE_START_DATE,'') <> '' AND ISNULL(@RESOURCE_END_DATE,'') <> ''
BEGIN
 IF @BKRE_DATE_START < @RESOURCE_START_DATE OR @BKRE_DATE_END > @RESOURCE_END_DATE
 BEGIN
  SELECT @ErrorStr = 'The resource ' + @BKRE_RESOURCE + ' cannot be scheduled for the dates supplied'
  RAISERROR(@ErrorStr,16,1)
  Return -1
 END
END

/* Validate @BKRE_ROLE */
IF ISNULL(@BKRE_ROLE,'')=''
BEGIN
 SELECT @BKRE_ROLE = ISNULL(TSU_DEFAULT_ROLE ,'')
 FROM TS_USERS
  INNER JOIN PRC_PRICE_RECS
   ON PRC_PRICE_RECS.PRCODE = TS_USERS.TSU_RESOURCE_LINK
 WHERE PRCODE = @BKRE_RESOURCE
 
 IF ISNULL(@BKRE_ROLE,'')=''
 BEGIN
  SET @BKRE_RATE = 0
  SET @BKRE_COST_PRICE = 0
 END
END

IF ISNULL(@BKRE_ROLE,'')<>''
BEGIN
 IF NOT EXISTS (SELECT TSR_CODE 
       FROM TS_ROLES 
       WHERE TSR_CODE = @BKRE_ROLE
      AND TSR_USE_ON_RES_PLAN_AND_JC = 1 
      AND TSR_INACTIVE = 0)
 BEGIN
  SELECT @ErrorStr = 'The @BKRE_ROLE supplied does not exist in the TS_ROLES'
  RAISERROR(@ErrorStr,16,1)
  Return -1
 END
END

/* Get Role Rate if not supplied */
IF @ACTION <> 1 AND (@BKRE_RATE IS NULL OR @BKRE_COST_PRICE IS NULL)
BEGIN
 DECLARE @USEHOURLYRATES TINYINT
      , @SHADOWPROJECT VARCHAR(20)
      , @SQL   nvarchar(1000)
      , @DAILYRATE FLOAT
      , @HOURLYRATE FLOAT
      , @CURRDB VARCHAR(20)
      , @PR_CRDT_ID FLOAT
      , @CR_CRDT_ID FLOAT
      , @TSO_JC_DATE_SENS_CON_RATES TINYINT
      , @HOURLYCOST FLOAT
      , @DAILYCOST FLOAT
      , @RECCOUNT FLOAT
      
    SELECT @TSO_JC_DATE_SENS_CON_RATES = TSO_JC_DATE_SENS_CON_RATES 
 FROM TS_OPTIONS2
 
    SET @PR_CRDT_ID = 0
    SET @CR_CRDT_ID = 0

 SELECT @USEHOURLYRATES = TSBK_HOURLY_RATES
 FROM TS_BOOKING_TYPES
  INNER JOIN TS_BOOKINGS
   ON TS_BOOKING_TYPES.TSBK_CODE = TS_BOOKINGS.BKG_TYPE
 WHERE TS_BOOKINGS.BKG_PRIMARY = @BKRE_BKG_PRIMARY
 
 SELECT @SHADOWPROJECT = ISNULL(CH_USER5,'') 
 FROM CST_COSTHEADER 
  INNER JOIN TS_BOOKINGS
   ON CST_COSTHEADER.CH_CODE = TS_BOOKINGS.BKG_PROJECT
  LEFT JOIN CST_COSTHEADER2 
   ON CH_PRIMARY = CH_PRIMARY_2 
 WHERE CH_USER6 = 'SHADOW'

 IF ISNULL(@SHADOWPROJECT,'') = ''
 BEGIN
  SELECT @SHADOWPROJECT = DB_NAME()
 END
 
 IF @TSO_JC_DATE_SENS_CON_RATES = 1
 BEGIN
  SELECT @SQL = 'SELECT TOP 1 @CRDT_PRIMARY = ISNULL(CRDT_PRIMARY,0) 
        FROM '+ @SHADOWPROJECT + '.dbo.TS_CONTRACT_DATES
        WHERE CRDT_PROJECT = @ProjectCode 
       AND CRDT_DATE_EFFECTIVE <= @CRDT_DATE_EFFECTIVE 
       AND CRDT_ACTIVE = 1
        ORDER BY CRDT_DATE_EFFECTIVE DESC, 
        CRDT_PRIMARY DESC'
         
  EXEC sp_executesql @SQL, 
   N'@ProjectCode VARCHAR(20), @CRDT_DATE_EFFECTIVE DATETIME, @CRDT_PRIMARY FLOAT OUTPUT', 
   @ProjectCode = @BKG_PROJECT,
   @CRDT_DATE_EFFECTIVE = @BKG_START,
   @CRDT_PRIMARY = @PR_CRDT_ID OUTPUT
  
  SELECT @SQL ='SELECT TOP 1 @CRDT_PRIMARY = ISNULL(CRDT_PRIMARY,0) 
       FROM '+ @SHADOWPROJECT + '.dbo.TS_CONTRACT_DATES
       WHERE CRDT_CUCODE = (SELECT CH_ACCOUNT FROM CST_COSTHEADER WHERE CH_CODE = @ProjectCode) 
      AND CRDT_DATE_EFFECTIVE <= @CRDT_DATE_EFFECTIVE 
      AND CRDT_ACTIVE = 1
       ORDER BY CRDT_DATE_EFFECTIVE DESC, 
          CRDT_PRIMARY DESC'
         
  EXEC sp_executesql @SQL, 
   N'@ProjectCode VARCHAR(20), @CRDT_DATE_EFFECTIVE DATETIME, @CRDT_PRIMARY FLOAT OUTPUT', 
   @ProjectCode = @BKG_PROJECT,
   @CRDT_DATE_EFFECTIVE = @BKG_START,
   @CRDT_PRIMARY = @CR_CRDT_ID OUTPUT  
 END
 
 IF @BKRE_RATE IS NULL
 BEGIN
  IF (SELECT TSBK_OVERRIDE_RATE
   FROM TS_BOOKING_TYPES
    INNER JOIN TS_BOOKINGS
     ON TS_BOOKING_TYPES.TSBK_CODE = TS_BOOKINGS.BKG_TYPE
   WHERE TS_BOOKINGS.BKG_PRIMARY = @BKRE_BKG_PRIMARY) = 1
  BEGIN
   SELECT @BKRE_RATE = ISNULL(TSBK_RATE,0)
   FROM TS_BOOKING_TYPES
    INNER JOIN TS_BOOKINGS
     ON TS_BOOKING_TYPES.TSBK_CODE = TS_BOOKINGS.BKG_TYPE
   WHERE TS_BOOKINGS.BKG_PRIMARY = @BKRE_BKG_PRIMARY
  END
  ELSE BEGIN
   IF (SELECT LEN(BKG_SOW) 
    FROM TS_BOOKINGS 
    WHERE BKG_PRIMARY = @BKRE_BKG_PRIMARY)>0
   BEGIN
    SELECT @SQL = 'SELECT @BKRE_RATE = TSSWD_ROLE_RATE
          FROM '+ @SHADOWPROJECT + '.dbo.TS_PROJECT_SOW_DETAIL '
       + 'WHERE TSSWD_ROLE_CODE = @RoleCode'
          
    EXEC sp_executesql @SQL, 
     N'@RoleCode VARCHAR(20), @BKRE_RATE FLOAT OUTPUT', 
     @RoleCode = @BKRE_ROLE,
     @BKRE_RATE = @BKRE_RATE OUTPUT
   END
   ELSE IF LEN(ISNULL(@BKG_PROJECT,''))> 0
   BEGIN
    SELECT @SQL = 'SELECT @RECCOUNT = ISNULL(COUNT(TSR_CODE),0)
          FROM '+ @SHADOWPROJECT + '.dbo.TS_PROJECT_DAYS 
            INNER JOIN '+ @SHADOWPROJECT + '.dbo.TS_ROLES
           ON TSR_PRIMARY = PJD_TSR_PRIMARY 
            INNER JOIN '+ @SHADOWPROJECT + '.dbo.TS_PROJECTS
           ON TSPR_PRIMARY = PJD_TSPR_PRIMARY '
        + 'WHERE TSR_CODE = @RoleCode
          AND TSPR_CODE = @ProjectCode'
          
    EXEC sp_executesql @SQL, 
     N'@RoleCode VARCHAR(20), @ProjectCode VARCHAR(20), @RECCOUNT FLOAT OUTPUT', 
     @RoleCode = @BKRE_ROLE,
     @ProjectCode = @BKG_PROJECT,
     @RECCOUNT = @RECCOUNT OUTPUT
    
    
    
    IF (@RECCOUNT > 0)
    BEGIN 
     SELECT @SQL = 'SELECT @BKRE_RATE = PJD_RATE
           FROM '+ @SHADOWPROJECT + '.dbo.TS_PROJECT_DAYS 
            INNER JOIN '+ @SHADOWPROJECT + '.dbo.TS_ROLES
           ON TSR_PRIMARY = PJD_TSR_PRIMARY 
            INNER JOIN '+ @SHADOWPROJECT + '.dbo.TS_PROJECTS
           ON TSPR_PRIMARY = PJD_TSPR_PRIMARY '
        + 'WHERE TSR_CODE = @RoleCode
          AND TSPR_CODE = @ProjectCode'
           
     EXEC sp_executesql @SQL, 
      N'@RoleCode VARCHAR(20), @ProjectCode VARCHAR(20), @BKRE_RATE FLOAT OUTPUT', 
      @RoleCode = @BKRE_ROLE,
      @ProjectCode = @BKG_PROJECT,
      @BKRE_RATE = @BKRE_RATE OUTPUT
    END
    ELSE BEGIN
        
     SELECT @SQL = 'SELECT @RECCOUNT = ISNULL(COUNT(CON_PRIMARY),0)
           FROM '+ @SHADOWPROJECT + '.dbo.TS_CONTRACTS
           WHERE CON_TYPE = ''PROJECT'' AND CON_CODE = @ProjectCode
          AND ISNULL(CON_CRDT_PRIMARY,0) = @CRDT_PRIMARY'
            
     EXEC sp_executesql @SQL, 
      N'@ProjectCode VARCHAR(20), @CRDT_PRIMARY FLOAT, @RECCOUNT FLOAT OUTPUT', 
      @ProjectCode = @BKG_PROJECT,
      @CRDT_PRIMARY = @PR_CRDT_ID,
      @RECCOUNT = @RECCOUNT OUTPUT
     
     IF (@RECCOUNT > 0)
     BEGIN
      SELECT @SQL = 'SELECT TOP 1 @HourlyRate = CON_SELL_PRICE
           , @Rate = CON_SELL_PRICE_DAILY
            FROM '+ @SHADOWPROJECT + '.dbo.TS_CONTRACTS
            WHERE CON_TYPE = ''PROJECT'' AND CON_CODE = @ProjectCode
           AND ISNULL(CON_CRDT_PRIMARY,0) = @CRDT_PRIMARY'
              
      EXEC sp_executesql @SQL, 
       N'@ProjectCode VARCHAR(20), @CRDT_PRIMARY FLOAT, @Rate FLOAT OUTPUT, @HourlyRate FLOAT OUTPUT', 
       @ProjectCode = @BKG_PROJECT,
       @CRDT_PRIMARY = @PR_CRDT_ID,
       @Rate = @DAILYRATE OUTPUT,
       @HourlyRate = @HOURLYRATE OUTPUT

     END
     ELSE BEGIN
      
      SELECT @SQL = 'SELECT @RECCOUNT = ISNULL(COUNT(CON_PRIMARY),0)
            FROM '+ @SHADOWPROJECT + '.dbo.TS_CONTRACTS
            WHERE CON_TYPE = ''ROLECUST'' 
           AND CON_CODE = (SELECT CH_ACCOUNT FROM CST_COSTHEADER WHERE CH_CODE = @ProjectCode)
           AND ISNULL(CON_CRDT_PRIMARY,0) = @CRDT_PRIMARY'
              
      EXEC sp_executesql @SQL, 
       N'@ProjectCode VARCHAR(20), @CRDT_PRIMARY FLOAT, @RECCOUNT FLOAT OUTPUT', 
       @ProjectCode = @BKG_PROJECT,
       @CRDT_PRIMARY = @CR_CRDT_ID,
       @RECCOUNT = @RECCOUNT OUTPUT
      
      IF (@RECCOUNT > 0)
      BEGIN
       SELECT @SQL = 'SELECT TOP 1 @HourlyRate = CON_SELL_PRICE
            , @Rate = CON_SELL_PRICE_DAILY
             FROM  '+ @SHADOWPROJECT + '.dbo.TS_CONTRACTS
             WHERE CON_TYPE = ''ROLECUST'' 
            AND CON_CODE = (SELECT CH_ACCOUNT FROM CST_COSTHEADER WHERE CH_CODE = @ProjectCode)
            AND ISNULL(CON_CRDT_PRIMARY,0) = @CRDT_PRIMARY'
              
       EXEC sp_executesql @SQL, 
       N'@ProjectCode VARCHAR(20), @CRDT_PRIMARY FLOAT, @Rate FLOAT OUTPUT, @HourlyRate FLOAT OUTPUT', 
       @ProjectCode = @BKG_PROJECT,
       @CRDT_PRIMARY = @CR_CRDT_ID,
       @Rate = @DAILYRATE OUTPUT,
       @HourlyRate = @HOURLYRATE OUTPUT
       
      END
      ELSE BEGIN
       SELECT @SQL = 'SELECT @Rate = TSR_SELL_PRICE_DAILY'
          + '  , @HourlyRate = TSR_SELL_PRICE '
          + 'FROM  '+ @SHADOWPROJECT + '.dbo.TS_ROLES '
          + 'WHERE TSR_CODE = @RoleCode'
          
       EXEC sp_executesql @SQL, 
        N'@RoleCode VARCHAR(20), @Rate FLOAT OUTPUT, @HourlyRate FLOAT OUTPUT', 
        @RoleCode = @BKRE_ROLE,
        @Rate = @DAILYRATE OUTPUT,
        @HourlyRate = @HOURLYRATE OUTPUT
       
      END
     END
        
     IF @USEHOURLYRATES = 1
     BEGIN
      SET @BKRE_RATE = @HOURLYRATE
     END
     ELSE BEGIN
      SET @BKRE_RATE = @DAILYRATE
     END
    END
   END  
  END
 END 
  
 IF @BKRE_COST_PRICE IS NULL
 BEGIN
    
  SELECT @SQL = 'SELECT @RECCOUNT = ISNULL(COUNT(CON_PRIMARY),0)
        FROM  '+ @SHADOWPROJECT + '.dbo.TS_CONTRACTS
        WHERE CON_TYPE = ''PROJECT'' AND CON_CODE = @ProjectCode
          AND ISNULL(CON_CRDT_PRIMARY,0) = @CRDT_PRIMARY'
          
  EXEC sp_executesql @SQL, 
   N'@ProjectCode VARCHAR(20), @CRDT_PRIMARY FLOAT, @RECCOUNT FLOAT OUTPUT',
   @ProjectCode = @BKG_PROJECT,
   @CRDT_PRIMARY = @PR_CRDT_ID,
   @RECCOUNT = @RECCOUNT OUTPUT
  
  IF (@RECCOUNT > 0)
  BEGIN
  
   SELECT @SQL = 'SELECT TOP 1 @HourlyCost = CON_COST_PRICE
        , @Cost = CON_COST_PRICE_DAILY
         FROM  '+ @SHADOWPROJECT + '.dbo.TS_CONTRACTS
         WHERE CON_TYPE = ''PROJECT'' AND CON_CODE = @ProjectCode
           AND ISNULL(CON_CRDT_PRIMARY,0) = @CRDT_PRIMARY'
           
   EXEC sp_executesql @SQL, 
    N'@ProjectCode VARCHAR(20), @CRDT_PRIMARY FLOAT, @Cost FLOAT OUTPUT, @HourlyCost FLOAT OUTPUT', 
    @ProjectCode = @BKG_PROJECT,
    @CRDT_PRIMARY = @PR_CRDT_ID,
    @Cost = @DAILYCOST OUTPUT,
    @HourlyCost = @HOURLYCOST OUTPUT
  END
  ELSE BEGIN
   
   SELECT @SQL = 'SELECT @RECCOUNT = ISNULL(COUNT(CON_PRIMARY),0)
         FROM  '+ @SHADOWPROJECT + '.dbo.TS_CONTRACTS
         WHERE CON_TYPE = ''ROLECUST'' 
           AND CON_CODE = (SELECT CH_ACCOUNT FROM CST_COSTHEADER WHERE CH_CODE = @ProjectCode)
           AND ISNULL(CON_CRDT_PRIMARY,0) = @CRDT_PRIMARY'
           
   EXEC sp_executesql @SQL, 
    N'@ProjectCode VARCHAR(20), @CRDT_PRIMARY FLOAT, @RECCOUNT FLOAT OUTPUT',
    @ProjectCode = @BKG_PROJECT,
    @CRDT_PRIMARY = @CR_CRDT_ID,
    @RECCOUNT = @RECCOUNT OUTPUT
   
   IF (@RECCOUNT > 0)
   BEGIN
    SELECT @SQL = 'SELECT TOP 1 @HourlyCost = CON_COST_PRICE
         , @Cost = CON_COST_PRICE_DAILY
          FROM  '+ @SHADOWPROJECT + '.dbo.TS_CONTRACTS
          WHERE CON_TYPE = ''ROLECUST'' 
         AND CON_CODE = (SELECT CH_ACCOUNT FROM CST_COSTHEADER WHERE CH_CODE = @ProjectCode)
         AND ISNULL(CON_CRDT_PRIMARY,0) = @CRDT_PRIMARY'
           
    EXEC sp_executesql @SQL, 
    N'@ProjectCode VARCHAR(20), @CRDT_PRIMARY FLOAT, @Cost FLOAT OUTPUT, @HourlyCost FLOAT OUTPUT', 
    @ProjectCode = @BKG_PROJECT,
    @CRDT_PRIMARY = @CR_CRDT_ID,
    @Cost = @DAILYCOST OUTPUT,
    @HourlyCost = @HOURLYCOST OUTPUT
   END
   ELSE BEGIN
    
    SELECT @SQL = 'SELECT @Cost = TSR_COST_PRICE_DAILY'
       + '  , @HourlyCost = TSR_COST_PRICE '
       + 'FROM  '+ @SHADOWPROJECT + '.dbo.TS_ROLES '
       + 'WHERE TSR_CODE = @RoleCode'
       
    EXEC sp_executesql @SQL, 
     N'@RoleCode VARCHAR(20), @Cost FLOAT OUTPUT, @HourlyCost FLOAT OUTPUT', 
     @RoleCode = @BKRE_ROLE,
     @Cost = @DAILYCOST OUTPUT,
     @HourlyCost = @HOURLYCOST OUTPUT
    
   END
  END
  
  IF @USEHOURLYRATES = 1
  BEGIN
   SET @BKRE_COST_PRICE = @HOURLYCOST
  END
  ELSE BEGIN
   SET @BKRE_COST_PRICE = @DAILYCOST
  END
 END 
END


IF ISNULL(@ACTION,0) = 0
BEGIN
 /* Insert or Update the record */
 IF @Type = 1
 BEGIN
  
  BEGIN TRANSACTION BKRE
  
  IF @ONLY_UPDATE_FOR_DATES = 0
  BEGIN
   /* Delete the TS_BOOKING_RESOURCES records first if already exist */
   IF EXISTS(SELECT BKRE_PRIMARY
       FROM TS_BOOKING_RESOURCES
       WHERE BKRE_BKG_PRIMARY = @BKRE_BKG_PRIMARY
      AND BKRE_RESOURCE = @BKRE_RESOURCE)
   BEGIN    
    DELETE FROM TS_BOOKING_RESOURCES
    WHERE BKRE_BKG_PRIMARY = @BKRE_BKG_PRIMARY
      AND BKRE_RESOURCE = @BKRE_RESOURCE
      
    IF @@ERROR <> 0
    BEGIN
     SELECT @ErrorStr = 'Falied to delete from TS_BOOKING_RESOURCES'
     RAISERROR(@ErrorStr,16,1)
     ROLLBACK TRANSACTION BKRE
     Return -1
    END
   END
  END
   
  SET @BKRE_DATE = CAST(CONVERT(VARCHAR,@BKRE_DATE_START,106) AS DATETIME)
  
  WHILE (@BKRE_DATE <= @BKRE_DATE_END)
  BEGIN
   IF EXISTS(SELECT BKRE_PRIMARY
       FROM TS_BOOKING_RESOURCES 
       WHERE BKRE_BKG_PRIMARY = @BKRE_BKG_PRIMARY
      AND BKRE_RESOURCE = @BKRE_RESOURCE
      AND BKRE_DATE = @BKRE_DATE)
   AND @ONLY_UPDATE_FOR_DATES = 1
   BEGIN
    SELECT @ErrorStr = 'Cannot add the passed in resource '+ @BKRE_RESOURCE +' twice for the selected date '+ CONVERT(VARCHAR(10), @BKRE_DATE, 103) + ' when @ONLY_UPDATE_FOR_DATES is set to 1' 
    RAISERROR(@ErrorStr,16,1)
    ROLLBACK TRANSACTION BKRE
    Return -1
   END
   
   EXEC @Return_Value = TSSP_GET_SEQUENCE 'TS_BOOKING_RESOURCES', @BKRE_PRIMARY OUT
     
   IF @Return_Value <> 0 
   BEGIN
    SELECT @ErrorStr = 'Falied to get the next sequence number for TS_BOOKING_RESOURCES'
    RAISERROR(@ErrorStr,16,1)
    ROLLBACK TRANSACTION BKRE
    Return -1
   END
   
   INSERT INTO TS_BOOKING_RESOURCES
       ( BKRE_PRIMARY
       , BKRE_BKG_PRIMARY
       , BKRE_RESOURCE
       , BKRE_ROLE
       , BKRE_RATE
       , BKRE_DISCOUNT
       , BKRE_COST_PRICE
       , BKRE_DATE
       , BKRE_MAIN
       , BKRE_UPDATING
       , BKRE_TSSWD_PRIMARY
       , BKRE_SYSTEM)
   VALUES
       (@BKRE_PRIMARY --<BKRE_PRIMARY, float,>
       ,@BKRE_BKG_PRIMARY --<BKRE_BKG_PRIMARY, float,>
       ,@BKRE_RESOURCE --<BKRE_RESOURCE, varchar(16),>
       ,@BKRE_ROLE --<BKRE_ROLE, varchar(20),>
       ,@BKRE_RATE --<BKRE_RATE, float,>
       ,@BKRE_DISCOUNT --<BKRE_DISCOUNT, float,>
       ,@BKRE_COST_PRICE --<BKRE_COST_PRICE, float,>
       ,@BKRE_DATE --<BKRE_DATE, datetime,>
       ,0--<BKRE_MAIN, tinyint,>
       ,0 --<BKRE_UPDATING, tinyint,>
       ,@BKRE_TSSWD_PRIMARY --<BKRE_TSSWD_PRIMARY, float,>
       ,0) --<BKRE_SYSTEM, tinyint,>)
  
   IF @@ERROR <> 0
   BEGIN
    SELECT @ErrorStr = 'Falied to insert into TS_BOOKING_RESOURCES'
    RAISERROR(@ErrorStr,16,1)
    ROLLBACK TRANSACTION BKRE
    Return -1
   END
   SET @BKRE_DATE = DATEADD(dd,1,@BKRE_DATE)
  END
  
  COMMIT TRANSACTION BKRE
 END         
END
ELSE BEGIN
 /* Delete the record */
 IF @Type = 1
 BEGIN
  DELETE FROM TS_BOOKING_RESOURCES
  WHERE BKRE_BKG_PRIMARY = @BKRE_BKG_PRIMARY
    AND BKRE_RESOURCE = @BKRE_RESOURCE
    AND BKRE_DATE BETWEEN CAST(CONVERT(VARCHAR,@BKRE_DATE_START,106) AS DATETIME) AND CAST(CONVERT(VARCHAR,@BKRE_DATE_END,106) AS DATETIME)
    
  IF @@ERROR <> 0
  BEGIN
   SELECT @ErrorStr = 'Falied to delete from TS_BOOKING_RESOURCES'
   RAISERROR(@ErrorStr,16,1)
   Return -1
  END
 END
END
GO


