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
    File        : ServiceManager
    Purpose     :
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Jun 21 13:46:15 CEST 2016
    Notes       :
  ----------------------------------------------------------------------*/

ROUTINE-LEVEL ON ERROR UNDO, THROW.

USING CCS.Common.*                               FROM PROPATH .
USING Consultingwerk.CcsSamples.ServiceManager.* FROM PROPATH .
USING Progress.Lang.*                            FROM PROPATH .

CLASS Consultingwerk.CcsSamples.ServiceManager.ServiceManager
    IMPLEMENTS IServiceManager:







    METHOD PUBLIC CCS.Common.IService getService( INPUT poServiceClass AS Progress.Lang.Class ):

        UNDO, THROW NEW Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

    END METHOD.

    METHOD PUBLIC CCS.Common.IService getService( INPUT poServiceClass AS Progress.Lang.Class, INPUT pcInstanceName AS CHARACTER ):

        UNDO, THROW NEW Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

    END METHOD.

    METHOD PUBLIC Progress.Lang.Class getServiceImplementation( INPUT poService AS Progress.Lang.Class ):

        UNDO, THROW NEW Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

    END METHOD.

    METHOD PUBLIC VOID initialize(  ):

    END METHOD.

    METHOD PUBLIC VOID stopService( INPUT pcServiceTypeName AS CHARACTER, INPUT pcInstanceName AS CHARACTER ):

        UNDO, THROW NEW Progress.Lang.AppError("METHOD NOT IMPLEMENTED").

    END METHOD.

END CLASS.
