
CREATE PROC [dbo].[Newsletters_Query_Paged]
			@PageIndex int
			,@PageSize int
			,@Query nvarchar(100)
AS

/*******************TEST CODE*******************

DECLARE @PageIndex int = 0
		,@PageSize int = 10
		,@Query nvarchar(100) = 'visa'

EXECUTE [dbo].[Newsletters_Query_Paged]
		@PageIndex
		,@PageSize 
		,@query

***********************************************/

BEGIN

	DECLARE @offset int = @PageIndex * @PageSize

	SELECT [N].[Id]
		  ,[NT].[Id] as 'TemplateId'
		  ,[N].[Name]
		  ,[N].CoverPhoto
		  ,[DateToPublish]
		  ,[DateToExpire]
		  ,[N].[DateCreated]
		  ,[N].[DateModified]
		  ,[U].[Id] as 'CreatedBy'
		  ,[TotalCount] = COUNT(1) OVER()

	  FROM [dbo].[Newsletters] as N
		inner join [dbo].[NewsletterTemplates] as NT
			ON [N].[TemplateId] = [NT].[Id]
		inner join [dbo].[Users] as U
			ON [N].[CreatedBy] = [U].[Id]
	  WHERE (N.Name LIKE '%' + @Query + '%') 

	  ORDER BY N.Id

		OFFSET @offSet Rows
		Fetch Next @PageSize Rows ONLY

END
