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
    File        : Euro2016ResultService
    Purpose     : Example for a domain specific application service
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Jun 22 01:04:29 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

BLOCK-LEVEL ON ERROR UNDO, THROW.

USING Ccs.BusinessLogic.*                                 FROM PROPATH .
USING Ccs.Common.*                                        FROM PROPATH .
USING Consultingwerk.*                                    FROM PROPATH .
USING Consultingwerk.CcsSamples.BusinessEntity.*          FROM PROPATH .
USING Consultingwerk.CcsSamples.CustomService.*           FROM PROPATH .
USING Consultingwerk.CcsSamples.Framework.BusinessLogic.* FROM PROPATH .
USING Progress.Lang.*                                     FROM PROPATH .

CLASS Consultingwerk.CcsSamples.CustomService.Euro2016ResultService
    IMPLEMENTS IEuro2016ResultService:

    {Consultingwerk/CcsSamples/BusinessEntity/Euro2016/dsMatches.i}

    /**
     * Purpose: Disposes the object instance
     * Notes:
     */
    METHOD PUBLIC VOID dispose ():

        /* noop */

    END METHOD.

    /**
     * Purpose: Returns the match results of the given date
     * Notes:
     * @param pdtDate The date to return results from
     * @return The array of MatchResult's
     */
    METHOD PUBLIC MatchResult EXTENT GetMatchResultsByDate (pdtDate AS DATE):

        DEFINE VARIABLE oMatches AS IBusinessEntity NO-UNDO .

        oMatches = CAST (Application:ServiceManager:getService(GET-CLASS (IBusinessEntity), BusinessEntities:Matches:ToString()), IBusinessEntity) .

        oMatches:getData (NEW GetDataRequest (NEW NamedQuery ("date", "date", NEW DateHolder (pdtDate))),
                          OUTPUT DATASET dsMatches BY-REFERENCE) .

        RETURN THIS-OBJECT:MatchResultExtent() .

    END METHOD.

    /**
     * Purpose: Returns the match results of the given team
     * Notes:
     * @param poTeam The team to return results from
     * @return The array of MatchResult's
     */
    METHOD PUBLIC MatchResult EXTENT GetMatchResultsByTeam (poTeam AS TeamEnum):

        DEFINE VARIABLE oMatches AS IBusinessEntity NO-UNDO .

        oMatches = CAST (Application:ServiceManager:getService(GET-CLASS (IBusinessEntity), BusinessEntities:Matches:ToString()), IBusinessEntity) .

        oMatches:getData (NEW GetDataRequest (NEW NamedQuery ("team", "team", NEW CharacterHolder (poTeam:ToString()))),
                          OUTPUT DATASET dsMatches BY-REFERENCE) .

        RETURN THIS-OBJECT:MatchResultExtent() .

    END METHOD.

    /**
     * Purpose: Returns the match results of today
     * Notes:
     * @return The array of MatchResult's
     */
    METHOD PUBLIC MatchResult EXTENT GetTodaysMatchResults ():

        DEFINE VARIABLE oMatches AS IBusinessEntity NO-UNDO .

        oMatches = CAST (Application:ServiceManager:getService(GET-CLASS (IBusinessEntity), BusinessEntities:Matches:ToString()), IBusinessEntity) .

        oMatches:getData (NEW GetDataRequest (NEW NamedQuery ("today")),
                          OUTPUT DATASET dsMatches BY-REFERENCE) .

        RETURN THIS-OBJECT:MatchResultExtent() .

    END METHOD.

    /**
     * Purpose:
     * Notes:
     *
     */
    METHOD PUBLIC VOID initialize():
        /* noop */
    END METHOD.

    /**
     * Purpose: Returns an array of match results based on the current dsMatches
     * Notes:
     * @return The MatchResult array
     */
    METHOD PRIVATE MatchResult EXTENT MatchResultExtent():

        DEFINE QUERY qQuery FOR eMatches .

        DEFINE VARIABLE oResult AS MatchResult EXTENT .
        DEFINE VARIABLE i       AS INTEGER NO-UNDO.

        OPEN QUERY qQuery PRESELECT EACH eMatches .

        IF QUERY qQuery:NUM-RESULTS > 0 THEN DO:

            EXTENT (oResult) = QUERY qQuery:NUM-RESULTS .

            GET FIRST qQuery .

            DO WHILE NOT QUERY qQuery:QUERY-OFF-END:
                ASSIGN i = i + 1
                       oResult [i] = NEW MatchResult(BUFFER eMatches:HANDLE) .

                GET NEXT qQuery .
            END.

        END.

        RETURN oResult.

    END METHOD.

END CLASS.
