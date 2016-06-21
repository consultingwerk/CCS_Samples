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
    File        : TeamEnum
    Purpose     : Enumeration of Teams in Euro 2016
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Jun 21 20:56:58 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

USING Consultingwerk.CcsSamples.CustomService.* FROM PROPATH .
USING Progress.Lang.*                           FROM PROPATH .

ENUM Consultingwerk.CcsSamples.CustomService.TeamEnum:

    DEFINE ENUM Albania             Austria
                Belgium             Croatia
                CzechRepublic       England
                France              Germany
                Hungary             Iceland
                Italy               NorthernIreland
                Poland              Portugal
                RepublicOfIreland   Romania
                Russia              Slovakia
                Spain               Sweden
                Switzerland         Turkey
                Ukraine             Wales
                .
END ENUM.
