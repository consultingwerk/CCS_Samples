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
    File        : OnlineEuro2016ResultService
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike
    Created     : Wed Jun 22 13:23:48 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

BLOCK-LEVEL ON ERROR UNDO, THROW.

USING Consultingwerk.CcsSamples.CustomService.* FROM PROPATH .
USING Progress.Json.ObjectModel.*               FROM PROPATH .
USING Progress.Lang.*                           FROM PROPATH .
USING OpenEdge.Net.HTTP.*                       FROM PROPATH .

CLASS Consultingwerk.CcsSamples.CustomService.OnlineEuro2016ResultService
    IMPLEMENTS IEuro2016ResultService:

    {Consultingwerk/CcsSamples/BusinessEntity/Euro2016/dsMatches.i}

    /**
     * Purpose:
     * Notes:
     *
     */
    CONSTRUCTOR PUBLIC OnlineEuro2016ResultService():

        // noop

    END CONSTRUCTOR.


    /**
     * Purpose: Gets/refreshes the match results
     * Notes:   See http://api.football-data.org/v1/soccerseasons/424/fixtures and
     *          http://api.football-data.org/index for details
     */
    METHOD PUBLIC VOID getResults():

        DEFINE VARIABLE oRequest  AS IHttpRequest  NO-UNDO .
        DEFINE VARIABLE oResponse AS IHttpResponse NO-UNDO .
        DEFINE VARIABLE oJson     AS JsonObject    NO-UNDO .
        DEFINE VARIABLE oFixtures AS JsonArray     NO-UNDO .
        DEFINE VARIABLE oFixture  AS JsonObject    NO-UNDO .
        DEFINE VARIABLE oResult   AS JsonObject    NO-UNDO .
        DEFINE VARIABLE i         AS INTEGER       NO-UNDO .
        DEFINE VARIABLE iCount    AS INTEGER       NO-UNDO .

        DATASET dsMatches:EMPTY-DATASET() .

        ASSIGN
            oRequest  = RequestBuilder:Get("http://api.football-data.org/v1/soccerseasons/424/fixtures":U):AcceptJson():Request
            oResponse = ClientBuilder:Build():Client:Execute(oRequest).

        ASSIGN
            oJson     = CAST (oResponse:Entity, JsonObject)
            oFixtures = oJson:GetJsonArray("fixtures":U)
            iCount    = oFixtures:Length .

        DO i = 1 TO iCount:

            oFixture = oFixtures:GetJsonObject(i) .

            CREATE eMatches .
            ASSIGN eMatches.Order     = 1
                   eMatches.Date      = DATE (oFixture:GetDatetime("date":U))
                   eMatches.HomeTeam  = REPLACE (oFixture:GetCharacter("homeTeamName":U), " ", "")
                   eMatches.GuestTeam = REPLACE (oFixture:GetCharacter("awayTeamName":U), " ", "")
                   eMatches.Location  = "paris" // cheating here, as the web service does not return the location
                .

            IF eMatches.Date < 6/25/2016 THEN
                eMatches.Stage = StageEnum:Group:ToString() .
            ELSE IF eMatches.Date < 6/30/2016 THEN
                eMatches.Stage = StageEnum:RoundOf16:ToString() .
            ELSE IF eMatches.Date < 7/6/2016 THEN
                eMatches.Stage = StageEnum:QuarterFinal:ToString() .
            ELSE IF eMatches.Date < 7/10/2016 THEN
                eMatches.Stage = StageEnum:SemiFinal:ToString() .
            ELSE IF eMatches.Date = 7/10/2016 THEN
                eMatches.Stage = StageEnum:Final:ToString() .

            IF oFixture:Has("result":U) THEN DO:

                ASSIGN
                    oResult             = oFixture:GetJsonObject("result":U)

                    eMatches.HomeScore  = oResult:GetInteger("goalsHomeTeam")
                    eMatches.GuestScore = oResult:GetInteger("goalsAwayTeam")
                    .
            END.

        END.

    END METHOD.

    /**
     * Purpose: Returns the match results of the given date
     * Notes:
     * @param pdtDate The date to return results from
     * @return The array of MatchResult's
     */
    METHOD PUBLIC MatchResult EXTENT GetMatchResultsByDate (pdtDate AS DATE):

        DEFINE QUERY qQuery FOR eMatches .

        OPEN QUERY qQuery PRESELECT EACH eMatches WHERE eMatches.Date = pdtDate .

        RETURN THIS-OBJECT:QueryResults (QUERY qQuery:HANDLE) .

    END METHOD .

    /**
     * Purpose: Returns the match results of the given team
     * Notes:
     * @param poTeam The team to return results from
     * @return The array of MatchResult's
     */
    METHOD PUBLIC MatchResult EXTENT GetMatchResultsByTeam (poTeam AS TeamEnum):

        DEFINE QUERY qQuery FOR eMatches .

        OPEN QUERY qQuery PRESELECT EACH eMatches WHERE eMatches.HomeTeam  = poTeam:ToString()
                                                     OR eMatches.GuestTeam = poTeam:ToString().

        RETURN THIS-OBJECT:QueryResults (QUERY qQuery:HANDLE) .

    END METHOD .

    /**
     * Purpose: Returns the match results of today
     * Notes:
     * @return The array of MatchResult's
     */
    METHOD PUBLIC MatchResult EXTENT GetTodaysMatchResults ():

        RETURN THIS-OBJECT:GetMatchResultsByDate (TODAY) .

    END METHOD .

    /**
     * Purpose:
     * Notes:
     *
     */
    METHOD PUBLIC VOID initialize():

        THIS-OBJECT:getResults () .

    END METHOD.

    /**
     * Purpose:
     * Notes:
     *
     */
    METHOD PROTECTED MatchResult EXTENT QueryResults (phQuery AS HANDLE):

        DEFINE VARIABLE oResult AS MatchResult EXTENT NO-UNDO .
        DEFINE VARIABLE i       AS INTEGER            NO-UNDO .

        IF phQuery:NUM-RESULTS = 0 THEN
            RETURN oResult .

        EXTENT (oResult) = phQuery:NUM-RESULTS .

        phQuery:GET-FIRST () .

        DO WHILE NOT phQuery:QUERY-OFF-END:

            ASSIGN i = i + 1
                   oResult[i] = NEW MatchResult(phQuery:GET-BUFFER-HANDLE (1)) .

            phQuery:GET-NEXT () .
        END.

        RETURN oResult .

    END METHOD.

END CLASS.
