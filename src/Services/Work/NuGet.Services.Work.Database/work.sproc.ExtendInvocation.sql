﻿CREATE PROCEDURE [work].[ExtendInvocation]
	@Id uniqueidentifier,
	@Version int,
	@ExtendTo datetime2,
	@InstanceName nvarchar(100)
AS
	-- Add a new row for the specified Invocation indicating its new visibility time
	INSERT INTO [private].InvocationsStore(
			[Id],
            [Job],
            [Source],
            [Payload],
            [Status],
            [Result],
            [ResultMessage],
            [UpdatedBy],
            [LogUrl],
            [DequeueCount],
            [IsContinuation],
            [Complete],
            [LastDequeuedAt],
            [LastSuspendedAt],
            [CompletedAt],
            [QueuedAt],
            [NextVisibleAt],
            [UpdatedAt])
	OUTPUT	inserted.*
	SELECT	Id,
			Job, 
			Source, 
			Payload, 
			[Status],
			[Result],
            [ResultMessage],
			@InstanceName AS [UpdatedBy],
            [LogUrl],
			DequeueCount,
			IsContinuation,
			Complete,
            [LastDequeuedAt],
            [LastSuspendedAt],
            [CompletedAt],
			QueuedAt,
			@ExtendTo AS [NextVisibleAt],
			SYSUTCDATETIME() AS [UpdatedAt]
	FROM	[work].ActiveInvocations
	WHERE	[Id] = @Id AND [Version] = @Version