/**********************************************************************
 * Copyright (C) 2006-2016 by Consultingwerk Ltd. ("CW") -            *
 * www.consultingwerk.de and other contributors as listed             *
 * below.  All Rights Reserved.                                       *
 *                                                                    *
 *  Software is distributed on an "AS IS", WITHOUT WARRANTY OF ANY    *
 *   KIND, either express or implied.                                 *
 *                                                                    *
 *  Contributors:                                                     *
 *                                                                    *
 **********************************************************************/
/*------------------------------------------------------------------------
    File        : invoke-custom-service.p
    Purpose     :

    Syntax      :

    Description :

    Author(s)   :
    Created     : Wed Jun 22 11:21:32 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

BLOCK-LEVEL ON ERROR UNDO, THROW.

USING Ccs.Common.*                              FROM PROPATH.
USING Consultingwerk.CcsSamples.CustomService.* FROM PROPATH.

DEFINE VARIABLE oMatchesService AS IEuro2016ResultService NO-UNDO .
DEFINE VARIABLE i               AS INTEGER                NO-UNDO .
DEFINE VARIABLE oResults        AS MatchResult EXTENT .

/* ***************************  Main Block  *************************** */

RUN Consultingwerk/CcsSamples/boot.p .

oMatchesService = CAST (Application:ServiceManager:getService(GET-CLASS (IEuro2016ResultService)),
                        IEuro2016ResultService) .

oResults = oMatchesService:GetTodaysMatchResults().

// oResults = oMatchesService:GetMatchResultsByTeam(TeamEnum:Germany) .

MESSAGE "today:" EXTENT (oResults)
    VIEW-AS ALERT-BOX.

DO i = 1 TO EXTENT (oResults):
    MESSAGE oResults[i]:ToString()
        VIEW-AS ALERT-BOX.
END.

EXTENT (oResults) = ? .

oResults = oMatchesService:GetMatchResultsByDate(7/10/2016).

MESSAGE "final (7/10/2016):" EXTENT (oResults)
    VIEW-AS ALERT-BOX.

DO i = 1 TO EXTENT (oResults):
    MESSAGE oResults[i]:ToString()
        VIEW-AS ALERT-BOX.
END.

// Error handling
CATCH apperr AS Progress.Lang.AppError :
    MESSAGE apperr:GetMessage(1) SKIP
            apperr:ReturnValue         SKIP (2)
            apperr:CallStack
        VIEW-AS ALERT-BOX.
END CATCH.

CATCH err AS Progress.Lang.Error :
    MESSAGE err:GetMessage(1)       SKIP (2)
            err:CallStack

        VIEW-AS ALERT-BOX.
END CATCH.
