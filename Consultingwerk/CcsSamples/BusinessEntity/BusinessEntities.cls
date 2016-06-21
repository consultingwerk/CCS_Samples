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
    File        : BusinessEntities
    Purpose     : Enumeration of Business Entity named
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Wed Jun 22 01:32:52 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/


USING Consultingwerk.CcsSamples.BusinessEntity.* FROM PROPATH .
USING Progress.Lang.*                            FROM PROPATH .

ENUM Consultingwerk.CcsSamples.BusinessEntity.BusinessEntities:

    DEFINE ENUM Customer
                Matches
        .

END ENUM .
