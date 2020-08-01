SELECT @PolicyModelID = [PolicyModelID]
FROM [fn_rbac_DeploymentSummary]([dbo].[fn_LShortNameToLCID]( @LocaleID), @UserSIDs)
WHERE [AssignmentID] = @AssignmentID;

SELECT *
INTO ##Deployment0
FROM (
	SELECT [AppState].[MachineName]
		,umr.UniqueUserName
		,usr.Full_User_Name0 AS 'Display Name'
		,usr.company0 AS 'Company'
		,usr.title0 AS 'Title'
		,[AppState].[ExtendedInfoDescriptionID]
		,[AppState].[StatusType]
		,NULL AS [ErrorCode]
		,[AppState].[EnforcementState]
		,[AppState].[IsMachineChangesPersisted]
		,[cs].[ClientStateDescription]
	FROM [fn_rbac_AppDeploymentAssetDetails]([dbo].[fn_LShortNameToLCID]( @LocaleID), @UserSIDs) [AppState]
	LEFT OUTER JOIN [dbo].[v_CH_ClientSummary] [cs] ON [AppState].[MachineID] = [cs].[ResourceID]
	INNER JOIN UserMachineRelation umr ON umr.MachineResourceID = AppState.MachineID
	INNER JOIN v_r_user usr ON usr.Unique_User_Name0 = umr.UniqueUserName
	WHERE ([AppState].[PolicyModelID] = @PolicyModelID)
		AND ([AppState].[AssignmentID] = @AssignmentID)
		AND ([AppState].[StatusType] = [AppState].[AppStatusType])
		AND ([AppState].[StatusType] <> 5)
	
	UNION ALL
	
	SELECT [AppState].[MachineName]
		,umr.UniqueUserName
		,usr.Full_User_Name0 AS 'Display Name'
		,usr.company0 AS 'Company'
		,usr.title0 AS 'Title'
		,[AppState].[ExtendedInfoDescriptionID]
		,[AppState].[StatusType]
		,NULL AS [ErrorCode]
		,[AppState].[EnforcementState]
		,[AppState].[IsMachineChangesPersisted]
		,[cs].[ClientStateDescription]
	FROM [fn_rbac_AppDeploymentRNMAssetDetails]([dbo].[fn_LShortNameToLCID]( @LocaleID), @UserSIDs) [AppState]
	LEFT OUTER JOIN [dbo].[v_CH_ClientSummary] [cs] ON [AppState].[MachineID] = [cs].[ResourceID]
	INNER JOIN UserMachineRelation umr ON umr.MachineResourceID = AppState.MachineID
	INNER JOIN v_r_user usr ON usr.Unique_User_Name0 = umr.UniqueUserName
	WHERE ([AppState].[PolicyModelID] = @PolicyModelID)
		AND ([AppState].[AssignmentID] = @AssignmentID)
		AND ([AppState].[StatusType] = [AppState].[AppStatusType])
		AND ([AppState].[StatusType] <> 5)
	
	UNION ALL
	
	SELECT [AppState].[MachineName]
		,umr.UniqueUserName
		,usr.Full_User_Name0 AS 'Display Name'
		,usr.company0 AS 'Company'
		,usr.title0 AS 'Title'
		,0 AS [ExtendedInfoDescriptionID]
		,4 AS [StatusType]
		,NULL AS [ErrorCode]
		,4000 AS [EnforcementState]
		,[AppState].[IsMachineChangesPersisted]
		,[cs].[ClientStateDescription]
	FROM [fn_rbac_CIDeploymentUnknownAssetDetails]([dbo].[fn_LShortNameToLCID]( @LocaleID), @UserSIDs) [AppState]
	LEFT OUTER JOIN [dbo].[v_CH_ClientSummary] [cs] ON [AppState].[MachineID] = [cs].[ResourceID]
	INNER JOIN UserMachineRelation umr ON umr.MachineResourceID = AppState.MachineID
	INNER JOIN v_r_user usr ON usr.Unique_User_Name0 = umr.UniqueUserName
	WHERE ([AppState].[PolicyModelID] = @PolicyModelID)
		AND ([AppState].[AssignmentID] = @AssignmentID)
	
	UNION ALL
	
	SELECT [AppState].[MachineName]
		,umr.UniqueUserName
		,usr.Full_User_Name0 AS 'Display Name'
		,usr.company0 AS 'Company'
		,usr.title0 AS 'Title'
		,[AppState].[ExtendedInfoDescriptionID]
		,[AppState].[StatusType]
		,[AppState].[ErrorCode]
		,[AppState].[EnforcementState]
		,[AppState].[IsMachineChangesPersisted]
		,[cs].[ClientStateDescription]
	FROM [fn_rbac_AppDeploymentErrorAssetDetails]([dbo].[fn_LShortNameToLCID]( @LocaleID), @UserSIDs) [AppState]
	LEFT OUTER JOIN [dbo].[v_CH_ClientSummary] [cs] ON [AppState].[MachineID] = [cs].[ResourceID]
	INNER JOIN UserMachineRelation umr ON umr.MachineResourceID = AppState.MachineID
	INNER JOIN v_r_user usr ON usr.Unique_User_Name0 = umr.UniqueUserName
	WHERE ([AppState].[PolicyModelID] = @PolicyModelID)
		AND ([AppState].[AssignmentID] = @AssignmentID)
		AND ([AppState].[StatusType] = [AppState].[AppStatusType])
		AND (
			[AppState].[ErrorCode] IS NOT NULL
			AND [AppState].[StatusType] = 5
			)
	) AS [tmp];

SELECT DISTINCT *
	,CASE [dt].[StatusType]
		WHEN 1
			THEN 'Compliant'
		WHEN 2
			THEN 'In_Progress'
		WHEN 3
			THEN 'Requirements_Not_Met'
		WHEN 4
			THEN 'Unknown'
		WHEN 5
			THEN 'Error'
		END AS [Status]
FROM ##deployment0 [dt]
ORDER BY [dt].[StatusType]
	,[dt].[EnforcementState]
	,[dt].[ErrorCode]
	,[dt].[MachineName];

DROP TABLE ##Deployment0;
