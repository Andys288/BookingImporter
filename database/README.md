# Database Scripts

This folder contains SQL Server database scripts and stored procedures used by the Resource Booking Import Tool.

## Stored Procedures

### TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS

**Purpose**: Insert, update, or delete booking records in the TS_BOOKINGS table.

**Database**: ACCOUNTS

**Version History**:
- V1: Amit Patel 17/09/2012 - Created to insert, update or delete the Bookings - 4.6.00
- V1.1: Dean Napper 19/09/2015 - Increased the size of the BKG_DETAIL field to 4000 characters
- V2: Nikhil Bhavani 09/03/2023 - Add TSSWD PRIMARY as parameter for pass into TSSP_INSERT_UPDATE_DELETE_TS_BOOKING_RESOURCES
- V3: Nikhil Bhavani 31/07/2025 - Update error message
- v3.1: Andy Smith 04/09/2025 - Fixed issue with not finding Global Lookup values in ts_lookup
- v3.2: Andy Smith 21/11/2025 - Fixed issue with hourly bookings setting bkg_qty =0.5

**Key Parameters**:
- `@Type` - TINYINT (0 = Validate Only, 1 = Validate and Post)
- `@ACTION` - TINYINT (NULL = MixMode, 0 = Insert, 1 = Update, 2 = Delete)
- `@BKG_PRIMARY` - FLOAT (Primary key for the booking record)
- `@BKG_TYPE` - VARCHAR(20) (The type of the booking record)
- `@BKG_USER` - VARCHAR(4) (The id of the user who creates/updated the booking)
- `@BKG_STATUS` - TINYINT (0=Pending, 1=Submitted, 2=Approved, 3=Rejected, 4=Cancelled, 5=Confirmed, 6=Completed, 7=Invoiced)
- `@BKG_RESOURCE` - VARCHAR(16) (The resource for the booking)
- `@BKG_PROJECT` - VARCHAR(10) (The project for the booking record)
- `@BKG_START` - DATETIME (The start date of the booking record)
- `@BKG_END` - DATETIME (The end date of the booking record)
- `@BKG_ROLE` - VARCHAR(20) (The role for the booking record)
- `@BKG_ALL_DAY` - TINYINT (1 = All Day booking, 0 = Not all day booking)
- `@BKG_HALF_DAY` - TINYINT (Half day flag)
- `@BKRE_TSSWD_PRIMARY` - FLOAT (Primary key for the PROJECT SOW DETAIL)

Plus many additional optional parameters for custom fields (USER_CHAR1-20, USER_NUM1-10, USER_FLAG1-10, USER_DATE1-10, USER_NOTES1-5, USER_TIME1-5).

**Validation Rules**:
- Validates booking type exists in TS_BOOKING_TYPES
- Validates customer code exists in SL_ACCOUNTS (if provided)
- Validates project code exists in CST_COSTHEADER (if provided)
- Validates cost centre exists in CST_COSTCENTRE (if provided)
- Validates resource exists in PRC_PRICE_RECS (if provided)
- Validates role exists in TS_ROLES (if provided)
- Validates product exists in TS_BOOKING_PRODUCTS (if provided)
- Validates currency exists in SYS_CURRENCY (if provided)
- Validates SOW code exists in TS_PROJECT_SOW_HEADER (if provided)
- Validates start date is before end date
- Validates hourly bookings don't span multiple days
- Validates all compulsory fields based on booking type configuration

**Related Tables**:
- TS_BOOKINGS (main booking table)
- TS_BOOKING_RESOURCES (booking resource allocations)
- TS_BOOKING_HISTORY (audit trail of booking changes)
- TS_BOOKING_TYPES (booking type definitions)
- TS_BOOKING_TYPES_SETUP_DETAIL (field configuration per booking type)
- TS_ROLES (role definitions)
- TS_USERS (user information)
- PRC_PRICE_RECS (resource pricing)
- CST_COSTHEADER (project/cost header)
- CST_COSTCENTRE (cost centre definitions)
- SL_ACCOUNTS (customer accounts)
- TS_PROJECT_SOW_HEADER (Statement of Work headers)
- TS_LOOKUP (lookup values for custom fields)

**Transaction Handling**:
- Uses transactions for data integrity
- Rolls back on any error
- Maintains booking history for updates

**Usage in POC**:
The Resource Booking Import Tool calls this stored procedure to insert or update booking records imported from Excel files. The tool maps Excel columns to stored procedure parameters and handles validation errors returned by the procedure.

## File Location

The complete stored procedure SQL script is located in:
`database/TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS.sql`

## Installation

To install or update the stored procedure:

```sql
-- Run the script in SQL Server Management Studio
-- against the ACCOUNTS database
USE [ACCOUNTS]
GO

-- Execute the script file
-- TSSP_INSERT_UPDATE_DELETE_TS_BOOKINGS.sql
```

## Notes

- The stored procedure requires appropriate permissions on all referenced tables
- Ensure all dependent stored procedures exist (e.g., TSSP_GET_SEQUENCE, TSSP_INSERT_UPDATE_DELETE_TS_BOOKING_RESOURCES)
- The procedure validates data against multiple lookup tables before inserting/updating
- Custom field validation is dynamic based on booking type configuration
