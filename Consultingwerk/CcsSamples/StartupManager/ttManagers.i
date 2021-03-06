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
    File        : ttManagers.i
    Purpose     : Temp-Table for manager definitions

    Syntax      :

    Description :

    Author(s)   :
    Created     : Tue Jun 21 13:41:21 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE TEMP-TABLE ttManagers NO-UNDO
    FIELD InitializationSequence AS INTEGER INIT ?
    FIELD ManagerType            AS CHARACTER
    FIELD ManagerImplementation  AS CHARACTER
    INDEX InitializationSequence IS PRIMARY UNIQUE InitializationSequence .
