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
    File        : dsMatches.i
    Purpose     :

    Syntax      :

    Description :

    Author(s)   : Mike Fechner / Consultingwerk Ltd
    Created     : Tue Jun 21 21:22:56 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

/* ***************************  Definitions  ************************** */

DEFINE TEMP-TABLE eMatches NO-UNDO
    FIELD Order      AS INTEGER
    FIELD Location   AS CHARACTER
    FIELD Date       AS DATE
    FIELD Stage      AS CHARACTER
    FIELD HomeTeam   AS CHARACTER INIT ?
    FIELD GuestTeam  AS CHARACTER INIT ?
    FIELD HomeScore  AS INTEGER INIT ?
    FIELD GuestScore AS INTEGER INIT ?
    INDEX Order IS PRIMARY Order.

DEFINE DATASET dsMatches FOR eMatches .
