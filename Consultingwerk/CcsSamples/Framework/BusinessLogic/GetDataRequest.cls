/*------------------------------------------------------------------------
    File        : IGetDataRequest
    Purpose     : Inteface for the request object passed to the getData
                  method of the IBusinessEntity
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Sun May 22 19:58:18 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

USING Ccs.BusinessLogic.*                                 FROM PROPATH .
USING Consultingwerk.CcsSamples.Framework.BusinessLogic.* FROM PROPATH.
USING Progress.Lang.*                                     FROM PROPATH .

CLASS Consultingwerk.CcsSamples.Framework.BusinessLogic.GetDataRequest
    IMPLEMENTS IGetDataRequest:

    /*------------------------------------------------------------------------------
        Purpose: Returns the custom parameter object
        Notes:   May be used to provide further instructions or information to the
                 Business Entity while executing the GetData request
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY CustomParameter AS Progress.Lang.Object NO-UNDO
    GET.
    SET.

    /*------------------------------------------------------------------------------
        Purpose: Returns the Table requests
        Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY NamedQuery AS INamedQuery NO-UNDO
    GET.
    SET.

    /*------------------------------------------------------------------------------
        Purpose: Returns the Table requests
        Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY TableRequests AS IGetDataTableRequest EXTENT NO-UNDO
    GET.
    SET.


    /**
     * Purpose:
     * Notes:
     *
     */
    CONSTRUCTOR PUBLIC GetDataRequest():

    END CONSTRUCTOR.

    /**
     * Purpose:
     * Notes:
     *
     */
    CONSTRUCTOR PUBLIC GetDataRequest (poTableRequest1 AS IGetDataTableRequest):

        ASSIGN EXTENT (THIS-OBJECT:TableRequests) = 1

               THIS-OBJECT:TableRequests[1] = poTableRequest1 .

    END CONSTRUCTOR.

    /**
     * Purpose:
     * Notes:
     *
     */
    CONSTRUCTOR PUBLIC GetDataRequest (poTableRequest1 AS IGetDataTableRequest,
                                       poTableRequest2 AS IGetDataTableRequest):

        ASSIGN EXTENT (THIS-OBJECT:TableRequests) = 2

               THIS-OBJECT:TableRequests[1] = poTableRequest1
               THIS-OBJECT:TableRequests[2] = poTableRequest2
               .

    END CONSTRUCTOR.

    /**
     * Purpose:
     * Notes:
     *
     */
    CONSTRUCTOR PUBLIC GetDataRequest (poTableRequest1 AS IGetDataTableRequest,
                                       poTableRequest2 AS IGetDataTableRequest,
                                       poTableRequest3 AS IGetDataTableRequest):

        ASSIGN EXTENT (THIS-OBJECT:TableRequests) = 3

               THIS-OBJECT:TableRequests[1] = poTableRequest1
               THIS-OBJECT:TableRequests[2] = poTableRequest2
               THIS-OBJECT:TableRequests[3] = poTableRequest3
               .

    END CONSTRUCTOR.

    /**
     * Purpose:
     * Notes:
     *
     */
    CONSTRUCTOR PUBLIC GetDataRequest (pcTableName1 AS CHARACTER,
                                       pcQueryString1 AS CHARACTER):

        ASSIGN EXTENT (THIS-OBJECT:TableRequests) = 1

               THIS-OBJECT:TableRequests[1] = NEW GetDataTableRequest(pcTableName1, pcQueryString1) .

    END CONSTRUCTOR.

    /**
     * Purpose:
     * Notes:
     *
     */
    CONSTRUCTOR PUBLIC GetDataRequest (pcTableName1 AS CHARACTER,
                                       pcQueryString1 AS CHARACTER,
                                       pcTableName2 AS CHARACTER,
                                       pcQueryString2 AS CHARACTER):

        ASSIGN EXTENT (THIS-OBJECT:TableRequests) = 2

               THIS-OBJECT:TableRequests[1] = NEW GetDataTableRequest(pcTableName1, pcQueryString1)
               THIS-OBJECT:TableRequests[2] = NEW GetDataTableRequest(pcTableName2, pcQueryString2)
               .

    END CONSTRUCTOR.

    /**
     * Purpose:
     * Notes:
     *
     */
    CONSTRUCTOR PUBLIC GetDataRequest (pcTableName1 AS CHARACTER,
                                       pcQueryString1 AS CHARACTER,
                                       pcTableName2 AS CHARACTER,
                                       pcQueryString2 AS CHARACTER,
                                       pcTableName3 AS CHARACTER,
                                       pcQueryString3 AS CHARACTER):

        ASSIGN EXTENT (THIS-OBJECT:TableRequests) = 3

               THIS-OBJECT:TableRequests[1] = NEW GetDataTableRequest(pcTableName1, pcQueryString1)
               THIS-OBJECT:TableRequests[2] = NEW GetDataTableRequest(pcTableName2, pcQueryString2)
               THIS-OBJECT:TableRequests[3] = NEW GetDataTableRequest(pcTableName3, pcQueryString3)
               .

    END CONSTRUCTOR.


    /**
     * Purpose:
     * Notes:
     *
     */
    CONSTRUCTOR PUBLIC GetDataRequest (poNamedQuery AS INamedQuery):

        ASSIGN THIS-OBJECT:NamedQuery = poNamedQuery .

    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
        Purpose: Returns the IGetDataTableRequest by name
        Notes:
        @param poGetDataRequest The IGetDataRequest for the given temp-table
        @param pcTableName The name of the temp-table to return the request for
        @return The IGetDataTableRequest for the temp-table
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC STATIC IGetDataTableRequest GetDataTableRequestByName (poGetDataRequest AS IGetDataRequest,
                                                                         pcTempTableName AS CHARACTER):

        DEFINE VARIABLE i AS INTEGER NO-UNDO.

        DO i = 1 TO EXTENT (poGetDataRequest:TableRequests):

            IF poGetDataRequest:TableRequests[i]:TableName = pcTempTableName THEN
                RETURN poGetDataRequest:TableRequests[i] .

        END.

        RETURN ? .

    END METHOD.

END CLASS.
