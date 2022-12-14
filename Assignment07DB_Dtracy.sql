--*************************************************************************--
-- Title: Assignment07
-- Author: Dtracy
-- Desc: This file demonstrates how to use Functions
-- Change Log: When,Who,What
-- 2022-08-23,Dtracy,Excuted Code, Added Answers to Questions
--**************************************************************************--
Begin Try
	Use Master;
	If Exists(Select Name From SysDatabases Where Name = 'Assignment07DB_Dtracy')
	 Begin 
	  Alter Database [Assignment07DB_Dtracy] set Single_user With Rollback Immediate;
	  Drop Database Assignment07DB_Dtracy;
	 End
	Create Database Assignment07DB_Dtracy;
End Try
Begin Catch
	Print Error_Number();
End Catch
go
Use Assignment07DB_Dtracy;

-- Create Tables (Module 01)-- 
Create Table Categories
([CategoryID] [int] IDENTITY(1,1) NOT NULL 
,[CategoryName] [nvarchar](100) NOT NULL
);
go

Create Table Products
([ProductID] [int] IDENTITY(1,1) NOT NULL 
,[ProductName] [nvarchar](100) NOT NULL 
,[CategoryID] [int] NULL  
,[UnitPrice] [money] NOT NULL
);
go

Create Table Employees -- New Table
([EmployeeID] [int] IDENTITY(1,1) NOT NULL 
,[EmployeeFirstName] [nvarchar](100) NOT NULL
,[EmployeeLastName] [nvarchar](100) NOT NULL 
,[ManagerID] [int] NULL  
);
go

Create Table Inventories
([InventoryID] [int] IDENTITY(1,1) NOT NULL
,[InventoryDate] [Date] NOT NULL
,[EmployeeID] [int] NOT NULL
,[ProductID] [int] NOT NULL
,[ReorderLevel] int NOT NULL -- New Column 
,[Count] [int] NOT NULL
);
go

-- Add Constraints (Module 02) -- 
Begin  -- Categories
	Alter Table Categories 
	 Add Constraint pkCategories 
	  Primary Key (CategoryId);

	Alter Table Categories 
	 Add Constraint ukCategories 
	  Unique (CategoryName);
End
go 

Begin -- Products
	Alter Table Products 
	 Add Constraint pkProducts 
	  Primary Key (ProductId);

	Alter Table Products 
	 Add Constraint ukProducts 
	  Unique (ProductName);

	Alter Table Products 
	 Add Constraint fkProductsToCategories 
	  Foreign Key (CategoryId) References Categories(CategoryId);

	Alter Table Products 
	 Add Constraint ckProductUnitPriceZeroOrHigher 
	  Check (UnitPrice >= 0);
End
go

Begin -- Employees
	Alter Table Employees
	 Add Constraint pkEmployees 
	  Primary Key (EmployeeId);

	Alter Table Employees 
	 Add Constraint fkEmployeesToEmployeesManager 
	  Foreign Key (ManagerId) References Employees(EmployeeId);
End
go

Begin -- Inventories
	Alter Table Inventories 
	 Add Constraint pkInventories 
	  Primary Key (InventoryId);

	Alter Table Inventories
	 Add Constraint dfInventoryDate
	  Default GetDate() For InventoryDate;

	Alter Table Inventories
	 Add Constraint fkInventoriesToProducts
	  Foreign Key (ProductId) References Products(ProductId);

	Alter Table Inventories 
	 Add Constraint ckInventoryCountZeroOrHigher 
	  Check ([Count] >= 0);

	Alter Table Inventories
	 Add Constraint fkInventoriesToEmployees
	  Foreign Key (EmployeeId) References Employees(EmployeeId);
End 
go

-- Adding Data (Module 04) -- 
Insert Into Categories 
(CategoryName)
Select CategoryName 
 From Northwind.dbo.Categories
 Order By CategoryID;
go

Insert Into Products
(ProductName, CategoryID, UnitPrice)
Select ProductName,CategoryID, UnitPrice 
 From Northwind.dbo.Products
  Order By ProductID;
go

Insert Into Employees
(EmployeeFirstName, EmployeeLastName, ManagerID)
Select E.FirstName, E.LastName, IsNull(E.ReportsTo, E.EmployeeID) 
 From Northwind.dbo.Employees as E
  Order By E.EmployeeID;
go

