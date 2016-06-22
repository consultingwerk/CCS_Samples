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

USING Consultingwerk.* FROM PROPATH.
USING Consultingwerk.CcsSamples.Framework.BusinessLogic.* FROM PROPATH.
USING Consultingwerk.CcsSamples.CustomService.* FROM PROPATH.
USING Ccs.BusinessLogic.* FROM PROPATH.
USING Consultingwerk.CcsSamples.StartupManager.* FROM PROPATH .
USING Ccs.Common.*                               FROM PROPATH.

BLOCK-LEVEL ON ERROR UNDO, THROW.

/* ***************************  Main Block  *************************** */

Application:StartupManager = NEW StartupManager() .
Application:StartupManager:initialize() .

