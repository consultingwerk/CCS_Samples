/*------------------------------------------------------------------------
  This Software is licensed by Progress Software Corporation (licensor)
  under the Progress Software Common Component Specification Project
  Release License Agreement available at
  https://community.progress.com/products/directions/common_component/p/releaselicenseagreement

  The Interface definition is part of the Common Component Specification [CCSBE01]. The
  file is considered as a Specification Implementation Condition as described
  in section 2.1.1.1: If Licensor has made Specification Implementation
  Conditions available as of the date Licensee completes its Independent
  Implementation, then Licensee must, prior to making any claim that its
  Independent Implementation complies with the Specification, ensure that
  the Independent Implementation satisfies all of the Specification
  Implementation Conditions. If Licensor subsequently makes available or
  updates, from time to time, the Specification Implementation Conditions,
  then Licensee will verify that its Independent Implementation satisfies the
  latest version of the Specification Implementation Conditions within ninety
  (90) days following Licensor's release thereof.

  Contributors:
    Mike Fechner, Consultingwerk [2016]
  ----------------------------------------------------------------------*/
/*------------------------------------------------------------------------
    File        : IGetResultCountResponse
    Purpose     : Interface for the response of the getResultCount method of the
                  IBusinessEntiy
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri May 27 09:35:55 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

USING Ccs.BusinessLogic.*                                 FROM PROPATH .
USING Consultingwerk.CcsSamples.Framework.BusinessLogic.* FROM PROPATH .
USING Progress.Lang.*                                     FROM PROPATH .

CLASS Consultingwerk.CcsSamples.Framework.BusinessLogic.GetResultCountResponse
    IMPLEMENTS IGetResultCountResponse:

    /*------------------------------------------------------------------------------
        Purpose: Returns the result counts per requested table
        Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY ResultCounts AS IGetTableResultCountResponse EXTENT NO-UNDO
    GET.
    SET.

    /*------------------------------------------------------------------------------
        Purpose: Constructor for the GetResultCountResponse class
        Notes:
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC GetResultCountResponse ():

    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
        Purpose: Constructor for the GetResultCountResponse class
        Notes:
        @param pcTableName1 The name of the table for the result
        @param piNumResults1 The number of result records
        @param plExact1 Is the result exact of guessed
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC GetResultCountResponse (pcTableName1 AS CHARACTER,
                                               piNumResults1 AS INT64,
                                               plExact1 AS LOGICAL):

        ASSIGN EXTENT (THIS-OBJECT:ResultCounts) = 1

               THIS-OBJECT:ResultCounts[1] = NEW GetTableResultCountResponse(pcTableName1, piNumResults1, plExact1)
              .

    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
        Purpose: Constructor for the GetResultCountResponse class
        Notes:
        @param pcTableName1 The name of the table for the result
        @param piNumResults1 The number of result records
        @param plExact1 Is the result exact of guessed
        @param pcTableName2 The name of the table for the result
        @param piNumResults2 The number of result records
        @param plExact2 Is the result exact of guessed
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC GetResultCountResponse (pcTableName1 AS CHARACTER,
                                               piNumResults1 AS INT64,
                                               plExact1 AS LOGICAL,
                                               pcTableName2 AS CHARACTER,
                                               piNumResults2 AS INT64,
                                               plExact2 AS LOGICAL):

        ASSIGN EXTENT (THIS-OBJECT:ResultCounts) = 2

               THIS-OBJECT:ResultCounts[1] = NEW GetTableResultCountResponse(pcTableName1, piNumResults1, plExact1)
               THIS-OBJECT:ResultCounts[2] = NEW GetTableResultCountResponse(pcTableName2, piNumResults2, plExact2)
               .

    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
        Purpose: Constructor for the GetResultCountResponse class
        Notes:
        @param pcTableName1 The name of the table for the result
        @param piNumResults1 The number of result records
        @param plExact1 Is the result exact of guessed
        @param pcTableName2 The name of the table for the result
        @param piNumResults2 The number of result records
        @param plExact2 Is the result exact of guessed
        @param pcTableName3 The name of the table for the result
        @param piNumResults3 The number of result records
        @param plExact3 Is the result exact of guessed
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC GetResultCountResponse (pcTableName1 AS CHARACTER,
                                               piNumResults1 AS INT64,
                                               plExact1 AS LOGICAL,
                                               pcTableName2 AS CHARACTER,
                                               piNumResults2 AS INT64,
                                               plExact2 AS LOGICAL,
                                               pcTableName3 AS CHARACTER,
                                               piNumResults3 AS INT64,
                                               plExact3 AS LOGICAL):

        ASSIGN EXTENT (THIS-OBJECT:ResultCounts) = 3

               THIS-OBJECT:ResultCounts[1] = NEW GetTableResultCountResponse(pcTableName1, piNumResults1, plExact1)
               THIS-OBJECT:ResultCounts[2] = NEW GetTableResultCountResponse(pcTableName2, piNumResults2, plExact2)
               THIS-OBJECT:ResultCounts[3] = NEW GetTableResultCountResponse(pcTableName3, piNumResults3, plExact3)
               .

    END CONSTRUCTOR.

END CLASS .