Insert Into Inventories
(InventoryDate, EmployeeID, ProductID, [Count], [ReorderLevel]) -- New column added this week
Select '20170101' as InventoryDate, 5 as EmployeeID, ProductID, UnitsInStock, ReorderLevel
From Northwind.dbo.Products
UNIOn
Select '20170201' as InventoryDate, 7 as EmployeeID, ProductID, UnitsInStock + 10, ReorderLevel -- Using this is to create a made up value
From Northwind.dbo.Products
UNIOn
Select '20170301' as InventoryDate, 9 as EmployeeID, ProductID, abs(UnitsInStock - 10), ReorderLevel -- Using this is to create a made up value
From Northwind.dbo.Products
Order By 1, 2
go


-- Adding Views (Module 06) -- 
Create View vCategories With SchemaBinding
 AS
  Select CategoryID, CategoryName From dbo.Categories;
go
Create View vProducts With SchemaBinding
 AS
  Select ProductID, ProductName, CategoryID, UnitPrice From dbo.Products;
go
Create View vEmployees With SchemaBinding
 AS
  Select EmployeeID, EmployeeFirstName, EmployeeLastName, ManagerID From dbo.Employees;
go
Create View vInventories With SchemaBinding 
 AS
  Select InventoryID, InventoryDate, EmployeeID, ProductID, ReorderLevel, [Count] From dbo.Inventories;
go

-- Show the Current data in the Categories, Products, and Inventories Tables
Select * From vCategories;
go
Select * From vProducts;
go
Select * From vEmployees;
go
Select * From vInventories;
go

/********************************* Questions and Answers *********************************/
Print
'NOTES------------------------------------------------------------------------------------ 
 1) You must use the BASIC views for each table.
 2) Remember that Inventory Counts are Randomly Generated. So, your counts may not match mine
 3) To make sure the Dates are sorted correctly, you can use Functions in the Order By clause!
------------------------------------------------------------------------------------------'
-- Question 1 (5% of pts):
-- Show a list of Product names and the price of each product.
-- Use a function to format the price as US dollars.
-- Order the result by the product name.

-- <Put Your Code Here> --
 -- View the data in the View:)
 --Select * from vproducts;
 --Go
 ---- Select the columns
 --Select 
 --ProductName
 --,UnitPrice
 --From vproducts;
 --Go
 ---- Add the format for US Dollars
 -- Select 
 --ProductName
 --,Format(UnitPrice, 'C', 'en-US') AS 'UnitPrice'
 --From vproducts;
 --Go
 ---- Add the Sort Order
 Select 
 ProductName
 ,Format(UnitPrice, 'C', 'en-US') AS 'UnitPrice'
 From vproducts
 Order by ProductName;
 Go


-- Question 2 (10% of pts): 
-- Show a list of Category and Product names, and the price of each product.
-- Use a function to format the price as US dollars.
-- Order the result by the Category and Product.
-- <Put Your Code Here> --
-- View the data in the View:)
 --Select * from vproducts;
 --Select * from vcategories;
 --Go
 ---- Select the columns
 --Select 
 --CategoryName
 --,ProductName
 --,UnitPrice
 --From vproducts,vcategories;
 --Go
 -- Add the format for US Dollars
 --Select 
 --CategoryID
 --,ProductName
 --,Format(UnitPrice, 'C', 'en-US') AS 'UnitPrice'
 --From vproducts;
 --Go
 -- Add the Join and Order by
 Select 
 c.CategoryName
 ,p.ProductName
 ,Format(p.UnitPrice, 'C', 'en-US') AS 'UnitPrice'
 From vproducts p
 INNER JOIN
 vcategories c
 ON c.CategoryID = p.CategoryID
 Order by c.CategoryID, p.ProductName;
 Go

-- Question 3 (10% of pts): 
-- Use functions to show a list of Product names, each Inventory Date, and the Inventory Count.
-- Format the date like 'January, 2017'.
-- Order the results by the Product and Date.

-- <Put Your Code Here> --
-- Look at the Data
--Select * from vproducts;
--Select * from vinventories;
--Go
 ---- Select the columns
--Select 
--ProductName
--,InventoryDate
--,Count
--From vproducts,vinventories;
--Go

-- Join the Tables and Format the Date
--Select 
--p.ProductName
--,Format(i.InventoryDate, 'MMMM, yyyy') AS 'InventoryDate'
--,i.Count AS 'InventoryCount'
--From vproducts p
--Inner Join vInventories i
--ON p.ProductID = i.ProductID;
--Go

 -- Add the Sort Order
