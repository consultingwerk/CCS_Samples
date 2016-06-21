/**********************************************************************
 * Copyright (C) 2006-2012 by Consultingwerk Ltd. ("CW") -            *
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
    File        : ttServices.i
    Purpose     : Temp-Table for service definitions

    Syntax      :

    Description :

    Author(s)   :
    Created     : Tue Jun 21 13:41:21 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE TEMP-TABLE ttServices NO-UNDO
    FIELD ServiceType           AS CHARACTER
    FIELD InstanceName          AS CHARACTER
    FIELD ServiceImplementation AS CHARACTER
    INDEX ServiceTypeInstanceName IS PRIMARY UNIQUE ServiceType InstanceName .
