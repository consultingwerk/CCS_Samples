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
    File        : MatchResult
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Jun 21 21:01:54 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

USING Consultingwerk.CcsSamples.CustomService.* FROM PROPATH .
USING Progress.Lang.*                           FROM PROPATH .

CLASS Consultingwerk.CcsSamples.CustomService.MatchResult:

    /**
     * Purpose: Returns the match date
     * Notes:
     */
    DEFINE PUBLIC PROPERTY Date AS DATE NO-UNDO
    GET.
    PRIVATE SET.

    /**
     * Purpose: Returns the score of the guest team
     * Notes:
     */
    DEFINE PUBLIC PROPERTY GuestScore AS INTEGER NO-UNDO INIT ?
    GET.
    PRIVATE SET.

    /**
     * Purpose: Returns the home team
     * Notes:
     */
    DEFINE PUBLIC PROPERTY GuestTeam AS TeamEnum NO-UNDO INIT ?
    GET.
    PRIVATE SET.

    /**
     * Purpose: Returns the score of the home team
     * Notes:
     */
    DEFINE PUBLIC PROPERTY HomeScore AS INTEGER NO-UNDO
    GET.
    PRIVATE SET.

    /**
     * Purpose: Returns the home team
     * Notes:
     */
    DEFINE PUBLIC PROPERTY HomeTeam AS TeamEnum NO-UNDO
    GET.
    PRIVATE SET.

    /**
     * Purpose: Returns the match location
     * Notes:
     */
    DEFINE PUBLIC PROPERTY Location AS LocationEnum NO-UNDO
    GET.
    PRIVATE SET.

    /**
     * Purpose: Returns the match order
     * Notes:
     */
    DEFINE PUBLIC PROPERTY Order AS INTEGER NO-UNDO
    GET.
    PRIVATE SET.

    /**
     * Purpose: Returns the match location
     * Notes:
     */
    DEFINE PUBLIC PROPERTY Stage AS StageEnum NO-UNDO
    GET.
    PRIVATE SET.

    /**
     * Purpose: Returns a string representation
     * Notes:
     *
     * @return CHARACTER
     */
    METHOD PUBLIC OVERRIDE CHARACTER ToString():

        DEFINE VARIABLE cReturn AS CHARACTER NO-UNDO.

        ASSIGN cReturn = SUBSTITUTE ("Game &1, Date: &2, Location: &3, Stage: &4",
                                     THIS-OBJECT:Order,
                                     THIS-OBJECT:Date,
                                     THIS-OBJECT:Location,
                                     THIS-OBJECT:Stage:ToString()) .

        IF VALID-OBJECT (THIS-OBJECT:HomeTeam) OR
           VALID-OBJECT (THIS-OBJECT:GuestTeam) THEN DO:

            IF VALID-OBJECT (THIS-OBJECT:HomeTeam) AND VALID-OBJECT (THIS-OBJECT:GuestTeam) THEN
                ASSIGN cReturn = cReturn + SUBSTITUTE ("~n&1 vs &2",
                                                       THIS-OBJECT:HomeTeam:ToString(),
                                                       THIS-OBJECT:GuestTeam:ToString()) .
            ELSE
                IF VALID-OBJECT (THIS-OBJECT:HomeTeam) THEN
                    ASSIGN cReturn = cReturn + SUBSTITUTE ("~n&1 vs ???",
                                                           THIS-OBJECT:HomeTeam:ToString()) .
            ELSE
                ASSIGN cReturn = cReturn + SUBSTITUTE ("~n&1 vs ???",
                                                       THIS-OBJECT:GuestTeam:ToString()) .
        END.

        IF THIS-OBJECT:HomeScore <> ? AND THIS-OBJECT:GuestScore <> ? THEN DO:

            ASSIGN cReturn = cReturn + SUBSTITUTE ("~n&1:&2 (&3)",
                                                   THIS-OBJECT:HomeScore,
                                                   THIS-OBJECT:GuestScore,
                                                   (IF THIS-OBJECT:HomeScore > THIS-OBJECT:GuestScore
                                                    THEN THIS-OBJECT:HomeTeam:ToString() ELSE
                                                    (IF THIS-OBJECT:GuestScore > THIS-OBJECT:HomeScore
                                                    THEN THIS-OBJECT:GuestTeam:ToString() ELSE "Tie"))) .
        END.

        RETURN cReturn .

    END METHOD.

    /**
     * Purpose: Constructor for the MatchResult class
     * Notes:
     *
     */
    CONSTRUCTOR PUBLIC MatchResult (phBuffer AS HANDLE):

        ASSIGN THIS-OBJECT:Order      = phBuffer::Order
               THIS-OBJECT:Location   = LocationEnum:GetEnum (phBuffer::Location)
               THIS-OBJECT:Date       = phBuffer::Date
               THIS-OBJECT:HomeScore  = phBuffer::HomeScore
               THIS-OBJECT:GuestScore = phBuffer::GuestScore
               THIS-OBJECT:Stage      = StageEnum:GetEnum (phBuffer::Stage) .

        IF phBuffer::HomeTeam > "" THEN
            THIS-OBJECT:HomeTeam = TeamEnum:GetEnum (STRING (phBuffer::HomeTeam)) .

        IF phBuffer::GuestTeam > "" THEN
            THIS-OBJECT:GuestTeam = TeamEnum:GetEnum (STRING (phBuffer::GuestTeam)) .

    END CONSTRUCTOR.

END CLASS.
