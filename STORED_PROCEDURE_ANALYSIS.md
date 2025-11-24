# Stored Procedures Analysis - Complete Documentation

## ✅ CONFIRMATION: I NOW HAVE COMPLETE CONTEXT

I have successfully analyzed:
1. ✅ **Booking Updates example.xlsx** - 47 columns of real booking data
2. ✅ **SQL Table Structures** - TS_BOOKINGS, TS_BOOKING_TYPES, TS_BOOKING_RATES, TS_BOOKING_RESOURCES
3. ✅ **Stored Procedures** - Both SPs with full parameter lists and validation logic

---

## 📋 STORED PROCEDURE 1: TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS

### Version History
- **V1**: Amit Patel 17/09/2012 - Created for insert, update, delete bookings
- **V1.1**: Dean Napper 19/09/2015 - Increased BKG_DETAIL to 4000 characters
- **V2**: Nikhil Bhavani 09/03/2023 - Added TSSWD PRIMARY parameter
- **V3**: Nikhil Bhavani 31/07/2025 - Updated error messages
- **v3.1**: Andy Smith 04/09/2025 - Fixed Global Lookup values issue
- **v3.2**: Andy Smith 21/11/2025 - Fixed hourly bookings setting bkg_qty =0.5

### Complete Parameter List (100+ parameters!)

#### Core Parameters
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `@Type` | TINYINT | Yes | 1 | 0=Validate Only, 1=Validate and Post |
| `@ACTION` | TINYINT | No | NULL | NULL=MixMode, 0=Insert, 1=Update, 2=Delete |
| `@BKG_PRIMARY` | FLOAT | Conditional | 0 | Primary key (required for UPDATE) |
| `@BKG_TYPE` | VARCHAR(20) | **Yes** | - | Booking type code |
| `@BKG_USER` | VARCHAR(4) | **Yes** | - | User ID who creates/updates |
| `@BKG_STATUS` | TINYINT | No | NULL | 0-7 (Pending to Invoiced) |
| `@BKG_START` | DATETIME | **Yes** | - | Start date |
| `@BKG_END` | DATETIME | **Yes** | - | End date |

#### Booking Details
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `@BKG_DESCRIPTION` | VARCHAR(50) | Conditional | NULL | Description |
| `@BKG_LOCATION` | VARCHAR(50) | Conditional | NULL | Location |
| `@BKG_DETAIL` | VARCHAR(4000) | Conditional | NULL | Detailed description |
| `@BKG_RESOURCE` | VARCHAR(16) | Conditional | NULL | Resource code |
| `@BKG_PROJECT` | VARCHAR(10) | Conditional | NULL | Project code |
| `@BKG_COSTCENTRE` | VARCHAR(20) | Conditional | NULL | Cost centre |
| `@BKG_ROLE` | VARCHAR(20) | Conditional | NULL | Role code |
| `@BKG_PRODUCT` | VARCHAR(100) | Conditional | NULL | Product |
| `@BKG_SOW` | VARCHAR(20) | Conditional | NULL | Statement of Work reference |

#### Time-Related
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `@BKG_START_TIME` | VARCHAR(5) | No | NULL | Start time (when not all-day) |
| `@BKG_END_TIME` | VARCHAR(5) | No | NULL | End time (when not all-day) |
| `@BKG_ALL_DAY` | TINYINT | Conditional | NULL | 1=All day, 0=Hourly |
| `@BKG_HALF_DAY` | TINYINT | No | NULL | Half day flag |

#### Financial
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `@BKG_RATE` | FLOAT | Conditional | NULL | Booking rate |
| `@BKG_COST_PRICE` | FLOAT | Conditional | NULL | Cost price |
| `@BKG_DISCOUNT` | FLOAT | Conditional | NULL | Discount amount |
| `@BKG_CURRENCY` | VARCHAR(4) | Conditional | NULL | Currency code |

#### Contact Information
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `@BKG_CUCODE` | VARCHAR(50) | Conditional | NULL | Customer code |
| `@BKG_ADDRESS` | VARCHAR(500) | Conditional | NULL | Address |
| `@BKG_PHONE` | VARCHAR(20) | Conditional | NULL | Phone number |
| `@BKG_EMAIL` | VARCHAR(128) | Conditional | NULL | Email address |
| `@BKG_CONTACT` | VARCHAR(30) | Conditional | NULL | Contact name |

