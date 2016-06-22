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
    File        : QueryBuilder
    Purpose     : Turns a list of query entries into a query string
    Syntax      : Does currently not take joined data-sources into account
                  (data-source using a query with 2 or more buffers)
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Jun 22 02:35:45 CEST 2016
    Notes       : Currently InList and InRange operators are not optimized
                  in the way that we should AND/OR the current query group
                  A AND InList(10,20) now becomes
                  A AND (B = 10 OR B = 20) but when returning
                  (A AND B = 10) OR (A AND B = 20) a better index selection
                  would be performed
  ----------------------------------------------------------------------*/

ROUTINE-LEVEL ON ERROR UNDO, THROW.

USING Ccs.BusinessLogic.*                        FROM PROPATH.
USING Ccs.Common.Support.*                       FROM PROPATH .
USING Consultingwerk.CcsSamples.BusinessEntity.* FROM PROPATH .
USING Progress.Lang.*                            FROM PROPATH .

CLASS Consultingwerk.CcsSamples.BusinessEntity.QueryBuilder:

    /**
     * Purpose: Returns the ABL Query String for the abstract query
     * Notes:   Does currently not take joined data-sources into account (data-source using a query with 2 or more buffers)
     * @param pcTableName The name of the table
     * @param poQueryDefinition The IQueryDefinition that describes the query
     */
    METHOD PUBLIC CHARACTER BuildQueryString (pcTableName AS CHARACTER,
                                              poQueryDefinition AS IQueryDefinition):

        DEFINE VARIABLE cQueryString AS CHARACTER NO-UNDO.


        IF VALID-OBJECT (poQueryDefinition:QuerySelection) THEN
            ASSIGN cQueryString = SUBSTITUTE ("for each &1 where", pcTableName) .
        ELSE
            ASSIGN cQueryString = SUBSTITUTE ("for each &1", pcTableName) .

        IF TYPE-OF (poQueryDefinition:QuerySelection, IQueryGroup) THEN
            ASSIGN cQueryString = THIS-OBJECT:FromQueryGroup (cQueryString, CAST (poQueryDefinition:QuerySelection, IQueryGroup), TRUE) .
        ELSE
            ASSIGN cQueryString = THIS-OBJECT:FromQueryPredicate (cQueryString, CAST (poQueryDefinition:QuerySelection, IQueryPredicate)) .

        RETURN cQueryString .

    END METHOD.

    /**
     * Purpose:
     * Notes:
     *
     */
    METHOD PROTECTED CHARACTER FromQueryGroup (pcQueryString AS CHARACTER,
                                               poQueryGroup AS IQueryGroup,
                                               plOutermost AS LOGICAL):

        DEFINE VARIABLE i AS INTEGER NO-UNDO.

        IF VALID-OBJECT (poQueryGroup:Join) THEN
            ASSIGN pcQueryString = pcQueryString + RIGHT-TRIM (SUBSTITUTE (" &1", THIS-OBJECT:OperatorFromJoin (poQueryGroup:Join))) .

        IF NOT plOutermost THEN
            ASSIGN pcQueryString = pcQueryString + " (":U .

        DO i = 1 TO EXTENT (poQueryGroup:Entries):

            IF TYPE-OF (poQueryGroup:Entries[i], IQueryGroup) THEN
                ASSIGN pcQueryString = THIS-OBJECT:FromQueryGroup (pcQueryString, CAST (poQueryGroup:Entries[i], IQueryGroup), FALSE) .
            ELSE
                ASSIGN pcQueryString = THIS-OBJECT:FromQueryPredicate (pcQueryString, CAST (poQueryGroup:Entries[i], IQueryPredicate)) .

        END.

        IF NOT plOutermost THEN
            ASSIGN pcQueryString = pcQueryString + ")":U .

        RETURN pcQueryString .

    END METHOD.

    /**
     * Purpose:
     * Notes:
     *
     */
    METHOD PROTECTED CHARACTER FromQueryPredicate (pcQueryString AS CHARACTER,
                                                   poQueryPredicate AS IQueryPredicate):

        DEFINE VARIABLE cOperatorString AS CHARACTER NO-UNDO INIT "=":U.

        ASSIGN cOperatorString = UPPER (poQueryPredicate:Operator:ToString()) .

        IF VALID-OBJECT (poQueryPredicate:Join) THEN
            ASSIGN pcQueryString = pcQueryString + RIGHT-TRIM (SUBSTITUTE (" &1", THIS-OBJECT:OperatorFromJoin (poQueryPredicate:Join))) .

        IF poQueryPredicate:Operator = QueryOperatorEnum:InList THEN
            UNDO, THROW NEW AppError ("InList operator not yet supported", 0) .
        ELSE IF poQueryPredicate:Operator = QueryOperatorEnum:InRange THEN
            UNDO, THROW NEW AppError ("InList operator not yet supported", 0) .
        ELSE
            ASSIGN pcQueryString = pcQueryString + SUBSTITUTE (" &1 &2 &3",
                                                               poQueryPredicate:FieldName,
                                                               cOperatorString,
                                                               THIS-OBJECT:QueryValue(poQueryPredicate:Value)) .

        RETURN pcQueryString .

    END METHOD.
    /**
     * Purpose:
     * Notes:
     *
     */
    METHOD PROTECTED CHARACTER OperatorFromJoin (poJoin AS JoinEnum):

        CASE poJoin:

            WHEN JoinEnum:And THEN
                RETURN "AND" .
            WHEN JoinEnum:AndNot THEN
                RETURN "AND NOT" .
            WHEN JoinEnum:Not THEN
                RETURN "NOT" .
            WHEN JoinEnum:Or THEN
                RETURN "OR" .
            WHEN JoinEnum:OrNot THEN
                RETURN "OR NOT" .
            OTHERWISE
                RETURN "".

        END CASE.

    END METHOD.

    /**
     * Purpose: Returns the (quoted) query string value
     * Notes:
     *
     */
    METHOD PUBLIC CHARACTER QueryValue (poPrimitiveHolder AS IPrimitiveHolder):

        IF TYPE-OF (poPrimitiveHolder, ICharacterHolder) THEN
            RETURN QUOTER (CAST (poPrimitiveHolder, ICharacterHolder):Value) .

        IF TYPE-OF (poPrimitiveHolder, IDateHolder) THEN
            RETURN QUOTER (CAST (poPrimitiveHolder, IDateHolder):Value) .

        IF TYPE-OF (poPrimitiveHolder, IDateTimeHolder) THEN
            RETURN QUOTER (CAST (poPrimitiveHolder, IDateTimeHolder):Value) .

        IF TYPE-OF (poPrimitiveHolder, IDateTimeTzHolder) THEN
            RETURN QUOTER (CAST (poPrimitiveHolder, IDateTimeTzHolder):Value) .

        IF TYPE-OF (poPrimitiveHolder, IDecimalHolder) THEN
            RETURN STRING (CAST (poPrimitiveHolder, IDecimalHolder):Value) .

        IF TYPE-OF (poPrimitiveHolder, IInt64Holder) THEN
            RETURN STRING (CAST (poPrimitiveHolder, IInt64Holder):Value) .

        IF TYPE-OF (poPrimitiveHolder, IIntegerHolder) THEN
            RETURN STRING (CAST (poPrimitiveHolder, IIntegerHolder):Value) .

        IF TYPE-OF (poPrimitiveHolder, ILogicalHolder) THEN
            RETURN STRING (CAST (poPrimitiveHolder, ILogicalHolder):Value) .

        IF TYPE-OF (poPrimitiveHolder, ILongcharHolder) THEN
            RETURN QUOTER (STRING(CAST (poPrimitiveHolder, ILongcharHolder):Value)) .

        IF TYPE-OF (poPrimitiveHolder, IRowidHolder) THEN
            RETURN SUBSTITUTE ("TO-ROWID(&1)", QUOTER (CAST (poPrimitiveHolder, IRowidHolder):Value)) .

        UNDO, THROW NEW AppError (SUBSTITUTE ("Unsupported primitive holder type: &1", poPrimitiveHolder:GetClass():TypeName), 0) .

    END METHOD.

END CLASS.
