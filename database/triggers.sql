USE EventFlow;
GO

--Trigger som uppdaterar en viss kolumn i evenemangtabellen, och visar tid för senast uppdatering varje gång en rad uppdateras

CREATE TRIGGER update_timestamp ON Events
AFTER UPDATE
AS
	UPDATE Events
	SET UppdateradSenast = SYSDATETIME()
	FROM inserted i
	WHERE Events.EvenemangId = i.EvenemangId;
GO