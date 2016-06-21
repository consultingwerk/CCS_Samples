/*------------------------------------------------------------------------
    File        : boot.p
    Purpose     : Initiates the framework bootstrap process

    Syntax      :

    Description :

    Author(s)   :
    Created     : Tue Jun 21 13:34:26 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

USING Consultingwerk.CcsSamples.StartupManager.* FROM PROPATH .
USING Ccs.Common.*                               FROM PROPATH.

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ***************************  Main Block  *************************** */

Application:StartupManager = NEW StartupManager() .
Application:StartupManager:initialize() .

MESSAGE Application:ServiceManager
    VIEW-AS ALERT-BOX.

CATCH apperr AS Progress.Lang.AppError :
    MESSAGE apperr:GetMessage(1) SKIP
            apperr:ReturnValue
        VIEW-AS ALERT-BOX.
END CATCH.

CATCH err AS Progress.Lang.Error :
    MESSAGE err:GetMessage(1) SKIP

        VIEW-AS ALERT-BOX.
END CATCH.