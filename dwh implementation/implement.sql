create database e_commerce_dwh;
go

use e_commerce_dwh;

create table dim_date (
    datekey int primary key,
    datefull date,
    year int,
    quarter int,
    month int,
    day int,
    dayofweek int,
    dayname nvarchar(10),
    monthname nvarchar(10)
);

declare @startdate date = '2016-01-01';
declare @enddate date = '2020-01-01';

while @startdate <= @enddate
begin
    insert into dim_date (
        datekey,
        datefull,
        year,
        quarter,
        month,
        day,
        dayofweek,
        dayname,
        monthname
    )
    values (
        cast(year(@startdate) as varchar(4)) + 
        right('0' + cast(month(@startdate) as varchar(2)), 2) + 
        right('0' + cast(day(@startdate) as varchar(2)), 2), -- datekey
        @startdate,                                         -- datefull
        year(@startdate),                                   -- year
        datepart(quarter, @startdate),                       -- quarter
        month(@startdate),                                  -- month
        day(@startdate),                                    -- day
        ((datepart(weekday, @startdate) + @@datefirst - 1) % 7) + 1, -- dayofweek
        datename(weekday, @startdate),                       -- dayname
        datename(month, @startdate)                          -- monthname
    );

    set @startdate = dateadd(day, 1, @startdate);
end;

create table dim_order (
    order_id_sk int identity(1,1) primary key,
    order_id varchar(50) ,
    payment_sequential int,
    payment_type varchar(50),
    payment_installments int,
    order_state varchar(50),
    payment_value int,
	feedback_id varchar(50),
    feedback_score int,
	feedback_form_sent_time datetime,
    feedback_answer_time datetime,
    
    
    
    start_date datetime,
    end_date datetime,
    is_current int check (is_current in (0, 1))
);

create table dim_customer
(
    customer_id_sk int identity(1,1) primary key,
   
     customer_id varchar(50),
    customer_zip_code int,
    customer_city varchar(50),
    customer_state varchar(50),
	

	 start_date datetime,
    end_date datetime,
    is_current int check (is_current in (0, 1))

)

create table dim_seller (
    seller_id_sk int identity(1,1) primary key,
    seller_id varchar(50),
    seller_zip_code int,
    seller_city varchar(50),
    seller_state varchar(50),
    start_date datetime,
    end_date datetime,
    is_current int check (is_current in (0, 1))
);

create table dim_product (
    product_id_sk int identity(1,1) primary key,
    product_id varchar(50),
    product_category varchar(50),
    product_name_length int,
    product_description_length int,
    product_photos_qty int,
    product_weight_g int,
    product_length_cm int,
    product_height_cm int,
    product_width_cm int,
    start_date datetime,
    end_date datetime,
    is_current int check (is_current in (0, 1))
);

create table fact_sales (
    order_id int foreign key references dbo.dim_order(order_id_sk),
    order_item_id int,
    product_id int foreign key references dbo.dim_product(product_id_sk),
    seller_id int foreign key references dbo.dim_seller(seller_id_sk),
	customer_id int foreign key references dbo.dim_customer(customer_id_sk),


    
    pickup_limit_date int foreign key references dbo.dim_date(datekey),
  
    order_date int foreign key references dbo.dim_date(datekey),
    order_approved_date int foreign key references dbo.dim_date(datekey),
    pickup_date int foreign key references dbo.dim_date(datekey),
    delivery_date int foreign key references dbo.dim_date(datekey),
    estimated_time_delivery int foreign key references dbo.dim_date(datekey),
    
  
   
    
    pickup_limit_time int,
  
    order_time int,
    order_approved_time int,
    pickup_time int,
    delivery_time int,
    estimated_time_delivery_time int,
	  price int,
    shipping_cost int,

    primary key (order_id, order_item_id,product_id,seller_id,customer_id)
);





