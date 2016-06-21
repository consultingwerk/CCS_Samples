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
    File        : INamedQuery
    Purpose     : Interface for parameters describing named queries
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Fri May 27 10:03:02 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

USING Ccs.Common.Support.*                                FROM PROPATH .
USING Ccs.BusinessLogic.*                                 FROM PROPATH .
USING Consultingwerk.CcsSamples.Framework.BusinessLogic.* FROM PROPATH .
USING Progress.Lang.*                                     FROM PROPATH .

CLASS Consultingwerk.CcsSamples.Framework.BusinessLogic.NamedQuery
    IMPLEMENTS INamedQuery:

    /*------------------------------------------------------------------------------
        Purpose: Returns the name of the named query
        Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY Name AS CHARACTER NO-UNDO
    GET.
    SET.

    /*------------------------------------------------------------------------------
        Purpose: Returns the array of (optional) parameters of the named query
        Notes:   Each Named Query Parameter consists of an identifier (name) and a value
                 (primitive holder) or values (primitive array holder)
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY Parameters AS INamedQueryParameter EXTENT NO-UNDO
    GET.
    SET.

    /*------------------------------------------------------------------------------
        Purpose: Constructor of the NamedQuery class
        Notes:
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC NamedQuery ():
    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
        Purpose: Constructor of the NamedQuery class
        Notes:
        @param pcName The Name of the Named Query
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC NamedQuery (pcName AS CHARACTER):

        THIS-OBJECT:Name = pcName .

    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
        Purpose: Constructor of the NamedQuery class
        Notes:
        @param pcName The Name of the Named Query
        @param pcParameterName1 The name of the Named Query Parameter
        @param poParameterValue1 The value of the Named Query Parameter
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC NamedQuery (pcName AS CHARACTER,
                                   pcParameterName1 AS CHARACTER,
                                   poParameterValue1 AS IPrimitiveHolder):

        THIS-OBJECT:Name = pcName .

        EXTENT (THIS-OBJECT:Parameters) = 1 .

        THIS-OBJECT:Parameters[1] = NEW NamedQueryParameter (pcParameterName1, poParameterValue1) .

    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
        Purpose: Constructor of the NamedQuery class
        Notes:
        @param pcName The Name of the Named Query
        @param pcParameterName1 The name of the Named Query Parameter
        @param poParameterValue1 The value of the Named Query Parameter
        @param pcParameterName2 The name of the Named Query Parameter
        @param poParameterValue2 The value of the Named Query Parameter
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC NamedQuery (pcName AS CHARACTER,
                                   pcParameterName1 AS CHARACTER,
                                   poParameterValue1 AS IPrimitiveHolder,
                                   pcParameterName2 AS CHARACTER,
                                   poParameterValue2 AS IPrimitiveHolder):

        THIS-OBJECT:Name = pcName .

        EXTENT (THIS-OBJECT:Parameters) = 2 .

        THIS-OBJECT:Parameters[1] = NEW NamedQueryParameter (pcParameterName1, poParameterValue1) .
        THIS-OBJECT:Parameters[2] = NEW NamedQueryParameter (pcParameterName2, poParameterValue2) .

    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
        Purpose: Constructor of the NamedQuery class
        Notes:
        @param pcName The Name of the Named Query
        @param pcParameterName1 The name of the Named Query Parameter
        @param poParameterValue1 The value of the Named Query Parameter
        @param pcParameterName2 The name of the Named Query Parameter
        @param poParameterValue2 The value of the Named Query Parameter
        @param pcParameterName3 The name of the Named Query Parameter
        @param poParameterValue3 The value of the Named Query Parameter
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC NamedQuery (pcName AS CHARACTER,
                                   pcParameterName1 AS CHARACTER,
                                   poParameterValue1 AS IPrimitiveHolder,
                                   pcParameterName2 AS CHARACTER,
                                   poParameterValue2 AS IPrimitiveHolder,
                                   pcParameterName3 AS CHARACTER,
                                   poParameterValue3 AS IPrimitiveHolder):

        THIS-OBJECT:Name = pcName .

        EXTENT (THIS-OBJECT:Parameters) = 1 .

        THIS-OBJECT:Parameters[1] = NEW NamedQueryParameter (pcParameterName1, poParameterValue1) .
        THIS-OBJECT:Parameters[2] = NEW NamedQueryParameter (pcParameterName2, poParameterValue2) .
        THIS-OBJECT:Parameters[3] = NEW NamedQueryParameter (pcParameterName3, poParameterValue3) .

    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
        Purpose: Returns the Named Query Parameter Value by name
        Notes:
        @param pcParameterName The name of the named query parameter to return
        @return The IPrimitiveHolder representing the value
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC STATIC IPrimitiveHolder ParameterValueByName (poNamedQuery AS INamedQuery,
                                                                pcParameterName AS CHARACTER):

        DEFINE VARIABLE i AS INTEGER NO-UNDO.

        DO i = 1 TO EXTENT (poNamedQuery:Parameters):

            IF poNamedQuery:Parameters[i]:Name = pcParameterName THEN
                RETURN poNamedQuery:Parameters[i]:Value .

        END.

        UNDO, THROW NEW AppError (SUBSTITUTE ("Invalid named query parameter: &1", pcParameterName), 0) .

    END METHOD.

    /*------------------------------------------------------------------------------
        Purpose: Returns the Named Query Parameter Values by name
        Notes:
        @param pcParameterName The name of the named query parameter to return
        @return The IPrimitiveHolder representing the values
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC STATIC IPrimitiveArrayHolder ParameterValuesByName (poNamedQuery AS INamedQuery,
                                                                      pcParameterName AS CHARACTER):

        DEFINE VARIABLE i AS INTEGER NO-UNDO.

        DO i = 1 TO EXTENT (poNamedQuery:Parameters):

            IF poNamedQuery:Parameters[i]:Name = pcParameterName THEN
                RETURN poNamedQuery:Parameters[i]:Values .

        END.

        UNDO, THROW NEW AppError (SUBSTITUTE ("Invalid named query parameter: &1", pcParameterName), 0) .

    END METHOD.

END CLASS .
