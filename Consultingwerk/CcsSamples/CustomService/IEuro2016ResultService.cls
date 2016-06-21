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
    File        : IEuro2016ResultService
    Purpose     : A sample domain specific application service
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Jun 21 16:28:57 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

USING Ccs.Common.*                              FROM PROPATH.
USING Consultingwerk.CcsSamples.CustomService.* FROM PROPATH .
USING Progress.Lang.*                           FROM PROPATH .

INTERFACE Consultingwerk.CcsSamples.CustomService.IEuro2016ResultService
    INHERITS IService:

    /**
     * Purpose: Returns the match results of the given date
     * Notes:
     * @param pdtDate The date to return results from
     * @return The array of MatchResult's
     */
    METHOD PUBLIC MatchResult EXTENT GetMatchResultsByDate (pdtDate AS DATE).

    /**
     * Purpose: Returns the match results of the given team
     * Notes:
     * @param poTeam The team to return results from
     * @return The array of MatchResult's
     */
    METHOD PUBLIC MatchResult EXTENT GetMatchResultsByTeam (poTeam AS TeamEnum).

    /**
     * Purpose: Returns the match results of the given team
     * Notes:
     * @param poTeam The team to return results from
     * @return The array of MatchResult's
     */
    METHOD PUBLIC MatchResult EXTENT GetTodaysMatchResults ().

END INTERFACE.
