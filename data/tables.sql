set ansi_nulls on
go

set quoted_identifier on
go

set ansi_padding on
go

/* drop tables */

if exists (select name from sys.objects where name = N'production') drop table [production]
go
if exists (select name from sys.objects where name = N'products') drop table [products]
go
if exists (select name from sys.objects where name = N'stockrooms') drop table [stockrooms]
go
if exists (select name from sys.objects where name = N'production_workstations') drop table [production_workstations]
go
if exists (select name from sys.objects where name = N'plant_sectors') drop table [plant_sectors]
go
if exists (select name from sys.objects where name = N'production_orders') drop table [production_orders]
go
if exists (select name from sys.objects where name = N'human_resources_messages') drop table [human_resources_messages]
go

/* create tables */

-- human_resources_messages (SIRH) --
create table [dbo].[human_resources_messages] (
	[id]						[int] identity(1,1) not null,
	[modification_date_time]	[datetime]			not null,
	[message]					[varchar](max)		not null,
	[enabled]					[bit]				not null,
	constraint [pk_notes] primary key clustered (
		[id] ASC
	)with (pad_index  = off, statistics_norecompute  = off, ignore_dup_key = off, allow_row_locks  = on, allow_page_locks  = on) on [primary]
) on [primary]
go
alter table [dbo].[human_resources_messages] add constraint [df_human_resources_messages_modification_date_time] default (getdate()) for [modification_date_time]
go
alter table [dbo].[human_resources_messages] add constraint [df_human_resources_messages_enabled] default (1) for [enabled]
go

-- production_orders (SGI) --
create table [dbo].[production_orders] (
	[id]					[int] identity(1,1) not null,
	[start_date_time]		[datetime]			not null,
	[end_date_time]			[datetime]			not null,
	[quantity]				[int]				not null
	constraint [pk_production_orders] primary key clustered (
		[id] ASC
	)with (pad_index  = off, statistics_norecompute  = off, ignore_dup_key = off, allow_row_locks  = on, allow_page_locks  = on) on [primary]
) on [primary]
go

-- plant_sectors (MES) --
create table [dbo].[plant_sectors] (
	[id]		[int] identity(1,1) not null,
	[name]		[varchar](30)		not null
	constraint [pk_plant_sectors] primary key clustered (
		[id] ASC
	)with (pad_index  = off, statistics_norecompute  = off, ignore_dup_key = off, allow_row_locks  = on, allow_page_locks  = on) on [primary]
) on [primary]
go
create unique nonclustered index [ix_plant_sectors_name] ON [dbo].[plant_sectors] 
(
	[name] asc
) with (pad_index = off, statistics_norecompute = off, sort_in_tempdb = off, ignore_dup_key = off, drop_existing = off, online = off, allow_row_locks = on, allow_page_locks = on) on [primary]
go

-- stockrooms (MES) --
create table [dbo].[stockrooms] (
	[id]			[int] identity(1,1) not null,
	[name]			[varchar](30)		not null,
	[max_quantity]	[int]				not null,
	constraint [pk_stockrooms] primary key clustered (
		[id] ASC
	)with (pad_index  = off, statistics_norecompute  = off, ignore_dup_key = off, allow_row_locks  = on, allow_page_locks  = on) on [primary]
) on [primary]
go
create unique nonclustered index [ix_stockroom_name] ON [dbo].[stockrooms] 
(
	[name] asc
) with (pad_index = off, statistics_norecompute = off, sort_in_tempdb = off, ignore_dup_key = off, drop_existing = off, online = off, allow_row_locks = on, allow_page_locks = on) on [primary]
go

-- stockrooms_threshold (MES) --
create table [dbo].[stockrooms_threshold] (
	[id]				[int] identity(1,1) not null,
	[stockroom_id]		[int]				not null,
	[min_percentaje]	[decimal](6,2)		not null,
	[max_percentaje]	[decimal](6,2)		not null,
	[color]				[int]				not null,
	constraint [pk_stockrooms_threshold] primary key clustered (
		[id] ASC
	)with (pad_index  = off, statistics_norecompute  = off, ignore_dup_key = off, allow_row_locks  = on, allow_page_locks  = on) on [primary]
) on [primary]
go
alter table [dbo].[stockrooms_threshold] add constraint [fk_stockrooms_threshold-stockrooms]	foreign key ([stockroom_id])	references [dbo].[stockrooms_threshold]([id])
go

-- production_workstations (MES) --
create table [dbo].[production_workstations] (
	[id]						[int] identity(1,1) not null,
--	[workstation_id]			[varchar](30)		not null,
	[plant_sector_id]			[int]				not null,
	[consumption_stockroom_id]	[int]				not null,
	[production_stockroom_id]	[int]				not null,
	constraint [pk_production_workstations] primary key clustered (
		[id] ASC
	)with (pad_index  = off, statistics_norecompute  = off, ignore_dup_key = off, allow_row_locks  = on, allow_page_locks  = on) on [primary]
) on [primary]
go
alter table [dbo].[production_workstations] add constraint [fk_production_workstations-plant_sectors]	foreign key ([plant_sector_id])				references [dbo].[production_workstations]([id])
go
alter table [dbo].[production_workstations] add constraint [fk_production_workstations-stockrooms_1]	foreign key ([consumption_stockroom_id])	references [dbo].[production_workstations]([id])
go
alter table [dbo].[production_workstations] add constraint [fk_production_workstations-stockrooms_2]	foreign key ([production_stockroom_id])		references [dbo].[production_workstations]([id])
go

-- products (MES) --
create table [dbo].[products] (
	[id]				[int] identity(1,1) not null,
	[serial_number]		[varchar](8)		not null,
	[stockroom_id]		[int]				not null
	constraint [pk_products] primary key clustered (
		[id] ASC
	)with (pad_index  = off, statistics_norecompute  = off, ignore_dup_key = off, allow_row_locks  = on, allow_page_locks  = on) on [primary]
) on [primary]
go
create unique nonclustered index [ix_products_serial_number] ON [dbo].[products] 
(
	[serial_number] asc
) with (pad_index = off, statistics_norecompute = off, sort_in_tempdb = off, ignore_dup_key = off, drop_existing = off, online = off, allow_row_locks = on, allow_page_locks = on) on [primary]
go
alter table [dbo].[products] add constraint [fk_products_stockrooms]	foreign key ([stockroom_id]) references [dbo].[stockrooms]([id])
go

-- production (MES) --
create table [dbo].[production] (
	[id]					[int] identity(1,1) not null,
	[date_time]				[datetime]			not null,
	[production_order_id]	[int]				not null,
	[workstation_id]		[int]				not null,
	[product_id]			[int]				not null,
	constraint [pk_production] primary key clustered (
		[id] ASC
	)with (pad_index  = off, statistics_norecompute  = off, ignore_dup_key = off, allow_row_locks  = on, allow_page_locks  = on) on [primary]
) on [primary]
go
alter table [dbo].[production] add constraint [df_production_date_time] default (getdate()) for [date_time]
go
alter table [dbo].[production] add constraint [fk_production-production_orders] foreign key ([production_order_id]) references [dbo].[production_orders]([id])
go
alter table [dbo].[production] add constraint [fk_production-workstations]		foreign key ([workstation_id])		references [dbo].[workstations]([id])
go
alter table [dbo].[production] add constraint [fk_production-product]			foreign key ([product_id])			references [dbo].[products]([id])
go
