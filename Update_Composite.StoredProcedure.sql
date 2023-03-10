CREATE proc [dbo].[Newsletters_Update_Composite]
			@TemplateId int
			,@Name nvarchar(100)
			,@CoverPhoto nvarchar(255)
			,@DateToPublish datetime2(7)
			,@DateToExpire datetime2(7)
			,@CreatedBy int
			,@Id int 
			,@BatchTable dbo.NewsletterContentUpdate_UDT READONLY
		
/*-------------- TEST CODE ------------------------------------
DECLARE @BatchTable dbo.NewsletterContentUpdate_UDT
DECLARE @Id int = 4;

INSERT INTO @BatchTable
 VALUES(25, 6, 5, 'Migrately Newsletters')

DECLARE  @TemplateId int = 1
		,@Name nvarchar(100) = 'Migrately Updates'
		,@CoverPhoto nvarchar(255) = 'https://images.unsplash.com/photo-1522199873717-bc67b1a5e32b?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2072&q=80'
		,@DateToPublish datetime2(7) = '2023-1-10 12:00:00'
		,@DateToExpire datetime2(7) = '2024-3-8 12:00:00'
		,@CreatedBy int = 1

SELECT *
	FROM [dbo].[Newsletters]
	WHERE Id = @Id
		
EXECUTE dbo.Newsletters_Update_Composite
	@TemplateId
	,@Name
	,@CoverPhoto
	,@DateToPublish
	,@DateToExpire
	,@CreatedBy
	,@Id
	,@BatchTable

SELECT *
FROM [dbo].[Newsletters] 
WHERE Id = @Id

*/--------------------------------------------------------------

As

BEGIN

DECLARE @DateModified datetime2 = getutcdate();

UPDATE [dbo].Newsletters
	SET [TemplateId] = @TemplateId
		,[Name] = @Name
		,[CoverPhoto] = @CoverPhoto
		,[DateToPublish] = @DateToPublish
		,[DateToExpire] = @DateToExpire
		,[CreatedBy] = @CreatedBy
		,[DateModified] = @DateModified
	WHERE Id = @Id

UPDATE dbo.NewsletterContent
	SET	 [NewsletterId] = @Id 
		,[TemplateKeyId] = bt.TemplateKeyId
		,[ContentOrder] = bt.[Order]
		,[Value] = bt.Content
		,[CreatedBy] = @CreatedBy
	FROM @BatchTable as bt
	WHERE dbo.NewsletterContent.Id = bt.Id

END
