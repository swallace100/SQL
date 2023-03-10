
CREATE PROC [dbo].[Newsletters_Insert_Composite]
	@TemplateId int
	,@Name nvarchar(100)
	,@CoverPhoto nvarchar(255)
	,@DateToPublish datetime2(7)
	,@DateToExpire datetime2(7)
	,@CreatedBy int
	,@Id int OUTPUT
	,@BatchTable dbo.NewsletterContent_UDT READONLY

AS

/*******************TEST CODE*******************

DECLARE @BatchTable dbo.NewsletterContent_UDT

INSERT INTO @BatchTable
 VALUES(1, 1, 'title')

DECLARE @Id int = 0;

DECLARE  @TemplateId int = 1
		,@Name nvarchar(100) = 'template 1'
		,@CoverPhoto nvarchar(255) = 'coverphoto 1'
		,@DateToPublish datetime2(7) = '2023-3-1 12:00:00'
		,@DateToExpire datetime2(7) = '2023-3-8 12:00:00'
		,@CreatedBy int = 1

EXECUTE dbo.Newsletters_Insert_Composite
			@TemplateId
			,@Name
			,@CoverPhoto
			,@DateToPublish
			,@DateToExpire
			,@CreatedBy 
			,@Id
			,@BatchTable

SELECT *
	FROM dbo.Newsletters
	Where Id = @Id

***********************************************/

BEGIN

SELECT * FROM @BatchTable

INSERT INTO dbo.Newsletters
	(
		[TemplateId]
		,[Name]
		,[CoverPhoto]
		,[DateToPublish]
		,[DateToExpire]
		,[CreatedBy]
						)

VALUES
	(
		@TemplateId
		,@Name
		,@CoverPhoto
		,@DateToPublish
		,@DateToExpire
		,@CreatedBy
						)

	SET @Id = SCOPE_IDENTITY()

-- New Content Insert
INSERT INTO dbo.NewsletterContent(
			[NewsletterId]
			,[TemplateKeyId]
			,[ContentOrder]
			,[Value]
			,[CreatedBy]
							)
SELECT

	@Id
	,bt.TemplateKeyId
	,bt.[Order]
	,bt.Content
	,@CreatedBy
	FROM @BatchTable as bt

END