Select 
p.ProductName
,Format(i.InventoryDate, 'MMMM, yyyy') AS 'InventoryDate'
,i.Count AS 'InventoryCount'
From vproducts p
Inner Join vInventories i
ON p.ProductID = i.ProductID
Order by p.ProductName, i.InventoryDate;
go

-- Question 4 (10% of pts): 
-- CREATE A VIEW called vProductInventories. 
-- Shows a list of Product names, each Inventory Date, and the Inventory Count. 
-- Format the date like 'January, 2017'.
-- Order the results by the Product and Date.

-- <Put Your Code Here> --
-- Look at the Data
--Select * from vproducts;
--Select * from vinventories;
--Go
-- ---- Select the columns
--Select 
--ProductName
--,InventoryDate
--,Count
--From vproducts,vinventories;
--Go
-- Join the Tables and Format the Date
--Select 
--ProductName
--,Format(InventoryDate, 'MMMM, yyyy') AS 'InventoryDate'  
--,Count AS 'InventoryCount'
--From vproducts
--Inner Join vInventories
--ON vproducts.ProductID = vInventories.ProductID;
--Go
 -- Add the Sort Order
--Select 
--ProductName
--,Format(InventoryDate, 'MMMM, yyyy') AS 'InventoryDate'  
--,Count AS 'InventoryCount'
--From vproducts
--Inner Join vInventories
--ON vproducts.ProductID = vInventories.ProductID
--Order by ProductName, InventoryDate;
--Go

-- Create the View 
Create --Drop
View vProductInventories AS
Select TOP 100000000  -- Top to get past the Order by requirement
ProductName
,Format(InventoryDate, 'MMMM, yyyy') AS 'InventoryDate'  
,Count AS InventoryCount
From vproducts
Inner Join vInventories
ON vproducts.ProductID = vInventories.ProductID
Order by ProductName, InventoryDate;
Go

-- Check that it works: Select * From vProductInventories;
go

-- Question 5 (10% of pts): 

-- CREATE A VIEW called vCategoryInventories. 
-- Shows a list of Category names, Inventory Dates, and a TOTAL Inventory Count BY CATEGORY
-- Format the date like 'January, 2017'.
-- Order the results by the Product and Date.

-- <Put Your Code Here> --
-- Look over the tables
--Select * from vproducts;
--Select * from vinventories;
--Select * from vcategories;
--Go
-- Join the Tables and Format the Date
--Select Distinct
--c.CategoryName
--,Format(i.InventoryDate, 'MMMM, yyyy') AS 'InventoryDate'
--,Sum(i.Count) AS InventoryCountByCategory
--FROM Categories c 
--INNER JOIN
--Products p
--ON p.CategoryID = c.CategoryID 
--INNER JOIN
--Inventories i
--ON i.ProductID = p.ProductID 
--Group by c.CategoryName,i.InventoryDate;
--Go
-- Create the View
Create -- Drop
View vCategoryInventories
AS
Select Distinct
c.CategoryName
,Format(i.InventoryDate, 'MMMM, yyyy') AS 'InventoryDate'
,Sum(i.Count) AS InventoryCountByCategory
FROM Categories c 
INNER JOIN
Products p
ON p.CategoryID = c.CategoryID 
INNER JOIN
Inventories i
ON i.ProductID = p.ProductID 
Group by c.CategoryName,i.InventoryDate;
Go

-- Check that it works: Select * From vCategoryInventories;
go

-- Question 6 (10% of pts): 
-- CREATE ANOTHER VIEW called vProductInventoriesWithPreviouMonthCounts. 
-- Show a list of Product names, Inventory Dates, Inventory Count, AND the Previous Month Count.
-- Use functions to set any January NULL counts to zero. 
-- Order the results by the Product and Date. 
-- This new view must use your vProductInventories view.

-- <Put Your Code Here> --
-- Select * From vProductInventories; -- Verify what's there.
-- Setup before Lag:
--Select 
--v.ProductName
--,v.InventoryDate
--,v.InventoryCount 
--From vProductInventories v; 
--Go
-- Add Lag
--Select 
--v.ProductName
--,v.InventoryDate
--,v.InventoryCount 
--,[PreviousMonthCount] = Lag(v.InventoryCount) Over(Order By Month(v.InventoryDate))
--From vProductInventories v;
--go
-- Deal with the Null Values Set the Order by.
--Select 
--v.ProductName
--,v.InventoryDate
--,v.InventoryCount
--,PreviousMonthCount = ISNULL(Lag(v.InventoryCount) Over(Order By Month(v.InventoryDate)),0)
--From vProductInventories v
--Order by v.ProductName,v.InventoryDate;
--go
-- Create the view vProductInventoriesWithPreviousMonthCounts  -- At TOP XXXXXXXX
Create --Drop
View vProductInventoriesWithPreviousMonthCounts
AS
Select TOP 10000000
v.ProductName
,v.InventoryDate
,v.InventoryCount
,[PreviousMonthCount] = ISNULL(Lag(v.InventoryCount) Over(Order By Month(v.InventoryDate)),0)
From vProductInventories v
Order by v.ProductName,v.InventoryDate;
go