#### Additional Fields
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `@BKG_NOTES` | VARCHAR(1000) | No | NULL | Notes |
| `@BKG_REJECTED_REASON` | VARCHAR(500) | No | NULL | Rejection reason |
| `@BKG_COLOUR` | FLOAT | Conditional | NULL | Color code |
| `@BKG_COLOUR_OVERRIDE` | TINYINT | Conditional | NULL | Color override flag |
| `@BKG_PO_NO` | VARCHAR(50) | Conditional | NULL | Purchase order number |
| `@BKG_USER1` | VARCHAR(50) | Conditional | NULL | User field 1 |
| `@BKG_COMMENTS` | VARCHAR(100) | Conditional | NULL | Comments |
| `@BKG_OFFSITE` | TINYINT | Conditional | NULL | Offsite flag |
| `@BKG_INVOICED` | TINYINT | Conditional | NULL | Invoiced flag |
| `@BGK_INV_ADDR` | FLOAT | Conditional | NULL | Invoice address primary |
| `@BGK_COURSE_CODE` | VARCHAR(10) | Conditional | NULL | Course code |

#### Custom Character Fields (20 fields)
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `@BGK_USER_CHAR1` | VARCHAR(30) | Conditional | NULL | Custom char field 1 |
| `@BGK_USER_CHAR2` | VARCHAR(30) | Conditional | NULL | Custom char field 2 |
| ... | ... | ... | ... | ... |
| `@BGK_USER_CHAR20` | VARCHAR(30) | Conditional | NULL | Custom char field 20 |

#### Custom Numeric Fields (10 fields)
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `@BGK_USER_NUM1` | FLOAT | Conditional | NULL | Custom numeric field 1 |
| ... | ... | ... | ... | ... |
| `@BGK_USER_NUM10` | FLOAT | Conditional | NULL | Custom numeric field 10 |

#### Custom Flag Fields (10 fields)
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `@BGK_USER_FLAG1` | TINYINT | Conditional | NULL | Custom flag field 1 |
| ... | ... | ... | ... | ... |
| `@BGK_USER_FLAG10` | TINYINT | Conditional | NULL | Custom flag field 10 |

#### Custom Date Fields (10 fields)
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `@BGK_USER_DATE1` | DATETIME | Conditional | NULL | Custom date field 1 |
| ... | ... | ... | ... | ... |
| `@BGK_USER_DATE10` | DATETIME | Conditional | NULL | Custom date field 10 |

#### Custom Notes Fields (5 fields)
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `@BGK_USER_NOTES1` | VARCHAR(MAX) | Conditional | NULL | Custom notes field 1 |
| ... | ... | ... | ... | ... |
| `@BGK_USER_NOTES5` | VARCHAR(MAX) | Conditional | NULL | Custom notes field 5 |

#### Custom Time Fields (5 fields)
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `@BGK_USER_TIME1` | DATETIME | Conditional | NULL | Custom time field 1 |
| ... | ... | ... | ... | ... |
| `@BGK_USER_TIME5` | DATETIME | Conditional | NULL | Custom time field 5 |

#### Reference Fields
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `@BGK_REF` | VARCHAR(30) | Conditional | NULL | Reference |
| `@BGK_REF_LINK` | VARCHAR(30) | Conditional | NULL | Reference link |
| `@BKG_DATASET` | VARCHAR(30) | Conditional | NULL | Dataset |

#### Shadow/Split Fields
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `@BKG_SHADOW_DB` | VARCHAR(50) | Conditional | NULL | Shadow database |
| `@BKG_SHADOW_KEY` | FLOAT | Conditional | NULL | Shadow key |
| `@BKG_SPLIT_PRIMARY` | FLOAT | Conditional | NULL | Split booking primary |
| `@BKG_PREDECESSOR` | FLOAT | Conditional | NULL | Predecessor booking |
| `@BKG_HAS_SUCCESSORS` | TINYINT | Conditional | NULL | Has successors flag |
| `@BKG_LINK_TYPE` | TINYINT | Conditional | NULL | Link type |
| `@BKG_SME_CALLTRAN` | FLOAT | Conditional | NULL | SME call transaction |

#### Resource-Related
| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `@BKRE_TSSWD_PRIMARY` | FLOAT | No | 0 | Project SOW Detail primary |

---

## 📋 STORED PROCEDURE 2: TSSP_INSERT_UPDATE_DELETE_TS_BOOKING_RESOURCES

### Version History
- **V1**: Amit Patel 17/09/2012 - Created for booking resource management
- **V2**: Nikhil Bhavani 09/03/2023 - Added TSSWD PRIMARY parameter

### Complete Parameter List

