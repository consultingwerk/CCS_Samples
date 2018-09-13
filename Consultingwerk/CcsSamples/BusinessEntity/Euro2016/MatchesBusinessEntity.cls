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
    File        : Euro2016MatchesBusinessEntity
    Purpose     : Sample for a Business Entity using an XML file as it's
                  data source
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Jun 21 21:19:43 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

BLOCK-LEVEL ON ERROR UNDO, THROW.

USING Consultingwerk.*                                           FROM PROPATH.
USING Consultingwerk.CcsSamples.BusinessEntity.Euro2016Matches.* FROM PROPATH .
USING Consultingwerk.CcsSamples.Framework.BusinessLogic.*        FROM PROPATH .
USING Ccs.BusinessLogic.*                                        FROM PROPATH  .
USING Progress.Lang.*                                            FROM PROPATH .

CLASS Consultingwerk.CcsSamples.BusinessEntity.Euro2016.MatchesBusinessEntity
    IMPLEMENTS IBusinessEntity:

    {Consultingwerk/CcsSamples/BusinessEntity/Euro2016/dsMatches.i}

    DEFINE TEMP-TABLE ttMatches NO-UNDO
        LIKE eMatches .

    // Data access query
    DEFINE QUERY qMatches FOR ttMatches .

    /**
     * Purpose: Default constructor for the MatchesBusinessEntity class
     * Notes:
     */
    CONSTRUCTOR PUBLIC MatchesBusinessEntity ():
        SUPER ().

        /* noop */

    END CONSTRUCTOR.

    /**
     * Purpose: Disposes the object instance
     * Notes:
     */
    METHOD PUBLIC VOID dispose ():

        /* noop */

    END METHOD.

    /**
     * Purpose: Opens the Data Source query
     * Notes:
     * @param poRequest The IGetDataRequest instance with the getData request parameters
     */
    METHOD PROTECTED VOID OpenQuery (poRequest AS Ccs.BusinessLogic.IGetDataRequest):

        IF NOT VALID-OBJECT (poRequest) THEN DO:
            OPEN QUERY qMatches PRESELECT EACH ttMatches .
            RETURN.
        END.

        IF VALID-OBJECT (poRequest:NamedQuery) THEN DO:
            THIS-OBJECT:OpenNamedQuery (poRequest:NamedQuery) .
        END.
        ELSE DO:

        END.

    END METHOD.

    /**
     * Purpose: Opens a named query
     * Notes:
     * @param poNamedQuery The named query parameter
     */
    METHOD PROTECTED VOID OpenNamedQuery (poNamedQuery AS INamedQuery):

        DEFINE VARIABLE oDateHolder AS DateHolder NO-UNDO .
        DEFINE VARIABLE oCharacterHolder AS CharacterHolder NO-UNDO .

        CASE poNamedQuery:Name:
            WHEN "today" THEN
                OPEN QUERY qMatches PRESELECT EACH ttMatches WHERE ttMatches.Date = TODAY .
            WHEN "date" THEN DO:

                oDateHolder = CAST (NamedQuery:ParameterValueByName(poNamedQuery, "date"), DateHolder) .

                OPEN QUERY qMatches PRESELECT EACH ttMatches WHERE ttMatches.Date = oDateHolder:Value.
            END.
            WHEN "team" THEN DO:

                oCharacterHolder = CAST (NamedQuery:ParameterValueByName(poNamedQuery, "team"), CharacterHolder) .

                OPEN QUERY qMatches PRESELECT EACH ttMatches WHERE ttMatches.HomeTeam = oCharacterHolder:Value
                                                                OR ttMatches.GuestTeam = oCharacterHolder:Value .
            END.


            OTHERWISE
                UNDO, THROW NEW AppError (SUBSTITUTE ("Invalid named query: &1", poNamedQuery:Name), 0) .
        END.

    END METHOD.

    /**
     * Purpose: Performs a read request
     * Notes:
     * @param poRequest The IGetDataRequest instance with the getData request parameters
     * @param phDataset OUTPUT Dataset
     * @return The IGetDataResponse instance
     */
    METHOD PUBLIC Ccs.BusinessLogic.IGetDataResponse getData (poRequest AS Ccs.BusinessLogic.IGetDataRequest,
                                                              OUTPUT DATASET-HANDLE phDataset):

        IF NOT VALID-HANDLE (phDataset) THEN
            ASSIGN phDataset = DATASET dsMatches:HANDLE .

        RETURN THIS-OBJECT:getData (poRequest, OUTPUT DATASET-HANDLE phDataset BY-REFERENCE) .

    END METHOD.

    /**
     * Purpose: Performs a read request
     * Notes:
     * @param poRequest The IGetDataRequest instance with the getData request parameters
     * @param dsMatches OUTPUT Dataset
     * @return The IGetDataResponse instance
     */
    METHOD PUBLIC Ccs.BusinessLogic.IGetDataResponse getData (poRequest AS Ccs.BusinessLogic.IGetDataRequest,
                                                              OUTPUT DATASET dsMatches):

        DATASET dsMatches:EMPTY-DATASET () .

        THIS-OBJECT:OpenQuery (poRequest) .

        GET FIRST qMatches .

        DO WHILE NOT QUERY qMatches:QUERY-OFF-END:
            CREATE eMatches .
            BUFFER-COPY ttMatches TO eMatches .

            GET NEXT qMatches .
        END.

    END METHOD .

    /**
     *  Purpose: Returns an empty instance of the primary ProDataset to the caller
     *  Notes:   Used for catalog generation or initialization of dynamic user
     *           interfaces etc.
     *  @param phDataset OUTPUT Dataset (not intended to be called BY-REFERENCE)
     */
    METHOD PUBLIC VOID getDataset (OUTPUT DATASET-HANDLE phDataset):

        DATASET dsMatches:EMPTY-DATASET () .

        phDataset = DATASET dsMatches:HANDLE .

    END METHOD.

    /**
     * Purpose: Returns the count of the total number of result records or a guess
     *          of the result count to the caller
     * Notes:
     * @param poRequest The IGetDataRequest instance with the getResultCount request parameters
     * @return The IGetResultCountResponse instance
     */
    METHOD PUBLIC Ccs.BusinessLogic.IGetResultCountResponse getResultCount (poRequest AS Ccs.BusinessLogic.IGetDataRequest):


        THIS-OBJECT:OpenQuery (poRequest) .

        RETURN NEW GetResultCountResponse ("eMatches",
                                           QUERY qMatches:NUM-RESULTS,
                                           TRUE) .

    END METHOD.

    /**
     * Purpose: Initializes the Service
     * Notes:   Imports ttMatches.xml
     *
     */
    METHOD PUBLIC VOID initialize ():

        TEMP-TABLE ttMatches:READ-XML ("file", "Consultingwerk/CcsSamples/BusinessEntity/Euro2016/ttMatches.xml", ?, ?, ?) .

    END METHOD.

END CLASS.
