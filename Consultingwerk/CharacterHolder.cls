/**********************************************************************
 * Copyright (C) 2006-2013 by Consultingwerk Ltd. ("CW") -            *
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
    File        : CharacterHolder
    Purpose     : A holder class for ABL primitive values
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Oct 10 01:15:43 CEST 2012
    Notes       :
  ----------------------------------------------------------------------*/

ROUTINE-LEVEL ON ERROR UNDO, THROW.

{Consultingwerk/products.i}

USING Consultingwerk.*     FROM PROPATH .
USING Ccs.Common.Support.* FROM PROPATH .
USING Progress.Lang.*      FROM PROPATH .

CLASS Consultingwerk.CharacterHolder
    IMPLEMENTS IPrimitiveHolder, ICharacterHolder
    SERIALIZABLE:

    /*------------------------------------------------------------------------------
        Purpose: Returns a the value of the CharacterHolder instance
        Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY Value AS CHARACTER NO-UNDO
    GET.
    SET.

    /*------------------------------------------------------------------------------
        Purpose: Returns a holder for the CHARACTER unknown value
        Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC STATIC PROPERTY Empty AS CharacterHolder NO-UNDO
    GET:
        RETURN NEW CharacterHolder ("":U) .
    END GET .

    /*------------------------------------------------------------------------------
        Purpose: Returns a holder for the CHARACTER unknown value
        Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC STATIC PROPERTY UnknownValue AS CharacterHolder NO-UNDO
    GET:
        RETURN NEW CharacterHolder (?) .
    END GET .

    /*------------------------------------------------------------------------------
        Purpose: Constructor for the CharacterHolder class
        Notes:
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC CharacterHolder ():
        SUPER ().

    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
        Purpose: Constructor for the CharacterHolder class
        Notes:
        @param pcValue The initial Value
    ------------------------------------------------------------------------------*/
    CONSTRUCTOR PUBLIC CharacterHolder (pcValue AS CHARACTER):

        THIS-OBJECT () .

        THIS-OBJECT:Value = pcValue .

    END CONSTRUCTOR.

    /*------------------------------------------------------------------------------
        Purpose: Returns the Value of the Holder instance
        Notes:   Unquoted value
        @return The value as a CHARACTER
    ------------------------------------------------------------------------------*/
    METHOD PUBLIC CHARACTER GetValue ():

        RETURN THIS-OBJECT:Value .

    END METHOD .

    /*------------------------------------------------------------------------------
        Purpose: Returns a Character representation of the value
        Notes:
        @return The Character representation of the value
    ------------------------------------------------------------------------------*/
    METHOD OVERRIDE PUBLIC CHARACTER ToString ():

        RETURN SUBSTITUTE ("CharacterHolder (&1)":U, THIS-OBJECT:Value) .

    END METHOD .

END CLASS.