| Parameter | Type | Required | Default | Description |
|-----------|------|----------|---------|-------------|
| `@Type` | TINYINT | Yes | 1 | 0=Validate Only, 1=Validate and Post |
| `@ACTION` | TINYINT | No | NULL | NULL=MixMode, 0=Insert, 1=Delete |
| `@BKRE_BKG_PRIMARY` | FLOAT | **Yes** | - | Booking primary key |
| `@BKRE_RESOURCE` | VARCHAR(16) | **Yes** | - | Resource code |
| `@BKRE_DATE_START` | DATETIME | **Yes** | - | Start date |
| `@BKRE_DATE_END` | DATETIME | **Yes** | - | End date |
| `@BKRE_ROLE` | VARCHAR(20) | No | '' | Role code |
| `@BKRE_RATE` | FLOAT | No | 0 | Rate |
| `@BKRE_DISCOUNT` | FLOAT | No | 0 | Discount |
| `@BKRE_COST_PRICE` | FLOAT | No | 0 | Cost price |
| `@ONLY_UPDATE_FOR_DATES` | TINYINT | No | 0 | 0=Re-create, 1=Update only |
| `@BKRE_TSSWD_PRIMARY` | FLOAT | No | 0 | Project SOW Detail primary |

---

## 🔍 KEY VALIDATION RULES

### Booking Status Values
- **0** = Pending
- **1** = Submitted
- **2** = Approved
- **3** = Rejected
- **4** = Cancelled
- **5** = Confirmed
- **6** = Completed
- **7** = Invoiced

### Critical Validations
1. **BKG_TYPE** must exist in `TS_BOOKING_TYPES` table
2. **BKG_RESOURCE** must exist in `PRC_PRICE_RECS` with `PR_TYPE = 'R'`
3. **BKG_PROJECT** must exist in `CST_COSTHEADER`
4. **BKG_COSTCENTRE** must exist in `CST_COSTCENTRE` for the project
5. **BKG_CUCODE** (customer) must exist in `SL_ACCOUNTS`
6. **BKG_ROLE** must exist in `TS_ROLES` with specific flags
7. **BKG_PRODUCT** must exist in `TS_BOOKING_PRODUCTS`
8. **BKG_SOW** must exist in `TS_PROJECT_SOW_HEADER` for the project
9. **BKG_END** must be >= **BKG_START**
10. **Hourly bookings** cannot span multiple days
11. **Custom CHAR fields** may require lookup validation in `TS_LOOKUP`
12. **Field visibility and requirements** controlled by `TS_BOOKING_TYPES_SETUP_DETAIL`

### Dynamic Field Requirements
Fields marked as "Conditional" have their requirement status determined by:
- `TS_BOOKING_TYPES_SETUP_DETAIL.TSBKD_SHOW` - Whether field is visible
- `TS_BOOKING_TYPES_SETUP_DETAIL.TSBKD_COMPULSARY` - Whether field is required
- `TS_BOOKING_TYPES_SETUP_DETAIL.TSBKD_FIXED` - Whether field has fixed lookup values

---

## 📊 EXCEL TO STORED PROCEDURE MAPPING

### Current Excel Columns (47 total)
```
Primary, Cust Code, Customer, Resource Code, Resource Name, Start Date, End Date,
Unit Type, Units, Booking Type, Status, Description, Location, Detail, Product,
Flex Points Product, Offsite, SOW, SOW Type, SOW Detail Select, SOW Detail,
Role, RoleName, Booking Value, Phase, Stage, Sub Stage, Work Packet Code,
Internal Notes, Suppress on Plan, Go Live, Client Facing, Client Facing Notes,
Client Resource, ProjectCode, Activity Report, Invoice No, Inv. Nett, PO No,
Contact, Email, Pre-Contract PM, Pre-Contract Chargeable, Requested By/Reason,
Type/Outcome, [Project Plan fields-->], [Additional Info-->]
```

### Recommended Mapping Strategy

#### PRIORITY 1: Core Fields (Already Implemented)
- ✅ `Primary` → `@BKG_PRIMARY`
- ✅ `Resource Code` → `@BKG_RESOURCE`
- ✅ `ProjectCode` → `@BKG_PROJECT`
- ✅ `Start Date` → `@BKG_START`
- ✅ `End Date` → `@BKG_END`
- ✅ `Booking Type` → `@BKG_TYPE`
- ✅ `Status` → `@BKG_STATUS`

