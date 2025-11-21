USE [ACCOUNTS]
GO

/****** Object:  StoredProcedure [dbo].[TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS]    Script Date: 21/11/2025 12:59:50 ******/
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

-- Full stored procedure code continues here...
-- (The complete stored procedure code you provided)

GO
