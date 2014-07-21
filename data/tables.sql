set ansi_nulls on
go

set quoted_identifier on
go

set ansi_padding on
go

/* drop tables */

if exists (select name from sys.objects where name = N'human_resources_messages') drop table [human_resources_messages]
go

/* create tables */

-- human_resources_messages --
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
