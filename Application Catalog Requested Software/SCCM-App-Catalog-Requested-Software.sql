SELECT app.RequestID AS 'ReqID'
,usr.ResourceID AS 'UserResourceID'
,(
SELECT DisplayName
FROM fn_ListApplicationCIs(1033)
WHERE ModelName = app.AppID
AND IsLatest = 1
) AS 'Requested Software'
,umr.UniqueUserName AS 'User'
,usr.Full_User_Name0 AS 'Display Name'
,usr.company0 AS 'Company'
,usr.department0 AS 'Department'
,usr.title0 AS 'Title'
,usr.telephoneNumber0 AS 'Phone'
,comp.Name0 AS 'Computer Name'
,app.CreationTime AS 'Request Date'
FROM UserAppModelSoftwareRequest app
JOIN UserMachineRelation umr ON app.RelationshipResourceID = umr.RelationshipResourceID
JOIN v_r_user usr ON usr.Unique_User_Name0 = umr.UniqueUserName
JOIN v_R_System comp ON umr.MachineResourceID = comp.ResourceID
ORDER BY 'Request Date'