#### PRIORITY 2: Essential Fields (Should Add)
- ⚠️ `Description` → `@BKG_DESCRIPTION`
- ⚠️ `Location` → `@BKG_LOCATION`
- ⚠️ `Detail` → `@BKG_DETAIL`
- ⚠️ `Role` → `@BKG_ROLE`
- ⚠️ `Product` → `@BKG_PRODUCT`
- ⚠️ `SOW` → `@BKG_SOW`
- ⚠️ `Offsite` → `@BKG_OFFSITE` (map "Onsite"/"Offsite" to 0/1)
- ⚠️ `Units` → Calculate `BKG_DAYS` or handle hourly bookings
- ⚠️ `Unit Type` → Determine `@BKG_ALL_DAY` (Day=1, Hour=0)
- ⚠️ `Contact` → `@BKG_CONTACT`
- ⚠️ `Email` → `@BKG_EMAIL`
- ⚠️ `PO No` → `@BKG_PO_NO`
- ⚠️ `Cust Code` → `@BKG_CUCODE`

#### PRIORITY 3: Custom Fields (Map to USER_CHAR/NUM/FLAG)
- `Phase` → `@BGK_USER_CHAR1`
- `Stage` → `@BGK_USER_CHAR2`
- `Sub Stage` → `@BGK_USER_CHAR3`
- `Work Packet Code` → `@BGK_USER_CHAR4`
- `Internal Notes` → `@BGK_USER_NOTES1`
- `Client Facing Notes` → `@BGK_USER_NOTES2`
- `Suppress on Plan` → `@BGK_USER_FLAG1` (Yes/No → 1/0)
- `Go Live` → `@BGK_USER_FLAG2`
- `Client Facing` → `@BGK_USER_FLAG3`
- `Pre-Contract Chargeable` → `@BGK_USER_FLAG4`
- `Booking Value` → `@BGK_USER_NUM1`
- `SOW Detail` → `@BGK_USER_NUM2`

#### PRIORITY 4: Additional Fields
- `Customer` → Reference only (use Cust Code)
- `Resource Name` → Reference only (use Resource Code)
- `RoleName` → Reference only (use Role)
- `SOW Type` → Reference/validation
- `Flex Points Product` → `@BGK_USER_CHAR5`
- `Client Resource` → `@BGK_USER_CHAR6`
- `Activity Report` → `@BGK_USER_CHAR7`
- `Invoice No` → `@BGK_USER_CHAR8`
- `Inv. Nett` → `@BGK_USER_NUM3`
- `Pre-Contract PM` → `@BGK_USER_CHAR9`
- `Requested By/Reason` → `@BGK_USER_CHAR10`
- `Type/Outcome` → `@BGK_USER_CHAR11`

---

## 🎯 IMPLEMENTATION RECOMMENDATIONS

### 1. Update bookingService.js
Current implementation only maps ~9 fields. Should expand to include:
- All Priority 1 fields (done)
- All Priority 2 fields (essential)
- Priority 3 fields (custom mapping)

### 2. Add Validation Layer
- Validate booking type exists
- Validate resource exists
- Validate project exists
- Validate dates (end >= start)
- Validate status values (0-7)
- Handle Excel date serial numbers (45881 → actual date)
- Map text values to codes (e.g., "Onsite"/"Offsite" → 0/1)

### 3. Handle Special Cases
- **Hourly vs Daily bookings**: Check `Unit Type` column
- **Half-day bookings**: Set `@BKG_HALF_DAY` appropriately
- **SOW Detail**: May need to query `TS_PROJECT_SOW_DETAIL`
- **Custom field lookups**: Validate against `TS_LOOKUP` if required

### 4. Error Handling
- Capture SP error messages
- Map to user-friendly messages
- Include row numbers in error reports
- Handle transaction rollbacks

### 5. History Tracking
The SP automatically creates history records in `TS_BOOKING_HISTORY` for updates, including:
- Changed fields
- Original vs new values
- User who made changes
- Timestamp

---

## 🚀 NEXT STEPS

1. **Update Excel Parser** to handle all 47 columns
2. **Create Field Mapping Configuration** (Excel column → SP parameter)
3. **Implement Data Transformation** (text → codes, dates, flags)
4. **Add Comprehensive Validation** before calling SP
5. **Update UI** to show more field information
6. **Create Template Generator** with all supported fields
7. **Add Lookup Value Validation** for custom fields
8. **Implement Batch Processing** with proper transaction handling

---

## 📝 NOTES

- The SP has **extensive validation** built-in
- Many fields are **conditionally required** based on booking type configuration
- The SP handles **INSERT, UPDATE, and DELETE** operations
- **Automatic history tracking** for updates
- **Resource allocation** handled by second SP
- **Rate calculation** is complex and automatic if not provided
- **Working day validation** against user profiles
- **Bank holiday checking** for resources

---

**Analysis Complete**: Ready to implement full Excel import functionality! 🎉
