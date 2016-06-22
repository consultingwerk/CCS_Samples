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
    File        : DatasetHelper
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike
    Created     : Wed Jun 22 16:35:03 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

BLOCK-LEVEL ON ERROR UNDO, THROW.

USING Progress.Json.ObjectModel.* FROM PROPATH.
USING Consultingwerk.Util.* FROM PROPATH .
USING Progress.Lang.*       FROM PROPATH .

CLASS Consultingwerk.Util.DatasetHelper:

    /**
     * Purpose:
     * Notes:
     *
     */
    METHOD PUBLIC STATIC VOID AddErrorString (phBuffer AS HANDLE,
                                              pcErrorMessage AS CHARACTER):

        DatasetHelper:AddErrorString(phBuffer, pcErrorMessage, "":U) .

    END METHOD.

    /**
     * Purpose:
     * Notes:
     *
     */
    METHOD PUBLIC STATIC VOID AddErrorString (phBuffer AS HANDLE,
                                              pcErrorMessage AS CHARACTER,
                                              pcFieldName AS CHARACTER):

        ASSIGN phBuffer:ERROR-STRING  = DatasetHelper:AddJsonError(phBuffer:ERROR-STRING,
                                                                   pcFieldName,
                                                                   ArrayHelper:Array(pcErrorMessage))
               phBuffer:ERROR         = TRUE
               phBuffer:DATASET:ERROR = TRUE .

    END METHOD.

    /**
     * Purpose:
     * Notes:
     *
     */
    METHOD PUBLIC STATIC CHARACTER AddJsonError (pcErrorString        AS CHARACTER,
                                                 pcFieldName          AS CHARACTER,
                                                 pcMessageStrings     AS CHARACTER EXTENT,
                                                 piMessageId          AS INTEGER,
                                                 pcMessageGroup       AS CHARACTER,
                                                 pcSubstitutionValues AS CHARACTER EXTENT):

        DEFINE VARIABLE oJson         AS JsonArray         NO-UNDO .
        DEFINE VARIABLE oObjectModel  AS ObjectModelParser NO-UNDO .
        DEFINE VARIABLE cReturn       AS CHARACTER         NO-UNDO .

        IF pcErrorString > "" THEN DO:
            oObjectModel = NEW ObjectModelParser () .

            oJson = CAST (oObjectModel:Parse (pcErrorString), JsonArray).
        END .
        ELSE
            oJson = NEW JsonArray () .

        DatasetHelper:AddJsonError (oJson, pcFieldName, pcMessageStrings, piMessageId, pcMessageGroup, pcSubstitutionValues) .

        oJson:WRITE (OUTPUT cReturn, TRUE) .

        RETURN cReturn .

    END METHOD.


    /**
     * Purpose:
     * Notes:
     *
     */
    METHOD PUBLIC STATIC CHARACTER AddJsonError (pcErrorString        AS CHARACTER,
                                                 pcFieldName          AS CHARACTER,
                                                 piMessageId          AS INTEGER,
                                                 pcMessageGroup       AS CHARACTER,
                                                 pcSubstitutionValues AS CHARACTER EXTENT):

        DEFINE VARIABLE cMessageStrings     AS CHARACTER NO-UNDO EXTENT 1 INIT ?.

        RETURN DatasetHelper:AddJsonError (pcErrorString, pcFieldName, cMessageStrings, piMessageId, pcMessageGroup, pcSubstitutionValues) .

    END METHOD .

    /**
     * Purpose:
     * Notes:
     *
     */
    METHOD PUBLIC STATIC CHARACTER AddJsonError (pcErrorString    AS CHARACTER,
                                                 pcFieldName      AS CHARACTER,
                                                 pcMessageStrings AS CHARACTER EXTENT,
                                                 piMessageId      AS INTEGER,
                                                 pcMessageGroup   AS CHARACTER):

        DEFINE VARIABLE cSubstitutionValues AS CHARACTER NO-UNDO EXTENT 1 INIT ?.

        RETURN DatasetHelper:AddJsonError (pcErrorString, pcFieldName, pcMessageStrings, piMessageId, pcMessageGroup, cSubstitutionValues) .

    END METHOD.

    /**
     * Purpose:
     * Notes:
     *
     */
    METHOD PUBLIC STATIC CHARACTER AddJsonError (pcErrorString  AS CHARACTER,
                                                 pcFieldName    AS CHARACTER,
                                                 pcMessageStrings AS CHARACTER EXTENT):

        DEFINE VARIABLE cSubstitutionValues AS CHARACTER NO-UNDO EXTENT 1 INIT ?.

        RETURN DatasetHelper:AddJsonError (pcErrorString, pcFieldName, pcMessageStrings, ?, ?, cSubstitutionValues) .

    END METHOD.

    /**
     * Purpose:
     * Notes:
     *
     */
    METHOD PUBLIC STATIC CHARACTER AddJsonError (pcErrorString  AS CHARACTER,
                                                 pcFieldName    AS CHARACTER,
                                                 piMessageId    AS INTEGER,
                                                 pcMessageGroup AS CHARACTER):

        DEFINE VARIABLE cMessageStrings     AS CHARACTER NO-UNDO EXTENT 1 INIT ?.
        DEFINE VARIABLE cSubstitutionValues AS CHARACTER NO-UNDO EXTENT 1 INIT ?.

        RETURN DatasetHelper:AddJsonError (pcErrorString, pcFieldName, cMessageStrings, piMessageId, pcMessageGroup, cSubstitutionValues) .

    END METHOD.

    /**
     * Purpose:
     * Notes:
     *
     */
    METHOD PUBLIC STATIC VOID AddJsonError (poJson               AS JsonArray,
                                            pcFieldName          AS CHARACTER,
                                            pcMessageStrings     AS CHARACTER EXTENT,
                                            piMessageId          AS INTEGER,
                                            pcMessageGroup       AS CHARACTER,
                                            pcSubstitutionValues AS CHARACTER EXTENT):

        DEFINE VARIABLE oError AS JsonObject NO-UNDO .
        DEFINE VARIABLE oArray AS JsonArray  NO-UNDO .

        oError = NEW JsonObject () .

        IF pcFieldName > "" THEN
            oError:Add ("FieldName", pcFieldName) .

        IF EXTENT (pcMessageStrings) >= 1 AND
            pcMessageStrings[1] <> ? THEN DO:

            oArray = NEW JsonArray () .
            oArray:Add(pcMessageStrings) .

            oError:Add ("MessageStrings", oArray) .
        END.

        IF piMessageId <> ? THEN
            oError:Add ("MessageId", piMessageId) .

        IF pcMessageGroup > "" THEN
            oError:Add ("MessageGroup", pcMessageGroup) .

        IF EXTENT (pcSubstitutionValues) >= 1 AND
            pcSubstitutionValues[1] <> ? THEN DO:

            oArray = NEW JsonArray () .
            oArray:Add(pcSubstitutionValues) .

            oError:Add ("SubstitutionValues", oArray) .
        END.

        poJson:Add (oError) .

    END METHOD.

END CLASS.
