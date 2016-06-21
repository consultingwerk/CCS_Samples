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
    Purpose     : Sample CCS IServiceManaager implementation
    Syntax      :
    Description :
    Author(s)   : Mike Fechner / Consultingwerk Ltd.
    Created     : Tue Jun 21 13:46:15 CEST 2016
    Notes       : Configured from services.xml in the application working
                  directory or an services=<file name> entry in the -param
                  startup parameter
  ----------------------------------------------------------------------*/

ROUTINE-LEVEL ON ERROR UNDO, THROW.

USING CCS.Common.*                               FROM PROPATH .
USING Consultingwerk.CcsSamples.ServiceManager.* FROM PROPATH .
USING Progress.Lang.*                            FROM PROPATH .
USING Progress.Reflect.*                         FROM PROPATH .

CLASS Consultingwerk.CcsSamples.ServiceManager.ServiceManager
    IMPLEMENTS IServiceManager:

    {Consultingwerk/CcsSamples/ServiceManager/ttServices.i}

    DEFINE TEMP-TABLE ttServiceInstances NO-UNDO
        FIELD ServiceType           AS Progress.Lang.Object
        FIELD InstanceName          AS CHARACTER
        FIELD ServiceImplementation AS Progress.Lang.Object
        INDEX ServiceTypeInstanceName IS PRIMARY UNIQUE ServiceType InstanceName .

    /**
     * Purpose: Default constructor for the Startup Manager
     * Notes:
     *
     */
    CONSTRUCTOR PUBLIC ServiceManager():
        /* noop */
    END CONSTRUCTOR.

    /**
     * Purpose: Returns the service with the given type name
     * Notes:
     * @param poServiceClass The type (Interface) of the service to shut down
     */
    METHOD PUBLIC CCS.Common.IService getService (poServiceClass AS Progress.Lang.Class):

        RETURN THIS-OBJECT:getService(poServiceClass, "":U) .

    END METHOD.

    /**
     * Purpose: Returns the service with the given type name and instance name
     * Notes:   Typically used for Business Entities
     * @param poServiceClass The type (Interface) of the service to shut down
     * @param pcInstanceName The name of the instance to shut down (may be "")
     */
    METHOD PUBLIC CCS.Common.IService getService (poServiceClass AS Progress.Lang.Class,
                                                  pcInstanceName AS CHARACTER):

        DEFINE VARIABLE oInstanceType AS Progress.Lang.Class  NO-UNDO .
        DEFINE VARIABLE oInstance     AS Progress.Lang.Object NO-UNDO .
        DEFINE VARIABLE oError        AS AppError             NO-UNDO .

        DEFINE BUFFER ttServices FOR ttServices .
        DEFINE BUFFER ttServiceInstances FOR ttServiceInstances .

        // treat ? like empty string - as empty string will cause uniqueness in ttServiceInstances
        IF pcInstanceName = ? THEN
            ASSIGN pcInstanceName = "":U .

        // existing instance?
        IF CAN-FIND (ttServiceInstances WHERE ttServiceInstances.ServiceType  = poServiceClass
                                          AND ttServiceInstances.InstanceName = pcInstanceName) THEN DO:

            FIND ttServiceInstances WHERE ttServiceInstances.ServiceType  = poServiceClass
                                      AND ttServiceInstances.InstanceName = pcInstanceName .

            RETURN CAST (ttServiceInstances.ServiceImplementation, IService) .
        END .

        DO ON ERROR UNDO, THROW:
            // Find ttServices record for this request
            IF pcInstanceName = "":U THEN DO:
                IF NOT CAN-FIND (FIRST ttServices WHERE (ttServices.ServiceType  = poServiceClass:TypeName
                                                    AND  ttServices.InstanceName = "") OR
                                                        (ttServices.ServiceType  = poServiceClass:TypeName
                                                    AND  ttServices.InstanceName = ?)) THEN
                    UNDO, THROW NEW AppError (SUBSTITUTE ("No service definition for &1",
                                                          poServiceClass:TypeName),
                                              0) .

                FIND ttServices WHERE ttServices.ServiceType  = poServiceClass:TypeName
                                  AND ttServices.InstanceName = "" NO-ERROR .

                IF NOT AVAILABLE ttServices THEN
                    FIND ttServices WHERE ttServices.ServiceType  = poServiceClass:TypeName
                                      AND ttServices.InstanceName = ? NO-ERROR .

                ASSIGN oInstanceType = Progress.Lang.Class:GetClass (ttServices.ServiceImplementation) .
            END.
            ELSE DO:
                IF NOT CAN-FIND (ttServices WHERE ttServices.ServiceType  = poServiceClass:TypeName
                                              AND ttServices.InstanceName = pcInstanceName) THEN
                    UNDO, THROW NEW AppError (SUBSTITUTE ("No service definition for &1, instance name &2",
                                                          poServiceClass:TypeName,
                                                          pcInstanceName),
                                              0) .

                FIND ttServices WHERE ttServices.ServiceType  = poServiceClass:TypeName
                                  AND ttServices.InstanceName = pcInstanceName NO-ERROR .

                ASSIGN oInstanceType = Progress.Lang.Class:GetClass (ttServices.ServiceImplementation) .
            END.

            oInstance     = oInstanceType:GetConstructor (Flags:Public,
                                                          NEW ParameterList (0)):Invoke (NEW ParameterList (0)) .

            CATCH err AS Progress.Lang.SysError:
                oError = NEW AppError () .

                IF pcInstanceName > "":U THEN
                    oError:AddMessage (SUBSTITUTE ("Unable to create service for &1, instance name &2",
                                                   ttServices.ServiceImplementation,
                                                   pcInstanceName), 0) .
                ELSE
                    oError:AddMessage (SUBSTITUTE ("Unable to create service for &1",
                                       ttServices.ServiceImplementation), 0) .

                oError:AddMessage(err:GetMessage(1), err:GetMessageNum(1)) .

                UNDO, THROW oError .
            END CATCH.
        END.

        IF NOT TYPE-OF (oInstance, IService) THEN
            UNDO, THROW NEW AppError (SUBSTITUTE ("&1 is not an IService", oInstanceType:TypeName), 0) .

        CREATE ttServiceInstances.
        ASSIGN ttServiceInstances.ServiceType           = poServiceClass
               ttServiceInstances.InstanceName          = pcInstanceName
               ttServiceInstances.ServiceImplementation = oInstance .

        RELEASE ttServiceInstances .

        CAST (oInstance, IService):initialize() .

        RETURN CAST (oInstance, IService) .

    END METHOD.

    /**
     * Purpose: Initializes the Service
     * Notes:   Imports services.xml config file
     *
     */
    METHOD PUBLIC VOID initialize ():

        DEFINE VARIABLE cServicesFile AS CHARACTER NO-UNDO INIT "services.xml":U.
        DEFINE VARIABLE i             AS INTEGER   NO-UNDO.
        DEFINE VARIABLE iCount        AS INTEGER   NO-UNDO.

        /* Do we have a services= entry in -param */
        ASSIGN iCount = NUM-ENTRIES (SESSION:PARAM) .

        paramLoop:
        DO i = 1 TO iCount:
            IF ENTRY (i, SESSION:PARAM) BEGINS "services=":U THEN DO:
                ASSIGN cServicesFile = ENTRY (2, ENTRY (i, SESSION:PARAMETER), "=":U) .
                LEAVE paramLoop .
            END.
        END.

        FILE-INFO:FILE-NAME = cServicesFile .

        IF FILE-INFO:FULL-PATHNAME = ? THEN
            UNDO, THROW NEW AppError (SUBSTITUTE ("Invalid services definition: &1", cServicesFile), 0) .

        TEMP-TABLE ttServices:READ-XML ("file":U, FILE-INFO:FULL-PATHNAME, ?, ?, ?) .

    END METHOD.

    /**
     * Purpose: Shuts down the given service
     * Notes:
     * @param poServiceClass The type (Interface) of the service to shut down
     * @param pcInstanceName The name of the instance to shut down (may be "")
     */
    METHOD PUBLIC VOID stopService (poServiceClass AS Progress.Lang.Class,
                                    pcInstanceName AS CHARACTER):

        DEFINE BUFFER ttServiceInstances FOR ttServiceInstances .

        // treat ? like empty string - as empty string will cause uniqueness in ttServiceInstances
        IF pcInstanceName = ? THEN
            ASSIGN pcInstanceName = "":U .

        // existing instance?
        IF CAN-FIND (ttServiceInstances WHERE ttServiceInstances.ServiceType  = poServiceClass
                                          AND ttServiceInstances.InstanceName = pcInstanceName) THEN DO:

            FIND ttServiceInstances WHERE ttServiceInstances.ServiceType  = poServiceClass
                                      AND ttServiceInstances.InstanceName = pcInstanceName .

            IF VALID-OBJECT (ttServiceInstances.ServiceImplementation) THEN
                DELETE OBJECT ttServiceInstances.ServiceImplementation .

            DELETE ttServiceInstances .
        END .
        ELSE
            UNDO, THROW NEW AppError (SUBSTITUTE ("Service &1 is not running.", poServiceClass:TypeName), 0) .

    END METHOD.

END CLASS.
