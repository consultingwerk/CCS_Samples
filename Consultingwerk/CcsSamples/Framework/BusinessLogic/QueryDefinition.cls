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
    File        : QueryDefinition
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Jun 22 03:11:53 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

BLOCK-LEVEL ON ERROR UNDO, THROW.

USING Ccs.BusinessLogic.*                                 FROM PROPATH .
USING Consultingwerk.CcsSamples.Framework.BusinessLogic.* FROM PROPATH .
USING Progress.Lang.*                                     FROM PROPATH .

CLASS Consultingwerk.CcsSamples.Framework.BusinessLogic.QueryDefinition
    IMPLEMENTS IQueryDefinition:

    /*------------------------------------------------------------------------------
        Purpose: Returns the list of query predicates or query groups for this query
                 definition
        Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY QuerySelection AS IQueryEntry NO-UNDO
    GET.
    SET.

    /*------------------------------------------------------------------------------
        Purpose: Returns the list of query sort entries
        Notes:
    ------------------------------------------------------------------------------*/
    DEFINE PUBLIC PROPERTY QuerySort AS IQuerySortEntry EXTENT NO-UNDO
    GET.
    SET.

    /**
     * Purpose:
     * Notes:
     *
     */
    CONSTRUCTOR PUBLIC QueryDefinition():

    END CONSTRUCTOR.

    /**
     * Purpose:
     * Notes:
     *
     */
    CONSTRUCTOR PUBLIC QueryDefinition (poQueryEntry AS IQueryEntry,
                                        poQuerySort AS IQuerySortEntry EXTENT):

        ASSIGN THIS-OBJECT:QuerySelection = poQueryEntry
               THIS-OBJECT:QuerySort      = poQuerySort .

    END CONSTRUCTOR.

END CLASS.