-- Check that it works: Select * From vProductInventoriesWithPreviousMonthCounts;
go

-- Question 7 (15% of pts): 
-- CREATE a VIEW called vProductInventoriesWithPreviousMonthCountsWithKPIs.
-- Show columns for the Product names, Inventory Dates, Inventory Count, Previous Month Count. 
-- The Previous Month Count is a KPI. The result can show only KPIs with a value of either 1, 0, or -1. 
-- Display months with increased counts as 1, same counts as 0, and decreased counts as -1. 
-- Varify that the results are ordered by the Product and Date.

-- Important: This new view must use your vProductInventoriesWithPreviousMonthCounts view!
-- Check that it works: Select * From vProductInventoriesWithPreviousMonthCountsWithKPIs;

-- <Put Your Code Here> --

 --Setup the select statment with a case 

--SELECT v.ProductName
--,v.InventoryDate
--,v.InventoryCount
--,v.PreviousMonthCount
--,[CountVsPreviousCountKPI] = CASE
--	When v.InventoryCount = v.PreviousMonthCount Then 0
--	When v.InventoryCount > v.PreviousMonthCount Then 1
--	When v.InventoryCount < v.PreviousMonthCount Then -1
--	End
--FROM vProductInventoriesWithPreviousMonthCounts v
--Go

---- Add in the order by.

--SELECT v.ProductName
--,v.InventoryDate
--,v.InventoryCount
--,v.PreviousMonthCount
--,[CountVsPreviousCountKPI] = CASE
--	When v.InventoryCount = v.PreviousMonthCount Then 0
--	When v.InventoryCount > v.PreviousMonthCount Then 1
--	When v.InventoryCount < v.PreviousMonthCount Then -1
--	End
--FROM vProductInventoriesWithPreviousMonthCounts v
--Order By v.ProductName,v.InventoryDate;
--Go

-- Create the View 

Create --Drop
View vProductInventoriesWithPreviousMonthCountsWithKPIs
AS
SELECT TOP 10000000
v.ProductName
,v.InventoryDate
,v.InventoryCount
,v.PreviousMonthCount
,[CountVsPreviousCountKPI] = CASE
	When v.InventoryCount = v.PreviousMonthCount Then 0
	When v.InventoryCount > v.PreviousMonthCount Then 1
	When v.InventoryCount < v.PreviousMonthCount Then -1
	End
FROM vProductInventoriesWithPreviousMonthCounts v
Order By v.ProductName,v.InventoryDate;
Go
-- Check that it works: 
-- Select * From vProductInventoriesWithPreviousMonthCountsWithKPIs;
Go


-- Question 8 (25% of pts): 
-- CREATE a User Defined Function (UDF) called fProductInventoriesWithPreviousMonthCountsWithKPIs.
-- Show columns for the Product names, Inventory Dates, Inventory Count, the Previous Month Count. 
-- The Previous Month Count is a KPI. The result can show only KPIs with a value of either 1, 0, or -1. 
-- Display months with increased counts as 1, same counts as 0, and decreased counts as -1. 
-- The function must use the ProductInventoriesWithPreviousMonthCountsWithKPIs view.
-- Varify that the results are ordered by the Product and Date.

-- <Put Your Code Here> --
-- Check the output of the previous View 
--Select * From vProductInventoriesWithPreviousMonthCountsWithKPIs;
--Go
-- Create the Function
Create -- DROP 
Function fProductInventoriesWithPreviousMonthCountsWithKPIs
(@KPI as int)
Returns table
AS
Return
(
Select *
From vProductInventoriesWithPreviousMonthCountsWithKPIs
Where CountVsPreviousCountKPI = @KPI
)
go

/* Check that it works:
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(1);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(0);
Select * From fProductInventoriesWithPreviousMonthCountsWithKPIs(-1);
*/
go

/***************************************************************************************/